//
//  DownloadListController.m
//  ThreeMan
//
//  Created by tianj on 15/4/2.
//  Copyright (c) 2015年 ___普马克___. All rights reserved.
//

#import "DownloadListController.h"
#import "EditView.h"
#import "FavoriteItem.h"
#import "UnfinishedCell.h"
#import "FinishedCell.h"
#import "CommenHelper.h"
#import "RecommendController.h"
#import "QuestionController.h"
#import "CourseDetailController.h"
#import "SectionHeadView.h"
#import "MemorySizeView.h"
#import "DownloadManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ErrorView.h"
#import "CommenHelper.h"
#import "DirectionMPMoviePlayerViewController.h"

@interface DownloadListController ()<EditViewDelegate,CircularProgressViewDelegate,DownloadDelegate,UIDocumentInteractionControllerDelegate>
{
    BOOL isEditting;
    EditView *editView;
    MemorySizeView *memoryView;
    ErrorView *noDataView;
}


@end

@implementation DownloadListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    _headViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    _finishedArray = [[NSMutableArray alloc] initWithCapacity:0];
    _unFinishedArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    [self addView];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDownload) name:addNewDownload object:nil];
}

- (void)newDownload
{
    [self loadData];
}

- (void)addView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-40-40) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = HexRGB(0xe8e8e8);
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundView = nil;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];

    editView = [[EditView alloc] init];
    editView.delegate = self;
    editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
    [self.view addSubview:editView];
    
    memoryView = [[MemorySizeView alloc] init];
    memoryView.frame = CGRectMake(0,_tableView.frame.size.height,memoryView.frame.size.width,memoryView.frame.size.height);
    [self.view addSubview:memoryView];
    
    noDataView = [[ErrorView alloc] initWithImage:@"netFailImg_2" title:@"亲,您暂时还未下载任何文件哦!"];
    noDataView.center = CGPointMake(kWidth/2, (kHeight-64-40)/2);
    noDataView.hidden = YES;
    [self.view addSubview:noDataView];
    
    [DownloadManager setDelegate:self];
}


#pragma mark 添加下载数据
- (void)loadData
{
    [_finishedArray removeAllObjects];
    [_unFinishedArray removeAllObjects];
    [_dataArray removeAllObjects];
    [_headViewArray removeAllObjects];

    [_finishedArray addObjectsFromArray:[DownloadManager arrayOfFinished]];
    [_unFinishedArray addObjectsFromArray:[DownloadManager arrayOfUnfinished]];
    
    if (_finishedArray.count!=0) {
        [_dataArray addObject:_finishedArray];
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        [headView setImgView:[UIImage imageNamed:@"finish"] title:@"完成"];
        [_headViewArray addObject:headView];
    }
    
    if (_unFinishedArray.count!=0) {
        [_dataArray addObject:_unFinishedArray];
        SectionHeadView *headView = [[SectionHeadView alloc] initWithFrame:CGRectMake(0, 0,kWidth,36)];
        [headView setImgView:[UIImage imageNamed:@"unfinish"] title:@"未完成"];
        [_headViewArray addObject:headView];
    }

    [_tableView reloadData];
    
    if (_dataArray.count==0) {
        
        noDataView.hidden = NO;
        
    }else{
        
        noDataView.hidden = YES;
    }
}


- (void)edit:(BOOL)editting
{
    isEditting = editting;
    [_tableView setEditing:editting animated:YES];
    //编辑状态
    if (editting) {
        if (editView) {
            editView = nil;
        }
        editView = [[EditView alloc] init];
        editView.delegate = self;
        editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
        [self.view addSubview:editView];
        
        [UIView animateWithDuration:0.2 animations:^{
            editView.frame = CGRectMake(0,self.view.frame.size.height-editView.frame.size.height,editView.frame.size.width, editView.frame.size.height);
        }];
        //非编辑状态
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            editView.frame = CGRectMake(0,self.view.frame.size.height,editView.frame.size.width, editView.frame.size.height);
        }];
    }
}


