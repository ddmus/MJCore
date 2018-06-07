//
//  Observable+Failure.swift
//  MJCore
//
//  Created by Martin Janák on 21/05/2018.
//

import RxSwift

extension Observable {
    
    public func onFailure<V>(
        _ handler: @escaping (Error) -> Void
    ) -> Observable<MJResult<V>> where Element == MJResult<V> {
        return self.map({ response in
            switch response {
            case .success:
                break
            case .failure(let error):
                handler(error)
            }
            return response
        })
    }
    
    public func onFailureAwait<V>(
        _ handler: @escaping (Error) -> Observable<MJResultSimple>
    ) -> Observable<MJResult<V>> where Element == MJResult<V> {
        return self.flatMap({ (response: MJResult<V>) -> Observable<MJResult<V>> in
            switch response {
            case .success:
                return .just(response)
            case .failure(let error):
                return handler(error)
                    .map { _ in response }
            }
        })
    }
    
    public func bindFailure<V>(
        _ handler: @escaping (Error) -> Void
    ) -> Disposable where Element == MJResult<V> {
        return self.bind(onNext: { result in
            if case .failure(let error) = result {
                handler(error)
            }
        })
    }
    
}

extension Observable where Element == MJResultSimple {
    
    public func onFailure(
        _ handler: @escaping (Error) -> Void
    ) -> Observable<MJResultSimple>  {
        return self.map({ response in
            switch response {
            case .success:
                break
            case .failure(let error):
                handler(error)
            }
            return response
        })
    }
    
    public func onFailureAwait(
        _ handler: @escaping (Error) -> Observable<MJResultSimple>
    ) -> Observable<MJResultSimple> {
        return self.flatMap({ (response: MJResultSimple) -> Observable<MJResultSimple> in
            switch response {
            case .success:
                return .just(response)
            case .failure(let error):
                return handler(error)
                    .map { _ in response }
            }
        })
    }
    
    public func bindFailure(
        _ handler: @escaping (Error) -> Void
    ) -> Disposable {
        return self.bind(onNext: { result in
            if case .failure(let error) = result {
                handler(error)
            }
        })
    }
    
}
