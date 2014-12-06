//
//  SwitchCell.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/12/06.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier];
  if (self) {
    self.switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.accessoryView = self.switchView;
  }
  return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
