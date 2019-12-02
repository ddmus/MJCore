//
//  MJNavigationController.swift
//  MJCore
//
//  Created by Martin Janák on 26/10/2018.
//

import UIKit

internal class MJNavigationController: UINavigationController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension MJNavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if let fromVC = fromVC as? MJHasCustomTransitioning {
            return fromVC.getCustomTransitioning(toVC: toVC, operation: operation)
        }
        return nil
    }
}
