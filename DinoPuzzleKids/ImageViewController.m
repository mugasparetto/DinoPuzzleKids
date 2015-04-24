//
//  ImageViewController.m
//  TesteImagemBotoes
//
//  Created by Murilo Gasparetto on 20/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageViewController.h"
#import "contadorDireita.h"
#import "contadorEsquerda.h"
#import "contadorBaixo.h"
#import "contadorCima.h"
#import "contadorAngle.h"
#import "Coordenadas.h"

@interface ImageViewController () <UIScrollViewDelegate>

{
    AVAudioPlayer *background;
    AVAudioPlayer *encaixou;
    int _startMusica;
}

@property (weak, nonatomic) IBOutlet UIImageView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIImageView *base2;
@property (weak, nonatomic) IBOutlet UIImageView *base1;

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *pontLabel;
@property (nonatomic, weak) IBOutlet UIImageView *personagem;
@property (nonatomic) UIImageView *sombra;
@property (nonatomic) CGFloat anglo;
@property CGSize startSize;
@property CGPoint startPoint;
@property (weak, nonatomic) IBOutlet UIImageView *bg;

@property (nonatomic) contadorDireita *objetoContadorDireto;
@property (nonatomic) contadorEsquerda *objetoContadorEsquerda;
@property (nonatomic) contadorBaixo *objetoContadorBaixo;
@property (nonatomic) contadorCima *objetoContadorCima;
@property (nonatomic) contadorAngle *objetoContadorAngle;
@property (nonatomic) Coordenadas *vetoresCoordenadas;

@property (weak, nonatomic) IBOutlet UIView *areaJogo;
@property (nonatomic) NSMutableArray *matrizX;
@property (nonatomic) NSMutableArray *matrizY;
@property (nonatomic) NSMutableArray *matrizSombraX;
@property (nonatomic) NSMutableArray *matrizSombraY;
@property (nonatomic) NSInteger i;
@property (nonatomic) NSInteger j;
@property (nonatomic) float largura;
@property (nonatomic) float altura;
@property (nonatomic) float x0;
@property (nonatomic) float y0;
@property (nonatomic) int sorteioX;
@property (nonatomic) int sorteioY;

@property (nonatomic) NSInteger sorteado;
@property (nonatomic) int pont;

@end

@implementation ImageViewController

@synthesize btnCima, btnBaixo, btnDir, btnEsq, btnAngloDir, btnAngloEsq;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        self.anglo = 0;
        _startMusica = 1;
        self.tabBarItem.title = @"Jogo";
        UIImage *i = [UIImage imageNamed:@"IconeGame2.png"];
        self.tabBarItem.image = i;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sorteado = 0;
    self.pont =0 ;
    
    self.sombras = [[NSMutableArray alloc] init];
    self.imagens = [[NSMutableArray alloc] init];
    
    [self.score setFont:[UIFont fontWithName:@"foo" size:30]];
    [self.pontLabel setFont:[UIFont fontWithName:@"foo" size:30]];
    [self.pontLabel setText: [NSString stringWithFormat:@"%d", self.pont]];
    
    [self.sombras addObject:[UIImage imageNamed:@"sombra_dino1.png"]];
    [self.sombras addObject:[UIImage imageNamed:@"sombra_dino2.png"]];
    [self.sombras addObject:[UIImage imageNamed:@"sombra_dino3.png"]];
    [self.imagens addObject:[UIImage imageNamed:@"dino1.png"]];
    [self.imagens addObject:[UIImage imageNamed:@"dino2.png"]];
    [self.imagens addObject:[UIImage imageNamed:@"dino3.png"]];
    
    self.startSize = self.personagem.frame.size;
    self.objetoContadorEsquerda = [contadorEsquerda instance];
    self.objetoContadorDireto = [contadorDireita instance];
    self.objetoContadorCima = [contadorCima instance];
    self.objetoContadorBaixo = [contadorBaixo instance];
    self.objetoContadorAngle = [contadorAngle instance];
    self.vetoresCoordenadas = [Coordenadas instance];
    
    self.sombra = [[UIImageView alloc] init];
    self.sombra.layer.anchorPoint = CGPointMake (0.5, 0.5);
    self.personagem.layer.anchorPoint = CGPointMake (0.5, 0.5);
    
    
    [self resetImagem];
    
    [self.view insertSubview:self.sombra belowSubview:self.personagem];
    // Do any additional setup after loading the view from its nib.
    
    NSString *path;
    NSURL *soundUrl;
    
    path = [NSString stringWithFormat:@"%@/background.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    background = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    background.numberOfLoops = -1;
    [background setVolume:0.1];
    [background play];
    
    path = [NSString stringWithFormat:@"%@/encaixe.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    encaixou = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [encaixou setDelegate:self];
    encaixou.numberOfLoops = 0;

    [self.viewAlert setHidden:YES];
    
    self.resetou = YES;
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.vetoresCoordenadas.resetou){
        self.anglo = 0;
        self.personagem.transform = CGAffineTransformMakeRotation(self.anglo);
        [self.personagem setFrame:CGRectMake(110, 190, self.startSize.width, self.startSize.height)];
        self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
        [self resetImagem];
        self.vetoresCoordenadas.resetou = NO;
    }
    
    self.scroll.delegate = self;
    self.scroll.bounces = NO;
    self.scroll.bouncesZoom = NO;

}

