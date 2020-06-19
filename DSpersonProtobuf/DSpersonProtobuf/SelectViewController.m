//
//  SelectViewController.m
//  DSpersonProtobuf
//
//  Created by DSperson on 2020/6/16.
//  Copyright © 2020 bat. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectRowView.h"
@interface SelectViewController () <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSPopUpButton *selectButton;
@property (weak) IBOutlet NSMenu *selectButtonMenu;
@property (nonatomic, strong) NSMutableArray <NSString *>* originFiles;
@property (strong, nonatomic) NSMutableDictionary *dics;
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_tableView registerNib:[[NSNib alloc] initWithNibNamed:@"SelectRowView" bundle:nil] forIdentifier:@"SelectRowView"];
    _tableView.headerView.hidden = true;
    _originFiles = [_files mutableCopy];
    _tableView.tableColumns.firstObject.hidden = true;
    self.dics = [NSMutableDictionary dictionaryWithCapacity:_files.count];
    [_files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dics setValue:@(true) forKey:obj];
    }];
   
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return _files.count;
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(nullable id)object forTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    
}
- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    SelectRowView *r = [tableView makeViewWithIdentifier:@"SelectRowView" owner:nil];
    NSString *v = _files[row];
    BOOL s = [_dics[v] boolValue];
    r.switchButton.state = s;
    r.fileLabel.stringValue = v;
    __weak SelectViewController *weakSelf = self;
    r.block = ^(BOOL s) {
        weakSelf.dics[v] = @(s);
    };
    return r;
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 30.0;
}

- (IBAction)okButton:(id)sender {
    [_dics enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber *  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj boolValue]) {
            [self.files removeObject:key];
        }
    }];
    !_action ?: _action();
}
- (IBAction)selectButtonAction:(NSPopUpButton *)sender {
    switch (sender.indexOfSelectedItem) {
        case 0:
        {
            [_files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dics setValue:@(true) forKey:obj];
            }];
        }
            break;
        case 1:
        {
            [_files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dics setValue:@(false) forKey:obj];
            }];
        }
            break;
        case 2:
        {
            [_files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dics setValue:@(![self.dics[obj] boolValue]) forKey:obj];
            }];
        }
            break;
        default:
            break;
    }
    //    int i = 0;
    //    BOOL ss = !i;
    [self.tableView reloadData];
}
- (IBAction)sortButtonAction:(NSPopUpButton *)sender {
    switch (sender.indexOfSelectedItem) {
        case 0:
        {
            _files = [_originFiles mutableCopy];
        }
            break;
        case 1:
        {
            
            NSStringCompareOptions comparisonOptions = NSNumericSearch;
            NSLocale *currentLocale = [NSLocale currentLocale];
            NSComparator finderSortBlock = ^(id string1,id string2) {
                
                NSRange string1Range = NSMakeRange(0, [string1 length]);
                return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
            };
            NSArray *finderSortArray = [_files sortedArrayUsingComparator:finderSortBlock];
            _files = [finderSortArray mutableCopy];
          
        }
            break;
        case 2:
        {
            NSStringCompareOptions comparisonOptions = NSNumericSearch;
            NSLocale *currentLocale = [NSLocale currentLocale];
            NSComparator finderSortBlock = ^(id string1,id string2) {
                
                NSRange string1Range = NSMakeRange(0, [string2 length]);
                return [string2 compare:string1 options:comparisonOptions range:string1Range locale:currentLocale];
            };
            NSArray *finderSortArray = [_files sortedArrayUsingComparator:finderSortBlock];
            _files = [finderSortArray mutableCopy];
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}


@end
