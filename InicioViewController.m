//
//  InicioViewController.m
//  TesteImagemBotoes
//
//  Created by Murilo Gasparetto on 23/04/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "InicioViewController.h"
#import "MenuFPViewController.h"

@interface InicioViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@implementation InicioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

- (IBAction)nextView:(id)sender
{
    
    MenuFPViewController *menuFP = [[MenuFPViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:menuFP animated:NO];
    
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
