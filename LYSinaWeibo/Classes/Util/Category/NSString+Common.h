//
//  NSString+Common.h
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

- (NSString *)trimWhitespace;
- (BOOL)isEmpty;
+ (BOOL)isEmptyOrNilString:(NSString *)string;

@end

@interface NSString (ExtendedStringSize)

- (CGSize)boundingSizeWithFont:(UIFont *)font size:(CGSize)size;
- (CGFloat)boundingWidthWithFont:(UIFont *)font size:(CGSize)size;
- (CGFloat)boundingHeightWithFont:(UIFont *)font size:(CGSize)size;

- (CGFloat)boundingHeightWithFont:(UIFont *)font size:(CGSize)size lineSpacing:(CGFloat)lineSpacing;

@end



@interface NSString (Encode)

- (NSString *)URLEncoding;
- (NSString *)URLDecoding;
- (NSString *)md5Str;
- (NSString *)sha1Str;

+ (NSString *)md5WithContentsOfFile:(NSString *)path;
+ (NSString *)md5WithImage:(UIImage *)image;
+ (NSString *)md5WithData:(NSData *)data;

@end