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

@interface ViewController : UIViewController <AVPlayerViewControllerDelegate>
{
    AVPlayer *videoPlayer;
    AVAsset *avAsset;
    AVPlayerItem *playerItem;
    AVPlayerViewController *playerVC;
}
@property (nonatomic,retain)AVPlayer *videoPlayer;
@property (weak) id timeObserver;
@end

