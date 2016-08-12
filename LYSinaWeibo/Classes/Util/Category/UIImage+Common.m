//
//  UIImage+Common.m
//  LYSinaWeibo
//
//  Created by GuiJiahai on 16/7/13.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "UIImage+Common.h"

@implementation UIImage (Common)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [UIImage imageWithColor:color frame:CGRectMake(0, 0, 1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextFillRect(ctx, frame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation UIImage (UIImageQRCode)

+ (CIImage *)QRCode_CI_WithInputMessage:(NSString *)inputMessage {
    NSData *data = [inputMessage dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKeyPath:@"inputMessage"];
    [filter setValue:@"H" forKeyPath:@"inputCorrectionLevel"];
    return filter.outputImage;
}

+ (UIImage *)QRCodeWithInputMessage:(NSString *)inputMessage size:(CGSize)size {
    
    CIImage *image = [self QRCode_CI_WithInputMessage:inputMessage];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width / CGRectGetWidth(extent), size.height / CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

+ (UIImage *)QRCodeWithInputMessage:(NSString *)inputMessage size:(CGSize)size color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor {
    
    CIImage *outputImage = [self QRCode_CI_WithInputMessage:inputMessage];

    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage", outputImage,
                             @"inputColor0", [CIColor colorWithCGColor:color.CGColor],
                             @"inputColor1", [CIColor colorWithCGColor:backgroundColor.CGColor],
                             nil];
    
    CIImage *ciImage = colorFilter.outputImage;
    
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:ciImage fromRect:ciImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *QRCode = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return QRCode;
}

- (UIImage *)drawWithLogoImage:(UIImage *)logoImage logoSize:(CGSize)logoSize {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:(CGRect){0, 0, self.size}];
    CGRect rect = CGRectMake((self.size.width - logoSize.width) * 0.5, (self.size.height - logoSize.height) * 0.5, logoSize.width, logoSize.height);
    [logoImage drawInRect:rect];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

- (NSString *)parseQRCode {
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyLow}];
    NSData *imageData = UIImagePNGRepresentation(self);
    CIImage *ci_image = [CIImage imageWithData:imageData];
    NSArray *features = [detector featuresInImage:ci_image];
    if (features.count > 0) {
        CIQRCodeFeature *feature = features.firstObject;
        return feature.messageString;
    }
    return nil;
}

@end