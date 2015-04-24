//
//  Coordenadas.m
//  Contando
//
//  Created by Murilo Gasparetto on 26/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import "Coordenadas.h"

@implementation Coordenadas

+ (instancetype) instance {
    
    static Coordenadas *auxiliar = nil;
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
        
        self.posX = [NSMutableArray array];
        self.posY = [NSMutableArray array];
        self.angle = [NSMutableArray array];
        
        NSNumber *point;
        
        for (int i=50; i<=150; i+=20){
            point = [NSNumber numberWithInt:i];
            [self.posX addObject:point];
        }
        
        for (int j=50; j<=210; j+=20) {
            point = [NSNumber numberWithInt:j];
            [self.posY addObject:point];
        }
        
        for (int z=0; z<=360; z+=20) {
            point = [NSNumber numberWithFloat:z*M_PI/180];
            [self.angle addObject:point];
        }
        
        self.resetou = NO;

    }
    
    return self;
}


@end
