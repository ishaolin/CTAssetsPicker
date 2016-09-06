//
//  CTAssetsGroupViewController.m
//  CTAssetsPicker
//
//  Created by wshaolin on 15/7/9.
//  Copyright © 2016年 wshaolin. All rights reserved.
//

#import "CTAssetsGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "CTAssetsViewController.h"
#import "CTAssetsPickerController.h"
#import "CTAssetsGroupTableViewCell.h"

@interface CTAssetsGroupViewController ()<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray<ALAssetsGroup *> *_assetsGroups;
    ALAssetsLibrary *_assetsLibrary;
    UILabel *_noDataLabel;
    UIView *_noDataView;
    
    CTAssetsViewController *_currentAssetsViewController;
    __weak CTAssetsPickerController *_assetsPickerController;
}

@end

@implementation CTAssetsGroupViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.title = NSLocalizedString(@"相簿", nil);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didClickCancelBarButtonItem:)];
    
    _assetsGroups = [NSMutableArray array];
    _assetsLibrary = [[ALAssetsLibrary alloc] init];
    _assetsPickerController = (CTAssetsPickerController *)self.navigationController;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    _noDataLabel = [[UILabel alloc] init];
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    _noDataLabel.textColor = [UIColor lightGrayColor];
    _noDataLabel.font = [UIFont systemFontOfSize:18.0];
    _noDataLabel.numberOfLines = 0;
    switch (_assetsPickerController.assetsType) {
        case CTAssetsPickerControllerAssetsTypePhoto:{
            _noDataLabel.text = NSLocalizedString(@"暂无照片", nil);
        }
            break;
        case CTAssetsPickerControllerAssetsTypeVideo:{
            _noDataLabel.text = NSLocalizedString(@"暂无视频", nil);
        }
            break;
        case CTAssetsPickerControllerAssetsTypeAllAsset:{
            _noDataLabel.text = NSLocalizedString(@"暂无内容", nil);
        }
            break;
        default:
            break;
    }
    
    CGFloat noDataLabel_X = 20.0;
    CGFloat noDataLabel_H = 200.0;
    CGFloat noDataLabel_W = self.view.bounds.size.width - noDataLabel_X * 2;
    CGFloat noDataLabel_Y = (self.view.bounds.size.height - noDataLabel_H) * 0.5;
    _noDataLabel.frame = CGRectMake(noDataLabel_X, noDataLabel_Y, noDataLabel_W, noDataLabel_H);
    
    _noDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    _noDataView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _noDataView.backgroundColor = self.view.backgroundColor;
    _noDataView.hidden = YES;
    [_noDataView addSubview:_noDataLabel];
    [self.view addSubview:_noDataView];
    
    [self loadAssetsGroups];
}

- (void)didClickCancelBarButtonItem:(UIBarButtonItem *)barButtonItem{
    if(_assetsPickerController.delegate && [_assetsPickerController.delegate respondsToSelector:@selector(assetsPickerControllerDidCancel:)]){
        [_assetsPickerController.delegate assetsPickerControllerDidCancel:_assetsPickerController];
    }
    
    [_assetsPickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)loadAssetsGroups{
    ALAssetsLibraryGroupsEnumerationResultsBlock assetsLibraryGroupsEnumerationResultsBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil){
            [group setAssetsFilter:_assetsPickerController.assetsFilter];
            if (group.numberOfAssets > 0 || _assetsPickerController.isShowEmptyGroups){
                [_assetsGroups addObject:group];
                
                if(group.numberOfAssets > 0 && _currentAssetsViewController == nil){
                    _currentAssetsViewController = [[CTAssetsViewController alloc] init];
                    [_currentAssetsViewController setAssetsGroup:group];
                    _currentAssetsViewController.toolbarItemBackgroundColor = self.toolbarItemBackgroundColor;
                    _currentAssetsViewController.toolbarItemFontColor = self.toolbarItemFontColor;
                    [self.navigationController pushViewController:_currentAssetsViewController animated:NO];
                }
            }
        }else{
            *stop = YES;
            [self reloadData];
        }
    };
    
    ALAssetsLibraryAccessFailureBlock assetsLibraryAccessFailureBlock = ^(NSError *error) {
        if(error.code == ALAssetsLibraryAccessUserDeniedError || error.code == ALAssetsLibraryAccessGloballyDeniedError){
            NSString *bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            if(bundleDisplayName == nil || bundleDisplayName.length == 0){
                bundleDisplayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            }
            NSString *errorMessage = NSLocalizedString(@"您目前拒绝应用\"%@\"访问相册，请在\"设置\"->\"隐私\"->\"照片\"中找到应用\"%@\"，打开相册访问权限.", nil);
            _noDataLabel.text = [NSString stringWithFormat:errorMessage, bundleDisplayName, bundleDisplayName];
        }
        [self reloadData];
    };
    
    [_assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsLibraryGroupsEnumerationResultsBlock failureBlock:assetsLibraryAccessFailureBlock];
    NSUInteger types = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream;
    [_assetsLibrary enumerateGroupsWithTypes:types usingBlock:assetsLibraryGroupsEnumerationResultsBlock failureBlock:assetsLibraryAccessFailureBlock];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTAssetsGroupTableViewCell *groupViewCell = [CTAssetsGroupTableViewCell groupViewCellWithTableView:tableView];
    groupViewCell.firstRowInSection = indexPath.row == 0;
    groupViewCell.lastRowInSection = indexPath.row == _assetsGroups.count - 1;
    groupViewCell.assetsGroup = _assetsGroups[indexPath.row];
    return groupViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentAssetsViewController = [[CTAssetsViewController alloc] init];
    _currentAssetsViewController.assetsGroup = _assetsGroups[indexPath.row];
    _currentAssetsViewController.toolbarItemBackgroundColor = self.toolbarItemBackgroundColor;
    _currentAssetsViewController.toolbarItemFontColor = self.toolbarItemFontColor;
    [self.navigationController pushViewController:_currentAssetsViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0;
}

- (NSArray<ALAsset *> *)selectedAssets{
    return _currentAssetsViewController.selectedAssets;
}

- (void)deselectAssetAtIndex:(NSUInteger)index{
    [_currentAssetsViewController deselectAssetAtIndex:index];
}

- (void)reloadData{
    _tableView.hidden = _assetsGroups.count == 0;
    _noDataView.hidden = _assetsGroups.count > 0;
    
    if(_assetsGroups.count > 0){
        [_tableView reloadData];
    }
}

@end
