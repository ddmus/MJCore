//
//  MJTableViewCell.swift
//  MJCore
//
//  Created by Martin Janák on 29/07/2018.
//

import UIKit
import RxSwift
import RxCocoa

open class MJTableViewCell<Model>: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    public let model: BehaviorRelay<MJTableViewCellModel<Model>?>
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        model = BehaviorRelay<MJTableViewCellModel<Model>?>(value: nil)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        initBindings()
    }
    
    open func initView() {
        fatalError("initView() has not been implemented")
    }
    
    private func initBindings() {
        model.asDriver()
            .drive(onNext: { [weak self] model in
                self?.set(model: model)
            })
            .disposed(by: disposeBag)
    }
    
    open func set(model: MJTableViewCellModel<Model>?) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
