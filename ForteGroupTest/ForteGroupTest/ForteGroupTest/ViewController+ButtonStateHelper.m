//
//  ViewController+ButtonStateHelper.m
//  ForteGroupTest
//
//  Created by Sasha Khotiashov on 4/16/16.
//  Copyright © 2016 Sasha Khotiashov. All rights reserved.
//

#import "ViewController+ButtonStateHelper.h"
#import "Film.h"
#import "ForteGroupEnums.h"

@implementation ViewController (ButtonStateHelper)

-(void)setButtonsInButtonCell: (UIButton *)sender withFilmData: (Film*) aFilmData {
    
    UIView *parentView = sender.superview;
    UITableViewCell *parentCell = (UITableViewCell*)parentView.superview;
    [self setRightButtonsInCell:parentCell withFilmData: aFilmData];
    
}

-(int)getCellIndexFromButton: (UIButton *)aButton {
    
    UIView *parentView = aButton.superview;
    UITableViewCell *parentCell = (UITableViewCell*)parentView.superview;
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell: parentCell];
    int cellIndex = (int)cellIndexPath.row;
    return cellIndex;
    
}

-(void)setRightButtonsInCell: (UITableViewCell*)cell withFilmData: (Film*)aFilmData {
    
    UIButton *downloadButton = [cell viewWithTag:FilmDownloadButtonTag];
    UIButton *pauseButton = [cell viewWithTag:FilmPauseButtonTag];
    UIButton *resumeButton = [cell viewWithTag:FilmResumeButtonTag];
    UIButton *removeButton = [cell viewWithTag:FilmRemoveButtonTag];
    
    if ([aFilmData downloadStart]) {
        
        NSURLSessionTaskState downloadState = [aFilmData getDownloadState];
        
        switch (downloadState) {
            case NSURLSessionTaskStateRunning:
                
                downloadButton.hidden = YES;
                pauseButton.hidden = NO;
                resumeButton.hidden = YES;
                removeButton.hidden = NO;
                
                break;
                
            case NSURLSessionTaskStateSuspended:
                
                downloadButton.hidden = YES;
                pauseButton.hidden = YES;
                resumeButton.hidden = NO;
                removeButton.hidden = NO;
                
                break;
                
            case NSURLSessionTaskStateCanceling:
                
                downloadButton.hidden = NO;
                pauseButton.hidden = YES;
                resumeButton.hidden = YES;
                removeButton.hidden = YES;
                
                break;
                
            case NSURLSessionTaskStateCompleted:
                
                downloadButton.hidden = YES;
                pauseButton.hidden = YES;
                resumeButton.hidden = YES;
                removeButton.hidden = NO;
                
                break;
                
            default:
                break;
        }
        
    }
    else {
        
        downloadButton.hidden = NO;
        pauseButton.hidden = YES;
        resumeButton.hidden = YES;
        removeButton.hidden = YES;
        
    }
    
}


@end
