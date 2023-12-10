//
//  UIViewController+Exts.swift
//  Presentation
//
//  Created by Dao Van Nha on 11/10/2023.
//

import Foundation
import UIKit

//public extension UIViewController {
//    
//    func push(from vc: UIViewController?,
//              showInDetail: Bool = false,
//              animated: Bool = true) {
//        guard let vc = vc else { return }
//        let nav = (vc as? UINavigationController) ?? vc.navigationController
//        if showInDetail && vc.splitViewController != nil {
//            nav?.showDetailViewController(self, sender: nil)
//        } else {
//            nav?.pushViewController(self, animated: animated)
//        }
//    }
//}

public extension UIViewController {
    
    func presentFullScreen(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: animated, completion: completion)
    }
    
    // Check if this VC is presented and not pushed into stack
    var isFirstViewControllerPresented: Bool {
        guard let nav = navigationController else {
            return presentingViewController != nil
        }
        
        return presentingViewController != nil && nav.viewControllers.first === self
    }
    
    func addRightBarButtonItem(image: UIImage?, color: UIColor? = nil, action: Selector) {
        let item = UIBarButtonItem(image: image,
                                   style: .plain,
                                   target: self,
                                   action: action)
        item.tintColor = color
        addBarButtonItem(item, position: .right)
    }
    
    func addRightBarButtonItem(item: UIBarButtonItem?, color: UIColor? = nil) {
        guard let item = item else { return }
        item.tintColor = color
        addBarButtonItem(item, position: .right)
    }
    
    func addRightBarButtonItem(title: String?, color: UIColor? = nil, action: Selector) {
        let item = UIBarButtonItem(title: title,
                                   style: .plain,
                                   target: self,
                                   action: action)
        item.tintColor = color
        addBarButtonItem(item, position: .right)
    }
    
    func addLeftBarButtonItem(image: UIImage?, color: UIColor? = nil, action: Selector) {
        let item = UIBarButtonItem(image: image,
                                   style: .plain,
                                   target: self,
                                   action: action)
        item.tintColor = color
        addBarButtonItem(item, position: .left)
    }
    
    func addLeftBarButtonItem(title: String?, color: UIColor? = nil, action: Selector) {
        let item = UIBarButtonItem(title: title,
                                   style: .plain,
                                   target: self,
                                   action: action)
        item.tintColor = color
        addBarButtonItem(item, position: .left)
    }
    
    private enum BarButtonItemPosition {
        case left
        case right
    }
    
    private func addBarButtonItem(_ item: UIBarButtonItem, position: BarButtonItemPosition) {
        switch position {
        case .left:
            if navigationItem.leftBarButtonItems == nil {
                navigationItem.leftBarButtonItems = []
            }
            
            navigationItem.leftBarButtonItems?.append(item)
        case .right:
            if navigationItem.rightBarButtonItems == nil {
                navigationItem.rightBarButtonItems = []
            }
            
            navigationItem.rightBarButtonItems?.append(item)
        }
    }
    
    @objc func didTapCloseBarButton() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func push(from vc: UIViewController?,
              showInDetail: Bool = false,
              animated: Bool = true) {
        guard let vc = vc else { return }
        let nav = (vc as? UINavigationController) ?? vc.navigationController
        if showInDetail && vc.splitViewController != nil {
            nav?.showDetailViewController(self, sender: nil)
        } else {
            nav?.pushViewController(self, animated: animated)
        }
    }
    
    func present(from vc: UIViewController?,
                 fullscreen: Bool = true,
                 fullscreenOnIpad: Bool = true,
                 animated: Bool = true) {
        func presentFull() {
            if transitioningDelegate == nil {
                transitioningDelegate = CustomViewControllerTransition.shared
            }
            
            vc?.presentFullScreen(self, animated: animated)
        }
        
        if fullscreen && (UIDevice.current.userInterfaceIdiom != .pad || fullscreenOnIpad) {
            presentFull()
        } else {
            vc?.present(self, animated: animated)
        }
    }
    
    /// Pop view controllers from navigation stack until meet instance of a UIViewController type,
    /// then push a view controller into stack, if set.
    /// If there is no instance of that type in stack, this will pop nothing and only push (if set).
    /// - Parameters:
    ///   - type: a type of `UIViewController`
    ///   - includeLast: `true` will also remove that instance, `false` will keep it.
    ///   - vc: view controller to push into stack
    ///   - animated: animated
    func popToInstanceOf<T: UIViewController>(type: T.Type,
                                              includeLast: Bool = false,
                                              thenPush vc: UIViewController? = nil,
                                              animated: Bool = true) {
        guard let nav = navigationController ?? (self as? UINavigationController) else {
            return
        }
        
        let viewControllers = nav.viewControllers
        if let index = viewControllers.lastIndex(where: { $0 is T }) {
            let count = viewControllers.count - index - (includeLast ? 0 : 1)
            popLast(count: count, thenPush: vc, animated: animated)
        } else {
            popLast(count: 0, thenPush: vc, animated: animated)
        }
    }
    
    /// Pop view controllers from stack then push a new view controller (if set)
    /// - Parameters:
    ///   - count: number of view controllers to pop
    ///   - vc: view controller to push into stack
    ///   - animated: animated
    func popLast(count: Int = 1, thenPush vc: UIViewController? = nil, animated: Bool = true) {
        guard let nav = navigationController ?? (self as? UINavigationController) else {
            return
        }
        
        // do normal pop
        if count == 1, vc == nil {
            nav.popViewController(animated: animated)
            return
        }
        
        // do normal push
        if count == 0, let vc = vc {
            nav.pushViewController(vc, animated: animated)
            return
        }
        
        var viewControllers = nav.viewControllers
        viewControllers = viewControllers.dropLast(count)
        
        if let vc = vc {
            viewControllers.append(vc)
        }
        
        nav.setViewControllers(viewControllers, animated: animated)
    }
    
    func popToRoot(thenPush vc: UIViewController, animated: Bool = true) {
        guard let nav = navigationController ?? (self as? UINavigationController) else {
            return
        }
        
        popLast(count: nav.viewControllers.count - 1, thenPush: vc, animated: animated)
    }
}

