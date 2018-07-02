//
//  MAROpencvCameraVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/21.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAROpencvCameraVC.h"
#import <AVFoundation/AVFoundation.h>
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>
#import <Masonry.h>

@interface MAROpencvCameraVC () <AVCaptureVideoDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *frontCameraInput;
//摄像头前面输入
@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;

@property (nonatomic, strong) UILabel *similarLabel;

//是否是前置摄像头,默认是no
@property (nonatomic, assign) BOOL isDevicePositionFront;

@property (nonatomic, assign) cv::Mat templateMat;
@property (nonatomic, assign) BOOL isCompareing;
@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) CAShapeLayer *tagLayer;
@end

@implementation MAROpencvCameraVC
{
    cv::Point  currentLoc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.lock = [[NSLock alloc] init];
//    [self setupCaptureSession];
    self.isCompareing = YES;
    [self chooseImage];
}

- (void)chooseImage
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ImagePick delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
//    self.templateMat = [image CVMat];
    cv::Mat templateMat;
    UIImageToMat(image, templateMat);
    cv::cvtColor(templateMat, templateMat, CV_BGR2GRAY);
    self.templateMat = templateMat;
    @weakify(self)
    [self mar_gcdPerformAfterDelay:2 usingBlock:^(id  _Nonnull objSelf) {
        [self setupCaptureSession];
    }];
    [self mar_gcdPerformAfterDelay:5 usingBlock:^(id  _Nonnull objSelf) {
        weak_self.isCompareing = NO;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setupCaptureSession
{
    //创建一个Session会话，控制输入输出流
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    //设置视频质量
    session.sessionPreset = AVCaptureSessionPresetMedium;
    self.session = session;
    
    //选择输入设备,默认是后置摄像头
    AVCaptureDeviceInput *input = self.backCameraInput;
    //设置视频输出流
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc]init];
    
    //设置输出格式
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA],                                   kCVPixelBufferPixelFormatTypeKey,nil];
    output.videoSettings = settings;
    
    //设置输出的代理
    dispatch_queue_t videoQueue = dispatch_queue_create("VideoQueue", DISPATCH_QUEUE_SERIAL);
    [output setSampleBufferDelegate:self queue:videoQueue];
    
    //将输入输出添加到会话，连接
    if ([session canAddInput:input]) {
        [session addInput:input];
    }
    if ([session canAddOutput:output]) {
        [session addOutput:output];
    }
    
    //创建预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    //设置layer大小
    CGFloat layerW = self.view.bounds.size.width - 40;
    previewLayer.frame = CGRectMake(20, 70, layerW, layerW);
    //视频大小根据frame大小自动调整
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:previewLayer];
    self.previewLayer = previewLayer;
    
    //创建一个处理后的预览图层,用来标记
    CAShapeLayer *targetLayer = [CAShapeLayer layer];
    targetLayer.frame = self.previewLayer.frame;
    [self.view.layer addSublayer:targetLayer];
    targetLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.tagLayer = targetLayer;
    
    
    // If you wish to cap the frame rate to a known value, such as 15 fps, set
    // minFrameDuration.
//    output.minFrameDuration = CMTimeMake(1, 15);
    
    // Start the session running to start the flow of data
    [session startRunning];
    
    // Assign session to an ivar.
    //[self setSession:session];
    
    [self.view addSubview:self.similarLabel];
    [self.similarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

-(cv::Mat)bufferToMat:(CMSampleBufferRef) sampleBuffer{
    CVImageBufferRef imgBuf = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    //锁定内存
    CVPixelBufferLockBaseAddress(imgBuf, 0);
    // get the address to the image data
    void *imgBufAddr = CVPixelBufferGetBaseAddress(imgBuf);
    
    // get image properties
    int w = (int)CVPixelBufferGetWidth(imgBuf);
    int h = (int)CVPixelBufferGetHeight(imgBuf);
    
    // create the cv mat
    cv::Mat mat(h, w, CV_8UC4, imgBufAddr, 0);
    //    //转换为灰度图像
    //    cv::Mat edges;
    //    cv::cvtColor(mat, edges, CV_BGR2GRAY);
    
    //旋转90度
    cv::Mat transMat;
    cv::transpose(mat, transMat);
    
    //翻转,1是x方向，0是y方向，-1位Both
    cv::Mat flipMat;
    cv::flip(transMat, flipMat, 1);
    
    CVPixelBufferUnlockBaseAddress(imgBuf, 0);
    
    return flipMat;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.previewLayer.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    // Create a UIImage from the sample buffer data
//    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    
    if (!self.isCompareing) {
        [self opencvJiansuoWithBuffer:sampleBuffer];
    }
}

- (void)opencvJiansuoWithBuffer:(CMSampleBufferRef)sampleBuffer
{
    NSLog(@">>>>>> start");
    [self.lock lock];
    self.isCompareing = YES;
    [self.lock unlock];
    
    cv::Mat imgMat = [self bufferToMat:sampleBuffer];
    // 判断是否为空 否则返回
    if (imgMat.empty() || self.templateMat.empty()) {
        [self.lock lock];
        self.isCompareing = NO;
        [self.lock unlock];
        return;
    }
    
    cv::cvtColor(imgMat, imgMat, CV_BGR2GRAY);
    UIImage *tempImg = MatToUIImage(imgMat);
    
    //获取标记的矩形
    NSArray *rectArr = [self compareByLevel:6 CameraInput:imgMat];
    
    // 转换为图片
    UIImage *rectImage = [self imageWithColor:[UIColor redColor] size:tempImg.size rectArray:rectArr];
    
    CGImageRef cgImage = rectImage.CGImage;
    
    //在异步线程中，将任务同步添加至主线程，不会造成死锁
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (cgImage) {
            self.tagLayer.contents = (__bridge id _Nullable)cgImage;
        }
    });
    
    [self compareInput:imgMat templateMat:self.templateMat];
    [self.lock lock];
    self.isCompareing = NO;
    [self.lock unlock];
    NSLog(@">>>>>> end");
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}

