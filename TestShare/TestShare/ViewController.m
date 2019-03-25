//
//  ViewController.m
//  TestShare
//
//  Created by lilun on 2019/3/22.
//  Copyright © 2019年 lilun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)prepareShareVidoData:(NSString *)soureName  target:(NSString *)targetName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:soureName ofType:@""];
    NSURL *Url = [NSURL fileURLWithPath:path];
    
    NSString *topath = [NSTemporaryDirectory() stringByAppendingPathComponent:targetName];
    NSMutableData *mutData = [[NSData dataWithContentsOfURL:Url] mutableCopy];
    [mutData writeToURL:[NSURL fileURLWithPath:topath] options:NSDataWritingAtomic|NSDataWritingFileProtectionNone error:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //36.mp4 是可以压缩，所以可以分享成功
    //28.mp4 无法进行压缩，分享失败
    //猜测原因是因为手Q和微信的分享视频逻辑导致，过小的视频文件大小压缩失败，将会导致分享失败
    //分享28.mp4到微信的时候，控制台输出错误 [QQShare]compressVideoAtURL:压缩失败, 原因:Error Domain=AVFoundationErrorDomain Code=-11800 "The operation could not be completed" UserInfo={NSLocalizedFailureReason=An unknown error occurred (-12780), NSLocalizedDescription=The operation could not be completed, NSUnderlyingError=0x280682ac0 {Error Domain=NSOSStatusErrorDomain Code=-12780 "(null)"}}
    
    [self prepareShareVidoData:@"28.mp4" target:@"share28.mp4"];
    [self prepareShareVidoData:@"36.mp4" target:@"share36.mp4"];


}

- (void)testShare:(NSString *)videoName
{
    
    

    NSString *topath = [NSTemporaryDirectory() stringByAppendingPathComponent:videoName];
    NSURL *Url = [NSURL fileURLWithPath:topath];
    NSArray *activityItems = @[Url];

    NSLog(@"path %@ %d", topath, [[NSFileManager defaultManager] fileExistsAtPath:topath]);
    //can present
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    NSMutableArray *array = [@[ UIActivityTypePostToFacebook     ,
                                UIActivityTypePostToTwitter      ,
                                UIActivityTypePostToWeibo        ,    // SinaWeibo
                                //                             UIActivityTypeMessage            ,
                                //                             UIActivityTypeMail               ,
                                UIActivityTypePrint              ,
                                UIActivityTypeCopyToPasteboard   ,
                                UIActivityTypeAssignToContact    ,
                                UIActivityTypeSaveToCameraRoll   ,
                                UIActivityTypeAddToReadingList   ,
                                UIActivityTypePostToFlickr       ,
                                UIActivityTypePostToVimeo        ,
                                UIActivityTypePostToTencentWeibo ,
                                //                             UIActivityTypeAirDrop            ,
                                //                             UIActivityTypeOpenInIBooks 9.0
                                ] mutableCopy];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_3) {
        [array addObject:UIActivityTypeOpenInIBooks];
    }
    
    UIPopoverPresentationController *popover = activityVC.popoverPresentationController;
    if (popover ) {
        popover.sourceView = self.view;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    activityVC.excludedActivityTypes = array;
    __weak typeof(UIViewController *) weakVC = activityVC;
    [activityVC setCompletionWithItemsHandler:^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        [weakVC dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
- (IBAction)share28Clicked:(id)sender {
    [self testShare:@"share28.mp4"];

}

- (IBAction)share36Clicked:(id)sender {
    [self testShare:@"share36.mp4"];

}

@end