#pragma mark tableView_datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify1 = @"identify1";
    static NSString *identify2 = @"identify2";
    if (_dataArray.count==2) {
        if (indexPath.section == 0) {
            FinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if (cell == nil) {
                cell = [[FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
            }
            UIView *view = [[UIView alloc] initWithFrame:cell.frame];
            view.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.multipleSelectionBackgroundView = [[UIView alloc] init];

            
            DownloadFileModel *fileInfo = [_finishedArray objectAtIndex:indexPath.row];
            NSDictionary *dic = fileInfo.fileInfo;
            NSString *imageurl = [dic objectForKey:@"imgurl"];
            NSString *title = [dic objectForKey:@"title"];
            cell.titleLabel.text = title;
            [cell.imgView setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:placeHoderImage];
            
            cell.recommendBtn.tag = 1000+indexPath.row;
            cell.questionBtn.tag = 2000+indexPath.row;
            cell.playBtn.tag = 3000+indexPath.row;
            [cell.recommendBtn addTarget:self action:@selector(recommend:) forControlEvents:UIControlEventTouchUpInside];
            [cell.questionBtn addTarget:self action:@selector(question:) forControlEvents:UIControlEventTouchUpInside];
            [cell.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }else{
            
            UnfinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
            if (cell == nil) {
                cell = [[UnfinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
            }
            
            UIView *view = [[UIView alloc] initWithFrame:cell.frame];
            view.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.multipleSelectionBackgroundView = [[UIView alloc] init];

            
            DownloadFileModel *fileInfo = [_unFinishedArray objectAtIndex:indexPath.row];
            NSDictionary *dic = fileInfo.fileInfo;
            NSString *imageurl = [dic objectForKey:@"imgurl"];
            NSString *title = [dic objectForKey:@"title"];
            cell.titleLabel.text = title;
            [cell.imgView setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:placeHoderImage];
            
            if (fileInfo.isDownloading) {
                cell.progressView.downloadState = loadingState;
                cell.progressLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonHelper transformToM:fileInfo.fileReceivedSize],[CommonHelper transformToM:fileInfo.totalSize]];
            }else{
                
                if (fileInfo.willDownloading) {
                    cell.progressView.downloadState = waitingState;
                    cell.progressLabel.text = @"等 待";
                    
                }else{
                    cell.progressView.downloadState = stopState;
                    cell.progressLabel.text = @"暂 停";
                }
            }
            cell.progressView.tag = 1000+indexPath.row;
            cell.progressView.delegate = self;
            
            if (fileInfo.fileReceivedSize) {
            }else{
            }
            
            return cell;
            
        }
    }else{
        if (_finishedArray.count==0) {
            //下载列表
            UnfinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
            if (cell == nil) {
                cell = [[UnfinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
            }
            UIView *view = [[UIView alloc] initWithFrame:cell.frame];
            view.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.multipleSelectionBackgroundView = [[UIView alloc] init];

            DownloadFileModel *fileInfo = [_unFinishedArray objectAtIndex:indexPath.row];
            NSDictionary *dic = fileInfo.fileInfo;
            NSString *imageurl = [dic objectForKey:@"imgurl"];
            NSString *title = [dic objectForKey:@"title"];
            cell.titleLabel.text = title;
            [cell.imgView setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:placeHoderImage];
            
            if (fileInfo.isDownloading) {
                cell.progressView.downloadState = loadingState;
                cell.progressLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonHelper transformToM:fileInfo.fileReceivedSize],[CommonHelper transformToM:fileInfo.totalSize]];
            }else{
                
                if (fileInfo.willDownloading) {
                    cell.progressView.downloadState = waitingState;
                    cell.progressLabel.text = @"等 待";
                    
                }else{
                    cell.progressView.downloadState = stopState;
                    cell.progressLabel.text = @"暂 停";
                }
            }
            cell.progressView.tag = 1000+indexPath.row;
            cell.progressView.delegate = self;
            
            return cell;
        }else{
            //已完成列表
            FinishedCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
            if (cell == nil) {
                cell = [[FinishedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
            }
            UIView *view = [[UIView alloc] initWithFrame:cell.frame];
            view.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.multipleSelectionBackgroundView = [[UIView alloc] init];

            
            DownloadFileModel *fileInfo = [_finishedArray objectAtIndex:indexPath.row];
            NSDictionary *dic = fileInfo.fileInfo;
            NSString *imageurl = [dic objectForKey:@"imgurl"];
            NSString *title = [dic objectForKey:@"title"];
            cell.titleLabel.text = title;
            
            [cell.imgView setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:placeHoderImage];
            
            cell.recommendBtn.tag = 1000+indexPath.row;
            cell.questionBtn.tag = 2000+indexPath.row;
            cell.playBtn.tag = 3000+indexPath.row;
            [cell.recommendBtn addTarget:self action:@selector(recommend:) forControlEvents:UIControlEventTouchUpInside];
            [cell.questionBtn addTarget:self action:@selector(question:) forControlEvents:UIControlEventTouchUpInside];
            [cell.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];

            return cell;
        }
    }
    return nil;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}


#pragma mark tableView_delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [_headViewArray objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEditting) {
        DownloadFileModel *file = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        CourseDetailController *detail = [[CourseDetailController alloc] init];
        detail.courseDetailID = [file.fileInfo objectForKey:@"id"];
        [self.nav pushViewController:detail animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 49;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000000000000001;
}

#pragma mark editView_delegate
- (void)btnClicked:(UIButton *)btn view:(EditView *)view
{
    if (btn.tag == 0) {
        btn.selected = !btn.selected;
        for (int i = 0; i < _dataArray.count; i++) {
            NSMutableArray *arr = [_dataArray objectAtIndex:i];
            for (int j =0; j <arr.count; j++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                if (btn.selected) {
                    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                }else{
                    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
                }
            }
        }
    }else{
        //获取选中的cell的 NSIndexPath
        NSArray *array = [_tableView indexPathsForSelectedRows];
        
        if (array.count==0) {
            return;
        }
        //存储选中的已完成的对象
        NSMutableArray *arr1 = [[NSMutableArray alloc] initWithCapacity:0];
        //存储选中的未完成的对象
        NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:0];
        //遍历array
        for (int i = 0 ; i < array.count; i++) {
            NSIndexPath *indexPath = [array objectAtIndex:i];
            FavoriteItem *item = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if ([_finishedArray containsObject:item]) {
                [arr1 addObject:item];
            }else if ([_unFinishedArray containsObject:item]){
                [arr2 addObject:item];
            }
        }
        
        if (arr1.count!=0) {
            //删除缓存下已下载的文件
            [DownloadManager deleteFinisedFiles:arr1];
        }
        if (arr2.count!=0) {
            //取消当前选中的下载任务
            [DownloadManager cancelDownloads:arr2];
        }
        [self loadData];
    }
}


#pragma mark 推荐按钮点击
- (void)recommend:(UIButton *)btn
{
    DownloadFileModel *file = [_finishedArray objectAtIndex:btn.tag - 1000];
    RecommendController *recommend = [[RecommendController alloc] init];
    recommend.sid = [file.fileInfo objectForKey:@"id"];
    [self.nav pushViewController:recommend animated:YES];
}

#pragma mark 提问按钮点击
- (void)question:(UIButton *)btn
{
    DownloadFileModel *file = [_finishedArray objectAtIndex:btn.tag - 2000];
    QuestionController *question = [[QuestionController alloc] init];
    question.sid =[file.fileInfo objectForKey:@"id"];
    [self.nav pushViewController:question animated:YES];
}

#pragma mark 播放按钮点击
- (void)play:(UIButton *)btn
{
    DownloadFileModel *file = [_finishedArray objectAtIndex:btn.tag-3000];
    //视频
    if ([file.type isEqualToString:@"1"]) {

        NSURL *url = [NSURL fileURLWithPath:file.targetPath];
        DirectionMPMoviePlayerViewController *movieController = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:url];
        [self.view.window.rootViewController presentMoviePlayerViewControllerAnimated:movieController];

    }else{
        
        UIDocumentInteractionController *documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:file.targetPath]];
        documentController.delegate = self;
        [documentController presentPreviewAnimated:YES];
    }
    NSDictionary *param = @{@"sid":[file.fileInfo objectForKey:@"id"]};
    [HttpTool postWithPath:@"getHistoryAdd" params:param success:^(id JSON, int code, NSString *msg) {
        NSLog(@"%@",JSON);
        if (code == 100) {
            [[NSNotificationCenter defaultCenter] postNotificationName:playMessage object:nil];
        }
    } failure:^(NSError *error) {
       NSLog(@"%@",error);
    }];
}

