//
//  LYComposeTextCell.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/8/1.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYComposeTextCell.h"

NSString *const kCellIdentifier_ComposeText = @"LYComposeTextCell";

@interface LYComposeTextCell () <UITextViewDelegate>

@end

@implementation LYComposeTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _textView = ({
            LYPlaceholderTextView *textView = [[LYPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, kScreen_Width - 20.0, 70.0)];
            textView.placeholder = @"分享新鲜事...";
            textView.delegate = self;
            textView.scrollEnabled = NO;
            textView.bounces = NO;
            textView.font = [UIFont systemFontOfSize:15];
            textView.textColor = [UIColor colorWithWhite:34.0/255 alpha:1];
            [textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
//            textView.layer.borderColor = [UIColor grayColor].CGColor;
//            textView.layer.borderWidth = 1.0;
            [self.contentView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self.contentView).offset(10);
                make.right.bottom.equalTo(self.contentView).offset(-10);
                make.height.mas_greaterThanOrEqualTo(70.0);
            }];
            textView;
        });
        
    }
    return self;
}

#pragma mark - text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textValueDidChangeBlock) {
        self.textValueDidChangeBlock(textView.text);
    }
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self.textView && [keyPath isEqualToString:@"text"]) {
        [self textViewDidChange:self.textView];
    }
}

- (void)dealloc {
    [self.textView removeObserver:self forKeyPath:@"text"];
}

+ (CGFloat)cellHeight {
    return UITableViewAutomaticDimension;
}

@end
