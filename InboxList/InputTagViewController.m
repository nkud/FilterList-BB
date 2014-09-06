//
//  InputTagViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/17.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "InputTagViewController.h"
#import "Header.h"

@interface InputTagViewController ()

@end

@implementation InputTagViewController
#pragma mark - 初期化
/**
 * @brief  初期化
 *
 * @param nibNameOrNil   <#nibNameOrNil description#>
 * @param nibBundleOrNil <#nibBundleOrNil description#>
 *
 * @return <#return value description#>
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self.saveButton addTarget:self
                      action:@selector(save:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.titleField becomeFirstResponder];
}
/**
 * @brief  入力を保存して終了する
 *
 * @return
 */
-(void)save:(id)sender
{
  LOG(@"入力を保存して戻る");
  // タイトルフィールドの文字列を渡す
  [self.delegate saveTags:self.titleField.text];
  // 画面をポップする
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - その他

/**
 *  メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  LOG(@"メモリー警告");
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
