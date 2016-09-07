//
//  ViewController.h
//  myvideoplayer
//
//  Created by Gaurav Amrutiya on 03/09/16.
//  Copyright © 2016 Gaurav Amrutiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVPlayerViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>
{
    AVPlayer *videoPlayer;
    AVAsset *avAsset;
    AVPlayerItem *playerItem;
    AVPlayerViewController *playerVC;
    BOOL btnState;
    NSMutableArray *timeRange;
    NSMutableDictionary *timeDict;
    int currentSecond,maxVal;
    UITextField * namefield;
    NSString *purposeStr;
    UIAlertController *alertController;
    BOOL pass,status,isInsert;
}

-(IBAction)StartMarking:(id)sender;
-(void)popMsg;
-(BOOL)verifyPart: (void (^)(void))completionBlock;

@property (weak, nonatomic) IBOutlet UITableView *marketTbl;
@property (nonatomic,retain)IBOutlet UIButton *startBtn;
@property (nonatomic,retain)AVPlayer *videoPlayer;
@property (weak) id timeObserver;


@end

