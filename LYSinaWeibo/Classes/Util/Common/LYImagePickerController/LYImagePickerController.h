//
//  LYImagePickerController.h
//  LYImagePickerController
//
//  Created by GuiJiahai on 16/8/5.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYImagePickerControllerDelegate;
@class PHAsset;

@interface LYImagePickerController : UINavigationController

/* maxChooseCount如果为0，则表示不限数量 */
- (instancetype)initWithMaxChooseCount:(NSUInteger)maxChooseCount pickerDelegate:(id<LYImagePickerControllerDelegate>)pickerDelegate;

/* 选择单张图片 */
- (instancetype)initWithSinglePickerDelegate:(id<LYImagePickerControllerDelegate>)pickerDelegate;

@property (nonatomic, weak) id<LYImagePickerControllerDelegate> pickerDelegate;

/* 照片排序，默认为降序 - NO */
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/* 是否允许选择原图，默认为YES， 如果设为NO， 则隐藏选择原图按钮 */
@property (nonatomic, assign) BOOL allowPickingOrignalPhoto;

/* 是否允许拍照，默认为YES， 如果设为NO， 则隐藏拍照按钮 */
@property (nonatomic, assign) BOOL allowTakingPicture;

@property (nonatomic, strong) NSArray<PHAsset *> *selectedAssets;

/* orignal is NO by default */
@property (nonatomic, getter=isOrignalPhotos) BOOL orignalPhotos;

//返回的images为缩略图
@property (nonatomic, copy) void (^didFinishPickingImagesHandler)(NSArray<UIImage *> *images, NSArray<PHAsset *> *sourceAssets, BOOL original);
@property (nonatomic, copy) void (^didCancelHandler)();

@end



@protocol LYImagePickerControllerDelegate <NSObject>

@optional

/* 
 *  @param original 是否勾选了原图按钮
 * 这方法返回的images为缩略图，如果需要原图，可以使用assets获取相应的原图
 */
- (void)imagePickerController:(LYImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images sourceAssets:(NSArray<PHAsset *> *)sourceAssets original:(BOOL)original;
- (void)imagePickerDidCancel:(LYImagePickerController *)picker;

@end