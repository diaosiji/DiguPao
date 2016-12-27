//
//  DPChangeIconViewController.m
//  DiguPao
//
//  Created by 屌斯基 on 2016/12/26.
//  Copyright © 2016年 intelligentunit. All rights reserved.
//

#import "DPChangeIconViewController.h"
#import "UIView+Extension.h"
#import <AFNetworking/AFNetworking.h>
#import "AFOAuth2Manager.h"
#import <AliyunOSSiOS/OSSService.h>
#import "MBProgressHUD.h"

@interface DPChangeIconViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIImageView *myHeadPortrait;

@end

@implementation DPChangeIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    //  调用setHeadPortrait方法
    [self setHeadPortrait];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置导航栏部分
- (void)setupNavigationBar {
    
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(changeIcon)];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}
//  方法：设置头像样式
-(void)setHeadPortrait{
    // 设置尺寸
    UIImageView *myHeadPortrait = [[UIImageView alloc] init];
    myHeadPortrait.width = 130;
    myHeadPortrait.height = 130;
    myHeadPortrait.centerX =[UIScreen mainScreen].bounds.size.width / 2;
    myHeadPortrait.y = 150;
    
    myHeadPortrait.backgroundColor = [UIColor grayColor];
    
    //  把头像设置成圆形
    myHeadPortrait.layer.cornerRadius = myHeadPortrait.frame.size.width/2;
    myHeadPortrait.layer.masksToBounds = YES;
    //  给头像加一个圆形边框
    myHeadPortrait.layer.borderWidth = 1.5f;
    myHeadPortrait.layer.borderColor = [UIColor orangeColor].CGColor;
    
    /**
     *  添加手势：也就是当用户点击头像了之后，对这个操作进行反应
     */
    //允许用户交互
    myHeadPortrait.userInteractionEnabled = YES;
    
    //初始化一个手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(alterHeadPortrait:)];
    
    //给imageView添加手势
    [myHeadPortrait addGestureRecognizer:singleTap];
    
    self.myHeadPortrait = myHeadPortrait;
    [self.view addSubview:myHeadPortrait];
}

//  方法：alterHeadPortrait
-(void)alterHeadPortrait:(UITapGestureRecognizer *)gesture{
    /**
     *  弹出提示框
     */
    //初始化提示框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    self.myHeadPortrait.image = newPhoto;
//    [self changeIcon];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeIcon {
    //////////////////////////// 初始化OSSClient //////////////////////////////////
    // 1.根据OSS区域地址设置endpoint
    NSString *endpoint = @"http://oss-cn-beijing.aliyuncs.com";
    
    // 2.用阿里云颁发的AccessKeyId和AccessKeySecret构造一个CredentialProvider
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的访问控制章节≤
    //    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:@"LTAIv2K9MJoamoFT" secretKey:@"NvMuE4F5Qhe8KKjD6ckbyfJIpInutx"];
    
    // 使用STS鉴权得到CredentialProvider
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
    
    
    
    // 3.可以在初始化的时候设置网络参数
    //    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    //    conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
    //    conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
    //    conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
    
    // 4.初始化OSSClient对象
    //    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential clientConfiguration:conf];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:stsCredential];
    //////////////////////////// 实现上传文件到OSS服务器 //////////////////////////////////
    // 1.初始化上传Object的请求头
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    
    put.bucketName = @"paopaos";
    NSString *imageName = [@"iocnImage" stringByAppendingPathComponent:[[NSUUID UUID].UUIDString stringByAppendingString:@".jpg"]];
    NSLog(@"imageName:%@", imageName);
    put.objectKey = imageName;
    
    // 2.将本地的图片资源打包为NSData
    UIImage *image = self.myHeadPortrait.image;
    NSData *data = UIImageJPEGRepresentation(image, 5.0);
    
    // 3.直接上传NSData
    put.uploadingData = data;
    
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"upload icon success!");
        } else {
            NSLog(@"upload icon failed, error: %@" , task.error);
        }
        return nil;
    }];
    
    // 可以等待任务完成
     [putTask waitUntilFinished];
    
    ///////////// 将图片名发送给应用服务器 ////////////////
    // 获取含accessToken的凭证对象
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:@"OAuthCredential"];
    // 设置基础url
    NSURL *baseURL = [NSURL URLWithString:@"http://123.56.97.99:3000"];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    // 设置参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = credential.accessToken; // 参数肯定需要accessToken
    params[@"avatar"] = imageName;
    
    
    [manager POST:@"/api/v1/users/me" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"头像修改成功:%@",responseObject);
        [self showHUD:@"成功上传头像" icon:nil view:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"头像修改失败");
        [self showHUD:@"上传头像失败" icon:nil view:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
    


    
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


@end























