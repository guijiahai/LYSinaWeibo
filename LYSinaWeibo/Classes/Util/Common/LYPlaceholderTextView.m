//
//  LYPlaceholderTextView.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/16.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYPlaceholderTextView.h"

@interface LYPlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;


@end

@implementation LYPlaceholderTextView

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.origin = CGPointMake(4, 7);
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont systemFontOfSize:16];
        self.placeholderColor = [UIColor grayColor];
        self.placeholderLineSpacing = 5.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

- (void)textViewDidChange:(NSNotification *)notification {
    self.placeholderLabel.hidden = self.hasText;
}

// placeholder property
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = [placeholder copy];
    
    if ([NSString isEmptyOrNilString:placeholder]) {
        _placeholderLabel.attributedText = nil;
        return;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = self.placeholderLineSpacing;
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : self.placeholderColor ? : [UIColor grayColor], NSParagraphStyleAttributeName : style}];
    self.placeholderLabel.attributedText = attString;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholder = self.placeholder;
}

- (void)setPlaceholderLineSpacing:(CGFloat)placeholderLineSpacing {
    _placeholderLineSpacing = placeholderLineSpacing;
    self.placeholder = self.placeholder;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textViewDidChange:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
