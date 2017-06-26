//
//  AppDelegate.swift
//  Aria2D
//
//  Created by xjbeta on 16/6/28.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var window: NSWindow? {
		return NSApp.mainWindow
	}
	
    func applicationDidFinishLaunching(_ aNotification: Notification) {
		#if DEBUG
			DMKitDebugAddDevMateMenu()
		#endif
		self.setDevMate()
		Aria2Websocket.shared.initSocket()
		Baidu.shared.checkLogin(nil)
		Preferences.shared.checkPlistFile()
		Aria2.shared.aria2c.autoStart()
	}
	
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window in sender.windows {
				if window.className == "NSWindow" {
					window.className.sort()
					window.makeKeyAndOrderFront(self)
				}
            }
        }
        return true
    }
	
	func applicationWillBecomeActive(_ notification: Notification) {
		Aria2Websocket.shared.resumeTimer()
	}
	
	func applicationWillResignActive(_ notification: Notification) {
		Aria2Websocket.shared.suspendTimer()
	}
	
	func applicationWillTerminate(_ notification: Notification) {
		Aria2.shared.aria2c.autoClose()
	}
}

extension AppDelegate: DevMateKitDelegate {
	
	func setDevMate() {
		//DevMate
		DevMateKit.sendTrackingReport(nil, delegate: self)
		
		//		DevMateKit.setupIssuesController(self, reportingUnhandledIssues: true)
		
		let kevlarError = DMKevlarError.testError
		if !string_check(nil).boolValue || kevlarError != .noError {
			DevMateKit.setupTimeTrial(self, withTimeInterval: kDMTrialWeek)
		}
		NotificationCenter.default.addObserver(self, selector: #selector(activateApp), name: .activateApp, object: nil)
		
	}
	
	@objc func feedbackController(_ controller: DMFeedbackController!, parentWindowFor mode: DMFeedbackMode) -> NSWindow? {
		return self.window
	}
	
	@objc func activationController(_ controller: DMActivationController!, parentWindowFor mode: DMActivationMode) -> NSWindow? {
		return self.window
	}
	
	@objc func activationController(_ controller: DMActivationController!, shouldShowDialogFor reason: DMShowDialogReason, withAdditionalInfo additionalInfo: [AnyHashable : Any]!, proposedActivationMode ioProposedMode: UnsafeMutablePointer<DMActivationMode>!, completionHandlerSetter handlerSetter: ((DMCompletionHandler?) -> Void)!) -> Bool {
		ioProposedMode.pointee = .sheet
		handlerSetter { _ in
			ViewControllersManager.shared.showAria2cAlert()
		}
		return true
	}
	
	@objc func activateApp() {
		// Swift does't work with macros, so check our Examples project on GitHub (https://github.com/DevMate/DevMateKit)
		// to see how to create _my_secret_activation_check variable
		let kevlarError = DMKevlarError.testError
		if !string_check(nil).boolValue || kevlarError != .noError {
			DevMateKit.runActivationDialog(self, in: .sheet)
		} else if let window = self.window {
			let license = string_info()?.takeUnretainedValue()
			let licenseSheet = NSAlert()
			licenseSheet.messageText = "Your application is already activated."
			licenseSheet.informativeText = "\(license.debugDescription)"
			licenseSheet.addButton(withTitle: "OK")
			licenseSheet.addButton(withTitle: "Invalidate License")
			
			licenseSheet.beginSheetModal(for: window) {
				if $0 == .alertSecondButtonReturn {
					InvalidateAppLicense()
				}
			}
		}
	}
}
