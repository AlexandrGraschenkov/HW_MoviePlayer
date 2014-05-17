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
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UILabel *currentTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalTimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *playPauseButton;
@end

@implementation ViewController {
    NSTimer *pollingTimer;
    UIView *movieView;
}
@synthesize moviePlayer, slider, totalTimeLabel, currentTimeLabel, playPauseButton, controlsView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerLoaded) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];


    [self setupPlayer];
    
    [self play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupPlayer {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video" withExtension:@"mp4"];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.view.frame = self.view.bounds;
    moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [movieView removeFromSuperview];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
    singleTapRecognizer.delegate = self;
    [singleTapRecognizer setNumberOfTapsRequired:1];
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playButtonPressed:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    doubleTapRecognizer.delegate = self;
    
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    
    movieView = moviePlayer.view;
    
    [movieView addGestureRecognizer:singleTapRecognizer];
    [movieView addGestureRecognizer:doubleTapRecognizer];
    
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)toggleControls {
    if ([controlsView isHidden]) {
        [controlsView setHidden:NO];
        
        CGRect frame = controlsView.frame;
        frame.origin.y -= frame.size.height;
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [controlsView setFrame:frame];
        } completion:NULL];
    } else {
        CGRect frame = controlsView.frame;
        frame.origin.y += frame.size.height;
        
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [controlsView setFrame:frame];
        } completion:^(BOOL finished) {
            [controlsView setHidden:YES];
        }];
    }
}

- (void)play {
    if (pollingTimer) {
        [pollingTimer invalidate];
        pollingTimer = nil;
    }
    
    pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeChanged) userInfo:nil repeats:YES];
    [moviePlayer play];
}

- (void)pause {
    if (pollingTimer) {
        [pollingTimer invalidate];
        pollingTimer = nil;
    }
    
    [moviePlayer pause];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSDate *dateInterval = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm:ss"];
    return [formatter stringFromDate:dateInterval];
}

- (IBAction)timeSliderValueChanged:(id)sender {
    [currentTimeLabel setText:[self stringFromTimeInterval:slider.value*[moviePlayer duration]]];
}

- (IBAction)timeSliderEndSliding:(id)sender {
    NSTimeInterval duration = [moviePlayer duration];
    NSTimeInterval newTime = duration * slider.value;
    [moviePlayer setCurrentPlaybackTime:newTime];
    [self timeChanged];
}

- (IBAction)playButtonPressed:(id)sender {
    if ([moviePlayer playbackState] == MPMoviePlaybackStatePlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)timeChanged {
    NSTimeInterval currentTime = [moviePlayer currentPlaybackTime];
    NSTimeInterval duration = [moviePlayer duration];
    
    if (![slider isSelected]) {
        [slider setValue:currentTime/duration];
        [currentTimeLabel setText:[self stringFromTimeInterval:currentTime]];
    }
}

- (void)playbackChanged {
    if ([moviePlayer playbackState] == MPMoviePlaybackStatePlaying) {
        [playPauseButton setSelected:YES];
    } else if ([moviePlayer playbackState] == MPMoviePlaybackStatePaused ||
               [moviePlayer playbackState] == MPMoviePlaybackStateStopped) {
        [playPauseButton setSelected:NO];
    }
}

- (void)playbackFinished {
    [self setupPlayer];
}

- (void)playerLoaded {
    if ([moviePlayer loadState] == MPMovieLoadStatePlaythroughOK) {
        [totalTimeLabel setText:[self stringFromTimeInterval:[moviePlayer duration]]];
    }
}

@end
