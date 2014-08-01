//
//  TagFieldViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagFieldViewController.h"
#import "TagField.h"
#import "Header.h"

@interface TagFieldViewController () {
  int pointY;
  int field_height;
}

@end

@implementation TagFieldViewController

/**
 *  新しいテキストフィールド作成する
 *
 *  @param rect サイズ
 *
 *  @return テキストフィールド
 */
- (TagField *)createTextField:(CGRect)rect
{
  TagField *newTextField = [[TagField alloc] initWithFrame:rect];
  [newTextField setBorderStyle:UITextBorderStyleRoundedRect];
  [newTextField setReturnKeyType:UIReturnKeyDone];
  [newTextField setDelegate:self];
  [newTextField setText:nil];

  return newTextField;
}

/**
 *  初期化
 *
 *  @param nibNameOrNil   nibNameOrNil description
 *  @param nibBundleOrNil nibBundleOrNil description
 *
 *  @return コントローラー
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self)
    {
      self.textFieldArray = [[NSMutableArray alloc] initWithObjects:nil];
      pointY = 50;
      field_height = 30;
    }
    return self;
}

/**
 *  新しいテキストフィールドを追加する
 *
 *  @param rect サイズ
 */
- (void)addNewTextField:(CGRect)rect
{
  rect.origin.y = pointY;
  TagField *textField = [self createTextField:rect];

  [self.textFieldArray addObject:textField];

  [textField becomeFirstResponder];
  [textField stateInput];
  [UIView animateWithDuration:1.0f
                   animations:^{
                     [self.view addSubview:textField];
                   }
                   completion:^(BOOL finished) {
                     NSLog(@"%@", @"adding animation end.");
                   }];
//  [self.view addSubview:textField];
  pointY += field_height;
}

/**
 *  ビューをロードした後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self addNewTextField:CGRectMake(0, 100, SCREEN_BOUNDS.size.width, field_height)];
}

/**
 *  バックスペースが押された時の処理
 */
-(void)backspaceWillDown:(TagField *)sender
{
  TagField *field = [self.textFieldArray lastObject];
  if ([sender.text isEqual:@""] && [self.textFieldArray count] > 1 ) {
    [self deleteLastField];

    field = [self.textFieldArray lastObject];
    [field stateInput];
    [field becomeFirstResponder];
  }
}

/**
 *  フィールドを削除
 */
- (void)deleteLastField
{
  TagField *field = [self.textFieldArray lastObject];
  [field removeFromSuperview];
  [self.textFieldArray removeLastObject];
  pointY -= field_height;
}

/**
 *  リターンが押された時の処理
 *
 *  @param textField テキストフィールド
 *
 *  @return 真偽値
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ([textField.text isEqual:@""]) {
    [textField removeFromSuperview];
    [self.textFieldArray removeObject:textField];
    pointY -= field_height;
    return YES;
  }
  for (TagField *textField in self.textFieldArray) {
    [textField stateFixed];
  }
  [self addNewTextField:CGRectMake(0, 200, SCREEN_BOUNDS.size.width, field_height)];
  return YES;
}

/**
 *  メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/**
 *  入力文字列が変化した時の処理
 *
 *  @param textField 変化したテキストフィールド
 *  @param range     レンジ
 *  @param string    文字列？
 *
 *  @return 真偽値
 */
-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
  /**
   *  テキストフィールドの幅を変更する
   */
  CGRect new_rect = textField.frame;
  CGSize bounds = CGSizeMake(400, 200);
  UIFont *font = textField.font;
  new_rect.size.width = [textField.text boundingRectWithSize:bounds
                                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine
                                                  attributes:@{NSFontAttributeName:font}
                                                     context:nil].size.width +30. ;
  textField.frame = new_rect;
  return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
