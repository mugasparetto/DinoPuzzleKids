//
//  contadorDireita.m
//  TesteImagemBotoes
//
//  Created by Anderson José da Silva on 25/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "contadorDireita.h"

@implementation contadorDireita

+ (instancetype) instance {
    
    static contadorDireita *auxiliar = nil;
    if (!auxiliar) {
        auxiliar = [[self alloc]initPrivite];
    }
    return auxiliar;
}

- (instancetype) init {
     @throw [NSException exceptionWithName:@"Singleton"
                                    reason:@"Use  + [contadorDireita]"
                                  userInfo:nil ];
    
}


- (instancetype)initPrivite {
    
    self = [super init];
    if (self) {
        self.valorDireita = 0;
    }
    
    return self;
}

- (void) maisUm{
    
    self.valorDireita ++;
    
}

@end
