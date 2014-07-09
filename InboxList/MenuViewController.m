//
//  MenuView.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "MenuViewController.h"
#import "Header.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

/**
 * @brief この初期化方法は変えたほうがいいかも
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  if (self) {
    ;
  }
  return self;
}

/**
 * セルが選択された時の処理
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected: %@", self.tag_list[indexPath.row]);

  /// 選択されたタグをデリゲートに渡す
  [self.delegate loadMasterViewForTag:self.tag_list[indexPath.row]];
}

/**
 * ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  NSLog(@"%s", __FUNCTION__);

  [super viewDidLoad];

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
}

/**
 *
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[NSNumber numberWithInt:1] integerValue];
}

/**
 *
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return [self.tag_list count];
}

/**
 * テーブルのセルを表示する
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"MenuCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  cell.textLabel.text = self.tag_list[indexPath.row];
  return cell;
}

/**
 * セルの更新を行う
 *
 * @param cell セル
 * @param atIndexPath 更新するセルの位置
 *
 * @note 現在使用せず
 */
- (void)updateCell:(UITableViewCell *)cell
       atIndexPath:(NSIndexPath *)indexPath
{
  [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
}
/**
 * テーブルを更新する
 *
 * @note 非効率かも
 */
- (void)updateTableView
{
  [self.tableView reloadData];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
