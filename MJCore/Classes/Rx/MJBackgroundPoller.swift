//
//  MJPoller.swift
//  MJCore
//
//  Created by Martin Janák on 24/05/2018.
//

import RxSwift
import RxCocoa

public final class MJBackgroundPoller {
    
    private let tickRelay = PublishRelay<MJResult<Double>>()
    public lazy var tick = tickRelay.asObservable()
    
    private let queue = DispatchQueue(
        label: "Poller",
        qos: .background
    )
    
    private var timer: Timer?
    private let interval: Double
    private var seconds: Double = 0
    private let timeout: Double?
    
    public init(interval: Double, timeout: Double? = nil) {
        self.interval = interval
        self.timeout = timeout
    }
    
    public func start() {
        queue.async {
            self.stopSync()
            self.timer = Timer(
                timeInterval: self.interval,
                target: self,
                selector: #selector(self.tickHandler),
                userInfo: nil,
                repeats: true
            )
            RunLoop.current.add(
                self.timer!,
                forMode: RunLoop.Mode.default
            )
            RunLoop.current.run()
        }
    }
    
    public func stop() {
        queue.async {
            self.stopSync()
        }
    }
    
    private func stopSync() {
        timer?.invalidate()
        timer = nil
        seconds = 0
    }
    
    @objc
    private func tickHandler() {
        if let timeout = timeout, timeout <= seconds {
            tickRelay.accept(.failure(error: MJPollerError.timeout))
            stopSync()
        } else {
            tickRelay.accept(.success(value: seconds))
            seconds = seconds + interval
        }
    }
    
    deinit {
        stopSync()
    }
    
}
