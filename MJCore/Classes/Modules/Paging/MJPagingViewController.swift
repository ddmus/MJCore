//
//  MJPagingViewController.swift
//  MJCore
//
//  Created by Martin Janák on 01/08/2018.
//

import RxSwift

public typealias MJPageViewControllerType = UIViewController & MJPagingViewControllerType

public struct MJPagingChange {
    
    let viewController: MJPageViewControllerType?
    let direction: UIPageViewController.NavigationDirection
    let animated: Bool
    
}

public final class MJPagingVC<PagingModel: MJPagingModelType>: UIPageViewController {
    
    private let disposeBag = DisposeBag()
    public let model = MJPagingViewModel<PagingModel>()
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        initBindings()
    }
    
    private func initBindings() {
        
        delegate = model
        dataSource = model
        
        model.change
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] pageViewChange in
                guard let pageViewChange = pageViewChange else { return }
                var viewControllers: [UIViewController]
                if let viewController = pageViewChange.viewController {
                    viewControllers = [viewController]
                } else {
                    viewControllers = []
                }
                self?.setViewControllers(
                    viewControllers,
                    direction: pageViewChange.direction,
                    animated: pageViewChange.animated,
                    completion: { _ in
                        self?.model.changeCompletedWith.accept(pageViewChange.viewController)
                    }
                )
            })
            .disposed(by: disposeBag)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
