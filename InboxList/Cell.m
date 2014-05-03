//
//  Cell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "Cell.h"


@interface Cell () {
    UIView *checkBoxTrue;
    UIView *checkBoxFalse;
}

- (void)setRightField;

@end


@implementation Cell

// 初期化する
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (self) {
        NSLog(@"%s", ">>> init Cell");

        // チェックボックスを初期化する
        int _checkbox_width = 40;
        checkBoxTrue = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                _checkbox_width,
                                                                _checkbox_width)];
        checkBoxFalse = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 _checkbox_width,
                                                                 _checkbox_width)];
        [checkBoxTrue setBackgroundColor:[UIColor redColor]];
        [checkBoxFalse setBackgroundColor:[UIColor blackColor]];
        
        CGFloat centerx = CGRectGetMidX(self.contentView.frame);
        CGFloat centery = CGRectGetMidY(self.contentView.frame);

        NSLog(@"%f %f", centerx, centery);
        [self.contentView setCenter:CGPointMake(centerx + _checkbox_width,
                                                centery)];
        
        // チェックボックスをビューに追加する
        [self.contentView addSubview:checkBoxFalse];

        // 右フィールドをビューに追加する
        [self setRightField];
    }
    return self;
}
- (id)init
{
    self = [super init];
    
    if (self) {
        NSLog(@"%s", ">>> init Cell");
        
        // チェックボックスを初期化する
        int _checkbox_width = 40;
        checkBoxTrue = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                _checkbox_width,
                                                                _checkbox_width)];
        checkBoxFalse = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 _checkbox_width,
                                                                 _checkbox_width)];
        [checkBoxTrue setBackgroundColor:[UIColor redColor]];
        [checkBoxFalse setBackgroundColor:[UIColor blackColor]];
        
        // チェックボックスをビューに追加する
        [self.contentView addSubview:checkBoxFalse];
        
        // 右フィールドをビューに追加する
        [self setRightField];
        
    }
    return self;
}

// フレームをセットする
-(void)setFrame:(CGRect)frame
{
    frame.origin.x += 40;
    frame.size.width -= 80;
    
    [super setFrame:frame];
}

// フィールドを追加する
- (void)setRightField
{
    // ビューを作成
    self.rightField = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [self.rightField setBackgroundColor:[UIColor redColor]];
    
    // ビューにセットする
    [self.contentView addSubview:self.rightField];
}

// タッチされた時の処理
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGFloat _left_side = 40;
    CGPoint location = [[touches anyObject] locationInView:self.contentView];
    
    NSLog(@"%f", location.x);
    if (location.x < _left_side) {
        ;
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

// チェックを付ける
- (void)turnChecked
{
    ;
}

// チェックを外す
- (void)turnUnchecked
{
    ;
}


@end