//
//  DetailViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Item.h"

@protocol ItemDetailViewControllerDelegate <NSObject>

- (void)dismissDetailView:(id)sender
                    index:(NSIndexPath *)indexPath
                itemTitle:(NSString *)itemTitle
                tagTitles:(NSArray *)tagTitles;


@end

@interface ItemDetailViewController : UIViewController

@property (strong, nonatomic) Item * detailItem;

//@property (strong, nonatomic) UILabel *detailDescriptionLabel;

@property id <ItemDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextField *tagField;
@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) NSIndexPath *index;

@end
