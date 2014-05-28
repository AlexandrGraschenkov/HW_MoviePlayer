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
{
    int currentTime;
}

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@property (nonatomic, strong) NSTimer *playerTimer;
@property (nonatomic) NSTimeInterval duration;

@end

@implementation ViewController
@synthesize moviePlayer, slider, totalTimeLabel, currentTimeLabel, playPauseButton, playerTimer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"movie" withExtension:@"mp4"];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTotalTime) name:MPMoviePlayerLoadStateDidChangeNotification object:moviePlayer];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.view.frame = self.view.bounds;
    moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
    [playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    [playPauseButton setSelected:YES];
    [self updateCurrentTime];
}

- (void)updateTotalTime
{
    _duration = [moviePlayer duration];
    int duration = (int) _duration;
    // почему он не обновляет (((
    dispatch_async(dispatch_get_main_queue(), ^{
        totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d", duration/60, duration%60];
    });
}

- (IBAction)play:(id)sender
{
    if ([moviePlayer playbackState] == MPMoviePlaybackStatePlaying)
    {
        [moviePlayer pause];
        [playPauseButton setSelected:YES];
    }
    else
    {
        [moviePlayer play];
        [self restartTimer];
        [playPauseButton setSelected:NO];
    }
}

- (void)restartTimer
{
    if (playerTimer && [playerTimer isValid])
    {
        [playerTimer invalidate];
    }
    playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                   target:self
                                                 selector:@selector(updateCurrentTime)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)updateCurrentTime
{
    currentTime = (int) [moviePlayer currentPlaybackTime];
    if (currentTime < 0)
    {
        currentTime = 0;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d", currentTime/60, currentTime%60];
        [slider setValue:([moviePlayer currentPlaybackTime] / _duration) animated:YES];
    });
}

- (IBAction)rewind:(id)sender
{
    [playerTimer invalidate];
    [self updateCurrentTime];
    [moviePlayer setCurrentPlaybackTime:[slider value] * _duration];
    [self restartTimer];
}

@end
