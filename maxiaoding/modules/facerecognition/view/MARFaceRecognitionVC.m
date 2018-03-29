//
//  MARFaceRecognitionVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/3/28.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARFaceRecognitionVC.h"
#import <AVFoundation/AVFoundation.h>
#import <UIImage+MAREX.h>
#import <UIView+MAREX.h>
#import <NSObject+MAREX.h>
#define FACERECOGNITION

@interface MARFaceRecognitionVC ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate,AVCaptureMetadataOutputObjectsDelegate>

//硬件设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入流
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//协调输入输出流的数据
@property (nonatomic, strong) AVCaptureSession *session;
//预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

//输出流
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;  //用于捕捉静态图片
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;    //原始视频帧，用于获取实时图像以及视频录制
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;      //用于二维码识别以及人脸识别
@property (nonatomic, strong) UIView *assistantFaceView;
@property (nonatomic, strong) UIView *assistantFaceView2;
@property (nonatomic, strong) UIView *assistantFaceView3;
@property (nonatomic, strong) UIView *assistantFaceView4;
@property (nonatomic, strong) UIView *assistantFaceView5;
@property (nonatomic, strong) NSArray<UIView *> *assistantFaceViewArray;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, MARCancelBlockToken> *blockTokenDic;
@property (nonatomic, strong) MARCancelBlockToken blockToken;
@property (weak, nonatomic) IBOutlet UIButton *changeCameraBtn;

- (IBAction)clickChangeCameraAction:(id)sender;

@end

@implementation MARFaceRecognitionVC
{
    BOOL stillImageFlag;
    BOOL videoDataFlag;
    BOOL metadataOutputFlag;
    UIImage *largeImage;
    UIImage *smallImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    metadataOutputFlag = YES;
}

- (void)UIGlobal
{
    [self.view.layer addSublayer:self.previewLayer];
    [self.view bringSubviewToFront:self.changeCameraBtn];
    for (NSInteger index = self.assistantFaceViewArray.count - 1; index >= 0; index--) {
        [self.view addSubview:self.assistantFaceViewArray[index]];
    }
//    [self.view addSubview:self.assistantFaceView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.session startRunning];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_session stopRunning];
}

- (void)dealloc
{
    MARLog(@">>>>>>>  stop");
}

#pragma mark - getter
- (AVCaptureDevice *)device
{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([_device lockForConfiguration:nil]) {
            // 自动闪光灯
            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
                [_device setFlashMode:AVCaptureFlashModeAuto];
            }
            // 自动白平衡
            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
                [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
            }
            // 自动对焦
            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            }
            // 自动曝光
            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            }
        }
    }
    return _device;
}

- (AVCaptureDeviceInput *)input
{
    if (!_input) {
        NSError *error = nil;
        _input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
        if (error) {
            NSLog(@">>>> error : %@", [error localizedDescription]);
        }
    }
    return _input;
}

- (AVCaptureStillImageOutput *)stillImageOutput
{
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    return _stillImageOutput;
}

- (AVCaptureVideoDataOutput *)videoDataOutput{
    if (!_videoDataOutput) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
        //设置像素格式，否则CMSampleBufferRef转换NSImage的时候CGContextRef初始化会出问题
        [_videoDataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    }
    return _videoDataOutput;
}

- (AVCaptureMetadataOutput *)metadataOutput
{
    if (!_metadataOutput) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc]init];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        //设置扫描区域
        _metadataOutput.rectOfInterest = self.view.bounds;
    }
    return _metadataOutput;
}

-(AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.stillImageOutput]) {
            [_session addOutput:self.stillImageOutput];
        }
        if ([_session canAddOutput:self.videoDataOutput]) {
            [_session addOutput:self.videoDataOutput];
        }
        if ([_session canAddOutput:self.metadataOutput]) {
            [_session addOutput:self.metadataOutput];
#ifndef FACERECOGNITION
            //设置扫码格式
            self.metadataOutput.metadataObjectTypes = @[
                                                        AVMetadataObjectTypeQRCode,
                                                        AVMetadataObjectTypeEAN13Code,
                                                        AVMetadataObjectTypeEAN8Code,
                                                        AVMetadataObjectTypeCode128Code
                                                        ];
#else
            self.metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
#endif
        }
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer
{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        _previewLayer.frame = self.view.layer.bounds;
    }
    return _previewLayer;
}

