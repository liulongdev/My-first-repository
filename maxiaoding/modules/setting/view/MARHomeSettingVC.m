//
//  MARHomeSettingVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/2/24.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARHomeSettingVC.h"
#import <iCarousel.h>
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

NSString * const kCellTitle_SelectStyle             = @"选择样式";
NSString * const kCellTitle_PageScale               = @"页面比利";
NSString * const kCellTitle_More                    = @"更多";
NSString * const kCellTitle_Feedback                = @"意见反馈";

@interface MARHomeSettingVC ()<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *homeStyleTitleArray;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
@property (nonatomic, strong) YWFeedbackViewController *feedbackVC;
@end

@implementation MARHomeSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAliFeedbackVC];
}

- (void)UIGlobal
{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[kCellTitle_SelectStyle,
                        kCellTitle_PageScale,
                        kCellTitle_More];
    }
    return _titleArray;
}

- (NSArray *)homeStyleTitleArray
{
    if (!_homeStyleTitleArray) {
        _homeStyleTitleArray = @[@"横铺", @"外圆柱", @"内圆柱", @"外柱体", @"内柱体", @"圆环", @"内圆环", @"封面浏览", @"封面浏览2", @"时间流逝", @"时间流逝2", @"时间流逝3"];
    }
    return _homeStyleTitleArray;
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:AliFeedbackAppKey appSecret:AliFeedbackSecretKey];
    }
    return _feedbackKit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pageScaleTableCell"];
        UISlider *slider = [cell viewWithTag:1];
        if ([slider isKindOfClass:[UISlider class]]) {
            double pageScale = [MARUserDefault getDoubleBy:USERDEFAULTKEY_HomePageScale];
            if (pageScale <=1 && pageScale >= 0.5) {
                slider.value = pageScale;
            }
            [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    }
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.titleArray.count > indexPath.row) {
        cell.textLabel.text = self.titleArray[indexPath.row];
        if ([self.titleArray[indexPath.row] isEqualToString:kCellTitle_SelectStyle]) {
            NSNumber *typeNum = [MARUserDefault getNumberBy:USERDEFAULTKEY_HomeStyle];
            if (typeNum && [typeNum integerValue] <= 11) {
                cell.detailTextLabel.text = self.homeStyleTitleArray[[typeNum integerValue]];
            }
            else
            {
                cell.detailTextLabel.text = self.homeStyleTitleArray[7];
            }
        }
        else
        {
            cell.detailTextLabel.text = nil;
        }
    }
    return cell;
}

#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    if ([title isEqual:kCellTitle_SelectStyle]) {
        [self chooseHomeStyle];
    }
    else if ([title isEqual:kCellTitle_More])
    {
        UIViewController *moreVC = [UIViewController vcWithStoryboardName:kSBNAME_Mob storyboardId:kSBID_Mob_MenuVC];
        [self mar_pushViewController:moreVC animated:YES];
    }
    else if ([title isEqual:kCellTitle_Feedback])
    {
        if (self.feedbackVC) {
            [MARDataAnalysis setEventPage:@"HomeSettingVC" EventLabel:@"clickCell_aliFeedback"];
            self.feedbackVC.fd_interactivePopDisabled = YES;
            [self mar_pushViewController:self.feedbackVC animated:YES];
        }
    }
    
}

- (void)chooseHomeStyle
{
    //    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Carousel Type"
    //                                                       delegate:self
    //                                              cancelButtonTitle:nil
    //                                         destructiveButtonTitle:nil
    //                                              otherButtonTitles:@"Linear", @"Rotary", @"Inverted Rotary", @"Cylinder", @"Inverted Cylinder", @"Wheel", @"Inverted Wheel", @"CoverFlow", @"CoverFlow2", @"Time Machine", @"Inverted Time Machine", @"Custom", nil];
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择样式"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"横铺", @"外圆柱", @"内圆柱", @"外柱体", @"内柱体", @"圆环", @"内圆环", @"封面浏览", @"封面浏览2", @"时间流逝", @"时间流逝2", @"时间流逝3", nil];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择样式"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:self.homeStyleTitleArray[0], self.homeStyleTitleArray[1], self.homeStyleTitleArray[2], self.homeStyleTitleArray[3], self.homeStyleTitleArray[4], self.homeStyleTitleArray[5], self.homeStyleTitleArray[6], self.homeStyleTitleArray[7], self.homeStyleTitleArray[8], self.homeStyleTitleArray[9], self.homeStyleTitleArray[10], self.homeStyleTitleArray[11], nil];
    
    [sheet showInView:self.view];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0 && buttonIndex <= 11)
    {
        //map button index to carousel type
        iCarouselType type = buttonIndex;
        [MARGLOBALMANAGER postNotif:kMARNotificationType_ChooseHomeStyle data:@(type) object:nil];
        [self.tableView reloadData];
    }
}

- (void)sliderChanged:(UISlider *)slider
{
    if (slider.value >= 0.5 || slider.value <= 1) {
        [MARUserDefault setDouble:slider.value key:USERDEFAULTKEY_HomePageScale];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(postReloadHomeVTMagicViewNotification) object:nil];
        [self performSelector:@selector(postReloadHomeVTMagicViewNotification) withObject:@(slider.value) afterDelay:1.f];
    }
}

#pragma mark
- (void)postReloadHomeVTMagicViewNotification
{
    [MARGLOBALMANAGER postNotif:kMARNotificationType_NeedReloadHomeMagicView data:nil object:nil];
}

- (void)getAliFeedbackVC
{
    if (_feedbackVC) {
        return;
    }
    @weakify(self)
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        @strongify(self)
        if (!strong_self) return;
        if (viewController != nil) {
            strong_self.feedbackVC = viewController;
            strong_self.feedbackVC.closeBlock = ^(BCFeedbackViewController *feedbackController) {
                [feedbackController.navigationController popViewControllerAnimated:YES];
                NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:RGBHEX(APPNaviTint), NSForegroundColorAttributeName, [UIFont systemFontOfSize:kSCALE(15.f)], NSFontAttributeName, nil];
                [weak_self.navigationController.navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
            };
            strong_self.titleArray = @[kCellTitle_SelectStyle,
                            kCellTitle_PageScale,
                            kCellTitle_More,kCellTitle_Feedback];
            [strong_self.tableView reloadData];
        } else {

        }
    }];
}

- (void)getNotifType:(NSInteger)type data:(id)data target:(id)obj
{
    if (type == kMARNotificationType_NetworkChangedEnabel) {
        [self getAliFeedbackVC];
    }
}

@end
