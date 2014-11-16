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
@dynamic completionDate;
@dynamic state;
@dynamic title;
@dynamic tag;

-(BOOL)isCompleted
{
  if (self.completionDate == nil) {
    return NO;
  }
  return YES;
}
-(void)setComplete
{
  self.completionDate = [NSDate date];
}
-(void)setIncomplete
{
  self.completionDate = nil;
}

-(BOOL)hasDueDate
{
  if (self.reminder == nil) {
    return NO;
  } else {
    return YES;
  }
}

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

-(BOOL)isEqualDueDate:(NSDate *)date
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];;
  NSString *todayString = [formatter stringFromDate:date];
  NSString *dueToString = [formatter stringFromDate:self.reminder];
  if ([todayString isEqualToString:dueToString]) {
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
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd"];;
  NSDate *today = [NSDate date];
  NSString *todayString = [formatter stringFromDate:today];
  NSString *dueToString = [formatter stringFromDate:self.reminder];
  if ([todayString isEqualToString:dueToString]) {
    return YES;
  } else {
    return NO;
  }
}

-(NSString *)tagName
{
  return self.tag ? self.tag.title : @"";
}

@end
