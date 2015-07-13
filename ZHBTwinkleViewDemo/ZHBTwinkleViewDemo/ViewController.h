//
//  ViewController.h
//  ZHBTwinkleViewDemo
//
//  Created by icode on 15/7/13.
//  Copyright (c) 2015年 zhb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHBTwinkleView.h"
#import "RTLabel.h"

@interface ViewController : UIViewController

@end

@interface CustomTwinkleViewCell : ZHBTwinkleViewCell

@property (nonatomic,strong) RTLabel *contentLabel;

@end
