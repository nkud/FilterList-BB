//
//  TabBar.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/26.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TabBar.h"
#import "Header.h"
#import "Configure.h"

static NSString *kItemTabBarItemImageName = @"ItemTabBarItem.png";
static NSString *kTagTabBarItemImageName = @"TagTabBarItem.png";
static NSString *kFilterTabBarItemImageName = @"FilterTabBarItem.png";
static NSString *kCompleteTabBarItemImageName = @"CompleteTabBarItem.png";

#pragma mark -

@implementation TabBar

/**
 *  タブバーを作成・初期化
 */
-(void)createTabs
{
  LOG(@"タブバーを作成");
  self.itemModeTab = [[UITabBarItem alloc] initWithTitle:@"ITEM"
                                                   image:[UIImage imageNamed:kItemTabBarItemImageName]
                                                     tag:0];
  self.tagModeTab = [[UITabBarItem alloc] initWithTitle:@"TAG"
                                                  image:[UIImage imageNamed:kTagTabBarItemImageName]
                                                    tag:1];
  self.filterModeTab = [[UITabBarItem alloc] initWithTitle:@"FILTER"
                                                     image:[UIImage imageNamed:kFilterTabBarItemImageName]
                                                       tag:2];
  self.completedModeTab = [[UITabBarItem alloc] initWithTitle:@"COMP"
                                                        image:[UIImage imageNamed:kCompleteTabBarItemImageName]
                                                          tag:3];
  self.items = [NSArray arrayWithObjects:self.itemModeTab, self.tagModeTab, self.filterModeTab, self.completedModeTab, nil];
  self.selectedItem = self.itemModeTab;
}

/**
 *  初期化
 *
 *  @param frame フレーム
 *
 *  @return インスタンス
 */
- (id)initWithFrame:(CGRect)frame
{
  LOG(@"初期化");
  self = [super initWithFrame:frame];
    if (self)
    {
      [self createTabs];
      self.barStyle = UIBarStyleDefault;
      self.tintColor = TAG_COLOR;
      self.translucent = NO;
      self.barTintColor = RGB(30, 30, 30);
    }
    return self;
}
-(void)setItemMode
{
  self.selectedItem = self.itemModeTab;
}

-(void)setTagMode
{
  self.selectedItem = self.tagModeTab;
}
-(void)setFilterMode
{
  self.selectedItem = self.filterModeTab;
}
-(void)setCompletedMode
{
  self.selectedItem = self.completedModeTab;
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
