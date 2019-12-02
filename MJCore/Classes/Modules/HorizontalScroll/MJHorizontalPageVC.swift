//
//  MJHorizontalPageVC.swift
//  MJCore
//
//  Created by Martin Janák on 03/07/2018.
//

import UIKit
import RxSwift

public struct MJPageViewChange {
    
    let viewController: UIViewController?
    let direction: UIPageViewController.NavigationDirection
    let animated: Bool
    
    static func error() -> MJPageViewChange {
        return MJPageViewChange(
            viewController: UIViewController(),
            direction: .forward,
            animated: false
        )
    }
}

public final class MJHorizontalPageVC: UIPageViewController {
    
    private let disposeBag = DisposeBag()
    public let model = MJHorizontalPageVM()
    
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
            .asDriver(onErrorJustReturn: MJPageViewChange.error())
            .drive(onNext: { [weak self] pageViewChange in
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
                        self?.model.changeCompleted.accept(true)
                        self?.model.currentVC.accept(pageViewChange.viewController)
                    }
                )
            })
            .disposed(by: disposeBag)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
