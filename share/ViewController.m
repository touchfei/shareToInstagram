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
    [self shareToInstagramByImage:@"my_qq"];
    
}

- (void)loadInstagramByWebview{
//    NSURL *url = [NSURL URLWithString:@"tel://10086"];
    NSURL *url = [NSURL URLWithString:@"instagram://media?id=1"];
    UIWebView *web = [[UIWebView alloc]init];
    [web loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:web];
}

#pragma mark - instagram share

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



-(void)shareToInstagramByDocumentImage:(NSString *)imageStr{
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]){// 判断是否安装了Instagram
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{// 子线程写入数据
            
            UIImage *image = [UIImage imageNamed:imageStr];
            NSString *name = [NSString stringWithFormat:@"%f%u.igo",[NSDate timeIntervalSinceReferenceDate],arc4random_uniform(1000)];
            NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:name];
            
            [UIImagePNGRepresentation(image) writeToFile:savePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{// 主线程显示视图
                self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
                self.documentInteractionController.UTI = @"com.instagram.exclusivegram";
                self.documentInteractionController.delegate = self;
                [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            });
        });
        
    }else{
        NSLog(@"did not install instagram");
        [self showAlterWithStr:@"did not install instagram"];
    }
}

-(void)shareToInstagramByImage:(NSString *)imageStr{
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIImage *image = [UIImage imageNamed:imageStr];
            NSString *name = [NSString stringWithFormat:@"%f%u.ig",[NSDate timeIntervalSinceReferenceDate],arc4random_uniform(1000)];
            NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:name];
            
            [UIImagePNGRepresentation(image) writeToFile:savePath atomically:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
                self.documentInteractionController.UTI = @"com.instagram.photo";
                self.documentInteractionController.delegate = self;
                [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
            });
        });
        
    }else{
        NSLog(@"did not install instagram");
        [self showAlterWithStr:@"did not install instagram"];
    }
}


-(void)shareToInstagramByDocumentnNameWith:(NSString *)imageName{
    
    NSURL *instagramUrl = [NSURL URLWithString:@"instagram://app"];
    
    
    if ([[UIApplication sharedApplication] canOpenURL:instagramUrl]){
        
        NSString  *jpgPath = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        NSURL *imageUrl = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", jpgPath]];
        
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:imageUrl];
        self.documentInteractionController.UTI = @"com.instagram.photo";
        self.documentInteractionController.delegate = self;
        
        [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    }else{
        NSLog(@"did not install instagram");
        [self showAlterWithStr:@"did not install instagram"];
    }
}

#pragma mark - IDocumentInteractionControllerDelegate

-(void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application{
    NSLog(@"%s",__func__);
    // 判断是否返回应用
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"%s",__func__);
}
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller{
    NSLog(@"%s",__func__);
}

#pragma mark - show error

- (void)showAlterWithStr:(NSString *)str{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
