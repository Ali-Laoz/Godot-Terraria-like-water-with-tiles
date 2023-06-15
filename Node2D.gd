extends Node2D

onready var tile=$TileMap
var array=PoolByteArray()
const HIGHT=600
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var frame=0


var waterThere=2
var waterSattle=1000
var counter=0


var end=0
var itarationPer=100 # defualt is 100 the best
var start=-itarationPer
var isWaterSattled=true


var vectorWater=PoolVector2Array()
var vectorWaterMoved=PoolIntArray()
var toDeleteWaterByIndex=PoolIntArray()


class water:
	
	pass




# Called when the node enters the scene tree for the first time.
func _ready():
	array.resize(1136*600)
	
	
	array.fill(-1)
	for x in range(0,1136,8):

				
		tile.set_cellv(tile.world_to_map(Vector2(x,576)),1)
		tile.set_cellv(tile.world_to_map(Vector2(x,584)),1)
		tile.set_cellv(tile.world_to_map(Vector2(x,592)),1)
		array[(x*HIGHT)+576]=1
		array[(x*HIGHT)+584]=1
		array[(x*HIGHT)+590]=1
		
	
	for x in range(0,1136,8):
		for y in range(0,600,8):
			var vec=tile.world_to_map(Vector2(x,y))
			if x==0:
				tile.set_cellv(vec,1)
				array[(vec.x*HIGHT)+vec.y]=1
			elif x==1128:
				tile.set_cellv(vec,1)
				array[(vec.x*HIGHT)+vec.y]=1
			elif y==0:
				tile.set_cellv(vec,1)	
				array[(vec.x*HIGHT)+vec.y]=1	
				
				
				
				
				
	
	for x in range(504,744,8):
		for y in range(152,344,8):
			if x==504:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue
			elif x==736:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue
					
			elif y==152:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue
			
			elif y==336:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue		
				
			tile.set_cellv(tile.world_to_map(Vector2(x,y)),0)
			var vec=tile.world_to_map(Vector2(x,y))
			array[(vec.x*HIGHT)+vec.y]=0
			vectorWater.append(vec)
	
	
	for x in range(200,400,8):
		for y in range(152,344,8):
			if x==200:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue
			elif x==392:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue
					
			elif y==152:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue
			
			elif y==336:
				tile.set_cellv(tile.world_to_map(Vector2(x,y)),1)
				continue		
				
			tile.set_cellv(tile.world_to_map(Vector2(x,y)),0)
			var vec=tile.world_to_map(Vector2(x,y))
			array[(vec.x*HIGHT)+vec.y]=0
			vectorWater.append(vec)
	

				
	vectorWater.resize(0)
		
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#set water
	if Input.get_action_strength("mouse3"):
		#print(get_global_mouse_position())
		var vec=Vector2(0,0)
		vec=tile.world_to_map(get_global_mouse_position())

		if tile.get_cellv(tile.world_to_map(vec))==-1:
			tile.set_cellv(vec,0)
			vectorWater.append(vec)
			array[(vec.x*HIGHT)+vec.y]=0
			isWaterSattled=false
		pass
		
		#set block
	if Input.get_action_strength("mouse_left"):
		var vec=Vector2(0,0)
		vec=tile.world_to_map(get_global_mouse_position())
		array[(vec.x*HIGHT)+vec.y]=1
		tile.set_cellv(vec,1)
		
		pass
		
		#remove block
	if Input.get_action_strength("mouse_right"):
		var vec=Vector2(0,0)
		vec=tile.world_to_map(get_global_mouse_position())
		detectWaterNeedToMove(vec)
		
		array[(vec.x*HIGHT)+vec.y]=-1
		tile.set_cellv(vec,-1)
		var index=vectorWater.find(vec)
		if index>=0:
			vectorWater.remove(index)
			
		pass			
		

	
	frame+=1
	if frame==1:

		waterFlow()
		frame=0
		
	
	pass



func waterFlow():
	if vectorWater.size()==0:
		return

	if counter>=vectorWater.size() and isWaterSattled==true:
		deleteSattledWater()
		return

		
	if counter>=vectorWater.size():	
		counter=0
		isWaterSattled=true
	
	var finalEnd=vectorWater.size()

	start+=itarationPer #starts from 0
	end+=itarationPer #starts from 250	


	if end>finalEnd:
		end=finalEnd
		
	if start>end:
		start=end-itarationPer
	
	if start<0:
		start=0	
	
	

		
	for x in range(start,end,1):
		
		var vec=vectorWater[x]
		var vec1=tile.world_to_map(vec)
		
	
		var up=tile.get_cellv((Vector2(vec.x,vec.y-1)))
		var down=tile.get_cellv((Vector2(vec.x,vec.y+1)))
		var right=tile.get_cellv((Vector2(vec.x+1,vec.y)))
		var left=tile.get_cellv((Vector2(vec.x-1,vec.y)))
		
		counter+=1
		


		if down!=0 and down!=1:
			

			
			vectorWater[x]=Vector2(vec.x,vec.y+1)
			

			isWaterSattled=false
			tile.set_cellv(vec,-1)
			array[(vec.x*HIGHT)+vec.y]=-1
			vec.y+=1
			tile.set_cellv(vec,0)
			array[(vec.x*HIGHT)+vec.y]=0
		

		elif right!=0 and right!=1 and left!=0 and left!=1:


			continue #its nesserly to be here
			

		elif right!=0 and right!=1:

			isWaterSattled=false

			vectorWater[x]=Vector2(vec.x+1,vec.y)
			
			
			tile.set_cellv(vec,-1)
			array[(vec.x*HIGHT)+vec.y]=-1
			vec.x+=1
			tile.set_cellv(vec,0)
			array[(vec.x*HIGHT)+vec.y]=0
		
		elif left!=0 and left!=1:
			
			isWaterSattled=false
			#print(vec)
			vectorWater[x]=Vector2(vec.x-1,vec.y)
			
			
			tile.set_cellv(vec,-1)
			array[(vec.x*HIGHT)+vec.y]=-1
			vec.x-=1
			tile.set_cellv(vec,0)
			array[(vec.x*HIGHT)+vec.y]=0



			
			
			pass
	if end>=finalEnd:				
		end=0
		start=-itarationPer		
		
	pass
	
func deleteSattledWater():
	for x in range(vectorWater.size()):
		var vec=vectorWater[x]
	vectorWater.resize(0)
	pass
	
func detectWaterNeedToMove(vec):
	
	
	var up=vec.y-1 
	var down=vec.y+1
	var right=vec.x+1
	var left=vec.x-1

	##test up vec.y-1 
	if array[(vec.x*HIGHT)+(up)]==0:
		makingWaterToMove(vec)
	
	##test down vec.y+1
	elif array[(vec.x*HIGHT)+(down)]==0:
		makingWaterToMove(vec)

		
		##test right vec.x+1
	elif array[(right*HIGHT)+(vec.y)]==0:
		makingWaterToMove(vec)

	
	
		##test left vec.x-1
	elif array[(left*HIGHT)+(vec.y)]==0:
		makingWaterToMove(vec)		
	
	
	pass	
		


func makingWaterToMove(Mouse_vec):
	
	for x in range(0,1136,8):
		for y in range(0,600,8):
			var vec=tile.world_to_map(Vector2(x,y))
			if array[(vec.x*HIGHT)+(vec.y)]==0:
				if vectorWater.has(vec):
					continue
				isWaterSattled=false
				counter=0
				vectorWater.append(vec)

				
	pass