- (void) initZoom {
    float minZoom =self.scroll.bounds.size.height / self.contentView.image.size.height;
    if (minZoom > 1) return;
    
    //0.526236
    
    self.scroll.minimumZoomScale = minZoom;
    
    self.scroll.zoomScale = minZoom;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}


- (void)viewDidLayoutSubviews{
    //ESSE TA CERTO CARAIOOO
    NSNumber *auxX, *auxY, *auxAng;
    
    if (self.resetou) {
        
    
    //--------------------------definição da matriz de jogo
    self.matrizX = [[NSMutableArray alloc] init];
    self.matrizY = [[NSMutableArray alloc] init];
    
    self.largura = self.areaJogo.frame.size.width;
    self.altura = self.areaJogo.frame.size.height;
    self.x0 = self.areaJogo.frame.origin.x;
    self.y0 = self.areaJogo.frame.origin.y;
    
    NSNumber *point;
    
    for (int a=self.x0 + self.personagem.frame.size.width/2; a<=self.largura; a+=20){
        point = [NSNumber numberWithInt:a];
        [self.matrizX addObject:point];
    }
    
    for (int b=self.y0 + self.personagem.frame.size.height/2; b<=self.altura; b+=20){
        point = [NSNumber numberWithInt:b];
        [self.matrizY addObject:point];
    }
    
    self.matrizSombraX = [[NSMutableArray alloc] initWithArray:self.matrizX];
    self.matrizSombraY = [[NSMutableArray alloc] initWithArray:self.matrizY];
    
    [self.matrizSombraX removeObjectAtIndex:[self.matrizSombraX count] -1];
    [self.matrizSombraX removeObjectAtIndex:0];
    
    [self.matrizSombraY removeObjectAtIndex:[self.matrizSombraY count] -1];
    [self.matrizSombraY removeObjectAtIndex:0];
    
    
    NSInteger countX = [self.matrizSombraX count];
    NSInteger countY = [self.matrizSombraY count];
    self.vetoresCoordenadas.sorteioAng = arc4random()%17;
    if (self.vetoresCoordenadas.sorteioAng != 0 || self.vetoresCoordenadas.sorteioAng != 9)
    {
        self.sorteioX = arc4random()%(countX-1);
        self.sorteioY = arc4random()%(countY-1);
    }
    else
    {
        self.sorteioX = arc4random()%countX;
        self.sorteioY = arc4random()%countY;
    }
    
    auxX = [self.matrizSombraX objectAtIndex:self.sorteioX];
    auxY = [self.matrizSombraY objectAtIndex:self.sorteioY];
    auxAng = [self.vetoresCoordenadas.angle objectAtIndex:self.vetoresCoordenadas.sorteioAng];
    
    
    self.sombra.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
    self.sombra.center = CGPointMake([auxX integerValue],[auxY integerValue]);
    self.sombra.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
    self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
    
    
    //colocando personagem na matriz
    if (countX%2 == 0){
        auxX = [self.matrizX objectAtIndex:countX/2];
        auxY = [self.matrizY objectAtIndex:countY];
        self.i = countX/2;
        self.j = countY;
        self.personagem.center = CGPointMake([auxX integerValue], [auxY integerValue]);
    }
    else {
        auxX = [self.matrizX objectAtIndex:(countX+1)/2];
        auxY = [self.matrizY objectAtIndex:countY];
        self.i = (countX+1)/2;
        self.j = countY;
        self.personagem.center = CGPointMake([auxX integerValue], [auxY integerValue]);
    }
    
    self.startPoint = self.personagem.center;
        
        
    [self initZoom];
        
        [self.view insertSubview:self.base2 belowSubview:self.base1];
    
        
    }
    
    auxX = [self.matrizX objectAtIndex:self.i];
    auxY = [self.matrizY objectAtIndex:self.j];
    self.personagem.center = CGPointMake([auxX integerValue], [auxY integerValue]);
    
    NSLog (@"ENTROOU");
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)praBaixo:(id)sender {
    if (self.j < [self.matrizY count]-1) {
        self.j = self.j + 1;
        [self.personagem setCenter: CGPointMake(self.personagem.center.x, [[self.matrizY objectAtIndex:self.j] integerValue])];
        
        [self.personagem setBounds:CGRectMake(0, 0,
                                              self.startSize.width, self.startSize.height)];
    }
    
    [self verificarEncaixe];
    
}

