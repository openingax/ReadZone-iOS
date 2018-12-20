
#import <Foundation/Foundation.h>
#import "TCVideoRecordViewController.h"
#import "TXRTMPSDK/TXUGCRecord.h"
#import "TCVideoPreviewViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TIMServerHelper.h"
#import "CommonLibrary.h"
#import "TSExpendButton.h"
#import <Masonry.h>

#define BUTTON_RECORD_SIZE          65
#define BUTTON_CONTROL_SIZE         40
#define MAX_RECORD_TIME             60
#define MIN_RECORD_TIME             5

@interface TCVideoRecordViewController () <TXVideoRecordListener, MicroVideoPreviewDelegate>
{
    BOOL                            _cameraFront;
    BOOL                            _lampOpened;
    BOOL                            _bottomViewShow;
    
    int                             _beautyDepth;
    int                             _whitenDepth;
    
    BOOL                            _cameraPreviewing;
    BOOL                            _videoRecording;
    UIView *                        _videoRecordView;
    UIButton *                      _btnClose;
    UIButton *                      _btnCamera;
    UIButton *                      _btnLamp;
    UILabel *                       _recordTimeLabel;
    int                             _currentRecordTime;
    
    BOOL                            _navigationBarHidden;
    BOOL                            _statusBarHidden;
    BOOL                            _appForeground;
    
    int    _filterType;
    int    _greenIndex;;
    
    float  _eye_level;
    float  _face_level;
    
    UIView *_recordBtn;
    UIView *_recordSubView;
    CAShapeLayer *_shapeLayer;
}
@end


@implementation TCVideoRecordViewController

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _cameraFront = YES;
        _lampOpened = NO;
        
        _beautyDepth = 6.3;
        _whitenDepth = 2.7;
        
        _cameraPreviewing = NO;
        _videoRecording = NO;

        _currentRecordTime = 0;
        
        [TXUGCRecord shareInstance].recordDelegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAudioSessionEvent:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
        _appForeground = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _navigationBarHidden = self.navigationController.navigationBar.hidden;
    _statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [self.navigationController setNavigationBarHidden:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (authorizationStatus) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler: ^(BOOL granted) {
                    if (granted) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self startCameraPreview];
                        });
                    } else {
                        NSLog(@"%@", @"访问受限");
                        [self showError];
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startCameraPreview];
                });
                break;
            }
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied: {
                NSLog(@"%@", @"访问受限");
                [self showError];
                break;
            }
            default: {
                break;
            }
        }
    });
}

- (void)showError
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //      [YMCAlertView showMessage:@"请在iPhone的“设置-隐私－相机”选项中，允许微信访问你的相机"];
        self.view.backgroundColor = [UIColor darkGrayColor];
        self->_btnClose.hidden = YES;
        self->_recordBtn.hidden = YES;
        self->_btnCamera.hidden = YES;
        
        UILabel *errorLabel = [[UILabel alloc] init];
        errorLabel.textAlignment = NSTextAlignmentCenter;
        errorLabel.numberOfLines = 0;
        errorLabel.text = @"请在iPhone的“设置-隐私－相机”选项中，允许云米商城访问你的相机";
        errorLabel.font = [UIFont systemFontOfSize:14];
        errorLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:errorLabel];
        [errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).with.offset(30);
            make.right.equalTo(self.view).with.offset(-30);
            make.centerY.equalTo(self.view);
        }];
        
        UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"退出" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        [exitBtn setAttributedTitle:str forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(onBtnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:exitBtn];
        [exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(errorLabel.mas_bottom).with.offset(20);
        }];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:_navigationBarHidden];
    
    [self stopCameraPreview];
}

- (void)dealloc {
    NSLog(@"TCVideoRecordViewController dealloc");
}

-(void)onAudioSessionEvent:(NSNotification*)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        // 在10.3及以上的系统上，分享跳其它app后再回来会收到AVAudioSessionInterruptionWasSuspendedKey的通知，不处理这个事件。
        if ([info objectForKey:@"AVAudioSessionInterruptionWasSuspendedKey"]) {
            return;
        }
        _appForeground = NO;
        
        if (_videoRecording)
        {
            _videoRecording = NO;
        }
    }else{
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            _appForeground = YES;
        }
    }
}

- (void)onAppDidEnterBackGround:(UIApplication*)app {
    _appForeground = NO;
    
    if (_videoRecording) {
        _videoRecording = NO;
    }
}

- (void)onAppWillEnterForeground:(UIApplication*)app {
    _appForeground = YES;
}


#pragma mark ---- Common UI ----
-(void)initUI
{
    _videoRecordView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_videoRecordView];

//    _btnStartRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE)];
    CGFloat btnMarginBottom = kIsiPhoneX ? self.view.frame.size.height - BUTTON_RECORD_SIZE : self.view.frame.size.height - BUTTON_RECORD_SIZE + 10;
