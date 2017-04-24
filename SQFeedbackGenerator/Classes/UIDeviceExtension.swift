//
//  UIDeviceExtension.swift
//  Pods
//
//  Created by Matteo Comisso on 24/04/2017.
//
//

import Foundation
import UIKit

public extension UIDevice {

    public func sqPlatform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }

    public var sqHasHapticFeedback: Bool {
        return ["iPhone9,1", "iPhone9,3", "iPhone9,2", "iPhone9,4"].contains(sqPlatform())
    }
}
