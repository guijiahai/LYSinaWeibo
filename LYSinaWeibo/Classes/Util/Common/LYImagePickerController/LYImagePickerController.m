//
//  LYImagePickerController.m
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/5.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYImagePickerController.h"
#import "LYAssetCell.h"
#import "LYAssetModel.h"
#import "LYAlbumView.h"
#import "LYNavigationTitleView.h"

@interface LYPhotoPickerController : UIViewController

@end

@interface LYImagePickerController ()

@property (nonatomic, assign) NSUInteger maxChooseCount;

@end

@implementation LYImagePickerController

- (instancetype)init {
    return [self initWithMaxChooseCount:9 pickerDelegate:nil];
}

- (instancetype)initWithMaxChooseCount:(NSUInteger)maxChooseCount pickerDelegate:(id<LYImagePickerControllerDelegate>)pickerDelegate {
    
    LYPhotoPickerController *picker = [[LYPhotoPickerController alloc] init];
    if (self = [super initWithRootViewController:picker]) {
        self.navigationBar.translucent = NO;
        
        self.maxChooseCount = maxChooseCount == 0 ? NSUIntegerMax : maxChooseCount;
        self.pickerDelegate = pickerDelegate;
        
        self.sortAscendingByModificationDate = NO;
        self.allowPickingOrignalPhoto = YES;
        self.allowTakingPicture = YES;
        self.orignalPhotos = NO;
    }
    return self;
}

@end

///-------------------------------

@interface LYPhotoPickerController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LYNavigationTitleViewDelegate>

@property (nonatomic, strong) LYNavigationTitleView *titleView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LYAlbumView *albumView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *previewButton, *originalButton;

@property (nonatomic, strong) NSArray<LYAlbumModel *> *albumModels;
@property (nonatomic, assign) NSInteger currentAlbumIndex;

@property (nonatomic, readonly) LYImagePickerController *navigation;
@property (nonatomic, strong) NSTimer *authTimer;

@property (nonatomic, strong) NSMutableArray<LYAssetModel *> *selectedAssetModels;

@end

@implementation LYPhotoPickerController

- (LYImagePickerController *)navigation {
    return (LYImagePickerController *)self.navigationController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentAlbumIndex = -1;
    self.selectedAssetModels = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem defaultNormalItemWithTitle:@"取消" target:self action:@selector(cancel)];
    
    [self authentication];
}

- (void)setupUI {
    dispatch_async_inMain(^{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem composeItemWithTitle:@"下一步" target:self action:@selector(next:)];
        
        self.titleView = [[LYNavigationTitleView alloc] init];
        self.titleView.delegate = self;
        self.navigationItem.titleView = self.titleView;
        
        [self.view addSubview:self.collectionView];
        [self.view addSubview:self.toolBar];
        [self.toolBar addSubview:self.previewButton];
        
        if (self.navigation.allowPickingOrignalPhoto) {
            [self originalButton];
        }
        
        [self getAlbum];
    });
}

- (void)authentication {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusDenied) {
                [self.navigation dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self setupUI];
            }
        }];
        
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted) {
        
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:@"对不起，因权限受限，%@无法访问您的手机相册", appName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigation dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:@"请在%@的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", [UIDevice currentDevice].model, appName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigation dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self setupUI];
    }
}

- (void)observeAuthrizationStatusChange {
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusNotDetermined) {
        [_authTimer invalidate];
        _authTimer = nil;
        if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
            [self setupUI];
        } else {
            [self.navigation dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)refreshTitleView {
    self.titleView.title = self.albumModels[self.currentAlbumIndex].title;
    self.titleView.selected = NO;
}

- (void)getAlbum {
    
    self.currentAlbumIndex = -1;
    
//    NSArray *selectedAssets = [self.navigation selectedAssets];
    
    self.albumModels = [LYImageManager fetchAlbumModels];

    
    if (self.navigation.selectedAssets && self.navigation.selectedAssets.count > 0) {
        
        NSMutableArray *selectedAssets = [NSMutableArray arrayWithArray:self.navigation.selectedAssets];
        
        for (LYAlbumModel *album in self.albumModels) {
            for (PHAsset *asset in selectedAssets.reverseObjectEnumerator) {
                for (LYAssetModel *assetModel in album.assetModels) {
                    if ([asset.localIdentifier isEqualToString:assetModel.asset.localIdentifier]) {
                        assetModel.selected = YES;
                        [self.selectedAssetModels addObject:assetModel];
                        [selectedAssets removeObject:asset];
                        break;
                    }
                }
            }

        }
    }
    for (LYAlbumModel *album in self.albumModels) {
        if ([album.assetCollection.localizedTitle isEqualToString:@"Camera Roll"]) {
            self.currentAlbumIndex = [self.albumModels indexOfObject:album];
        }
    }
   
    if (self.currentAlbumIndex < 0 && self.albumModels.count > 0) {
        self.currentAlbumIndex = 0;
    }
    [self refreshTitleView];
    
    if (self.navigation.isOrignalPhotos && self.navigation.allowPickingOrignalPhoto) {
        [self orignalButtonClicked:self.originalButton];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        bounds.size.height -= 64.0 + 44.0;
        bounds.origin.x = 0.0;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = [LYAssetCCell ccellSize];
        layout.minimumLineSpacing = 4.0;
        layout.minimumInteritemSpacing = 0.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:bounds collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[LYAssetCCell class] forCellWithReuseIdentifier:kCCellIdentifier_Asset];
        [_collectionView registerClass:[LYAssetCameraCCell class] forCellWithReuseIdentifier:kCCellIdentifier_AssetCamera];
    }
    return _collectionView;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        CGRect bounds = [UIScreen mainScreen].bounds;
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, bounds.size.height - 64.0 - 44.0, bounds.size.width, 44)];
        _toolBar.backgroundColor = [UIColor whiteColor];

        UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_horizontal_separator"]];
        [_toolBar addSubview:line];
        line.frame = CGRectMake(0, 0, bounds.size.width, 1);
    }
    return _toolBar;
}

- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previewButton.frame = CGRectMake(10, 7, 54, 30);
        [_previewButton setBackgroundImage:[UIImage imageNamed:@"compose_photo_preview_seleted"] forState:UIControlStateNormal];
        [_previewButton setBackgroundImage:[UIImage imageNamed:@"compose_photo_preview_highlighted"] forState:UIControlStateHighlighted];
        [_previewButton setBackgroundImage:[UIImage imageNamed:@"compose_photo_preview_disable"] forState:UIControlStateDisabled];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor colorWithWhite:102.0/255 alpha:1] forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(previewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _previewButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _previewButton;
}

- (UIButton *)originalButton {
    if (!_originalButton) {
        _originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_originalButton setBackgroundImage:[[UIImage imageNamed:@"compose_photo_original"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)] forState:UIControlStateNormal];
        [_originalButton setBackgroundImage:[[UIImage imageNamed:@"compose_photo_original_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 30, 0, 30)] forState:UIControlStateSelected];
        [_originalButton setTitle:@"原图" forState:UIControlStateNormal];
        [_originalButton setTitleColor:[UIColor colorWithWhite:102.0/255 alpha:1] forState:UIControlStateNormal];
        _originalButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _originalButton.contentEdgeInsets = UIEdgeInsetsMake(0, 23, 0, 10);
        [_originalButton addTarget:self action:@selector(orignalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolBar addSubview:_originalButton];
        
        [_originalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolBar).offset(80);
            make.centerY.equalTo(self.toolBar);
            make.height.mas_equalTo(30);
        }];
//        
//        _originalButton.selected = self.navigation.isOrignalPhotos;
    }
    return _originalButton;
}

#pragma mark - collection view methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.currentAlbumIndex < 0) {
        return 0;
    }
    return self.albumModels[self.currentAlbumIndex].assetModels.count + (self.navigation.allowTakingPicture ? 1 : 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item == 0 && self.navigation.allowTakingPicture) {
        
        LYAssetCameraCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_AssetCamera forIndexPath:indexPath];
        return cell;
        
    } else {
        
        LYAssetCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_Asset forIndexPath:indexPath];
        [cell setAssetModel:[self assetModelWithIndexPath:indexPath]];
        __weak typeof(self) weakSelf = self;
        cell.didSelectPhotoHandler = ^(LYAssetCCell *ccell) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf didSelectPhotoWithAssetCCell:ccell];
        };
        return cell;
    }
}

#pragma mark - action

- (void)didSelectPhotoWithAssetCCell:(LYAssetCCell *)ccell {
    
    BOOL selected = ccell.assetModel.isSelected;

    if (!selected && self.selectedAssetModels.count >= self.navigation.maxChooseCount) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多选择%ld张照片", self.navigation.maxChooseCount]];
        return;
    }
    
    LYAssetModel *asset = ccell.assetModel;
    if (!asset) {
        return;
    }
    
    asset.selected = !selected;
    if (selected) {
        [self.selectedAssetModels removeObject:asset];
    } else {
        if (![self.selectedAssetModels containsObject:asset]) {
            [self.selectedAssetModels addObject:asset];
        }
    }
  
    ccell.selectButton.selected = !selected;
    ccell.showMaskView = !selected;
    
    if (self.navigation.isOrignalPhotos && self.navigation.allowPickingOrignalPhoto) {
        [self calculatePhotosBytesWithBlock:^(NSString *totalBytes) {
            NSString *title = [NSString stringWithFormat:@"原图(%@)", totalBytes];
            if (self.navigation.isOrignalPhotos) {
                [self.originalButton setTitle:title forState:UIControlStateSelected];
            }
        }];
    }
    
    self.navigationItem.rightBarButtonItem.enabled = self.selectedAssetModels.count > 0;
    NSString *title = self.selectedAssetModels.count > 0 ? [NSString stringWithFormat:@"下一步(%ld)", self.selectedAssetModels.count] : @"下一步";
    [self.navigationItem.rightBarButtonItem setButtonTitle:title];
}

