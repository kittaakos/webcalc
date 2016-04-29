/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.interpreter

import com.google.inject.Inject
import org.xtext.example.webcalc.WebCalcEnvironment
import org.xtext.example.webcalc.webCalc.BinaryExpression
import org.xtext.example.webcalc.webCalc.Calculation
import org.xtext.example.webcalc.webCalc.Function0Call
import org.xtext.example.webcalc.webCalc.Function1Call
import org.xtext.example.webcalc.webCalc.Function2Call
import org.xtext.example.webcalc.webCalc.InputReference
import org.xtext.example.webcalc.webCalc.NumberLiteral
import org.xtext.example.webcalc.webCalc.Result
import org.xtext.example.webcalc.webCalc.UnaryExpression
import org.xtext.example.webcalc.webCalc.Variable
import org.xtext.example.webcalc.webCalc.VariableReference

class WebCalcInterpreter {
	
	@Inject WebCalcEnvironment environment
	
	def Double computeResult(Calculation calculation) {
		val model = new InterpreterModel
		for (equation : calculation.equations) {
			interpret(equation, model)
		}
		return model.result
	}
	
	private def dispatch void interpret(Variable variableEq, InterpreterModel model) {
		model.variables.put(variableEq, evaluate(variableEq.expression, model))
	}
	
	private def dispatch void interpret(Result resultEq, InterpreterModel model) {
		model.result = evaluate(resultEq.expression, model)
	}
	
	private def dispatch double evaluate(BinaryExpression expression, InterpreterModel model) {
		val left = evaluate(expression.left, model)
		val right = evaluate(expression.right, model)
		switch expression.operator {
			case '+': left + right
			case '-': left - right
			case '*': left * right
			case '/': left / right
			default: Double.NaN
		}
	}
	
	private def dispatch double evaluate(UnaryExpression expression, InterpreterModel model) {
		val value = evaluate(expression.expression, model)
		switch expression.operator {
			case '-': -value
			default: Double.NaN
		}
	}
	
	private def dispatch double evaluate(VariableReference reference, InterpreterModel model) {
		model.variables.get(reference.variable) ?: Double.NaN
	}
	
	private def dispatch double evaluate(InputReference reference, InterpreterModel model) {
		environment.inputs.get(reference.input) ?: Double.NaN
	}
	
	private def dispatch double evaluate(Function0Call functionCall, InterpreterModel model) {
		try {
			val method = Math.getMethod(functionCall.function)
			method.invoke(null) as Double
		} catch (Exception exception) {
			Double.NaN
		}
	}
	
	private def dispatch double evaluate(Function1Call functionCall, InterpreterModel model) {
		val argument = evaluate(functionCall.argument, model)
		try {
			val method = Math.getMethod(functionCall.function, double)
			method.invoke(null, argument) as Double
		} catch (Exception exception) {
			Double.NaN
		}
	}
	
	private def dispatch double evaluate(Function2Call functionCall, InterpreterModel model) {
		val argument1 = evaluate(functionCall.argument1, model)
		val argument2 = evaluate(functionCall.argument2, model)
		try {
			val method = Math.getMethod(functionCall.function, double, double)
			method.invoke(null, argument1, argument2) as Double
		} catch (Exception exception) {
			Double.NaN
		}
	}
	
	private def dispatch double evaluate(NumberLiteral literal, InterpreterModel model) {
		literal.value
	}
	
}