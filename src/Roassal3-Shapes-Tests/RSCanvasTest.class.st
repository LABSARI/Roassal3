"
I have common tests for shapes and canvas
"
Class {
	#name : #RSCanvasTest,
	#superclass : #RSTest,
	#instVars : [
		'canvas'
	],
	#category : #'Roassal3-Shapes-Tests'
}

{ #category : #running }
RSCanvasTest >> setUp [
	super setUp.
	canvas := RSCanvas new
]

{ #category : #running }
RSCanvasTest >> testAddOneShape [

	canvas addShape: RSBox new.
	self assert: canvas numberOfShapes equals: 1.
	self assert: canvas numberOfFixedShapes equals: 0
]

{ #category : #'tests - shapes ordering' }
RSCanvasTest >> testAddShapeBefore [
	| box ellipse |
	box := RSBox new size: 20.
	ellipse := RSEllipse new size: 10.

	canvas add: ellipse.
	
	canvas addShape: box before: ellipse.
	self assert: canvas shapes asArray equals: { box . ellipse }
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testAddingFixedShapeUpdatesDirtyArea [

	| box rectangle |
	box := RSBox new
		       size: 20;
		       setAsFixed;
		position: 0 asPoint;
		       yourself.
	canvas add: box.
	rectangle := -10 asPoint corner: 10 asPoint.
	self assert: canvas dirtyRectangle equals: (-250 asPoint corner: -240 asPoint).
]

{ #category : #tests }
RSCanvasTest >> testAntialiasing [
	| morph |
	canvas aaBest.
	morph := canvas createMorph.
	morph drawOnMockCanvas.
	canvas aaNone.
	morph drawOnMockCanvas.
	self deny: canvas hasAntialiasing.
	canvas enableAntialiasing.
	canvas aaGray.
	canvas aaFast.
	canvas aaDefault
]

{ #category : #'tests - composite' }
RSCanvasTest >> testAsForm [
	| form |
	canvas add: RSBox new.
	form := canvas asForm.
	self assert: form isForm
]

{ #category : #'tests - converting' }
RSCanvasTest >> testAsShapeModel [

	| c compositeShape |
	c :=RSCanvas new.
	c addAll: (RSBox models: (1 to: 20)).
	RSGridLayout on: c shapes.

	compositeShape := c asShapeModel: 'Hello'.
	self assert: compositeShape class equals: RSComposite.
	self assert: compositeShape model equals: 'Hello'.
	self assert: compositeShape children size equals: 20
]

{ #category : #'tests - coordinates' }
RSCanvasTest >> testBasicCoordinates [
	canvas := RSCanvas new.
	self assert: canvas originMode class equals: RSCamera originCenterMiddle class.
	
	canvas originTopLeft.
	self assert: canvas originMode class equals: RSCamera originTopLeft class.
	self deny: canvas originMode class equals: RSCamera originCenterMiddle class.
	
	canvas originCenterMiddle.
	self assert: canvas originMode class equals: RSCamera originCenterMiddle class.
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testCanvasClearBackgroundWhenShapePositionChange [

	| box form |
	box := RSBox new
		       color: Color black;
		       extent: 10 asPoint;
		       yourself.
	canvas add: box.
	form := canvas asForm.
	self
		assert:
		(form colorAt: (canvas extent / 2) asIntegerPoint)
		equals: box color.
	box position: 20 asPoint.
	form := canvas asForm.
	self
		assert:
		(form colorAt: (canvas extent / 2) asIntegerPoint)
		equals: canvas color
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testCanvasDirtyRectangleIsNil [

	self assert: canvas dirtyRectangle isNil
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testCanvasDirtyRectangleIsNotEmpty [

	canvas add: (RSBox new
			 extent: 100 asPoint;
			 yourself).

	canvas add: (RSBox new
			 extent: 100 asPoint;
			 position: 100 asPoint;
			 yourself).
	self
		assert: canvas dirtyRectangle
		equals: (-50 asPoint corner: 150 asPoint)
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testCanvasDirtyWhenShapeIsAddedInComposite [

	| composite canvasForm box |
	composite := RSComposite new
		             extent: 100 asPoint;
		             position: 50 asPoint;
		             color: Color black;
		             yourself.
	box := RSBox new
		       extent: 50 asPoint;
		       color: Color red;
		       yourself.
	canvas add: composite.
	canvasForm := canvas asForm.
	composite add: box.
	self
		assert: canvas dirtyRectangle
		equals: (25 asPoint corner: 75 asPoint)
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testCanvasDirtyWhenShapeIsAddedInCompositeOutSideOfIt [

	| composite canvasForm box position |
	composite := RSComposite new
		             extent: 100 asPoint;
		             position: 50 asPoint;
		             color: Color black;
		             yourself.
	box := RSBox new
		       extent: 50 asPoint;
		       color: Color red;
		       position: 100 asPoint;
		       yourself.
	canvas add: composite.
	canvasForm := canvas asForm.
	composite add: box.
	self assert: canvas dirtyRectangle isNil.
	canvasForm := canvas asForm.

	position := canvas extent / 2 + 150 asPoint.
	self assert: (canvasForm colorAt: position) equals: canvas background
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testCanvasDirtyWhenShapePositionChange [

	| box |
	box := RSBox new
		       extent: 10 asPoint;
		       yourself.
	canvas add: box.
	box position: 10 asPoint.
	self
		assert: canvas dirtyRectangle
		equals: (-5 asPoint corner: 15 asPoint)
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testChangeBorderWidthUpdatesDirtyRectangle [
	| box border |
	box := RSBox new
		       size: 20;
		       yourself.
	border := RSBorder new
		          width: 8;
		          yourself.
	box border: border.
	canvas add: box.
	self
		assert: canvas dirtyRectangle
		equals: (-14 asPoint corner: 14 asPoint).
	canvas asForm.
	border width: 12.
	box resetBBox.
	self
		assert: canvas dirtyRectangle
		equals: (-16 asPoint corner: 16 asPoint).
	self
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testChangeCameraPositionUpdatesDirtyRectangle [

	| camera |
	camera := canvas camera.
	camera position: 10 asPoint.
	self assert: canvas dirtyRectangle equals: camera visibleRectangle
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testChangeCameraScaleUpdatesDirtyRectangle [

	| camera |
	camera := canvas camera.
	camera scale: 2.
	self assert: canvas dirtyRectangle equals: camera visibleRectangle
]

{ #category : #tests }
RSCanvasTest >> testDeepNodes [

	| c compo box |
	c := RSCanvas new.

	compo := RSComposite new.
	box := RSBox new.
	compo addShape: box.
	compo adjustToChildren.

	c add: compo.

	self assert: c numberOfNodes equals: 1.
	self assert: c numberOfDeepNodes equals: 2.

	self assert: c deepNodes size equals: 2.
	self assert: (c deepNodes includesAll: {
				 box.
				 compo })
]

{ #category : #tests }
RSCanvasTest >> testDefaultShapeCollection [
	|  collection |
	collection := canvas shapeCollection.
	self assert: collection class equals: canvas defaultShapeCollection class.
	self assert: collection isCollection.
	self assert: collection isEmpty.
	
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testDirtyAreaIncludesBorder [

	| box |
	box := RSBox new
		       size: 10; 
		       yourself.
	box border: (RSBorder new
			 width: 4;
			 yourself).
	canvas add: box.
	self assert: canvas dirtyRectangle equals: (-7 asPoint corner: 7 asPoint)
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testDirtyAreaIsNotOutsideTheVisibleRectangle [
	| box |
	box := RSBox new size: 100; position: 100 asPoint; color: Color black.
	canvas extent: 200@200.
	canvas resetDirtyRectangle.
	canvas add: box.
	self assert: canvas dirtyRectangle equals: (50 asPoint corner: 100 asPoint).
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testDirtyIsVisibleRectangleWhenCanvasExtentChanges [

	
	canvas extent: 100 asPoint.
	self assert: canvas dirtyRectangle equals: (-50 asPoint corner: 50 asPoint).
]

{ #category : #running }
RSCanvasTest >> testDrawCanvas [
	canvas addShape: (RSBox new
		extent: 100@100;
		yourself).
	canvas addShape: (RSEllipse new
		position: 100@100;
		extent: 100@100;
		yourself).
	canvas createMorph drawOnMockCanvas
]

{ #category : #running }
RSCanvasTest >> testDrawCanvasWithGroup [
	| g |
	g := RSComposite new.
	g add: (RSBox new
		extent: 100@100;
		yourself).
	g add: (RSEllipse new
		position: 100@100;
		extent: 100@100;
		yourself).
	canvas addShape: g.
	canvas createMorph drawOnMockCanvas
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testDrawDirtyRectangleInCanvas [

	| form |
	canvas showDirtyRectangle.
	canvas dirtyRectangle: (-100 asPoint corner: 100 asPoint).
	form := canvas asForm.
	self deny: (form colorAt: (canvas extent / 2) asIntegerPoint) equals: canvas background
]

{ #category : #running }
RSCanvasTest >> testDrawFixed [
	| box |
	box := RSBox new
		extent: 100@100;
		yourself.
	box isFixed: true.
	canvas addShape: box.

	box := RSBox new
		extent: 100@100;
		yourself.
	canvas addShape: box.
	self deny: box isFixed.
	box setAsFixed.
	self assert: box isFixed.
	self assert: canvas numberOfShapes equals: 0.
	self assert: canvas numberOfFixedShapes equals: 2.
	canvas createMorph drawOnMockCanvas
]

{ #category : #running }
RSCanvasTest >> testEmpty [
	self assert: canvas numberOfShapes equals: 0
]

{ #category : #tests }
RSCanvasTest >> testEncompassingRectangle [
	| rect |
	rect := canvas encompassingRectangle.
	self assert: rect equals: (Rectangle center: 0@0 extent: RSCamera minimumExtent)
]

{ #category : #events }
RSCanvasTest >> testEvent [
	| box |
	box := RSBox new.
	box when: RSMouseClick do: [ :evt |  ] for: self
]

{ #category : #tests }
RSCanvasTest >> testEventKnowsItsCanvas [

	| evt t |
	evt := RSEvent new.
	t := false.
	canvas when: RSEvent do: [ :ex | t := true ] for: self.
	canvas announce: evt.
	self assert: evt canvas equals: canvas.
	self assert: t
]

{ #category : #tests }
RSCanvasTest >> testEventKnowsItsCanvas02 [

	| evt shape |
	shape := RSBox new size: 20.
	canvas add: shape.

	evt := RSShapeAddedEvent new shape: shape.
	canvas announce: evt.
	self assert: evt canvas equals: canvas
]

{ #category : #events }
RSCanvasTest >> testLowLevelEvent [
	| box |
	box := RSBox new size: 30.
	box when: RSMouseDragging do: [ :evt | box ] for: self.
	canvas addShape: box.
	self assert: canvas extent equals: 500 asPoint.
	self
		assert: (canvas shapeWithAction: RSMouseDragging forPositionInPixels: 250 @ 250)
		identicalTo: box
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testMoveFixedShapeShouldUpdatesDirtyRectangle [

	| fixedBox |
	fixedBox := RSBox new
		            size: 20;
		            setAsFixed;
		            yourself.
	canvas add: fixedBox.
	fixedBox translateTo: 10 @ 10.
	
	self assert: canvas dirtyRectangle equals: (-250 asPoint corner: -230 asPoint)
]

{ #category : #'tests - opening' }
RSCanvasTest >> testMultipleOpenOnce [

	| c1 c2 win1 win2 |
	c1 := RSCanvas new.
	win1 := c1 openOnce.

	c2 := RSCanvas new.
	win2 := c2 openOnce.

	[
		self deny: win1 isDisplayed.
		self assert: win2 isDisplayed
	] ensure: [ win1 delete. win2 delete. ]
]

{ #category : #'tests - composite' }
RSCanvasTest >> testNestedShape [

	| shape innerShape |
	shape := RSComposite new.
	canvas addShape: shape.
	innerShape := RSBox new.
	shape add: innerShape.

	self assert: shape canvas equals: canvas.
	self assert: innerShape parent equals: shape.
	self assert: innerShape canvas equals: canvas
]

{ #category : #'tests - composite' }
RSCanvasTest >> testNestedShapeNotAddedToACanvas [

	| shape innerShape |
	shape := RSComposite new.
	innerShape := RSBox new.
	shape add: innerShape.

	self assert: shape canvas isNil.
	self assert: innerShape parent equals: shape.
	self assert: innerShape canvas isNil
]

{ #category : #running }
RSCanvasTest >> testNodesShapesAndEdges [
	| n1 n2 n3 eb nodes |
	n1 := RSEllipse new size: 10; model: 1.
	n2 := RSEllipse new size: 10; model: 2.
	n3 := RSEllipse new size: 10; model: 3.
	nodes := Array with: n1 with: n2 with: n3.
	canvas addAll: nodes.
	eb := RSLineBuilder line.
	eb canvas: canvas.
	eb useAssociations: (Array with: (1 -> 2) with: (2 -> 3) with: (3 -> 1)).
	self assert: canvas shapes size equals: 6.
	self assert: (canvas shapes includesAll: nodes).

	self assert: canvas nodes equals: nodes asGroup.
	self assert: canvas edges size equals: 3
]

{ #category : #'tests - opening' }
RSCanvasTest >> testOpen [

	| c win |
	c := RSCanvas new.
	win := c open.
	self assert: win class equals: SystemWindow.
	win delete
]

{ #category : #'tests - opening' }
RSCanvasTest >> testOpenOnce [

	| c win morph |
	c := RSCanvas new.
	win := c openOnce.
	self assert: win class equals: SystemWindow.

	morph := win findDeeplyA: RSAthensMorph.
	self assert: morph class equals: RSAthensMorph.
	self assert: morph canvas equals: c.
	win delete
]

{ #category : #running }
RSCanvasTest >> testOpening [
	canvas open delete
]

{ #category : #'tests - shapes ordering' }
RSCanvasTest >> testPush [

	| c blueBox redBox |
	c := RSCanvas new.

	blueBox := RSBox new
		          size: 80;
		          color: #blue.
	redBox := RSBox new
		          size: 80;
		          color: #red.

	c
		add: blueBox;
		add: redBox.
	blueBox translateBy: 40 @ 20.

	"red is in front of blue"
	self assert: c shapes asArray equals: { blueBox . redBox }.

	redBox pushBack.
	self assert: c shapes asArray equals: { redBox . blueBox }.

	blueBox pushBack.
	self assert: c shapes asArray equals: { blueBox . redBox }.

	c pushBack: redBox.
	self assert: c shapes asArray equals: { redBox . blueBox }
]

{ #category : #'tests - shapes ordering' }
RSCanvasTest >> testPushBackEdges [

	| c blueBox redBox l |
	c := RSCanvas new.

	blueBox := RSBox new
		          size: 80;
		          color: #blue.
	redBox := RSBox new
		          size: 80;
		          color: #red.

	c
		add: blueBox;
		add: redBox.
	blueBox translateBy: 40 @ 20.

	l := RSLine new from: blueBox; to: redBox.
	c add: l.

	self assert: c shapes asArray equals: { blueBox . redBox . l }.

	c pushBackEdges.
	self assert: c shapes asArray equals: { l . blueBox . redBox }
]

{ #category : #'tests - shapes ordering' }
RSCanvasTest >> testPushFront [

	| c blueBox redBox |
	c := RSCanvas new.

	blueBox := RSBox new
		          size: 80;
		          color: #blue.
	redBox := RSBox new
		          size: 80;
		          color: #red.

	c
		add: blueBox;
		add: redBox.
	blueBox translateBy: 40 @ 20.

	"red is in front of blue"
	self assert: c shapes asArray equals: { blueBox . redBox }.

	blueBox pushFront.
	self assert: c shapes asArray equals: { redBox . blueBox }.

	redBox pushFront.
	self assert: c shapes asArray equals: { blueBox . redBox }.

	c pushFront: blueBox.
	self assert: c shapes asArray equals: { redBox . blueBox }.

	c pushBack: blueBox.
	self assert: c shapes asArray equals: { blueBox . redBox }
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testRemovingFixedShapeUpdatesDirtyArea [

	| box |
	box := RSBox new
		       size: 20;
		       setAsFixed;
		position: 0 asPoint;
		       yourself.
	canvas add: box.
	canvas asForm.
	box remove.
	self assert: canvas dirtyRectangle equals: (-250 asPoint corner: -240 asPoint).
]

{ #category : #'tests - shapes ordering' }
RSCanvasTest >> testRemovingShapes [
	| e |
	e := RSEllipse new.
	canvas addShape: e.
	self assert: canvas shapes size equals: 1.
	e remove.
	self assert: canvas shapes size equals: 0
]

{ #category : #tests }
RSCanvasTest >> testShapeFromModel [
	| shapes |
	shapes := (1 to: 3) collect: [ :m | RSBox new model: m; yourself ].
	canvas addAll: shapes.

	self assert: (canvas shapeFromModel: 1) equals: shapes first.
	self assert: (canvas shapeFromModel: 2) equals: shapes second.
	self assert: (canvas shapeFromModel: 3) equals: shapes third.
	self assert: (canvas shapeFromModel: 4) isNil
]

{ #category : #'tests - composite' }
RSCanvasTest >> testShapeFromModelAndComposite [

	| compo |
	compo := RSComposite new.
	compo add: (RSBox new size: 20; model: 42).
	compo model: 41.

	canvas add: compo.

	self assert: canvas numberOfShapes equals: 1.
	self assert: (canvas shapeFromModel: 41) equals: compo.
	self assert: (canvas shapeFromModel: 42) isNil.

	self assert: (canvas deepShapeFromModel: 41) equals: compo.
	self assert: (canvas deepShapeFromModel: 42) equals: compo children first.

	self assert: (canvas deepShapeFromModel: 43) isNil
]

{ #category : #'tests - composite' }
RSCanvasTest >> testShapeFromModelAndComposite2 [

	| compo compo2 compo3 |
	compo := RSComposite new.
	compo add: (RSBox new size: 20; model: 42).
	compo model: 41.
	canvas add: compo.

	compo2 := RSComposite new.
	compo2 add: (RSBox new size: 20; model: 42).
	compo2 model: 41.
	canvas add: compo2.

	compo3 := RSComposite new.
	compo3 add: (RSBox new size: 20; model: 2).
	compo3 model: 1.
	canvas add: compo3.

	self assert: canvas numberOfShapes equals: 3.
	self assert: (canvas shapesFromModel: 41) asArray equals: { compo . compo2 }.
	self assert: (canvas shapesFromModel: 42) isEmpty.

	self assert: (canvas deepShapesFromModel: 41) asArray equals: { compo . compo2 }.
	self assert: (canvas deepShapesFromModel: 42) asArray equals: { compo children first . compo2 children first }.

	self assert: (canvas deepShapesFromModel: 2) asArray equals: { compo3 children first }
]

{ #category : #'tests - composite' }
RSCanvasTest >> testShapeFromModelAndComposite3 [

	| compo compo2 compo3 |
	compo := RSComposite new.
	compo add: (RSBox new size: 20; model: 42).
	compo model: 41.
	canvas add: compo.

	compo2 := RSComposite new.
	compo2 add: (RSBox new size: 20; model: 42).
	compo2 model: 41.
	canvas add: compo2.

	compo3 := RSComposite new.
	compo3 add: (RSBox new size: 20; model: 2).
	compo3 model: 1.
	canvas add: compo3.

	self assert: canvas numberOfShapes equals: 3.
	self assert: (canvas shapesFromModels: #(41 1)) asArray equals: { compo . compo2 . compo3 }.
	self assert: (canvas shapesFromModels: #(42)) isEmpty.

	self assert: (canvas deepShapesFromModels: #(41 42)) asArray equals: { compo . compo children first  . compo2 . compo2 children first }
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsDirty [

	| box |
	box := RSBox new
		       extent: 100 asPoint;
		       yourself.
	self assert: box isDirty
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsDirtyAfterAddingInCanvas [

	| box |
	box := RSBox new extent: 50 asPoint.
	canvas add: box.
	self assert: canvas shapesToRender asArray equals: { box }
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsDirtyAfterPushBack [

	| box box1 form position |
	box := RSBox new
		       color: Color black;
		       extent: 50 asPoint;
		       yourself.
	box1 := RSBox new
		        extent: 50 asPoint;
		        position: 25 asPoint;
		        color: Color red;
		        yourself.
	canvas
		add: box;
		add: box1.
	canvas shouldClearBackground: false.
	form := canvas asForm.
	position := canvas extent / 2 + 20 asPoint.
	self assert: (form colorAt: position) equals: Color red.
	box1 pushBack.
	form := canvas asForm.
	self assert: (form colorAt: position) equals: Color black
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsDirtyAfterPushFront [

	| box box1 form position |
	box := RSBox new
		       color: Color black;
		       extent: 50 asPoint;
		       yourself.
	box1 := RSBox new
		        extent: 50 asPoint;
		        position: 25 asPoint;
		        color: Color red;
		        yourself.
	canvas
		add: box;
		add: box1.
	canvas shouldClearBackground: false.
	form := canvas asForm.
	position := canvas extent / 2 + 20 asPoint.
	self assert: (form colorAt: position) equals: Color red .
	box pushFront.
	self assert: canvas dirtyRectangle equals: box encompassingRectangle.
	form := canvas asForm.
	self assert: (form colorAt: position) equals: Color black
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsDirtyAfterUpdatingColor [

	| box |
	box := RSBox new
		       extent: 50 asPoint;
		       color: Color black;
		       yourself.

	canvas add: box.

	canvas createMorph drawOnMockCanvas.
	box color: Color red.
	self assert: canvas dirtyRectangle equals: box encompassingRectangle
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsDirtyAfterUpdatingExtent [

	| box |
	box := RSBox new
		       extent: 50 asPoint;
		       yourself.

	canvas add: box.

	canvas createMorph drawOnMockCanvas.
	box extent: 10 asPoint.
	self
		assert: canvas dirtyRectangle
		equals: (-25 asPoint corner: 25 asPoint)
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsDirtyAfterUpdatingExtentToBiggerOne [

	| box |
	box := RSBox new
		       extent: 50 asPoint;
		       yourself.

	canvas add: box.

	canvas createMorph drawOnMockCanvas.
	box extent: 100 asPoint.
	self
		assert: canvas dirtyRectangle
		equals: (-50 asPoint corner: 50 asPoint)
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsNotDirty [

	| box |
	box := RSBox new
		       extent: 100 asPoint;
		       yourself.
	box isDirty: false.
	self deny: box isDirty
]

{ #category : #'tests - dirty areas' }
RSCanvasTest >> testShapeIsNotDirtyAfterRendering [

	| box |
	box := RSBox new extent: 50 asPoint.
	canvas add: box.
	canvas createMorph drawOnMockCanvas.
	self assert: canvas shapesToRender isEmpty.
	self assert: canvas dirtyRectangle isNil
]

{ #category : #'tests - shapes ordering' }
RSCanvasTest >> testUseRTree [
	canvas useRTree.
	self assert: canvas shapeCollection class equals: RSRTreeShapeCollection
]

{ #category : #'tests - shapes ordering' }
RSCanvasTest >> testVisibleArea [
	| box smallSize bigSize |
	smallSize := 100.
	bigSize := 500.
	box := RSBox new.
	box size: smallSize asPoint.
	box position: box extent / 2.
	canvas add: box.
	canvas extent: bigSize asPoint.
	canvas visibleArea: (0 asPoint corner: smallSize asPoint).
	self assert: canvas position equals: bigSize asPoint / -2.
	self assert: canvas camera scale equals: bigSize / smallSize
]
