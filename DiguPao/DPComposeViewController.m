//
//  DPComposeViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/11/16.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPComposeViewController.h"
#import "DPComposeToolbar.h"
#import "UIView+Extension.h"
#import "AFOAuth2Manager.h"
#import "MBProgressHUD.h"
#import "DPComposeAlbumView.h"
#import "DPEmotionKeyboard.h"
#import "DPEmotion.h"
#import "NSString+Emoji.h"
#import "DPEmotionTextView.h"
#import <AliyunOSSiOS/OSSService.h>


//UINavigationControllerDelegate, UIImagePickerControllerDelegate两个代理都是为打开相机和打开相册服务的，必须同时声明代理

@interface DPComposeViewController () <UITextViewDelegate, DPComposeToolBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 输入控件 */
@property (nonatomic, strong) DPEmotionTextView *textView;
/** 键盘顶部工具条 */
@property (nonatomic, weak) DPComposeToolbar *toolBar;
/** 存放拍照或者从相册中选择的图片 */
@property (nonatomic, weak) DPComposeAlbumView *albumView;
/** 表情键盘 */
@property (nonatomic, strong) DPEmotionKeyboard *emotionKeyboard; // 一定要用强指针
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeyboard;

@end

@implementation DPComposeViewController

// 懒加载以保持始终有
- (UITextView *)textView {
    
    if (!_textView) {
        self.textView = [[DPEmotionTextView alloc] init];
    }
    return _textView;
}

#pragma - mark 懒加载
- (DPEmotionKeyboard *)emotionKeyboard {
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[DPEmotionKeyboard alloc] init];
        
        self.emotionKeyboard.width = self.view.width;
        self.emotionKeyboard.height = 216 + 44;  //键盘标准高度216
    }
    return _emotionKeyboard;
}

#pragma -mark 系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setupNavigationBar];
    // 添加输入控件
    [self setupTextView];
    // 添加工具条
    [self setupToolbar];
    // 添加相册
    [self setupAlbumView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    // 控制器销毁后就撤销监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma -mark 初始化方法
// 添加工具条
- (void)setupToolbar {
    
    DPComposeToolbar *toolbar = [[DPComposeToolbar alloc] init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    // 让工具条的代理是控制器自己 这样就可以实现点击按钮的代理方法
    toolbar.delegate = self;
    [self.view addSubview:toolbar];
    // inputView是设置键盘
//    self.textView.inputView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    // 设置显示在键盘顶部的内容
//    self.textView.inputAccessoryView = toolbar;
    self.toolBar = toolbar;
}

// 设置导航栏部分
- (void)setupNavigationBar {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(compose)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.title = @"发嘀咕";
}

// 添加输入控件
- (void)setupTextView {
    // 在此控制器中 textView的contentInset.top默认为64
    DPEmotionTextView *textView = [[DPEmotionTextView alloc] init];
    // 垂直方向上可以拖动 使得占位符可以下托
    textView.alwaysBounceVertical = YES;
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:16];
    textView.placeholder = @"嘀咕一下...";
    textView.placeholderColor = [UIColor grayColor];
    // 为了实现下拉时键盘退下
    textView.delegate = self;
    
    [self.view addSubview:textView];
    self.textView = textView;
    // 出现就调出键盘
    [textView becomeFirstResponder];
    
    // 监听文字改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    // 监听键盘通知 实现工具条随着键盘运动且不消失
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 监听PageView中表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:@"DPEmotionDidSelectedNotification" object:nil];
    // 监听来自pageView中删除按钮被点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:@"DPEmotionDidDeleteNotification" object:nil];

}

// 添加相册
- (void)setupAlbumView {
    
    DPComposeAlbumView *albumView = [[DPComposeAlbumView alloc] init];
    albumView.width = self.view.width;
    albumView.height = self.view.height; //随便写的 容纳图片即可
    albumView.y = 120;
//    albumView.backgroundColor = [UIColor blueColor];
    //photosView.backgroundColor = DGRandomColor;
    [self.textView addSubview:albumView];
    self.albumView = albumView;
    
}

#pragma -mark 监听方法
// 监听到文字改变后调用的方法
- (void)textDidChange {
    // 如果有文字 发送按钮就可用
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}

// 表情被选中了
- (void)emotionDidSelected:(NSNotification *)notification {
    
    DPEmotion *emotion = notification.userInfo[@"selectedEmotion"];
    NSLog(@"%@表情被选中了", emotion.chs);
    
    [self.textView insertEmotion:emotion];
    
}

// 监听表情键盘删除按钮的点击方法
- (void)emotionDidDelete {
    //
    [self.textView deleteBackward];
}

