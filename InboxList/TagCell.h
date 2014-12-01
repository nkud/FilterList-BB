//
//  TagCell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

/// タグのセル
@interface TagCell : UITableViewCell

@property UILabel *titleLabel;
@property UILabel *itemSizeLabel;

- (void)showItemSizeLabel:(BOOL)show;

@end
