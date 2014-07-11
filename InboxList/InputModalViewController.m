//
//  InputModalViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/07.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "InputModalViewController.h"

@interface InputModalViewController ()

@end

@implementation InputModalViewController

/**
 * 初期化
 */
- (id)init {
  self = [super init];
  if (self) {
    self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

/**
 * ビュー読み込み
 */
- (UITextField *)createTextField:(int)x y:(int)y
{
  UITextField *_newTextField;
  _newTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 100, 40)];
  [_newTextField setBorderStyle:UITextBorderStyleRoundedRect];
  [_newTextField setReturnKeyType:UIReturnKeyDone];
  [_newTextField setDelegate:self];
  [_newTextField setText:nil];
  return _newTextField;
}

/**
 * ビュー読み込み後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];

  /// アイテム入力フィールド
  self.textField = [self createTextField:0 y:100];
  [self.textField becomeFirstResponder];
  [self.view addSubview:self.textField];

  /// タグ入力フィールド
  self.tagInputField = [self createTextField:0 y:150];
  [self.view addSubview:self.tagInputField];

  /// リマインダー入力ピッカーを初期化
  self.remindPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 200, 0, 0)];
  [self.remindPicker setDatePickerMode:UIDatePickerModeDateAndTime];
  [self.view addSubview:self.remindPicker];

  /// 入力完了ボタン
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setFrame:CGRectMake(0, 30, 100, 50)];
  [button setTitle:@"Done" forState:UIControlStateNormal];
  [button addTarget:self
             action:@selector(dismissInput)
   forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];
}

/**
 * Returnが押された時の処理
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if (textField == self.textField) { // アイテム名入力欄なら、
    [self dismissInput];
  } else if (textField == self.tagInputField) { // タグ入力時なら、
    [self.textField becomeFirstResponder]; // アイテム名入力欄に移動する
  }
  return YES;
}

/**
 * データを渡してビューを削除する
 */
- (void)dismissInput
{
  NSArray *_data = @[self.textField.text, self.tagInputField.text];
  [[self delegate] dismissInputModalView:self data:_data];
}

/**
 * メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
