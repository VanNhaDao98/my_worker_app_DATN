//
//  MainTabbarViewController.swift
//  WorkerAPP
//
//  Created by Dao Van Nha on 16/10/2023.
//

import UIKit
import Presentation
import Utils

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
        for vc in viewControllers ?? [] {
            if let nav = vc as? UINavigationController {
                nav.delegate = self
            }
        }
        tabBar.backgroundColor = .ink05
    }
    
    private func setViewControllers() {
        let makeItem = { (vc: UIViewController, title: String, image: UIImage?, selectedImage: UIImage?) in
            let nav = BaseNavigationViewController(rootViewController: vc)
            nav.tabBarItem.title = title
            nav.tabBarItem.image = image
            nav.tabBarItem.selectedImage = selectedImage
            return nav
        }
        
        viewControllers = [
            makeItem(HomeViewController(), "Trang chủ", ImageConstant.briefcase, ImageConstant.briefcaseFill),
            makeItem(OrderViewController(), "Đơn hàng", ImageConstant.clipboardMinus, ImageConstant.clipboardMinusFill),
            makeItem(NotiViewController(), "Thông báo", ImageConstant.bellAlt, ImageConstant.bellAltFill),
            makeItem(PersionalViewController(), "Trang cá nhân", ImageConstant.user, ImageConstant.userfill)
        ]
    }

}

extension MainTabbarViewController: HiddenNavigationBarSupport {

}

extension MainTabbarViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let shouldHide = navigationController.viewControllers.count == 1
        if shouldHide {
            tabBar.isHidden = false
        } else {
            tabBar.isHidden = true
        }
    }
}
