//
//  MARCardSeriesVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/14.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCardSeriesVC.h"
#import <MobAPI/MobAPI.h>
#import "MARCardDetailVC.h"

@interface MARCardSeriesVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MARCardSerieModel *> *cardSerieArray;
@end

@implementation MARCardSeriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cardTypeInfoModel.type;
    [self cardSerieArray];
}

- (void)UIGlobal
{
    self.tableView.tableFooterView = [UIView new];
}

- (NSArray<MARCardSerieModel *> *)cardSerieArray
{
    if (!_cardSerieArray) {
        static BOOL simpleAsync = NO;
        [self showActivityView:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!simpleAsync) {
                simpleAsync = YES;
                _cardSerieArray = [MARCardSerieModel getCardSerieArrayWithBrandName:(self.cardTypeInfoModel.type ?: @"")];
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
    __weak __typeof(self) weakSelf = self;
    [self showActivityView:YES];
    [MobAPI sendRequest:[MOBACarRequest carSeriesNameRequestByName:(self.cardTypeInfoModel.type ?: @"")] onResult:^(MOBAResponse *response) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return ;
        [strongSelf showActivityView:NO];
        if (!response.error) {
            NSArray<MARCardSerieModel *> *cardSerieArray = [NSArray mar_modelArrayWithClass:[MARCardSerieModel class] json:response.responder[@"result"]];
            strongSelf->_cardSerieArray = cardSerieArray;
            [strongSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (MARCardSerieModel *model in cardSerieArray) {
                    [model updateToDB];
                }
            });
        }
        else
        {
            NSString *codeKey = [NSString stringWithFormat:@"%ld", (long)response.error.code];
            ShowErrorMessage(MARMOBUTIL.mobErrorDic[codeKey] ?: [response.error localizedDescription], 1.f);
            NSLog(@">>> getVerifyCode error : %@", [response.error localizedDescription]);
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
        MARCardSerieModel *cardSerieModel = _cardSerieArray[row];
        cell.textLabel.text = cardSerieModel.seriesName;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"参考价：%@", cardSerieModel.guidePrice];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (_cardSerieArray.count > row) {
        MARCardSerieModel *cardSerieModel = _cardSerieArray[row];
        [self performSegueWithIdentifier:@"goCardDetailVC" sender:cardSerieModel];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goCardDetailVC"]) {
        MARCardDetailVC *cardDetailVC = segue.destinationViewController;
        if ([cardDetailVC isKindOfClass:[MARCardDetailVC class]] && [sender isKindOfClass:[MARCardSerieModel class]]) {
            cardDetailVC.cardSerieModel = (MARCardSerieModel *)sender;
        }
    }
}

@end
