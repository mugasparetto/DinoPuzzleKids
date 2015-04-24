//
//  contadorEsquerda.m
//  TesteImagemBotoes
//
//  Created by Anderson José da Silva on 25/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "contadorEsquerda.h"

@implementation contadorEsquerda

+ (instancetype) instance {
    
    static contadorEsquerda *auxiliar = nil;
    if (!auxiliar) {
        auxiliar = [[self alloc]initPrivite];
    }
    return auxiliar;
}


- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use  + [contadorEsquerda]"
                                 userInfo:nil ];
    
}


- (instancetype)initPrivite {
    
    self = [super init];
    if (self) {
        self.valorEsquerda = 0;
    }
    
    return self;
}

- (void) maisUm{
    
    self.valorEsquerda ++;
    
}

@end
