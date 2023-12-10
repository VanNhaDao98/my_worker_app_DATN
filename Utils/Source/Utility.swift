//
//  Utility.swift
//  Utils
//
//  Created by Dao Van Nha on 11/11/2023.
//

import Foundation
import UIKit

public class Utility: NSObject {
    @discardableResult
    public static func call(phoneNumber: String?) -> Bool {
        guard let url = callUrl(for: phoneNumber) else { return false }
        return openUrl(url)
    }
    
    static func callUrl(for phoneNumber: String?) -> String? {
        guard let phoneNumber = phoneNumber else { return nil }
        return "tel://\(phoneNumber.keepDigitsOnly())"
    }
    
    @discardableResult
    static func openUrl(_ string: String) -> Bool {
        guard let tel = URL(string: string) else {
            return false
        }

        if UIApplication.shared.canOpenURL(tel) {
            UIApplication.shared.open(url: tel)
            return true
        }

        return false
    }
    
    public static func copyToClipboard(_ text: String?) {
        UIPasteboard.general.string = text
    }
}

import MessageUI
public class MessageUtils: NSObject, MFMailComposeViewControllerDelegate {

    public static let shared = MessageUtils()

    private weak var viewController: UIViewController?

    @discardableResult
    public func openMailComposer(address: String,
                          title: String? = nil,
                          body: String? = nil,
                          image: UIImage? = nil,
                          from viewController: UIViewController) -> Bool {

        guard MFMailComposeViewController.canSendMail() else {
            guard let url = URL(string: "mailto://\(address)") else {
                return false
            }

            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url: url)
                return true
            }

            return false
        }

        self.viewController = viewController

        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self

        if let title = title {
            mc.setSubject(title)
        }

        if let body = body {
            mc.setMessageBody(body, isHTML: false)
        }

        mc.setToRecipients([ address ])

        if let imageData = image?.jpegData(compressionQuality: 0.5) {
            mc.addAttachmentData(imageData,
                                 mimeType: "image/jpeg",
                                 fileName: "screenshot")
        }

        viewController.present(mc, animated: true, completion: nil)

        return true
    }

    public func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        viewController?.dismiss(animated: true, completion: nil)
    }

    @discardableResult
    public func openMessageApp(phoneNumber: String?) -> Bool {
        guard let phoneNumber = phoneNumber else { return false }
        return Utility.openUrl("sms://\(phoneNumber.removeAllWhitespaces())")
    }
}
private let digits = (0...9).map { Character("\($0)") }

extension String {
    func removeAllWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined(separator: "")
    }
    
    func keepDigitsOnly() -> String {
        var s = String(self)
        s.removeAll(where: { !digits.contains($0) })
        return s
    }
}

extension UIApplication {
    func open(url: URL) {
        open(url, options: [:], completionHandler: nil)
    }
}


