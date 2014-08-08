//
//  TabBar.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/26.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TabBar.h"
#import "Header.h"

@implementation TabBar

/**
 *  タブバーを作成・初期化
 */
-(void)createTabs
{
  self.tagModeTab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
  self.itemModeTab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:1];
  self.filterModeTab = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:2];
  self.items = [NSArray arrayWithObjects:self.tagModeTab, self.itemModeTab, self.filterModeTab, nil];
  self.selectedItem = self.itemModeTab;
}

/**
 *  初期化
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame
{
  NSLog(@"%s", __FUNCTION__);
  self = [super initWithFrame:frame];
    if (self)
    {
      [self createTabs];
      self.barStyle = UIBarStyleDefault;
      self.tintColor = [UIColor blueColor];
      self.translucent = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
