//
//  SQFeedbackGenerator.swift
//  Cryptospace
//
//  Created by Matteo Comisso on 24/04/2017.
//  Copyright © 2017 mcomisso. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit

public typealias SQNotificationCompletionBlock = () -> Void

public final class SQFeedbackGenerator {

    /// Fallback for unsupported devices, magic numbers
    final class SQHaptic {

        /// These are sounds code for triggering a haptic feedback on iPhone 6S generation.
        ///
        /// - weak: single weak
        /// - strong: single strong
        /// - error: three consecutive strong
        enum LegacyHapticFeedbackIntensity: UInt32 {
            case weak   = 1519
            case strong = 1520
            case error  = 1521
        }

        static func generateFeedback(intensity: LegacyHapticFeedbackIntensity) {

            if UIDevice.current.hasHapticFeedback, #available(iOS 10.0, *) {
                let notificationGenerator = UINotificationFeedbackGenerator()
                notificationGenerator.prepare()

                switch intensity {
                case .error:
                    notificationGenerator.notificationOccurred(.error)
                case .strong:
                    notificationGenerator.notificationOccurred(.warning)
                case .weak:
                    notificationGenerator.notificationOccurred(.success)
                }
            } else {
                AudioServicesPlaySystemSound(intensity.rawValue)
            }
        }
    }


    /// Feedback types
    ///
    /// - notification: Notification declares a light feedback, with default theme (accent colors) and weak feedback
    /// - error: Error declares a triple haptic feedback, with red color as whistle
    public enum SQFeedbackType {
        case notification
        case error
        case success
    }

    public init() { }

    fileprivate func generateSuccessFeedback(_ completion: SQNotificationCompletionBlock?) {
        defer { SQHaptic.generateFeedback(intensity: .weak) }
        guard let completion = completion else { return }
        completion()
    }

    fileprivate func generateErrorFeedback(_ completion: SQNotificationCompletionBlock?) {
        defer { SQHaptic.generateFeedback(intensity: .error) }
        guard let completion = completion else { return }
        completion()
    }

    fileprivate func generateNotificationFeedback(_ completion: SQNotificationCompletionBlock?) {
        defer { SQHaptic.generateFeedback(intensity: .weak) }
        guard let completion = completion else { return }
        completion()
    }
}

extension SQFeedbackGenerator {

    /// Generates a feedback for the selected feedback type
    ///
    /// - Parameters:
    ///   - type: Type can be .notification, .error, .success
    ///   - completion: Optional completion block to execute
    public func generateFeedback(type: SQFeedbackType, completion: SQNotificationCompletionBlock? = nil) {
        switch type {
        case .success:
            self.generateSuccessFeedback(completion)
        case .error:
            self.generateErrorFeedback(completion)
        case .notification:
            self.generateNotificationFeedback(completion)
        }
    }
    
}
