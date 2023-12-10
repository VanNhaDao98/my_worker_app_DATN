//
//  LoadingWindow.swift
//  UIComponents
//
//  Created by Dao Van Nha on 13/10/2023.
//

import UIKit
import Utils

public class LoadingWindow: BaseWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var backgroundView = UIView()
    private let containerView = UIView()
    private var indicatorView = UIActivityIndicatorView(style: .large)
    private var messageLabel = UILabel()
    private var percentLayer: CAShapeLayer = .init()
    
    var message: String? {
        didSet {
            messageLabel.text = message
            messageLabel.isHidden = String.isBlank(message)
        }
    }
    
    var percent: CGFloat? {
        didSet {
            percentLayer.strokeEnd = percent ?? 0
            percentLayer.isHidden = percent == nil
            indicatorView.isHidden = percent != nil
        }
    }
    
    public override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        percentLayer.path = UIBezierPath(arcCenter: .init(x: containerView.bounds.width / 2,
                                                          y: containerView.bounds.height / 2),
                                         radius: containerView.bounds.height / 2 - 12,
                                         startAngle: 0,
                                         endAngle: .pi * 2,
                                         clockwise: true).cgPath
    }
    
    private func setup() {
        addSubview(backgroundView)
        backgroundView.backgroundColor = .init(white: 0, alpha: 0.6)
        backgroundView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        containerView.squircle(radius: 20)
        containerView.backgroundColor = .init(white: 0.96, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [indicatorView, messageLabel])
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.alignment = .center
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints({ $0.edges.equalToSuperview().inset(16) })
        
        addSubview(containerView)
        containerView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.greaterThanOrEqualTo(80)
        })
        
        indicatorView.snp.makeConstraints({ $0.width.height.equalTo(48) })
        
        indicatorView.startAnimating()
        
        messageLabel.font = Fonts.mediumFont(ofSize: .default)
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true
        messageLabel.textAlignment = .center
        messageLabel.textColor = ColorConstant.text
        
        percentLayer.strokeColor = ColorConstant.primary.cgColor
        percentLayer.strokeStart = 0
        percentLayer.strokeEnd = 0
        percentLayer.lineWidth = 3
        percentLayer.lineCap = .round
        percentLayer.fillColor = UIColor.clear.cgColor
        percentLayer.isHidden = true
        
        containerView.layer.addSublayer(percentLayer)
    }
    
}

extension LoadingWindow {
    
    private static var current: LoadingWindow?
    // use weak to not retain this instance
    // so other custom UIWindow can deallocate itself
    private static weak var prevWindow: UIWindow?
    
    private static let minShowDuration: UInt64 = 200 // ms
    private static var shownTime: DispatchTime?
    
    public static func show(message: String? = nil, percent: CGFloat? = nil) {
        if let current {
            current.message = message
            current.percent = percent
            return
        }
        
        prevWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let view = LoadingWindow(frame: .init(x: 0, y: 0, width: 100, height: 100))
        view.message = message
        view.percent = percent
        view.makeKeyAndVisible()
        view.windowLevel = UIWindow.Level.alert + 1
        view.backgroundView.animateFadeIn(duration: 0.15)
        view.indicatorView.transform = .init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
            view.indicatorView.transform = .identity
        } completion: { _ in
            
        }
        
        shownTime = .now()
        current?.isHidden = false
    }
    
    public static func hide() {
        if current == nil {
            return
        }
        
        func _hide() {
            UIView.animate(withDuration: 0.2) { [self] in
                current?.alpha = 0
                current?.indicatorView.transform = .init(scaleX: 0.1, y: 0.1)
            } completion: { [self] _ in
                current?.removeFromSuperview()
                current = nil
                prevWindow?.makeKeyAndVisible()
            }
        }
        
        guard let time = shownTime else {
            _hide()
            return
        }
        
        let diff = (DispatchTime.now().uptimeNanoseconds - time.uptimeNanoseconds) / 1_000_000
        let minDuration: UInt64 = LoadingWindow.minShowDuration
        
        if diff > minDuration {
            _hide()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(minDuration - diff))) {
                _hide()
            }
        }
    }
    
    public static var isShowing: Bool {
        get { current?.superview != nil }
        set { newValue ? show() : hide() }
    }
}


