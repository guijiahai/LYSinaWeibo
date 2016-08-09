//
//  LYAlbumView.h
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/6.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYAlbumModel;

@interface LYAlbumView : UITableView

@property (nonatomic, strong) NSArray<LYAlbumModel *> *albumModels;

@property (nonatomic, copy) void (^didSelectRowHandler)(NSInteger index);
@property (nonatomic, copy) void (^didDismissHandler)();

- (void)show;
- (void)dismiss;

@end
