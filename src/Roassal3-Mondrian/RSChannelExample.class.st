Class {
	#name : #RSChannelExample,
	#superclass : #Object,
	#category : #'Roassal3-Mondrian-Examples'
}

{ #category : #examples }
RSChannelExample >> exampleBasic [
	<script: 'self new exampleBasic'>

| c box1 box2 label connection |
c := RSCanvas new.

box1 := RSBox new size: 50; color: Color gray translucent.
box2 := RSBox new size: 30; color: Color gray translucent.
box1 @ RSDraggable.
box2 @ RSDraggable.
c add: box1; add: box2.

box1 translateBy: 150 @ -40.

label := RSLabel new text: 'Move the mouse above me'.
c add: label.
RSLocation new 
	above;
	stick: label on: box1.

"-------"
"Connection here"

connection := RSChannel new.
connection input: { box1 } asGroup.
connection output: { box2 } asGroup.
connection build.
"connection effect: [ :evt |  ]"

"-------"

c open
]

{ #category : #examples }
RSChannelExample >> exampleBasic2 [
	<script: 'self new exampleBasic2'>
	| c m mondrianNodes oddLabel evenLabel g channel |
	c := RSCanvas new.

	m := RSMondrian new.
	m canvas: c.
	m nodes: (1 to: 30).
	m build.

	mondrianNodes := c nodes copy.


	oddLabel := RSLabel text: 'Odd'.
	evenLabel := RSLabel text: 'Label'.

	c add: oddLabel; add: evenLabel.

	g := { oddLabel . evenLabel } asGroup.

	RSHorizontalLineLayout on: g.
	RSVerticalLineLayout new alignCenter; on: { g .  mondrianNodes}.

	"-------" 
	channel := RSChannel new.
	channel input: { oddLabel }.
	channel output: (mondrianNodes select: [ :e | e model odd ]).
	channel build.
	"-------"
	channel := RSChannel new.
	channel input: { evenLabel }.
	channel output: (mondrianNodes select: [ :e | e model even ]).
	channel build.
	"-------"

	c @ RSCanvasController.
	c open
]