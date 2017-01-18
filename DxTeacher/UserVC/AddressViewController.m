//
//  AddressViewController.m
//  DxTeacher
//
//  Created by ligb on 16/11/1.
//  Copyright © 2016年 XXTechnology Co.,Ltd. All rights reserved.
//

#import "AddressViewController.h"
#import "TeacherTableViewCell.h"
#import "GenearchTableViewCell.h"
#import "AppDefine.h"

@interface AddressViewController ()
{
    __weak IBOutlet UIView *_headView;
    
    __weak IBOutlet UIButton *_addressBtn1;
    
    __weak IBOutlet UIButton *_addressBtn2;
    
    __weak IBOutlet UITableView *_tableView;
}
@property (nonatomic , strong) NSMutableArray *addressArray;//园所通讯录数据
@end

@implementation AddressViewController
- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
}
- (void)loadNewView{
    _headView.layer.borderWidth = 1;
    _headView.layer.borderColor = [UIColor colorLineBg].CGColor;
    
    [_addressBtn1 setTitleColor:[UIColor colorAppBg] forState:UIControlStateSelected];
    [_addressBtn2 setTitleColor:[UIColor colorAppBg] forState:UIControlStateSelected];
    _addressBtn1.selected = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.screen_W/2-1, _headView.y, 1, _headView.h)];

    lineView.backgroundColor = [UIColor colorLineBg];
    [_headView addSubview:lineView];
}
- (void)loadNewData{
    NSDictionary *info = [SavaData parseDicFromFile:User_File];
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":@"getStudentPhoneBook",@"uid":info[@"id"]} completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            //请求成功
            
            [self.dataSource setArray:model.data];
            [_tableView reloadData];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
}
- (void)loadSchoolPhoneData{
    [self.view showHUDActivityView:@"正在加载" shade:NO];
    [[ANet share] post:BASE_URL params:@{@"action":@"getTeaherPhoneBook"} completion:^(BNetData *model, NSString *netErr) {
        [self.view removeHUDActivity];
        
        NSLog(@"data = %@",model.data);
        if (model.status == 0) {
            NSArray *array = model.data;
            if ([array isKindOfClass:[NSArray class]] && array.count) {
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.addressArray addObject:obj];
                }];
            }
            [_tableView reloadData];
        }else{
            [self.view showHUDTitleView:model.message image:nil];
        }
        
    }];
}

- (IBAction)selectAddressType:(UIButton *)sender {
    
    sender.selected = YES;
    if (sender.tag == 100) {
        _addressBtn2.selected = NO;
        [self loadNewData];
    }else{
        _addressBtn1.selected = NO;
        [[ANet share] post:BASE_URL params:@{@"action":@"getSchoolPhoneBook"} completion:^(BNetData *model, NSString *netErr) {
              NSLog(@"data = %@",model.data);
            if (self.addressArray.count) {
                [self.addressArray removeAllObjects];
            }
            if (model.status == 0) {
                NSMutableArray *array = [NSMutableArray array];
                [model.data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    [array addObject:@[key,obj]];
                }];
                //请求成功
                [self.addressArray addObject:@{@"grade":@"园所通讯",@"teachers":array}];
            }else{
               
            }
            [self loadSchoolPhoneData];
        }];

    }
    
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_addressBtn1.selected) {
        return self.dataSource.count;
    }else{
        return self.addressArray.count;
    }
    
}
- (NSArray *)itemsArr:(NSInteger)section{
    NSArray *items = @[];
    if (_addressBtn1.selected) {
        items = self.dataSource[section][@"childrens"];
    }else{
        items = self.addressArray[section][@"teachers"];
    }
    if ([items isKindOfClass:[NSArray class]] && items.count) {
        return items;
    }
    return @[];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self itemsArr:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_addressBtn1.selected) {
        static NSString *xibName = @"GenearchTableViewCell";
        GenearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[self itemsArr:indexPath.section] count]) {
            cell.info = [self itemsArr:indexPath.section][indexPath.row];
            
        }
        return cell;

    }else{
        NSString *title = self.addressArray[indexPath.section][@"grade"];
        if ([title isEqualToString:@"园所通讯"]) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
            }
            NSArray *items = [self itemsArr:indexPath.section][indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@：%@",items[0],items[1]];
            return cell;
        }else{
            static NSString *xibName = @"TeacherTableViewCell";
            TeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:xibName];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([[self itemsArr:indexPath.section] count]) {
                cell.info = [self itemsArr:indexPath.section][indexPath.row];
                
            }
            return cell;
        }
    }
    
     
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screen_W, 35)];
    //headView.backgroundColor = [UIColor colorCellLineBg];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 60, 25)];
    labTitle.backgroundColor = [UIColor colorAppBg];
    labTitle.layer.cornerRadius = 3;
    labTitle.clipsToBounds = YES;
    labTitle.textColor = [UIColor whiteColor];
    labTitle.font = [UIFont systemFontOfSize:14];
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.text = _addressBtn1.selected ? self.dataSource[section][@"grade"] : self.addressArray[section][@"grade"];
    [headView addSubview:labTitle];
    
    //画线
    UILabel *labLine = [[UILabel alloc] initWithFrame:CGRectMake(15, headView.h-1, self.screen_W-15, 1)];
    labLine.backgroundColor = [UIColor colorCellLineBg];
    [headView addSubview:labLine];
    return headView;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (_addressBtn1.selected) {
         return;
     }
    NSString *title = self.addressArray[indexPath.section][@"grade"];
    if ([title isEqualToString:@"园所通讯"]) {
        NSArray *items = [self itemsArr:indexPath.section][indexPath.row];
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",items[1]]];
        [[UIApplication sharedApplication] openURL:phoneURL];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_addressBtn1.selected) {
        return 90;
    }
   NSString *title = self.addressArray[indexPath.section][@"grade"];
    if ([title isEqualToString:@"园所通讯"]) {
        return 40;
    }
    
    return 80;
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
