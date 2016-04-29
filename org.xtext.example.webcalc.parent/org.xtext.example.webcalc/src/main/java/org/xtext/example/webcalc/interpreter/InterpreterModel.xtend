/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.interpreter

import java.util.Map
import org.eclipse.xtend.lib.annotations.Accessors
import org.xtext.example.webcalc.webCalc.Variable

@Accessors
class InterpreterModel {
	
	val Map<Variable, Double> variables = newHashMap
	
	Double result
	
}