//
//  Assembler.swift
//  RestImageRender
//
//  Copyright © 2020 Ranjan-iOS. All rights reserved.
//

import Foundation
import Swinject

// Assembler
extension Assembler {

	static let sharedAssembler: Assembler = {
		let container = Container()
		let assembler = Assembler([
			CoordinatorAssembly(), // all coordinator assembly
			ViewModelAssembly(), // all view model assembly
			ServiceAssembly(), // all service related assembly
			ViewControllerAssembly(), // all view controller realted assembly
			UtilityAssembly(),
			RepositoryAssembly(),
			LoggerAssembly(),
		], container: container)

		return assembler
	} ()
}

// Returns resolver for dependency injection
let AppResolver = Assembler.sharedAssembler.resolver
