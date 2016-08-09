//
//  LYComposeImagesCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/1.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComposeImagesCell.h"
#import "LYComposeImageCCell.h"
#import "LYComposeAddImageCCell.h"
#import "MJPhotoBrowser.h"

NSString *const kCellIdentifier_ComposeImages = @"LYComposeImagesCell";

@interface LYComposeImagesCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <UIImage *> *sourceImages;

@property (nonatomic, weak) LYComposeImageCCell *pointCCell;
@property (nonatomic, strong) UIImageView *captureImageView;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) CGPoint touchPoint;


@end

@implementation LYComposeImagesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
            
        self.sourceImages = [NSMutableArray array];
        
        UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [kKeyWindow addGestureRecognizer:ges];
    
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = [LYComposeImageCCell ccellSize];
        layout.minimumLineSpacing = 4.0;
        layout.minimumInteritemSpacing = 0.0;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollEnabled = NO;
        [self.collectionView registerClass:[LYComposeImageCCell class] forCellWithReuseIdentifier:kCCellIdentifier_ComposeImage];
        [self.collectionView registerClass:[LYComposeAddImageCCell class] forCellWithReuseIdentifier:kCCellIdentifier_ComposeAddImage];
        [self.contentView addSubview:self.collectionView];
        
        //左右边距为10
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);

        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_equalTo([self cellHeight]);
        }];
    }
    return self;
}

- (void)setImages:(NSArray<UIImage *> *)images {
    [self.sourceImages removeAllObjects];
    if (images) {
        [self.sourceImages addObjectsFromArray:images];
    }
    [self reloadUI];
}

- (NSArray<UIImage *> *)images {
    return [self.sourceImages copy];
}

#pragma mark - collection view methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.sourceImages.count == 0) {
        return 0;
    } else {
        return MIN(self.sourceImages.count + 1, 9);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.sourceImages.count) {
        LYComposeImageCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_ComposeImage forIndexPath:indexPath];
        cell.imageView.image = self.sourceImages[indexPath.item];
        ESWeakSelf
        cell.deleteImageBlock = ^(LYComposeImageCCell *ccell) {
            ESStrongSelf
            [strongSelf deleteImageWithCCell:ccell];
        };
        return cell;
    } else {
        LYComposeAddImageCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_ComposeAddImage forIndexPath:indexPath];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item < self.sourceImages.count) {
    } else {
        [self addImage];
    }
}

#pragma mark - action 
- (void)addImage {
    if (self.addImageButtonClicked) {
        self.addImageButtonClicked();
    }
}

- (void)reloadUI {
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([self cellHeight]);
    }];
    [self.collectionView reloadData];
    [UIView setAnimationsEnabled:NO];
    [[self tableView] beginUpdates];
    [[self tableView] endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)deleteImageWithCCell:(LYComposeImageCCell *)ccell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:ccell];
    if (indexPath) {
        [self.sourceImages removeObjectAtIndex:indexPath.item];
        [self reloadUI];
        if (self.deleteImageButtonClicked) {
            self.deleteImageButtonClicked(indexPath.row);
        }
    }
}

- (CGFloat)cellHeight {
    CGFloat line = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 4 : 3;
    NSInteger row = (MIN(self.sourceImages.count + 1, 9) + line - 1) / line;
    return ([LYComposeImageCCell ccellSize].height + 4.0) * row;
}

+ (CGFloat)cellHeight {
    return UITableViewAutomaticDimension;
}

#pragma mark - 移动图片
- (UIImageView *)captureImageView {
    if (!_captureImageView) {
        _captureImageView = [[UIImageView alloc] initWithFrame:(CGRect){0, 0,[LYComposeImageCCell ccellSize]}];
    }
    return _captureImageView;
}

- (void)longPress:(UILongPressGestureRecognizer *)ges {
    
    CGPoint point = [ges locationInView:kKeyWindow];
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        self.touchPoint = point;
        
        for (LYComposeImageCCell *ccell in self.collectionView.visibleCells) {
            CGRect tmpRect = [ccell convertRect:ccell.bounds toView:kKeyWindow];
            if (CGRectContainsPoint(tmpRect, point)) {
                self.pointCCell = ccell;
                self.originFrame = tmpRect;
                break;
            }
        }
        if (!self.pointCCell) {
            return;
        }
        UIGraphicsBeginImageContext(self.pointCCell.bounds.size);
        [self.pointCCell drawViewHierarchyInRect:self.pointCCell.bounds afterScreenUpdates:YES];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self.pointCCell.contentView setHidden:YES];
        
        self.captureImageView.image = image;
        self.captureImageView.frame = self.originFrame;
        [kKeyWindow addSubview:self.captureImageView];
        [UIView animateWithDuration:0.1 animations:^{
            self.captureImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
        
    } else if (ges.state == UIGestureRecognizerStateChanged) {
        
        if (self.pointCCell) {
            //移动截图-captureImageView
            CGPoint origin = self.originFrame.origin;
            origin.x += (point.x - self.touchPoint.x);
            origin.y += (point.y - self.touchPoint.y);
            self.captureImageView.origin = origin;
            
            //是否需要移动ccell
            LYComposeImageCCell *currentCCell = nil;
            for (LYComposeImageCCell *ccell in self.collectionView.visibleCells) {
                CGRect tmpRect = [ccell convertRect:ccell.bounds toView:kKeyWindow];
                if (CGRectContainsPoint(tmpRect, point)) {
                    currentCCell = ccell;
                    break;
                }
            }
            if (currentCCell && currentCCell != self.pointCCell) {
                NSIndexPath *fromIP = [self.collectionView indexPathForCell:currentCCell];
                if (fromIP.item >= self.sourceImages.count) {
                    return;
                }
                NSIndexPath *toIP = [self.collectionView indexPathForCell:self.pointCCell];
                [self.sourceImages exchangeObjectAtIndex:fromIP.item withObjectAtIndex:toIP.item];
                [self.collectionView moveItemAtIndexPath:fromIP toIndexPath:toIP];
                if (self.exchangeImageBlock) {
                    self.exchangeImageBlock(fromIP.item, toIP.item);
                }
            }
        }
        
    } else if (ges.state == UIGestureRecognizerStateEnded) {
        
        if (self.pointCCell) {
            [UIView animateWithDuration:0.15 animations:^{
                self.captureImageView.transform = CGAffineTransformIdentity;
                self.captureImageView.frame = [self.pointCCell convertRect:self.pointCCell.bounds toView:kKeyWindow];
            } completion:^(BOOL finished) {
                [self.captureImageView removeFromSuperview];
                [self.pointCCell.contentView setHidden:NO];
                self.pointCCell = nil;
            }];
        }
    }
}

- (void)dealloc {
    for (UIGestureRecognizer *ges in kKeyWindow.gestureRecognizers) {
        if ([ges isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [kKeyWindow removeGestureRecognizer:ges];
        }
    }
}

@end
