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
    if (self) {
      // Custom initialization
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
  NSLog(@"%s", __FUNCTION__);
  rect.origin.y = pointY;
  TagField *textField = [self createTextField:rect];

  [self.textFieldArray addObject:textField];

  [textField becomeFirstResponder];
  NSLog(@"%@", self.textFieldArray);
  [self.view addSubview:textField];
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

-(void)backspaceWillDown
{
  TagField *field = [self.textFieldArray lastObject];
  if ([field.text isEqual:@""] && [self.textFieldArray count] > 1 ) {
    [self deleteLastField];
    [[self.textFieldArray lastObject] becomeFirstResponder];
  }
}

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
 *  @param textField <#textField description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ([textField.text isEqual:@""]) {
    [textField removeFromSuperview];
    [self.textFieldArray removeObject:textField];
    pointY -= field_height;
    return NO;
  }
  for (UITextField *textField in self.textFieldArray) {
    [textField setBackgroundColor:RGBA(255, 255, 255, 0.5)];
    NSLog(@"%@", textField.text);
  }
  [self addNewTextField:CGRectMake(0, 200, SCREEN_BOUNDS.size.width, field_height)];
  return NO;
}

/**
 *  メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
