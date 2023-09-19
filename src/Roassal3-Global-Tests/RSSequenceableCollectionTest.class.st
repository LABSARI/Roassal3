Class {
	#name : #RSSequenceableCollectionTest,
	#superclass : #RSTest,
	#instVars : [
		'list'
	],
	#category : #'Roassal3-Global-Tests-Rendering'
}

{ #category : #running }
RSSequenceableCollectionTest >> setUp [
	super setUp.
	list := RSSequenceableCollection new
]

{ #category : #tests }
RSSequenceableCollectionTest >> testBasic [

	list isEmpty.
	self assert: list size isZero
]

{ #category : #tests }
RSSequenceableCollectionTest >> testGetShapeFromRectangle [

	| listOfShapes |
	list add: (RSBox new
			 size: 20 asPoint;
			 yourself).
	listOfShapes := list shapesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: (listOfShapes includes: list anyOne)
]

{ #category : #tests }
RSSequenceableCollectionTest >> testGetShapesFromRectangle [

	| listOfShapes box1 box2 box3 |
	box1 := RSBox new
		        size: 20 asPoint;
		        position: -50 asPoint;
		        yourself.
	box2 := RSBox new
		        size: 20 asPoint;
		        position: 50 asPoint;
		        yourself.
	box3 := RSBox new
		        size: 20 asPoint;
		        yourself.
	list addAll: {
			box1.
			box2.
			box3 }.
	listOfShapes := list shapesAtRectangle:
		                (5 asPoint corner: 45 asPoint).
	self assert: listOfShapes asArray equals: {
			box2.
			box3 }
]

{ #category : #tests }
RSSequenceableCollectionTest >> testGetShapesFromRectangleInComposite [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 asPoint;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	list add: composite.
	listOfShapes := list shapesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: listOfShapes asArray equals: { composite }
]

{ #category : #tests }
RSSequenceableCollectionTest >> testGetShapesFromRectangleInCompositeWithChildOutside [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 asPoint;
		       position: 80 asPoint;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	list add: composite.
	listOfShapes := list shapesAtRectangle:
		                (85 asPoint corner: 95 asPoint).
	self assert: listOfShapes asArray equals: { composite }
]

{ #category : #tests }
RSSequenceableCollectionTest >> testIncludes [
	| result |
	list addAll: { RSBox new size: 10. RSBox new position: 50@50; size: 10 asPoint}.
	self assert: list size equals: 2.
	result := list shapesAtPoint:  -100@ -100.
	self assert: result isEmpty.
	result := list shapeAtPoint: -100@ -100.
	self assert: result isNil
]

{ #category : #tests }
RSSequenceableCollectionTest >> testOneElement [
	list add: (RSBox new size: 10).
	self deny: list isEmpty
]