// 发送嘀咕方法
- (void)compose {
    
    if (self.albumView.photos.count) {
        // 如果相册中有图片
        [self composeWithImage];
    } else {
        // 如果相册中没有图片
        [self composeWithoutImage];
    
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

// 发送文字嘀咕方法
- (void)composeWithoutImage {
    
    // 获取地理位置
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    double latitudeDouble = [user doubleForKey:@"latitude"];
    double longtitudeDouble = [user doubleForKey:@"longtitude"];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", latitudeDouble];
    NSString *longtitude = [NSString stringWithFormat:@"%f", longtitudeDouble];
    
    // 获取token凭证
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    
    // 发起网络请求
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken;
    params[@"text"] = self.textView.fullText;
    params[@"latitude"] = latitude;
    params[@"longitude"]= longtitude;
    // 发起请求
    [manager POST:@"/api/v1/paopaos" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"发送嘀咕API调用成功: %@", responseObject);
        // 显示HUD提示成功
        [self showComposeSuccessHUD];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"发送嘀咕API调用失败: %@", error);
        // 显示HUD提示失败
        [self showComposeFailureHUD];
        
    }];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)composeWithImage {
    ////////////////////////////// 图片上传OSS /////////////////////////////////////////
    // 首先初始化OSSClient
    // 1.根据OSS区域地址设置endpoint
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    
    // 2.使用STS鉴权得到CredentialProvider
    id<OSSCredentialProvider> stsCredential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
        // 构造请求访问您的业务server
        NSURL * url = [NSURL URLWithString:@"http://123.56.97.99:3000/api/v1/pictures/sts"];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
        NSURLSession * session = [NSURLSession sharedSession];
        
        // 发送请求
        NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        if (error) {
                                                            [tcs setError:error];
                                                            NSLog(@"error!");
                                                            return;
                                                        }
                                                        NSLog(@"success");
                                                        [tcs setResult:data];
                                                    }];
        [sessionTask resume];
        
        // 需要阻塞等待请求返回
        [tcs.task waitUntilFinished];
        
        // 解析结果
        if (tcs.task.error) {
            NSLog(@"get token error: %@", tcs.task.error);
            return nil;
        } else {
            // 返回数据是json格式，需要解析得到token的各个字段
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                    options:kNilOptions
                                                                      error:nil];
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = [object objectForKey:@"access_key_id"];
            token.tSecretKey = [object objectForKey:@"access_key_secret"];
            token.tToken = [object objectForKey:@"security_token"];
            token.expirationTimeInGMTFormat = [object objectForKey:@"expiration"];
            NSLog(@"get token: %@", token);
            return token;
        }
    }];

    // 3.初始化OSSClient对象
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:stsCredential];
    
    // 然后实现多图上传
    // 4.结合NSOperationQueue设置operation间的依赖来实现多图上传
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 获得选取的图片
    NSArray *images = self.albumView.photos;
    queue.maxConcurrentOperationCount = images.count;
    NSLog(@"选中图片%lu个", (unsigned long)images.count);
    // 获取生成的图片名
    NSMutableArray *imageNames = [NSMutableArray array];
    
    // 利用NSOperationQueue实现多图上传
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                
                // 设置请求头bucketname和objectKey
                put.bucketName = @"paopaos";
                // 这句代码的意义？
                NSString *imageName = [@"paopaoImage" stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
                NSLog(@"imageName:%@", imageName);
                put.objectKey = imageName;
                // 将图片名记录到数组中
                // 生成字典再将字典加入数组
                NSMutableDictionary *pic = [NSMutableDictionary dictionary];
                pic[@"url"] = imageName;
                [imageNames addObject:pic];
                
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                put.uploadingData = data;
                
                OSSTask * putTask = [client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                if (!putTask.error) {
                    NSLog(@"upload object success!");
                } else {
                    NSLog(@"upload object failed, error: %@" , putTask.error);
                }
                
                if (image == images.lastObject) {
                    NSLog(@"upload object finished!");
                    
              ///////////////////// 图片名和文本信息发给应用服务器 ///////////////////////////
                    // 获取地理位置
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    double latitudeDouble = [user doubleForKey:@"latitude"];
                    double longtitudeDouble = [user doubleForKey:@"longtitude"];
                    
                    NSString *latitude = [NSString stringWithFormat:@"%f", latitudeDouble];
                    NSString *longtitude = [NSString stringWithFormat:@"%f", longtitudeDouble];
                    
                    // 获取token凭证
                    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
                    // 构建字符串
                    NSLog(@"composeWithImage with text:%@ latitude:%f,longtitude:%f",self.textView.fullText, latitudeDouble,longtitudeDouble);
                    // 发起网络请求
                    // 设置基础url
                    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
                    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
                    // 设置参数
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"access_token"] = credential.accessToken;
                    params[@"text"] = self.textView.fullText;
                    params[@"latitude"] = latitude;
                    params[@"longitude"]= longtitude;
                    // 设置关键的pictures_attributes参数
                    // imageNames是数组 数组中是一个个字典
                    // 字典只含有一个KVP
                    // key:url value:图片名
                    params[@"pictures"] = imageNames;
                    
                    NSLog(@"composeWithImage params:%@", params);
                    
                    // 发起请求
                    [manager POST:@"/api/v1/paopaos" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        
                        NSLog(@"发送含图片嘀咕API调用成功: %@", responseObject);
                        // 显示HUD提示成功
                        [self showComposeSuccessHUD];
                        
                        
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                        NSLog(@"发送含图片嘀咕API调用失败: %@", error);
                        // 显示HUD提示失败
                        [self showComposeFailureHUD];
                        
                    }];

                }
                
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
    
}

