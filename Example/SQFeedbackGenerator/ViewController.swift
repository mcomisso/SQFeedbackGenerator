//
//  ViewController.swift
//  SQFeedbackGenerator
//
//  Created by mcomisso on 04/24/2017.
//  Copyright (c) 2017 mcomisso. All rights reserved.
//

import UIKit
import SQFeedbackGenerator

class ViewController: UIViewController {

    let generator = SQFeedbackGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let successButton = UIButton(type: .custom)
        successButton.setTitle("Success button", for: .normal)
        successButton.backgroundColor = .green
        successButton.tag = 100

        let notificationButton = UIButton(type: .custom)
        notificationButton.setTitle("Notification button", for: .normal)
        notificationButton.backgroundColor = .blue
        notificationButton.tag = 200

        let errorButton = UIButton(type: .custom)
        errorButton.setTitle("Error button", for: .normal)
        errorButton.backgroundColor = .red
        errorButton.tag = 300

        let completionButton = UIButton(type: .custom)
        completionButton.setTitle("Completion button", for: .normal)
        completionButton.backgroundColor = .purple
        completionButton.tag = 400

        let buttons = [successButton, notificationButton, errorButton, completionButton]
        buttons.forEach {
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            $0.setTitleColor(.white, for: .normal)
            $0.addTarget(self, action: #selector(didPressButton(_:)), for: .touchUpInside)
        }

        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally

        self.view.addSubview(stackView)

        NSLayoutConstraint.activate([stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                     stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
    }
}

fileprivate typealias ButtonsActions = ViewController
extension ButtonsActions {
    func didPressButton(_ sender: Any?) {
        guard let sender = sender as? UIButton else { return }

        switch sender.tag {

        case 100:
            self.generator.generateFeedback(type: .success)

        case 200:
            self.generator.generateFeedback(type: .notification)

        case 300:
            self.generator.generateFeedback(type: .error)

        case 400:
            self.generator.generateFeedback(type: .error, completion: { 
                // Show an error
                let alert = UIAlertController(title: "Ooops", message: "Called from completion", preferredStyle: .alert)

                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)

                self.present(alert, animated: true, completion: nil)
            })

        default:
            fatalError("Not a button tag")
        }
    }
}
