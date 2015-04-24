//
//  contadorAngle.h
//  TesteImagemBotoes
//
//  Created by Anderson José da Silva on 25/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface contadorAngle : NSObject


+ (instancetype) instance;
- (void) maisVinte;
- (void) menosVinte;

@property (nonatomic) int valorAngle;
@property (nonatomic) int valorAngleAtual;
@property (nonatomic) int quantidadeVoltas;

@end
