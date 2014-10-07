//
//  CompleteCell.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;

@end
