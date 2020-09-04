////
////  AudioKitMicStreamer.swift
////  YToke
////
////  Created by Lyt on 9/3/20.
////  Copyright © 2020 TestOrganization. All rights reserved.
////
//
//import Foundation
//
//final class AudioKitMicStreamer: MicStreamer {
//    
//    var volume: Float {
//        get {
//            //Float(mic?.volume ?? 0)
//            30
//        }
//        set {
//            //mic?.volume = Double(volume)
//        }
//    }
//    
//    var isEnabled: Bool {
//        false //mic?.isStarted ?? false
//    }
//    
//    let mic = AKMicrophone()
//    
//    init() {
//        AKSettings.audioInputEnabled = true
//        mic?.start()
//        AudioKit.output = mic
//        try? AudioKit.start()
//    }
//    
//    func startStreaming(with device: AudioDevice) throws {
//        //try mic?.setDevice(AKDevice(name: device.uid, deviceID: device.id))
//        
//    }
//    
//    func stopStreaming() {
//        do {
//            try AudioKit.stop()
//        } catch {
//            print(error)
//        }
//    }
//    
//}
