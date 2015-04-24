//
//  Coordenadas.h
//  Contando
//
//  Created by Murilo Gasparetto on 26/03/15.
//  Copyright (c) 2015 Murilo Gasparetto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coordenadas : NSObject

+ (instancetype) instance;

@property (nonatomic) NSMutableArray *posX;
@property (nonatomic) NSMutableArray *posY;
@property (nonatomic) NSMutableArray *angle;

@property (nonatomic) BOOL resetou;

@property (nonatomic) int sorteioX;
@property (nonatomic) int sorteioY;
@property (nonatomic) int sorteioAng;

@end