- (IBAction)praCima:(id)sender{
    if (self.j > 0) {
        self.j = self.j - 1;
        [self.personagem setCenter: CGPointMake(self.personagem.center.x, [[self.matrizY objectAtIndex:self.j] integerValue])];
        
        [self.personagem setBounds:CGRectMake(0, 0,
                                         self.startSize.width, self.startSize.height)];
        
    }
    
    [self verificarEncaixe];
  
}

- (IBAction)praDireita:(id)sender{
    if (self.personagem.center.x < self.x0 + self.largura - self.personagem.frame.size.width/2) {
        self.i = self.i + 1;
        [self.personagem setCenter:CGPointMake([[self.matrizX objectAtIndex:self.i] integerValue], self.personagem.center.y)];
        
        [self.personagem setBounds:CGRectMake(0, 0,
                                         self.startSize.width, self.startSize.height)];
        
    }
    
    [self verificarEncaixe];
    
}

- (IBAction)praEsquerda:(id)sender{
    if (self.personagem.center.x > self.x0 + self.personagem.frame.size.width/2) {
        self.i = self.i - 1;
        [self.personagem setCenter:CGPointMake([[self.matrizX objectAtIndex:self.i] integerValue], self.personagem.center.y)];
        
        [self.personagem setBounds:CGRectMake(0, 0,
                                         self.startSize.width, self.startSize.height)];
        
        [self.objetoContadorEsquerda maisUm];
    }
    
    [self verificarEncaixe];
}

- (IBAction)rotacaoHorario:(id)sender{
    self.anglo = self.anglo + .34906585;
    self.personagem.transform = CGAffineTransformMakeRotation(self.anglo);
    [self.objetoContadorAngle maisVinte];
    
    [self verificarEncaixe];
}

- (IBAction)rotacaoAntiHorario:(id)sender{
    self.anglo = self.anglo - .34906585;
    self.personagem.transform = CGAffineTransformMakeRotation(self.anglo);
    [self.objetoContadorAngle menosVinte];
    
    [self verificarEncaixe];
}

