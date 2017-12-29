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
        //
    }];
}


@end
