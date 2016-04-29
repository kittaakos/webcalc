/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import org.xtext.example.webcalc.WebCalcEnvironment
import org.xtext.example.webcalc.webCalc.Calculation
import org.xtext.example.webcalc.webCalc.Result
import org.xtext.example.webcalc.webCalc.Variable
import org.xtext.example.webcalc.webCalc.VariableReference

import static org.xtext.example.webcalc.webCalc.WebCalcPackage.Literals.*

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.xtext.example.webcalc.webCalc.InputReference

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class WebCalcValidator extends AbstractWebCalcValidator {
	
	@Inject WebCalcEnvironment environment
	
	@Check
	def checkOneResult(Calculation calculation) {
		var resultFound = false
		for (equation : calculation.equations) {
			if (equation instanceof Result) {
				if (resultFound)
					error('The result must not be defined more than once.', equation, null)
				else
					resultFound = true
			}
		}
	}
	
	@Check
	def checkDuplicateVarName(Calculation calculation) {
		val nameMap = <String, Variable>newHashMap
		for (variable : calculation.equations.filter(Variable)) {
			if (nameMap.containsKey(variable.name)) {
				error('A variable named \'' + variable.name + '\' has already been defined.', variable, VARIABLE__NAME)
				val otherVar = nameMap.get(variable.name)
				if (otherVar !== null) {
					error('A variable named + \'' + variable.name + '\' has already been defined.', otherVar, VARIABLE__NAME)
					nameMap.put(variable.name, null)
				}
			} else {
				nameMap.put(variable.name, variable)
			}
		}
	}
	
	@Check
	def checkVariableReferencesItself(VariableReference varRef) {
		val containingVar = varRef.getContainerOfType(Variable)
		if (containingVar !== null && varRef.variable == containingVar)
			error('A variable must not reference itself.', VARIABLE_REFERENCE__VARIABLE)
	}
	
	@Check
	def checkInputIsSet(InputReference inputRef) {
		val value = environment.inputs.get(inputRef.input)
		if (value === null || value.isNaN)
			error('The input ' + inputRef.input + ' is not set.', INPUT_REFERENCE__INPUT)
	}
	
}
