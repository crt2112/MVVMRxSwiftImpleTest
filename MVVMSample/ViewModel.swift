//
//  ViewModel.swift
//  MVVMSample
//
//  Created by beakhand on 2019/02/13.
//  Copyright © 2019 beakhand. All rights reserved.
//

import Foundation
import RxSwift

final class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>
    
    init(idTextObservable: Observable<String?>, passWordTextObservable: Observable<String?>, model: ModelProtocol) {
        let event = Observable.combineLatest(idTextObservable, passWordTextObservable)
        .skip(1)
        .flatMap { idText, passWordText -> Observable<Event<Void>> in
            return model.validate(idText: idText, passWordText: passWordText).materialize()
        }.share()
        
        self.validationText = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next:
                    return .just("OK!")
                case let .error(error as ModelError):
                    return .just(error.errorText)
                case .error, .completed:
                    return .empty()
                }
                
        }
        .startWith("ID と Password を入力してください。")
        
        self.loadLabelColor = event
            .flatMap { event -> Observable<UIColor> in
                switch event {
                case .next:
                    return .just(.green)
                case .error:
                    return .just(.red)
                case .completed:
                    return .empty()
                }
                
        }
    }
}

extension ModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidIdAndPassword:
            return "ID と Password  が未入力です。"
        case .invalidId:
            return "ID が未入力です。"
        case .invalidPassword:
            return "Password が未入力です。"
        }
    }
}