public extension UIViewController {
    
    static func visibleViewController(from rootViewController: UIViewController?
                                      = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let tabBarController = rootViewController as? UITabBarController {
            return visibleViewController(from: tabBarController.selectedViewController)
        }
        
        guard let presentedViewController = rootViewController?.presentedViewController else {
            return rootViewController
        }
        
        if let nav = presentedViewController as? UINavigationController {
            return visibleViewController(from: nav.viewControllers.last)
        }
        
        if let tabBarController = presentedViewController as? UITabBarController {
            return visibleViewController(from: tabBarController.selectedViewController)
        }
        
        return visibleViewController(from: presentedViewController)
    }
}

public extension UINavigationController {
    func popToLastViewController<T>(ofType type: T.Type, animated: Bool = true) where T: UIViewController {
        if let vc = viewControllers.last(where: { $0 is T }) {
            popToViewController(vc, animated: animated)
        }
    }
}

public extension UIViewController {
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
class TransitioningAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let animationDuration: TimeInterval = 0.5
    private let reverseAnimationDuration: TimeInterval = 0.65
    private let transitionScale: CGFloat = 0.9
    
    var isReversed: Bool = false
    
    static var present: TransitioningAnimator {
        let animator = TransitioningAnimator()
        animator.isReversed = false
        return animator
    }
    
    static var dismiss: TransitioningAnimator {
        let animator = TransitioningAnimator()
        animator.isReversed = true
        return animator
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return isReversed ? reverseAnimationDuration : animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        let screenBounds = fromVC.view.bounds
        
        var finalFrame: CGRect = .zero
        finalFrame.size = screenBounds.size
        
        if !isReversed {
            var origFrame: CGRect = .zero
            origFrame.origin = CGPoint(x: toVC.view.frame.origin.x,
                                       y: toVC.view.frame.size.height)
            origFrame.size = toVC.view.frame.size
            toVC.view.frame = origFrame
            
            containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
            
            finalFrame.origin = .zero
        } else {
            toVC.view.frame = transitionContext.finalFrame(for: toVC)
            
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
            
            let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.size.height)
            finalFrame.origin = bottomLeftCorner
            
            toVC.view.transform = .init(scaleX: transitionScale, y: transitionScale)
        }
        
        let roundedCornerVC = isReversed ? toVC : fromVC
        
        let screenCornerRadius: CGFloat = UIScreen.main.displayCornerRadius
        let targetCornerRadius: CGFloat = 16.0
        roundedCornerVC.view.layer.masksToBounds = true
        roundedCornerVC.view.layer.cornerRadius = isReversed ? targetCornerRadius : screenCornerRadius
        
        if #available(iOS 13.0, *) {
            roundedCornerVC.view.layer.cornerCurve = .continuous
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
            if self.isReversed {
                fromVC.view.frame = finalFrame
                fromVC.view.layer.shadowOpacity = 0
                toVC.view.transform = .identity
                roundedCornerVC.view.layer.cornerRadius = screenCornerRadius
            } else {
                toVC.view.frame = finalFrame
                fromVC.view.transform = .init(scaleX: self.transitionScale,
                                              y: self.transitionScale)
                roundedCornerVC.view.layer.cornerRadius = targetCornerRadius
            }
        },
                       completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            if !self.isReversed {
                fromVC.view.transform = .identity
            } else {
                toVC.view.transform = .identity
            }
            
            roundedCornerVC.view.layer.cornerRadius = 0
        })
    }
}

class CustomViewControllerTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    static let shared = CustomViewControllerTransition()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningAnimator.present
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitioningAnimator.dismiss
    }
}

extension UIScreen {
    private static let cornerRadiusKey: String = {
        let components = ["Radius", "Corner", "display", "_"]
        return components.reversed().joined()
    }()

    /// The corner radius of the display. Uses a private property of `UIScreen`,
    /// and may report 0 if the API changes.
    var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: Self.cornerRadiusKey) as? CGFloat else {
            assertionFailure("Failed to detect screen corner radius")
            return 0
        }

        return cornerRadius
    }
}


