/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.xtext.example.webcalc.web.services

import com.google.inject.Inject
import com.google.inject.Provider
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.web.server.IServiceContext
import org.eclipse.xtext.web.server.model.DocumentSynchronizer
import org.eclipse.xtext.web.server.model.IWebDocumentProvider
import org.eclipse.xtext.web.server.model.XtextWebDocument

/**
 * TODO this workaround shouldn't be necessary with Xtext 2.10.
 */
class WebDocumentProvider implements IWebDocumentProvider {
	
	@Inject Provider<DocumentSynchronizer> synchronizerProvider
	
	override get(String resourceId, IServiceContext serviceContext) {
		val synchronizer =
			if (resourceId === null)
				synchronizerProvider.get
			else
				serviceContext.session.get(DocumentSynchronizer, [synchronizerProvider.get])
		new Document(resourceId, synchronizer)
	}
	
	@FinalFieldsConstructor
	static class Document extends XtextWebDocument {
		
		override clearCachedServiceResults() {
			super.clearCachedServiceResults()
		}
		
	}
	
}