- (UIView *)assistantFaceView
{
    if (!_assistantFaceView) {
        _assistantFaceView = [self initializeFaceView];
    }
    return _assistantFaceView;
}

- (UIView *)assistantFaceView2
{
    if (!_assistantFaceView2) {
        _assistantFaceView2 = [self initializeFaceView];
    }
    return _assistantFaceView2;
}

- (UIView *)assistantFaceView3
{
    if (!_assistantFaceView3) {
        _assistantFaceView3 = [self initializeFaceView];
    }
    return _assistantFaceView3;
}

- (UIView *)assistantFaceView4
{
    if (!_assistantFaceView4) {
        _assistantFaceView4 = [self initializeFaceView];
    }
    return _assistantFaceView4;
}

- (UIView *)assistantFaceView5
{
    if (!_assistantFaceView5) {
        _assistantFaceView5 = [self initializeFaceView];
    }
    return _assistantFaceView5;
}

- (NSArray<UIView *> *)assistantFaceViewArray
{
    if (!_assistantFaceViewArray) {
        _assistantFaceViewArray = @[self.assistantFaceView, self.assistantFaceView2, self.assistantFaceView3, self.assistantFaceView4, self.assistantFaceView5];
    }
    return _assistantFaceViewArray;
}

- (NSMutableDictionary<NSNumber *,MARCancelBlockToken> *)blockTokenDic
{
    if (!_blockTokenDic) {
        _blockTokenDic = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    return _blockTokenDic;
}

- (UIView *)initializeFaceView
{
    UIView *view = [UIView new];
    view.hidden = YES;
    view.backgroundColor = [UIColor clearColor];
    [view mar_setLayerBorderWithColor:RGBHEX(0x9f4512) withCornerRadius:0.f andWidth:1];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//CMSampleBufferRef转NSImage
-(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    // 释放context和颜色空间
    CGContextRelease(context); CGColorSpaceRelease(colorSpace);
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    return (image);
}

#pragma mark - 切换前后摄像头
- (void)switchCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[self.input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            }else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if (!videoDataFlag) {
        return;
    }
    
    // 设置图像方向, 否则largeImage取出来是反的
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    largeImage = [self imageFromSampleBuffer:sampleBuffer];
    smallImage = [largeImage mar_imageByResizeToSize:CGSizeMake(512.f, 512.f)];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!metadataOutputFlag) {
        return;
    }
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex :0];
#ifndef FACERECOGNITION
        [self.session stopRunning];
        NSLog(@"qrcode is : %@",metadataObject.stringValue);
        
#else
        [self layoutAsistantFaceViews:metadataObjects];
        AVMetadataObject *faceData = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
        NSLog(@"faceData is : %@", faceData);
#endif
    }
}

- (void)layoutAsistantFaceViews:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
{
    if (metadataObjects.count > 0) {
        NSInteger count = MIN(metadataObjects.count, 5);
        for (int index = 0; index < count; index++) {
            AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex :index];
            AVMetadataObject *faceData = [self.previewLayer transformedMetadataObjectForMetadataObject:metadataObject];
            MARCancelBlockToken blockToken = self.blockTokenDic[@(index)];
            if (blockToken) {
                [NSObject mar_cancelBlock:blockToken];
                blockToken = nil;
            }
            UIView *asistantFaceView = self.assistantFaceViewArray[index];
            asistantFaceView.frame = faceData.bounds;
            asistantFaceView.hidden = NO;
            asistantFaceView.alpha = 1;
            blockToken = [self mar_gcdPerformAfterDelay:0.5 usingBlock:^(id  _Nonnull objSelf) {
                [UIView animateWithDuration:0.25 animations:^{
                    asistantFaceView.alpha = 0;
                } completion:^(BOOL finished) {
                    asistantFaceView.hidden = YES;
                }];
                
            }];
            [self.blockTokenDic setObject:blockToken forKey:@(index)];
        }
    }
}

- (void)hiddenAsistantFaceView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.assistantFaceView.alpha = 0;
    } completion:^(BOOL finished) {
        self.assistantFaceView.hidden = YES;
    }];
}

- (IBAction)clickChangeCameraAction:(id)sender {
    [self switchCamera];
}
@end