//open class LoadingWindow: BaseWindow {
//
//    private var backgroundView = UIView()
//    private var containerView = UIView()
//    private var indicatorView = UIActivityIndicatorView(style: .medium)
//    private var messageLabel = UILabel()
//    private var percentLayer = CAShapeLayer()
//
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required public init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    var message: String? {
//        didSet {
//            messageLabel.text = message
//            messageLabel.isHidden = String.isBlank(message)
//        }
//    }
//
//    var percent: CGFloat? {
//        didSet {
//            percentLayer.strokeEnd = percent ?? 0
//            percentLayer.isHidden = percent == nil
//            indicatorView.isHidden = percent != nil
//        }
//    }
//
//    public override func layoutSublayers(of layer: CALayer) {
//        super.layoutSublayers(of: layer)
//
//        percentLayer.path = UIBezierPath(arcCenter: .init(x: containerView.bounds.width / 2,
//                                                          y: containerView.bounds.height / 2),
//                                         radius: containerView.bounds.height / 2 - 12,
//                                         startAngle: 0,
//                                         endAngle: .pi * 2,
//                                         clockwise: true).cgPath
//    }
//
//    private func setupView() {
//        addSubview(backgroundView)
//        backgroundView.backgroundColor = .init(white: 0, alpha: 0.6)
//        backgroundView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        containerView.squircle(radius: 20)
//        containerView.backgroundColor = .init(white: 0.96, alpha: 1)
//
//        let stackView = UIStackView(arrangedSubviews: [indicatorView, messageLabel])
//        stackView.axis = .vertical
//        stackView.spacing = 4
//        stackView.alignment = .center
//
//        containerView.addSubview(stackView)
//        stackView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(16)
//        }
//
//        addSubview(containerView)
//        containerView.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.height.greaterThanOrEqualTo(80)
//        }
//
//        indicatorView.snp.makeConstraints({ $0.width.height.equalTo(48) })
//        indicatorView.startAnimating()
//
//        messageLabel.font = Fonts.mediumFont(ofSize: .default)
//        messageLabel.numberOfLines = 0
//        messageLabel.isHidden = true
//        messageLabel.textAlignment = .center
//        messageLabel.textColor = ColorConstant.text
//
//        percentLayer.strokeColor = ColorConstant.primary.cgColor
//        percentLayer.strokeStart = 0
//        percentLayer.strokeEnd = 0
//        percentLayer.lineWidth = 3
//        percentLayer.lineCap = .round
//        percentLayer.fillColor = UIColor.clear.cgColor
//        percentLayer.isHidden = true
//
//        containerView.layer.addSublayer(percentLayer)
//
//    }
//
//}
//
//public extension LoadingWindow {
//    private static var current: LoadingWindow?
//    private static weak var prevWinDow: UIWindow?
//
//    private static let minShowDuration: UInt64 = 200 // ms
//    private static var shownTime: DispatchTime?
//
//    static func show(massage: String? = nil, percent: CGFloat? = nil) {
//        if let current {
//            current.message = massage
//            current.percent = percent
//            return
//        }
//
//        prevWinDow = UIApplication
//            .shared
//            .connectedScenes
//            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
//            .last { $0.isKeyWindow }
//        prevWinDow?.resignKey()
//
//        let view = LoadingWindow(frame: UIScreen.main.bounds)
//        view.windowLevel = UIWindow.Level.alert
//        view.makeKeyAndVisible()
//        view.backgroundView.animateFadeIn(duration: 0.15)
//        view.indicatorView.transform = .init(scaleX: 0.1, y: 0.1)
//        view.rootViewController = UIViewController()
//        view.rootViewController?.view.backgroundColor = .black
//        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut) {
//            view.indicatorView.transform = .identity
//        } completion: { _ in
//
//        }
//
//        shownTime = .now()
//        current = view
//    }
//}
