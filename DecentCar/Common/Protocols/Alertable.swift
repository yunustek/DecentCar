//
//  Alertable.swift
//  DecentCar
//
//  Created by Yunus Tek on 31.01.2023.
//

import UIKit

protocol Alertable {}

extension Alertable where Self: UIViewController {

    /// Alert with Yes and No button
    /// - Parameters:
    ///   - titleMessage: alert tile message
    ///   - bodyMessage: alert body message
    ///   - yesTitle: alert Yes button title
    ///   - noTitle: alert No button title
    ///   - yes: Yes button tap closue
    ///   - no: No button tap closue
    func showQuestion(_ titleMessage: String?,
                      bodyMessage: String?,
                      yesTitle: String? = nil,
                      noTitle: String? = nil,
                      yes: (() -> Void)?,
                      no: (() -> Void)?) {

        alert(titleMessage, bodyMessage: bodyMessage, yesTitle: yesTitle, noTitle: noTitle, yes: {
            yes?()
        }) {
            no?()
        }
    }

    /// Alert with Ok button
    /// - Parameters:
    ///   - titleMessage: alert tile message
    ///   - bodyMessage: alert body message
    ///   - okTitle: alert ok button title
    ///   - ok: ok button tap closue
    func showConfirm(_ titleMessage: String,
                     bodyMessage: String,
                     okTitle: String? = nil,
                     ok: (() -> Void)? = nil) {

        alert(titleMessage, bodyMessage: bodyMessage, okTitle: okTitle, ok: ok)
    }

    func showActionSheet(_ titleMessage: String? = nil,
                         bodyMessage: String? = nil,
                         contentView: UIView? = nil,
                         yesTitle: String? = nil,
                         noTitle: String? = nil,
                         yes: (() -> Void)?,
                         no: (() -> Void)?,
                         cancel: (() -> Void)?) {

        actionSheet(titleMessage, bodyMessage: bodyMessage, yesTitle: yesTitle, noTitle: noTitle, yes: yes, no: no, cancel: cancel)
    }

    // MARK: Privates

    private func presentToCurrenVC(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {

        DispatchQueue.main.async { [weak self] in

            self?.present(viewControllerToPresent, animated: animated, completion: completion)
        }
    }

    /// Action Sheet with cancel action
    private func actionSheet(_ titleMessage: String?,
                             bodyMessage: String?,
                             yesTitle: String? = nil,
                             noTitle: String? = nil,
                             yes: (() -> Void)? = nil,
                             no: (() -> Void)? = nil,
                             cancel: (() -> Void)? = nil) {

        let optionMenu = UIAlertController(title: titleMessage, message: bodyMessage, preferredStyle: .actionSheet)

        let yesAction = UIAlertAction(title: yesTitle ?? "Yes", style: .default, handler: { _ in

            yes?()
        })
        optionMenu.addAction(yesAction)

        let noAction = UIAlertAction(title: noTitle ?? "No", style: .default, handler: { _ in

            no?()
        })
        optionMenu.addAction(noAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

            cancel?()
        })
        optionMenu.addAction(cancelAction)

        presentToCurrenVC(optionMenu, animated: true)
    }

    /// Yes/No button alert
    private func alert(_ titleMessage: String?, bodyMessage: String?, yesTitle: String? = nil, noTitle: String? = nil, yes: (() -> Void)? = nil, no: (() -> Void)? = nil) {

        let alertController = UIAlertController(title: titleMessage, message: bodyMessage, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: noTitle ?? "No", style: .cancel , handler: {(action: UIAlertAction!) in
            no?()
        }))

        alertController.addAction(UIAlertAction(title: yesTitle ?? "Yes", style: .default , handler: { (action: UIAlertAction!) in
            yes?()
        }))

        presentToCurrenVC(alertController, animated: true)
    }

    /// Ok button alert
    private func alert(_ titleMessage: String, bodyMessage: String, okTitle: String? = nil, ok: (() -> Void)? = nil) {

        let alertController = UIAlertController(title: titleMessage, message: bodyMessage, preferredStyle: .alert)

        let buttonTitle = okTitle ?? "Ok"
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action: UIAlertAction!) in
            ok?()
        }))

        presentToCurrenVC(alertController, animated: true)
    }
}
