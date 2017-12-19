//
//  MARHomeTestVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARHomeTestVC.h"
#import "MARHomeCustomTableCell.h"
@interface MARHomeTestVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MARHomeTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass:[MARTestTableViewCell class] forCellReuseIdentifier:@"MARTestTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MARHomeCustomTableCell" bundle:nil] forCellReuseIdentifier:@"MARHomeCustomTableCell"];
}

- (void)UIGlobal
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MARHomeCustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MARHomeCustomTableCell" forIndexPath:indexPath];
    @weakify(self)
    [cell setBottomAppearBlock:^{
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        [weak_self.tableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.mar_height;
}

@end
