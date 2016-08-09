//
//  LYAlbumView.m
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/6.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYAlbumView.h"
#import "LYAssetModel.h"
#import "LYAssetCell.h"

#define LYImagePicker_ScreenWidth   [UIScreen mainScreen].bounds.size.width
#define LYImagePicker_ScreenHeight  [UIScreen mainScreen].bounds.size.height
#define LYImagePicker_KeyWindow     [UIApplication sharedApplication].keyWindow

@interface LYAlbumView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *topOverlayView;
@property (nonatomic, strong) UIView *bottomOverlayView;

@end

@implementation LYAlbumView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        self.backgroundColor = [UIColor colorWithWhite:240.0/255 alpha:1];
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[LYAlbumCell class] forCellReuseIdentifier:kCellIdentifier_Album];
        
        self.topOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LYImagePicker_ScreenWidth, 64.0)];
        self.topOverlayView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.topOverlayView addGestureRecognizer:ges];
        
        self.bottomOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 64.0, LYImagePicker_ScreenWidth, LYImagePicker_ScreenHeight - 64.0)];
        self.bottomOverlayView.alpha = 0.0l;
        self.bottomOverlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.bottomOverlayView addGestureRecognizer:ges];
    }
    return self;
}

#pragma mark - table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albumModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Album forIndexPath:indexPath];
    cell.albumModel = self.albumModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LYAlbumCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
    if (self.didSelectRowHandler) {
        self.didSelectRowHandler(indexPath.row);
    }
}

- (void)show {
    if (self.superview) {
        return;
    }
    CGFloat tableHeight = self.albumModels.count * [LYAlbumCell cellHeight];
    tableHeight = MIN(tableHeight, LYImagePicker_ScreenHeight * 0.5);
    self.frame = CGRectMake(0, 64.0, LYImagePicker_ScreenWidth, 0);
    self.bottomOverlayView.alpha = 0.0;
    
    [LYImagePicker_KeyWindow addSubview:self.topOverlayView];
    [LYImagePicker_KeyWindow addSubview:self.bottomOverlayView];
    [LYImagePicker_KeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, 64.0, LYImagePicker_ScreenWidth, tableHeight);
        self.bottomOverlayView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self reloadData];
    }];
}

- (void)dismiss {
    if (!self.superview) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, 64.0, LYImagePicker_ScreenWidth, 0);
        self.bottomOverlayView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.topOverlayView removeFromSuperview];
        [self removeFromSuperview];
        [self.bottomOverlayView removeFromSuperview];
        if (self.didDismissHandler) {
            self.didDismissHandler();
        }
    }];
}


@end
