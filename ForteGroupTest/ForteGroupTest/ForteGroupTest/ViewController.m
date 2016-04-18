//
//  ViewController.m
//  ForteGroupTest
//
//  Created by Sasha Khotiashov on 4/14/16.
//  Copyright © 2016 Sasha Khotiashov. All rights reserved.
//

#import "ViewController.h"
#import "FilmsData.h"
#import "Film.h"
#import "ViewController+ButtonStateHelper.h"
#import "ForteGroupEnums.h"

@interface ViewController () <FilmsDataDelegateProtocol, FilmDataDelegateProtocol>

@end

@implementation ViewController {
    
    FilmsData *_filmsData;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _filmsData = [[FilmsData alloc]init];
    _filmsData.delegate = self;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_filmsData getFilmsCount];
    
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ForteGroupTestCell"forIndexPath:indexPath];
     
     Film *filmData = [_filmsData getFilmDataForIndex:(int)indexPath.row];
     filmData.delegate = self;
     [self setCellIndicators: cell withFilmData: filmData];
     [self setRightButtonsInCell:cell withFilmData: filmData];
     
     return cell;
 }

-(void)setCellIndicators: (UITableViewCell*) aCell withFilmData: (Film*) aFilmData {
    
    UILabel *filmName = (UILabel *)[aCell viewWithTag: FilmNameTag];
    filmName.text = [aFilmData getFilmName];
    
    UILabel *downloadDiscription = (UILabel *)[aCell viewWithTag: FilmDownloadStatusTag];
    downloadDiscription.text = [aFilmData getDownloadDescription];
    
    UIProgressView *progress = [aCell viewWithTag:FilmProgresTag];
    progress.progress = [aFilmData getDownloadProgress];
    
}

#pragma mark - Films data delegate

-(void)filmsWasLoaded {
    
    [self.tableView reloadData];
    
}

#pragma mark - Film delegate

-(void)changeDownloadPercentInFilm: (Film*) aFilm {
    
    int filmIndex = [_filmsData getFilmIndex:aFilm];
    NSIndexPath *path = [NSIndexPath indexPathForRow:filmIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    UIProgressView *progress = [cell viewWithTag:FilmProgresTag];
    progress.progress = [aFilm getDownloadProgress];
    
}

-(void)downloadFinished: (Film*) aFilm {
    
    int filmIndex = [_filmsData getFilmIndex:aFilm];
    [self startDownloadNextFilmAfterIndex: filmIndex];
    NSIndexPath *path = [NSIndexPath indexPathForRow:filmIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [self setRightButtonsInCell:cell withFilmData: aFilm];
    
}

-(void)startDownloadNextFilmAfterIndex: (int) aFilmIndex {
    
    int nextUndownloadedFilmIndex = [_filmsData getNextUndownloadedFilmIndexFromIndex:aFilmIndex];
    if (nextUndownloadedFilmIndex >= 0) {
        
        Film *filmData = [_filmsData getFilmDataForIndex:nextUndownloadedFilmIndex];
        [filmData downloadFilm];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:nextUndownloadedFilmIndex inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        [self setRightButtonsInCell:cell withFilmData: filmData];
        
    }
    
}

-(void)filmSizeWasLoadedForFilm:(Film *)aFilm {
    
    int filmIndex = [_filmsData getFilmIndex:aFilm];
    NSIndexPath *path = [NSIndexPath indexPathForRow:filmIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    UILabel *filmName = [cell viewWithTag:FilmNameTag];
    filmName.text = [aFilm getFilmName];
    
}

-(void)filmDownloadDiscriptionChangedForFilm: (Film*) aFilm {
    
    int filmIndex = [_filmsData getFilmIndex:aFilm];
    NSIndexPath *path = [NSIndexPath indexPathForRow:filmIndex inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    UILabel *downloadDiscription = [cell viewWithTag:FilmDownloadStatusTag];
    downloadDiscription.text = [aFilm getDownloadDescription];
    
}

#pragma mark - Actions

- (IBAction)downloadFilm:(UIButton *)sender {
    
    int cellIndex = [self getCellIndexFromButton: sender];
    Film *filmData = [_filmsData getFilmDataForIndex:cellIndex];
    [filmData downloadFilm];
    [self setButtonsInButtonCell: sender withFilmData: filmData];
    
}

- (IBAction)pauseDownload:(UIButton *)sender {
    
    int cellIndex = [self getCellIndexFromButton: sender];
    Film *filmData = [_filmsData getFilmDataForIndex:cellIndex];
    [filmData pauseDownload];
    [self setButtonsInButtonCell: sender withFilmData: filmData];
    
}

- (IBAction)resumeDownload:(UIButton *)sender {
    
    int cellIndex = [self getCellIndexFromButton: sender];
    Film *filmData = [_filmsData getFilmDataForIndex:cellIndex];
    [filmData resumeDownload];
    [self setButtonsInButtonCell: sender withFilmData: filmData];
    
}

- (IBAction)removeDownload:(UIButton *)sender {
    
    int cellIndex = [self getCellIndexFromButton: sender];
    Film *filmData = [_filmsData getFilmDataForIndex:cellIndex];
    [filmData removeDownload];
    [self setButtonsInButtonCell: sender withFilmData: filmData];
    
}
- (IBAction)startTenDownloads:(id)sender {
    
    for (int downloadIndex = 0; downloadIndex < 10; downloadIndex++) {
        
        [self startDownloadNextFilmAfterIndex: 0];
        
    }
    
}

@end
