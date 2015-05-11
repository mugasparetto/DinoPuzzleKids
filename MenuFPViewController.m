//
//  MenuFPViewController.m
//  DinoPuzzleKids
//
//  Created by Murilo Gasparetto on 28/04/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "MenuFPViewController.h"
#import "ImageViewController.h"
#import "AppDelegate.h"

@interface MenuFPViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (nonatomic) AppDelegate *delegate;

@end

@implementation MenuFPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
    
    self.bg.image = [UIImage imageNamed:@"tela_inicio.png"];
    self.logo.image = [UIImage imageNamed:@"logo 4.png"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (IBAction)easyView:(id)sender
{
    
    ImageViewController *easy = [[ImageViewController alloc] initWithNibName:nil bundle:nil];
    easy.origem = 0;
    [self.navigationController pushViewController:easy animated:NO];
    
}

- (IBAction)mediumView:(id)sender
{
    
    ImageViewController *medium = [[ImageViewController alloc] initWithNibName:nil bundle:nil];
    medium.origem = 1;
    [self.navigationController pushViewController:medium animated:NO];
    
}

- (IBAction)hardView:(id)sender
{
    
    ImageViewController *hard = [[ImageViewController alloc] initWithNibName:nil bundle:nil];
    hard.origem = 2;
    [self.navigationController pushViewController:hard animated:NO];
    
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
