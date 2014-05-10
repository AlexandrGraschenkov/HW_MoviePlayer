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
    [moviePlayer play];
    [self.view addSubview:moviePlayer.view];
    [self.view sendSubviewToBack:moviePlayer.view];
}

@end
