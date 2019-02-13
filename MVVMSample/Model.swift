//
//  Model.swift
//  MVVMSample
//
//  Created by beakhand on 2019/02/13.
//  Copyright © 2019 beakhand. All rights reserved.
//

import Foundation
import RxSwift

enum ModelError: Error {
    case invalidId
    case invalidPassword
    case invalidIdAndPassword
}

protocol ModelProtocol {
    func validate(idText: String?, passWordText: String?) -> Observable<Void>
}

final class Model: ModelProtocol {
    func validate(idText: String?, passWordText: String?) -> Observable<Void> {
        switch (idText, passWordText) {
        case (.none, .none):
            return Observable.error(ModelError.invalidIdAndPassword)
        case (.none, .some):
            return Observable.error(ModelError.invalidId)
        case (.some, .none):
            return Observable.error(ModelError.invalidPassword)
        case (let idText?, let passWordText?):
            switch (idText.isEmpty, passWordText.isEmpty) {
            case (true, true):
                return Observable.error(ModelError.invalidIdAndPassword)
            case (false, false):
                return Observable.just(())
            case (true, false):
                return Observable.error(ModelError.invalidId)
            case (false, true):
                return Observable.error(ModelError.invalidPassword)
                
            }
        }
    }
}
