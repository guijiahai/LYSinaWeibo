//
//  NSString+Common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/4.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Common)

- (NSString *)trimWhitespace {
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty {
    return [[self trimWhitespace] isEqualToString:@""];
}

+ (BOOL)isEmptyOrNilString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    return [string isEmpty];
}

@end

@implementation NSString (ExtendedStringSize)

- (CGSize)boundingSizeWithFont:(UIFont *)font size:(CGSize)size {
    if (self.length <= 0) {
        return CGSizeZero;
    }
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size;
}

- (CGFloat)boundingWidthWithFont:(UIFont *)font size:(CGSize)size {
    return [self boundingSizeWithFont:font size:size].width;
}

- (CGFloat)boundingHeightWithFont:(UIFont *)font size:(CGSize)size {
    return [self boundingSizeWithFont:font size:size].height;
}

- (CGFloat)boundingHeightWithFont:(UIFont *)font size:(CGSize)size lineSpacing:(CGFloat)lineSpacing {
    if (self.length <= 0) {
        return 0.0;
    }
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = lineSpacing;
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font, NSParagraphStyleAttributeName : style} context:nil].size.height;
}

@end



@implementation NSString (Encode)


- (NSString *)URLEncoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)URLDecoding {
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    return [string stringByRemovingPercentEncoding];
}


- (NSString *)md5Str {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString*) sha1Str {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+ (NSString *)md5WithContentsOfFile:(NSString *)path {
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if (!handle) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while (!done) {
        NSData* fileData = [handle readDataOfLength:1024];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if ([fileData length] == 0)
            done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

+ (NSString *)md5WithImage:(UIImage *)image {
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        return nil;
    }
    return [self md5WithData:data];
}

+ (NSString *)md5WithData:(NSData *)data {
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    NSData *fileData = [data subdataWithRange:NSMakeRange(0, 1024)];
    if ([fileData length] > 0) {
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

@end