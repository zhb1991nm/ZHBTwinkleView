//
//  ViewController.m
//  ZHBTwinkleViewDemo
//
//  Created by icode on 15/7/13.
//  Copyright (c) 2015年 zhb. All rights reserved.
//

#import "ViewController.h"

CGPoint CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

@interface ViewController ()<ZHBTwinkleViewDataSource,ZHBTwinkleViewDelegate>

@property (nonatomic,strong) ZHBTwinkleView *twinkleView;

@end

@implementation ViewController{
    NSArray *dataArray;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //<font size=12 color=#000000>上证指数</font> <font size=12 color=#FF0000><b>3991.567</b> <b>+113.76</b> <b>+2.93%</font>
    dataArray = @[@"<font size=12 color=#000000>深证成指</font> <font size=12 color=#FF0000><b>12609.317</b> <b>+571.17</b> <b>+4.74%</font>",
                  @"<font size=12 color=#000000>中小板指</font> <font size=12 color=#FF0000><b>8394.226</b> <b>+392.76</b> <b>+4.91%</font>",
                  @"<font size=12 color=#000000>创业板指</font> <font size=12 color=#FF0000><b>2675.845</b> <b>+139.96</b> <b>+5.52%</font>",
                  @"<font size=12 color=#000000>沪深300</font> <font size=12 color=#FF0000><b>4232.623</b> <b>+126.07</b> <b>+3.07%</font>"];
    self.navigationItem.titleView = self.twinkleView;
    [self.twinkleView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ZHBTwinkleViewDataSource

-(NSUInteger)numberOfRowsInZHBTwinkleView:(ZHBTwinkleView *)twinkleView{
    return dataArray.count;
}

-(ZHBTwinkleViewCell *)ZHBTwinkleView:(ZHBTwinkleView *)twinkleView twinkleViewcellAtIndex:(NSInteger)index{
    static NSString *identifier = @"identifier";
    CustomTwinkleViewCell *cell = [twinkleView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CustomTwinkleViewCell alloc] initWithIdentifier:identifier];
    }
    cell.contentLabel.text = dataArray[index];
    return cell;
}

#pragma mark - ZHBTwinkleViewDelegate

-(void)ZHBTwinkleView:(ZHBTwinkleView *)twinkleView didSelectedAtIndex:(NSInteger)index{
    NSLog(@"选择了第%ld条",(long)index);
}

-(void)didTwinkleToLastIndex:(ZHBTwinkleView *)twinkleView{
    NSLog(@"滚动到最后一条");
}

#pragma mark - getter & setter
-(ZHBTwinkleView *)twinkleView{
    if (!_twinkleView) {
        _twinkleView = [[ZHBTwinkleView alloc] initWithFrame:CGRectMake(50, 0, self.view.bounds.size.width - 100, 20)];
        _twinkleView.backgroundColor = [UIColor clearColor];
        _twinkleView.cycleTimeInterval = 1.0f;
        _twinkleView.fadeTimeInterval = 0.3f;
        _twinkleView.repeatTimes = NSIntegerMax;
        _twinkleView.dataSource = self;
        _twinkleView.delegate = self;
    }
    return _twinkleView;
}

@end

@implementation CustomTwinkleViewCell

-(id)initWithIdentifier:(NSString *)identifier{
    self = [super initWithIdentifier:identifier];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentLabel.frame = CGRectMake(0, 0, self.contentLabel.frame.size.width, self.contentLabel.optimumSize.height);
    self.contentLabel.center = CGRectGetCenter(self.contentView.bounds);
    
}

#pragma mark - getter & setter
-(RTLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[RTLabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = RTTextAlignmentRight;
        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _contentLabel.userInteractionEnabled = NO;
    }
    return _contentLabel;
}

@end
