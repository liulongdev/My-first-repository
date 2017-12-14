//
//  MARCardDetailVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/15.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARCardDetailVC.h"
#import <MobAPI/MobAPI.h>
#import <UIImageView+WebCache.h>

@interface MARCardDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UILabel *cardInfoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_cardImageViewWidth;

@property (nonatomic, strong) MARCardDetailModel *cardDetailModel;
@property (nonatomic, strong) NSDictionary *attrDic;

@end

@implementation MARCardDetailVC
@synthesize cardDetailModel = _cardDetailModel;
- (void)viewDidLoad {
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    [super viewDidLoad];
    self.constraint_cardImageViewWidth.constant = kScreenWIDTH;
    [self cardDetailModel];
}

- (void)UIGlobal
{
    self.tableView.tableFooterView = [UIView new];
}

- (void)_updateTableHeaderView
{
    CGFloat height = [self.tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.tableHeaderView.mar_height = height;
    self.tableView.tableHeaderView.mar_width = kScreenWIDTH;
    [self.tableView reloadData];
}

- (MARCardDetailModel *)cardDetailModel
{
    if (!_cardDetailModel) {
        static BOOL simpleAsync = NO;
        [self showActivityView:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!simpleAsync) {
                simpleAsync = YES;
                NSArray *cardDetailArray = [MARCardDetailModel searchWithWhere:@{@"carId":self.cardSerieModel.carId ?: @""}];
                if (cardDetailArray.count <= 0) {
                    [self loadData];
                }
                else
                {
                    mar_dispatch_async_on_main_queue(^{
                        self.cardDetailModel = cardDetailArray[0];
                        [self showActivityView:NO];
                        [self.tableView reloadData];
                    });
                }
                simpleAsync = NO;
            }
        });
    }
    return _cardDetailModel;
}

- (void)loadData
{
    __weak __typeof(self) weakSelf = self;
    [self showActivityView:YES];
    [MobAPI sendRequest:[MOBACarRequest carSeriesDetailRequestByCid:self.cardSerieModel.carId] onResult:^(MOBAResponse *response) {
        [weakSelf showActivityView:NO];
        if (!response.error) {
            MARCardDetailModel *cardDetailModel = (MARCardDetailModel *)[MARCardDetailModel mar_modelWithJSON:response.responder[@"result"][0]];
            cardDetailModel.carId = weakSelf.cardSerieModel.carId;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [cardDetailModel updateToDB];
            });
            weakSelf.cardDetailModel = cardDetailModel;
            [weakSelf.tableView reloadData];
        }
        else
        {
            NSString *codeKey = [NSString stringWithFormat:@"%ld", (long)response.error.code];
            ShowErrorMessage(MARMOBUTIL.mobErrorDic[codeKey] ?: [response.error localizedDescription], 1.f);
            NSLog(@">>> getVerifyCode error : %@", [response.error localizedDescription]);
        }
    }];
}

- (void)setCardDetailModel:(MARCardDetailModel *)cardDetailModel
{
    _cardDetailModel = cardDetailModel;
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:cardDetailModel.carImage ?: @""] placeholderImage:nil];
    
    NSString *infoStr = [NSString stringWithFormat:@"品牌名称 : %@\n车系名称 : %@\n车型名称 : %@\n子品牌或合资品牌:%@", cardDetailModel.brand, cardDetailModel.brandName, cardDetailModel.seriesName, cardDetailModel.sonBrand];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:infoStr attributes:self.attrDic];
    self.cardInfoLabel.attributedText = attrStr;
    [self _updateTableHeaderView];
}

- (NSDictionary *)attrDic
{
    if (!_attrDic) {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineSpacing = 8;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        _attrDic = @{NSParagraphStyleAttributeName: style, NSFontAttributeName: [UIFont systemFontOfSize:15.f], NSForegroundColorAttributeName: RGBHEX(0x333333)};
    }
    return _attrDic;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)_secionArray
{
    return  @[@[@"baseInfo",        @"车型基本配置信息"],
              @[@"airConfig",       @"空调/冰箱配置信息"],
              @[@"carbody",         @"空调/冰箱配置信息"],
              @[@"chassis",         @"底盘配置信息"],
              @[@"controlConfig",   @"操控配置信息"],
              @[@"engine",          @"发动机配置信息"],
              @[@"exterConfig",     @"外部配置信息"],
              @[@"glassConfig",     @"玻璃/后视镜配置信息"],
              @[@"interConfig",     @"内部配置信息"],
              @[@"lightConfig",     @"灯光配置信息"],
              @[@"mediaConfig",     @"多媒体配置信息"],
              @[@"safetyDevice",    @"安全装置信息"],
              @[@"seatConfig",      @"座椅配置信息"],
              @[@"techConfig",      @"高科技配置信息"],
              @[@"transmission",    @"变速箱信息"],
              @[@"wheelInfo",       @"车轮制动信息"],
              @[@"motorList",       @"电动机配置信息"],
              ];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_cardDetailModel) {
        return [self _secionArray].count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self _secionArray][section][1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self _secionArray].count > section) {
        NSArray *nameValueArray = [_cardDetailModel valueForKey:[self _secionArray][section][0]];
        if ([nameValueArray isKindOfClass:[NSArray class]]) {
            return nameValueArray.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    if ([self _secionArray].count > indexPath.section) {
        NSArray *nameValueArray = [_cardDetailModel valueForKey:[self _secionArray][indexPath.section][0]];
        if ([nameValueArray isKindOfClass:[NSArray class]] && nameValueArray.count > indexPath.row) {
            MARCardNameValueModel *nameValueModel = (MARCardNameValueModel *)nameValueArray[indexPath.row];
            cell.textLabel.text = nameValueModel.value;
            cell.detailTextLabel.text = nameValueModel.name;
        }
    }
    return cell;
}

@end
