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
#import "Settings.h"
#import "AppDelegate.h"


@interface ImageViewController () <UIScrollViewDelegate>

{
    AVAudioPlayer *background;
    AVAudioPlayer *encaixou;
    int _startMusica;
}

@property (nonatomic) AppDelegate *delegate;

@property (weak, nonatomic) IBOutlet UIImageView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *pontLabel;
@property (nonatomic, weak) IBOutlet UIImageView *personagem;

@property (nonatomic) UIImageView *sombra;
@property (nonatomic) UIImageView *sombra2;
@property (nonatomic) UIImageView *sombra3;

@property (nonatomic) CGFloat anglo;
@property CGSize startSize;
@property CGPoint startPoint;

@property (weak, nonatomic) IBOutlet UIView *areaJogo;
@property (nonatomic) NSMutableArray *matrizX;
@property (nonatomic) NSMutableArray *matrizY;
@property (nonatomic) NSMutableArray *vetorAnglo;
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
@property (nonatomic) int sorteioAng;

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
    }

    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"%d", self.origem);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //index dino sorteado
    self.sorteado = 0;
    
    //pontuação
    self.pont = 0;
    
    //alocando app deledagte para usar backgroudsound
    self.delegate = ( AppDelegate* )[UIApplication sharedApplication].delegate;
    
    //alocando vetores de personagens e sombras
    self.sombras = [[NSMutableArray alloc] init];
    self.imagens = [[NSMutableArray alloc] init];
    self.sombrasErradas = [[NSMutableArray alloc] init];
    
    //label da pontuação
    [self.score setFont:[UIFont fontWithName:@"foo" size:30]];
    [self.pontLabel setFont:[UIFont fontWithName:@"foo" size:30]];
    [self.pontLabel setText: [NSString stringWithFormat:@"%d", self.pont]];
    
    //adicionando imagens
    [self.sombras addObject:[UIImage imageNamed:@"sombra_dino1.png"]];
    [self.sombras addObject:[UIImage imageNamed:@"sombra_dino2.png"]];
    [self.sombras addObject:[UIImage imageNamed:@"sombra_dino3.png"]];
    [self.imagens addObject:[UIImage imageNamed:@"dino1.png"]];
    [self.imagens addObject:[UIImage imageNamed:@"dino2.png"]];
    [self.imagens addObject:[UIImage imageNamed:@"dino3.png"]];
    [self.sombrasErradas addObject:[UIImage imageNamed:@"sombra_errada_dino1.png"]];
    [self.sombrasErradas addObject:[UIImage imageNamed:@"sombra_errada_dino2.png"]];
    [self.sombrasErradas addObject:[UIImage imageNamed:@"sombra_errada_dino3.png"]];

    
    //setando start size, para corrigir bug ao rotacionar
    self.startSize = self.personagem.frame.size;
    
    
    //adicionando sombra programaticamente
    self.sombra = [[UIImageView alloc] init];
    self.sombra2 = [[UIImageView alloc] init];
    self.sombra3 = [[UIImageView alloc] init];
    self.sombra.layer.anchorPoint = CGPointMake (0.5, 0.5);
    self.sombra2.layer.anchorPoint = CGPointMake (0.5, 0.5);
    self.sombra3.layer.anchorPoint = CGPointMake (0.5, 0.5);
    self.personagem.layer.anchorPoint = CGPointMake (0.5, 0.5);
    
    //método que chama nova sombra e novo personagem
    [self resetImagem];
    
    //fazendo personagem ficar acima da sombra
    switch (self.origem){
        case 0:
            [self.view insertSubview:self.sombra belowSubview:self.personagem];
            break;
        case 1:
            [self.view insertSubview:self.sombra belowSubview:self.personagem];
            [self.view insertSubview:self.sombra2 belowSubview:self.personagem];
            break;
            
        case 2:
            [self.view insertSubview:self.sombra belowSubview:self.personagem];
            [self.view insertSubview:self.sombra2 belowSubview:self.personagem];
            [self.view insertSubview:self.sombra3 belowSubview:self.personagem];
            break;
    }

    //configuracões de som
    NSString *path;
    NSURL *soundUrl;
    
    path = [NSString stringWithFormat:@"%@/background.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    background = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    background.numberOfLoops = -1;
    [background setVolume:0.1];
//    [background play];
    
    path = [NSString stringWithFormat:@"%@/encaixe.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    encaixou = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [encaixou setDelegate:self];
    encaixou.numberOfLoops = 0;
    
    if (![Settings getBoolForKey:@"settingsPlayBackgroundMusic"]) {
        [self.btnPlay setSelected:YES];
    }
    

    //property que impede entrar em didLayoutSubviews
    self.resetou = YES;
    
    //configurações de scrollview
    self.scroll.delegate = self;
    self.scroll.bounces = NO;
    self.scroll.bouncesZoom = NO;
    
}


- (void) initZoom {
    float minZoom =self.scroll.bounds.size.height / self.contentView.image.size.height;
    if (minZoom > 1) return;
    
    self.scroll.minimumZoomScale = minZoom;
    
    self.scroll.zoomScale = minZoom;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}


- (void)viewDidLayoutSubviews{

    NSNumber *auxX, *auxY, *auxAng;
    
//    self.sombra.backgroundColor = [UIColor redColor];
//    self.sombra2.backgroundColor = [UIColor greenColor];
//    self.sombra3.backgroundColor = [UIColor blueColor];
    
    NSLog(@"-------ORIGEM %d------", self.origem);
    
    if (self.resetou) {
        
    //definição da matriz de jogo
    self.matrizX = [[NSMutableArray alloc] init];
    self.matrizY = [[NSMutableArray alloc] init];
    self.vetorAnglo = [[NSMutableArray alloc] init];
    
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
        
    for (int z=0; z<=360; z+=20) {
        point = [NSNumber numberWithFloat:z*M_PI/180];
        [self.vetorAnglo addObject:point];
    }
        
        
    //definição matriz de sombra (menor para não bugar nas extremidades)
    self.matrizSombraX = [[NSMutableArray alloc] initWithArray:self.matrizX];
    self.matrizSombraY = [[NSMutableArray alloc] initWithArray:self.matrizY];
    
    [self.matrizSombraX removeObjectAtIndex:[self.matrizSombraX count] -1];
    [self.matrizSombraX removeObjectAtIndex:0];
    
    [self.matrizSombraY removeObjectAtIndex:[self.matrizSombraY count] -1];
    [self.matrizSombraY removeObjectAtIndex:0];
    
    
    NSInteger countX = [self.matrizSombraX count];
    NSInteger countY = [self.matrizSombraY count];
        
        switch (self.origem) {
                
            case 0:
                self.sorteioAng = arc4random()%17;
                if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
                auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
                self.sombra.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
                self.sombra.center = CGPointMake([auxX integerValue],[auxY integerValue]);
                self.sombra.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
                self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
                
                break;
                
            case 1:
                
                [self sorteioSombra2];
                
                break;
                
            case 2:
                
                [self sorteioSombra2];
                
                break;
                /*
                self.sorteioAng = arc4random()%17;
                if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
                auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
                self.sombra.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
                self.sombra.center = CGPointMake([auxX integerValue],[auxY integerValue]);
                self.sombra.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
                self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
                
                
                
                self.sorteioAng = arc4random()%17;
                if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
                auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
                self.sombra2.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
                self.sombra2.center = CGPointMake([auxX integerValue],[auxY integerValue]);
                self.sombra2.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
                self.sombra2.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
                
                
                
                self.sorteioAng = arc4random()%17;
                if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
                auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
                self.sombra3.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
                self.sombra3.center = CGPointMake([auxX integerValue],[auxY integerValue]);
                self.sombra3.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
                self.sombra3.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
                
                
                break;
                 */
                
        }
    
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
    
        //setando startPoint para reset
    self.startPoint = self.personagem.center;
        
        
    [self initZoom];
    
        
    }
    
    //manter personagem sempre na mesma posição
    auxX = [self.matrizX objectAtIndex:self.i];
    auxY = [self.matrizY objectAtIndex:self.j];
    self.personagem.center = CGPointMake([auxX integerValue], [auxY integerValue]);
    self.resetou = NO;

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
        
    }
    
    [self verificarEncaixe];
}

