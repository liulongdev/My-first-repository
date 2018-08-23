//
//  MAROpencvTestVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/6/15.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MAROpencvTestVC.h"
//#import <opencv2/core/core.hpp>
//#import <opencv2/features2d/features2d.hpp>
//#import <opencv2/highgui/highgui.hpp>
#import <opencv2/opencv.hpp>
#import "MAROpenCVUtil.h"

@interface MAROpencvTestVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *otherImageView;
@property (strong, nonatomic) UIImage *selectImage;
@property (strong, nonatomic) UIImage *otherSelectImage;
- (IBAction)clickSelectImageBtnAction:(id)sender;
- (IBAction)clickTestBtnAction:(id)sender;

@end

@implementation MAROpencvTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark - ImagePick delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!self.selectImage) {
        self.selectImage = image;
        self.imageView.image = self.selectImage;
    }
    else
    {
        self.otherSelectImage = image;
        self.otherImageView.image = self.otherSelectImage;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickSelectImageBtnAction:(id)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)clickTestBtnAction:(id)sender {
    if (!self.selectImage || !self.otherSelectImage) {
        return;
    }
    
    [MAROpenCVUtil test3:self.selectImage other:self.otherSelectImage];
}
@end
