//
//  DefaultPanelLayout.swift
//  UIComponents
//
//  Created by Dao Van Nha on 15/10/2023.
//

import Foundation
import UIKit
import FloatingPanel

class DefaultPanelLayout: FloatingPanelBottomLayout {
    
    private let supportedSizes: [BottomSheetConfig.Size]
    private var supportFull: Bool = false
    
    init(supportedSizes: [BottomSheetConfig.Size]) {
        self.supportedSizes = supportedSizes
        self.supportFull = supportedSizes.contains(.full)
    }
    
    func forceAllowFull(_ allow: Bool) {
        supportFull = allow ? true : supportedSizes.contains(.full)
    }
    
    override var initialState: FloatingPanelState {
        if supportedSizes.contains(.intrinsic) {
            return .full
        }
        
        if anchors.keys.contains(.half) {
            return .half
        }
        
        return anchors.keys.first ?? .half
    }
    
    override var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        if supportedSizes.contains(.intrinsic) {
            if supportFull {
                return [
                    .half: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0.0, referenceGuide: .superview),
                    .full: FloatingPanelLayoutAnchor(absoluteInset: 8.0, edge: .top, referenceGuide: .superview)
                ]
            }
            
            return [.full: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0.0, referenceGuide: .superview)]
        }
        
        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [:]
        for size in supportedSizes {
            switch size {
            case .tip:
                anchors[.tip] = FloatingPanelLayoutAnchor(absoluteInset: 80.0, edge: .bottom, referenceGuide: .safeArea)
            case .medium:
                anchors[.half] = FloatingPanelLayoutAnchor(absoluteInset: 420.0, edge: .bottom, referenceGuide: .safeArea)
            case .full:
                anchors[.full] = FloatingPanelLayoutAnchor(absoluteInset: 8.0, edge: .top, referenceGuide: .safeArea)
            case .fixed(let height):
                anchors[.half] = FloatingPanelLayoutAnchor(absoluteInset: height, edge: .bottom, referenceGuide: .safeArea)
            case .intrinsic:
                anchors[.full] = FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0.0, referenceGuide: .safeArea)
            }
        }
        
        if supportFull {
            anchors[.full] = FloatingPanelLayoutAnchor(absoluteInset: 8.0, edge: .top, referenceGuide: .safeArea)
        }
        
        return anchors
    }
    
    override func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        switch state {
        case .half:
            return 0.6
        case .full:
            return 0.7
        default:
            return 0.0
        }
    }
}
