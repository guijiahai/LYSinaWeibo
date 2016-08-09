//
//  LYMiddlePopoverView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/18.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYMiddlePopoverView.h"

static NSString *const kCellIdentifier_MiddlePopover = @"LYMiddlePopoverCell";
static NSString *const kHeaderIdentifier_MiddlePopover = @"LYMiddlePopoverHeaderView";

static const CGFloat kMiddlePopoverCell_RowHeight = 39.0;
static const CGFloat kMiddlePopoverCell_SectionHeight = 20.0;
static const CGFloat kMiddlePopoverBottomButtonHeight = 37.0;

#define kMiddlePopoverViewWidth         (kScreen_Width * 0.5)
#define kMiddlePopoverViewMaxHeight     (kScreen_Height * 0.5)

@interface LYMiddlePopoverView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *bottomButton;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@interface LYMiddlePopoverCell : UITableViewCell

@end

@interface LYMiddlePopoverHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *leftSeparator, *rightSeparator;

@end

@implementation LYMiddlePopoverView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _arrowView = ({
            UIImage *image = [UIImage imageNamed:@"popover_background"];
            image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 16) resizingMode:UIImageResizingModeStretch];
            UIImageView *iv = [[UIImageView alloc] initWithImage:image];
            [self addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            iv;
        });
        
        _tableView = ({
            UITableView *tbView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
            tbView.backgroundColor = [UIColor clearColor];
            tbView.dataSource = self;
            tbView.delegate = self;
            tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tbView registerClass:[LYMiddlePopoverCell class] forCellReuseIdentifier:kCellIdentifier_MiddlePopover];
            [tbView registerClass:[LYMiddlePopoverHeaderView class] forHeaderFooterViewReuseIdentifier:kHeaderIdentifier_MiddlePopover];
            [self addSubview:tbView];
            tbView;
        });
        
        _backgroundView = [[UIView alloc] initWithFrame:kScreen_Bounds];
        _backgroundView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backgroundView addGestureRecognizer:tapGes];
        
        _animating = NO;
    }
    return self;
}

#pragma mark - table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInMiddlePopoverView:)]) {
        return [self.dataSource numberOfSectionsInMiddlePopoverView:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(middlePopoverView:titlesForSection:)]) {
        return [[self.dataSource middlePopoverView:self titlesForSection:section] count];
    } else {
        NSParameterAssert(NO);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYMiddlePopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MiddlePopover forIndexPath:indexPath];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(middlePopoverView:titlesForSection:)]) {
        NSArray *titles = [self.dataSource middlePopoverView:self titlesForSection:indexPath.section];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSParameterAssert(NO);
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(middlePopoverView:titleForHeaderInSection:)]) {
        NSString *title = [self.dataSource middlePopoverView:self titleForHeaderInSection:section];
        if (title) {
            LYMiddlePopoverHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderIdentifier_MiddlePopover];
            headerView.textLabel.text = title;
            return headerView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(middlePopoverView:titleForHeaderInSection:)] && [self.dataSource middlePopoverView:self titleForHeaderInSection:section]) {
        return kMiddlePopoverCell_SectionHeight;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMiddlePopoverCell_RowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(middlePopoverView:didSelectRowAtIndexPath:)]) {
        [self.delegate middlePopoverView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (CGFloat)popoverViewHeight:(CGFloat *)tableViewHeight {
    NSInteger section = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSectionsInMiddlePopoverView:)]) {
        section = [self.dataSource numberOfSectionsInMiddlePopoverView:self];
    } else {
        section = 1;
    }
    CGFloat tbViewHeight = 0.0;
    for (NSInteger idx = 0; idx < section; idx ++) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(middlePopoverView:titlesForSection:)]) {
            NSInteger row = [[self.dataSource middlePopoverView:self titlesForSection:idx] count];
            tbViewHeight += row * kMiddlePopoverCell_RowHeight;
        } else {
            NSParameterAssert(NO);
        }
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(middlePopoverView:titleForHeaderInSection:)] && [self.dataSource middlePopoverView:self titleForHeaderInSection:idx]) {
            tbViewHeight += kMiddlePopoverCell_SectionHeight;
        }
    }
    
    CGFloat height = tbViewHeight + 15.0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleOfBottomButtonInMiddlePopoverView:)] && [self.dataSource titleOfBottomButtonInMiddlePopoverView:self]) {
        height += kMiddlePopoverBottomButtonHeight;
    } else {
        height += 14.0;
    }
    
    if (height <= kMiddlePopoverViewMaxHeight) {
        *tableViewHeight = tbViewHeight;
        return height;
    } else {
        *tableViewHeight = tbViewHeight - (height - kMiddlePopoverViewMaxHeight);
        return kMiddlePopoverViewMaxHeight;
    }
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];

        _bottomButton.layer.masksToBounds = YES;
        
