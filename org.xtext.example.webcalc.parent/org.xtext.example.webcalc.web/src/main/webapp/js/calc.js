/**
 * Copyright (c) 2016 TypeFox GmbH (http://typefox.io)
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

require(['./requirejs-setup'], function () {
	
	var initialContent = 'result = (A + B) / C';
	
	require(['jquery', 'bootstrap', 'webjars/ace/1.2.2/src/ace'], function($) {
		require(['xtext/xtext-ace'], function(xtext) {
			var editor = xtext.createEditor({
				baseUrl: require.config.baseUrl,
				syntaxDefinition: 'js/xtext/mode-webcalc'
			});
			editor.setShowFoldWidgets(false);
			editor.renderer.setOption('showLineNumbers', false);
			var xtextServices = editor.xtextServices;
			
			require(['xtext/services/XtextService', 'xtext/ServiceBuilder'], function(XtextService, ServiceBuilder) {
				var options = xtextServices.options;
				
				// The 'calculate' service interprets the model and returns the result
				var calculateService = new XtextService();
				calculateService.initialize(options.serviceUrl, 'calculate', options.resourceId, xtextServices.updateService);
				
				// The 'setInput' service updates the input value in the server-side environment
				var setInputService = new XtextService();
				setInputService.initialize(options.serviceUrl, 'setInput', options.resourceId, xtextServices.updateService);
				setInputService._initServerData = function(serverData, editorContext, params) {
					serverData.input = $(params.input).attr('data-input-name');
					serverData.value = $(params.input).val();
				};
				
				// Set an initial value for each input field and trigger validation on value change
				$('.calc-input').each(function(index, input) {
					var initialValue = index + 1;
					var params = ServiceBuilder.mergeOptions({input: input}, options);
					$(input).val(initialValue).change(function() {
						setInputService.invoke(xtextServices.editorContext, params).done(function() {
							xtextServices.validationService.setState(undefined);
							xtextServices.serviceBuilder.doValidation();
						});
					});
				});
				
				// Force an update in order to ensure a proper document on the server, then initialize the input values
				xtextServices.update({forceUpdate: true}).done(function() {
					$('.calc-input').each(function(index, input) {
						var params = ServiceBuilder.mergeOptions({input: input}, options);
						setInputService.invoke(xtextServices.editorContext, params);
					});
				});
				
				// Whenever validation finishes without errors, fetch the calculation result and display it
				xtextServices.successListeners.push(function(serviceType, result) {
					if (serviceType == 'validate' && result.issues.every(function(issue) {issue.severity != 'error'})) {
						calculateService.invoke(xtextServices.editorContext, options).done(function(result) {
							$('#calc-output').empty().append(result.error ? result.error : result.output);
						});
					}
				});
				
				// Set an initial editor content as example
				editor.setValue(initialContent);
				editor.clearSelection();
			});
		});
	});
});
