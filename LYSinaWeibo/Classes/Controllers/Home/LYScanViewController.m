//
//  LYScanViewController.m
//  LYScanViewController
//
//  Created by GuiJiahai on 16/8/10.
//  Copyright © 2016年 GuiJiahai. All rights reserved.
//

#import "LYScanViewController.h"
#import "LYScanView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "LYScanResultViewController.h"
#import "LYMyCardViewController.h"
#import "LYImagePickerController.h"

@interface LYScanViewController () <AVCaptureMetadataOutputObjectsDelegate, LYImagePickerControllerDelegate>

@property (nonatomic, strong) LYScanView *scanView;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
//@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, assign) BOOL needCapureQRCode;
@property (nonatomic, assign) BOOL firstLoadView;

@end

@implementation LYScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needCapureQRCode = YES;
    self.firstLoadView = YES;

    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.titleView = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor whiteColor];
        label.text = @"扫一扫";
        [label sizeToFit];
        label;
    });
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName : LYMainColor} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(album)];
    [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName : LYMainColor} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;


    ESWeakSelf
    
    self.scanView = [[LYScanView alloc] initWithFrame:kScreen_Bounds];
    [self.view addSubview:self.scanView];
    self.scanView.cardButtonClickedBlock = ^{
        ESStrongSelf
        LYMyCardViewController *vc = [[LYMyCardViewController alloc] init];
        [strongSelf.navigationController pushViewController:vc animated:YES];
    };
    self.scanView.flashButtonClickedBlock = ^ BOOL {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if ([strongSelf isFlashAvailable]) {
            BOOL on = [strongSelf isFlashOn];
            [strongSelf openFlash:!on];
            return !on;
        }
        return NO;
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(LYBaseNavigationController *)self.navigationController makeNavigationBarBackgroundTransparent];
    if (self.firstLoadView) {
        self.firstLoadView = NO;
        [self.scanView prepareDeviceWithText:@"相机启动中"];
        [self performSelector:@selector(startCamera) withObject:nil afterDelay:0.2];
    } else {
        [self startRunningAnimated:self.needCapureQRCode];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [(LYBaseNavigationController *)self.navigationController recoverNavigationBarBackground];
    [self.session stopRunning];
    [self.scanView stopScanAnimation];
    if (self.scanView.flashButton) {
        self.scanView.flashButton.selected = NO;
    }
}

- (void)startCamera {
    [self.scanView stopToPrepareDevice];

    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied) {
        NSString *appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleName"];
        NSString *message = [NSString stringWithFormat:@"请在%@的\"设置-隐私-相机\"选项中，允许%@访问你的相机", [UIDevice currentDevice].model, appName];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
      
    } else {
        [self.scanView beginScanAnimation];
        [self setupCapture];
        self.scanView.showFlashButton = [self isFlashAvailable];
    }
}

- (void)setupCapture {
    
    if (!self.session) {
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
     
        self.output = [[AVCaptureMetadataOutput alloc] init];
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        self.output.rectOfInterest = [LYScanView rectOfInterestForAVCaputreMetadataOutputWithFrame:self.scanView.frame];
        
//        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//        self.stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
        
        self.session = [[AVCaptureSession alloc] init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([self.session canAddInput:self.input]) {
            [self.session addInput:self.input];
        }
        if ([self.session canAddOutput:self.output]) {
            [self.session addOutput:self.output];
            [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
        }
//        if ([self.session canAddOutput:self.stillImageOutput]) {
//            [self.session addOutput:self.stillImageOutput];
//        }
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.frame = kScreen_Bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer insertSublayer:self.previewLayer atIndex:0];
        
        //自动聚焦
        if (device.isFocusPointOfInterestSupported && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [device lockForConfiguration:nil];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        }
    }
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (!self.needCapureQRCode) {
        return;
    }
    
    self.needCapureQRCode = NO;
    
    if (metadataObjects.count > 0) {
        
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];

        ESWeakSelf
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ESStrongSelf
            LYScanResultViewController *vc = [[LYScanResultViewController alloc] init];
            vc.metadataObject = object;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        });

    } else {
        self.needCapureQRCode = YES;
    }
}

//- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections {
//    for (AVCaptureConnection *conn in connections) {
//        for (AVCaptureInputPort *port in conn.inputPorts) {
//            if ([port.mediaType isEqual:mediaType]) {
//                return conn;
//            }
//        }
//    }
//    return nil;
//}

#pragma mark - action
- (void)startRunningAnimated:(BOOL)animated {
    if (!self.session.isRunning) {
        [self.session startRunning];
    }
    if (animated) {
        if (!self.scanView.isAnimating) {
            [self.scanView beginScanAnimation];
        }
    } else {
        if (self.scanView.isAnimating) {
            [self.scanView stopScanAnimation];
        }
    }
}

- (void)openFlash:(BOOL)flag {
    AVCaptureDeviceInput *input = self.session.inputs.firstObject;
    if ([input.device hasTorch] && [input.device hasFlash]) {
        [input.device lockForConfiguration:nil];
        if (flag) {
            input.device.torchMode = AVCaptureTorchModeOn;
            input.device.flashMode = AVCaptureFlashModeOn;
        } else {
            input.device.torchMode = AVCaptureFlashModeOff;
            input.device.flashMode = AVCaptureFlashModeOff;
        }
        [input.device unlockForConfiguration];
    }
}

- (BOOL)isFlashOn {
    AVCaptureDeviceInput *input = self.session.inputs.firstObject;
    return input.device.torchMode == AVCaptureTorchModeOn;
}

- (BOOL)isFlashAvailable {
    AVCaptureDeviceInput *input = self.session.inputs.firstObject;
    return input.device.hasFlash && input.device.hasTorch;
}

- (void)close {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)album {
    LYImagePickerController *picker = [[LYImagePickerController alloc] initWithSinglePickerDelegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - LYImagePickerControllerDelegate 

- (void)imagePickerController:(LYImagePickerController *)picker didFinishPickingImages:(NSArray<UIImage *> *)images sourceAssets:(NSArray<PHAsset *> *)sourceAssets original:(BOOL)original {
    
    self.needCapureQRCode = NO;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (sourceAssets.count <= 0) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"照片获取失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                self.needCapureQRCode = YES;
                [self startRunningAnimated:YES];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            [[PHImageManager defaultManager] requestImageForAsset:sourceAssets.firstObject targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                if ([info[PHImageResultIsDegradedKey] boolValue]) {
                    return ;
                }
                
                if (!result) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"照片获取失败" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                        self.needCapureQRCode = YES;
                        [self startRunningAnimated:YES];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                } else {
                    
                    NSString *message = [result parseQRCode];
                    if (!message) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"未发现二维码/条形码" preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                            self.needCapureQRCode = YES;
                            [self startRunningAnimated:YES];
                        }]];
                        [self presentViewController:alert animated:YES completion:nil];
                        return;
                    }
                    
                    self.needCapureQRCode = YES;
                    
                    LYScanResultViewController *vc = [[LYScanResultViewController alloc] init];
                    vc.messageString = message;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }
    }];

}

- (void)imagePickerDidCancel:(LYImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
