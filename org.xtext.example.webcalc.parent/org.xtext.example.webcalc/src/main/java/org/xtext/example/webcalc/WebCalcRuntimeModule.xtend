/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc

import org.xtext.example.webcalc.values.WebCalcValueConverterService

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class WebCalcRuntimeModule extends AbstractWebCalcRuntimeModule {
	
	override bindIValueConverterService() {
		WebCalcValueConverterService
	}
	
}
