//
//  MARCarSeriesVCh
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCarSeriesVC.h"
#import <MobAPI/MobAPI.h>
#import "MARCarDetailVC.h"

@interface MARCarSeriesVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MARCarSerieModel *> *cardSerieArray;
@end

@implementation MARCarSeriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cardTypeInfoModel.type;
    [self cardSerieArray];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
}

- (NSArray<MARCarSerieModel *> *)cardSerieArray
{
    if (!_cardSerieArray) {
        static BOOL simpleAsync = NO;
        [self showActivityView:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!simpleAsync) {
                simpleAsync = YES;
                _cardSerieArray = [MARCarSerieModel getCardSerieArrayWithBrandName:(self.cardTypeInfoModel.type ?: @"")];
                if (_cardSerieArray.count <= 0) {
                    [self loadData];
                }
                else
                {
                    mar_dispatch_async_on_main_queue(^{
                        [self showActivityView:NO];
                        [self.tableView reloadData];
                    });
                }
                simpleAsync = NO;
            }
        });
    }
    return _cardSerieArray;
}

- (void)loadData
{
    [self showActivityView:YES];
    @weakify(self)
    [MARMobUtil loadCarSeriesName:(self.cardTypeInfoModel.type ?: @"") callback:^(MOBAResponse *response, NSArray<MARCarSerieModel *> *cardSerieArray, NSString *errMsg) {
        @strongify(self)
        if (!strong_self) return;
        [strong_self showActivityView:NO];
        if (!response.error) {
            strong_self->_cardSerieArray = cardSerieArray;
            [strong_self.tableView reloadData];
        }
        else
        {
            ShowErrorMessage(errMsg ?: [response.error localizedDescription], 1.f);
            NSLog(@">>> get carSeries error : %@", [response.error localizedDescription]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cardSerieArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    NSInteger row = indexPath.row;
    if (_cardSerieArray.count > row) {
        MARCarSerieModel *cardSerieModel = _cardSerieArray[row];
        cell.textLabel.text = cardSerieModel.seriesName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"参考价：%@", cardSerieModel.guidePrice];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (_cardSerieArray.count > row) {
        MARCarSerieModel *cardSerieModel = _cardSerieArray[row];
        [self performSegueWithIdentifier:@"goCardDetailVC" sender:cardSerieModel];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goCardDetailVC"]) {
        MARCarDetailVC *cardDetailVC = segue.destinationViewController;
        if ([cardDetailVC isKindOfClass:[MARCarDetailVC class]] && [sender isKindOfClass:[MARCarSerieModel class]]) {
            cardDetailVC.cardSerieModel = (MARCarSerieModel *)sender;
        }
    }
}

@end
