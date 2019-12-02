//
//  MJPagingScrollViewModel.swift
//  MJCore
//
//  Created by Martin Janák on 01/08/2018.
//

import UIKit
import RxSwift

open class MJPagingScrollVC<
    PagingModel: MJPagingModelType,
    View: MJPagingScrollView,
    ViewModel: MJPagingScrollVM<PagingModel>
>: UIViewController {
    
    public let disposeBag = DisposeBag()
    public let ui: View
    private let pagingVC: MJPagingVC<PagingModel>
    public let viewModel: ViewModel
    
    public init() {
        ui = View()
        pagingVC = MJPagingVC<PagingModel>()
        viewModel = ViewModel()
        viewModel.pagingVM = pagingVC.model
        super.init(nibName: nil, bundle: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        addChild(pagingVC)
        ui.initView(pagingVC.view)
        view = ui
        pagingVC.didMove(toParent: self)
        viewModel.initBindings()
        pagingVC.model.initBindings()
        initBindings()
    }
    
    open func initBindings() {
        // optional override
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
