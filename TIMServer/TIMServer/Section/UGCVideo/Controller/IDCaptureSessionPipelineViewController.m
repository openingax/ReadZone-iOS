//
//  IDCaptureSessionPipelineViewController.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 9/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "IDCaptureSessionPipelineViewController.h"
#import "IDCaptureSessionAssetWriterCoordinator.h"
#import "TSUGCVideoPreviewViewController.h"

#import "IDFileManager.h"
#import "IDPermissionsManager.h"

#define BUTTON_RECORD_SIZE          65
#define BUTTON_CONTROL_SIZE         40
#define MAX_RECORD_TIME             60
#define MIN_RECORD_TIME             5

//TODO: add backgrounding stuff

@interface IDCaptureSessionPipelineViewController () <IDCaptureSessionCoordinatorDelegate, TSUGCVideoPreviewViewControllerDelegate>

@property (nonatomic, strong) IDCaptureSessionCoordinator *captureSessionCoordinator;

@property (nonatomic, strong) UIView *recordBtn;
@property (nonatomic, strong) UIView *recordSubview;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) UIButton *btnClose;
@property (nonatomic, strong) UIButton *btnCamera;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, assign) BOOL recording;
@property (nonatomic, assign) BOOL dismissing;
@property (nonatomic, assign) BOOL cameraFont;
@property (nonatomic, assign) BOOL isActive;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, assign) NSInteger recordDuration;
@property (nonatomic, assign) CGFloat recordPeakTime;
@property (nonatomic, strong) NSTimer *recorderTimer;
@property (nonatomic, strong) NSTimer *recorderPeakerTimer;

@property (nonatomic, strong) NSString *filePath;

@end

@implementation IDCaptureSessionPipelineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self checkPermissions];
    
    _captureSessionCoordinator = [IDCaptureSessionAssetWriterCoordinator new];
    [_captureSessionCoordinator setDelegate:self callbackQueue:dispatch_get_main_queue()];
    
    [self configureInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isActive = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isActive = NO;
}

- (void)dealloc {
    DebugLog(@"IDCaptureSessionPipelineViewController dealloc");
}

#pragma mark - Process

- (void)applicationDidBecomeActive:(NSNotification *)noti
{
    self.isActive = YES;
}

- (void)applicationWillResignActive:(NSNotification *)noti
{
    if (self.isActive) {
        [self stopRecordAction];
        [self stopPipelineAndDismiss];
    }
}

#pragma mark - Private methods

- (void)addOwnViews
{
    [super addOwnViews];
    
    CGFloat btnMarginBottom = kIsiPhoneX ? self.view.frame.size.height - BUTTON_RECORD_SIZE - 76 : self.view.frame.size.height - BUTTON_RECORD_SIZE + 10;
    
    _recordBtn = [[UIView alloc] init];
    _recordBtn.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE);
    _recordBtn.center = CGPointMake(self.view.frame.size.width / 2, btnMarginBottom);
    _recordBtn.userInteractionEnabled = YES;
    _recordBtn.layer.cornerRadius = 32.5;
    _recordBtn.layer.backgroundColor = [UIColor colorWithRed:247/255.f green:247/255.f blue:247/255.f alpha:0.6].CGColor;
    _recordBtn.layer.masksToBounds = YES;
    [self.view addSubview:_recordBtn];
    
    _recordSubview = [[UIView alloc] init];
    _recordSubview.bounds = CGRectMake(0, 0, 48, 48);
    _recordSubview.center = CGPointMake(32.5, 32.5);
    [_recordBtn addSubview:_recordSubview];
    _recordSubview.layer.cornerRadius = 24;
    _recordSubview.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _recordSubview.layer.masksToBounds = YES;
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordBtnLongPress:)];
    longGes.minimumPressDuration = 0.1;
    [_recordBtn addGestureRecognizer:longGes];
    
    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnClose.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnClose.center = CGPointMake(_recordBtn.center.x/2, _recordBtn.center.y);
    [_btnClose setImage:[UIImage tim_imageWithBundleAsset:@"kickout"] forState:UIControlStateNormal];
    [_btnClose addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnClose];
    
    // 切换前后摄像头的按钮
    _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCamera.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnCamera.center = CGPointMake(self.view.frame.size.width * 3 / 4 , _recordBtn.center.y);
    [_btnCamera setImage:[UIImage tim_imageWithBundleAsset:@"cameraex"] forState:UIControlStateNormal];
    [_btnCamera addTarget:self action:@selector(btnCameraAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCamera];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.hidesWhenStopped = YES;
    _indicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    [self.view addSubview:_indicator];
}

