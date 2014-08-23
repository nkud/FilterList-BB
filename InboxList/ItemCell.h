//
//  Cell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief  アイテムリスト用のセル
 */
@interface ItemCell : UITableViewCell

@property (strong, nonatomic) UIView *checkBox; /* チェックボックス */

//@property (weak, nonatomic) IBOutlet CheckBoxImageView *checkBoxImageView; // チェックボックス画像
@property (weak, nonatomic) IBOutlet UIImageView *checkBoxImageView;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel; // リマインダーラベル
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;    // タイトルラベル

//+ (CGFloat)cellHeight;

- (BOOL)updateCheckBox:(BOOL)isChecked;

@end
