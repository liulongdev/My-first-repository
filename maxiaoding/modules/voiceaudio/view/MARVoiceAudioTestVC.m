//
//  MARVoiceAudioTestVC.m
//  maxiaoding
//
//  Created by Martin.Liu on 2018/3/19.
//  Copyright © 2018年 MAIERSI. All rights reserved.
//

#import "MARVoiceAudioTestVC.h"
#import "BDSEventManager.h"
#import "BDSASRDefines.h"
#import "BDSASRParameters.h"
@interface MARVoiceAudioTestVC () <BDSClientASRDelegate>
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)clickStartBtnAction:(UIButton *)sender;
- (IBAction)clickStopBtnAction:(UIButton *)sender;

@property (strong, nonatomic) BDSEventManager *asrEventManager;

@end

@implementation MARVoiceAudioTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.asrEventManager = [BDSEventManager createEventManagerWithName:BDS_ASR_NAME];
    
    //设置DEBUG_LOG的级别
    [self.asrEventManager setParameter:@(EVRDebugLogLevelTrace) forKey:BDS_ASR_DEBUG_LOG_LEVEL];
    //配置API_KEY 和 SECRET_KEY 和 APP_ID
    [self.asrEventManager setParameter:@[BAIDUYY_APIKEY, BAIDUYY_SECRETKEY] forKey:BDS_ASR_API_SECRET_KEYS];
    [self.asrEventManager setParameter:BAIDUYY_AppID forKey:BDS_ASR_OFFLINE_APP_CODE];
    //配置端点检测（二选一）
    [self configModelVAD];
    //      [self configDNNMFE];
    
    //     [self.asrEventManager setParameter:@"15361" forKey:BDS_ASR_PRODUCT_ID];
    // ---- 语义与标点 -----
    [self enableNLU];
    //    [self enablePunctuation];
    // ------------------------
}

- (void)configModelVAD {
    NSString *modelVAD_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_basic_model" ofType:@"dat"];
    [self.asrEventManager setParameter:modelVAD_filepath forKey:BDS_ASR_MODEL_VAD_DAT_FILE];
    [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_ENABLE_MODEL_VAD];
}

- (void)configDNNMFE {
    NSString *mfe_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_dnn" ofType:@"dat"];
    [self.asrEventManager setParameter:mfe_dnn_filepath forKey:BDS_ASR_MFE_DNN_DAT_FILE];
    NSString *cmvn_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_cmvn" ofType:@"dat"];
    [self.asrEventManager setParameter:cmvn_dnn_filepath forKey:BDS_ASR_MFE_CMVN_DAT_FILE];
    
    [self.asrEventManager setParameter:@(NO) forKey:BDS_ASR_ENABLE_MODEL_VAD];
    // MFE支持自定义静音时长
    //    [self.asrEventManager setParameter:@(500.f) forKey:BDS_ASR_MFE_MAX_SPEECH_PAUSE];
    //    [self.asrEventManager setParameter:@(500.f) forKey:BDS_ASR_MFE_MAX_WAIT_DURATION];
}

- (void) enableNLU {
    // ---- 开启语义理解 -----
    [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_ENABLE_NLU];
    [self.asrEventManager setParameter:@"1536" forKey:BDS_ASR_PRODUCT_ID];
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

- (IBAction)clickStartBtnAction:(UIButton *)sender {
    self.textView.text = @"";
//    AudioInputStream *stream = [[AudioInputStream alloc] init];
//    [self.asrEventManager setParameter:stream forKey:BDS_ASR_AUDIO_INPUT_STREAM];
//    [self.asrEventManager setParameter:@"" forKey:BDS_ASR_AUDIO_FILE_PATH];
    [self.asrEventManager setDelegate:self];
//    [self.asrEventManager sendCommand:BDS_ASR_CMD_START];
    
    // 发送指令：启动识别
    [self.asrEventManager sendCommand:BDS_ASR_CMD_START];
}

- (IBAction)clickStopBtnAction:(UIButton *)sender {
}

- (void)VoiceRecognitionClientWorkStatus:(int)workStatus obj:(id)aObj
{
    switch (workStatus) {
            case EVoiceRecognitionClientWorkStatusNewRecordData:{
                
                break;
            }
            case EVoiceRecognitionClientWorkStatusStartWorkIng:{
                NSDictionary *logDic = [self parseLogToDic:aObj];
                [self logAppendStr:[NSString stringWithFormat:@"CALLBACK: start vr, log: %@\n", logDic]];
                break;
            }
            case EVoiceRecognitionClientWorkStatusStart:{
                [self logAppendStr:@"CALLBACK: detect voice start point.\n"];
                break;
            }
            case EVoiceRecognitionClientWorkStatusFlushData:{
                [self logAppendStr:[NSString stringWithFormat:@"CALLBACK: partial result - %@.\n\n", [self getDescriptionForDic:aObj]]];
                break;
            }
            case EVoiceRecognitionClientWorkStatusFinish:{
                [self logAppendStr:[NSString stringWithFormat:@"CALLBACK: final result - %@.\n\n", [self getDescriptionForDic:aObj]]];
            }
            case EVoiceRecognitionClientWorkStatusChunkEnd:{
                [self logAppendStr:[NSString stringWithFormat:@"CALLBACK: Chunk end, sn: %@.\n", aObj]];
                break;
            }
            case EVoiceRecognitionClientWorkStatusEnd:{
                [self logAppendStr:@"CALLBACK: detect voice end point.\n"];
                break;
            }
            
        
        default:
            break;
    }
}

- (void)logAppendStr:(NSString *)str
{
    self.textView.text = [str stringByAppendingString:self.textView.text];
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (NSString *)getDescriptionForDic:(NSDictionary *)dic {
    if (dic) {
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic
                                                                              options:NSJSONWritingPrettyPrinted
                                                                                error:nil] encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSDictionary *)parseLogToDic:(NSString *)logString
{
    NSArray *tmp = NULL;
    NSMutableDictionary *logDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSArray *items = [logString componentsSeparatedByString:@"&"];
    for (NSString *item in items) {
        tmp = [item componentsSeparatedByString:@"="];
        if (tmp.count == 2) {
            [logDic setObject:tmp.lastObject forKey:tmp.firstObject];
        }
    }
    return logDic;
}

@end
