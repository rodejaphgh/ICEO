"
Browser au niveau individuel d'ICEO
"
Class {
	#name : 'SiBrowser',
	#superclass : 'SpPresenter',
	#instVars : [
		'situations',
		'etres',
		'attributs',
		'etats',
		'code'
	],
	#category : 'ICEO',
	#package : 'ICEO'
}

{ #category : 'showing' }
SiBrowser class >> open [ 
	<script>
	
	^ self new open
]

{ #category : 'initialization' }
SiBrowser >> connectAttributsPresenter [

	attributs
		transmitTo: code
		transform: [ :aAttribut | aAttribut ifNotNil: [ aAttribut getDescription ] ifNil: [ '' ] ]
]

{ #category : 'initialization' }
SiBrowser >> connectEtatsPresenter [

	etats
		transmitTo: code
		transform: [ :anEtat | anEtat ifNotNil: [ anEtat getDescription ] ifNil: [ '' ] ]
]

{ #category : 'initialization' }
SiBrowser >> connectEtresPresenter [

	etres
		transmitTo: attributs
		transform: [ :anEtre | 
			anEtre
				ifNotNil: [anEtre getAllEtresAttributs asArray]
				ifNil: [ #(  ) ] ].
		
	etres
		transmitTo: etats
		transform: [ :anEtre | 
			anEtre
				ifNotNil: [anEtre getEtats asArray]
				ifNil: [ #(  ) ] ].
	
	etres
		transmitTo: code
		transform: [ :anEtre | anEtre ifNotNil: [ anEtre getDescription ] ifNil: [ '' ] ]
]

{ #category : 'initialization' }
SiBrowser >> connectPresenters [

	self connectSituationsPresenter.
	self connectEtresPresenter.
	self connectAttributsPresenter.
	self connectEtatsPresenter
]

{ #category : 'initialization' }
SiBrowser >> connectSituationsPresenter [

	situations
		transmitTo: etres
		transform: [ :aSituation | 
			aSituation
				ifNotNil: [ aSituation getEtres asArray ] 
				ifNil: [ #(  ) ] ].

	situations
		transmitTo: code
		transform: [ :aSituation | aSituation getDescription ]
]

{ #category : 'layout' }
SiBrowser >> defaultLayout [

	| situationsLayout etresLayout etatsLayout attributsLayout |
	situationsLayout := SpBoxLayout newTopToBottom
		add: 'Situations' expand: false;
		add: situations;
		yourself.
	
	etresLayout := SpBoxLayout newTopToBottom
		add: 'Etres' expand: false;
		add: etres;
		yourself.
		
	attributsLayout := SpBoxLayout newTopToBottom
		add: 'Attributs' expand: false;
		add: attributs;
		yourself.
		
	etatsLayout := SpBoxLayout newTopToBottom
		add: 'Etats' expand: false;
		add: etats;
		yourself.
		
	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpBoxLayout newLeftToRight
			spacing: 5;
			add: situationsLayout;
			add: etresLayout;
			add: attributsLayout;
			add: etatsLayout;
			yourself);	
		add: code height: 30;
		yourself
]

{ #category : 'initialization' }
SiBrowser >> initializeAttributsPresenter [

	| icon |
	attributs := self newList.
	attributs
		display: [ :attribut |
			attribut getSituationDefinition isSituation
				ifTrue: [
					attribut isEtat
						ifTrue: [
							attribut getEtant isEtat
								ifTrue: [
									' (' , attribut getEtant getEtant getNom , ') '
									, attribut getNom ]
								ifFalse: [
									' (' , attribut getEtant getNom , ') ' , attribut getNom ] ]
						ifFalse: [ ' ' , attribut getNom ] ]
				ifFalse: [' ', 
					attribut getNom  ] ];
		displayIcon: [ :attribut |
			attribut isEtat
				ifTrue: [
					attribut class isEssentielle
						ifTrue: [
							icon := Smalltalk ui icons iconNamed: #redTriangleIcon ]
						ifFalse: [
							icon := Smalltalk ui icons iconNamed: #yellowTriangleIcon ] ]
				ifFalse: [
					attribut getSituationDefinition isSituation
						ifTrue: [
							icon := Smalltalk ui icons iconNamed: #purpleTriangleIcon ]
						ifFalse: [
							icon := Smalltalk ui icons iconNamed: #blueTriangleIcon ] ].
			icon ];
		whenActivatedDo: [ :selection | selection selectedItem inspect ];
		sortingBlock: [ :a :b | a getNom < b getNom ] 
]

{ #category : 'initialization' }
SiBrowser >> initializeCodePresenter [

	code := self newLabel
]

{ #category : 'initialization' }
SiBrowser >> initializeEtatsPresenter [

| icon |

	etats := self newList.
	etats
		display: [ :etat | ' ', etat  getNom ];
		displayIcon: [ :etre |
			etre isEtat   
				ifTrue: [
					etre class isEssentielle
						ifTrue: [ icon := Smalltalk ui icons iconNamed: #redTriangleIcon ] 
						ifFalse: [ icon := Smalltalk ui icons iconNamed: #yellowTriangleIcon]]
			ifFalse: [ icon := Smalltalk ui icons iconNamed: #blueTriangleIcon]. 
			icon]; 
			whenActivatedDo: [ :selection | 
			selection selectedItem inspect ];
		sortingBlock: [ :a :b | a getNom < b getNom ]
]

{ #category : 'initialization' }
SiBrowser >> initializeEtresPresenter [

	| icon |
	etres := self newList.
	etres
		display: [ :etre |
			etre isEtat
				ifTrue: [
					etre getEtant isEtat
						ifTrue: [
							' (' , etre getEtant getEtant getNom , ') ' , etre getNom ]
						ifFalse: [ ' (' , etre getEtant getNom , ') ' , etre getNom ] ]
				ifFalse: [ ' ' , etre getNom ] ];
		displayIcon: [ :etre |
			etre isEtat
				ifTrue: [
					etre class isEssentielle
						ifTrue: [
							icon := Smalltalk ui icons iconNamed: #redTriangleIcon ]
						ifFalse: [
							icon := Smalltalk ui icons iconNamed: #yellowTriangleIcon ] ]
				ifFalse: [
					icon := Smalltalk ui icons iconNamed: #blueTriangleIcon ].
			icon ];
		whenActivatedDo: [ :selection | selection selectedItem inspect ];
		sortingBlock: [ :a :b | a getNom < b getNom ]
]

{ #category : 'initialization' }
SiBrowser >> initializePresenters [

	self initializeSituationsPresenter.
	self initializeEtresPresenter.
	self initializeAttributsPresenter.
	self initializeEtatsPresenter.
	self initializeCodePresenter
]

{ #category : 'initialization' }
SiBrowser >> initializeSituationsPresenter [

	situations := self newTreeTable.
	situations
		addColumn: (SpCompositeTableColumn new
				 addColumn: ((SpImageTableColumn evaluated: [ :aSituation |
							   Smalltalk ui icons iconNamed: #open ])
						  width: 20;
						  yourself);
				 addColumn: (SpStringTableColumn evaluated: #getNom);
				 yourself);
		roots: { (Smalltalk at: #monde) };
		children: [ :aSituation | aSituation getSituations ];
		whenActivatedDo: [ :selection | 
			selection selectedItem inspect ]
]

{ #category : 'initialization' }
SiBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Niveau individuel';
		initialExtent: 800 @ 250
]
