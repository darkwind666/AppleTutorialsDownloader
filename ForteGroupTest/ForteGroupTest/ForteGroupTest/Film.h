//
//  Film.h
//  ForteGroupTest
//
//  Created by Sasha Khotiashov on 4/15/16.
//  Copyright © 2016 Sasha Khotiashov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Film;

@protocol FilmDataDelegateProtocol

-(void)changeDownloadPercentInFilm: (Film*) aFilm;
-(void)downloadFinished: (Film*) aFilm;
-(void)filmSizeWasLoadedForFilm: (Film*) aFilm;
-(void)filmDownloadDiscriptionChangedForFilm: (Film*) aFilm;

@end

@interface Film : NSObject

@property id <FilmDataDelegateProtocol> delegate;

-(id)initWithData: (NSDictionary*) aData;

-(NSString*)getFilmName;
-(float)getDownloadProgress;
-(NSString*)getDownloadDescription;
-(NSURLSessionTaskState)getDownloadState;
-(BOOL)downloadStart;

- (void)downloadFilm;
- (void)pauseDownload;
- (void)resumeDownload;
- (void)removeDownload;

@end
