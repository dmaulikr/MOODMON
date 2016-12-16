//
//  MDEndPageViewController.m
//  moodMon
//
//  Created by 이재성 on 04/12/2016.
//  Copyright © 2016 HUB. All rights reserved.
//

#import "MDEndPageViewController.h"
#define CURRENT_WINDOW_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface MDEndPageViewController ()

@end
@implementation MDEndPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDate];
    [self makeMoodFace];
    [self setMoodFace];
    [self setTextToLabel];
    [self setLabelImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setTextToLabel{
    CGSize maximumSize = CGSizeMake(200, 60);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14]};
    CGRect rect = [_comment boundingRectWithSize:maximumSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    _commentTextView.translatesAutoresizingMaskIntoConstraints = YES;
    CGFloat startYPoint = _moodView.frame.origin.y + _moodView.frame.size.height + 20;
    _textRectFrame = CGRectMake((CURRENT_WINDOW_WIDTH-270)/2, startYPoint, 200, rect.size.height+10);
    [_commentTextView setFrame:_textRectFrame];
    _commentTextView.text = _comment;
    [_commentTextView setBackgroundColor:[UIColor clearColor]];
}

-(void)setLabelImage{
    [_backImage setFrame:_textRectFrame];
    UIImage *Image = [UIImage imageNamed:@"icon.png"];
    [_backImage setImage:[Image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
}

-(void)setMoodFace{
    CGAffineTransform transform = CGAffineTransformMakeScale(0.66, 0.66);
    _bigView.transform = transform;
    _bigView.frame = CGRectMake(0, 0, 200, 200);
    [_moodView addSubview:_bigView];
}

-(void)makeMoodFace{
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    
    _bigView.layer.cornerRadius = _bigView.frame.size.width/2;
    _bigView.layer.masksToBounds = YES;
    MDMoodColorView *colorView = [[MDMoodColorView alloc] initWithFrame:_bigView.frame];
    MDSaveMoodFaceView *faceView = [[MDSaveMoodFaceView alloc] initWithFrame:_bigView.frame];
    [_bigView addSubview:colorView];
    [_bigView addSubview:faceView];
    [_bigView setBackgroundColor:[UIColor clearColor]];
    [faceView setBackgroundColor:[UIColor clearColor]];
    [colorView setBackgroundColor:[UIColor clearColor]];
    
    [colorView awakeFromNib];
    colorView.chosenMoods = _moodColorView.chosenMoods;
    [colorView setNeedsDisplay];
    colorView.layer.cornerRadius = colorView.frame.size.width/2;
    colorView.layer.masksToBounds = YES;
    
    [faceView awakeFromNib];
    faceView.chosenMoods = _moodColorView.chosenMoods;
    [faceView setNeedsDisplay];
    faceView.layer.cornerRadius = faceView.frame.size.width/2;
    faceView.layer.masksToBounds = YES;
}

-(void)saveMoodMon{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), _bigView.opaque, 0.0);
    [_bigView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:@"snapshot.png" options:NSDataWritingWithoutOverwriting error:Nil];
    [data writeToFile:@"snapshot.png" atomically:YES];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
}

-(void)setDate{
    _dateLabelDetail.text = _dateString;
    _dateLabel.text =  _timest;
}

- (IBAction)closeButton:(id)sender {
    [self dissmissView];
}

-(void)dissmissView{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteBlur" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)showAlertView:(NSString*)title Message:(NSString*)Message{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:Message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)saveMoodButton:(id)sender {
    [self saveMoodMon];
    [self showAlertView:@"SAVE" Message:@"저장되었습니다."];
}

//***************
- (IBAction)commitModify:(id)sender {
    
    [self showAlertView:@"EDIT" Message:@"수정되었습니다."];
}

- (IBAction)deleteMood:(id)sender {
    [self showAlertView:@"DELETE" Message:@"삭제되었습니다."];
    [self dissmissView];
}
//*****************
//위두개는 렒으로 변경이후 추가.

@end