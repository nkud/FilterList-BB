//
//  InputFilterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/25.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputFilterViewController.h"

@interface InputFilterViewController ()

@end

@implementation InputFilterViewController

/**
 *  初期化
 *
 *  @param nibNameOrNil   <#nibNameOrNil description#>
 *  @param nibBundleOrNil <#nibBundleOrNil description#>
 *
 *  @return self
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      [self.view setBackgroundColor:[UIColor grayColor]];
    }
    return self;
}

/**
 *  テキストフィールドを作成する
 *
 *  @param x x座標
 *  @param y y座標
 *
 *  @return テキストフィールドのポインタ
 */
- (UITextField *)createTextField:(int)x y:(int)y
{
  UITextField *_newTextField;
  _newTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 100, 40)];
  [_newTextField setBorderStyle:UITextBorderStyleRoundedRect];
  [_newTextField setReturnKeyType:UIReturnKeyDone];
  [_newTextField setText:nil];
  return _newTextField;
}

/**
 *  ビューがロードされたあとの処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];

  self.inputField = [self createTextField:0 y:100];
  [self.inputField becomeFirstResponder];
  [self.view addSubview:self.inputField];
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
