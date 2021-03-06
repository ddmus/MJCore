//
//  Driver+Datasource.swift
//  MJCore
//
//  Created by Martin Janák on 29/07/2018.
//

import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    
    public func dataSource<TableModel>(
        _ tableView: MJTableView<TableModel>
    ) -> Disposable where E == [TableModel] {
        return self.drive(tableView.data)
    }
    
    public func dataSource<CellModel, TableModel>(
        _ tableView: MJTableView<TableModel>
    ) -> Disposable where E == [CellModel] {
        return self
            .filter { data in
                return data.reduce(true, { isTableModel, value in
                    return isTableModel && (value is TableModel)
                })
            }
            .map { $0.map { $0 as! TableModel } }
            .drive(tableView.data)
    }
    
    public func dataSource<StackModel>(
        _ dynamicStackView: MJDynamicStackView<StackModel>
    ) -> Disposable where E == [StackModel] {
        return self.drive(dynamicStackView.data)
    }
    
    public func dataSource<CellModel, StackModel>(
        _ dynamicStackView: MJDynamicStackView<StackModel>
    ) -> Disposable where E == [CellModel] {
        return self
            .filter { data in
                return data.reduce(true, { isStackModel, value in
                    return isStackModel && (value is StackModel)
                })
            }
            .map { $0.map { $0 as! StackModel } }
            .drive(dynamicStackView.data)
    }
    
}
