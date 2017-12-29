//
//  HDWJsonEditerPage.h
//  JSONEditer
//
//  Created by David on 2017/12/29.
//  Copyright © 2017年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HDWJsonEditerPage : UIViewController

@property (nonatomic, copy) NSString *jsonString;

@property (nonatomic, copy) void (^backJsonStringBlock)(NSString *backString);

@end
