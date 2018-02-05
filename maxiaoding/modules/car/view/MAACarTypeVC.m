//
//  MAACarTypeVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/4.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAACarTypeVC.h"
#import "MAACarDetailVC.h"
//carSimpleInfoCell
@interface MAACarTypeVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MAACarTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carTypeM.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carSimpleInfoCell" forIndexPath:indexPath];
    if (self.carTypeM.list.count > indexPath.row) {
        MAACarSimpleInfoM *carSimpleInfoM = self.carTypeM.list[indexPath.row];
        UIImageView *imageView = [cell viewWithTag:1];
        UILabel *label = [cell viewWithTag:2];
        
        NSURL *URL = nil;
        if ([carSimpleInfoM.logo mar_isValidUrl]) {
            URL = [NSURL URLWithString:carSimpleInfoM.logo];
        }
        else
        {
            if ([carSimpleInfoM.logo mar_stringByTrim].length > 0) {
                URL = [NSURL URLWithString:self.carTypeM.logo ?: @""];
                URL = [URL URLByDeletingLastPathComponent];
                URL = [URL URLByAppendingPathComponent:carSimpleInfoM.logo];
            }
        }
        [imageView mar_setImageDefaultCornerRadiusWithURL:URL errorImage:[UIImage imageNamed:@"icon_car_brands"]];
        NSString *simpleInfoStr = [NSString stringWithFormat:@"%@\n参考价:%@\n%@, %@ , %@", carSimpleInfoM.name, carSimpleInfoM.price, carSimpleInfoM.sizetype, carSimpleInfoM.productionstate, carSimpleInfoM.salestate];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:simpleInfoStr attributes:MARSTYLEFORMAT.carSimpleInfoAttrDic];
        label.attributedText = attr;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.carTypeM.list.count > indexPath.row) {
        MAACarSimpleInfoM *carSimpleInfoM = self.carTypeM.list[indexPath.row];
        [self performSegueWithIdentifier:@"goMAACarDetailVC" sender:carSimpleInfoM];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MAACarDetailVC *carDetailVC = segue.destinationViewController;
    if ([carDetailVC isKindOfClass:[MAACarDetailVC class]] && [sender isKindOfClass:[MAACarSimpleInfoM class]]) {
        carDetailVC.carId = ((MAACarSimpleInfoM *)sender).id;
    }
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