//    _btnStartRecord.center = CGPointMake(self.view.frame.size.width / 2, btnMarginBottom);
//    [_btnStartRecord setImage:[UIImage tim_imageWithBundleAsset:@"startrecord"] forState:UIControlStateNormal];
//    [_btnStartRecord setImage:[UIImage tim_imageWithBundleAsset:@"startrecord_press"] forState:UIControlStateSelected];
//    [_btnStartRecord addTarget:self action:@selector(onBtnRecordStartClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_btnStartRecord];
    
    _recordBtn = [[UIView alloc] init];
    _recordBtn.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE);
    _recordBtn.center = CGPointMake(self.view.frame.size.width / 2, btnMarginBottom);
    _recordBtn.userInteractionEnabled = YES;
    _recordBtn.layer.cornerRadius = 32.5;
    _recordBtn.layer.backgroundColor = [UIColor colorWithRed:247/255.f green:247/255.f blue:247/255.f alpha:0.6].CGColor;
    _recordBtn.layer.masksToBounds = YES;
    [self.view addSubview:_recordBtn];
    
    _recordSubView = [[UIView alloc] init];
    _recordSubView.bounds = CGRectMake(0, 0, 48, 48);
    _recordSubView.center = CGPointMake(32.5, 32.5);
    [_recordBtn addSubview:_recordSubView];
    _recordSubView.layer.cornerRadius = 24;
    _recordSubView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _recordSubView.layer.masksToBounds = YES;
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordBtnLongPress:)];
    longGes.minimumPressDuration = 0.2;
    [_recordBtn addGestureRecognizer:longGes];

    _btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnClose.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnClose.center = CGPointMake(_recordBtn.center.x/2, _recordBtn.center.y);
    [_btnClose setImage:[UIImage tim_imageWithBundleAsset:@"kickout"] forState:UIControlStateNormal];
    [_btnClose addTarget:self action:@selector(onBtnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnClose];
    
    // 切换前后摄像头的按钮
    _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCamera.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
    _btnCamera.center = CGPointMake(self.view.frame.size.width * 3 / 4 , _recordBtn.center.y);
    [_btnCamera setImage:[UIImage tim_imageWithBundleAsset:@"cameraex"] forState:UIControlStateNormal];
    [_btnCamera addTarget:self action:@selector(onBtnCameraClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnCamera];
    
    // 闪光灯
//    _btnLamp = [UIButton buttonWithType:UIButtonTypeCustom];
//    _btnLamp.bounds = CGRectMake(0, 0, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE);
////    _btnLamp.center = CGPointMake(offsetX - BUTTON_CONTROL_SIZE * 2 , centerY);
//    _btnLamp.center = CGPointMake(kScreenWidth * 5 / 6, kIsiPhoneX ? 64 : 40);
//    [_btnLamp setImage:[UIImage tim_imageWithBundleAsset:@"lamp"] forState:UIControlStateNormal];
//    [_btnLamp addTarget:self action:@selector(onBtnLampClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_btnLamp];
}

- (void)recordBtnLongPress:(UILongPressGestureRecognizer *)ges {
    CGFloat btnMarginBottom = kIsiPhoneX ? self.view.frame.size.height - BUTTON_RECORD_SIZE : self.view.frame.size.height - BUTTON_RECORD_SIZE + 10;
    if (ges.state == UIGestureRecognizerStateBegan) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self->_recordBtn.bounds = CGRectMake(0, 0, 105, 105);
            self->_recordBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.f, btnMarginBottom);
            self->_recordBtn.layer.cornerRadius = 52.5;
            
            self->_recordSubView.bounds = CGRectMake(0, 0, 35, 35);
            self->_recordSubView.center = CGPointMake(105/2.f, 105/2.f);
            self->_recordSubView.layer.cornerRadius = 17.5;
            
        } completion:^(BOOL finished) {
            
            [self circleAnimate];
            [self onBtnRecordStartClicked];
            
        }];
        
    } else if (ges.state == UIGestureRecognizerStateEnded) {
//        [self onBtnCloseClicked];
        [self onBtnRecordStartClicked];
        
        [UIView animateWithDuration:0.3 animations:^{
            self->_recordBtn.bounds = CGRectMake(0, 0, BUTTON_RECORD_SIZE, BUTTON_RECORD_SIZE);
            self->_recordBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.f, btnMarginBottom);
            self->_recordBtn.layer.cornerRadius = BUTTON_RECORD_SIZE/2.f;
            
            self->_recordSubView.bounds = CGRectMake(0, 0, 48, 48);
            self->_recordSubView.center = CGPointMake(BUTTON_RECORD_SIZE/2.f, BUTTON_RECORD_SIZE/2.f);
            self->_recordSubView.layer.cornerRadius = 24;
            
        }];
    }
}

- (void)circleAnimate {
    //第一步，通过UIBezierPath设置圆形的矢量路径
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 99, 99)];
    
    //第二步，用CAShapeLayer沿着第一步的路径画一个完整的环（颜色灰色，起始点0，终结点1）
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = CGRectMake(0, 0, 99, 99);//设置Frame
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
    _shapeLayer.frame = CGRectMake(0, 0, 99, 99);
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

