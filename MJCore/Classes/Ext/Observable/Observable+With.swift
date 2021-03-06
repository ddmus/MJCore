//
//  Observable+With.swift
//  MJCore
//
//  Created by Martin Janák on 23/07/2018.
//

import RxSwift

extension Observable {
    
    public func with<WithElement>(
        _ observable: Observable<WithElement>
    ) -> Observable<(Element, WithElement)> {
        return self.withLatestFrom(observable) { ($0, $1) }
    }
    
    public func with<A, B>(
        _ tuple: (Observable<A>, Observable<B>)
    ) -> Observable<(Element, A, B)> {
        return self
            .withLatestFrom(tuple.0) { ($0, $1) }
            .withLatestFrom(tuple.1) { ($0.0, $0.1, $1) }
    }
    
    public func with<A, B, C>(
        _ tuple: (Observable<A>, Observable<B>, Observable<C>)
    ) -> Observable<(Element, A, B, C)> {
        return self
            .withLatestFrom(tuple.0) { ($0, $1) }
            .withLatestFrom(tuple.1) { ($0.0, $0.1, $1) }
            .withLatestFrom(tuple.2) { ($0.0, $0.1, $0.2, $1) }
    }
    
    public func with<A, B, C, D>(
        _ tuple: (Observable<A>, Observable<B>, Observable<C>, Observable<D>)
    ) -> Observable<(Element, A, B, C, D)> {
        return self
            .withLatestFrom(tuple.0) { ($0, $1) }
            .withLatestFrom(tuple.1) { ($0.0, $0.1, $1) }
            .withLatestFrom(tuple.2) { ($0.0, $0.1, $0.2, $1) }
            .withLatestFrom(tuple.3) { ($0.0, $0.1, $0.2, $0.3, $1) }
    }
    
}
