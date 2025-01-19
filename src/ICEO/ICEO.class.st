"
""Interprète du langage ICEO""
"
Class {
	#name : 'ICEO',
	#superclass : 'Object',
	#category : 'ICEO',
	#package : 'ICEO'
}

{ #category : 'utile' }
ICEO class >> ICEO [
	"Méthode de classe d'ICEO. 
	Permet que les lignes évaluées en bloc le soient en séquence et d'attraper les exceptions de classe Oups" 

	RubSmalltalkEditor
		compile: 'evaluateSelection
	| node aString |
	node := RBParser parseExpression: self selectionForDoitAsStream contents.
	(node class == RBVariableNode or: [node class == RBMessageNode]) ifTrue: [
		[ OpalCompiler new evaluate: node newSource ]
			on: Oups
			do: [ :ex |
				SpInformDialog new
					title: '''';
					extent: 600 @ 120;
					label: ex description;
					acceptLabel: ''OK'';
					openDialog. 
				Transcript clear; show: node newSource ]].

	node class == RBSequenceNode ifTrue: [
		[
		node statements do: [ :each | aString := each newSource.
			Semaphore new
				waitTimeoutMilliseconds: 10
				onCompletion: [  ]
				onTimeout: [ OpalCompiler new evaluate: each newSource ] ] ]
			on: Oups
			do: [ :ex |
				SpInformDialog new
					title: '''';
					extent: 600 @ 120;
					label: ex description;
					acceptLabel: ''OK'';
					openDialog. 
				Transcript clear; show: aString ]]'
		classified: 'do-it'
]

{ #category : 'worldMenu' }
ICEO class >> addReset: aBuilder [
<worldMenu>
			(aBuilder item: #Reset)
				parent: #ICEO;
				order: 1;
				help: 'Reset ICEO';
				iconName: #glamorousTrash;
				label: 'ICEO reset';
				action: [ ICEO reset ];
				withSeparatorAfter 
]

{ #category : 'worldMenu' }
ICEO class >> addSgBrowser: aBuilder [

	<worldMenu>
	| sgbr |
	(aBuilder item: #SgBrowser)
		parent: #ICEO;
		order: 2;
		help: 'Open a SgBrowser';
		iconName: #glamorousInspect;
		label: 'SgBrowser';
		action: [
			Smalltalk at: #sgb ifPresent: [ :x | x window close ].
			sgbr := SgBrowser new.
			Smalltalk at: #sgb put: sgbr.
			sgbr open ]
]

{ #category : 'worldMenu' }
ICEO class >> addSiBrowser: aBuilder [

	<worldMenu>
	| sibr |
	(aBuilder item: #SiBrowser)
		parent: #ICEO;
		order: 3;
		help: 'Open a SiBrowser';
		iconName: #glamorousInspect;
		label: 'SiBrowser';
		action: [
			Smalltalk at: #sib ifPresent: [ :x | x window close ].
			sibr := SiBrowser new.
			Smalltalk at: #sib put: sibr.
			sibr open ]
]

{ #category : 'worldMenu' }
ICEO class >> ajoute: aBuilder [

	<worldMenu>
	(aBuilder item: #ICEO)
		order: 2
]

{ #category : 'icones' }
ICEO class >> blueCircleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJxSURBVDhPXZK/S1ZhFMfPc54fr1mL
EBE56JZI0RA0NeUg2F/QFBE61BQNUYtLS0hDCgU6tukSLRGkYNDW+JI0KTRkhlaKb++9z6++
57lXhR4499z3vs/nc84991H037oz93HcE81UmSeSsqPEWmW2W0qbNW3U4vK98W67taxjwexy
133b3J3rJ3W/T1pHdqSMIzYWDoNgUkol0vzq3PDIw4UproQrgtnZrvs+uPf2oKbJw8jkdYfY
dUgbQ9oijCaD0FqTYiA5rw6dH74pEhbB7pm9Z72/eXK/R9SrDPloKUKUMlMmVGZdujCQWWvJ
Ojvx5+f2c2HV4/lPY78PQ/fHPul9rymguh5wZByADgBkh+yQLQSqfemEFTJdYeTpfk26wuRi
koYQWboslxJyL7flj3ZhHpxCnOGc6EYNVYhiVQ2TACBSRLQ5xkQhpGNZxLMc0w3Go5FUYAFb
GJuzwMgRUIQ9+Ei+DlRXTci993G0DBEIDI2ACtjASWCAAocWrorAl/tQx8x4ly2NwaD5Ulng
Ut0L3ApqVJeqAvcBIzwkeL6Jr5rXLAw4b6TQQsY8MipL9QS4CEq1RuD7Imkyfq8yvvPSgFOh
YzJpioAjQEhQvXRRQYIOArKISuXSSYixSos89+D6V83qxSmnyOlEnEPTASQiOJIEVDwKj1eI
dVj48PTyRhniTrX9xGR+N2gg4Ugq+gauT0K6EFHqIQ7C+50B90hYLZcv6yvx4oWpFeOGTqvI
18oZLsPEdBEcsNErMn0Vraf5s78G766/vFQL2x7Mk3Xr9ucxHItpHKCJlNVo2ZJpi1itYcRL
b15f3Wi3YhH9A+Ds0kqzi+vxAAAAAElFTkSuQmCC'
]

{ #category : 'icones' }
ICEO class >> blueTriangleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAE0SURBVDhPjZNLSgNBEIarejILQXwk
V5CYuIjniCvxeYNEEVfuzQUcfOEiXkAEF648hRuzEXKHTMwwoGEyXXb1tImZnhn9oOj6q+tF
Q0MRB1fhFpuRmaA5LVpdcoefYY/91YXFxn0bI32RQpjTYjgOj1X7Gpv2c8jcYPt2VClJ0VeX
ZdYE4E+ErD6fLg90wi8yN3Bj7PwUM+xzzMg5rA0O74J6HOEbIrgmpCGCyHFp8/Fk6d2ENNYG
cgJeupjhmIzAM3LKXIPdy1FTpSrLAbGZ5MyYNmh1X101xZqQBlFccK6Rswb+19qRuqwbmYsa
suGP19tGJo+4532U0XH6SlV09C8IBhTH1aezFT/ZwBGdfxcznFsqnWt35yaoCQk9RLRevggi
iqSABu5fBw9AWPhhckF6+QbDPVj5ea9QcwAAAABJRU5ErkJggg=='
]

{ #category : 'icones' }
ICEO class >> buildIcons [

"		ICEO buildIcons   "
	" ThemeIcons compile:  'yellowCircleIconContents
	^ ''' , (Base64MimeConverter mimeEncode: 'yellowCircleIcon.png' asFileReference binaryReadStream) contents , '''' classified: 'Material-Design-Lite-Core'."

	ThemeIcons
		compile: 'blueCircleIcon
	self icons
			at: #''blueCircleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO blueCircleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.


	ThemeIcons
		compile: 'redCircleIcon
	^ self icons
			at: #''redCircleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO redCircleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'greenCircleIcon
	^ self icons
			at: #''greenCircleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO greenCircleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'yellowCircleIcon
	self icons
			at: #''yellowCircleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO yellowCircleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'lightBlueCircleIcon
	self icons
			at: #''lightBlueCircleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO lightBlueCircleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'purpleCircleIcon
	self icons
			at: #''purpleCircleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO purpleCircleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'orangeCircleIcon
	self icons
			at: #''orangeCircleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO orangeCircleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.


	"-------------------------------------------------"


	ThemeIcons
		compile: 'blueTriangleIcon
	self icons
			at: #''blueTriangleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO blueTriangleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.


	ThemeIcons
		compile: 'redTriangleIcon
	^ self icons
			at: #''redTriangleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO redTriangleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'greenTriangleIcon
	^ self icons
			at: #''greenTriangleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO greenTriangleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'yellowTriangleIcon
	self icons
			at: #''yellowTriangleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO yellowTriangleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'lightBlueTriangleIcon
	self icons
			at: #''lightBlueTriangleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO lightBlueTriangleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'purpleTriangleIcon
	self icons
			at: #''purpleTriangleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO purpleTriangleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.

	ThemeIcons
		compile: 'orangeTriangleIcon
	self icons
			at: #''orangeTriangleIcon''
			ifAbsentPut:[ Form fromBinaryStream: ICEO orangeTriangleIconContents base64Decoded asByteArray readStream ]'
		classified: 'Material-Design-Lite-Core'.


	Smalltalk ui icons blueCircleIcon.
	Smalltalk ui icons greenCircleIcon.
	Smalltalk ui icons lightBlueCircleIcon.
	Smalltalk ui icons orangeCircleIcon.
	Smalltalk ui icons purpleCircleIcon.
	Smalltalk ui icons redCircleIcon.
	Smalltalk ui icons yellowCircleIcon.
	Smalltalk ui icons blueTriangleIcon.
	Smalltalk ui icons greenTriangleIcon.
	Smalltalk ui icons lightBlueTriangleIcon.
	Smalltalk ui icons orangeTriangleIcon.
	Smalltalk ui icons purpleTriangleIcon.
	Smalltalk ui icons redTriangleIcon.
	Smalltalk ui icons yellowTriangleIcon




	
]

{ #category : 'utile' }
ICEO class >> forDoIt [
	"Méthode de classe d'ICEO. 
	Permet que les lignes évaluées en bloc le soient en séquence et d'attraper les exceptions de classe Oups" 

	RubSmalltalkEditor
		compile: 'evaluateSelection
	| node aString |
	node := RBParser parseExpression: self selectionForDoitAsStream contents.
	(node class == RBVariableNode or: [node class == RBMessageNode]) ifTrue: [
		[ OpalCompiler new evaluate: node newSource ]
			on: Oups
			do: [ :ex |
				SpInformDialog new
					title: '''';
					extent: 600 @ 120;
					label: ex description;
					acceptLabel: ''OK'';
					openDialog. 
				Transcript clear; show: node newSource ]].

	node class == RBSequenceNode ifTrue: [
		[
		node statements do: [ :each | aString := each newSource.
			Semaphore new
				waitTimeoutMilliseconds: 10
				onCompletion: [  ]
				onTimeout: [ OpalCompiler new evaluate: each newSource ] ] ]
			on: Oups
			do: [ :ex |
				SpInformDialog new
					title: '''';
					extent: 600 @ 120;
					label: ex description;
					acceptLabel: ''OK'';
					openDialog. 
				Transcript clear; show: aString ]]'
		classified: 'do-it'
]

{ #category : 'utile' }
ICEO class >> forDoItInPlayground [
	"Permet que les lignes évaluées en bloc soient évaluées en séquence et attrape les exceptions Oups"

	SpCodePresenter
		compile: 'evaluate: aString onCompileError: compileErrorBlock onError: errorBlock

	| receiver result oldBindings node aLine |
	node := RBParser parseExpression: aString.
	(node class == RBMessageNode or: [node class == RBVariableNode]) ifTrue: [
		[
		 [
		  self announcer announce:
			  (SpCodeWillBeEvaluatedAnnouncement newContent: aString).
		  oldBindings := self interactionModel bindings copy.
		  receiver := self interactionModel doItReceiver.
		  result := receiver class compiler
			            source: aString;
			            context: self interactionModel doItContext;
			            receiver: self interactionModel doItReceiver;
			            requestor: self interactionModel;
			            environment: self environment;
			            failBlock: [
				            self announcer announce:
						            (SpCodeEvaluationFailedAnnouncement newContent:
								             aString).
				            ^ compileErrorBlock value ];
			            evaluate.
		  oldBindings size = self interactionModel bindings size ifFalse: [
			  self withAdapterDo: [ :anAdapter | anAdapter refreshStyling ] ].
		  self announcer announce:
			  (SpCodeEvaluationSucceedAnnouncement newContent: aString)]
			  on: Error
			  do: [ :e |
				  self announcer announce:
					  (SpCodeEvaluationFailedAnnouncement
						   newContent: aString
						   error: e).
				  errorBlock value: e ] ]
			on: Oups
			do: [ :ex |
				SpInformDialog new
					title: '''';
					extent: 600 @ 120;
					label: ex description;
					acceptLabel: ''OK'';
					openDialog. Transcript clear; show:  aString]. ^result].
			
			
			

	node class == RBSequenceNode ifTrue: [
		[
		node statements do: [ :each | aLine := each newSource.
			Semaphore new
				waitTimeoutMilliseconds: 10
				onCompletion: [  ]
				onTimeout: [
					self announcer announce:
						(SpCodeWillBeEvaluatedAnnouncement newContent: each newSource).
					oldBindings := self interactionModel bindings copy.
					receiver := self interactionModel doItReceiver.
					result := receiver class compiler
						          source: each newSource;
						          context: self interactionModel doItContext;
						          receiver: self interactionModel doItReceiver;
						          requestor: self interactionModel;
						          environment: self environment;
						          failBlock: [
							          self announcer announce:
									          (SpCodeEvaluationFailedAnnouncement newContent:
											           each newSource).
							          ^ compileErrorBlock value ];
						          evaluate.
					oldBindings size = self interactionModel bindings size ifFalse: [
						self withAdapterDo: [ :anAdapter | anAdapter refreshStyling ] ].
					self announcer announce:
						(SpCodeEvaluationSucceedAnnouncement newContent: each newSource)] ] ]
			on: Oups
			do: [ :ex |
				SpInformDialog new
					title: '''';
					extent: 600 @ 120;
					label: ex description;
					acceptLabel: ''OK'';
					openDialog. Transcript clear; show:  aLine ] ]. 
			^result'
		classified: 'command support'.
		
]

{ #category : 'utile' }
ICEO class >> genSym: aSymb [ 
	"generateur de symboles"

	| n gs |
	gs := Smalltalk at: #GenSym.
	n := gs at: aSymb ifAbsent: [n := -1].
	n := n + 1.
	gs at: aSymb put: n.
	^(aSymb , '_', n printString) asSymbol
]

{ #category : 'utile' }
ICEO class >> getPremierGenusCommun: uneCollectionEssences [ 
	"il faudra étendre cette méthode à un nombre d'essences > 2 ! "
	| c t1 t2 |
	c := uneCollectionEssences.
	c size == 1
		ifTrue: [^ c at: 1].
	t1 := (c at: 1) getAllGenus.
	t2 := (c at: 2) getAllGenus.
	t1
		detect: [:each | t2 includes: each]
		ifFound: [:x | ^ x].   "il y a au moins l'essence chose ! "
]

{ #category : 'icones' }
ICEO class >> greenCircleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAEdSURBVDhPnZMxTgNBDEVtZ8SGW3AD
JC4QiTRQ0CHR0BJaqDgD1dZElDRIdCmoiEQOgMQJ4BYQmIzx9w4RixTYyStWO/b+mbX9h+kX
F5PjbV3EU2HaJeUtD7K+JqUp98LV5cHNs8cyyw3Obw83q36oleiEiSWHWyhpssf1xzye1Ud3
b4j5BhBvVOGemQdY/48+zt/jPjbxk3BydzHgQVWF2t9QM6X4tOq3V+HlSNgRNKxUDFyT4ki8
2+szlMWnNqNag2Ra6YXiv18CrcAkeV2MNfJF4LC8LodpKrCnj6SQPMaxuLfNnjneHdNA6x2E
ty0y80QndNZoyJpowNPm7T1L/FkOcqo6xrety/STbO2RJYbf11mbST2g5vZ1JvoC3HqARbs8
jn8AAAAASUVORK5CYII='
]

{ #category : 'icones' }
ICEO class >> greenTriangleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAEuSURBVDhPlZHPSsNAEMZntgm9pyf/
QNBDaT3UShB8hYqvUaoHX8E+QU8FpfSFBCnSHhR6E8Rbcg/Z7HRnnQbbxFp/MMzMl5nNlyzs
Ino6veaQthKUXCKaRL4xyYJrpYLObDDL3IMtlOQSRPEdIrQ4uBa5RKWDy/FhQ3v1pV0OuCeC
xNNp8+X+K3YDP6h0kHv14XqZ4Zo1aTcoObiYhm3QOEdEXyQHEWXg0flr/+NdJEfJAeZqtL3M
sIZajaQt2Dig+xj2bOKoBqEnMwXFJ/C1kUnmVmmL9BtviEF3fa2FA0Px7R7LzJmBZCD1t4Or
6XGQ5v7SNg2n/gEBxPVa1nzufybOQar94b7LDM/aFz64OpqELWNwUfXnd8HXqhR1agc3wdge
eWK19F+BoAHU0Qqv1WXk5FrHhQAAAABJRU5ErkJggg=='
]

{ #category : 'icones' }
ICEO class >> lightBlueCircleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAEbSURBVDhPpZMxTkJBEIb/GeQUNlKo
ibU3oEQjNp4ADmBprKUl1HAGQmJMbOAEthRqoYV6B1F2/Gd3E4MGZPFL3mbmf/vP2528Efzk
OuxijhYgdYjtRM3kmcsYFQxwrI9Ry3wXuLMqXu0KhnOIbGV1EbNPOrrYlkscyodLqYCb32zI
Lx3F/E/shkVOvYjG/MU665sdafC0nRhhGPagmC499jL8OhUcKJdWsdlxT0Bb2bR6lsqh13tQ
S9lG1FIT/4GyjU85LodeP8EkZRtgmHgTB4zmWSqAnir6iqbeM+slsYgeGvqQmvguF/wxbmO8
Dr7XPSQVOJMZZnKCYN3V1+E73+N73UN+j/Mo7HNt8+E4I48zOM4Y8+nnK2eAL9UvWnPXvEU0
AAAAAElFTkSuQmCC'
]

{ #category : 'icones' }
ICEO class >> lightBlueTriangleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAEZSURBVDhPY8AL5r31AmM8gBFKY4KZ
/1kZWN9dArN/C+kxpDP+BrPRABOUxgRs7zMZGBk1wBjExgGwu2DhR2GGf39uAaWFIAL/3zEw
fVdjiJd5C+EjAHYX/P1Tj9AMAkD2X06gGCbAdMHCT5pA2y8CWawQATj4zcDEos8Qz3cdygcD
TBf8+9MLJNE1gwAr0GUgORSAasDct55AEoSxA0agHEQNHCAMmHmGFagAwwYMwMTYA1YLBQgD
2BQygFGmCeXhA1oM7ErpUDY0EGd/EGJg/nsLaIAwmE8I/P//luEvsxpDqsA7iAuY/9YTrRkE
QGpZ/teBmQzzX2sAfQJMsozYQh4P+A9M2v/0GBnmvVsONAZvhsEJ/jNsAwANvUW1sWq69AAA
AABJRU5ErkJggg=='
]

{ #category : 'icones' }
ICEO class >> orangeCircleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAJbSURBVDhPXVNNaxRBEK3q+eg1SMCj
p+jRU/wJkuTir5CAkoAuKCLiRTFHwYAggtlc9uJJb96Ci/9AQcFj4kVy0uCuuzP9Vb7qcddo
s297prvee1XVPUz/jcnO1moZp1uS2nWmcJFNIlPSkSn5XSCzZx+8+fAnNI+FwOGja73z9dmn
sZlss58aQx5EkGsmrg1xaUgKFjAGHOm2uft6prwskJ71rXPV2zg+2ZDZTzLSUlkLGQuyBbku
iKqCGCDDJCLvubZXeXPYGBXwtPwkuemG+DEZmlFp4d6LICcApjWcIES2JOpVxL36iojfVS43
g51LNJl8ij+OC2pOqGBHRSYxMoCrutdVh0qVuqolpUQxXjYVFdfFNYX4lrCAHdEfZgX+Ts+n
BjOjKXLDpJjWxDuSGNCM1AVi0ln0NeEhA+Iak8UANQtxDR2SFaSDBd1QMpqkRLx3SCQBwR5w
HnAdPJ5jWEEandtfRyUDahaw6BUQ8VhwQAtyq0KBxEU0nfhrLkcfF+6YVQDkBLJCg6UFKcN3
s4tHKMGMGN1lU6A0EOFOOQM8w0hFxEGghVCrInOoUByZGOI+1zj0ypLgzs7dk8IzJWScWmQC
ZJEmAonCDOcYwsD0bj78wmX53NglwvXDARg0vMskl+H+FemAOp28sI8PPuebWNH4Pok94GqJ
REW0FC1BBXIvVARomeLUUBiXo2/HzT3lLj6m1O/bXxR3o59uaxTje0D4/OJhoEexSiJmbzmd
ucPDYaOri+35+L55axUnscWS1pHKBdwZaMghtkYs4eW5V/sfu0gdRL8BRL6aunCOC8oAAAAA
SUVORK5CYII='
]

{ #category : 'icones' }
ICEO class >> orangeTriangleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAEXSURBVDhPjZNdTgJBDMf/XbMb4ouE
vQNhNdFzwD0I+MAV9ALwxNPKAbyBp/BFX0y4AwQTIYTNOrSlWXVn3PBLJtOPaadpZ9DEfoGB
LFODkO0eLke8I7yLfOlwSyMU6qgR2e6xi3DP2XuyRDazR7CCzznSOMGSvR01OKyLA7pXE6xU
/0WwAg5+rIIFltUWwKuAm5aVDm/siM2kOKC4INy1hvgwk+JV8O0wqwcLYuPEM1Mr/iT4ytHn
TVYQTtK3MxVVglceGx/wbqgTEaZy1tSfBBlhTITM1CaubyKMTD41cbNAJ3E8NiAV/QxWB0K3
PcRaK0hKHdG5wULKFz6IQPscvZKfbKjzTehY5Ylvn/DMwY0f5j8c8HIE2CtCARfgnkYAAAAA
SUVORK5CYII='
]

{ #category : 'icones' }
ICEO class >> orangeTriangleIconnContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAEXSURBVDhPjZNdTgJBDMf/XbMb4ouE
vQNhNdFzwD0I+MAV9ALwxNPKAbyBp/BFX0y4AwQTIYTNOrSlWXVn3PBLJtOPaadpZ9DEfoGB
LFODkO0eLke8I7yLfOlwSyMU6qgR2e6xi3DP2XuyRDazR7CCzznSOMGSvR01OKyLA7pXE6xU
/0WwAg5+rIIFltUWwKuAm5aVDm/siM2kOKC4INy1hvgwk+JV8O0wqwcLYuPEM1Mr/iT4ytHn
TVYQTtK3MxVVglceGx/wbqgTEaZy1tSfBBlhTITM1CaubyKMTD41cbNAJ3E8NiAV/QxWB0K3
PcRaK0hKHdG5wULKFz6IQPscvZKfbKjzTehY5Ylvn/DMwY0f5j8c8HIE2CtCARfgnkYAAAAA
SUVORK5CYII='
]

{ #category : 'icones' }
ICEO class >> purpleCircleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAGYSURBVDhPnVO/S8JBFH/3Tr+aolHO
gaNDa5BTpBBuTblH6FZDi0GTRIMQDTaVQ1OLTm0iGDj5D0Q0OjQUWVH+/vq9e919k7LS0D7w
geNz7/Pu3rt7DH4gu3YeMsCddJErggyDWpMkayYzyz3o5HZKm7d24ACfCfIbeePp2czMMN+2
i7n4QP6GHvVEhxongXkjFS/ETa3ZCbS5/tK/9IE/xgC1NBYEEhryrfgQcK6nVRI7+r7eznjI
GyNS2yT+pI7xMG8soDzay45WTkM+9F8bzD3y2uNgUleomywiYyzJwcGFyj4NtQcRE8jJEfkQ
rSkpACWPoqopOKrWSai9qBdC/o/aixb1a8O1TcO+8qLq5tWozUloUq+MlqSzjuwKS0qYhtoj
ZCfHK3elenhhdY6TsUzqfeUEVO2DNmtlD6p7F/ZPdLw2Uy1qFvuqMaNOG6aO0bHao73276s8
VkRkNlxoOYWPgC0BIP4+mcAEU3SxmXU32lvpm/TXMA1jN3wYIoEJLh1RNVj2OKsJqQm0yozL
3HF1f2icAd4BfoMJKR+SVQUAAAAASUVORK5CYII='
]

{ #category : 'icones' }
ICEO class >> purpleTriangleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAE0SURBVDhPlZK/TsMwEMZ9toK6tEjt
yARD1TIUJB4A8UdIRX2NKDD0FcgTMDFFHqq+BoJHYCgDSH2HdoChIq5jfO4Rkdpq4SddfPed
L/oSm21CnslrDCqDAK0e2UkW8QZ/xbz4KHrJS6JcYw1Oqwev81tg0MHAnGSPoIPxxbiltJra
btMJhs0XYtEePg9nrv5F0EGu87QcRmxe07WUqgqeA3kpu6BhYtNopZQoI8xR/BS/U+3wHSzZ
vX2uDyMR9SpUXpCdZ30A6FPpgT3cQ6Wj/AQ8NlEXE6t0SQpj2Jv+1Mc/x1o6gAbcbB1GgB3y
XZ5QtXIgr2ST5WxqLbacugVjzIztsHb8GM+dA6NM+tdhxO1V7M7lo9NRR3ONVzb05zehRCF6
YnAweLDXdd8KX/+MZQHF3jf09F9pbLXY5gAAAABJRU5ErkJggg=='
]

{ #category : 'icones' }
ICEO class >> redCircleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAKRSURBVDhPXVI9axVBFL3ztbsvERvB
0ijYWEXwD5gPUP+AlZBGSQoDWqiNjWAlGBFENLFJrWBjERCfprHzAxSENMYiIIgS49v3dmbu
zHhmX14i3uXszM7ec+6ZOyPov3h//vKk9mFeuTCjOR4zkUgLsVlK9QrJy4fXHn3YTW1jT+D1
3Fx1KBy4S323YPpOlhypJEmFUqSVJolRSJmklCu/lL5y5Nm9Qea1AhuLi2Vdixfid29W9wbU
cYE6QpIB0WhNyhSk9BBCKkqU3hTl+DmxequRWeBPLO/E/mA29WqSTUM6MIkUUD+SRAklJciG
dFGRqTpkyrHTzHYpc8W76zdP0HbvU/z+U+mdmjqM6iAUqF4YQ8aUIIJUjZEux8EY7joGjszu
pNQpXoyNVcl5Eti3SEQpIz8YMbSvhI+MUQg0RKZ0SaaYppNjIh8gG9v8/I5IjikCAdUymCI7
SjknrwdPgd00RMREQsLwB8gtQMYkYC3gX8jJ3hK7AbGtiZs+BTvAmpuQrdVcdUQEAuaMKpnM
qMzsiSHgQfIg+6Ymn8Wwlk/hG6FpCe3OIgECnIEPDwceIh4CzjmQGnIQcSA7i7m3m1II0RVG
U1KSGA0OrfXsYF/AMQMORLuP7Mj7rowsn4hOGXBmFLNItg+RoYNEFmoOR5tFLJxYCFnvqPEu
9qNfkafu3/4ilH4gxiqKpSGPrYy2sCcCJxZOLIQshJrWUXh4fP355/Ym/jDuRtLmJXUqCoUm
j61k4r9wQAOhPjpch9TdMtvXMnd4rRAbZxfLLbWzlBq7IKyTCndDwUmugD61NzCQQHfEsqsO
Xp1aX20yb09gFGtTFyZl4Hl0cga38iguSKZ/BbosxOMzb59+3E1FEP0FL/HRbnuU71EAAAAA
SUVORK5CYII='
]

{ #category : 'icones' }
ICEO class >> redTriangleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAEhSURBVDhPjZPBUsJADIY3rRW9wqFZ
hjMDjOLFl8AXUV8CX0CfgzfwKbyAqDOeGaYe4O5027hZItruUv1mtps/m6SZTauaeEG84iUy
CMju8aRU0kpxwfbnRza+VCp3BzUi2T1OU30LAANebIvbI9jBa7fbKYry3Sa3WRPRNo6j/mi9
3riAXwQ7KMry7juZYZt9Iit4HTwjDkHB3JrJzrMnJ0UX51n2Jtrhd0DwYJ/1ZCaRswqVAnPE
CYCaiPTgM44R6dgX4LHFgTfUiQjuOVbkT4HjVN/YGxmKPIjtYnSS6muRu0tc9nptyg2PreO8
f2DHuoHkqH+2Wm1dB2QMj+1fyYyLNWbq7IXWg4jIfrIQuvkGKC8BxrBEnNnkxh/mMPT4BRww
TvcqkjF8AAAAAElFTkSuQmCC'
]

{ #category : 'intialise' }
ICEO class >> reset [

	| abs th wd |

	(Smalltalk at: #Lexique) do: [:each | Smalltalk globals removeKey: each ifAbsent: []].
	Smalltalk at: #iceo put: self new.
	Smalltalk at: #Lexique put: OrderedCollection new.
	Smalltalk at: #GenSym put: Dictionary new.
	Essence subclasses
		do: [:each | Essence removeSubclass: each].
	abs := Essence createFreeSubclass: #absolu.
	Smalltalk at: #absolu put: abs.
	(Smalltalk at: #absolu) setDescription: 'absolu est la racine des situations génériques'.
	abs isSituation: true.
	abs isQualite: false.
	th := Essence createFreeSubclass: #chose.
	Smalltalk at: #chose put: th.
	(Smalltalk at: #chose) setDescription: 'chose est l''essence racine de la hiérarchie des essences'.
	(Smalltalk at: #Lexique) add: #chose.
	(Smalltalk at: #absolu) getDifferentia add: (Smalltalk at: #chose).
	th isSituation: false.
	th isQualite: false.
	th setSituationDefinition: abs.
	wd := abs new.
	wd setNom: #monde.
	Smalltalk at: #monde put: wd.
	(Smalltalk at: #Lexique) add: #monde.
	wd isSituation: true.
	wd isEtat: false.
	Smalltalk at: #sgb ifPresent: [:x | x window close].
	Smalltalk at: #sib ifPresent: [:x | x window close]
]

{ #category : 'intialise' }
ICEO class >> start [

	| abs th wd |
	"Appelée lors du chargement de ICEO"
	ShiftClassBuilder compile: 'validateClassName
	name ifNil: [ ^self ].

	"I try to convert to symbol, if there is an error the next guard will catch it"
	[ name := name asSymbol ] on: Error do: [  ].

	name isSymbol ifFalse:[InvalidGlobalName
				signal: ''Global names should be symbols''
				for: name].

"	name isValidGlobalName ifFalse: [
		InvalidGlobalName signal: ''Class name is not a valid global name. It must start with uppercase letter and continue with alphanumeric characters or underscore. Default names used in class or trait templates are not allowed.'' for: name ]."

	DangerousClassNotifier check: name'.
	
	self forDoItInPlayground.
	self buildIcons.
	[
	(Smalltalk globals hasClassNamed: 'absolu') ifTrue: [
		Oups new signal:
			'ICEO start ne peut être utilisée qu''une seule fois. 
		Utiliser ICEO reset' ].
	Smalltalk at: #iceo put: self new.
	Smalltalk at: #Lexique put: OrderedCollection new.
	Smalltalk at: #GenSym put: Dictionary new.
	abs := Essence createFreeSubclass: #absolu.
	Smalltalk at: #absolu put: abs.
	(Smalltalk at: #absolu) setDescription:
		'absolu est la racine des situations génériques'.
	abs isSituation: true.
	abs isQualite: false.
	th := Essence createFreeSubclass: #chose.
	Smalltalk at: #chose put: th.
	(Smalltalk at: #Lexique) add: #chose.
	(Smalltalk at: #absolu) getDifferentia add: (Smalltalk at: #chose).
	(Smalltalk at: #chose) setDescription:
		'chose est l''essence racine de la hiérarchie des essences'.
	th isSituation: false.
	th isQualite: false.
	th setSituationDefinition: abs.
	wd := abs new.
	wd setNom: #monde.
	Smalltalk at: #monde put: wd.
	(Smalltalk at: #Lexique) add: #monde.
	wd isSituation: true.
	wd isEtat: false.
	Transcript
		cr;
		show: 'ICEO initialisé avec absolu, monde et chose' ]
		on: Oups
		do: [ :ex |
			SpInformDialog new
				title: '';
				extent: 600 @ 120;
				label: ex description;
				acceptLabel: 'OK';
				openDialog ]
]

{ #category : 'icones' }
ICEO class >> yellowCircleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAIpSURBVDhPXVI9a1RREJ2ZfbvZ1Q1B
sIoSIohiECF/QDEBSWFpZ2HjFzaC/gJrBUVBTOE/sIrYmRT2VtGAIqyCWGn8iPuR3X0znnPf
e2vIwHlz731zzszcuSr7zDsri6JxU8SWRbN5sZaItr7Ar6s0VnX28dsyNNlEIDpXmlH7/kjy
4XVVnJNo08BBRB2An5KQeohlz3UYt/XIvR55SSA650CeeaXeXRIZMyMIM0C7EDAIpLMmfCYR
8UZ6umJzd/uWBLLD99X7SxIDbAJBdaCWgov1FMgUoFhb1KbPSrvxkFz1b5cXZLSzqf7TJJAd
pf7PzhZK1LgHyq4jcpfhYNHE5arKsCCjy8Ic4HofWF1puCaTul+DgKP0EY5yoAwKrBMgmoD/
PsT/XawpTmDvo/MmFnMFucoKnwSBQFCQxLsB8i78X4QQGEL05lE6ecxKAQoRzEhiRe5jD7Lv
4PefElz3AlPQz2wnGUUmpVdEZKrICSAnYB3dDpkbIhwXb5fZq76R3SEQJFdl76mgENlQ/3rp
pIy779W3a+gJAiwKs5fqHTQAjDZ57HkOixjnkuVnzI6++IAbfZIeDsnVrU88Wtnbv/+G3wZ+
PLXZta3iKb9baESr+VJlfCERaUmQGVkRw4hixBGj1+KDi3bi027xrGD+8Tjq9AcIuKVmZOGU
bcBzUhgviPj4M7R0h2SeTgQq861Dp/HAb4C1DMaxMjEmJesQXLVTvzaLSJrIP67jKV40zUb7
AAAAAElFTkSuQmCC'
]

{ #category : 'icones' }
ICEO class >> yellowTriangleIconContents [
	^ 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAOCAYAAAAmL5yKAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAACxMAAAsTAQCanBgAAAEjSURBVDhPjZOxTgJBEIbnX9hWCVSo
sSRggc+BD4JaWmiw0dYYjb0v4Bv4FDbSmFgaRRtIrE9unBlHFPY4/ZK9nf+f2b252yyVkY8O
d3S4LAQ+JzD3I7+uDjVG870LXGeWWCD4nMBvtX0AbR0au51Q2EH+PGhQJX+UZF01E01oGlph
42xsBb8o7iDkp9+LFYvFczlH0kE+OuqIey+J6JYhXWTy2A5r5w9uGWkH4MvFxYp5knM5Y24D
eXsPhJ7LBM1pjUtjtgHf9aOcXfKGBNCF1To/GzRX9hDQcbkU+ZQtXq/tulQtrT8d1ClW5djQ
MPcPmHhM2UcrbF5NvjqoVuXY/rdYsdoYTyzml+M2YzoE0j9fBjNl4EoXclluCCi9MEthvv0E
Zc1VUJPb4QUAAAAASUVORK5CYII='
]

{ #category : 'essences' }
ICEO >> definition: unStringOrSymbol [
	"définition dans absolu d'une essence subsumée par chose"  

	| nom essence |
	
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	(Smalltalk at: #absolu) getElements
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal:
				'une essence nommée ''' , x getNom
				, ''' existe déjà dans l''absolu' ].
	essence := (Smalltalk at: #chose) createFreeSubclass: nom.
	(Smalltalk at: #Lexique) add: nom.
	Smalltalk at: nom put: essence.
	essence setSituationDefinition: (Smalltalk at: #absolu).
	(Smalltalk at: #absolu) getDifferentia add: essence.
	essence isSituation: false.
	essence isQualite: false.
	essence setDescription: 'definition: ' , unStringOrSymbol printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'essences' }
ICEO >> definition: unStringOrSymbol genus: uneEssence [ 
	"définition dans absolu  d'une essence subsumée par uneEssence"
	| nom essence | 
	[nom := unStringOrSymbol isSymbol
				ifTrue: [unStringOrSymbol]
				ifFalse: [unStringOrSymbol asSymbol].
	(nom at: 1) isLowercase ifFalse: [Oups new signal: 'le nom commun d''une essence doit commencer par une minuscule'].
	(Smalltalk at: #absolu)  getElements
		detect: [:each | each getNom == nom]
		ifFound: [:x | Oups new signal: 'une essence nommée ''' , x getNom, ''' existe déjà dans l''absolu'].
	essence := uneEssence createFreeSubclass: nom.
	(Smalltalk at: #Lexique)
		add: nom.
	Smalltalk
		at: nom
		put: essence.
	essence setSituationDefinition: (Smalltalk at: #absolu).
	(Smalltalk at: #absolu) getDifferentia add: essence.
	essence isSituation: false.
	essence isQualite: false.
	essence setDescription: 'definition: ', unStringOrSymbol printString, ' genus: ', uneEssence getNom printString.
	Smalltalk at: #sgb ifPresent: [:x | x window close]]
		on: Oups
		do: [ :ex |
			SpInformDialog new
			title: '';
				extent: 600@120;
				label: ex description;
				acceptLabel: 'OK';
				openDialog ]

]

{ #category : 'essences' }
ICEO >> definition: unStringOrSymbol genus: uneEssence metaEssence: uneAutreEssence [
	"définition dans l'absolu d'une essence subsumée par uneEssence et instance de uneAutreEssence"

	| nom essence |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	(Smalltalk at: #absolu) getElements
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal:
				'une essence nommée ''' , x getNom
				, ''' existe déjà dans l''absolu' ].
	essence := uneEssence createFreeSubclass: nom.
	essence setMetaEssence: uneAutreEssence.
	(Smalltalk at: #Lexique) add: nom.
	Smalltalk at: nom put: essence.
	essence setSituationDefinition: (Smalltalk at: #absolu).
	(Smalltalk at: #absolu) getDifferentia add: essence.
	(Smalltalk at: #monde) getStructure add: essence.
	essence isSituation: false.
	essence isQualite: false.
	essence setDescription:
		'definition: ' , unStringOrSymbol printString , ' genus: '
		, uneEssence getNom printString , ' metaEssence '
		, uneAutreEssence getNom printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ]
]

{ #category : 'essences' }
ICEO >> definition: unStringOrSymbol situation: uneSituation [
	"définition dans uneSituation d'une essence subsumée par chose"

	| nom essence |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneSituation getElements
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal: 'une essence nommée ''' , x getNom, ''' existe déjà dans '
				, uneSituation getNom ].
	essence := (Smalltalk at: #chose) createFreeSubclass: nom.
	(Smalltalk at: #Lexique) add: nom.
	essence setSituationDefinition: uneSituation.
	uneSituation getDifferentia add: essence.
	essence isSituation: false.
	essence isQualite: false.
	essence setDescription: 'definition: ', unStringOrSymbol printString, ' situation: ', uneSituation getNom printString.
	Smalltalk at: #sgb ifPresent: [:x | x window close]

]

{ #category : 'essences' }
ICEO >> definition: unStringOrSymbol situation: uneSituation genus: uneEssence [
	"définition dans uneSituation d'une essence subsumée par uneEssence"

	| nom essence |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneSituation getElements
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal:
				'une essence nommée ''' , x getNom , ''' existe déjà dans '
				, uneSituation getNom ].
	essence := uneEssence createFreeSubclass: nom.
	(Smalltalk at: #Lexique) add: nom.
	essence setSituationDefinition: uneSituation.
	uneSituation getDifferentia add: essence.
	essence isSituation: false.
	essence isQualite: false.
	essence setDescription:
		'definition: ' , unStringOrSymbol printString , ' situation: '
		, uneSituation getNom printString , ' genus: '
		, uneEssence getNom printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'essences' }
ICEO >> definitionAttribut: unStringOrSymbol de: uneEssence [
	"définition dans le differentia de une essence d'une essence subsumée par chose"

	| attribut nom |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneEssence getDifferentia
		detect: [ :each | each key getNom == nom ]
		ifFound: [ :x |
			Oups new signal: 'une essence nommée ''' , x getNom
				, ''' existe déjà dans le differentia de ' , uneEssence getNom ].
	attribut := (Smalltalk at: #chose) createFreeSubclass: nom.
	attribut setSituationDefinition: uneEssence.
	uneEssence getDifferentia add: (Association key: attribut value: nil).
	attribut isSituation: false.
	attribut setDescription:
		'definitionAttribut: ' , unStringOrSymbol printString , ' de: '
		, uneEssence getNom printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'essences' }
ICEO >> definitionAttribut: unStringOrSymbol de: uneEssence cardinalite: uneValeur [
	"définition dans le differentia de une essence d'une essence subsumée par chose"

	| attribut nom |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneEssence getDifferentia
		detect: [ :each | each key getNom == nom ]
		ifFound: [ :x |
			Oups new signal: 'une essence nommée ''' , x getNom
				, ''' existe déjà dans le differentia de ' , uneEssence getNom ].
	attribut := (Smalltalk at: #chose) createFreeSubclass: nom.
	attribut setSituationDefinition: uneEssence.
	uneEssence getDifferentia add:
		(Association key: attribut value: uneValeur).
	attribut isSituation: false.
	attribut setDescription:
		'definitionAttribut: ' , unStringOrSymbol printString , ' de: '
		, uneEssence getNom printString , ' cardinalité: '
		, uneValeur printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'essences' }
ICEO >> definitionAttribut: unStringOrSymbol de: uneEssence genus: uneAutreEssence [
	"définition dans le differentia de une essence d'une essence subsumée
	par uneAutreEssence"

	| attribut nom |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneEssence getDifferentia
		detect: [ :each | each key getNom == nom ]
		ifFound: [ :x |
			Oups new signal: 'une essence nommée ''' , x getNom
				, ''' existe déjà dans le differentia de ' , uneEssence getNom ].
	attribut := uneAutreEssence createFreeSubclass: nom.
	attribut setSituationDefinition: uneEssence.
	attribut isSituation: false.
	uneEssence getDifferentia add: (Association key: attribut value: nil).
	attribut setDescription:
		'definitionAttribut: ' , unStringOrSymbol printString , ' de: '
		, uneEssence getNom printString , ' genus: '
		, uneAutreEssence printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'essences' }
ICEO >> definitionAttribut: unStringOrSymbol de: uneEssence genus: uneAutreEssence cardinalite: uneValeur [
	"définition dans le differentia de une essence d'une essence subsumée
	par uneAutreEssence"

	| attribut nom |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneEssence getDifferentia
		detect: [ :each | each key getNom == nom ]
		ifFound: [ :x |
			Oups new signal: 'une essence nommée ''' , x getNom
				, ''' existe déjà dans le differentia de ' , uneEssence getNom ].
	attribut := uneAutreEssence createFreeSubclass: nom.
	attribut setSituationDefinition: uneEssence.
	attribut isSituation: false.
	uneEssence getDifferentia add:
		(Association key: attribut value: uneValeur).
	attribut isSituation: false.
	attribut setDescription:
		'definitionAttribut: ' , unStringOrSymbol printString , ' de: '
		, uneEssence getNom printString , ' genus: '
		, uneAutreEssence printString , ' cardinalité: '
		, uneValeur printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'essences' }
ICEO >> definitionAttribut: unStringOrSymbol de: uneEssence isPrototype: aBoolean [
	"définition dans le differentia de une essence d'une essence subsumée par chose"

	| attribut nom |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneEssence getDifferentia
		detect: [ :each | each key getNom == nom ]
		ifFound: [ :x |
			Oups new signal: 'une essence nommée ''' , x getNom
				, ''' existe déjà dans le differentia de ' , uneEssence getNom ].
	attribut := (Smalltalk at: #chose) createFreeSubclass: nom.
	attribut setSituationDefinition: uneEssence.
	uneEssence getDifferentia add: (Association key: attribut value: nil).
	attribut isSituation: false.
	attribut isPrototype: aBoolean.
	attribut setDescription:
		'definitionAttribut: ' , unStringOrSymbol printString , ' de: '
		, uneEssence getNom printString , ' isPrototype '
		, aBoolean printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ]
]

{ #category : 'essences' }
ICEO >> definitionAttribut: unStringOrSymbol de: uneEssence isPrototype: aBoolean cardinalite: uneValeur [
	"définition dans le differentia de une essence d'une essence subsumée par chose qui est prototype"

	| attribut nom |

	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneEssence getDifferentia
		detect: [ :each | each key getNom == nom ]
		ifFound: [ :x |
			Oups new signal: 'une essence nommée ''' , x getNom
				, ''' existe déjà dans le differentia de ' , uneEssence getNom ].
	attribut := (Smalltalk at: #chose) createFreeSubclass: nom.
	attribut setSituationDefinition: uneEssence.
	uneEssence getDifferentia add:
		(Association key: attribut value: uneValeur).
	attribut isSituation: false.
	attribut isPrototype: aBoolean.
	attribut setDescription:
		'definitionAttribut: ' , unStringOrSymbol printString , ' de: '
		, uneEssence getNom printString , ' isProtype: '
		, aBoolean printString , ' cardinalité: ' , uneValeur printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'qualites' }
ICEO >> definitionQualite: unStringOrSymbol situation: uneSituation [
	"définition dans uneSituation d'une manière d'être subsumée par chose "

	| nom essence |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneSituation getElements
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal:
				'une essence nommée ''' , x getNom , ''' existe déjà dans '
				, uneSituation getNom ].
	essence := (Smalltalk at: #chose) createFreeSubclass: nom.
	(Smalltalk at: #Lexique) add: nom.
	essence setSituationDefinition: uneSituation.
	uneSituation getDifferentia add: essence.
	essence isSituation: false.
	essence isQualite: true.
	essence setStatut: #accidentelle.
	essence setEffectivite: #intermittente.
	essence setDescription:
		'definitionQualite: ' , unStringOrSymbol printString
		, ' situation: ' , uneSituation getNom printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ]
]

{ #category : 'qualites' }
ICEO >> definitionQualite: unStringOrSymbol situation: uneSituation genus: uneEssence [
	"définition dans uneSituation d'une manière d'être subsumée par uneEssence "

	| nom essence |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	uneSituation getElements
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal:
				'une essence nommée ''' , x getNom , ''' existe déjà dans '
				, uneSituation getNom ].
	essence := uneEssence createFreeSubclass: nom.
	(Smalltalk at: #Lexique) add: nom.
	essence setSituationDefinition: uneSituation.
	uneSituation getDifferentia add: essence.
	essence isSituation: false.
	essence isQualite: true.
	essence setStatut: #accidentelle.
	essence setEffectivite: #intermittente.
	essence setDescription:
		'definitionQualite: ' , unStringOrSymbol printString
		, ' situation: ' , uneSituation getNom printString , ' genus: '
		, uneEssence getNom printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'qualites' }
ICEO >> definitionQualiteEssentielle: unStringOrSymbol genus: uneEssence pour: uneAutreEssence effectivite: unSymbole [
	"définition dans la situation de définition de uneAutreEssence d'une manière d'être essentielle subsumée par uneEssence "

	| nom essence s col |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	s := uneAutreEssence getSituationDefinition.
	s isSituation
		ifTrue: [ col := s getElements ]
		ifFalse: [ col := s getEssencesAttributs ].
	col detect: [ :each | each getNom == nom ] ifFound: [ :x |
		Oups new signal:
			'une essence nommée ''' , x getNom , ''' existe déjà dans '
			, s getNom ].
	essence := uneEssence createFreeSubclass: nom.
	uneAutreEssence getDifferentia add: essence.
	(Smalltalk at: #Lexique) add: nom.
	essence setSituationDefinition: uneAutreEssence.
	essence isSituation: false.
	essence isQualite: true.
	essence setStatut: #essentielle.
	essence setEffectivite: unSymbole.
	uneAutreEssence getQualitesPropres add: essence.
	essence getEssencesQualifiees add: uneAutreEssence.
	essence setDescription:
		'definitionQualite: ' , unStringOrSymbol printString , ' genus: '
		, uneEssence getNom printString , ' pour: '
		, uneAutreEssence getNom printString , ' effectivite: '
		, unSymbole printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'qualites' }
ICEO >> definitionQualiteEssentielle: unStringOrSymbol pour: uneEssence effectivite: unSymbole [
	"définition dans la situation de définition de uneEssence d'une manière d'être essentielle subsumée par chose "

	| nom essence s col |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(nom at: 1) isLowercase ifFalse: [
		Oups new signal:
			'le nom commun d''une essence doit commencer par une minuscule' ].
	s := uneEssence getSituationDefinition.
	s isSituation
		ifTrue: [ col := s getElements ]
		ifFalse: [ col := s getEssencesAttributs ].
	col detect: [ :each | each getNom == nom ] ifFound: [ :x |
		Oups new signal:
			'une essence nommée ''' , x getNom , ''' existe déjà dans '
			, s getNom ].
	essence := (Smalltalk at: #chose) createFreeSubclass: nom.
	"uneEssence getDifferentia add: essence."
	(Smalltalk at: #Lexique) add: nom.
	essence setSituationDefinition: uneEssence.
	essence isSituation: false.
	essence isQualite: true.
	essence setStatut: #essentielle.
	essence setEffectivite: unSymbole.
	uneEssence getQualitesPropres add: essence.
	essence getEssencesQualifiees add: uneEssence.
	essence setDescription:
		'definitionQualite: ' , unStringOrSymbol printString , ' pour: '
		, uneEssence getNom printString , ' effectivite: '
		, unSymbole printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'situations' }
ICEO >> definitionSituation: unStringOrSymbol [
	"définition dans absolu  d'une situation générique subsumée par Essence "

	| sg nom |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(Smalltalk at: #absolu) getSituations
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal:
				'une situation nommée ''' , x getNom , ''' existe déjà dans '
				, #absolu ].
	sg := Essence createFreeSubclass: nom.
	(Smalltalk at: #absolu) getDifferentia add: sg.
	(Smalltalk at: #Lexique) add: nom.
	sg isSituation: true.
	Smalltalk at: nom asSymbol put: sg.
	sg setDescription:
		'definitionSituation: ' , unStringOrSymbol printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'situations' }
ICEO >> definitionSituation: unStringOrSymbol dans: uneSituationGenerique [
	"définition dans uneSituationGenerique d'une situation générique subsumée par Essence "

	| sg nom |
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(Smalltalk at: #absolu) getSituations
		detect: [ :each | each getNom == nom ]
		ifFound: [ :x |
			Oups new signal:
				'une situation nommée ''' , x getNom , ''' existe déjà dans '
				, #absolu ].
	sg := Essence createFreeSubclass: nom.
	uneSituationGenerique getDifferentia add: sg.
	(Smalltalk at: #Lexique) add: nom.
	sg isSituation: true.
	Smalltalk at: nom asSymbol put: sg.
	sg setDescription:
		'definitionSituation: ' , unStringOrSymbol printString , ' dans: '
		, uneSituationGenerique getNom printString.
	Smalltalk at: #sgb ifPresent: [ :x | x window close ] 
]

{ #category : 'etres' }
ICEO >> soit: unStringOrSymbol essence: uneEssence [
	"définition dans le monde d'un être d'essence uneEssence"

	| nom etre c n |
	Smalltalk at: #sib ifPresent: [:x | x window close].
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	(Smalltalk at: #monde) getElements
		detect: [ :each |
		each getNom == nom and: [ each getEssence == uneEssence ] ]
		ifFound: [ :x |
			Oups new signal: 'un être nommé ''' , x getNom
				, ''' de même essence existe déjà dans le monde' ].
	etre := uneEssence new.
	etre setNom: nom.
	etre setSituationDefinition: (Smalltalk at: #monde).
	etre isSituation: false.
	etre isEtat: false.
	(Smalltalk at: #monde) introductionEtre: etre.
	"création des attributs dont la cardinalite est définie et > 0"
	uneEssence isIndividu ifTrue: [
		uneEssence getAttributs do: [ :each |
			c := each value.
			(c notNil and: [ c > 0 ]) ifTrue: [
				(1 to: c) do: [ :x |
					n := ICEO genSym: each key getNom.
					self soitAttribut: n de: etre essence: each key] ] ] ].
	"les états essentiels se situent dans la situation de définition l'être"
	uneEssence getQualites do: [ :each |
		(each getStatut == #essentielle and: [
			 each getEffectivite == #permanente ]) ifTrue: [
			etre affecteEtatEssentiel: each  ] ].
	etre setDescription: 'soit: ', nom, ' essence: ', uneEssence getNom.
	^ etre
]

{ #category : 'etres' }
ICEO >> soit: unStringOrSymbol essence: uneEssence situationIndividuelle: uneSituation [
	"définition dans uneSituationIndividuelle d'un être d'essence
	uneEssence"

	| nom etre c n |
	Smalltalk at: #sib ifPresent: [:x | x window close].
		nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	uneSituation getElements
		detect: [ :each |
		each getNom == nom and: [ each getEssence == uneEssence ] ]
		ifFound: [ :x |
			Oups new signal: 'un être nommé ''' , x
				, ''' de même essence existe déjà dans la situation'
				, uneSituation ].
	etre := uneEssence new.
	etre setNom: nom.
	etre setSituationDefinition: uneSituation.
	uneSituation introductionEtre: etre.
	etre isSituation: false.
	etre isEtat: false.
	"création des attributs dont la cardinalite est définie et > 0"
	uneEssence isIndividu ifTrue: [
		uneEssence getAttributs do: [ :each |
			c := each value.
			(c notNil and: [ c > 0 ]) ifTrue: [
				(1 to: c) do: [ :x |
					n := ICEO genSym: each key getNom.
					self soitAttribut: n de: etre essence: each key] ] ] ].
	"les états essentiels se situent dans la situation de définition l'être"
	uneEssence getQualites do: [ :each |
		(each getStatut == #essentielle and: [
			 each getEffectivite == #permanente ]) ifTrue: [
			etre affecteEtatEssentiel: each  ] ].
	etre setDescription: 'soit: ', nom, ' essence: ', uneEssence getNom, ' situationIndividuelle: ', uneSituation getNom printString.
	^ etre
]

{ #category : 'etres' }
ICEO >> soit: unStringOrSymbol essence: uneEssence situationIndividuelle: uneSituation quiEst: uneQualite [
	"définition dans uneSituationIndividuelle d'un être d'essence uneEssence ayant un état instance de uneQualité"

	| nom etre c n |
	Smalltalk at: #sib ifPresent: [:x | x window close].
			nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	" deux êtres de même nom ne peuvent exister dans la même situation s'ils ne se distinguent pas par leur état"
	uneSituation getElements
		detect: [ :each |
			(each getNom == nom and: [ each getEssence == uneEssence ]) and: [
				(each getEtat: uneQualite getNom) notNil ] ]
		ifFound: [ :x |
			Oups new signal: 'un être nommé ''' , x getNom
				, ''' de même essence existe déjà dans la situation'
				, uneSituation , ' avec la même qualité ' , uneQualite getNom ].
	etre := uneEssence new.
	etre setNom: nom.
	etre setSituationDefinition: uneSituation.
	uneSituation introductionEtre: etre.
	etre isSituation: false.
	etre isEtat: false.
	(Smalltalk at: #monde) add: etre.
	etre affecteEtat: uneQualite dansSituation: uneSituation.
	"création des attributs dont la cardinalite est définie et > 0"
	uneEssence isIndividu ifTrue: [
		uneEssence getAttributs do: [ :each |
			c := each value.
			(c notNil and: [ c > 0 ]) ifTrue: [
				(1 to: c) do: [ :x |
					n := uneEssence genSym: each key getNom.
					self soitAttribut: n de: etre essence: each key] ] ] ].
	"les états essentiels se situent dans la situation de définition l'être"
	uneEssence getQualites do: [ :each |
		(each getStatut == #essentielle and: [
			 each getEffectivite == #permanente ]) ifTrue: [
			etre affecteEtatEssentiel: each  ] ].
	etre setDescription: 'soit: ', nom, ' essence: ', uneEssence getNom, ' situationIndividuelle: ', uneSituation getNom printString, ' quiEst: ', uneQualite getNom printString.
	^ etre
]

{ #category : 'situations' }
ICEO >> soit: unStringOrSymbol situationGenerique: uneSituation [
	"définition dans le monde d'une situation individuelle  instance de la situation générique uneSituation définie dans l'absolu"
	| nom situation |
	Smalltalk at: #sib ifPresent: [:x | x window close].
		nom := unStringOrSymbol isSymbol
				ifTrue: [unStringOrSymbol]
				ifFalse: [unStringOrSymbol asSymbol].
	situation := uneSituation new.
	situation setNom: nom.
	situation setSituationDefinition: (Smalltalk at: #monde).
	situation isSituation: true.
	(Smalltalk at: #monde) introductionEtre: situation.
	situation setDescription: 'soit: ', nom printString, ' situationGenerique ', uneSituation getNom.

]

{ #category : 'situations' }
ICEO >> soit: unStringOrSymbol situationGenerique: uneSituationGenerique dansSituationIndividuelle: uneSituationIndividuelle [
	"définition dans uneSituationIndividuelle d'une situation individuelle
	instance de la situation générique uneSituation"

	"exige que uneSituationIndividuelle soit instance d'une situation
	générique où se situe une situationGenerique"

	| nom situation |
		Smalltalk at: #sib ifPresent: [:x | x window close].
			(uneSituationIndividuelle getSituationGenerique includes:
		 uneSituationGenerique) ifFalse: [
		Oups new signal:
			uneSituationGenerique , ' doit être incluse dans l''essence de '
			, uneSituationIndividuelle ].
	nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	situation := uneSituationGenerique new.
	situation setNom: nom.
	situation setSituationDefinition: uneSituationIndividuelle.
	situation isSituation: true.
	situation setDescription: 'soit: ', nom, ' situationGenerique ', uneSituationGenerique getNom, ' situationIndividuelle: ', uneSituationIndividuelle getNom printString.

]

{ #category : 'etres' }
ICEO >> soitAttribut: unStringOrSymbol de: unEtre essence: uneEssence [
	"définition d'un attribut d'un être d'essence uneEssence.
	Il faudra vérifier qu'il est prévu au niveau de l'essence de self  d'avoir un attribut ayant comme essence uneEssence 
	"

	| nom attribut c n |
	Smalltalk at: #sib ifPresent: [:x | x window close].
		nom := unStringOrSymbol isSymbol
		       ifTrue: [ unStringOrSymbol ]
		       ifFalse: [ unStringOrSymbol asSymbol ].
	unEtre getStructure 
		detect: [ :each |
		each getNom == nom and: [ each getEssence == uneEssence ] ]
		ifFound: [ :x |
			Oups new signal: 'un être nommé ''' , x getNom, ' d''essence ', uneEssence getNom, ' est déjà attribut de ', unEtre getNom ].
	attribut := uneEssence new.
	attribut setNom: nom.
	attribut setSituationDefinition: unEtre.
	attribut isSituation: uneEssence isSituation.
	attribut isEtat: false.
	(unEtre getStructure) add: attribut.
	
	"création des attributs des attributs"
	uneEssence getAttributs do: [ :each |
			c := each value.
			(c notNil and: [ c > 0 ]) ifTrue: [
				(1 to: c) do: [ :x |
					n := ICEO genSym: each key getNom.
					self soitAttribut: n de: attribut essence: each key] ] ].
		
		"les états essentiels se situent dans la situation de définition l'être"
	uneEssence getQualites do: [ :each |
		(each getStatut == #essentielle and: [
			 each getEffectivite == #permanente ]) ifTrue: [
			attribut affecteEtatEssentiel: each  ] ].
	attribut setDescription: 'soitAttribut: ', nom, ' de: ', unEtre getNom, ' essence: ', uneEssence getNom.
	^ attribut
]

{ #category : 'etres' }
ICEO >> soitEtat: unStringOrSymbol essence: uneQualite situationIndividuelle: uneSituation [
	"définition dans uneSituationIndividuelle d'un état d'essence
	uneQualite dont l'étant est indéterminé"

	| nom etat essence inconnu |
	Smalltalk at: #sib ifPresent: [:x | x window close].
	nom := unStringOrSymbol isSymbol ifTrue: [ unStringOrSymbol ].
	uneQualite isQualite ifFalse: [
		Oups new signal: uneQualite , 'n''est pas une qualité' ].
	etat := uneQualite new.
	etat setNom: nom.
	etat setSituationDefinition: uneSituation.
	etat isSituation: false.
	etat isEtat: true.
	uneSituation introductionEtre:  etat.
	"recherche de l'essence ayant cette qualité"
	essence := self class getPremierGenusCommun:
		           uneQualite getEssencesQualifiees.
	inconnu := essence getInstance:
			 'un(e) ' , essence getNom , ' inconnu(e)'.
	etat setEtant: inconnu.
	inconnu setSituationDefinition: (Smalltalk at: #absolu).
	inconnu isSituation: false.
	inconnu isEtat: false.
	etat setDescription: 'soitEtat: ', nom, ' essence: ', uneQualite getNom, ' situationIndividuelle: ', uneSituation getNom printString.

]
