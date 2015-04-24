//
//  InicioViewController.m
//  TesteImagemBotoes
//
//  Created by Murilo Gasparetto on 23/04/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "InicioViewController.h"
#import "ImageViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface InicioViewController ()
{
    AVAudioPlayer *background;
}

@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation InicioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bg.image = [UIImage imageNamed:@"tela_inicio.png"];
    self.logo.image = [UIImage imageNamed:@"logo 4.png"];
    
//    NSString *path;
//    NSURL *soundUrl;
//    
//    path = [NSString stringWithFormat:@"%@/background.mp3", [[NSBundle mainBundle] resourcePath]];
//    soundUrl = [NSURL fileURLWithPath:path];
//    background = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
//    background.numberOfLoops = -1;
//    [background play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (IBAction)nextView:(id)sender
{
    
    ImageViewController *jogo = [[ImageViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:jogo animated:NO];
    
}

- (void) stopBackground {
    [background stop];
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
