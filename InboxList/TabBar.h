//
//  TabBar.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/26.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBar : UITabBar

@property UITabBarItem *tagModeTab;
@property UITabBarItem *itemModeTab;
@property UITabBarItem *filterModeTab;
@property UITabBarItem *completedModeTab;

-(void)setItemMode;
-(void)setTagMode;
-(void)setFilterMode;
-(void)setCompletedMode;

@end
