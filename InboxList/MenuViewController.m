//
//  MenuView.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "MenuViewController.h"
#import "Header.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

////////////////////////////////////////////////////////////////////////////////
/// initWithNibName
/// @todo この初期化方法は変えた方がいいのかも

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    ;
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////
//// viewDidLoad
- (void)viewDidLoad
{
  NSLog(@"%s", __FUNCTION__);

  [super viewDidLoad];

  /// メニュービューを初期化
  self.menuView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS
                                               style:UITableViewStylePlain];
  [self.view addSubview:self.menuView];
}

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
