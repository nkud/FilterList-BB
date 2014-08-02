//
//  TagCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/03.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagCell.h"

@implementation TagCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  NSLog(@"%s", __FUNCTION__);
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
  }
  return self;
}

- (void)awakeFromNib
{
  NSLog(@"%s", __FUNCTION__);
  // Initialization code
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
