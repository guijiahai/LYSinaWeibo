//
//  LYSidePopoverView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/18.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYSidePopoverView.h"

static NSString *const kCellIdentifier_SidePopover = @"LYSidePopoverCell";

static const CGFloat kSidePopoverCell_Height = 48.0;
static const CGFloat kSidePopoverViewWidth = 168.0;

@interface LYSidePopoverView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) LYSidePopoverViewStyle style;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) NSArray <UIImage *> *images;

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@interface LYSidePopoverCell : UITableViewCell

@property (nonatomic, strong) UIImageView *highlightedBackgroundView;
@property (nonatomic, strong) UIView *separator;

@end

@implementation LYSidePopoverView

- (instancetype)initWithStyle:(LYSidePopoverViewStyle)style titles:(NSArray<NSString *> *)titles images:(NSArray<UIImage *> *)images {
    
    if (self = [super init]) {
        self.style = style;
        self.titles = titles;
        self.images = images;
        
        self.backgroundColor = [UIColor clearColor];
        
        _arrowView = ({
            UIImage *image = nil;
            if (self.style == LYSidePopoverViewStyleLeft) {
                image = [UIImage imageNamed:@"popover_background_left"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(16, 40, 16, 16)];
            } else {
                image = [UIImage imageNamed:@"popover_background_right"];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16, 40)];
            }
            UIImageView *iv = [[UIImageView alloc] initWithImage:image];
            [self addSubview:iv];
            [iv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            iv;
        });
        
        _tableView = ({
            CGRect frame = CGRectMake(3.0, 14.0, kSidePopoverViewWidth - 6.0, kSidePopoverCell_Height * self.titles.count);
            UITableView *tbView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
            tbView.backgroundColor = [UIColor clearColor];
            tbView.dataSource = self;
            tbView.delegate = self;
            tbView.bounces = NO;
            tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tbView registerClass:[LYSidePopoverCell class] forCellReuseIdentifier:kCellIdentifier_SidePopover];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LYSidePopoverCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SidePopover forIndexPath:indexPath];
    cell.imageView.image = self.images[indexPath.row];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kSidePopoverCell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismiss];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sidePopoverView:didSelectRowAtIndex:)]) {
        [self.delegate sidePopoverView:self didSelectRowAtIndex:indexPath.row];
    }
    if (self.didSelectRowAtIndex) {
        self.didSelectRowAtIndex(indexPath.row);
    }
}

- (void)show {
    if (self.superview || self.isAnimating) {
        return;
    }
    self.animating = YES;
    
    [kKeyWindow addSubview:_backgroundView];
    self.alpha = 0.0;
    
    CGFloat x;
    if (self.style == LYSidePopoverViewStyleLeft) {
        x = 5.0;
    } else {
        x = kScreen_Width - kSidePopoverViewWidth - 5.0;
    }
    CGRect frame = CGRectMake(x, 55.0, kSidePopoverViewWidth, 18.0 + self.titles.count * kSidePopoverCell_Height);
    self.frame = frame;
    
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
    }];
}

@end

@implementation LYSidePopoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.highlightedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popover_background_highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)]];
        [self.contentView addSubview:self.highlightedBackgroundView];
        
        self.separator = [[UIView alloc] init];
        self.separator.backgroundColor = [UIColor colorWithWhite:34.0/255 alpha:0.5];
        [self.contentView addSubview:self.separator];
        [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.highlightedBackgroundView.hidden = !highlighted;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.highlightedBackgroundView.frame = CGRectMake(6.0, 4.0, self.contentView.width - 12.0, self.contentView.height - 8.0);
    
    self.textLabel.textColor = [UIColor whiteColor];
    
    self.imageView.frame = CGRectMake(20, (self.height - self.imageView.height) * 0.5, self.imageView.width, self.imageView.height);
    self.textLabel.frame = CGRectMake(60, (self.height - self.textLabel.height) * 0.5, self.textLabel.width, self.textLabel.height);
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    self.separator.hidden = indexPath.row == [[self tableView] numberOfRowsInSection:indexPath.section] - 1;
}

@end
