//
//  ImageViewController.m
//  Imaginarium
//
//  Created by Glauber Lima on 17/02/17.
//  Copyright © 2017 CI&T. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    _scrollView.minimumZoomScale = 0.2;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    //self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.imageURL]]; roda na thread da UI, o que é péssimo
    
    [self startDownloadingImage];
    
}

- (void)startDownloadingImage {
    
    
    self.image = nil;
    
    if(self.imageURL) {
        
        [self.spinner startAnimating];

        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                        completionHandler:^(NSURL * _Nullable localFile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                            if (!error) {
                                                                if([request.URL isEqual:self.imageURL]) {
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localFile]];
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        self.image = image;
                                                                    });
                                                                    
                                                                }
                                                            }
                                                        }];
        [task resume];
    }
    
}

// imageView get
- (UIImageView *) imageView {
    if(!_imageView) _imageView = [[UIImageView alloc] init];
    return _imageView;
}

// image  get
- (UIImage *) image {
    return self.imageView.image;
}

// image set
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self.imageView sizeToFit];
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    
}



@end
