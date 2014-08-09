//
//  MenuView.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagViewController.h"
#import "Header.h"
#import "TagCell.h"
#import "Tag.h"

@interface TagViewController ()

@end

@implementation TagViewController

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
 *  タグが選択された時の処理
 *
 *  @param tableView tableView description
 *  @param indexPath 選択された場所
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // 選択されたタグをデリゲートに渡す
  if (indexPath.section == 0) {         // セクション０なら
    [self.delegate selectedTag:@"all"]; // すべてのリストを表示
    return;
  } // そうでないなら
  Tag *tag = self.tagArray_[indexPath.row];
  [self.delegate selectedTag:tag.title]; // 選択されたタグを渡す
}

/**
 *  セクションのタイトルを設定
 *
 *  @param tableView テーブルビュー
 *  @param section   セクション
 *
 *  @return タイトルの文字列
 */
-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
  switch (section) {
    case 0:
      return @"Default";
      break;
    case 1:
      return @"Tag";
      break;
  }
  return nil;
}

/**
 * ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  NSLog(@"%s", __FUNCTION__);

  [super viewDidLoad];

//  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TagCell class])
                                             bundle:nil]
       forCellReuseIdentifier:TagModeCellIdentifier];
}

/**
 * セクション数を返す
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[NSNumber numberWithInt:2] integerValue];
}

/**
 * アイテム数を返す
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  if (section == 0) {
    return 1;
  }
  return [self.tagArray_ count];
}

/**
 * テーブルのセルを表示する
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TagCell *cell = [tableView dequeueReusableCellWithIdentifier:TagModeCellIdentifier];
  if (indexPath.section == 0) {
    cell.textLabel.text = @"all";
    return cell;
  }
  Tag *tag = self.tagArray_[indexPath.row];
  cell.textLabel.text = tag.title;
  return cell;
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
