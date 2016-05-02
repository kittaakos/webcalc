/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.ide

import com.google.inject.Inject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider
import org.xtext.example.webcalc.services.WebCalcGrammarAccess
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistEntry
import org.eclipse.xtext.Keyword

class WebCalcContentProposalProvider extends IdeContentProposalProvider {
	
	@Inject extension WebCalcGrammarAccess
	
	static val HIDDEN_KEYWORDS = #{ '(', ')' }
	
	override protected filterKeyword(Keyword keyword, ContentAssistContext context) {
		!HIDDEN_KEYWORDS.contains(keyword.value) && super.filterKeyword(keyword, context)
	}
	
	override protected _createProposals(RuleCall ruleCall, ContentAssistContext context, IIdeContentProposalAcceptor acceptor) {
		switch ruleCall.rule {
			case functionCallRule:
				proposeFunctionCalls(context, acceptor)
			default:
				super._createProposals(ruleCall, context, acceptor)
		}
	}
	
	static val HIDDEN_FUNCS = #{
		'IEEEremainder', 'cbrt', 'copySign', 'expm1', 'log1p', 'nextAfter', 'nextDown', 'nextUp', 'rint', 'signum', 'toDegrees',
		'toRadians', 'ulp'
	}
	
	protected def proposeFunctionCalls(ContentAssistContext context, IIdeContentProposalAcceptor acceptor) {
		val calcMethods = Math.methods.filter[ m |
			!HIDDEN_FUNCS.contains(m.name) && m.returnType == double && m.parameterCount <= 2 && m.parameterTypes.forall[it == double]
		]
		for (method : calcMethods) {
			// TODO Adapt to 2.10 proposal creator API
			val entry = new ContentAssistEntry => [
				prefix = context.prefix
				proposal = method.name + '()'
				escapePosition = context.offset + proposal.length - 1
			]
			if (entry.proposal.startsWith(entry.prefix))
				acceptor.accept(entry, proposalPriorities.getDefaultPriority(entry) + 50)
		}
	}
	
}