//
//  Item.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/26.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "Item.h"
#import "Tag.h"


@implementation Item

@dynamic color;
@dynamic reminder;
@dynamic state;
@dynamic title;
@dynamic tag;


/**
 * @brief  期限を過ぎているか評価
 *
 * @return 真偽値
 */
-(BOOL)isOverDue
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];;
  NSDate *today = [NSDate date];
  if ([[self.reminder earlierDate:today] isEqualToDate:self.reminder]) {
    return YES;
  } else {
    return NO;
  }
}

/**
 * @brief  期限が今日までなら真
 *
 * @return 真偽値
 */
-(BOOL)isDueToToday
{
  return NO;
}

@end
