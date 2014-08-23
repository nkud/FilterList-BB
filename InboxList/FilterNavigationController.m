//
//  FilterNavigationController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "FilterNavigationController.h"
#import "Header.h"
#import "Configure.h"

@interface FilterNavigationController ()

@end

@implementation FilterNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**
 *  @brief  ナビゲーションコントローラビューロード後処理
 */
-(void)viewDidLoad
{
  LOG(@"ナビゲーションバーの色を設定");
  [self.navigationBar setBarTintColor:ITEM_NAVBAR_COLOR];
  [self.navigationBar setTintColor:RGB(0, 0, 0)];
  [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: RGB(0, 0, 0)}];
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
