/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class WebCalcStandaloneSetup extends WebCalcStandaloneSetupGenerated {

	def static void doSetup() {
		new WebCalcStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
