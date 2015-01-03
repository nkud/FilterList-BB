//
//  Filter.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/26.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "Filter.h"
#import "Tag.h"


@implementation Filter

@dynamic title;
@dynamic tags;
@dynamic from;
@dynamic interval;
@dynamic overdue;
@dynamic today;
@dynamic future;
@dynamic order;

/**
 * @brief  期限をフィルターしているか返す
 *
 * @return 真偽値
 */
-(BOOL)hasInterval
{
  if (self.overdue && self.today) {
    return YES;
  } else {
    return NO;
  }
}

/**
 * @brief  期限オプションがなければ真を返す
 *
 * @return 真偽値
 */
-(BOOL)hasAllItem
{
  if( (self.overdue.boolValue || self.today.boolValue || self.future.boolValue) == NO ) {
    return YES;
  } else {
    return NO;
  }
}

@end