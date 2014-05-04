//
//  DetailViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate <NSObject>

- (void)dismissDetailView:(id)sender index:(NSIndexPath *)index;

@end

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

//@property (strong, nonatomic) UILabel *detailDescriptionLabel;

@property id <DetailViewControllerDelegate> delegate;

@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextField *tagField;
@property (strong, nonatomic) UIButton *btn;

@property (strong, nonatomic) NSIndexPath *index;

@end
