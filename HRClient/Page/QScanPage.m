//
//  QScanPage.m
//  HRClient
//
//  Created by amy.fu on 15/5/23.
//  Copyright (c) 2015年 panyj. All rights reserved.
//

#import "QScanPage.h"
#import <AVFoundation/AVFoundation.h>
#import "QViewController.h"
#import "QHttpMessageManager.h"

@interface QScanPage ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    NSString *_resultBarCode;
    UILabel *_scanLabel;
    UILabel *_tipLabel;
    UIView *_maskViewTop;
    UIView *_maskViewBottom;
    UIView *_maskViewLeft;
    UIView *_maskViewRight;
    UIImageView *_topLeftImageView;
    UIImageView *_topRightImageView;
    UIImageView *_bottomLeftImageView;
    UIImageView *_bottomRightImageView;
    UIImageView *_lineImageView;
    
    BOOL _isOutputSetted;
}

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation QScanPage

- (NSString*)title
{
    return _T(@"扫描二维码");
}

- (QCacheType)pageCacheType
{
    return kCacheTypeNone;
}

- (QNavigationType)navigationType
{
    return kNavigationTypeNormal;
}

- (QBottomMenuType)bottomMenuType
{
    return kBottomMenuTypeNone;
}

- (void)setActiveWithParams:(NSDictionary *)params
{
    
}

- (void)pageEvent:(QPageEventType)eventType
{
    if (eventType == kPageEventWillShow)
    {
    }
    else if (eventType == kPageEventWillHide)
    {
    }
    else if (eventType == kPageEventViewCreate)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successCheckOrder:) name:kScanCode
                                                   object:nil];
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusAuthorized)
        {
            [self initAVCapture];
            [self startScan];
        }
        else if (authStatus == AVAuthorizationStatusNotDetermined)
        {
            __weak typeof(self) weakSelf = self;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if(granted){
                        [weakSelf initAVCapture];
                        [weakSelf startScan];
                    }
                    else {
                        //todo : 不允许打开摄像头
                    }
                });
            }];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的\"设置 - 隐私 - 相机\"选项中，允许车夫访问你的相机"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
        }

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidEnterInBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appWillEnterInForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    else if (eventType == kPageEventViewDispose)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (UIView *)viewWithFrame:(CGRect)frame
{
    if ([super viewWithFrame:frame]) {
        
        CGSize scanSize = CGSizeMake(225, 225);
        CGFloat width = _view.deFrameWidth;
        CGFloat height = _view.deFrameHeight;
        
        _maskViewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, (height-scanSize.height)/2)];
        _maskViewTop.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self.view addSubview:_maskViewTop];
        
        _maskViewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, (height-scanSize.height)/2, (width-scanSize.width)/2, scanSize.height)];
        _maskViewLeft.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self.view addSubview:_maskViewLeft];
        
        _maskViewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, (height-scanSize.height)/2+scanSize.height, width, (height-scanSize.height)/2)];
        _maskViewBottom.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self.view addSubview:_maskViewBottom];
        
        _maskViewRight = [[UIView alloc] initWithFrame:CGRectMake((width-scanSize.width)/2+scanSize.width, (height-scanSize.height)/2, (width-scanSize.width)/2, scanSize.height)];
        _maskViewRight.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self.view addSubview:_maskViewRight];
        
        UIImage *cornerTopLeft = [UIImage imageNamed:@"scan_corner"];
        _topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-scanSize.width)/2, (height-scanSize.height)/2, cornerTopLeft.size.width, cornerTopLeft.size.height)];
        _topLeftImageView.image = cornerTopLeft;
        [self.view addSubview:_topLeftImageView];
        UIImage *cornerTopRight = [self rotateImage:cornerTopLeft WithRadian:M_PI/2];
        
        _topRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-scanSize.width)/2+scanSize.width-cornerTopLeft.size.width, (height-scanSize.height)/2, cornerTopLeft.size.width, cornerTopLeft.size.height)];
        _topRightImageView.image = cornerTopRight;
        [self.view addSubview:_topRightImageView];
        
        UIImage *cornerBottomRight = [self rotateImage:cornerTopLeft WithRadian:M_PI];
        _bottomRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-scanSize.width)/2+scanSize.width-cornerTopLeft.size.width, (height-scanSize.height)/2+scanSize.height-cornerTopLeft.size.height, cornerTopLeft.size.width, cornerTopLeft.size.height)];
        _bottomRightImageView.image = cornerBottomRight;
        [self.view addSubview:_bottomRightImageView];
        
        UIImage *cornerBottomLeft = [self rotateImage:cornerTopLeft WithRadian:3*M_PI/2];
        _bottomLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake((width-scanSize.width)/2, (height-scanSize.height)/2+scanSize.height-cornerTopLeft.size.height, cornerTopLeft.size.width, cornerTopLeft.size.height)];
        _bottomLeftImageView.image = cornerBottomLeft;
        [self.view addSubview:_bottomLeftImageView];
        
        UIImage *scanImage = [UIImage imageNamed:@"scan_now"];
        _lineImageView = [[UIImageView alloc] init];
        //    _lineImageView.backgroundColor = [UIColor greenColor];
        _lineImageView.image = scanImage;
        [self.view addSubview:_lineImageView];
        
        /*
        UIImage *lbImage = [UIImage imageNamed:@"pic_Bar_code"];
        _scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lbImage.size.width, lbImage.size.height)];
        _scanLabel.backgroundColor = [QTools colorWithRGB:73 :73 :73];
        _scanLabel.layer.cornerRadius = 6.f;
        _scanLabel.layer.masksToBounds = YES;
        _scanLabel.textAlignment = NSTextAlignmentCenter;
        _scanLabel.font = [UIFont systemFontOfSize:12];
        _scanLabel.textColor = [UIColor whiteColor];
        _scanLabel.text = @"正在扫描条形码";
        [self.view addSubview:_scanLabel];
        _scanLabel.center = CGPointMake(width/2, top+_scanLabel.frame.size.height/2);
        */
        
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:12];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.text = @"将条码放入框内，即可自动扫描";
        [self.view addSubview:_tipLabel];
        _tipLabel.center = CGPointMake(width/2, _maskViewBottom.frame.origin.y + 20);
        
        CGFloat ScreenHight = [UIScreen mainScreen].bounds.size.height;
        CGFloat ScreenWidth = [UIScreen mainScreen].bounds.size.width;
        
        AVCaptureMetadataOutput *output = [_session.outputs objectAtIndex:0];
        output.rectOfInterest =  CGRectMake ((CGRectGetMinY(_topLeftImageView.frame))/ ScreenHight ,(( ScreenWidth - (scanSize.width+10))/ 2 )/ ScreenWidth , (scanSize.height+10) / ScreenHight , (scanSize.width+10) / ScreenWidth );
    }
    return _view;
}

