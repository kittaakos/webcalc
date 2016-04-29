/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

var baseUrl = window.location.pathname;
var fileIndex = baseUrl.indexOf("index.html");
if (fileIndex > 0)
	baseUrl = baseUrl.slice(0, fileIndex);
require.config({
	baseUrl: baseUrl,
	shim: {
        'bootstrap': {
        	'deps': ['jquery']
        }
    },
	paths: {
		'jquery': 'webjars/jquery/2.2.3/jquery.min',
		'bootstrap': 'webjars/bootstrap/3.3.6/js/bootstrap.min',
		'ace/ext/language_tools': 'webjars/ace/1.2.2/src/ext-language_tools',
		'xtext/xtext-ace': 'xtext/2.9.2/xtext-ace.min'
	}
});