- (IBAction)play:(id)sender{
    
    int aux = 1;
    
    if ([sender isSelected]) {
        [background play];
        aux = 1;
//        UIImage *unselectedImage = [UIImage imageNamed:@"volume_on.png"];
//        [sender setBackgroundImage:unselectedImage forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    
    else{
        [background stop];
        aux = 0;
        //UIImage *selectedImage = [UIImage imageNamed:@"volume_off.png"];
        //[sender setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
    _startMusica = aux;
    self.resetou = NO;

}


- (IBAction)btnReset:(id)sender{
    //self.resetou = YES;
    [self reset];
}

- (void) verificarEncaixe {
    
    if (trunc(self.personagem.frame.origin.x*100)/100 == trunc(self.sombra.frame.origin.x*100)/100 ){
        if (trunc(self.personagem.frame.origin.y*100)/100 == trunc(self.sombra.frame.origin.y*100)/100){
            
            printf("\n\n");
            printf("M: a:%f b:%f c:%f d:%f tx:%f ty:%f \n",
                   trunc(self.personagem.transform.a*10)/10, trunc(self.personagem.transform.b*10)/10,
                   trunc(self.personagem.transform.c*10)/10, trunc(self.personagem.transform.d*10)/10,
                   trunc(self.personagem.transform.tx*10)/10, trunc(self.personagem.transform.ty*10)/10 );
            
            printf("S: a:%f b:%f c:%f d:%f tx:%f ty:%f \n",
                   trunc(self.sombra.transform.a*10)/10, trunc(self.sombra.transform.b*10)/10,
                   trunc(self.sombra.transform.c*10)/10, trunc(self.sombra.transform.d*10)/10,
                   trunc(self.sombra.transform.tx*10)/10, trunc(self.sombra.transform.ty*10)/10 );
            printf("\n\n");
            printf("M4: a:%f b:%f c:%f d:%f tx:%f ty:%f \n",
                   trunc((self.personagem.transform.a + 0.04)*10)/10, trunc((self.personagem.transform.b + 0.04)*10)/10,
                   trunc((self.personagem.transform.c + 0.04)*10)/10, trunc((self.personagem.transform.d + 0.04)*10)/10,
                   trunc((self.personagem.transform.tx + 0.04)*10)/10, trunc((self.personagem.transform.ty + 0.04)*10)/10);
            
            printf("S4: a:%f b:%f c:%f d:%f tx:%f ty:%f \n",
                   trunc((self.sombra.transform.a + 0.04)*10)/10, trunc((self.sombra.transform.b + 0.04)*10)/10,
                   trunc((self.sombra.transform.c + 0.04)*10)/10, trunc((self.sombra.transform.d + 0.04)*10)/10,
                   trunc((self.sombra.transform.tx + 0.04)*10)/10, trunc((self.sombra.transform.ty + 0.04)*10)/10);
            
            if (trunc((self.personagem.transform.a + 0.04)*10)/10  == trunc((self.sombra.transform.a + 0.04)*10)/10 &&
                trunc((self.personagem.transform.b + 0.04)*10)/10  == trunc((self.sombra.transform.b + 0.04)*10)/10 &&
                trunc((self.personagem.transform.c + 0.04)*10)/10  == trunc((self.sombra.transform.c + 0.04)*10)/10 &&
                trunc((self.personagem.transform.d + 0.04)*10)/10  == trunc((self.sombra.transform.d + 0.04)*10)/10 &&
                trunc((self.personagem.transform.tx + 0.04)*10)/10 == trunc((self.sombra.transform.tx + 0.04)*10)/10 &&
                trunc((self.personagem.transform.ty + 0.04)*10)/10 == trunc((self.sombra.transform.ty + 0.04)*10)/10 )  {
                
                    self.pont ++;
                    [self.pontLabel setText: [NSString stringWithFormat:@"%d", self.pont]];
                    self.resetou = NO;
                    [self disableControll];
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                    [encaixou play];
            }
        }
    }
}

- (void) reset {
    
    NSInteger countX = [self.matrizSombraX count];
    NSInteger countY = [self.matrizSombraY count];
    self.vetoresCoordenadas.sorteioAng = arc4random()%17;
    if (self.vetoresCoordenadas.sorteioAng != 0 || self.vetoresCoordenadas.sorteioAng != 9)
    {
        self.sorteioX = arc4random()%(countX-1);
        self.sorteioY = arc4random()%(countY-1);
    }
    else
    {
        self.sorteioX = arc4random()%countX;
        self.sorteioY = arc4random()%countY;
    }
    
    NSNumber *auxX, *auxY, *auxAng;
    auxX = [self.matrizSombraX objectAtIndex:self.sorteioX];
    auxY = [self.matrizSombraY objectAtIndex:self.sorteioY];
    auxAng = [self.vetoresCoordenadas.angle objectAtIndex:self.vetoresCoordenadas.sorteioAng];
    
    self.sombra.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
    self.sombra.center = CGPointMake([auxX integerValue],[auxY integerValue]);
    self.sombra.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
    self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
    
    self.anglo = 0;
    self.personagem.transform = CGAffineTransformMakeRotation(self.anglo);
    [self.personagem setCenter:CGPointMake(self.startPoint.x, self.startPoint.y)];
    self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
    self.vetoresCoordenadas.resetou = NO;
    
    NSNumber *origemX = [NSNumber numberWithFloat: self.personagem.center.x];
    NSNumber *origemY = [NSNumber numberWithFloat: self.personagem.center.y];
    
    self.i = [self.matrizX indexOfObject: origemX];
    self.j = [self.matrizY indexOfObject: origemY];
    
    [self resetImagem];
    [self enableControll];

}

- (void) enableControll {
    
    [btnCima setEnabled:YES];
    [btnBaixo setEnabled:YES];
    [btnEsq setEnabled:YES];
    [btnDir setEnabled:YES];
    [btnAngloEsq setEnabled:YES];
    [btnAngloDir setEnabled:YES];
}

- (void) disableControll {
    
    [btnCima setEnabled:NO];
    [btnBaixo setEnabled:NO];
    [btnEsq setEnabled:NO];
    [btnDir setEnabled:NO];
    [btnAngloEsq setEnabled:NO];
    [btnAngloDir setEnabled:NO];
}

- (void) resetImagem {
    
    NSInteger sorteioPersonagem = arc4random()%3;
    while (self.sorteado == sorteioPersonagem){
        sorteioPersonagem = arc4random()%3;
    }
    self.sombra.image = [self.sombras objectAtIndex:sorteioPersonagem];
    self.personagem.image = [self.imagens objectAtIndex:sorteioPersonagem];
    self.sorteado = sorteioPersonagem;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)encaixe successfully:(BOOL)flag{
    
    [self reset];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
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
