//
//  ViewController.m
//  HW_MoviePlayer
//
//  Created by Alexander on 10.05.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;

@interface ViewController ()
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@end

@implementation ViewController
@synthesize moviePlayer, slider, totalTimeLabel, currentTimeLabel, playPauseButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.view.frame = self.view.bounds;
    moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
    [moviePlayer play];
    [slider setValue:0];
    [playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
}
-(IBAction)playOrPause:(id)sender{
    if([moviePlayer playbackState]==MPMoviePlaybackStatePaused){
        [moviePlayer play];
        [playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else{
        [moviePlayer pause];
        [playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}
-(IBAction)goTo:(id)sender{
    [moviePlayer setCurrentPlaybackTime:[slider value] * [moviePlayer duration]];
}
-(void)updateTime{
    int time;
    time = self.moviePlayer.currentPlaybackTime;
    currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d", time/60, time%60];
    if(time%60 < 10) {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d", time/60, time%60];
    }
    int totalTime=[moviePlayer duration]-time;
    totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d", totalTime/60, totalTime%60];
    if(totalTime%60 < 10) {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d", totalTime/60, totalTime%60];
    }
    [slider setValue:(time / [moviePlayer duration])];
}

@end
