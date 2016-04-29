/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.web.services

import com.google.inject.Inject
import org.eclipse.xtext.web.server.IServiceContext
import org.eclipse.xtext.web.server.InvalidRequestException
import org.eclipse.xtext.web.server.InvalidRequestException.InvalidParametersException
import org.eclipse.xtext.web.server.XtextServiceDispatcher
import org.eclipse.xtext.web.server.model.DocumentStateResult
import org.xtext.example.webcalc.WebCalcEnvironment
import org.xtext.example.webcalc.interpreter.WebCalcInterpreter
import org.xtext.example.webcalc.webCalc.Calculation
import org.xtext.example.webcalc.webCalc.Input

class WebCalcServiceDispatcher extends XtextServiceDispatcher {
	
	@Inject WebCalcInterpreter interpreter
	
	@Inject WebCalcEnvironment environment
	
	override protected createServiceDescriptor(String serviceType, IServiceContext context) {
		switch serviceType {
			case 'calculate':
				getCalculateService(context)
			case 'setInput':
				getSetInputService(context)
			default:
				super.createServiceDescriptor(serviceType, context)
		}
	}
	
	protected def getCalculateService(IServiceContext context) throws InvalidRequestException {
		val document = getDocumentAccess(context)
		new ServiceDescriptor => [
			service = [
				try {
					document.readOnly[ it, cancelIndicator |
						val calculation = resource.contents.head as Calculation
						val result = if (calculation !==null)
							interpreter.computeResult(calculation)
						if (result === null)
							return new CalculationResult(0, 'Result value has not been specified.')
						else if (result.isNaN)
							return new CalculationResult(0, 'Error in calculation.')
						else
							return new CalculationResult(result, null)
					]
				} catch (Throwable throwable) {
					handleError(throwable)
				}
			]
		]
	}
	
	protected def getSetInputService(IServiceContext context) throws InvalidRequestException {
		val document = getDocumentAccess(context)
		val inputName = context.getParameter('input')
		if (inputName.nullOrEmpty)
			throw new InvalidParametersException('The parameter \'input\' must be specified.')
		val input = try {
			Input.valueOf(inputName)
		} catch (IllegalAccessException e) {
			throw new InvalidParametersException('The parameter \'input\' must contain an input name.')
		}
		val valueString = context.getParameter('value')?.trim
		val Double value =
			if (!valueString.nullOrEmpty)
				try {
					Double.parseDouble(valueString)
				} catch (NumberFormatException e) {
					Double.NaN
				}
			else
				null
		new ServiceDescriptor => [
			service = [
				try {
					document.modify[ doc, cancelIndicator |
						environment.inputs.put(input, value)
						(doc as WebDocumentProvider.Document).clearCachedServiceResults()
						return new DocumentStateResult(doc.stateId)
					]
				} catch (Throwable throwable) {
					handleError(throwable)
				}
			]
		]
	}
	
}