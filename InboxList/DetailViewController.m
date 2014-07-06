//
//  DetailViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

- (void)initItem;

@end

@implementation DetailViewController

#pragma mark - Initialization
/**
 * @brief 初期化
 */
-(id)init
{
  self = [super init];
  if (self) {
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self initInterface];
  }
  return self;
}

/**
 * @brief インターフェイスを初期化
 */
- (void)initInterface
{
  /// フィールドを作成
  self.titleField = [self createTextField:0 y:100];
  self.tagField   = [self createTextField:0 y:200];
  [self.view addSubview:self.titleField];
  [self.view addSubview:self.tagField];

  /// 戻るボタンを作成
  self.btn        = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.btn setTitle:@"back" forState:UIControlStateNormal];
  [self.btn setFrame:CGRectMake(CGRectGetMidX(self.view.frame),
                                CGRectGetMidY(self.view.frame),
                                100, 50)];
  [self.view addSubview:self.btn];

  [self.btn addTarget:self
               action:@selector(back)
     forControlEvents:UIControlEventTouchUpInside];
  
  
}

/**
 * @brief アイテムを更新する
 */
- (void)initItem
{
  if (self.detailItem) {
    NSString *title = [self.detailItem valueForKey:@"title"];
    NSSet *tags     = [self.detailItem valueForKey:@"tags"];

    [self.titleField setText:title]; //< タイトル設置
    [self.tagField setText:[[tags allObjects][0] title]]; //< タグを設置
  }
}

#pragma mark - Managing view

/**
 * @brief アイテムを設定する
 */
- (void)setDetailItem:(id)newDetailItem
{
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;

    // Update the view.
    [self initItem];
  }
}

/**
 * @brief テキストフィールドを作成する
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
 * @brief 戻るボタン
 * @todo 通常の戻るボタンでも、更新させる
 */
- (void)back
{
  NSLog(@"%s", __FUNCTION__);
  //    [self dismissViewControllerAnimated:YES completion:nil];

  /// デリゲートに変更後を渡す
  [self.delegate dismissDetailView:self
                             index:self.index
                             title:self.titleField.text
                         tagTitles:[NSSet setWithObject:self.tagField.text]];
  /// ビューを削除する
  [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 * @brief ビューがロードされたあとの処理
 */
- (void)viewDidLoad
{
  NSLog(@"%s", __FUNCTION__);
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self initItem]; //< アイテムを更新
}

/**
 * @brief メモリー関係？
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
