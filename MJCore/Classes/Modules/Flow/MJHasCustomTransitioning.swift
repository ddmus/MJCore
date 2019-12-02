//
//  MJHasCustomTransitioning.swift
//  MJCore
//
//  Created by Martin Janák on 26/10/2018.
//

import UIKit

public protocol MJHasCustomTransitioning {
    
    func getCustomTransitioning(
        toVC: UIViewController,
        operation: UINavigationController.Operation
    ) -> UIViewControllerAnimatedTransitioning?
    
}