// 导航栏左边取消按钮
- (void)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 利用MBProgressHUD制作的显示通知的方法
- (void)showHUD:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    UIImage *image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.0];
}

// 显示发送成功
- (void)showComposeSuccessHUD {
    
    [self showHUD:@"发送成功" icon:@"Checkmark" view:nil];
}
// 显示发送失败
- (void)showComposeFailureHUD {
    
    [self showHUD:@"发送失败" icon:nil view:nil];
}

#pragma mark - UITextViewDelegate方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

// 监听键盘改变(显示和隐藏) 用于实现工具条随着键盘出现 键盘消失后工具条留着
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    // 如果正在切换键盘就不要执行后面代码 保持工具条y值
    if (self.switchingKeyboard) return;
    
    //DGLog(@"%@", notification);
    NSDictionary *userInfo = notification.userInfo;
    // 键盘隐藏/弹出耗费时间 0.25s
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘隐藏/弹出后的frame
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条Y值始终等于键盘Y减去工具条高度
        if (keyboardFrame.origin.y > self.view.height) {//防止键盘Y值超过控制器高度
            self.toolBar.y = self.view.height - self.toolBar.height;
        } else {
            self.toolBar.y = keyboardFrame.origin.y - self.toolBar.height;
        }
    }];
    
}

#pragma mark - DPComposeToolBarDelegate方法

- (void)composeToolBar:(DPComposeToolbar *)toolBar didClickButton:(DPComposeToolBarButtonType)buttonType {
    switch (buttonType) {
        case DPComposeToolBarButtonTypeCamera:
            NSLog(@"拍照");
            [self openCamera];
            break;
            
        case DPComposeToolBarButtonTypePicture:
            NSLog(@"相册");
            if (self.albumView.photos.count < 9) {
                [self openAlbum];
            } else {
                [self showHUD:@"最多9张图片" icon:nil view:nil];
            }
            
            break;
            
        case DPComposeToolBarButtonTypeMention:
            NSLog(@"@");
            break;
            
        case DPComposeToolBarButtonTypeTrend:
            NSLog(@"#");
            //[self showComposeFailureHUD];
            break;
            
        case DPComposeToolBarButtonTypeEmotion:
            [self switchKeyboard];
            break;
            
    }

    
}

#pragma mark - 工具条按钮点击方法

- (void)switchKeyboard {
    
    //self.textView.inputView == nil 表示使用的是系统自带键盘
    if (self.textView.inputView == nil) {// 如果使用的是系统自带键盘
        // x和y不用管 系统决定
        self.textView.inputView = self.emotionKeyboard;
        // 显按钮图片
        self.toolBar.showEmotionButton = NO;
    } else {// 使用的是系统自带键盘
        self.textView.inputView = nil;
        self.toolBar.showEmotionButton = YES;
    }
    // 开始切换键盘
    self.switchingKeyboard = YES;
    
    // 推出键盘
    [self.textView endEditing:YES];
    // 结束切换键盘
    self.switchingKeyboard = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
            });
}


- (void)openCamera {
    
    //如果想自己写图片选择器，要利用AssetsLibrary框架 利用框架可以获得手机上所有图片
    // 如果相机不可用 返回
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)openAlbum {
    // 如果想自己写图片选择控制器 得利用AssetsLibrary.framework 可获得手机上所有图片
    //UIImagePickerControllerSourceTypePhotoLibrary > UIImagePickerControllerSourceTypeSavedPhotosAlbum
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

// 从UIImagePickerController拍照完毕和选择相册完毕调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // info中包含了选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    // 添加图片到photosView中
    [self.albumView addPhoto:image];
    
}

@end














