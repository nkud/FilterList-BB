//
//  DetailViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

- (void)updateItem;

@end

@implementation DetailViewController

/* ===  FUNCTION  ==============================================================
 *        Name: init
 * Description: 初期化する
 * ========================================================================== */
-(id)init
{
  self = [super init];
  if (self) {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initInterface];
  }
  return self;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;

    // Update the view.
    [self updateItem];
  }
}

- (void)updateItem
{
  // Update the user interface for the detail item.

  if (self.detailItem) {
    NSString *title = [self.detailItem valueForKey:@"title"];
    NSSet *tags = [self.detailItem valueForKey:@"tags"];

    //        NSString *detail = [NSString stringWithFormat:@"%@%@", title, [[tags allObjects][0] title]];

    [self.titleField setText:title];
    [self.tagField setText:[[tags allObjects][0] title]];
    //        self.detailDescriptionLabel.text = detail;
  }
}

/* ===  FUNCTION  ==============================================================
 *        Name: initInterface
 * Description: インターフェイスを初期化する
 * ========================================================================== */
- (UITextField *)createTextField:(int)x y:(int)y
{
  UITextField *_newTextField;
  _newTextField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, 100, 40)];
  [_newTextField setBorderStyle:UITextBorderStyleRoundedRect];
  [_newTextField setReturnKeyType:UIReturnKeyDone];
  [_newTextField setText:nil];
  return _newTextField;
}
- (void)initInterface
{
  //    // ラベルを作成
  //    self.detailDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, 100, 30)];
  //    [self.detailDescriptionLabel setBackgroundColor:[UIColor grayColor]];
  //    [self.view addSubview:self.detailDescriptionLabel];
  // フィールドを作成
  self.titleField = [self createTextField:0 y:100];
  self.tagField = [self createTextField:0 y:200];
  [self.view addSubview:self.titleField];
  [self.view addSubview:self.tagField];


  // 戻るボタン
  self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.btn setTitle:@"back" forState:UIControlStateNormal];
  [self.btn setFrame:CGRectMake(CGRectGetMidX(self.view.frame),
                                CGRectGetMidY(self.view.frame),
                                100, 50)];
  [self.btn addTarget:self
               action:@selector(back)
     forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.btn];


}

// 戻る
- (void)back
{
  //    [self dismissViewControllerAnimated:YES completion:nil];
  [self.delegate dismissDetailView:self index:self.index];
  [self.navigationController popToRootViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self updateItem];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
