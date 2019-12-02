//
//  MJTableViewWithSections.swift
//  MJCore
//
//  Created by Martin Janák on 16/08/2018.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

open class MJTableViewWithSections<SectionTableModel: MJSectionTableModel>
    : UITableView
    , UITableViewDataSource
    , UITableViewDelegate {
    
    private typealias CellConstructor = (SectionTableModel.ItemModel) -> (
        ((UITableView, IndexPath) -> UITableViewCell)?
    )
    
    public var sectionHeaderConstructor: ((UITableView, Int, SectionTableModel.HeaderModel) -> UIView) = { _, section, _ in
        let label = UILabel()
        label.text = "Section \(section)"
        return label
    }
    
    public func set<SectionHeaderView: MJTableSectionHeaderView<SectionTableModel.HeaderModel>>(
        sectionHeaderViewType: SectionHeaderView.Type
    ) {
        sectionHeaderConstructor = { tableView, section, headerModel in
            let header = SectionHeaderView()
            header.model.accept( MJTableSectionHeaderModel(
                tableView: tableView,
                section: section,
                header: headerModel
            ))
            return header
        }
    }
    
    private let disposeBag = DisposeBag()
    
    public let data = BehaviorRelay(value: [SectionTableModel]())
    private var cellConstructors = [CellConstructor]()
    
    public var willSelectItem: (IndexPath) -> IndexPath? = { $0 }
    public var willDeselectItem: (IndexPath) -> IndexPath? = { $0 }
    
    private let didSelectItemRelay = PublishRelay<IndexPath>()
    public lazy var didSelectItem = didSelectItemRelay.asObservable()
    
    private let didDeselectItemRelay = PublishRelay<IndexPath>()
    public lazy var didDeselectItem = didDeselectItemRelay.asObservable()
    
    private let didSelectModelRelay = PublishRelay<SectionTableModel.ItemModel?>()
    public lazy var didDeselectModel = didSelectModelRelay
        .asDriver(onErrorJustReturn: nil)
        .unwrap()
    
    public func didSelectModel<Model>(_ modelType: Model.Type) -> Driver<Model> {
        return didSelectModelRelay
            .asDriver(onErrorJustReturn: nil)
            .cast(Model.self)
    }
    
    public init() {
        super.init(frame: .zero, style: .plain)
        initSetup()
    }
    
    public init(style: UITableView.Style) {
        super.init(frame: .zero, style: style)
        initSetup()
    }
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initSetup()
    }
    
    private func initSetup() {
        backgroundColor = .clear
        delegate = self
        dataSource = self
        initView()
        initBindings()
    }
    
    open func initView() {
        // optional override
    }
    
    private func initBindings() {
        data.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Homogenous table
    
    public func register<Cell: MJTableViewCell<SectionTableModel.ItemModel>>(
        _ cellClass: Cell.Type,
        additionalSetup: ((UITableView, IndexPath, SectionTableModel.ItemModel, inout Cell) -> Void)? = nil
    ) {
        let cellId = "\(cellClass)Id"
        register(cellClass, forCellReuseIdentifier: cellId)
        cellConstructors.append({ cellModel in
            return { tableView, indexPath in
                if var cell = tableView.dequeueReusableCell(
                    withIdentifier: cellId,
                    for: indexPath
                ) as? Cell {
                    cell.model.accept(MJTableViewCellModel(
                        tableView: tableView,
                        indexPath: indexPath,
                        cell: cellModel
                    ))
                    additionalSetup?(tableView, indexPath, cellModel, &cell)
                    return cell
                }
                return UITableViewCell()
            }
        })
    }
    
    // MARK: Heterogenous table
    // - CellModel has to implement CollectionModel protocol or extend CollectionModel class
    
    public func register<CellModel, Cell: MJTableViewCell<CellModel>>(
        _ cellClass: Cell.Type,
        additionalSetup: ((UITableView, IndexPath, CellModel, inout Cell) -> Void)?
    ) {
        let cellId = "\(cellClass)Id"
        register(cellClass, forCellReuseIdentifier: cellId)
        cellConstructors.append({ tableModel in
            if let cellModel = tableModel as? CellModel {
                return { tableView, indexPath in
                    if var cell = tableView.dequeueReusableCell(
                        withIdentifier: cellId,
                        for: indexPath
                    ) as? Cell {
                        cell.model.accept(MJTableViewCellModel(
                            tableView: tableView,
                            indexPath: indexPath,
                            cell: cellModel
                        ))
                        additionalSetup?(tableView, indexPath, cellModel, &cell)
                        return cell
                    }
                    return UITableViewCell()
                }
            } else {
                return nil
            }
        })
    }
    
    // MARK: Data source
    
    public func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return data.value[section].items.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return data.value.count
    }
    
    public func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let model = data.value[indexPath.section].items[indexPath.item]
        for cellConstructor in cellConstructors {
            if let cellSetup = cellConstructor(model) {
                return cellSetup(tableView, indexPath)
            }
        }
        return UITableViewCell()
    }
    
    public func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = data.value[section].header
        return sectionHeaderConstructor(tableView, section, header)
    }
    
    // MARK: Delegate
    
    public func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return willSelectItem(indexPath)
    }
    
    public func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        didSelectItemRelay.accept(indexPath)
        let model = data.value[indexPath.section].items[indexPath.item]
        didSelectModelRelay.accept(model)
    }
    
    public func tableView(
        _ tableView: UITableView,
        willDeselectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return willDeselectItem(indexPath)
    }
    
    public func tableView(
        _ tableView: UITableView,
        didDeselectRowAt indexPath: IndexPath
    ) {
        didDeselectItemRelay.accept(indexPath)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
