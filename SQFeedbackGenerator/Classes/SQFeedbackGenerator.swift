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

public typealias SQCompletionBlock = () -> Void

public final class SQFeedbackGenerator {

    /// Fallback for unsupported devices, magic numbers
    final class SQHaptic {
        enum LegacyHapticFeedbackIntensity: UInt32 {
            case weak   = 1519
            case strong = 1520
            case error  = 1521
        }

        static func generateFeedback(intensity: LegacyHapticFeedbackIntensity) {
            if UIDevice.current.sqHasHapticFeedback, #available(iOS 10.0, *) {
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

    fileprivate func generateSuccessFeedback(_ completion: SQCompletionBlock?) {
        defer { SQHaptic.generateFeedback(intensity: .weak) }
        guard let completion = completion else { return }
        completion()
    }

    fileprivate func generateErrorFeedback(_ completion: SQCompletionBlock?) {
        defer { SQHaptic.generateFeedback(intensity: .error) }
        guard let completion = completion else { return }
        completion()
    }

    fileprivate func generateNotificationFeedback(_ completion: SQCompletionBlock?) {
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
    public func generateFeedback(type: SQFeedbackType, completion: SQCompletionBlock? = nil) {
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
