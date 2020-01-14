class Qubit {
	
	constructor() {
		
		this.x = width/5;
		this.y = height/3;
		this.ySpeed=0;
		this.scl=20;

	}

	update() {
		
		this.ySpeed += gravity;
		this.y += this.ySpeed;
		
		this.x = constrain(this.x, 0, width-this.scl);
    this.y = constrain(this.y, 0, height-this.scl);
		
		fill(255,200,50);
		ellipse(this.x, this.y, this.scl, this.scl);
		
		fill(128,0,0);
		text("Q", this.x, this.y)
		//circle(x,y,scl);
	}
	
	absorption(energy) {
		
		this.ySpeed -= energy;
	
	}
	
	emission(energy) {
		
		this.ySpeed += energy;
	
	}
	
	tunnel(path) {
		
		this.x += path;
		
	}


}