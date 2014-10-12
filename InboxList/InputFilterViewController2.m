//
//  InputFilterViewController2.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "InputFilterViewController2.h"
#import "FilterCell.h"
#import "CoreDataController.h"

static NSString *kTitleCellID = @"TitleCell";
static NSString *kTagSelectCellID = @"TagSelectCell";
static NSString *kDueDateCellID = @"DueDateCell";
static NSString *kSearchCellID = @"SearchCell";

#pragma mark -

@interface InputFilterViewController2 ()

@end

@implementation InputFilterViewController2

#pragma mark - 初期化

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // セルを登録
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kTitleCellID];
  self.tagFetchedResultsController = [CoreDataController userTagFetchedResultsController:self];
  
  // テーブルの設定
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
  
//  // ボタンを設定
//  [self.saveButton addTarget:self
//                      action:@selector(dismissView)
//            forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - テーブルビュー
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
