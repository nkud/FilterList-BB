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
 *  入力された文字列を返す
 *
 *  @return 文字列のセット
 */
-(NSSet *)getFields
{
  NSMutableSet *fields = [[NSMutableSet alloc] init];
  for (UITextField *field in self.textFieldArray) {
    [fields addObject:field.text];
  }
  return fields;
}

/**
 *  新しいテキストフィールド作成する
 *
 *  @param rect サイズ
 *
 *  @return テキストフィールド
 */
- (TagField *)createTextFieldWithFrame:(CGRect)frame
{
  LOG(@"テキストフィールドを作成");
  TagField *newTextField = [[TagField alloc] initWithFrame:frame];
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

    }
    return self;
}

/**
 *  テキストフィールド以外がタッチされた時の処理
 *
 *  @param touches <#touches description#>
 *  @param event   <#event description#>
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  LOG(@"テキストフィールド以外をタッチ");
}

/**
 *  新しいテキストフィールドを追加する
 *
 *  @param rect サイズ
 */
- (void)addNewTextField
{
  LOG(@"新しいテキストフィールドを追加");
  CGRect rect = CGRectMake(0, pointY, SCREEN_BOUNDS.size.width, field_height);
  TagField *textField = [self createTextFieldWithFrame:rect];

  [self.textFieldArray addObject:textField];

  [textField becomeFirstResponder];
  [textField stateInput];
//  [UIView animateWithDuration:1.0f
//                   animations:^{
//                     [self.view addSubview:textField];
//                   }
//                   completion:^(BOOL finished) {
//                   }];
  [self.view addSubview:textField];
  pointY += field_height;
}

/**
 *  ビューをロードした後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  CGRect rect = self.view.frame;
  rect.origin.y += 100;
  self.view.frame = rect;
  self.view.backgroundColor = [UIColor grayColor];
  self.textFieldArray = [[NSMutableArray alloc] initWithObjects:nil];
  pointY = self.view.frame.origin.y;
  field_height = 30;
  LOG(@"初期フィールドを作成・追加");
//  CGRect view_rect = self.view.frame;
//  CGRect field_rect = view_rect;
//  field_rect.size.width = SCREEN_BOUNDS.size.width;
//  field_rect.size.height = field_height;
  [self addNewTextField];
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
  // 空欄の場合
  if ([textField.text isEqual:@""]) {
    [textField removeFromSuperview];
    [self.textFieldArray removeObject:textField];
    pointY -= field_height;
    return YES;
  }
  // 追加する場合
//  [self addNewTextField:CGRectMake(0, 200, SCREEN_BOUNDS.size.width, field_height)];
  [self addNewTextField];
  LOG(@"テキストフィールド数: %ul", [self.textFieldArray count]);
  NSMutableArray *stock = [NSMutableArray arrayWithArray:self.textFieldArray];
  [stock removeObject:[stock lastObject]];
  for (TagField *textField in stock) {
    [textField stateFixed];
  }

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
  LOG(@"テキストフィールドの幅を変更");
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
