let barrier = []
let qubit;
let particle;
const gravity = 0.01;
const gameSpeed = 2;
const timeSync = 1000, timeDelay = 1000;
let gameRunning = true;
var score = 0;
const E = 2;
const path = 80;
let bool = true;


function setup() {
	createCanvas(700,500);
	//createCanvas(windowWidth, windowHeight);
	qubit = new Qubit();
	particle = new Particle();
	barrier.push(new Barrier());
	textAlign(CENTER,CENTER);

}

function draw(){
	
	background(125,125,255);
	
	if (!gameRunning){
		textSize(50);
		fill(255);
		text("Game Over\n Final Score: " + score,width/2,height/2);
		return;
	}
	
	
	fill(255,20);
	textSize(50);
	text(score, width/2, height/10);
	
	qubit.update();
	particle.update();
	
	
	if (barrier[barrier.length-1].xPos < height) {
		barrier.push(new Barrier()); }

	for (let i=0;i<barrier.length;i++){
		thisBarrier = barrier[i]; // can erase this to go back to ProcessingJS
		thisBarrier.render();
	}
	
	// Absorption - going up
	
	fill(220,20,60);
	ellipse(100, 450, 150, 75);
	textSize(15);
	fill(0, 102, 153)
	text("Absorption - UP Key", 100, 450);
	
	// Emission - going down
	
	fill(220,20,60);
	ellipse(300, 450, 150, 75);
	textSize(15);
	fill(0, 102, 153)
	text("Emission - DOWN Key", 300, 450);
	
	// Tunneling - Left/Right Arrow Keys
	
	fill(220,20,60);
	ellipse(500, 450, 150, 75);
	textSize(15);
	fill(0, 102, 153)
	text("Tunneling <--   -->", 500, 450);
	
	newWait()
	
}

//================================ FUNCTIONS OUTSIDE OF DRAW LOOP ============================

// Change this so that instead of a keyPress, the player needs to touch the actual 'button'

function keyPressed(){
	
	if (keyCode == UP_ARROW){
		
		qubit.absorption(E);
		
	}
	
	else if (keyCode == DOWN_ARROW){
		
		qubit.emission(E);
		
	}
	
	else if (keyCode == RIGHT_ARROW){
		var num = int(random(0, 4)); // 25% chance of successful tunneling
		if (num == 1) {
			qubit.tunnel(path);
		}
	}
	
	else if (keyCode == LEFT_ARROW) {
		var num = int(random(0, 4)); // 25% chance of successful tunneling
		if (num == 0) {
			qubit.tunnel(-1*path);
		}
	}	
}

//================================ PARTICLE CLASS ADDITIONS ============================

function newWait() {
	if (frameCount % 100 == 0){
		addNewParticle();
	}
}

//---------------------------------------------------
	
function addNewParticle() {
		particle.mass.push(random(0.003, 0.03));
		particle.positionX.push(random(-700, 700));
		particle.positionY.push(random(-500, 500));
		particle.velocityX.push(0);
		particle.velocityY.push(0);
	}
//================================ ========================== ============================

