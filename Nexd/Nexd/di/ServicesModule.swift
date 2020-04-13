//
//  ServicesModule.swift
//  nexd
//
//  Created by Tobias Schröpf on 09.04.20.
//  Copyright © 2020 Tobias Schröpf. All rights reserved.
//

import Cleanse

struct ServicesModule: Module {
    static func configure(binder: Binder<Singleton>) {
        binder
            .bind(AuthenticationService.self)
            .to(factory: AuthenticationService.init)

        binder
            .bind(ArticlesService.self)
            .to(factory: ArticlesService.init)

        binder
            .bind(HelpRequestsService.self)
            .to(factory: HelpRequestsService.init)

        binder
            .bind(UserService.self)
            .to(factory: UserService.init)

        binder
            .bind(HelpListsService.self)
            .to(factory: HelpListsService.init)

        binder
            .bind(CallsService.self)
            .to(factory: CallsService.init)
    }
}
