//
//  contadorCima.m
//  TesteImagemBotoes
//
//  Created by Anderson José da Silva on 25/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "contadorCima.h"

@implementation contadorCima

+ (instancetype) instance {
    
    static contadorCima *auxiliar = nil;
    if (!auxiliar) {
        auxiliar = [[self alloc]initPrivite];
    }
    return auxiliar;
}

- (instancetype) init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use  + [contadorCima]"
                                 userInfo:nil ];
    
}

- (instancetype)initPrivite {
    
    self = [super init];
    if (self) {
        self.valorCima = 0;
    }
    
    return self;
}

- (void) maisUm{
    
    self.valorCima ++;
    
}

@end
