//
//  ZHBTwinkleView.m
//  ZHBTwinkleViewDemo
//
//  Created by icode on 15/7/13.
//  Copyright (c) 2015年 zhb. All rights reserved.
//

#import "ZHBTwinkleView.h"

static  NSString const * ZHBTwinkleViewAnimationGroupKey = @"ZHBTwinkleViewAnimationGroupKey";


@interface ZHBTwinkleView()

@property (nonatomic,assign) NSUInteger count;

@property (nonatomic,assign) NSUInteger index;

@property (nonatomic,weak) ZHBTwinkleViewCell *currentCell;


@end

@implementation ZHBTwinkleView{
    NSMutableDictionary *reuseDict;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.cycleTimeInterval = 5.0f;
        self.fadeTimeInterval = 0.4f;
        reuseDict = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    if (!identifier || [@"" isEqualToString:identifier]) {
        return nil;
    }
    ZHBTwinkleViewCell *cell = [reuseDict objectForKey:identifier];
    return cell;
}

-(void)reloadData{
    self.index = 0;
    self.count = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfRowsInZHBTwinkleView:)]) {
        self.count = [self.dataSource numberOfRowsInZHBTwinkleView:self];
    }
    if (self.count == 0) {
        if (self.subviews.count > 0 ) {
            ZHBTwinkleViewCell *cell = self.subviews.firstObject;
            [cell.contentView.layer removeAnimationForKey:[ZHBTwinkleViewAnimationGroupKey copy]];
            reuseDict = [NSMutableDictionary dictionaryWithCapacity:10];
        }
        return;
    }
    [self updateContent];
}

-(void)stopTwinkle{
    if (self.subviews.count > 0 ) {
        ZHBTwinkleViewCell *cell = self.subviews.firstObject;
        [cell.contentView.layer removeAnimationForKey:[ZHBTwinkleViewAnimationGroupKey copy]];
    }
}

-(void)updateContent{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(ZHBTwinkleView:twinkleViewcellAtIndex:)] && self.index < self.count) {
        ZHBTwinkleViewCell *cell = [self.dataSource ZHBTwinkleView:self twinkleViewcellAtIndex:_index];
        cell.frame = self.bounds;
        cell.twinkleView = self;
        cell.index = _index;
        [reuseDict setObject:cell forKey:cell.reuseIdentifier];
        [self addSubview:cell];
        [cell layoutSubviews];
        cell.contentView.alpha = 0.0;
        CAAnimationGroup *animationGroup = [self animationGroupWithDuration:self.cycleTimeInterval repeatCount:1];
        if (_index != _count - 1) {
            animationGroup.animations = @[[self animationWithOpacityFrom:0.0 To:1.0 Duration:self.fadeTimeInterval BeginTime:0],
                                          [self animationWithOpacityFrom:1.0 To:1.0 Duration:self.cycleTimeInterval - self.fadeTimeInterval*2  BeginTime:self.fadeTimeInterval],
                                          [self animationWithOpacityFrom:1.0 To:0.0 Duration:self.fadeTimeInterval BeginTime:self.cycleTimeInterval - self.fadeTimeInterval]];
        }else{
            animationGroup.animations = @[[self animationWithOpacityFrom:0.0 To:1.0 Duration:self.fadeTimeInterval BeginTime:0],
                                          [self animationWithOpacityFrom:1.0 To:1.0 Duration:self.cycleTimeInterval - self.fadeTimeInterval BeginTime:self.fadeTimeInterval]];
        }
        [cell.contentView.layer addAnimation:animationGroup forKey:[ZHBTwinkleViewAnimationGroupKey copy]];
        self.currentCell = cell;
    }else{
        return;
    }
}

#pragma mark - override
-(void)removeFromSuperview{
    [super removeFromSuperview];
    [self stopTwinkle];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (!flag) {
        return;
    }
    [_currentCell.contentView.layer removeAnimationForKey:[ZHBTwinkleViewAnimationGroupKey copy]];
    if (self.index + 1 == self.count) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didTwinkleToLastIndex:)]) {
            [self.delegate didTwinkleToLastIndex:self];
        }
    }else{
        self.index ++;
        [self updateContent];
    }
}

#pragma mark - getter & setter

-(CAAnimation *)animationWithOpacityFrom:(CGFloat) from To:(CGFloat) to Duration:(CGFloat) duration BeginTime:(CGFloat)beginTime

{
    
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    theAnimation.duration=duration;
    
    theAnimation.beginTime = beginTime;
    
    theAnimation.repeatCount=0;
    
    theAnimation.autoreverses=NO;
    
    theAnimation.fromValue=[NSNumber numberWithFloat:from];
    
    theAnimation.toValue=[NSNumber numberWithFloat:to];
    
    
    
    return theAnimation;
    
}

-(CAAnimationGroup *)animationGroupWithDuration:(NSTimeInterval)duration repeatCount:(NSInteger)repeatCount{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode  = kCAFillModeForwards;
    animationGroup.duration = duration;
    animationGroup.repeatCount = repeatCount;
    return animationGroup;
}

-(void)setCycleTimeInterval:(NSTimeInterval)cycleTimeInterval{
    if (cycleTimeInterval < 1) {
        cycleTimeInterval = 1;
    }
    _cycleTimeInterval = cycleTimeInterval;
}

-(void)setFadeTimeInterval:(NSTimeInterval)fadeTimeInterval{
    if (fadeTimeInterval >= _cycleTimeInterval/2) {
        fadeTimeInterval = _cycleTimeInterval/2;
    }
    _fadeTimeInterval = fadeTimeInterval;
}

@end

@interface ZHBTwinkleViewCell()

@property (nonatomic,strong) UIButton *tapButton;

@end

@implementation ZHBTwinkleViewCell

-(id)initWithIdentifier:(NSString *)identifier{
    self = [super init];
    if (self) {
        self.reuseIdentifier = identifier;
        UIView *contentView = [[UIView alloc] initWithFrame:self.bounds];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentView];
        _contentView = contentView;
        [self addSubview:self.tapButton];
    }
    return self;
}

-(void)tap:(UIButton *)sender{
    if (self.twinkleView) {
        if (self.twinkleView.delegate && [self.twinkleView.delegate respondsToSelector:@selector(ZHBTwinkleView:didSelectedAtIndex:)]) {
            [self.twinkleView.delegate ZHBTwinkleView:self.twinkleView didSelectedAtIndex:self.index];
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self bringSubviewToFront:self.tapButton];
}

#pragma mark - getter & setter
-(UIButton *)tapButton{
    if (!_tapButton) {
        _tapButton = [[UIButton alloc] initWithFrame:self.bounds];
        _tapButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tapButton.backgroundColor = [UIColor clearColor];
        [_tapButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapButton;
}

@end
