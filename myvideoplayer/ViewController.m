//
//  ViewController.m
//  myvideoplayer
//
//  Created by Gaurav Amrutiya on 03/09/16.
//  Copyright © 2016 Gaurav Amrutiya. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize videoPlayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *asseturl=[[NSBundle mainBundle] URLForResource:@"video1" withExtension:@"mov"];
    playerItem = [AVPlayerItem playerItemWithURL:asseturl];
    
//    Float64 statTimeForVideo=60.0f;
//    NSInteger step = (NSInteger)(statTimeForVideo/0.04);
//    [playerItem stepByCount:step];
    playerItem.forwardPlaybackEndTime=CMTimeMakeWithSeconds(120.0f,NSEC_PER_SEC);
    videoPlayer=[[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    playerVC=[[AVPlayerViewController alloc] init];
    [self addChildViewController:playerVC];
    

    playerVC.delegate=self;
    [playerVC setPlayer:videoPlayer];
    playerVC.showsPlaybackControls=YES;
    playerVC.view.frame = CGRectMake(0,0,400,300);
    
    Float64 startSeconds = 60.0f;
//    Float64 endSecond=120.0f;
    CMTime startTime = CMTimeMakeWithSeconds(startSeconds, NSEC_PER_SEC);
//    CMTime endTime=CMTimeMakeWithSeconds(endSecond, NSEC_PER_SEC);
    
    
    
//    [videoPlayer seekToTime:startTime
//            toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [videoPlayer seekToTime:startTime];
   

    [videoPlayer play];
    [self.view addSubview:playerVC.view];
    
    //this observer stop player at Video time duration of 2:00
    /*
    CMTime endTime = CMTimeMakeWithSeconds(120.0f,NSEC_PER_SEC);
    _timeObserver = [videoPlayer addBoundaryTimeObserverForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:endTime]] queue:NULL usingBlock:^(void) {
        NSLog(@"observe called");
        
        
        [self.videoPlayer pause];
        videoPlayer.rate=0;
        [videoPlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
        //        [self nextButtonTapped:nil];
    }];
*/
   
/*
  this will replay video
 
 avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(playerItemDidReachEnd:)
 name:AVPlayerItemDidPlayToEndTimeNotification
 object:[avPlayer currentItem]];
 
 
    - (void)playerItemDidReachEnd:(NSNotification *)notification {
        AVPlayerItem *p = [notification object];
        [p seekToTime:kCMTimeZero];
    }
*/
}



-(void)pause1
{
    [videoPlayer pause];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
