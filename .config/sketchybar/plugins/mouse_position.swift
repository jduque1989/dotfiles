#!/usr/bin/env swift
import Cocoa

// Get current mouse location
let mouseLocation = NSEvent.mouseLocation

// Get main screen
guard let screen = NSScreen.main else {
    print("999")
    exit(1)
}

let screenHeight = screen.frame.height
let fromTop = Int(screenHeight - mouseLocation.y)
print(fromTop)
