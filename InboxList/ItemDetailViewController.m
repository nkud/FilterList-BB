//
//  DetailViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemDetailViewController.h"

#import "Tag.h"

@interface ItemDetailViewController ()

- (void)initItem;

@end

@implementation ItemDetailViewController

#pragma mark - Initialization

/**
 *  初期化
 *
 *  @return インスタンス
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
 *  Nibファイルで初期化
 *
 *  @param nibNameOrNil   Nibファイル名
 *  @param nibBundleOrNil バンドル
 *
 *  @return インスタンス
 */
-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil
{
  NSLog(@"%s", __FUNCTION__);
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  [self initInterface];
  return self;
}

/**
 *  インターフェイスを初期化する
 */
- (void)initInterface
{
  NSLog(@"%s", __FUNCTION__);
  /// フィールドを作成
//  self.titleField = [self createTextField:0 y:100];
//  self.tagField   = [self createTextField:0 y:200];
//  [self.view addSubview:self.titleField];
//  [self.view addSubview:self.tagField];

  /// 戻るボタンを作成
//  self.btn        = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//  [self.btn setTitle:@"save" forState:UIControlStateNormal];
//  [self.btn setFrame:CGRectMake(CGRectGetMidX(self.view.frame),
//                                CGRectGetMidY(self.view.frame),
//                                100, 50)];
//  [self.view addSubview:self.btn];

//  [self.btn addTarget:self
//               action:@selector(save)
//     forControlEvents:UIControlEventTouchUpInside];
  /**
   *  ボタン
   */
  [self.saveButton setTitle:@"Save"
                   forState:UIControlStateNormal];
  [self.saveButton addTarget:self
                      action:@selector(save)
            forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  アイテムを更新する
 */
- (void)initItem
{
  if (self.detailItem) {
    NSString *title = [self.detailItem valueForKey:@"title"];
    NSSet *tags     = [self.detailItem valueForKey:@"tags"];

    NSMutableString *field = [[NSMutableString alloc] init];
    [self.titleField setText:title]; //< タイトル設置
    for( Tag *tag in tags )
    { //< すべてのタグに対して
      [field appendString:tag.title]; //< フィールドに足していく
      [field appendString:@" "];
    }
    self.tagField.text = field; //< タグを設置

  }
}

#pragma mark - Managing view

/**
 *  アイテムを設定する
 *
 *  @param newDetailItem アイテム
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
 *  テキストフィールドを作成する
 *
 *  @param x x座標
 *  @param y y座標
 *
 *  @return インスタンス
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
 *  保存して戻る
 */
- (void)save
{
  //    [self dismissViewControllerAnimated:YES completion:nil];

  NSArray *tag_titles = [self.tagField.text componentsSeparatedByString:@" "]; //< タグの配列を生成

  /// デリゲートに変更後を渡す
  [self.delegate dismissDetailView:self
                             index:self.index
                         itemTitle:self.titleField.text
                         tagTitles:tag_titles];
  /// ビューを削除する
  [self.navigationController popToRootViewControllerAnimated:YES];
}

///  ビューがロードされたあとの処理
- (void)viewDidLoad
{
  NSLog(@"%s", __FUNCTION__);
  [super viewDidLoad];
  [self initItem]; //< アイテムを更新
  [self initInterface];
}

///  メモリー警告
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