-(void)onBtnRecordStartClicked
{
    _videoRecording = !_videoRecording;
    
    if (_videoRecording)
    {
        [self startVideoRecord];
    }
    else
    {
        [self stopVideoRecord];
    }
}

-(void)startCameraPreview
{
    if (_cameraPreviewing == NO)
    {
        //简单设置
        //        TXUGCSimpleConfig * param = [[TXUGCSimpleConfig alloc] init];
        //        param.videoQuality = VIDEO_QUALITY_MEDIUM;
        //        [[TXUGCRecord shareInstance] startCameraSimple:param preview:_videoRecordView];
        //自定义设置
        TXUGCCustomConfig * param = [[TXUGCCustomConfig alloc] init];
        param.videoResolution =  VIDEO_RESOLUTION_540_960;
        param.videoFPS = 25;
        param.videoBitratePIN = 1200;
        __weak typeof(_videoRecordView) _weakVideoRecordView = _videoRecordView;
//        [[TXUGCRecord shareInstance] startCameraCustom:param preview:_videoRecordView];
        [[TXUGCRecord shareInstance] startCameraCustom:param preview:_weakVideoRecordView];
        
        // 美颜
        [[TXUGCRecord shareInstance] setBeautyDepth:_beautyDepth WhiteningDepth:_whitenDepth];
        [[TXUGCRecord shareInstance] setEyeScaleLevel:_eye_level];
        [[TXUGCRecord shareInstance] setFaceScaleLevel:_face_level];
        
        _cameraPreviewing = YES;
    }
}

-(void)stopCameraPreview
{
    if (_cameraPreviewing == YES)
    {
        [[TXUGCRecord shareInstance] stopCameraPreview];
        _cameraPreviewing = NO;
    }
}

-(void)startVideoRecord {
    [self refreshRecordTime:0];
    [self startCameraPreview];
    [[TXUGCRecord shareInstance] startRecord];
}

-(void)stopVideoRecord {
    [[TXUGCRecord shareInstance] stopRecord];
}

-(void)onBtnCloseClicked
{
    [TXUGCRecord shareInstance].recordDelegate = nil;
    
    [self stopCameraPreview];
    [self stopVideoRecord];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)onBtnCameraClicked
{
    _cameraFront = !_cameraFront;
    
    if (_cameraFront) {
        [_btnCamera setImage:[UIImage tim_imageWithBundleAsset:@"cameraex"] forState:UIControlStateNormal];
    } else {
        [_btnCamera setImage:[UIImage tim_imageWithBundleAsset:@"cameraex_press"] forState:UIControlStateNormal];
    }
    
    [[TXUGCRecord shareInstance] switchCamera:_cameraFront];
}

-(void)onBtnLampClicked {
    _lampOpened = !_lampOpened;
    
    BOOL result = [[TXUGCRecord shareInstance] toggleTorch:_lampOpened];
    if (result == NO) {
        _lampOpened = !_lampOpened;
        [self toastTip:@"闪光灯启动失败"];
    }
    
    if (_lampOpened) {
        [_btnLamp setImage:[UIImage tim_imageWithBundleAsset:@"lamp_press"] forState:UIControlStateNormal];
    } else {
        [_btnLamp setImage:[UIImage tim_imageWithBundleAsset:@"lamp"] forState:UIControlStateNormal];
    }
}

// 刷新录像时间
-(void)refreshRecordTime:(int)second {
    _currentRecordTime = second;
    _shapeLayer.strokeEnd = (float)_currentRecordTime / MAX_RECORD_TIME;
}

#pragma mark ---- VideoRecordListener ----
-(void) onRecordProgress:(NSInteger)milliSecond;
{
    if (milliSecond > MAX_RECORD_TIME * 1000) {
        [self onBtnRecordStartClicked];
    } else {
        [self refreshRecordTime: (int)(milliSecond / 1000)];
    }
}

-(void) onRecordComplete:(TXRecordResult*)result;
{
    if (_appForeground) {
        if (_currentRecordTime >= MIN_RECORD_TIME) {
            if (result.retCode == RECORD_RESULT_OK) {
                [self.delegate recordVideoPath:result.videoPath];
//                TCVideoPreviewViewController *vc = [[TCVideoPreviewViewController alloc] initWith:kRecordType_Camera  coverImage:result.coverImage RecordResult:result];
//                vc.delegate = self;
//                [self.navigationController pushViewController:vc animated:YES];
                [self onBtnCloseClicked];
            } else {
                [self toastTip:@"录制失败"];
            }
        } else {
            [self toastTip:@"至少要录够5秒"];
        }
    }
    
    [self refreshRecordTime:0];
}
    
- (void)previewVideoPath:(NSString *)path {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordVideoPath:)]) {
        [self.delegate recordVideoPath:path];
    }
}

#pragma mark - Misc Methods

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void) toastTip:(NSString*)toastInfo
{
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = _recordBtn.origin.y - 44;
    frameRC.size.height -= 100;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self.view addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}

@end
