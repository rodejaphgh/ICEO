"
""superclass de toutes les essences et situations dans ICEO""
"
Class {
	#name : 'Essence',
	#superclass : 'Etre',
	#instVars : [
		'structure',
		'situationDefinition',
		'isSituation',
		'isEtat',
		'etats',
		'etant',
		'nom',
		'id',
		'description'
	],
	#classInstVars : [
		'differentia',
		'isQualite',
		'isIndividu',
		'isPrototype',
		'statut',
		'effectivite',
		'qualites',
		'essencesQualifiees',
		'metaEssence'
	],
	#category : 'ICEO',
	#package : 'ICEO'
}

{ #category : 'qualites' }
Essence class >> associationQualite: uneQualite [
	"association binaire et bidirectionnellle de self et de uneQualite"

	self isQualite ifFalse: [
		Oups new signal: self getNom , ' n''est pas une qualité' ].
	uneQualite isQualite ifFalse: [
		Oups new signal: uneQualite getNom , ' n''est pas une qualité' ].
	self getDifferentia add: uneQualite.
	" attribution corrélative, sauf s'il s'agit d'une qualite de self. Par exemple, être soeur pour une soeur ... "
	self == uneQualite ifFalse: [ uneQualite getDifferentia add: self ]
]

{ #category : 'utile' }
Essence class >> createFreeSubclass: aSymbol [

	| newClass |
	"not installed in the system"
	newClass := self newAnonymousSubclass setName: aSymbol.
	subclasses isNil
		ifTrue: [ self subclasses: (Array with: newClass) ]
		ifFalse: [ self subclasses: (subclasses copyWith: newClass) ].
	newClass setNom: aSymbol.
	^ newClass
]

{ #category : 'methodes' }
Essence class >> est: uneQualite [
	uneQualite isQualite ifFalse: [
		Oups new signal: uneQualite , ' n''est pas une qualité' ].
	uneQualite getStatut == #essentielle ifFalse: [
		Oups new signal:
			uneQualite , ' n''est pas une qualité essentielle' ].
	qualites isNil ifTrue: [ qualites := OrderedCollection new ].
	qualites add: uneQualite.
	uneQualite getEssencesQualifiees add: self
]

{ #category : 'situations' }
Essence class >> get: unStringOrSymbol [ 
	"retourne l'essence unStringOrSymbol incluse dans une situation"
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	^self getElement: unStringOrSymbol

]

{ #category : 'methodes' }
Essence class >> getAllGenus [
	| c |
	(self name == #Essence
			or: [self name == #absolu])
		ifTrue: [^ OrderedCollection new].
	c := OrderedCollection with: self.
	self name == #chose
		ifFalse: [c addAll: self getGenus getAllGenus].
	^ c
]

{ #category : 'methodes' }
Essence class >> getAllGenusWithoutMe [

	^ self getAllGenus copyWithout: self
	
]

{ #category : 'acces' }
Essence class >> getAttribut: unStringOrSymbol [
	| attributs symbole |
	symbole := unStringOrSymbol isSymbol
		           ifTrue: [ unStringOrSymbol ]
		           ifFalse: [ unStringOrSymbol asSymbol ].
	attributs := self getAttributs select: [ :each |
		             each key name == symbole ].
	attributs size == 0 ifTrue: [
		self getAttributs do: [ :each |
			each key getAllGenus do: [ :sup |
				sup name == symbole ifTrue: [ attributs add: each ] ] ] ].
	attributs size == 0 ifTrue: [
		Oups new signal:
			self name , ' ne possède pas d''attribut de nom ' , symbole
			, '  ou subsumé par ' , symbole ].
	attributs size > 1 ifTrue: [
		Oups new signal:
			self name , ' possède ' , attributs size printString
			, ' attributs de nom ' , symbole , '  ou subsumés par ' , symbole ].
	^ attributs at: 1 
]

{ #category : 'acces' }
Essence class >> getAttributs [
	"attributs (instances d'Association) propres et hérités mais non surchargées pour une essence"
	| attributs temp |
	self isSituation ifTrue: [
		Oups new signal:
			'la méthode getAttributs ne s''applique qu''à une essence' ].
	attributs := OrderedCollection new.

	((self ~~ Essence and: [ self ~~ (Smalltalk at: #chose) ]) and: [ superclass ~~ (Smalltalk at: #chose)]) 
		ifTrue: [ attributs addAll: superclass getAttributs ].

	self getDifferentia do: [ :each |
		each class name == #Association ifTrue: [ attributs add: each ] ].
	"ne garder que les attributs non surchargés"
	temp := OrderedCollection new.
	attributs do: [ :each | temp add: each ].
	attributs do: [ :each |
		attributs do: [ :att |
			(att key getAllGenusWithoutMe includes: each key) ifTrue: [
				temp remove: each ifAbsent: [  ] ] ] ].
	^ temp 
]

{ #category : 'acces' }
Essence class >> getDifferentia [
	"retourne l'ensemble des attributs propres"
	differentia isNil ifTrue: [ differentia := OrderedCollection new] .
	^ differentia
]

{ #category : 'qualites' }
Essence class >> getEffectivite [
	effectivite isNil ifTrue: [effectivite := #intermittente].
	^effectivite
]

{ #category : 'situations' }
Essence class >> getElement: unStringOrSymbol [
	"retourne l'essence unStringOrSymbol incluse dans une situation"

	| n |
	self isSituation ifFalse: [
		Oups new signal:
			'la méthode getEssence: ne s''applique qu''à une situation' ].
	n := unStringOrSymbol isSymbol
		     ifTrue: [ unStringOrSymbol ]
		     ifFalse: [ unStringOrSymbol asSymbol ].
	^ differentia
		  detect: [ :each | each name == n and: [ each isSituation not ] ]
		  ifNone: [
			  Oups new signal:
				  'essence ' , n , ' non trouvée dans la situation ' , self name ] 
]

{ #category : 'situations' }
Essence class >> getElements [
	"retourne l'ensemble des éléments inclus dans une situation générique"
	self isSituation
		ifTrue: [ ^ self getDifferentia ]
		ifFalse: [
			Oups new signal:
				'la méthode getElements ne s''applique qu''à une situation' ] 
]

{ #category : 'situations' }
Essence class >> getElements: uneEssence [
	"retourne l'ensemble des éléments inclus dans une situation  qui sont subsumés par uneEssence"

	self isSituation
		ifTrue: [
		^ self getDifferentia select: [ :each | uneEssence subsume: each ] ]
		ifFalse: [
			Oups new signal:
				'la méthode getElements ne s''applique qu''à une situation' ] 
]

{ #category : 'acces' }
Essence class >> getEssence [
	"par défaut, l'essence d'une essence est l'essence chose"
	metaEssence == nil
		ifTrue: [metaEssence := Smalltalk at: #chose].
	^ metaEssence
	
]

{ #category : 'acces' }
Essence class >> getEssenceAttribut: unStringOrSymbol [

	| attributs symbole |
	symbole := unStringOrSymbol isSymbol
		           ifTrue: [ unStringOrSymbol ]
		           ifFalse: [ unStringOrSymbol asSymbol ].
	attributs := self getEssencesAttributs select: [ :each |
		             each name == symbole ].
	attributs size == 0 ifTrue: [
		self getEssencesAttributs do: [ :each |
			each getAllGenus do: [ :sup |
				sup name == symbole ifTrue: [ attributs add: each ] ] ] ].
	attributs size == 0 ifTrue: [
		Oups new signal:
			self name , ' ne possède pas d''attribut de nom ' , symbole
			, '  ou subsumé par ' , symbole ].
	attributs size > 1 ifTrue: [
		Oups new signal:
			self name , ' possède ' , attributs size printString
			, ' attributs de nom ' , symbole , '  ou subsumés par ' , symbole ].
	^ attributs at: 1 
]

{ #category : 'situations' }
Essence class >> getEssences [
	" pour une situation "
	^self getElements select: [:each | each isSituation not]

]

{ #category : 'acces' }
Essence class >> getEssencesAttributs [

| col |

	col := self getAttributs collect: [:each | each key ].
	self isQualite ifTrue: [col addAll: self getQualitesAssociees].
	^col 
]

{ #category : 'acces' }
Essence class >> getEssencesAttributs: unStringOrSymbol [

	| attributs symbole |
	symbole := unStringOrSymbol isSymbol
		           ifTrue: [ unStringOrSymbol ]
		           ifFalse: [ unStringOrSymbol asSymbol ].
	attributs := self getEssencesAttributs select: [ :each |
		             each name == symbole ].
	attributs size == 0 ifTrue: [
		self getEssencesAttributs do: [ :each |
			each allSuperclasses do: [ :sup |
				sup name == symbole ifTrue: [ attributs add: each ] ] ] ].
	attributs size == 0 ifTrue: [
		Oups new signal:
			self name , ' ne possède pas d''attribut de nom ' , symbole ].
	^ attributs
]

{ #category : 'qualites' }
Essence class >> getEssencesQualifiees [
	essencesQualifiees isNil ifTrue: [essencesQualifiees := OrderedCollection new].	
 	^essencesQualifiees
]

{ #category : 'acces' }
Essence class >> getGenus [
	^ name == #chose
		ifTrue: [self]
		ifFalse: [superclass]
]

{ #category : 'methodes' }
Essence class >> getInstance: unStringOrSymbol [ 
	"création d'un être hypothétique instance de self "
	| symbol etre |
	symbol := unStringOrSymbol isSymbol
				ifTrue: [unStringOrSymbol]
				ifFalse: [unStringOrSymbol asSymbol].
	etre := self new.
	etre setNom: symbol.
	etre isSituation: false.
	etre isEtat: false.
	^etre

		

]

{ #category : 'qualites' }
Essence class >> getQualite: unStringOrSymbol [
	"retourne l'essence unStringOrSymbol incluse dans les qualités d'une essence "

	| n |
	n := unStringOrSymbol isSymbol
		     ifTrue: [ unStringOrSymbol ]
		     ifFalse: [ unStringOrSymbol asSymbol ].
	^ self getQualites detect: [ :each | each name == n ] ifNone: [
		  Oups new signal:
			  'qualité ' , unStringOrSymbol , ' non trouvée pour ' , name ] 
]

{ #category : 'qualites' }
Essence class >> getQualites [
	"qualités propres et héritées mais non surchargées pour une essence"

	| me temp |
"	self isSituation ifTrue: [
		Oups new signal:
			'la méthode getQualites ne s''applique qu''à une essence' ]."
	qualites isNil ifTrue: [ qualites := OrderedCollection new ].
	me := qualites collect: [ :each | each ].
	superclass == (Smalltalk at: #Essence) ifFalse: [
		me addAll: superclass getQualites ].
	"ne garder que les qualites non surchargées"
	temp := me collect: [ :each | each ].
	me do: [ :each |
		me do: [ :q |
			(q getAllGenusWithoutMe includes: each) ifTrue: [
				temp remove: each ifAbsent: [  ] ] ] ].
	^ temp 
]

{ #category : 'qualites' }
Essence class >> getQualitesAssociees [

	| attributs temp |
	(self isSituation or: [ self isQualite not ]) ifTrue: [
		Oups new signal:
			'la méthode getQualitesAssociees ne s''applique qu''à une qualité' ].
	attributs := OrderedCollection new.

	(self ~~ Essence and: [ superclass ~~ (Smalltalk at: #chose) ])
		ifTrue: [ attributs addAll: superclass getQualitesAssociees ].

	self getDifferentia do: [ :each |
		each class name ~~ #Association ifTrue: [ attributs add: each ] ].
	"ne garder que les attributs non surchargés"
	temp := OrderedCollection new.
	attributs do: [ :each | temp add: each ].
	attributs do: [ :each |
		attributs do: [ :att |
			(att getAllGenusWithoutMe includes: each) ifTrue: [
				temp remove: each ifAbsent: [  ] ] ] ].
	^ temp 
]

{ #category : 'qualites' }
Essence class >> getQualitesPropres [

	self isSituation ifTrue: [
		Oups new signal:
			'la méthode getQualites ne s''applique qu''à une essence' ].
	qualites isNil ifTrue: [ qualites := OrderedCollection new ].
	^ qualites 
]

{ #category : 'situations' }
Essence class >> getSituationGenerique: unStringOrSymbol [
	"retourne la situation unStringOrSymbol incluse dans une situation"

	| n env |
	self isSituation ifFalse: [
		Oups new signal:
			'la méthode getEssences: ne s''applique qu''à une situation' ].
	n := unStringOrSymbol isSymbol
		     ifTrue: [ unStringOrSymbol ]
		     ifFalse: [ unStringOrSymbol asSymbol ].
	env := self getDifferentia collect: [ :each | each value ].
	^ env
		  detect: [ :each |
			  each name == n and: [ each isBehavior and: [ each isSituation ] ] ]
		  ifNone: [
			  Oups new signal:
				  'situation ' , n , ' non trouvée dans la situation ' , self name ] 
]

{ #category : 'situations' }
Essence class >> getSituationsGeneriques [
	"pour une situation"

	| situations |
	self isSituation ifFalse: [
		Oups new signal:
			'la méthode getSituations ne s''applique qu''à une situation' ].
	situations := OrderedCollection new.
	self getDifferentia do: [ :each |
		each isSituation ifTrue: [ situations add: each ] ].
	^ situations 
]

{ #category : 'qualites' }
Essence class >> getStatut [
	statut isNil ifTrue: [statut := #accidentelle].
	^statut
]

{ #category : 'methodes' }
Essence class >> isChose [
	^ self getAllGenus
		detect: [:each | each name == #chose]
		ifFound: [:x | true]
		ifNone: [false]
]

{ #category : 'qualites' }
Essence class >> isEssentielle [
	statut isNil ifTrue: [^false].
	^self getStatut == #essentielle  
]

{ #category : 'acces' }
Essence class >> isIndividu [

	isIndividu isNil ifTrue: [
		((self isSituation or: [ self isQualite ]) or: [
			 self getSituationDefinition isSituation not ])
			ifTrue: [ isIndividu := false ]
			ifFalse: [ isIndividu := true ] ].
	^ isIndividu
]

{ #category : 'acces' }
Essence class >> isIndividu: aBoolean [
"true par défaut"
 isIndividu := aBoolean

]

{ #category : 'acces' }
Essence class >> isPrototype [
	isPrototype == nil ifTrue: [isPrototype := false].
 ^isPrototype
]

{ #category : 'acces' }
Essence class >> isPrototype: aBoolean [

	isPrototype := aBoolean
]

{ #category : 'qualites' }
Essence class >> isQualite [
 isQualite isNil ifTrue: [isQualite := false].
^isQualite
]

{ #category : 'qualites' }
Essence class >> isQualite: aBoolean [

	isQualite := aBoolean
]

{ #category : 'qualites' }
Essence class >> peutEtre: uneQualite [

	uneQualite isQualite ifFalse: [
		Oups new signal: uneQualite getNom , ' n''est pas une qualité' ].
	qualites isNil ifTrue: [ qualites := OrderedCollection new ].
	qualites add: uneQualite.
	uneQualite getEssencesQualifiees add: self 
]

{ #category : 'methodes' }
Essence class >> referenceEssence: uneEssence [ 
	"ne change pas la situation de définition de l'essence"
	self referenceEssence: uneEssence cardinalite: nil
]

{ #category : 'methodes' }
Essence class >> referenceEssence: uneEssence cardinalite: anInteger [
	"ne change pas la situation de définition de une essence"

	(self getDifferentia includes: uneEssence getNom)
		ifTrue: [
			Oups new signal:
				'une essence de nom ' , uneEssence , ' est déjà présente dans '
				, self getNom ]
		ifFalse: [
			self getDifferentia add:
				(Association key: uneEssence value: anInteger) ] 
]

{ #category : 'qualites' }
Essence class >> setEffectivite: unSymbole [
	effectivite := (OrderedCollection with: #permanente  with: #intermittente) detect: [:i | i = unSymbole]

]

{ #category : 'acces' }
Essence class >> setMetaEssence: uneEssence [
	metaEssence := uneEssence
]

{ #category : 'qualites' }
Essence class >> setStatut: unSymbole [ 
	statut := (OrderedCollection with: #accidentelle with: #essentielle)
				detect: [:i | i = unSymbole]
]

{ #category : 'methodes' }
Essence class >> specialise: uneEssence [ 
	^self allSuperclasses includes: uneEssence  
	
	



]

{ #category : 'methodes' }
Essence class >> subsume: uneEssence [ 
	self == uneEssence
		ifTrue: [^ true].
	(uneEssence getNom == #chose or: [uneEssence name == #Essence ] )
		ifTrue: [^ false].
	^ self subsume: uneEssence getGenus
]

{ #category : 'etats' }
Essence >> affecteEtat: uneQualite dansSituation: uneSituationIndividuelle [
	| etat |
	uneQualite isQualite ifFalse: [
		Oups new signal: uneQualite , 'n''est pas une qualité' ].
	uneQualite getSituationDefinition
	== uneSituationIndividuelle getEssence ifFalse: [
		Oups new signal:
			uneSituationIndividuelle , ' n''est pas instance de '
			, uneQualite getSituationDefinition ].
	self getEssence getQualites
		detect: [ :each | each subsume: uneQualite ]
		ifNone: [
		Oups new signal: self getNom , ' ne peut être ' , uneQualite getNom].   
	etat := uneQualite new.
	self getEtats add: etat.
	etat setEtant: self.
	etat isEtat: true.
	etat isSituation: false.
	uneSituationIndividuelle introductionEtre: etat.
	etat setSituationDefinition: uneSituationIndividuelle.
	"par défaut"
	etat setNom: uneQualite getNom.
	etat setDescription:
		self getNom printString , ' addEtat: '
		, uneQualite getNom printString , ' dansSituation: '
		, uneSituationIndividuelle getNom printString.
	Smalltalk at: #sib ifPresent: [ :x | x window close ].
	^etat 
]

{ #category : 'etats' }
Essence >> affecteEtatEssentiel: uneQualite [
	| etat |
	uneQualite isQualite ifFalse: [
		Oups new signal: uneQualite , 'n''est pas une qualité' ].
	self getEssence getQualites
		detect: [ :each | each subsume: uneQualite ]
		ifNone: [
		Oups new signal: self getNom , ' ne peut être ' , uneQualite getNom].
	uneQualite isEssentielle  ifFalse: [
		Oups new signal: uneQualite , 'n''est pas essentielle' ].
	etat := uneQualite new.
	self getEtats add: etat.
	etat setEtant: self.
	etat isEtat: true.
	etat isSituation: false.
	etat setSituationDefinition: self.
	"par défaut"
	etat setNom: uneQualite getNom.
	etat setDescription: self getNom printString , ' addEtatEssentiel: '
		, uneQualite getNom printString.
	Smalltalk at: #sib ifPresent: [ :x | x window close ] 
]

{ #category : 'etats' }
Essence >> associationEtat: unEtat [
	"association bidirectionnellle de self et de unEtat"

	self isEtat ifFalse: [
		Oups new signal: self getNom , ' n''est pas un   état' ].
	unEtat isEtat ifFalse: [
		Oups new signal: unEtat getNom , ' n''est pas un état' ].
	self getEssence getDifferentia
		detect: [ :each | each == unEtat getEssence ]
		ifNone: [
			Oups new signal:
				'Association entre ' , self getNom , ' et ' , unEtat getNom
				, ' non prévue' ].
	self getStructure add: unEtat.
	unEtat getStructure add: self
]

{ #category : 'acces' }
Essence >> attributionEtre: unEtre [
	" change la situation de définition de unEtre.
	cas du montage d'une pièce démontée d'un autre être  "  

	self getEssence getEssencesAttributs
		detect: [ :each | each subsume: unEtre getEssence ]
		ifFound: [ :a |
			(self getStructure includes: unEtre)
				ifTrue: [
					Oups new signal:
						'un être ' , unEtre , ' est déjà présente dans ' , self getNom ]
				ifFalse: [
					self getStructure add: unEtre.
					unEtre setSituationDefinition: self ] ]
		ifNone: [
			Oups new signal:
				unEtre getEssence getNom , ' non définie pour l''essence '
				, self getEssence getNom ] 
]

{ #category : 'acces' }
Essence >> attributionEtre: unStringOrSymbol essence: uneEssence [
	"Il faudra vérifier qu'il est prévu au niveau de l'essence de self d'avoir un attribut ayant comme essence uneEssence  "

	| symbol attribut c n |
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
	structure isNil ifTrue: [ structure := OrderedCollection new ].
	structure
		detect: [ :each |
		each getNom == nom and: [ each getEssence == uneEssence ] ]
		ifFound: [ :x |
			Oups new signal:
				'un être nommé ''' , x getNom , ' d''essence ' , uneEssence getNom
				, ' est déjà attribut de ' , self getNom ].

	attribut := uneEssence new.
	attribut setNom: symbol.
	attribut isSituation: false.
	structure add: attribut.
	attribut setSituationDefinition: self.
	uneEssence isIndividu ifTrue: [
		uneEssence getAttributs do: [ :each |
			c := each value.
			(c notNil and: [ c > 0 ]) ifTrue: [
				(1 to: c) do: [ :x |
					n := (Smalltalk at: #ICEO) genSym: each key getNom.
					attribut attributionEtre: n essence: each key ] ] ] ].
	attribut class getQualites do: [ :each |
		(each getStatut == #essentielle and: [
			 each getEffectivite == #permanente ]) ifTrue: [
			attribut affecteEtatEssentiel: each ] ].
	attribut setDescription:
		self getNom printString , ' attributionEtre ' , unStringOrSymbol
		, ' essence: ' , uneEssence getNom printString.
	Smalltalk at: #sib ifPresent: [ :x | x window close ] 
]

{ #category : 'acces' }
Essence >> get: unStringOrSymbol [
	"pour une situation"

	"retourne, s'il existe, l'etre trouvé"

	| symbol etres |
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
	etres := self getStructure select: [ :each | each getNom == symbol ].
	etres size == 0 ifTrue: [
		Oups new signal:
			'être de nom' , symbol , ' non trouvé dans la situation '
			, self getNom ].
	etres size > 1 ifTrue: [
		etres := self getStructure select: [ :each |
			         each getNom == symbol and: [ each getEtats size == 0 ] ].
		etres size == 0 ifTrue: [
			Oups new signal: 'aucun être sans état de nom ' , symbol
				, ' ne se trouve dans la situation ' , self getNom ] ].
	etres size > 1 ifTrue: [
		Oups new signal:
			etres size printString , ' êtres de nom ' , symbol
			, ' se trouvent dans la situation ' , self getNom ].
	^ etres at: 1 
]

{ #category : 'acces' }
Essence >> get: unStringOrSymbol quiEst: uneQualite [
	"pour une situation"

	"retourne, s'il existe avec la qualité uneQualité, l'etre trouvé"

	| symbol etres |
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
	etres := self getStructure select: [ :each |
		         each getNom == symbol and: [
			         (each getEtat: uneQualite getNom) notNil ] ].
	etres size == 0 ifTrue: [
		Oups new signal:
			'être de nom' , symbol , ' non trouvé dans la situation '
			, self getNom ].
	etres size > 1 ifTrue: [
		Oups new signal:
			etres size printString , ' êtres de nom ' , symbol
			, ' se trouvent dans la situation ' , self getNom ].
	^ etres at: 1 
]

{ #category : 'acces' }
Essence >> getAllEtresAttributs [

	| ee attributs |
	"retourne les attributs propres de self et acquis dans ses états"
	attributs := self getEtresAttributs.
	ee := self getEtats.
	ee do: [ :each |
		each getEtresAttributs do: [ :x |
			x isEtat
				ifTrue: [ x getEtant notNil ifTrue: [ attributs add: x getEtant ] ]
				ifFalse: [ "x est un être attribut d'un état" attributs add: x ] ].
		each getEtats do: [ :other |
			other getEtresAttributs do: [ :y |
				y isEtat
					ifTrue: [
						y getEtant notNil ifTrue: [
							y getEtant isEtat
								ifTrue: [
									y getEtant getEtant notNil ifTrue: [
										attributs add: y getEtant getEtant ] ]
								ifFalse: [ attributs add: y getEtant ] ] ]
					ifFalse: [ attributs add: y ] ] ] ].
	^ attributs
]

{ #category : 'acces' }
Essence >> getDescription [
	^description isNil ifTrue: ['tbd'] ifFalse: [ description ]
]

{ #category : 'situations' }
Essence >> getElements [
"pour une situation"
	structure isNil
		ifTrue: [structure := OrderedCollection new].
	^ structure
]

{ #category : 'situations' }
Essence >> getElementsEssence: uneEssence [
"pour une situation, retourne l'ensemble des êtres ayant uneEssence pour essence"
	^self getEtresAttributs select: [:each | each getEssence == uneEssence]   
]

{ #category : 'acces' }
Essence >> getEssence [
	^self class
]

{ #category : 'etats' }
Essence >> getEtant [
	^etant
]

{ #category : 'etats' }
Essence >> getEtat: unSymbole [ 
	| states |
	states := etats
				select: [:each | each getNom == unSymbole].
	states size == 0
		ifTrue: [^ nil].
	^ states  at: 1
]

{ #category : 'etats' }
Essence >> getEtat: unStringOrSymbol dansSituation: uneSituation [ 
	|  e etre symbol |
	symbol := unStringOrSymbol isSymbol
				ifTrue: [unStringOrSymbol]
				ifFalse: [unStringOrSymbol asSymbol].
	e := self getEtats.
	etre := e
				detect: [:each | (each getEssence getNom == symbol
						and: [each isEtat])
						and: [uneSituation getElements includes: each]].
	^ etre
]

{ #category : 'etats' }
Essence >> getEtatEssence: uneEssence [
	| states |
	states := etats
				select: [:each | uneEssence subsume: each getEssence].
	states size == 0
		ifTrue: [^ nil].
	^ states  at: 1
]

{ #category : 'etats' }
Essence >> getEtats [
	etats isNil ifTrue: [etats := OrderedCollection new].
	^etats
]

{ #category : 'etats' }
Essence >> getEtats: unStringOrSymbol dansSituation: uneSituation [ 
	|  e states symbol |
	symbol := unStringOrSymbol isSymbol
				ifTrue: [unStringOrSymbol]
				ifFalse: [unStringOrSymbol asSymbol].
	e := self getEtats.
	states := e
				select: [:each | (each getEssence getNom == symbol
						and: [each isEtat])
						and: [uneSituation getElements includes: each]].
	^ states
]

{ #category : 'acces' }
Essence >> getEtreAttribut: unStringOrSymbol [

	| attributs etre symbol |
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
	attributs := self getEtresAttributs.
	attributs
		detect: [ :each |
			each getNom == symbol or: [ each getEssence getNom == symbol ] ]
		ifFound: [ :x | etre := x ]
		ifNone: [
			attributs do: [ :each |
				each getEssence getAllGenus do: [ :x |
					x getNom == symbol ifTrue: [ etre := each ] ] ] ].
	etre isNil ifTrue: [
		Oups new signal: 'attribut ' , symbol , ' non trouvé' ].
	^ etre
]

{ #category : 'acces' }
Essence >> getEtres [
"pour une situation"
	^self getElements select: [:each | each isSituation not]
]

{ #category : 'acces' }
Essence >> getEtresAttributs [

	| attributs |
	structure isNil ifTrue: [ structure := OrderedCollection new ].
	attributs := (OrderedCollection new , structure) select: [:each | each isSituation not].
	self getEssence name ~~ #chose ifTrue: [
		self getEssence getEtresAttributs do: [ :each |
			each getEssence isPrototype ifTrue: [ attributs add: each ] ] ].
	^ attributs
]

{ #category : 'acces' }
Essence >> getEtresAttributs: unStringOrSymbol [

	| attributs symbol |
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
	attributs := self getEtresAttributs
		select: [ :each |
			each getNom == symbol or: [ each getEssence getNom == symbol ] ].
	attributs size == 0 ifTrue: [
		Oups new signal: 'attribut ' , symbol , ' non trouvé' ].
	^ attributs
]

{ #category : 'acces' }
Essence >> getEtresAttributsEnTantQue: uneQualite [

	| ee attributs |
	attributs := OrderedCollection new.
	ee := self getEtats.
	ee do: [ :each |
		each getEssence == uneQualite ifTrue: [
			each getEtresAttributs do: [ :x |
				x isEtat
					ifTrue: [
					x getEtant notNil ifTrue: [ attributs add: x getEtant ] ]
					ifFalse: [ "x est un être attribut d'un état" attributs add: x ] ] ] ].
	^ attributs
]

{ #category : 'acces' }
Essence >> getEtresAttributsQuiSont: uneQualite [ 
	| attributs |
	attributs := OrderedCollection new.
	self getEtats 
		do: [:e |
			e getEtresAttributs
				do: [:ao | (ao getEssence == uneQualite
							or: [ao getEssence getGenus == uneQualite])
						ifTrue: [ao getEtant == nil
								ifFalse: [attributs add: ao getEtant]]].
			e getEtats
				do: [:ao | ao getEtresAttributs
						do: [:etat | (etat getEssence == uneQualite
									or: [etat getEssence getGenus == uneQualite])
								ifTrue: [etat getEtant == nil
										ifFalse: [attributs add: etat getEtant]]]]].
	^ attributs
]

{ #category : 'acces' }
Essence >> getId [
	" permet de différencier deux êtres de même nom"
	id isNil ifTrue: [id := ((Smalltalk at: #ICEO) genSym: nom)].
	^id
]

{ #category : 'acces' }
Essence >> getNom [
	^nom
]

{ #category : 'situations' }
Essence >> getSituation: unSymbole [ 
	"retourne, si elle existe, la première situation individuelle trouvée"
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	^ structure
		detect: [:each | each getNom == unSymbole asSymbol]
]

{ #category : 'situations' }
Essence >> getSituationDefinition [
	^situationDefinition
]

{ #category : 'situations' }
Essence >> getSituationGenerique [

	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	^self class
]

{ #category : 'situations' }
Essence >> getSituations [
	"pour une situation"

	| situations |
	self isSituation ifFalse: [
		Oups new signal:
			'la méthode getSituations ne s''applique qu''à une situation' ].
	situations := OrderedCollection new.
	self getStructure do: [ :each |
		each isSituation ifTrue: [ situations add: each ] ].
	^ situations 
]

{ #category : 'situations' }
Essence >> getSituations: unStringOrSymbol [
	"pour une situation"

	| situations symbol|
	self isSituation ifFalse: [
		Oups new signal:
			'la méthode getSituations ne s''applique qu''à une situation' ].
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
	situations := OrderedCollection new.
	self getStructure do: [ :each |
		(each isSituation and: [each getEssence getNom == symbol]) ifTrue: [ situations add: each ] ].
	^ situations 
]

{ #category : 'acces' }
Essence >> getStructure [
"pour un être"
	structure isNil
		ifTrue: [structure := OrderedCollection new].
	^ structure
]

{ #category : 'situations' }
Essence >> introductionEtre: unEtre [
"dans une situation"
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	structure isNil ifTrue: [structure := OrderedCollection new].
	structure add: unEtre
]

{ #category : 'acces' }
Essence >> isEtat [
	isEtat isNil ifTrue: [isEtat := false].
	^isEtat 
]

{ #category : 'acces' }
Essence >> isEtat: aBoolean [
	isEtat := aBoolean
]

{ #category : 'acces' }
Essence >> isGenerique [
	^false
]

{ #category : 'acces' }
Essence >> isSituation [
	^isSituation
]

{ #category : 'acces' }
Essence >> isSituation: aBoolean [
	isSituation := aBoolean
]

{ #category : 'printing' }
Essence >> printOn: aStream [ 
	aStream nextPutAll: self getNom
]

{ #category : 'etats' }
Essence >> removeEtat: unEtat [
	
	self getEtats remove: unEtat.
	unEtat getSituationDefinition removeEtre: unEtat

]

{ #category : 'etats' }
Essence >> removeEtatDeNom: unStringOrSymbol [

	| symbol |
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
	self getEtats
		detect: [ :each | each getNom == symbol ]
		ifFound: [ :element | self removeEtat: element ]
		ifNone: [
			"Oups new signal:
				self getNom , ' ne possède pas d''état de nom ' , unStringOrSymbol" ]
]

{ #category : 'acces' }
Essence >> removeEtre: unEtre [
	"dans une situation"
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	self getStructure remove: unEtre

]

{ #category : 'acces' }
Essence >> removeEtreDeNom: unStringOrSymbol [

	| symbol |
	symbol := unStringOrSymbol isSymbol
		          ifTrue: [ unStringOrSymbol ]
		          ifFalse: [ unStringOrSymbol asSymbol ].
			self getStructure
		detect: [ :each | each getNom == symbol ]
		ifFound: [ :element | self removeEtre: element ]
		ifNone: [
			Oups new signal:
				self getNom , ' ne possède pas d''attribut de nom ' , unStringOrSymbol ]

]

{ #category : 'acces' }
Essence >> setDescription: unString [
	description := unString
]

{ #category : 'etats' }
Essence >> setEtant: unEtre [
	etant := unEtre
]

{ #category : 'acces' }
Essence >> setNom: unSymbole [
	nom := unSymbole
]

{ #category : 'situations' }
Essence >> setSituationDefinition: unEtre [
	situationDefinition := unEtre
]
