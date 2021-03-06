//
//  DownloadUrlTextField.swift
//  Aria2D
//
//  Created by xjbeta on 2016/9/30.
//  Copyright © 2016年 xjbeta. All rights reserved.
//

import Cocoa

class DownloadUrlTextField: NSTextField {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
	
	var button: NSButton = {
		let button = NSButton(frame: NSRect(x: 25, y: 20, width: 132, height: 20))
		button.bezelStyle = .roundRect
		button.title = "magnet:?xt=urn:btih:"
		button.action = #selector(changeStringValue)
		return button
	}()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	override func textDidChange(_ notification: Notification) {
		if stringValue == "ma" {
			self.addSubview(button)
		} else {
			hideButton()
		}
	}
	
	@objc func changeStringValue() {
		stringValue = "magnet:?xt=urn:btih:"
		currentEditor()?.moveToEndOfLine(self)
		hideButton()
	}
	
	func hideButton() {
		subviews.forEach {
			if $0 is NSButton, let i = subviews.firstIndex(of: $0) {
				subviews.remove(at: i)
			}
		}
	}

}
