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
    
    _marketTbl.dataSource=self;
    _marketTbl.delegate=self;
    btnState=TRUE;
    timeRange=[[NSMutableArray alloc] init];
    timeDict=[[NSMutableDictionary alloc] init];

    
    NSURL *asseturl=[[NSBundle mainBundle] URLForResource:@"video1" withExtension:@"mov"];
    playerItem = [AVPlayerItem playerItemWithURL:asseturl];
    

    videoPlayer=[[AVPlayer alloc] initWithPlayerItem:playerItem];
    
    playerVC=[[AVPlayerViewController alloc] init];
    [self addChildViewController:playerVC];
    

    playerVC.delegate=self;
    [playerVC setPlayer:videoPlayer];
    playerVC.showsPlaybackControls=YES;
    playerVC.view.frame = CGRectMake(0,0,420,300);
    
//    Float64 startSeconds = 60.0f;
//    CMTime startTime = CMTimeMakeWithSeconds(startSeconds, NSEC_PER_SEC);
//    [videoPlayer seekToTime:startTime
//            toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
/*    [videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
                    NSLog(@"Current time %f",CMTimeGetSeconds(time));
    }];
  */
    [videoPlayer play];
    [self.view addSubview:playerVC.view];
    
}

-(IBAction)StartMarking:(id)sender
{
//    NSLog(@"current time %f", CMTimeGetSeconds(videoPlayer.currentItem.currentTime));
    currentSecond=CMTimeGetSeconds(videoPlayer.currentItem.currentTime);
    
    if(btnState)
    {
        //already started state
        [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"start"];

        btnState=false;
        [_startBtn setTitle:@"Stop Marking" forState:UIControlStateNormal];

    }
    else
    {
        //stop state
        if([timeRange count]>0)
            [self verifyPart];
        else
        {
            [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"stop"];
            [self popMsg];
        }
        
    }
}

-(void)popMsg
{
    alertController=   [UIAlertController
                        alertControllerWithTitle:@"Which part of Video marked ?"
                        message:@"Name of marking"
                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             //Do Some action here
                             purposeStr=alertController.textFields[0].text;
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             [timeDict setObject:purposeStr forKey:@"purpose"];
                             [timeRange addObject:timeDict];
                             [_marketTbl reloadData];
                             timeDict=[[NSMutableDictionary alloc] init];
                             NSLog(@"time range %@",[timeRange description]);
                             btnState=TRUE;
                             [_startBtn setTitle:@"Start Marking" forState:UIControlStateNormal];
                         }];
    
    [alertController addAction:ok];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter Marking Name";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)verifyPart
{
    BOOL pass = false;
    for (int i=0; i<[timeRange count]; i++)
    {
        NSString *tempstart=[NSString stringWithFormat:@"%@",[[timeRange objectAtIndex:i] objectForKey:@"start"]];
        int tempval1=[tempstart intValue];
        NSString *tempstop=[NSString stringWithFormat:@"%@",[[timeRange objectAtIndex:i] objectForKey:@"stop"]];
        int tempval2=[tempstop intValue];
        if((currentSecond!=tempval1)||(currentSecond!=tempval2))
        {
            if(((currentSecond>tempval1)&&(currentSecond>tempval2)) ||((currentSecond<tempval1) &&(currentSecond<tempval2)))
            {
                    NSLog(@"pass");
                    pass=true;
            }
        }
        else
        {
            NSLog(@"fail");
           
            pass=false;
        }
    }
    if (pass==true)
    {
        [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"stop"];
        [self popMsg];
    }
    else
    {
        NSLog(@"fail");
        
    }

}


#pragma mark - marking Table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeRange count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text=[NSString stringWithFormat:@"Name - %@ Start -%@ Stop -%@",[[timeRange objectAtIndex:indexPath.row] objectForKey:@"purpose"],[[timeRange objectAtIndex:indexPath.row] objectForKey:@"start"],[[timeRange objectAtIndex:indexPath.row] objectForKey:@"stop"]];
        
    }
    
 
    return cell;

}
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



-(void)pause1
{
    [videoPlayer pause];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