- (void)layoutSubviewsFrame
{
    [super layoutSubviewsFrame];
}

- (void)configureInterface
{
    AVCaptureVideoPreviewLayer *previewLayer = [_captureSessionCoordinator previewLayer];
    previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    [_captureSessionCoordinator startRunning];
}

#pragma mark - Action

- (void)recordingAction
{
    if(_recording){
        [_captureSessionCoordinator stopRecording];
    } else {
        // Disable the idle timer while recording
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        [self.captureSessionCoordinator startRecording];
        
        _recording = YES;
    }
}

- (void)cancelRecordAction
{
    if (_recording) {
        [_captureSessionCoordinator cancelRecording];
        _recording = NO;
    }
}

- (void)stopRecordAction
{
    [_recorderTimer invalidate];
    _recorderTimer = nil;
    
    [_recorderPeakerTimer invalidate];
    _recorderPeakerTimer = nil;
    
    _recordDuration = 0;
    _recordPeakTime = 0;
    
    [self refreshRecordTime:0];
    
    [_captureSessionCoordinator stopRecording];
}

/**
 切换前后摄像头
 */
- (void)btnCameraAction
{
    [self.captureSessionCoordinator swapFrontAndBackCamera];
}

/**
 关闭
 */
- (void)closeAction
{
    [_recorderTimer invalidate];
    _recorderTimer = nil;
    
    [_recorderPeakerTimer invalidate];
    _recorderPeakerTimer = nil;
    
    //TODO: tear down pipeline
    if(_recording){
        _dismissing = YES;
        [_captureSessionCoordinator stopRecording];
    } else {
        [self stopPipelineAndDismiss];
    }
}

- (void)recordBtnLongPress:(UILongPressGestureRecognizer *)ges
{
    CGFloat btnMarginBottom = kIsiPhoneX ? self.view.frame.size.height - BUTTON_RECORD_SIZE - 76 : self.view.frame.size.height - BUTTON_RECORD_SIZE + 10;
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _recordBtn.bounds = CGRectMake(0, 0, 90, 90);
            _recordBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.f, btnMarginBottom);
            _recordBtn.layer.cornerRadius = 45;
            
            _recordSubview.bounds = CGRectMake(0, 0, 35, 35);
            _recordSubview.center = CGPointMake(90/2.f, 90/2.f);
            _recordSubview.layer.cornerRadius = 17.5;
            
        } completion:^(BOOL finished) {
            
            [self circleAnimate];
            [self recordingAction];
            
        }];
        
    } else if (ges.state == UIGestureRecognizerStateEnded) {
        
        [self stopRecordAction];
        
        [UIView animateWithDuration:0.3 animations:^{
            _recordBtn.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE);
            _recordBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.f, btnMarginBottom);
            _recordBtn.layer.cornerRadius = BUTTON_RECORD_SIZE/2.f;
            
            _recordSubview.bounds = CGRectMake(0, 0, 48, 48);
            _recordSubview.center = CGPointMake(BUTTON_RECORD_SIZE/2.f, BUTTON_RECORD_SIZE/2.f);
            _recordSubview.layer.cornerRadius = 24;
            
        }];
    } else {
        
    }
}

