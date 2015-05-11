//
//  ImageViewController.h
//  TesteImagemBotoes
//
//  Created by Murilo Gasparetto on 20/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Settings.h"


@interface ImageViewController : UIViewController <AVAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnCima;
@property (weak, nonatomic) IBOutlet UIButton *btnBaixo;
@property (weak, nonatomic) IBOutlet UIButton *btnEsq;
@property (weak, nonatomic) IBOutlet UIButton *btnDir;
@property (weak, nonatomic) IBOutlet UIButton *btnAngloEsq;
@property (weak, nonatomic) IBOutlet UIButton *btnAngloDir;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnVoltar;


@property (weak, nonatomic) IBOutlet UIButton *btnReset;

@property (nonatomic) NSMutableArray *imagens;
@property (nonatomic) NSMutableArray *sombras;
@property (nonatomic) NSMutableArray *sombrasErradas;


@property (nonatomic)BOOL resetou;
@property (nonatomic)int origem;

@end