- (void)previewButtonClicked:(UIButton *)sender {
    
}

- (void)orignalButtonClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.navigation.orignalPhotos = sender.selected;
    if (self.navigation.orignalPhotos) {
        [self calculatePhotosBytesWithBlock:^(NSString *totalBytes) {
            NSString *title = [NSString stringWithFormat:@"原图(%@)", totalBytes];
            if (self.navigation.orignalPhotos) {
                [self.originalButton setTitle:title forState:UIControlStateSelected];
                [self.originalButton sizeToFit];
            }
        }];
    }
}

- (LYAssetModel *)assetModelWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger index;
    if ([self.navigation sortAscendingByModificationDate]) {
        index = indexPath.item - (self.navigation.allowTakingPicture ? 1 : 0);
    } else {
        index = self.albumModels[self.currentAlbumIndex].assetModels.count - indexPath.item - (self.navigation.allowTakingPicture ? 0 : 1);
    }
    return self.albumModels[self.currentAlbumIndex].assetModels[index];
}

- (void)calculatePhotosBytesWithBlock:(void (^)(NSString *totalBytes))block {

    __block NSInteger dataLength = 0;
    __block NSInteger curIndex = 0;
    
    if (self.selectedAssetModels.count > 0) {
        
        for (LYAssetModel *asset in self.selectedAssetModels) {
            
            [[PHImageManager defaultManager] requestImageDataForAsset:asset.asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                dataLength += imageData.length;
                curIndex ++;
                if (curIndex >= self.selectedAssetModels.count) {
                    NSString *bytes = nil;
                    if (dataLength >= 0.1 * 1024 * 1024) {
                        bytes = [NSString stringWithFormat:@"%0.1fM", dataLength / 1024.0 / 1024.0];
                    } else if (dataLength >= 1024) {
                        bytes = [NSString stringWithFormat:@"%0.0fK", dataLength / 1024.0];
                    } else {
                        bytes = [NSString stringWithFormat:@"%zdB", dataLength];
                    }
                    if (block) {
                        block(bytes);
                    }
                }
            }];
        }
    } else {
        if (block) {
            block(@"0.0M");
        }
    }
}

- (void)next:(UIBarButtonItem *)sender {
    
    sender.enabled = NO;
    
    NSMutableArray *assets = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    for (LYAssetModel *asset in self.selectedAssetModels) {
        [assets addObject:asset.asset];
        [images addObject:@1];
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    CGFloat scale = [LYImageManager imageScale];
    CGSize targetSize = CGSizeMake([LYAssetCCell ccellSize].width * scale, [LYAssetCCell ccellSize].height * scale);
    
    __block NSInteger count = 0;
    
    for (NSInteger idx = 0; idx < assets.count; idx ++) {
        PHAsset *asset = assets[idx];
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result && ![info[PHImageResultIsDegradedKey] boolValue]) {
//              这样可以保证图片的顺序
                [images replaceObjectAtIndex:idx withObject:result];
                count ++;
            }
            
            if (count >= assets.count) {
                
                if (self.navigation.pickerDelegate && [self.navigation.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingImages:sourceAssets:original:)]) {
                    [self.navigation.pickerDelegate imagePickerController:self.navigation didFinishPickingImages:[images copy] sourceAssets:[assets copy] original:self.navigation.isOrignalPhotos && self.navigation.allowPickingOrignalPhoto];
                }
                
                if (self.navigation.didFinishPickingImagesHandler) {
                    self.navigation.didFinishPickingImagesHandler([images copy], [assets copy], self.navigation.isOrignalPhotos && self.navigation.allowPickingOrignalPhoto);
                }
            }
        }];
    }
}

- (void)cancel {
    if (self.navigation.pickerDelegate && [self.navigation.pickerDelegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
        [self.navigation.pickerDelegate imagePickerDidCancel:self.navigation];
    }
    if (self.navigation.didCancelHandler) {
        self.navigation.didCancelHandler();
    }
}

#pragma mark - LYNavigationTitleViewDelegate
- (void)navigationTitleViewDidSelectItem:(LYNavigationTitleView *)titleView {
    if (!_albumView) {
        _albumView = [[LYAlbumView alloc] init];
        __weak typeof(self) weakSelf = self;
        _albumView.didSelectRowHandler = ^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.currentAlbumIndex = index;
            [strongSelf.collectionView reloadData];
            [strongSelf refreshTitleView];
        };
        _albumView.didDismissHandler = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf refreshTitleView];
        };
    }
    for (LYAlbumModel *album in self.albumModels) {
        album.hasSelectedAssets = NO;
        for (LYAssetModel *asset in self.selectedAssetModels) {
            if ([album.assetModels containsObject:asset]) {
                album.hasSelectedAssets = YES;
                break;
            }
        }
    }
    _albumView.albumModels = self.albumModels;
    [_albumView show];
}

@end
