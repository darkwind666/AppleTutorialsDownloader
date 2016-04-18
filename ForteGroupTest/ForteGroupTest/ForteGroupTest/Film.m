//
//  Film.m
//  ForteGroupTest
//
//  Created by Sasha Khotiashov on 4/15/16.
//  Copyright © 2016 Sasha Khotiashov. All rights reserved.
//

#import "Film.h"

@interface Film() <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@end

static NSString * const FILM_TITLE = @"title";
static NSString * const FILM_MP4 = @"download_sd";

@implementation Film {
    
    NSString *_filmName;
    float _downloadProgress;
    NSString *_filmUrl;
    NSString *_downloadDiscription;
    
    BOOL _downloadStart;
    NSURLSessionDownloadTask *_downloadTask;
    NSString *_filmSize;
    
}

-(id)initWithData: (NSDictionary*) aData {
    
    if (self = [super init]) {
        
        NSString *title = aData[FILM_TITLE];
        _filmName =  [title substringToIndex:MIN(18, title.length)];
        _filmUrl = aData[FILM_MP4];
        _downloadProgress = 0;
        _downloadStart = NO;
        _downloadDiscription = @"";
        self.delegate = nil;
        
        [self loadFilmSize];
    }
    
    return self;
    
}

-(void)loadFilmSize {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_filmUrl]];
    [request setHTTPMethod:@"HEAD"];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *sizeTask = [session dataTaskWithRequest:request
                                                completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                                    [self setFilmSizeAndNameWithResponse: response];
                                                    
                                                                     }];
    
    [sizeTask resume];
    
}

-(void)setFilmSizeAndNameWithResponse: (NSURLResponse*) aResponse {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;
    float totalBytesExpectedToReceive = (double)[httpResponse expectedContentLength];
    
    _filmSize = [NSByteCountFormatter stringFromByteCount:totalBytesExpectedToReceive countStyle:NSByteCountFormatterCountStyleFile];
    
    _filmName = [NSString stringWithFormat:@"%@ (%@)", _filmName , _filmSize];
    
    [self notifyDelegateAboutSize];
    
}

-(void)notifyDelegateAboutSize {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.delegate) {
            [self.delegate filmSizeWasLoadedForFilm: self];
        }
        
    });
    
}

-(NSString*)getFilmName {
    
    return _filmName;
    
}

-(NSString*)getDownloadDescription {
    
    return _downloadDiscription;
    
}

-(float)getDownloadProgress {
    
    return _downloadProgress;
    
}

-(BOOL)downloadStart {
    
    return _downloadStart;
    
}

-(NSURLSessionTaskState)getDownloadState {
    
    if (_downloadTask) {
        
        return _downloadTask.state;
        
    }
    else {
        
        return NSURLSessionTaskStateSuspended;
        
    }
    
}

- (void)downloadFilm {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    _downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:_filmUrl]];
    [_downloadTask resume];
    
    _downloadStart = YES;
    _downloadDiscription = [NSString stringWithFormat:@"Downloading 0 KB of %@ (0%%)", _filmSize];
    [self.delegate filmDownloadDiscriptionChangedForFilm: self];
    
}

- (void)pauseDownload {
    
    [_downloadTask suspend];
    _downloadDiscription = [_downloadDiscription stringByReplacingOccurrencesOfString:@"Downloading" withString:@"Paused"];
    [self.delegate filmDownloadDiscriptionChangedForFilm: self];
    
}

- (void)resumeDownload {
    
    [_downloadTask resume];
    
}

- (void)removeDownload {
    
    [_downloadTask cancel];
    _downloadStart = NO;
    _downloadProgress = 0;
    _downloadDiscription = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.delegate changeDownloadPercentInFilm:self];
        [self.delegate filmDownloadDiscriptionChangedForFilm: self];
        
    });
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    
    _downloadDiscription = [_downloadDiscription stringByReplacingOccurrencesOfString:@"Downloading" withString:@"Complited"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.delegate downloadFinished:self];
        [self.delegate filmDownloadDiscriptionChangedForFilm: self];
        
    });
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    _downloadProgress = progress;
    [self changeDownloadDiscriptionWithDownloadedBytes: totalBytesWritten];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.delegate changeDownloadPercentInFilm:self];
        [self.delegate filmDownloadDiscriptionChangedForFilm: self];
        
    });
    
}

-(void)changeDownloadDiscriptionWithDownloadedBytes: (int64_t)totalBytesWritten {
    
    int progressPercent = _downloadProgress * 100;
    NSString *downloadedBytesSize = [NSByteCountFormatter stringFromByteCount:totalBytesWritten countStyle:NSByteCountFormatterCountStyleFile];
    _downloadDiscription = [NSString stringWithFormat:@"Downloading %@ of %@ (%i%%)",downloadedBytesSize , _filmSize, progressPercent];
    
}


@end
