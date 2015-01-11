//
//  Cell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

/**
 * @brief  アイテムリスト用のセル
 */
@interface ItemCell : UITableViewCell

@property (strong, nonatomic) UIView *checkBox;

//@property (weak, nonatomic) IBOutlet CheckBoxImageView *checkBoxImageView; // チェックボックス画像
//@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
//@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
//@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property UIImageView *checkBoxImageView;

//@property UILabel *titleLabel;
//@property UILabel *reminderLabel;
//@property UILabel *tagLabel;

//+ (CGFloat)cellHeight;

-(BOOL)updateCheckBoxWithItem:(Item *)item;
-(void)setCheckedWithItem:(Item *)item;
-(void)setUnCheckedWithItem:(Item *)item;

@end
