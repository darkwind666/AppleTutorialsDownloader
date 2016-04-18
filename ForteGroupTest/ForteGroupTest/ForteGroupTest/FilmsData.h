//
//  FilmsData.h
//  ForteGroupTest
//
//  Created by Sasha Khotiashov on 4/14/16.
//  Copyright © 2016 Sasha Khotiashov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FilmsDataDelegateProtocol

-(void)filmsWasLoaded;

@end

@class Film;

@interface FilmsData : NSObject

@property id<FilmsDataDelegateProtocol> delegate;

-(int)getFilmsCount;
-(Film*)getFilmDataForIndex:(int) aIndex;
-(int)getFilmIndex: (Film*) afilm;
-(int)getNextUndownloadedFilmIndexFromIndex: (int) aIndex;

@end
