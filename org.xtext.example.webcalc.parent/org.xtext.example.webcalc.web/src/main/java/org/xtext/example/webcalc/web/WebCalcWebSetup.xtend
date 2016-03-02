/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.web

import com.google.inject.Guice
import com.google.inject.Injector
import com.google.inject.Provider
import com.google.inject.util.Modules
import java.util.concurrent.ExecutorService
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.xtext.example.webcalc.WebCalcRuntimeModule
import org.xtext.example.webcalc.WebCalcStandaloneSetup

/**
 * Initialization support for running Xtext languages in web applications.
 */
@FinalFieldsConstructor
class WebCalcWebSetup extends WebCalcStandaloneSetup {
	
	val Provider<ExecutorService> executorServiceProvider;
	
	override Injector createInjector() {
		val runtimeModule = new WebCalcRuntimeModule()
		val webModule = new WebCalcWebModule(executorServiceProvider)
		return Guice.createInjector(Modules.override(runtimeModule).with(webModule))
	}
	
}
