//
//  ItemDetailTitleCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "ItemDetailTitleCell.h"

@implementation ItemDetailTitleCell

- (void)awakeFromNib
{
    // Initialization code
  self.titleField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.titleField resignFirstResponder];
  return YES;
}

@end
