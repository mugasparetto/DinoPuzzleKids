//
//  contadorBaixo.m
//  TesteImagemBotoes
//
//  Created by Anderson José da Silva on 25/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "contadorBaixo.h"

@implementation contadorBaixo

+ (instancetype) instance {
    
    static contadorBaixo *auxiliar = nil;
    if (!auxiliar) {
        auxiliar = [[self alloc]initPrivite];
    }
    return auxiliar;
}

- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use  + [contadorBaixo]"
                                 userInfo:nil ];
    
}

- (instancetype)initPrivite {
    
    self = [super init];
    if (self) {
        self.valorBaixo = 0;
    }
    
    return self;
}

- (void) maisUm{
    
    self.valorBaixo ++;
    
}

@end
