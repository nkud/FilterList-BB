//
//  CompleteViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ListViewController.h"

@interface CompleteViewController : ListViewController
<NSFetchedResultsControllerDelegate>

@property NSFetchedResultsController *fetchedResultsController;

-(void)updateTableView;


@end
