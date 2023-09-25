Class {
	#name : #RSShapeCollectionTest,
	#superclass : #ParametrizedTestCase,
	#instVars : [
		'shapeCollection',
		'shapeCollectionClass',
		'canvas'
	],
	#category : #'Roassal3-Global-Tests-Rendering'
}

{ #category : #'building suites' }
RSShapeCollectionTest class >> testParameters [
	| m classesToConsider |
	m := ParametrizedTestMatrix new.
	classesToConsider := RSShapeCollection subclasses.
	classesToConsider do: [ :cls |
		m addCase: { (#shapeCollectionClass: -> cls) }
	].
	^ m
]

{ #category : #running }
RSShapeCollectionTest >> setUp [
	super setUp.
	shapeCollection := self shapeCollectionClass new.
	canvas := RSCanvas new.
	canvas shapeCollection: shapeCollection
]

{ #category : #accessing }
RSShapeCollectionTest >> shapeCollection [
	^ shapeCollection
]

{ #category : #accessing }
RSShapeCollectionTest >> shapeCollection: anObject [

	shapeCollection := anObject
]

{ #category : #accessing }
RSShapeCollectionTest >> shapeCollectionClass [

	^ shapeCollectionClass
]

{ #category : #accessing }
RSShapeCollectionTest >> shapeCollectionClass: anObject [
	shapeCollectionClass := anObject
]

{ #category : #'tests - adding' }
RSShapeCollectionTest >> testAdd [
	canvas add: RSBox new.
	self assert: canvas shapes size equals: 1.
	self assert: canvas nodes size equals: 1.
	self assert: canvas lines size equals: 0.
	self assert: canvas fixedShapes size equals: 0.
	self assert: shapeCollection size equals: 1.
	
	canvas add: RSLine new.
	self assert: canvas shapes size equals: 2.
	self assert: canvas nodes size equals: 1.
	self assert: canvas lines size equals: 1.
	self assert: canvas fixedShapes size equals: 0.
	self assert: shapeCollection size equals: 2.
	
	canvas add: (RSBox new isFixed: true).
	self assert: canvas shapes size equals: 2.
	self assert: canvas nodes size equals: 2.
	self assert: canvas lines size equals: 1.
	self assert: canvas fixedShapes size equals: 1.
	self assert: shapeCollection size equals: 2.
	
	canvas addShape: RSBox new.
	self assert: canvas shapes size equals: 3.
	self assert: canvas nodes size equals: 2.
	self assert: canvas lines size equals: 1.
	self assert: canvas fixedShapes size equals: 1.
	self assert: shapeCollection size equals: 3.
]

{ #category : #tests }
RSShapeCollectionTest >> testContainsPoint [
	| box shape position |
	position := 1000 asPoint.
	box := RSBox new
		size: 100 asPoint;
		position: position;
		yourself.
	canvas add: box.
	self assert: shapeCollection notEmpty.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape isNil.
	shape := shapeCollection shapeAtPoint: position.
	self assert: shape equals: box.
	box @ RSDraggable.
	shape := canvas shapeWithActionForPosition: position.
	self assert: shape equals: box
]

{ #category : #tests }
RSShapeCollectionTest >> testContainsPointInComposite [
	| box shapes position composite |
	position := 1000 asPoint.
	box := RSBox new
		size: 100;
		position: position;
		yourself.
	composite := { box } asShape size: 200.
	composite draggable.
	canvas add: composite.
	
	shapes := canvas shapesWithActionForPosition: position.
	self assert: shapes size equals: 1.
	self assert: shapes first equals: composite.
	shapes := shapeCollection shapesAtPoint: position.
	self assert: shapes size equals: 2.
]

{ #category : #tests }
RSShapeCollectionTest >> testGetShapeFromRectangle [

	| listOfShapes |
	shapeCollection add: (RSBox new
			 size: 20 asPoint;
			 yourself).
	listOfShapes := shapeCollection shapesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: (listOfShapes includes: shapeCollection anyOne)
]

{ #category : #tests }
RSShapeCollectionTest >> testGetShapesFromRectangle [

	| listOfShapes box1 box2 box3 |
	box1 := RSBox new
		        size: 20 asPoint;
		        position: -50 asPoint;
		        shapeIndex: 1;
		        yourself.
	box2 := RSBox new
		        size: 20 asPoint;
		        position: 50 asPoint;
		        shapeIndex: 2;
		        yourself.
	box3 := RSBox new
		        size: 20 asPoint;
		        shapeIndex: 3;
		        yourself.
	shapeCollection addAll: {
			box1.
			box2.
			box3 }.
	listOfShapes := shapeCollection shapesAtRectangle:
		                (5 asPoint corner: 45 asPoint).
	self assert: listOfShapes asArray equals: {
			box2.
			box3 }
]

{ #category : #tests }
RSShapeCollectionTest >> testGetShapesFromRectangleInComposite [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 asPoint;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	shapeCollection add: composite.
	listOfShapes := shapeCollection shapesAtRectangle:
		                (-5 asPoint corner: 5 asPoint).
	self assert: listOfShapes asArray equals: { composite }
]

{ #category : #tests }
RSShapeCollectionTest >> testGetShapesFromRectangleInCompositeWithChildOutside [

	| listOfShapes box composite |
	box := RSBox new
		       size: 20 asPoint;
		       position: 80 asPoint;
		       yourself.
	composite := RSComposite new
		             size: 100;
		             yourself.
	composite add: box.
	shapeCollection add: composite.
	listOfShapes := shapeCollection shapesAtRectangle:
		                (85 asPoint corner: 95 asPoint).
	self assert: listOfShapes asArray isEmpty
]

{ #category : #tests }
RSShapeCollectionTest >> testIncludes [
	| result |
	shapeCollection addAll: { RSBox new size: 10. RSBox new position: 50@50; size: 10 asPoint}.
	self assert: shapeCollection size equals: 2.
	result := shapeCollection shapesAtPoint:  -100@ -100.
	self assert: result isEmpty.
	result := shapeCollection shapeAtPoint: -100@ -100.
	self assert: result isNil
]

{ #category : #tests }
RSShapeCollectionTest >> testIsEmpty [

	self assert: shapeCollection isEmpty
]

{ #category : #tests }
RSShapeCollectionTest >> testOneElement [

	shapeCollection add: (RSBox new size: 10).
	self deny: shapeCollection isEmpty
]

{ #category : #'tests - removing' }
RSShapeCollectionTest >> testRemoveOneElement [
	| box |
	box := RSBox new.
	canvas add: box.
	box remove.
	self assert: canvas shapes isEmpty.
	self assert: shapeCollection isEmpty.
]
