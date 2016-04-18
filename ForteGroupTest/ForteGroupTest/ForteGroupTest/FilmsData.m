//
//  FilmsData.m
//  ForteGroupTest
//
//  Created by Sasha Khotiashov on 4/14/16.
//  Copyright © 2016 Sasha Khotiashov. All rights reserved.
//

#import "FilmsData.h"
#import "Film.h"

static NSString * const FILMS_URL = @"https://devimages.apple.com.edgekey.net/wwdc-services/ftzj8e4h/6rsxhod7fvdtnjnmgsun/videos.json";

static NSString * const FILMS_SESSIONS = @"sessions";
static NSString * const FILM_MP4 = @"download_sd";

@implementation FilmsData {
    
    NSMutableArray *_films;
    
}

-(id)init {
    
    if (self = [super init]) {
        
        _films = [NSMutableArray array];
        [self loadFilmsData];
        
    }
    
    return self;
}

- (void)loadFilmsData {
    
    NSURL *myUrl = [NSURL URLWithString:FILMS_URL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [self startDownloadTaskWithSession: session andUrl: myUrl];
    
}

-(void)startDownloadTaskWithSession: (NSURLSession*) aSession andUrl: (NSURL*) aUrl {
    
    NSURLSessionDataTask *task = [aSession dataTaskWithURL:aUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        _films = [self getFilmsFromData: data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.delegate filmsWasLoaded];
            
        });
        
    }];
    
    [task resume];
    
}

-(NSMutableArray*)getFilmsFromData: (NSData*) aData {
    
    NSMutableArray *films = [NSMutableArray array];
    
    NSMutableDictionary *filmsDataCollection = [NSJSONSerialization JSONObjectWithData:aData options:kNilOptions error:nil];
    NSMutableArray *sessions = filmsDataCollection[FILMS_SESSIONS];
    films = [self getFilmsFromSessions: sessions];

    return films;
    
}

-(NSMutableArray*)getFilmsFromSessions: (NSArray*) aSessions {
    
    NSMutableArray *films = [NSMutableArray array];
    
    for (NSMutableDictionary *session in aSessions) {
        
        NSString *filmUrl = session[FILM_MP4];
        if (filmUrl != [NSNull null]) {
            
            Film *filmData = [[Film alloc]initWithData:session];
            [films addObject: filmData];
            
        }
        
    }
    
    return films;
    
}

-(int)getFilmsCount {
    
    return (int)[_films count];
    
}

-(Film*)getFilmDataForIndex:(int) aIndex {
    
    return _films[aIndex];
    
}

-(int)getFilmIndex: (Film*) afilm {
    
    return (int)[_films indexOfObject:afilm];
    
}

-(int)getNextUndownloadedFilmIndexFromIndex: (int) aIndex {
    
    int nextfilmIndex = -1;
    
    for (int index = aIndex; index < _films.count; index++) {
        
        Film *film = _films[index];
        
        if ([film downloadStart] == false) {
            nextfilmIndex = index;
            break;
        }
        
    }
    
    return nextfilmIndex;
    
}

@end
