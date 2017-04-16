//
//  ViewController.m
//  share
//
//  Created by GaoFei on 2017/4/16.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIDocumentInteractionControllerDelegate>
@property(nonatomic, strong)UIDocumentInteractionController *documentInteractionController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)selectShared:(UIButton *)sender {
    
//    [self loadInstagramByWebview];
    [self loadInstagram];
//    [self shareByDocument];
    
}

- (void)loadInstagramByWebview{
//    NSURL *url = [NSURL URLWithString:@"tel://10086"];
    NSURL *url = [NSURL URLWithString:@"instagram://media?id=1"];
    UIWebView *web = [[UIWebView alloc]init];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];
}



/**
 如果你的应用使用了如SSO授权登录或跳转到第三方分享功能，
 在iOS9/10下就需要增加一个可跳转的白名单，即LSApplicationQueriesSchemes，否则将在SDK判断是否跳转时用到的canOpenURL时返回NO，进而只进行webview授权或授权/分享失败。 
 在项目中的info.plist中加入应用白名单，右键info.plist选择source code打开(plist具体设置在Build Setting -> Packaging -> Info.plist File可获取plist路径)配置如下文件:
 
 <key>LSApplicationQueriesSchemes</key>
 <array>
    <string>instagram</string>
 </array>
 
 */
-(void)loadInstagram{
        NSURL *url = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        NSLog(@"did not install instagram");
    }

}


-(void)shareByDocument{
    UIImage *image = [UIImage imageNamed:@"my_qq"];
   NSString *imagesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString* filename = [NSString stringWithFormat:@"testImage.igo"];
    NSString* savePath = [imagesPath stringByAppendingPathComponent:filename];
    [UIImagePNGRepresentation(image) writeToFile:savePath atomically:YES];
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]){
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        self.documentInteractionController.UTI = @"com.instagram.exclusivegram";
        self.documentInteractionController.delegate = self;
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }else{
        NSLog(@"did not install instagram");
    }
}

-(void)shareByDocument2{
    UIImage *image = [UIImage imageNamed:@"my_qq"];
    NSString *imagesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString* filename = [NSString stringWithFormat:@"testImage.ig"];
    NSString* savePath = [imagesPath stringByAppendingPathComponent:filename];
    [UIImagePNGRepresentation(image) writeToFile:savePath atomically:YES];
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]){
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        self.documentInteractionController.UTI = @"com.instagram.photo";
        self.documentInteractionController.delegate = self;
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }else{
        NSLog(@"did not install instagram");
    }
}


-(void)shareByDocument3{

    NSURL *instagramUrl = [NSURL URLWithString:@"instagram://app"];
    NSString  *jpgPath = [[NSBundle mainBundle] pathForResource:@"my_qq.png" ofType:nil];
    NSURL *imageUrl = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramUrl]){
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:imageUrl];
        self.documentInteractionController.UTI = @"com.instagram.photo";
        self.documentInteractionController.delegate = self;
        
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }else{
        NSLog(@"did not install instagram");
    }
}


@end