/**
 对比两个图像是否有相同区域
 
 @return 有为Yes
 */
-(BOOL)compareInput:(cv::Mat) inputMat templateMat:(cv::Mat)tmpMat{
    int result_rows = abs(inputMat.rows - tmpMat.rows) + 1;
    int result_cols = abs(inputMat.cols - tmpMat.cols) + 1;

    cv::Mat resultMat = cv::Mat(result_cols,result_rows,CV_32FC1);
    cv::matchTemplate(inputMat, tmpMat, resultMat, cv::TM_CCOEFF_NORMED);

    double minVal, maxVal;
    cv::Point minLoc, maxLoc, matchLoc;
    cv::minMaxLoc( resultMat, &minVal, &maxVal, &minLoc, &maxLoc, cv::Mat());
    //    matchLoc = maxLoc;
    //    NSLog(@"min==%f,max==%f",minVal,maxVal);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.similarLabel.text = [NSString stringWithFormat:@"相似度：%.2f",maxVal];
        NSLog(@"相似度：%.2f",maxVal);
    });

    if (maxVal > 0.7) {
        //有相似位置，返回相似位置的第一个点
        currentLoc = maxLoc;
        return YES;
    }else{
        return NO;
    }
}

//图像金字塔分级放大缩小匹配，最大0.8*相机图像，最小0.3*tep图像
-(NSArray *)compareByLevel:(int)level CameraInput:(cv::Mat) inputMat{
    //相机输入尺寸
    int inputRows = inputMat.rows;
    int inputCols = inputMat.cols;
    
    //模板的原始尺寸
    int tRows = self.templateMat.rows;
    int tCols = self.templateMat.cols;
    
    NSMutableArray *marr = [NSMutableArray array];
    
    for (int i = 0; i < level; i++) {
        //取循环次数中间值
        int mid = level*0.5;
        //目标尺寸
        cv::Size dstSize;
        if (i<mid) {
            //如果是前半个循环，先缩小处理
            dstSize = cv::Size(tCols*(1-i*0.2),tRows*(1-i*0.2));
        }else{
            //然后再放大处理比较
            int upCols = tCols*(1+i*0.2);
            int upRows = tRows*(1+i*0.2);
            //如果超限会崩，则做判断处理
            if (upCols>=inputCols || upRows>=inputRows) {
                upCols = tCols;
                upRows = tRows;
            }
            dstSize = cv::Size(upCols,upRows);
        }
        //重置尺寸后的tmp图像
        cv::Mat resizeMat;
        cv::resize(self.templateMat, resizeMat, dstSize);
        //然后比较是否相同
        BOOL cmpBool = [self compareInput:inputMat templateMat:resizeMat];
        
        if (cmpBool) {
            NSLog(@"匹配缩放级别level==%d",i);
            CGRect rectF = CGRectMake(currentLoc.x, currentLoc.y, dstSize.width, dstSize.height);
            NSValue *rValue = [NSValue valueWithCGRect:rectF];
            [marr addObject:rValue];
            break;
        }
    }
    return marr;
}

/**
 生成一张用矩形框标记目标的图片
 
 @param rectColor 矩形的颜色
 @param size 图片大小，一般和视频帧大小相同
 @param rectArray 需要标记的CGRect数组
 @return 返回一张图片
 */
- (UIImage *)imageWithColor:(UIColor *)rectColor size:(CGSize)size rectArray:(NSArray *)rectArray
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 1.开启图片的图形上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    // 2.获取
    CGContextRef cxtRef = UIGraphicsGetCurrentContext();
    
    // 3.矩形框标记颜色
    //获取目标位置
    for (NSInteger i = 0; i < rectArray.count; i++) {
        NSValue *rectValue = rectArray[i];
        CGRect targetRect = rectValue.CGRectValue;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetRect cornerRadius:5];
        //加路径添加到上下文
        CGContextAddPath(cxtRef, path.CGPath);
        [rectColor setStroke];
        [[UIColor clearColor] setFill];
        //渲染上下文里面的路径
        /**
         kCGPathFill,   填充
         kCGPathStroke, 边线
         kCGPathFillStroke,  填充&边线
         */
        CGContextDrawPath(cxtRef,kCGPathFillStroke);
    }
    
    //填充透明色
    CGContextSetFillColorWithColor(cxtRef, [UIColor clearColor].CGColor);
    
    CGContextFillRect(cxtRef, rect);
    
    // 4.获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 6.返回图片
    return img;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 摄像头输入
- (AVCaptureDeviceInput *)backCameraInput {
    if (_backCameraInput == nil) {
        NSError *error;
        AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        _backCameraInput = [[AVCaptureDeviceInput  alloc] initWithDevice:device error:&error];
        if (error) {
            NSLog(@"后置摄像头获取失败");
        }
    }
    self.isDevicePositionFront = NO;
    return _backCameraInput;
}

- (AVCaptureDeviceInput *)frontCameraInput {
    if (_frontCameraInput == nil) {
        NSError *error;
        AVCaptureDevice *device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        _frontCameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error) {
            NSLog(@"前置摄像头获取失败");
        }
    }
    self.isDevicePositionFront = YES;
    return _frontCameraInput;
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ){
            return device;
        }
    return nil;
}

- (UILabel *)similarLabel
{
    if (!_similarLabel) {
        _similarLabel = [UILabel new];
        _similarLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _similarLabel;
}

@end
