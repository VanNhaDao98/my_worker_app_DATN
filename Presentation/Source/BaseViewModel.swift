//
//  BaseViewModel.swift
//  Presentation
//
//  Created by Dao Van Nha on 09/10/2023.
//

import Foundation
import UIKit
import Utils

public protocol ViewModel {
    associatedtype Input
    associatedtype Output: VMOutPut
    
    var output: Output { get }
    func send(_ input: Input )
}

public protocol VMOutPut {
    func hideLoading()
    func showLoading(message: String, view: UIView)
}

extension VMOutPut {
    public func hideLoading() {
        Loading.shared.hideLoading()
    }
    
    public func showLoading(message: String, view: UIView) {
        Loading.shared.showLoading(view: view, text: message)
    }
}

open class BaseViewModel<Input, Output: VMOutPut>: NSObject, ViewModel {
    public typealias Input = Input
    public typealias Output = Output
    
    private var _output: Output!
    
    public var output: Output {
        return _output
    }
    
    public override init() {
        
    }
    
    public func send(_ input: Input) {
        handle(input)
    }
    
    open func handle(_ input: Input) {
        
    }
    
    public func config(_ output: Output) {
        self._output = output
    }
}

public protocol MVVMViewControllerCongigurable {
    func config()
}

public protocol MVVMViewController: UIViewController, MVVMViewControllerCongigurable {
    
    associatedtype VM: ViewModel
    
    var viewModel: VM { get }
    
    func setupView()
    func bind(viewModel: VM)
}

extension MVVMViewController {
   
    public func config() {
        setupView()
        bind(viewModel: viewModel)
    }
}