#pragma mark UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.window.rootViewController;
}

#pragma mark CircularProgressView_delegate
- (void)progressViewClicked:(CircularProgressView *)view
{
    DownloadFileModel *fileInfo =[_unFinishedArray objectAtIndex:view.tag-1000];
    //点击停止下载
    if (fileInfo.isDownloading) {
        [DownloadManager stopDownload:fileInfo];
    }else{
        //点击等待下载
        if (fileInfo.willDownloading) {
            return;
            //点击开始下载
        }else{
            [DownloadManager resumeDownload:fileInfo];
        }
    }
    
    [_tableView reloadData];
}

#pragma mark Download_delegate  下载失败
- (void)downloadFailure:(DownloadFileModel *)fileinfo
{
    [_tableView reloadData];
}

//下载成功
- (void)downloadFinished:(DownloadFileModel *)fileinfo
{
    [self loadData];
}

//更新进度
- (void)updateUI:(DownloadFileModel *)fileinfo progress:(float)progress
{
    for (DownloadFileModel *file in _unFinishedArray) {
        
        if ([file.fileName isEqualToString:fileinfo.fileName]) {
            
            NSInteger count = [_unFinishedArray indexOfObject:file];
            
            UnfinishedCell *cell = (UnfinishedCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:_dataArray.count-1]];
            
            cell.progressView.progress = progress;
            cell.progressLabel.text = [NSString stringWithFormat:@"%@/%@",[CommonHelper transformToM:file.fileReceivedSize],[CommonHelper transformToM:file.totalSize]];
            return;
        }
    }
}

- (void)dealloc
{
    [DownloadManager setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