- (IBAction)rotacaoHorario:(id)sender{
    self.anglo = self.anglo + .34906585;
    self.personagem.transform = CGAffineTransformMakeRotation(self.anglo);
    
    [self verificarEncaixe];
}

- (IBAction)rotacaoAntiHorario:(id)sender{
    self.anglo = self.anglo - .34906585;
    self.personagem.transform = CGAffineTransformMakeRotation(self.anglo);
    
    [self verificarEncaixe];
}

- (IBAction)play:(id)sender{
    
    int aux = 1;
    
    if ([sender isSelected]) {
        [_delegate.background play];
        [Settings setBoolForKey:@"settingsPlayBackgroundMusic" value:YES];
//        [background play];
        aux = 1;
//        UIImage *unselectedImage = [UIImage imageNamed:@"volume_on.png"];
//        [sender setBackgroundImage:unselectedImage forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    
    else{
        [_delegate.background stop];
        [Settings setBoolForKey:@"settingsPlayBackgroundMusic" value:NO];
//        [background stop];
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

- (IBAction)btnVoltar:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
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
    NSNumber *auxX, *auxY, *auxAng;
    
    switch (self.origem) {
            
        case 0:
            self.sorteioAng = arc4random()%17;
            if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
            auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
            self.sombra.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
            self.sombra.center = CGPointMake([auxX integerValue],[auxY integerValue]);
            self.sombra.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
            self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
            
            break;
            
        case 1:
            
            [self sorteioSombra2];
            
            break;
            
        case 2:
            
            [self sorteioSombra2];
            
            break;

            /*
            self.sorteioAng = arc4random()%17;
            if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
            auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
            self.sombra.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
            self.sombra.center = CGPointMake([auxX integerValue],[auxY integerValue]);
            self.sombra.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
            self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
            
            
            
            self.sorteioAng = arc4random()%17;
            if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
            auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
            self.sombra2.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
            self.sombra2.center = CGPointMake([auxX integerValue],[auxY integerValue]);
            self.sombra2.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
            self.sombra2.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
            
            
            
            self.sorteioAng = arc4random()%17;
            if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
            auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
            self.sombra3.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
            self.sombra3.center = CGPointMake([auxX integerValue],[auxY integerValue]);
            self.sombra3.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
            self.sombra3.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
            */
            
    }
    
    self.anglo = 0;
    self.personagem.transform = CGAffineTransformMakeRotation(self.anglo);
    [self.personagem setCenter:CGPointMake(self.startPoint.x, self.startPoint.y)];
    
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
    int sombra2 = 0;
    
    while (self.sorteado == sorteioPersonagem)
    {
        sorteioPersonagem = arc4random()%3;
    }
    
    switch (sorteioPersonagem) {
        case 0:
            sombra2 = 1;
            break;
            
        case 1:
            sombra2 = 2;
            break;
            
        case 2:
            sombra2 = 0;
            break;
    }
    
    switch (self.origem){
        case 0:
            self.sombra.image = [self.sombras objectAtIndex:sorteioPersonagem];
            break;
        case 1:
            self.sombra.image = [self.sombras objectAtIndex:sorteioPersonagem];
            self.sombra2.image = [self.sombras objectAtIndex: sombra2];
            break;
        case 2:
            self.sombra.image = [self.sombras objectAtIndex:sorteioPersonagem];
            self.sombra2.image = [self.sombrasErradas objectAtIndex:sorteioPersonagem];
//            self.sombra3.image = [self.sombras objectAtIndex: sombra2];
//            self.sombra3.image = [self.sombras objectAtIndex:sorteioPersonagem];
            break;
    }
    self.personagem.image = [self.imagens objectAtIndex:sorteioPersonagem];
    self.sorteado = sorteioPersonagem;
    
}


- (void) sorteioSombra2 {
    
    NSInteger countX = [self.matrizSombraX count];
    NSInteger countY = [self.matrizSombraY count];
    NSNumber *auxX, *auxY, *auxAng;
    
    
    self.sorteioAng = arc4random()%17;
    if (self.sorteioAng != 0 || self.sorteioAng != 9)
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
    auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
    self.sombra.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
    self.sombra.center = CGPointMake([auxX integerValue],[auxY integerValue]);
    self.sombra.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
    self.sombra.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
    
    
    NSInteger sorteioSombra2X, sorteioSombra2Y;
    int range = [self range];
    
    if (self.sorteioX >= 0 && self.sorteioX< countX/2) {
        
        if (self.sorteioY >= 0 && self.sorteioY < countY/2) {
            NSLog(@"Segundo Quadrante");
            sorteioSombra2X = countX -1 - arc4random_uniform(range);//ta dando problema
            sorteioSombra2Y = countY -1 - arc4random_uniform(range);
            NSLog(@"X: %ld", (long)sorteioSombra2X);
            NSLog(@"Y: %ld", (long)sorteioSombra2Y);
            NSLog(@"%d", range);
            
        }
        else {
            NSLog(@"Terceiro Quadrante");
            sorteioSombra2X = countX -1 - arc4random_uniform(range);
            sorteioSombra2Y = arc4random_uniform(range);
            NSLog(@"X: %ld", (long)sorteioSombra2X);
            NSLog(@"Y: %ld", (long)sorteioSombra2Y);
            NSLog(@"%d", range);
        }
        
    }
    
    else {
        
        if (self.sorteioY >= 0 && self.sorteioY < countY/2) {
            NSLog(@"Primeiro Quadrante");
            sorteioSombra2X = arc4random_uniform(range);
            sorteioSombra2Y = countY -1 - arc4random_uniform(range);
            NSLog(@"X: %ld", (long)sorteioSombra2X);
            NSLog(@"Y: %ld", (long)sorteioSombra2Y);
            NSLog(@"%d", range);
        }
        
        else {
            
            NSLog(@"Quarto Quadrante");
            sorteioSombra2X = arc4random_uniform(range);
            sorteioSombra2Y = arc4random_uniform(range);
            NSLog(@"X: %ld", (long)sorteioSombra2X);
            NSLog(@"Y: %ld", (long)sorteioSombra2Y);
            NSLog(@"%d", range);
        }
    }
    
    
    self.sorteioAng = arc4random()%17;
    auxX = [self.matrizSombraX objectAtIndex:sorteioSombra2X];
    auxY = [self.matrizSombraY objectAtIndex:sorteioSombra2Y];
    auxAng = [self.vetorAnglo objectAtIndex:self.sorteioAng];
    self.sombra2.frame = CGRectMake ([auxX integerValue],[auxY integerValue],100,127);
    self.sombra2.center = CGPointMake([auxX integerValue],[auxY integerValue]);
    
    self.sombra2.transform = CGAffineTransformMakeRotation([auxAng floatValue]);
    self.sombra2.bounds = CGRectMake(0, 0, self.startSize.width, self.startSize.height);
    
    
}

- (int) range {
    int altura = (int)self.altura;
    switch (altura) {
        case 262: return 1; break;
        case 350: return 2; break;
        case 449: return 3; break;
        case 518: return 5; break;
    }
    return 0;
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
