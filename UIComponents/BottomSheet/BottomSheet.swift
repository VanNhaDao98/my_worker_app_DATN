//
//  BottomSheet.swift
//  UIComponents
//
//  Created by Dao Van Nha on 13/10/2023.
//

import UIKit
import Utils

public protocol BottomSheetContentView: UIView {
    var innerScrollView: UIScrollView? { get }
}

public class BottomSheet: UIViewController {
    
    static var defaultTitleHeight: CGFloat {
        56.0
    }
    
    private var stackView: UIStackView = .init()
    private var titleView: UIView = .init()
    private var titleLabel: UILabel = .init()
    private var dismissButton: AppBaseButton = .init(type: .custom)
    private var actionButton: Button = .init(type: .custom)
    
    private(set) var contentView: BottomSheetContentView?
    
    var sheetScrollView: UIScrollView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().priority(.init(999))
        }
        
        stackView.addArrangedSubview(titleView)
        titleView.addSubview(titleLabel)
        titleView.addSubview(dismissButton)
        titleView.addSubview(actionButton)
        
        let separator = UIView()
        separator.backgroundColor = ColorConstant.ink05
        titleView.addSubview(separator)
        
        titleLabel.font = Fonts.semiboldFont(ofSize: .alertButton)
        titleLabel.textColor = ColorConstant.text
        titleLabel.textAlignment = .left

        let titleHeight: CGFloat = BottomSheet.defaultTitleHeight
        
        actionButton.isHidden = true
        actionButton.config.style = .plain
        actionButton.spacing = 0
        actionButton.labelFont = Fonts.mediumFont(ofSize: .default)
        
        dismissButton.setImage(ImageConstant.icClose, for: .normal)
        dismissButton.corner(radius: 16)
        dismissButton.action = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
                .inset(titleLabel.textAlignment == .center ? titleHeight : 16.0)
                .priority(999)
        }
        dismissButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(titleHeight)
        }
        actionButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
        }
        separator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        titleView.snp.makeConstraints {
            $0.height.equalTo(titleHeight)
        }
    }
    
    public func setContentView(_ contentView: BottomSheetContentView,
                               handleKeyboard: Bool = false) {
        loadViewIfNeeded()
        
        self.contentView = contentView
        
        stackView.arrangedSubviews
            .filter { $0 !== titleView }
            .forEach { $0.removeFromSuperview() }
        stackView.addArrangedSubview(contentView)
        
        if handleKeyboard {
            let avoidingView = KeyboardAvoidingView()
            avoidingView.topMargin = 16.0
            stackView.addArrangedSubview(avoidingView)
        }

        sheetScrollView = contentView.innerScrollView
    }
}

public extension BottomSheet {
    override var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var showTitle: Bool {
        get { !titleView.isHidden }
        set { titleView.isHidden = !newValue }
    }
    
    var showCloseButton: Bool {
        get { !dismissButton.isHidden }
        set {
            dismissButton.isHidden = !newValue
            if newValue {
                actionButton.isHidden = true
            }
        }
    }
    
    func configAction(_ config: (Button) -> Void) {
        actionButton.isHidden = false
        dismissButton.isHidden = true
        
        config(actionButton)
    }
}

public struct BottomSheetConfig {
    public enum Size: Equatable {
        case tip
        case medium
        case full
        case fixed(CGFloat)
        case intrinsic
        
        private var rawValueForCompare: AnyHashable {
            switch self {
            case .tip:
                return "tip"
            case .medium:
                return "medium"
            case .full:
                return "full"
            case .intrinsic:
                return "intrinsic"
            case .fixed(let value):
                return value
            }
        }
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.rawValueForCompare == rhs.rawValueForCompare
        }
    }
    
    public enum KeyboardHandlingMode {
        case disabled // do not handle keyboard
        case moveToFull // move BottomSheet to fullscreen mode
        case updateHeight // increase height of BottomSheet
    }
    
    public struct Action {
        public var title: String?
        public var image: UIImage?
        public var action: () -> Void
        
        public init(title: String?, image: UIImage?, action: @escaping () -> Void) {
            self.title = title
            self.image = image
            self.action = action
        }
    }
    
    public var title: String?
    public var showCloseButton: Bool = true
    public var titleAction: Action?
    public var dismissable: Bool = true
    public var keyboardHandlingMode: KeyboardHandlingMode = .moveToFull
    public var sizes: [Size] = [.medium]
    
    public init(title: String? = nil,
         showCloseButton: Bool = true,
         dismissable: Bool = true,
         keyboardHandlingMode: KeyboardHandlingMode = .moveToFull,
         sizes: [Size] = [.medium]) {
        self.title = title
        self.showCloseButton = showCloseButton
        self.dismissable = dismissable
        self.keyboardHandlingMode = keyboardHandlingMode
        self.sizes = sizes
    }
    
    public static var `default`: BottomSheetConfig {
        .init()
    }
}

extension BottomSheetConfig: Then {}

extension BottomSheetConfig.Size {
    public static func forItems(count: Int,
                                withTitle: Bool = true,
                                customRowHeight: CGFloat? = nil) -> Self {
        let itemsHeight = CGFloat(count) * (customRowHeight ?? 1)
        let titleHeight = withTitle ? BottomSheet.defaultTitleHeight : 0.0
        return .fixed(itemsHeight + titleHeight)
    }
}
