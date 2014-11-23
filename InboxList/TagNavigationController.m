//
//  TagNavigationController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagNavigationController.h"
#import "Header.h"
#import "Configure.h"

#define kShadowOpacity 0.8

#pragma mark -

@interface TagNavigationController ()

@end

@implementation TagNavigationController

#pragma mark - 初期化

/**
 * @brief  初期化
 *
 * @param nibNameOrNil   nibNameOrNil description
 * @param nibBundleOrNil nibBundleOrNil description
 *
 * @return インスタンス
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.navigationBar.barTintColor = GRAY_COLOR;
    CGRect frame = self.view.frame;
    frame.size.width -= ITEM_LIST_REMAIN_MARGIN;
    frame.origin.x += ITEM_LIST_REMAIN_MARGIN;
    self.view.frame = frame;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // 影をつける
//  self.view.layer.shadowOpacity = kShadowOpacity;
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