//        _bottomButton.backgroundColor = [UIColor whiteColor];
        [_bottomButton setBackgroundImage:[[UIImage imageNamed:@"popover_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
        [_bottomButton setBackgroundImage:[[UIImage imageNamed:@"popover_button_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
    }
    return _bottomButton;
}

- (NSIndexPath *)indexPathForSelectedRow {
    return self.tableView.indexPathForSelectedRow;
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)show {
    if (self.superview || self.isAnimating) {
        return;
    }
    self.animating = YES;

    
    [kKeyWindow addSubview:_backgroundView];
    self.alpha = 0.0;
    
    CGFloat tbViewHeight;
    CGFloat viewHeight = [self popoverViewHeight:&tbViewHeight];
    
    self.tableView.frame = CGRectMake(9.0, 15.0, kMiddlePopoverViewWidth - 18.0, tbViewHeight);
    self.frame = CGRectMake((kScreen_Width - kMiddlePopoverViewWidth) * 0.5, 55.0, kMiddlePopoverViewWidth, viewHeight);
    
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(titleOfBottomButtonInMiddlePopoverView:)] && [self.dataSource titleOfBottomButtonInMiddlePopoverView:self]) {
        NSString *title = [self.dataSource titleOfBottomButtonInMiddlePopoverView:self];
        [self.bottomButton setTitle:title forState:UIControlStateNormal];
        [self addSubview:self.bottomButton];
        self.bottomButton.frame = CGRectMake(6.0, viewHeight - kMiddlePopoverBottomButtonHeight + 3.0, kMiddlePopoverViewWidth - 12.0, 25);
        
    } else {
        if (_bottomButton && _bottomButton.superview) {
            [self.bottomButton removeFromSuperview];
        }
    }
    
    [self.tableView reloadData];
    
    [kKeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.animating = NO;
    }];
}

- (void)dismiss {
    if (!self.superview || self.isAnimating) {
        return;
    }
    self.animating = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backgroundView removeFromSuperview];
        self.animating = NO;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(middlePopoverViewDidDismiss:)]) {
            [self.delegate middlePopoverViewDidDismiss:self];
        }
    }];
}

@end

@interface LYMiddlePopoverCell ()

@property (nonatomic, strong) UIImageView *highlightedBackgroundView;

@end

@implementation LYMiddlePopoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor clearColor];
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popover_background_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
        
        self.highlightedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popover_background_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
        [self.contentView addSubview:self.highlightedBackgroundView];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.textColor = highlighted ? LYMainColor : [UIColor whiteColor];
    self.highlightedBackgroundView.hidden = !highlighted;
}

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 4.0;
    frame.size.height -= 8.0;
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.highlightedBackgroundView.frame = CGRectMake(0, 0, self.width, self.height);
    self.textLabel.textColor = self.selected ? LYMainColor : [UIColor whiteColor];
    self.textLabel.font = [UIFont boldSystemFontOfSize:16];
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 6.0;
    frame.origin.y = (self.height - frame.size.height) * 0.5;
    self.textLabel.frame = frame;
}

@end

@implementation LYMiddlePopoverHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        _leftSeparator = [[UIView alloc] init];
        _leftSeparator.backgroundColor = [UIColor colorWithWhite:90.0/255 alpha:1];
        [self.contentView addSubview:_leftSeparator];
        
        _rightSeparator = [[UIView alloc] init];
        _rightSeparator.backgroundColor = [UIColor colorWithWhite:90.0/255 alpha:1];
        [self.contentView addSubview:_rightSeparator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.textColor = [UIColor colorWithWhite:60.0/255 alpha:1];
    self.textLabel.font = [UIFont systemFontOfSize:12];
    
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 20.0;
    frame.origin.y += 3.0;
    self.textLabel.frame = frame;
    
    _leftSeparator.frame = CGRectMake(0, self.textLabel.centerY, self.textLabel.x - 5, 1);
    _rightSeparator.frame = CGRectMake(self.textLabel.maxXOfFrame + 5, self.textLabel.centerY, self.width - self.textLabel.maxXOfFrame - 5, 1);
}


@end
