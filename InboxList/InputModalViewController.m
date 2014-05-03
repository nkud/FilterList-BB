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

/* ===  FUNCTION  ==============================================================
 *        Name: init
 * Description: 初期化
 * ========================================================================== */
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
/* ===  FUNCTION  ==============================================================
 *        Name: viewDidLoad
 * Description: ビュー読み込み
 * ========================================================================== */
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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    // -----------------
    // アイテム入力フィールド
    self.textField = [self createTextField:0 y:100];
    [self.textField becomeFirstResponder];
    [self.view addSubview:self.textField];
    
    // -----------------
    // タグ入力フィールド
    self.tagInputField = [self createTextField:0 y:150];
    [self.view addSubview:self.tagInputField];
    
    // -----------------
    // 入力完了ボタン
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 30, 100, 50)];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(dismissInputModalView:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
/* ===  FUNCTION  ==============================================================
 *        Name: textFieldShouldReturn:
 * Description: テキストフィールドのReturnボタンが押された時の処理
 * ========================================================================== */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textField) { // アイテム名入力欄なら、
        // データを渡して、ビューを削除する
        [self dismissInputModalView:textField];
//                               data:@[self.textField.text, self.tagInputField.text]];
    } else if (textField == self.tagInputField) { // タグ入力時なら、
        [self.textField becomeFirstResponder]; // アイテム名入力欄に移動する
    }
    return YES;
}
/* ===  FUNCTION  ==============================================================
 *        Name: dismissInputModalView:title:
 * Description: データを渡して、ビューを削除する
 * ========================================================================== */
- (void)dismissInputModalView:(id)sender
//                        data:(NSArray *)data
{
    NSArray *_data = @[self.textField.text, self.tagInputField.text];
    [[self delegate] dismissInputModalView:sender
                                      data:_data];
}
/* ===  FUNCTION  ==============================================================
 *        Name: didReceiveMemoryWarning
 * Description: ???
 * ========================================================================== */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