#pragma mark - Private

- (UIImage*)rotateImage:(UIImage *)originalImage WithRadian:(CGFloat)radian
{
    CGSize imgSize = CGSizeMake(originalImage.size.width, originalImage.size.height);
    CGSize outputSize = imgSize;
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, radian);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [originalImage drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)initAVCapture {
    // Device
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // Output
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:input])
    {
        [_session addInput:input];
    }
    
    if ([_session canAddOutput:output])
    {
        [_session addOutput:output];
    }
    
    // 条码类型
    [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    AVCaptureVideoPreviewLayer *preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    preview.frame = self.view.bounds;
    [_view.layer insertSublayer:preview atIndex:0];
}

- (void)scanAnimation:(BOOL)show
{
    if (show)
    {
        CGSize scanSize = CGSizeMake(225, 225);
        CGFloat width = _view.deFrameWidth;
        CGFloat height = _view.deFrameHeight;
        
        UIImage *scanImage = [UIImage imageNamed:@"scan_now.png"];
        _lineImageView.frame = CGRectMake((width-scanImage.size.width)/2, (height-scanSize.height)/2, scanImage.size.width, 0);
        [UIView beginAnimations:Nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:2.5];
        [UIView setAnimationRepeatCount:HUGE_VALF];
        _lineImageView.frame = CGRectMake((width-scanImage.size.width)/2, (height-scanSize.height)/2+scanSize.height-scanImage.size.height+10, scanImage.size.width, scanImage.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [_lineImageView.layer removeAllAnimations];
    }
}

- (void)startScan
{
    [self scanAnimation:YES];
     if (_session)
        [_session startRunning];
}

- (void)stopScan
{
    [self scanAnimation:NO];
    if (_session)
        [_session stopRunning];
}

#pragma mark- AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        _resultBarCode = metadataObject.stringValue;
        
        //规避多次调用问题
        @synchronized(_session){
            if (_session.isRunning) {
                [self gotoCheck];
            }
        }
    }
}

#pragma mark - Notification

- (void)appDidEnterInBackground:(NSNotification *)notification
{
    [self stopScan];
}

- (void)appWillEnterInForeground:(NSNotification *)notification
{
    [self startScan];
}


- (void)gotoCheck
{
    if (!_resultBarCode) {
        return;
    }
    
    [[QHttpMessageManager sharedHttpMessageManager] accessScanCode:_resultBarCode];
    [ASRequestHUD show];
}

#pragma mark - Notification

- (void)successCheckOrder:(NSNotification*)noti
{
    [QViewController gotoPage:@"QCheckOrderResult"
                    withParam:[[NSDictionary alloc] initWithObjectsAndKeys:noti.object, @"QScanModel", nil]];
    [ASRequestHUD dismiss];
}


@end
