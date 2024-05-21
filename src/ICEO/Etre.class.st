"
""Une essence est un être""
"
Class {
	#name : 'Etre',
	#superclass : 'Object',
	#classInstVars : [
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
	#category : 'ICEO',
	#package : 'ICEO'
}

{ #category : 'acces' }
Etre class >> affecteEtat: uneQualite dansSituation: uneSituationIndividuelle [
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
	uneSituationIndividuelle add: etat.
	etat setSituationDefinition: uneSituationIndividuelle.
	"par défaut"
	etat setNom: uneQualite getNom.
	etat setDescription:
		self getNom printString , ' addEtat: '
		, uneQualite getNom printString , ' dansSituation: '
		, uneSituationIndividuelle getNom printString.
	Smalltalk at: #sib ifPresent: [ :x | x window close ] 
]

{ #category : 'acces' }
Etre class >> affecteEtatEssentiel: uneQualite [
	"il faudra vérifier que self peut avoir cet etat !! "

	| etat |
	[
	uneQualite isQualite ifFalse: [
		Oups new signal: uneQualite , 'n''est pas une qualité' ].
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
	Smalltalk at: #sib ifPresent: [ :x | x window close ] ]
		on: Oups
		do: [ :ex |
			SpInformDialog new
				title: '';
				label: ex description;
				acceptLabel: 'Ok';
				openDialog ]
]

{ #category : 'acces' }
Etre class >> associationEtat: unEtat [
	"association bidirectionnellle de self et de unEtat"

	self isEtat ifFalse: [
		Oups new signal: self getNom , ' n''est pas un   état' ].
	unEtat isEtat ifFalse: [
		Oups new signal: unEtat getNom , ' n''est pas un état' ].
	self getSituationDefinition == unEtat getSituationDefinition
		ifFalse: [
			Oups new signal: unEtat getNom , ' et ' , self getNom
				, ' ne sont pas définis dans la même situation' ].
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
Etre class >> attributionEtre: unEtre [
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
				unEtre getEssence getNom , ' non défini pour l''essence '
				, self getEssence getNom ] 
]

{ #category : 'acces' }
Etre class >> attributionEtre: unStringOrSymbol essence: uneEssence [
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

	structure add: attribut.
	attribut setSituationDefinition: self.
	uneEssence isIndividu ifTrue: [
		uneEssence getAttributs do: [ :each |
			c := each value.
			(c notNil and: [ c > 0 ]) ifTrue: [
				(1 to: c) do: [ :x |
					n := uneEssence genSym: each key getNom.
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
Etre class >> get: unStringOrSymbol quiEst: uneQualite [
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
Etre class >> getAllEtresAttributs [

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
Etre class >> getDescription [
	^description isNil ifTrue: ['tbd'] ifFalse: [ description ]
]

{ #category : 'acces' }
Etre class >> getElementsEssence: uneEssence [
"pour une situation, retourne l'ensemble des êtres ayant uneEssence pour essence"
	^self getEtresAttributs select: [:each | each getEssence == uneEssence]   
]

{ #category : 'acces' }
Etre class >> getEssenceOld [

	^self class
]

{ #category : 'acces' }
Etre class >> getEtant [
	^etant
]

{ #category : 'acces' }
Etre class >> getEtat: unSymbole [ 
	| states |
	states := etats
				select: [:each | each getNom == unSymbole].
	states size == 0
		ifTrue: [^ nil].
	^ states  at: 1
]

{ #category : 'acces' }
Etre class >> getEtat: unStringOrSymbol dansSituation: uneSituation [ 
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

{ #category : 'acces' }
Etre class >> getEtatEssence: uneEssence [
	| states |
	states := etats
				select: [:each | uneEssence subsume: each getEssence].
	states size == 0
		ifTrue: [^ nil].
	^ states  at: 1
]

{ #category : 'acces' }
Etre class >> getEtats [
	etats isNil ifTrue: [etats := OrderedCollection new].
	^etats
]

{ #category : 'acces' }
Etre class >> getEtats: unStringOrSymbol dansSituation: uneSituation [ 
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
Etre class >> getEtreAttribut: unStringOrSymbol [

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
Etre class >> getEtres [
	^self getElements select: [:each | each isSituation not]
]

{ #category : 'acces' }
Etre class >> getEtresAttributs [

	| attributs |
	structure isNil ifTrue: [ structure := OrderedCollection new ].
	attributs := OrderedCollection new , structure.
	self getEssence name ~~ #chose ifTrue: [
		self getEssence getEtresAttributs do: [ :each |
			each getEssence isPrototype ifTrue: [ attributs add: each ] ] ].
	^ attributs
]

{ #category : 'acces' }
Etre class >> getEtresAttributsEnTantQue: uneQualite [

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
Etre class >> getEtresAttributsQuiSont: uneQualite [ 
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
Etre class >> getId [
	" permet de différencier deux êtres de même nom"
	id isNil ifTrue: [id := ((Smalltalk at: #ICEO) genSym: nom)].
	^id
]

{ #category : 'acces' }
Etre class >> getNom [
	^nom
]

{ #category : 'acces' }
Etre class >> getSituation: unSymbole [ 
	"retourne, si elle existe, la première situation individuelle trouvée"
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	^ structure
		detect: [:each | each getNom == unSymbole asSymbol]
]

{ #category : 'acces' }
Etre class >> getSituationDefinition [
	^situationDefinition
]

{ #category : 'acces' }
Etre class >> getSituationGenerique [

	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	^self class
]

{ #category : 'acces' }
Etre class >> getSituations [
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

{ #category : 'acces' }
Etre class >> getStructure [
"pour un être"
	structure isNil
		ifTrue: [structure := OrderedCollection new].
	^ structure
]

{ #category : 'acces' }
Etre class >> introductionEtre: unEtre [
"dans une situation"
	self isSituation ifFalse: [
		Oups new signal: self getNom , ' n''est pas une situation' ].
	structure isNil ifTrue: [structure := OrderedCollection new].
	structure add: unEtre
]

{ #category : 'acces' }
Etre class >> isEtat [
	isEtat isNil ifTrue: [isEtat := false].
	^isEtat 
]

{ #category : 'acces' }
Etre class >> isEtat: aBoolean [
	isEtat := aBoolean
]

{ #category : 'acces' }
Etre class >> isGenerique [
	self isSituation ifFalse: [
		Oups new signal: 'seule une situation peut être générique' ].
	^ true 
]

{ #category : 'acces' }
Etre class >> isSituation [
	^isSituation
]

{ #category : 'acces' }
Etre class >> isSituation: aBoolean [
	isSituation := aBoolean
]

{ #category : 'acces' }
Etre class >> removeEtat: unEtat [
	
	self getEtats remove: unEtat.

]

{ #category : 'acces' }
Etre class >> setDescription: unString [
	description := unString
]

{ #category : 'acces' }
Etre class >> setEtant: unEtre [
	etant := unEtre
]

{ #category : 'acces' }
Etre class >> setNom: unSymbole [
	nom := unSymbole
]

{ #category : 'acces' }
Etre class >> setSituationDefinition: unEtre [
	situationDefinition := unEtre
]
