//
//  DWQuestionView.m
//  CustomDemo
//
//  Created by luyang on 2018/2/9.
//  Copyright © 2018年 Myself. All rights reserved.
//

#import "DWQuestionView.h"
#import "DWQuestionCell.h"
#import "DWAnswerModel.h"


@interface DWQuestionView()<UITableViewDelegate,UITableViewDataSource>{
    
    UIButton *skipBtn;
}

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)CGFloat tableViewWidth;
@property (nonatomic,assign)CGFloat tableViewHeight;

@property (nonatomic,strong)NSMutableArray *btnArray;
@property (nonatomic,strong)NSMutableArray *answerArray;
@property (nonatomic,strong)NSMutableArray *selectArray;

@property (nonatomic,strong)UILabel *toastLabel;

@property (nonatomic,assign)BOOL isRight;

@end

@implementation DWQuestionView

- (NSMutableArray *)answerArray{
    
    if (!_answerArray) {
        
        _answerArray =[NSMutableArray array];
    }
    
    return _answerArray;
}


- (NSMutableArray *)selectArray{
    
    if(!_selectArray){
        
        _selectArray =[NSMutableArray array];
        
    }
    
    return _selectArray;
}

- (NSMutableArray *)btnArray{
    
    if (!_btnArray) {
        
        _btnArray =[NSMutableArray array];
    }
    
    return _btnArray;
}

- (instancetype )initWithFrame:(CGRect)frame{
    
    self =[super initWithFrame:frame];
    if (self) {
        
        self.tableViewWidth =frame.size.width;
        self.tableViewHeight =frame.size.height;
        self.layer.cornerRadius =8/2;
        self.layer.masksToBounds =YES;
        [self loadSubviews];
    }
    
    return self;
}

- (void)loadSubviews{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,self.tableViewWidth,self.tableViewHeight-90/2) style:UITableViewStylePlain];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
   // self.tableView.allowsMultipleSelection =YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator =YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    
    //尾部视图
    UIView *footerView =[[UIView alloc]init];
    footerView.backgroundColor =[DWTools colorWithHexString:@"#f0f8ff"];
    [self addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.left.centerX.mas_equalTo(self.tableView);
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(45);
        
    }];
    
    UIButton *commitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundColor:[DWTools colorWithHexString:@"#419bf9"]];
    [footerView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(footerView.mas_centerX).offset(25);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(footerView.mas_bottom).offset(-15/2);
    }];
    
    
    skipBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setBackgroundColor:[DWTools colorWithHexString:@"#9198a3"]];
    [footerView addSubview:skipBtn];
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(footerView.mas_centerX).offset(-25);
        make.width.height.top.mas_equalTo(commitBtn);
        
    }];
    
    _toastLabel =[[UILabel alloc]init];
    _toastLabel.text =@"请选择答案";
    _toastLabel.textColor =[UIColor whiteColor];
    _toastLabel.font =[UIFont systemFontOfSize:13];
    _toastLabel.textAlignment =NSTextAlignmentCenter;
    _toastLabel.backgroundColor =[UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:0.5];
    _toastLabel.layer.cornerRadius =2;
    _toastLabel.layer.masksToBounds =YES;
    _toastLabel.hidden =YES;
    [self addSubview:_toastLabel];
    [_toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(262/2);
        make.height.mas_equalTo(80/2);
        
    }];
  
    
    
    
}

- (void)commitAction{
    
    if (!self.selectArray.count) {
        //提示选择答案
        self.toastLabel.hidden =NO;
        
        return;
    }
    
    //答案是否正确
    if (self.selectArray.count !=self.answerArray.count) {
        
        if (_questionBlock) {
            
            _questionBlock(_isRight);
        }
        
        return;
    }
    
    BOOL right =[self verifyAnswer];
    if (_questionBlock) {
        _questionBlock(right);
    }
    
}
//校验答案
- (BOOL )verifyAnswer{
    
    
    [self.selectArray enumerateObjectsUsingBlock:^(DWAnswerModel *answerModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([answerModel.right boolValue]) {
            
           self.isRight =YES;
            
        }else{
            
            self.isRight =NO;
            *stop =YES;
        }
        
        
    }];
    
    return _isRight;
    
}

- (void)skipAction{
    
    //能否跳过
    if (![_questionModel.jump boolValue]) {
        
        self.toastLabel.hidden =NO;
        
        
    }else{
    
     if (_skipBlock) {
        
         _skipBlock();
      }
        
    }
    
}

- (void)didQuestionBlock:(QuestionBlock )block{
    
    _questionBlock =block;
}


- (void)didSkipBlock:(SkipBlock )block{
    
    _skipBlock =block;
}