- (void)circleAnimate
{
    //第一步，通过UIBezierPath设置圆形的矢量路径
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 84, 84)];
    
    //第二步，用CAShapeLayer沿着第一步的路径画一个完整的环（颜色灰色，起始点0，终结点1）
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = CGRectMake(0, 0, 84, 84);//设置Frame
    bgLayer.position = _recordBtn.center;//居中显示
    bgLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色=透明色
    bgLayer.lineWidth = 6.f;//线条大小
    bgLayer.strokeColor = [UIColor clearColor].CGColor;//线条颜色
    bgLayer.strokeStart = 0.f;//路径开始位置
    bgLayer.strokeEnd = 1.f;//路径结束位置
    bgLayer.path = circle.CGPath;//设置bgLayer的绘制路径为circle的路径
    [self.view.layer addSublayer:bgLayer];//添加到屏幕上
    
    //第三步，用CAShapeLayer沿着第一步的路径画一个红色的环形进度条，但是起始点=终结点=0，所以开始不可见
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, 84, 84);
    _shapeLayer.position = _recordBtn.center;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    _shapeLayer.lineWidth = 6.f;
    _shapeLayer.strokeColor = [UIColor colorWithRed:0 green:163/255.f blue:180/255.f alpha:1].CGColor;
    _shapeLayer.strokeStart = 0;
    _shapeLayer.strokeEnd = 0;
    _shapeLayer.path = circle.CGPath;
    [self.view.layer addSublayer:_shapeLayer];
    
    [_shapeLayer setAffineTransform:CGAffineTransformMakeRotation(-M_PI/2.f)];
}

// 刷新录像时间
-(void)refreshRecordTime:(CGFloat)second
{
    if (second == 0) {
        _shapeLayer.hidden = YES;
    } else {
        if (_shapeLayer.isHidden == YES) {
            _shapeLayer.hidden = NO;
        }
    }
    _recordPeakTime = second;
    _shapeLayer.strokeEnd = (CGFloat)_recordPeakTime / MAX_RECORD_TIME;
}

- (void)stopPipelineAndDismiss
{
    [_captureSessionCoordinator stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
    _dismissing = NO;
}

- (void)checkPermissions
{
    IDPermissionsManager *pm = [IDPermissionsManager new];
    [pm checkCameraAuthorizationStatusWithBlock:^(BOOL granted) {
        if(!granted){
            NSLog(@"we don't have permission to use the camera");
        }
    }];
    [pm checkMicrophonePermissionsWithBlock:^(BOOL granted) {
        if(!granted){
            NSLog(@"we don't have permission to use the microphone");
        }
    }];
}

#pragma mark - Timer

- (void)onRecording
{
    _recordDuration ++;
    DebugLog(@"录像时间：%ld", (long)_recordDuration);
    
    if (_recordDuration == MAX_RECORD_TIME) {
        [_recorderTimer invalidate];
        _recorderTimer = nil;
        
        [_recorderPeakerTimer invalidate];
        _recorderPeakerTimer = nil;
    }
}

- (void)onRecordPeak
{
    DebugLog(@"peak 时间：%f", (CGFloat)_recordPeakTime);
    _recordPeakTime += 0.1;
    [self refreshRecordTime:(CGFloat)_recordPeakTime];
}

#pragma mark = IDCaptureSessionCoordinatorDelegate methods

// 开始摄像
- (void)coordinatorDidBeginRecording:(IDCaptureSessionCoordinator *)coordinator
{
    _recorderTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRecording) userInfo:nil repeats:YES];
    _recorderPeakerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onRecordPeak) userInfo:nil repeats:YES];
}

- (void)coordinator:(IDCaptureSessionCoordinator *)coordinator didFinishRecordingToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    _recording = NO;
    [_indicator startAnimating];
    
    
    //Do something useful with the video file available at the outputFileURL
    IDFileManager *fm = [IDFileManager new];
    __weak typeof(self) ws = self;
    [fm convertMovToMP4WithSource:outputFileURL complete:^(AVAssetExportSessionStatus status, NSString *outputPath, UIImage *coverImg) {
        [ws.indicator stopAnimating];
        [fm removeFile:outputFileURL];
        
        if (status == AVAssetExportSessionStatusCompleted) {
            TSUGCVideoPreviewViewController *previewVC = [[TSUGCVideoPreviewViewController alloc] initWithVideoPath:outputPath coverImg:coverImg];
            previewVC.delegate = self;
            [ws.navigationController pushViewController:previewVC animated:YES];
        }
    }];
    
    //Dismiss camera (when user taps cancel while camera is recording)
    if(_dismissing){
        [self stopPipelineAndDismiss];
    }
}

#pragma mark TSUGCVideoPreviewViewControllerDelegate

- (void)previewVideoPath:(NSString *)path {
    [self.delegate recordVideoPath:path];
}

@end
