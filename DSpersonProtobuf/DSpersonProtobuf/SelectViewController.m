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

@property (strong, nonatomic) NSMutableDictionary *dics;
@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [_tableView registerNib:[[NSNib alloc] initWithNibNamed:@"SelectRowView" bundle:nil] forIdentifier:@"SelectRowView"];
    _tableView.headerView.hidden = true;
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
    NSLog(@"%@", v);
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

@end
