//
//  MARTianxingMenuVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/19.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "MARTianxingMenuVC.h"
#import "MARTXNewsVC.h"

NSString * const tianxingMenuCellTitle_ShuiHuiXinWen = @"社会新闻";
NSString * const tianxingMenuCellTitle_GuoJiXinWen = @"国际新闻";
NSString * const tianxingMenuCellTitle_YuLeXinWen = @"娱乐新闻";
NSString * const tianxingMenuCellTitle_TiYuXinWen = @"体育新闻";
NSString * const tianxingMenuCellTitle_NBAXinWen = @"NBA新闻";
NSString * const tianxingMenuCellTitle_ZuQiuXinWen = @"足球新闻";
NSString * const tianxingMenuCellTitle_KeJiXinWen = @"科技新闻";
NSString * const tianxingMenuCellTitle_ChuangyeXinWen = @"创业新闻";
NSString * const tianxingMenuCellTitle_PingGuoXinWen = @"苹果新闻";
NSString * const tianxingMenuCellTitle_JunShiXinWen = @"军事新闻";
NSString * const tianxingMenuCellTitle_YiDongHuLian = @"移动互联";
NSString * const tianxingMenuCellTitle_LvYouZiXun = @"旅游资讯";
NSString * const tianxingMenuCellTitle_JianKangZhiShi = @"健康知识";
NSString * const tianxingMenuCellTitle_QuWenYiShi = @"奇闻异事";
NSString * const tianxingMenuCellTitle_MeiNvTuPian = @"美女图片";
NSString * const tianxingMenuCellTitle_VRKeJi = @"VR科技";
NSString * const tianxingMenuCellTitle_ITZiXun = @"IT资讯";

@interface MARTianxingMenuVC () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuTitleArray;
@end

@implementation MARTianxingMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuTitleArray = @[tianxingMenuCellTitle_VRKeJi,
                            tianxingMenuCellTitle_ShuiHuiXinWen,
                            tianxingMenuCellTitle_GuoJiXinWen,
                            tianxingMenuCellTitle_YuLeXinWen,   // @"娱乐新闻";
                            tianxingMenuCellTitle_TiYuXinWen,   // @"体育新闻";
                            tianxingMenuCellTitle_NBAXinWen,    // @"NBA新闻";
                            tianxingMenuCellTitle_ZuQiuXinWen,  // @"足球新闻";
                            tianxingMenuCellTitle_KeJiXinWen,   // @"科技新闻";
                            tianxingMenuCellTitle_ChuangyeXinWen,   // @"创业新闻";
                            tianxingMenuCellTitle_PingGuoXinWen,    // @"苹果新闻";
                            tianxingMenuCellTitle_JunShiXinWen, // @"军事新闻";
                            tianxingMenuCellTitle_YiDongHuLian, // @"移动互联";
                            tianxingMenuCellTitle_LvYouZiXun,   // @"旅游资讯";
                            tianxingMenuCellTitle_JianKangZhiShi,   // @"健康知识";
                            tianxingMenuCellTitle_QuWenYiShi,   // @"奇闻异事";
                            tianxingMenuCellTitle_MeiNvTuPian,  // @"美女图片";
                            tianxingMenuCellTitle_ITZiXun,      // @"IT资讯";
                            
                       ];
}

- (void)UIGlobal
{
    MARAdjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.menuTitleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    NSNumber *typeNumber = nil;
    if ([tianxingMenuCellTitle_ShuiHuiXinWen isEqualToString:title]) {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_SheHui];
    }
    else if ([tianxingMenuCellTitle_GuoJiXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_GuoJi];;
    }
    else if ([tianxingMenuCellTitle_YuLeXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_YuLe];
    }
    else if ([tianxingMenuCellTitle_TiYuXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_TiYu];
    }
    else if ([tianxingMenuCellTitle_NBAXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_NBA];
    }
    else if ([tianxingMenuCellTitle_ZuQiuXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_ZuQiu];
    }
    else if ([tianxingMenuCellTitle_KeJiXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_KeJi];
    }
    else if ([tianxingMenuCellTitle_ChuangyeXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_ChuangYe];;
    }
    else if ([tianxingMenuCellTitle_PingGuoXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_PingGuo];;
    }
    else if ([tianxingMenuCellTitle_JunShiXinWen isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_JunShi];;
    }
    else if ([tianxingMenuCellTitle_YiDongHuLian isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_YiDongHuLian];;
    }
    else if ([tianxingMenuCellTitle_LvYouZiXun isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_LvYouZiXun];;
    }
    else if ([tianxingMenuCellTitle_JianKangZhiShi isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_JianKangZhiShi];;
    }
    else if ([tianxingMenuCellTitle_QuWenYiShi isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_QuWenYiShi];;
    }
    else if ([tianxingMenuCellTitle_MeiNvTuPian isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_MeiNvTuPian];;
    }
    else if ([tianxingMenuCellTitle_VRKeJi isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_VRKeJi];;
    }
    else if ([tianxingMenuCellTitle_ITZiXun isEqualToString:title])
    {
        typeNumber = [NSNumber numberWithInteger:TXNEWSType_ITZiXun];;
    }
    
    [self performSegueWithIdentifier:@"goTXNewsVC" sender:typeNumber];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MARTXNewsVC *TXNewsVC = segue.destinationViewController;
    if ([TXNewsVC isKindOfClass:[MARTXNewsVC class]] && [sender isKindOfClass:[NSNumber class]]) {
        TXNewsVC.type = [sender integerValue];
    }
}

@end
