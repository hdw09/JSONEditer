//
//  ViewController.m
//  JSONEditer
//
//  Created by David on 2017/12/26.
//  Copyright © 2017年 David. All rights reserved.
//

#import "ViewController.h"
#import "HDWJsonEditerPage.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIButton *openJsonEditer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)openJsonEditer:(id)sender
{
    HDWJsonEditerPage * editerPage = [[HDWJsonEditerPage alloc] init];
    [self presentViewController:editerPage animated:YES completion:^{
        editerPage.jsonString = @"{'data':{'imgUrl':'https://p1.meituan.net/pmsicon/e8dd6c2ee72a40f0b40a3c21fad79e58.jpg','currentTime':1499342461100,'redirectUrl':'http://www.baidu.com','id':'101012991901'}}";
    }];
}


@end
