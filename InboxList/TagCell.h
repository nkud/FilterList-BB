//
//  TagCell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

// TODO: 普通に消す時にラベルが消えてしまう

#import <UIKit/UIKit.h>

/// タグのセル
@interface TagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelForTitle;

@property (weak, nonatomic) IBOutlet UILabel *labelForItemSize;
//@property (weak, nonatomic) IBOutlet UILabel *labelForOverDueItemsSize;
//@property (weak, nonatomic) IBOutlet UILabel *labelForDueToTodayItemsSize;

- (void)showItemSizeLabel:(BOOL)show;

@end
