//
//  MJLocalNotificationService.swift
//  MJCore
//
//  Created by Martin Janák on 04/05/2018.
//

import UserNotifications
import RxSwift

public final class MJLocalNotificationService<Notification: MJLocalNotifications> {
    
    public init() { }
    
    public func create(
        _ notification: Notification
    ) -> Observable<MJResultSimple> {
        return requestAuthorization()
            .flatMap({ result -> Observable<MJResultSimple> in
                return Observable.create { observer in
                    switch result {
                    case .success:
                        let content = UNMutableNotificationContent()
                        content.title = notification.title
                        content.body = notification.body
                        content.sound = UNNotificationSound.default
                        
                        let request = UNNotificationRequest(
                            identifier: notification.id,
                            content: content,
                            trigger: notification.trigger
                        )
                        UNUserNotificationCenter
                            .current()
                            .add(request) { error in
                                if let error = error {
                                    observer.onNext(.failure(error: error))
                                } else {
                                    observer.onNext(.success)
                                }
                                observer.onCompleted()
                            }
                    default:
                        observer.onNext(result)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            })
    }
    
    public func requestAuthorization() -> Observable<MJResultSimple> {
        return Observable.create { observer in
            UNUserNotificationCenter
                .current()
                .requestAuthorization(
                    options: [.alert, .sound, .badge],
                    completionHandler: { (granted, error) in
                        if granted {
                            observer.onNext(.success)
                        } else if let error = error {
                            observer.onNext(.failure(error: error))
                        } else {
                            observer.onNext(
                                .failure(error: MJLocalNotificationError.authNotGranted)
                            )
                        }
                        observer.onCompleted()
                    }
            )
            return Disposables.create()
        }
    }
    
    public func getPendingRequests() -> Observable<[UNNotificationRequest]> {
        return Observable.create { observer in
            UNUserNotificationCenter
                .current()
                .getPendingNotificationRequests(completionHandler: { requests in
                    observer.onNext(requests)
                    observer.onCompleted()
                })
            return Disposables.create()
        }
    }
    
    public func removeAllPendingRequests() {
        UNUserNotificationCenter
            .current()
            .removeAllPendingNotificationRequests()
    }
    
    // MARK: Error
    
    public enum MJLocalNotificationError: Error {
        case authNotGranted
    }
    
}
