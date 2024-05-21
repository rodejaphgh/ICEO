"
Browser au niveau générique d'ICEO
"
Class {
	#name : 'SgBrowser',
	#superclass : 'SpPresenter',
	#instVars : [
		'situations',
		'essences',
		'attributs',
		'qualites',
		'code'
	],
	#category : 'ICEO',
	#package : 'ICEO'
}

{ #category : 'showing' }
SgBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : 'initialization' }
SgBrowser >> classTemplateFor: aSituation [

	aSituation ifNil: [ ^ '' ].

	^ 'Object subclass: #NameOfSubclass
	slots: {}
	classVariables: {}
	package: ''' , aSituation name , ''' '
]

{ #category : 'initialization' }
SgBrowser >> connectAttributsPresenter [

	attributs
		transmitTo: code
		transform: [ :aAttribut | aAttribut ifNotNil: [ aAttribut getDescription ] ifNil: [ '' ] ]
]

{ #category : 'initialization' }
SgBrowser >> connectEssencesPresenter [




	essences
		transmitTo: attributs
		transform: [ :aClass | 
			aClass
				ifNotNil: [aClass getEssencesAttributs asArray]
				ifNil: [ #(  ) ] ].
		
	essences
		transmitTo: qualites
		transform: [ :aClass | 
			aClass
				ifNotNil: [aClass getQualites asArray]
				ifNil: [ #(  ) ] ].
	
	essences
		transmitTo: code
		transform: [ :aClass | aClass ifNotNil: [ aClass getDescription ] ifNil: [ '' ] ]
]

{ #category : 'initialization' }
SgBrowser >> connectPresenters [

	self connectSituationsPresenter.
	self connectEssencesPresenter.
	self connectAttributsPresenter.
	self connectQualitesPresenter
]

{ #category : 'initialization' }
SgBrowser >> connectQualitesPresenter [

	qualites
		transmitTo: code
		transform: [ :aQualite | aQualite ifNotNil: [ aQualite getDescription ] ifNil: [ '' ] ]
]

{ #category : 'initialization' }
SgBrowser >> connectSituationsPresenter [

	situations transmitTo: essences transform: [ :aSituation |
		aSituation
			ifNotNil: [ aSituation getEssences asArray ]
			ifNil: [ #(  ) ] ].

	situations transmitTo: code transform: [ :aSituation |
		aSituation isNil
			ifFalse: [ aSituation getDescription ]
			ifTrue: [ '' ] ]
]

{ #category : 'layout' }
SgBrowser >> defaultLayout [

	| situationsLayout essencesLayout qualitesLayout attributsLayout |
	situationsLayout := SpBoxLayout newTopToBottom
		add: 'Situations' expand: false;
		add: situations;
		yourself.
	
	essencesLayout := SpBoxLayout newTopToBottom
		add: 'Essences' expand: false;
		add: essences;
		yourself.
		
	attributsLayout := SpBoxLayout newTopToBottom
		add: 'Attributs' expand: false;
		add: attributs;
		yourself.
		
	qualitesLayout := SpBoxLayout newTopToBottom
		add: 'Qualités' expand: false;
		add: qualites;
		yourself.
		
	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: situationsLayout;
			add: essencesLayout;
			add: attributsLayout;
			add: qualitesLayout;
			yourself);	
		add: code height: 30;
		yourself
]

{ #category : 'acces' }
SgBrowser >> getEssences [
^essences
]

{ #category : 'acces' }
SgBrowser >> getSituations [
^situations
]

{ #category : 'initialization' }
SgBrowser >> initializeAttributsPresenter [

	| icon |
	attributs := self newList.
	attributs
		display: [ :attribut |
			attribut isSituation ifTrue: [' ' , attribut name  ] 
			ifFalse: [  
			attribut getSituationDefinition isSituation
				ifTrue: [ ' ' , attribut name ]
				ifFalse: [
					' ' , attribut name , ' de '
					, attribut getSituationDefinition printString ]] ];
		displayIcon: [ :essence |
			essence isSituation ifTrue: [ icon := Smalltalk ui icons iconNamed: #greenCircleIcon]
			ifFalse: [ 
			essence isQualite
				ifTrue: [
					essence isEssentielle
						ifTrue: [ icon := Smalltalk ui icons iconNamed: #redCircleIcon ]
						ifFalse: [
							icon := Smalltalk ui icons iconNamed: #yellowCircleIcon ] ]
				ifFalse: [
					(essences items includes: essence getSituationDefinition)
						ifTrue: [ icon := Smalltalk ui icons iconNamed: #blueCircleIcon ]
						ifFalse: [
							icon := Smalltalk ui icons iconNamed: #purpleCircleIcon ]] ]. icon ];
					whenActivatedDo: [ :selection | selection selectedItem inspect ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : 'initialization' }
SgBrowser >> initializeCodePresenter [

	code := self newLabel 
]

{ #category : 'initialization' }
SgBrowser >> initializeEssencesPresenter [


	| icon |
	essences := self newList.
	essences
		display: [ :essence | ' ', essence name ];		
		displayIcon: [ :essence |
			essence isQualite
				ifTrue: [
					essence isEssentielle
						ifTrue: [ icon := Smalltalk ui icons iconNamed: #redCircleIcon ]
						ifFalse: [ icon := Smalltalk ui icons iconNamed: #yellowCircleIcon ] ]
				ifFalse: [
					icon := Smalltalk ui icons iconNamed: #blueCircleIcon ].
			icon ];
			whenActivatedDo: [ :selection | 
			selection selectedItem inspect ];
		sortingBlock: [ :a :b | a name < b name ]
	
]

{ #category : 'initialization' }
SgBrowser >> initializePresenters [

	self initializeSituationsPresenter.
	self initializeEssencesPresenter.
	self initializeAttributsPresenter.
	self initializeQualitesPresenter.
	self initializeCodePresenter
]

{ #category : 'initialization' }
SgBrowser >> initializeQualitesPresenter [

| icon |

	qualites := self newList.
	qualites
		display: [ :qualite | ' ', qualite  name ];
				displayIcon: [ :essence | 
			essence isQualite
				ifTrue: [
					essence isEssentielle
						ifTrue: [ icon := Smalltalk ui icons iconNamed: #redCircleIcon ]
						ifFalse: [ icon := Smalltalk ui icons iconNamed: #yellowCircleIcon ] ]
				ifFalse: [
					icon := Smalltalk ui icons iconNamed: #blueCircleIcon ].
			icon ];

		whenActivatedDo: [ :selection | selection selectedItem inspect ];
		sortingBlock: [ :a :b | a name < b name ]
]

{ #category : 'initialization' }
SgBrowser >> initializeSituationsPresenter [

	situations := self newTreeTable.
	situations
		addColumn: (SpCompositeTableColumn new
				 addColumn: ((SpImageTableColumn evaluated: [ :aSituation |
							   Smalltalk ui icons iconNamed: #open ])
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #name);
				 yourself);
		roots: { (Smalltalk at: #absolu) };
		children: [ :aSituation | aSituation getSituationsGeneriques ];
		whenActivatedDo: [ :selection | 
			selection selectedItem inspect ]
]

{ #category : 'initialization' }
SgBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Niveau générique';
		initialExtent: 800 @ 250
]
