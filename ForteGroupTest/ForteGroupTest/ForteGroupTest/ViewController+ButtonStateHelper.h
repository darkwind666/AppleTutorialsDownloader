//
//  ViewController+ButtonStateHelper.h
//  ForteGroupTest
//
//  Created by Sasha Khotiashov on 4/16/16.
//  Copyright © 2016 Sasha Khotiashov. All rights reserved.
//

#import "ViewController.h"

@class Film;

@interface ViewController (ButtonStateHelper)

-(void)setButtonsInButtonCell: (UIButton *)sender withFilmData: (Film*) aFilmData;
-(int)getCellIndexFromButton: (UIButton *)aButton;
-(void)setRightButtonsInCell: (UITableViewCell*)cell withFilmData: (Film*)aFilmData;

@end
