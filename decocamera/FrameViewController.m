//
//  FrameViewController.m
//  decocamera
//
//  Created by chikatokitamuro on 2016/01/23.
//  Copyright © 2016年 chikatokitamuro. All rights reserved.
//

#import "FrameViewController.h"
#import "ImageViewController.h"


@interface FrameViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *frameCollectionView;

@property (strong, nonatomic) NSArray *frameArray;
@property (strong, nonatomic) UIImage *editImage;

@end

@implementation FrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.frameArray = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15, @16];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.frameArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    // CollectionView上のUIImageViewをタグを用いて取得します。
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    NSString *imgName = [NSString stringWithFormat:@"frame_%02ld.png", (long)[self.frameArray[indexPath.row] integerValue]];
    UIImage *image = [UIImage imageNamed:imgName];
    imageView.image = image;
    
    return cell;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 浮世絵フレームと写真は別になっているので合成しなければいけません。
    // キャプチャ対象をWindowにします。
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // これからキャプチャするための作業場所を生成します。
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // １つ１つのWindowの現在の表示内容を作業場所に描画して行きます。
    for (UIWindow *aWindow in [UIApplication sharedApplication].windows) {
        [aWindow.layer renderInContext:context];
    }
    
    // 描画した内容をUIImageとして受け取ります。
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画終了
    UIGraphicsEndImageContext();
    
    // Window全体だと不要な部分があるので、浮世絵フレームを含めた写真の部分だけを切り抜きます
    CGRect rect = picker.view.bounds;
    rect.size.height -= picker.navigationBar.bounds.size.height;
    CGFloat barHeight = (rect.size.height - rect.size.width) / 2;
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.width));
    
    // 画像を描画します。
    [capturedImage drawAtPoint:CGPointMake(0, -barHeight)];
    capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 描画終了
    UIGraphicsEndImageContext();
    
    self.editImage = capturedImage;
    [self performSegueWithIdentifier:@"ImageView" sender:self];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Segueの特定
    if ( [[segue identifier] isEqualToString:@"ImageView"] ) {
        
        ImageViewController *nextViewController = [segue destinationViewController];
        nextViewController.editImage = self.editImage;
    }
}

@end
