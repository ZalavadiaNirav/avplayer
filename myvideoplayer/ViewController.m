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

#define BETWEEN(value, min, max) (value < max && value > min)

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

-(BOOL)verifyPart :(void(^)(void))completionBlock
{
    int min = 0,max=0,i;
    status=false;
    currentSecond=CMTimeGetSeconds(videoPlayer.currentItem.currentTime);
    if([timeRange count]!=0)
    {
        for (int i=0; i<[timeRange count]; i++)
        {
            int tempval1=[[[timeRange objectAtIndex:i] objectForKey:@"start"] intValue];
            int tempval2=[[[timeRange objectAtIndex:i] objectForKey:@"stop"] intValue];
            if(min==0)
                min=tempval1;
            if (max==0)
                max=tempval2;
            if(min<tempval1)
                min=tempval1;
            if(max<tempval2)
                max=tempval2;
        }
        
        for(i=0;i<[timeRange count];i++)
        {
            int tempval1=[[[timeRange objectAtIndex:i] objectForKey:@"start"] intValue];
            int tempval2=[[[timeRange objectAtIndex:i] objectForKey:@"stop"] intValue];
            
            
            if((currentSecond != tempval1 ) && (currentSecond != tempval2)) //equal
            {
                if((tempval1<currentSecond) &&(currentSecond <tempval2)) //check range
                {
                    NSLog(@"is in range error 1");
                    status=false;
                    break;
                }
                else
                {
                    if(currentSecond>min)
                    {
                        NSLog(@"2");
                        if(currentSecond>max)
                        {
                            NSLog(@"insert3 ");
                            status=true;
                            
                        }
                        else
                        {
                            status=true;
                            NSLog(@"insert 4");
                        }
                    }
                    else if(currentSecond<min)
                    {
                        status=true;
                        NSLog(@"insert 5");
                        
                    }
                }
            }
            else
            {
                NSLog(@"5 error same value");
                status=false;
                break;
            }
        }
    }
    else
    {
        //first time insertion
        if(btnState &&[timeRange count]==0)
        {
            //first time insertion only
            [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"start"];
            
            btnState=false;
            [_startBtn setTitle:@"Stop Marking" forState:UIControlStateNormal];
        }
        else
        {
            [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"stop"];
            [self popMsg];
        }
    }
    
    NSLog(@"result %d cur %d",status,currentSecond);
    return status;
}



-(IBAction)StartMarking:(id)sender
{
    int min = -99,max=-99,i;
    status=false;
    currentSecond=CMTimeGetSeconds(videoPlayer.currentItem.currentTime);
    if([timeRange count]!=0)
    {
        for (int i=0; i<[timeRange count]; i++)
        {
            int tempval1=[[[timeRange objectAtIndex:i] objectForKey:@"start"] intValue];
            int tempval2=[[[timeRange objectAtIndex:i] objectForKey:@"stop"] intValue];
            if(min==-99)
                min=tempval1;
            if (max==-99)
                max=tempval2;
            if(min<tempval1)
                min=tempval1;
            if(max<tempval2)
                max=tempval2;
        }
        
        for(i=0;i<[timeRange count];i++)
        {
            int tempval1=[[[timeRange objectAtIndex:i] objectForKey:@"start"] intValue];
            int tempval2=[[[timeRange objectAtIndex:i] objectForKey:@"stop"] intValue];
            
            
            if((currentSecond != tempval1 ) && (currentSecond != tempval2)) //equal
            {
                if((tempval1<currentSecond) &&(currentSecond <tempval2)) //check range
                {
                    NSLog(@"is in range error 1");
                    status=false;
                    
                    UIAlertController *msg=[UIAlertController alertControllerWithTitle:@"Marking Failed" message:@"You have already marked in this timeline" preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:msg animated:YES completion:nil];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action){
                                                                   
                                                                   [msg dismissViewControllerAnimated:YES completion:nil];
                                                                   [videoPlayer play];
                                                                   
                                                               }];
                    [msg addAction:ok];
                    //                NSLog(@"fail");
                    btnState=true;
                    [_startBtn setTitle:@"Start Marking" forState:UIControlStateNormal];
                    [videoPlayer pause];

                    break;
                }
                else
                {
                    if(currentSecond>min)
                    {
                        NSLog(@"2");
                        if(currentSecond>max)
                        {
                            int previousStart=[[timeDict objectForKey:@"start"] intValue];

                            if((previousStart<max) && (btnState==false))
                            {
                                status=false;
                                NSLog(@"Error val is in range");
                                UIAlertController *msg=[UIAlertController alertControllerWithTitle:@"Marking Failed" message:@"You have already marked in this timeline" preferredStyle:UIAlertControllerStyleAlert];
                                [self presentViewController:msg animated:YES completion:nil];
                                
                                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * action){
                                                                               
                                                                               [msg dismissViewControllerAnimated:YES completion:nil];
                                                                               [videoPlayer play];
                                                                               
                                                                           }];
                                [msg addAction:ok];
                                //                NSLog(@"fail");
                                btnState=true;
                                [_startBtn setTitle:@"Start Marking" forState:UIControlStateNormal];
                                [videoPlayer pause];

                            }
                            else
                            {
                                NSLog(@"insert3 ");
                                status=true;
                            }
                            
                        }
                        else
                        {
                            status=true;
                            NSLog(@"insert 4");
                        }
                    }
                    else if(currentSecond<min)
                    {
                        status=true;
                        NSLog(@"insert 5");
                        
                    }
                }
            }
            else
            {
                NSLog(@"5 error same value");
                status=false;
                
                UIAlertController *msg=[UIAlertController alertControllerWithTitle:@"Marking Failed" message:@"You have already marked in this timeline" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:msg animated:YES completion:nil];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               
                                                               [msg dismissViewControllerAnimated:YES completion:nil];
                                                               [videoPlayer play];
                                                               
                                                           }];
                [msg addAction:ok];
                //                NSLog(@"fail");
                btnState=true;
                [_startBtn setTitle:@"Start Marking" forState:UIControlStateNormal];
                [videoPlayer pause];

                break;
            }
        }
    }
    else
    {
        //first time insertion
        if(btnState &&[timeRange count]==0)
        {
            //first time insertion only
            [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"start"];
            
            btnState=false;
            [_startBtn setTitle:@"Stop Marking" forState:UIControlStateNormal];
        }
        else
        {
            [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"stop"];
            [self popMsg];
        }
    }
    
    NSLog(@"result %d cur %d",status,currentSecond);
    
    
    if(status==true)
    {
        if(btnState)
        {
            [timeDict setObject:[NSString stringWithFormat:@"%d",currentSecond] forKey:@"start"];
            
            btnState=false;
            [_startBtn setTitle:@"Stop Marking" forState:UIControlStateNormal];
            
        }
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
                             
                             purposeStr=alertController.textFields[0].text;
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             [timeDict setObject:purposeStr forKey:@"purpose"];
                             [timeRange addObject:timeDict];
                             [_marketTbl reloadData];
                             timeDict=[[NSMutableDictionary alloc] init];
                             NSLog(@"time range %@",[timeRange description]);
                             btnState=TRUE;
                             [videoPlayer play];

                             [_startBtn setTitle:@"Start Marking" forState:UIControlStateNormal];
                         }];
    
    [alertController addAction:ok];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    [videoPlayer pause];
        textField.placeholder = @"Enter Marking Name";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
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
