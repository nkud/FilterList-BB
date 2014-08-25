//
//  InputItemViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputItemViewController.h"
#import "TagFieldViewController.h"
#import "Header.h"
#import "TagSelectViewController.h"
#import "Tag.h"

@interface InputItemViewController ()

@end

@implementation InputItemViewController

/**
 * 初期化
 */
- (id)init {
  self = [super init];
  if (self) {
    self.view.backgroundColor = [UIColor colorWithWhite:1
                                                  alpha:1];
  }
  return self;
}

/**
 *  初期化
 *
 *  @param nibNameOrNil   <#nibNameOrNil description#>
 *  @param nibBundleOrNil <#nibBundleOrNil description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self)
  {
    // Custom initialization
  }
  return self;
}

/**
 * ビュー読み込み後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSString *tag_select_button_title = @"no tags selected";
  /// アイテム入力フィールド
  [self.titleInputField becomeFirstResponder];
  self.titleInputField.delegate = self;

  /// リマインダー入力ピッカーを初期化
  [self.remindPicker setDatePickerMode:UIDatePickerModeDateAndTime];

  /// 入力完了ボタン
  [self.saveButton addTarget:self
                      action:@selector(dismissInput)
            forControlEvents:UIControlEventTouchUpInside];

  [self.buttonTagSelectView addTarget:self
                               action:@selector(toTagSelectView)
                     forControlEvents:UIControlEventTouchUpInside];
  [self.buttonTagSelectView setTitle:tag_select_button_title
                            forState:UIControlStateNormal];
}

/**
 * @brief  タグ選択画面を表示する
 */
-(void)toTagSelectView
{
  LOG(@"タグ選択画面表示");
  TagSelectViewController *tagSelectViewController
  = [[TagSelectViewController alloc] initWithNibName:@"TagSelectViewController"
                                              bundle:nil];
  [self.navigationController pushViewController:tagSelectViewController
                                       animated:YES];
  [tagSelectViewController setDelegate:self];
  return;
}

/**
 * Returnが押された時の処理
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  NSLog(@"%s", __FUNCTION__);
  if (textField == self.titleInputField) { // アイテム名入力欄なら、
    [self dismissInput];
  }
  return YES;
}

/**
 * データを渡して入力画面を削除する
 */
- (void)dismissInput
{
  LOG(@"データを渡して入力画面を閉じる");
//  NSArray *_data = @[self.titleInputField.text, self.tagInputField.text];
//  [[self delegate] dismissInputModalView:self data:_data
//                                reminder:self.remindPicker.date];
  [[self delegate] dismissInputItemView:self.titleInputField.text
                    tagsForSelectedRows:self.selectedTags
                               reminder:self.remindPicker.date];
}

/**
 * @brief  タグ入力画面を終了する
 *
 * @param tagsForSelectedRows <#tagsForSelectedRows description#>
 */
-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  LOG(@"選択されたタグを更新する");
  NSMutableString *tags_title = [NSMutableString stringWithString:@""];
  for (Tag *tag in tagsForSelectedRows) {
    [tags_title appendFormat:@"%@ ", tag.title];
  }
  self.selectedTags = tagsForSelectedRows;
  self.selectedTagsLabel.text = tags_title;

  self.buttonTagSelectView.titleLabel.text = tags_title;
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
