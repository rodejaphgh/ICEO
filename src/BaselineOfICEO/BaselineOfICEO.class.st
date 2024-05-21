Class {
	#name : 'BaselineOfICEO',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfICEO',
	#package : 'BaselineOfICEO'
}

{ #category : 'baselines' }
BaselineOfICEO >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			package: #'ICEO'.
		spec 
			group: 'Core' with: #( 'ICEO' );
			group: 'default' with: #( 'ICEO' ) ]
]
