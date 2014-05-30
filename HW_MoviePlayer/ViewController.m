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
@property (nonatomic, strong) NSTimer *fetchTimer;
@end

@implementation ViewController
@synthesize moviePlayer, slider, totalTimeLabel, currentTimeLabel, playPauseButton, fetchTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.view.frame = self.view.bounds;
    moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self playbackToggle:self];
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
    
    fetchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setTimeToBarView:) userInfo:nil repeats:YES];
}

-(IBAction)setTimeToBarView:(id)sender {
    NSTimeInterval currentTime = [moviePlayer currentPlaybackTime];
    NSTimeInterval currentDuration = [moviePlayer duration];
    
    [slider setValue: currentTime / currentDuration];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    
    NSString *textForCurrentTimeLabel = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentTime]];
    NSString *textForEndTimeLabel = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:currentDuration]];
    
    [currentTimeLabel setText:textForCurrentTimeLabel];
    [totalTimeLabel setText:textForEndTimeLabel];
}

- (IBAction)currentTimeChanged:(id)sender {
    [moviePlayer setCurrentPlaybackTime:slider.value*moviePlayer.duration];
}

- (IBAction)playbackToggle:(id)sender {
    if (playPauseButton.selected) {
        [moviePlayer pause];
        [playPauseButton setSelected:NO];
    } else {
        [moviePlayer play];
        [playPauseButton setSelected:YES];
    }
}


@end
