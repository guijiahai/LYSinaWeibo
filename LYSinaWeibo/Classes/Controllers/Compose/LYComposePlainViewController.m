//
//  LYComposePlainViewController.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/16.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComposePlainViewController.h"
#import "LYComposeTextCell.h"
#import "LYComposeImagesCell.h"
#import "LYComposeKeyboardToolBar.h"
#import "LYImagePickerController.h"

@interface LYComposePlainViewController () <UITableViewDataSource, UITableViewDelegate, LYComposeKeyboardToolBarDelegate, LYImagePickerControllerDelegate>

@property (nonatomic, assign) LYComposePlainStyle style;

@property (nonatomic, strong) LYComposeKeyboardToolBar *keyboardToolBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<PHAsset *> *sourceAssets;
@property (nonatomic, getter=isOriginalPhoto) BOOL originalPhoto;


@end

@implementation LYComposePlainViewController

+ (instancetype)viewControllerWithStyle:(LYComposePlainStyle)style {
    LYComposePlainViewController *vc = [[LYComposePlainViewController alloc] init];
    vc.style = style;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.sourceAssets = [NSMutableArray array];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem composeItemWithTitle:@"发送" target:self action:@selector(publish)];
    self.navigationItem.titleView = [self titleView];
    
    [self tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.keyboardToolBar showInWindow];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.keyboardToolBar dismiss];
}

- (LYComposeKeyboardToolBar *)keyboardToolBar {
    if (!_keyboardToolBar) {
        _keyboardToolBar = [[LYComposeKeyboardToolBar alloc] init];
        _keyboardToolBar.delegate = self;
    }
    return _keyboardToolBar;
}

- (UIView *)titleView {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *topStr = [[NSAttributedString alloc] initWithString:@"发微博\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16], NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSAttributedString *bottomStr = [[NSAttributedString alloc] initWithString:[LYLogin sharedLogin].currentUser.screen_name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    [attString appendAttributedString:topStr];
    [attString appendAttributedString:bottomStr];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.attributedText = attString;
    [label sizeToFit];
    return label;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[LYComposeTextCell class] forCellReuseIdentifier:kCellIdentifier_ComposeText];
        [_tableView registerClass:[LYComposeImagesCell class] forCellReuseIdentifier:kCellIdentifier_ComposeImages];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

#pragma mark - table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ESWeakSelf
    if (indexPath.row == 0) {
        LYComposeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ComposeText forIndexPath:indexPath];
        cell.textValueDidChangeBlock = ^(NSString *textValue) {
            ESStrongSelf
            
        };
        return cell;
        
    } else {
        LYComposeImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ComposeImages forIndexPath:indexPath];
        cell.addImageButtonClicked = ^{
            ESStrongSelf
            [strongSelf composeKeyboardToolBarDidClickPictureButton:strongSelf.keyboardToolBar];
        };
        cell.deleteImageButtonClicked = ^(NSInteger index) {
            ESStrongSelf
            [strongSelf.sourceAssets removeObjectAtIndex:index];
        };
        cell.exchangeImageBlock = ^(NSInteger fromIndex, NSInteger toIndex) {
            ESStrongSelf
            [strongSelf.sourceAssets exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)publish {

}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark LYComposeKeyboardToolBarDelegate
- (void)composeKeyboardToolBarDidClickPictureButton:(LYComposeKeyboardToolBar *)toolBar {
    LYImagePickerController *picker = [[LYImagePickerController alloc] initWithMaxChooseCount:9 pickerDelegate:self];
    picker.selectedAssets = self.sourceAssets;
    picker.orignalPhotos = self.isOriginalPhoto;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - image picker delegate
- (void)imagePickerController:(LYImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images sourceAssets:(NSArray<PHAsset *> *)sourceAssets original:(BOOL)original {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.sourceAssets removeAllObjects];
    [self.sourceAssets addObjectsFromArray:sourceAssets];
    self.originalPhoto = original;
    LYComposeImagesCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.images = images;
}

- (void)imagePickerDidCancel:(LYImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