- (void)setQuestionModel:(DWQuestionModel *)questionModel{
    
    _questionModel =questionModel;
    
    if ([_questionModel.jump boolValue]) {
        
        [skipBtn setBackgroundColor:[DWTools colorWithHexString:@"#419bf9"]];
    }
    
    [self.tableView reloadData];
}

//返回高度
- (CGSize)heightWithWidth:(CGFloat)width andFont:(CGFloat )font andLabelText:(NSString *)text{
    
    NSDictionary *dict =[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect rect=[text boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return rect.size;
}

#pragma mark------UITableViewDelegate-----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    //计算高度
    CGSize size =[self heightWithWidth:self.tableViewWidth-30 andFont:14 andLabelText:_questionModel.content];
    
    return size.height+104/2;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.tableViewWidth,185/2)];
    
   
    UILabel *classLabel =[[UILabel alloc]init];
    classLabel.text =@"课堂练习";
    classLabel.font =[UIFont systemFontOfSize:16];
    classLabel.textAlignment =NSTextAlignmentCenter;
    classLabel.textColor =[DWTools colorWithHexString:@"#52a4fa"];
    [headerView addSubview:classLabel];
    [classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headerView).offset(15);
        make.width.mas_equalTo(128);
        make.height.mas_equalTo(32/2);
        make.centerX.mas_equalTo(headerView);
        
    }];
    
    UILabel *questionLabel =[[UILabel alloc]init];
    questionLabel.text =[NSString stringWithFormat:@"题目：%@",_questionModel.content];
    questionLabel.font =[UIFont systemFontOfSize:14];
    questionLabel.textColor =[DWTools colorWithHexString:@"#333333"];
    questionLabel.numberOfLines =0;
    [headerView addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(classLabel.mas_bottom).offset(21);
        make.left.mas_equalTo(headerView.mas_left).offset(15);
        make.right.mas_equalTo(headerView.mas_right).offset(-15);
        make.bottom.mas_equalTo(headerView);
        
    }];
    
    UIView *leftView =[[UIView alloc]initWithFrame:CGRectMake(15, 45/2, 90, 1)];
    [headerView addSubview:leftView];
    
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = leftView.bounds;
    //设置渐变颜色数组,可以加透明度的渐变
    leftLayer.colors = @[(__bridge id)[DWTools colorWithHexString:@"#ffffff" alpha:0.f].CGColor,(__bridge id)[DWTools colorWithHexString:@"#52a4fa" alpha:1.f].CGColor];
    //设置渐变区域的起始和终止位置（范围为0-1）
    leftLayer.startPoint = CGPointMake(0, 0);
    leftLayer.endPoint = CGPointMake(1, 0);
  //  gradientLayer.locations = @[@0.1,@0.2];
    [leftView.layer addSublayer:leftLayer];
    
    UIView *rightView =[[UIView alloc]initWithFrame:CGRectMake(self.tableViewWidth-15-90, 45/2, 90, 1)];
    [headerView addSubview:rightView];
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame =rightView.bounds;
    rightLayer.colors = @[(__bridge id)[DWTools colorWithHexString:@"#52a4fa" alpha:1.f].CGColor,(__bridge id)[DWTools colorWithHexString:@"#ffffff" alpha:0.f].CGColor];
    
    rightLayer.startPoint = CGPointMake(0, 0);
    rightLayer.endPoint = CGPointMake(1, 0);
    [rightView.layer addSublayer:rightLayer];
    
    return headerView;
}



#pragma mark------UITableViewDataSource------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return _questionModel.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"cellIdentifier";
    DWQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DWQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    }
    
    //首先要清空答案数组
    [self.answerArray removeAllObjects];
    
    //单选or多选
    for (DWAnswerModel *model in _questionModel.answers) {
        
        if ([model.right boolValue]) {
            
            [self.answerArray addObject:model];
        }
        
    }
    BOOL multipleSelect;
    if (self.answerArray.count >1) {
        
        multipleSelect =YES;//多选
    }else{
        multipleSelect =NO;//单选
    }
    
    
    DWAnswerModel *answerModel =_questionModel.answers[indexPath.row];
    [cell updateQuestion:answerModel withMultipleSelect:multipleSelect];
    [cell didSelectBlock:^(UIButton *btn,BOOL select) {
        
        if (select) {
            
            //单选
            if (!multipleSelect) {
                
                UIButton *lastBtn =[self.btnArray firstObject];
                lastBtn.selected =NO;
                [self.btnArray removeAllObjects];
                [self.selectArray removeAllObjects];
            }
            
             self.toastLabel.hidden =YES;
             [self.btnArray addObject:btn];
             [self.selectArray addObject:answerModel];
            
            
            
        }else{
            
            [self.btnArray removeObject:btn];
            [self.selectArray removeObject:answerModel];
        }
        
    }];
    
    return cell;
    
}



@end
