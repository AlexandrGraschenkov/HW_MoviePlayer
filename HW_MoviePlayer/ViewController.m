//
//  ViewController.m
//  HW_MoviePlayer
//
//  Created by Alexander on 10.05.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
@import MediaPlayer;

@interface ViewController () { int seconds; }

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
   
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(durationTime:)name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTime)userInfo:nil repeats:YES];
    
    [moviePlayer play];
    
    [slider setValue:0];
    [playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.view addSubview:moviePlayer.view];
    
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
}


- (void)updateTime
{
    seconds = self.moviePlayer.currentPlaybackTime;
    currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d", seconds/60, seconds%60];
    if(seconds%60 < 10) {
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d", seconds/60, seconds%60];
    }
    [slider setValue:(seconds / [moviePlayer duration])];
}


- (void)durationTime:(NSNotification *)notification
{
    seconds = [moviePlayer duration];
    totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d", seconds/60, seconds%60];
    if(seconds%60 < 10) {
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d", seconds/60, seconds%60];
    }
}

- (IBAction)slider:(id)sender
{
    [moviePlayer setCurrentPlaybackTime:[slider value] * [moviePlayer duration]];
}




- (IBAction)play:(UIButton *)sender
{
    NSLog(@"%ld", (long)[moviePlayer playbackState]);
    if ([moviePlayer playbackState] == 1) {
        [moviePlayer pause];
        [playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else {
        [moviePlayer play];
        [playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

@end
