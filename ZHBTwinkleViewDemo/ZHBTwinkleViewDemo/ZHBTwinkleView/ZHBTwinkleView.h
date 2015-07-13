//
//  ZHBTwinkleView.h
//  ZHBTwinkleViewDemo
//
//  Created by icode on 15/7/13.
//  Copyright (c) 2015年 zhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZHBTwinkleView;
@class ZHBTwinkleViewCell;

@protocol ZHBTwinkleViewDataSource <NSObject>

-(NSUInteger)numberOfRowsInZHBTwinkleView:(ZHBTwinkleView *)twinkleView;

-(ZHBTwinkleViewCell *)ZHBTwinkleView:(ZHBTwinkleView *)twinkleView twinkleViewcellAtIndex:(NSInteger)index;

@end

@protocol ZHBTwinkleViewDelegate <NSObject>

-(void)ZHBTwinkleView:(ZHBTwinkleView *)twinkleView didSelectedAtIndex:(NSInteger)index;

-(void)didTwinkleToLastIndex:(ZHBTwinkleView *)twinkleView;

@end

@interface ZHBTwinkleView : UIView

@property (nonatomic, weak) id<ZHBTwinkleViewDataSource> dataSource;

@property (nonatomic, weak) id<ZHBTwinkleViewDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval cycleTimeInterval;//闪烁周期

@property (nonatomic, assign) NSTimeInterval fadeTimeInterval;//透明度动画时长

@property (nonatomic, assign) NSInteger repeatTimes;//default = 1;


- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadData;

- (void)stopTwinkle;

@end

@interface ZHBTwinkleViewCell : UIView

@property (nonatomic,copy) NSString *reuseIdentifier;

@property (nonatomic,weak) UIView *contentView;

@property (nonatomic,weak) ZHBTwinkleView *twinkleView;

@property (nonatomic,assign) NSInteger index;

-(id)initWithIdentifier:(NSString *)identifier;

@end
