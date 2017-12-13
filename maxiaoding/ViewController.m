//
//  ViewController.m
//  maxiaoding
//
//  Created by Martin.Liu on 2017/12/13.
//  Copyright © 2017年 MAIERSI. All rights reserved.
//

#import "ViewController.h"
#import <MobAPI/MobAPI.h>
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

- (IBAction)clickBtnAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickBtnAction:(id)sender {
    __weak __typeof(self) weakSelf = self;
    [MobAPI sendRequest:[MOBAWxArticleRequest wxArticleCategoryRequest] onResult:^(MOBAResponse *response) {
        if (!response.error) {
            NSLog(@"response : %@", response.responder);
            NSArray<MARWXArticleCategoryModel *> *articleArray = [NSArray mar_modelArrayWithClass:[MARWXArticleCategoryModel class] json:response.responder[@"result"]];
            
            NSLog(@"articles : %@", articleArray);
//            weakSelf.textView.text = [articleArray description];
            weakSelf.textView.text = articleArray[0].name;
        }
    }];
}
@end
