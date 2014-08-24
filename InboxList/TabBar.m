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
  LOG(@"タブバーを作成");
  self.itemModeTab = [[UITabBarItem alloc] initWithTitle:@"ITEM"
                                                   image:[UIImage imageNamed:@"itemtab.png"]
                                                     tag:0];  
  self.tagModeTab = [[UITabBarItem alloc] initWithTitle:@"TAG"
                                                  image:[UIImage imageNamed:@"tagtab.png"]
                                                    tag:1];
  self.filterModeTab = [[UITabBarItem alloc] initWithTitle:@"FILTER"
                                                     image:[UIImage imageNamed:@"filtertab.png"]
                                                       tag:2];
  self.completedModeTab = [[UITabBarItem alloc] initWithTitle:@"COMP"
                                                        image:[UIImage imageNamed:@"completedtab.png"]
                                                          tag:3];
  
  self.items = [NSArray arrayWithObjects:self.itemModeTab, self.tagModeTab, self.filterModeTab, self.completedModeTab, nil];
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
  LOG(@"初期化");
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
