//
//  TabBar.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/26.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TabBar.h"
#import "Header.h"

@implementation TabBar

-(void)createTabs
{
  UITabBarItem *tabItem1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
  UITabBarItem *tabItem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:1];
  UITabBarItem *tabItem3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:2];
  self.items = [NSArray arrayWithObjects:tabItem1, tabItem2, tabItem3, nil];
  self.selectedItem = tabItem2;
}

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

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  NSLog(@"%@", item);
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
