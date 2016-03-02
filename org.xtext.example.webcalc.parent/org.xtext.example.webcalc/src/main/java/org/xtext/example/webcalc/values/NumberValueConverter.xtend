/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.values

import org.eclipse.xtext.conversion.impl.AbstractValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.nodemodel.INode

class NumberValueConverter extends AbstractValueConverter<Double> {
	
	override toString(Double value) throws ValueConverterException {
		value.toString
	}
	
	override toValue(String string, INode node) throws ValueConverterException {
		try {
			Double.valueOf(string)
		} catch (NumberFormatException exception) {
			throw new ValueConverterException('Not a valid number.', node, exception)
		}
	}
	
}