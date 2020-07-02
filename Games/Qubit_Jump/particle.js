class Particle {
	
	constructor(){
		
		this.mass = [];
		this.positionX = [];
		this.positionY = [];
		this.velocityX = [];
		this.velocityY = [];
	
	}
	
	update() {
		
		for (var particleA = 0; particleA < this.mass.length; particleA++) {
		var accelerationX = 0, accelerationY = 0;
		
		for (var particleB = 0; particleB < this.mass.length; particleB++) {
			if (particleA != particleB) {
				var distanceX = this.positionX[particleB] - this.positionX[particleA];
				var distanceY = this.positionY[particleB] - this.positionY[particleA];

				var distance = sqrt(distanceX * distanceX + distanceY * distanceY);
				if (distance < 1) distance = 1;

				var force = (distance - 320) * this.mass[particleB] / distance;
				accelerationX += force * distanceX;
				accelerationY += force * distanceY;
			}
		}
		
		this.velocityX[particleA] = this.velocityX[particleA] * 0.99 + accelerationX * this.mass[particleA];
		this.velocityY[particleA] = this.velocityY[particleA] * 0.99 + accelerationY * this.mass[particleA];
	}
	
	for (var particle = 0; particle < this.mass.length; particle++) {
		this.positionX[particle] += this.velocityX[particle];
		this.positionY[particle] += this.velocityY[particle];
		
		//ellipse(this.positionX[particle], this.positionY[particle], this.mass[particle] * 1000, this.mass[particle] * 1000);
		fill(120,68,98);
		ellipse(this.positionX[particle], this.positionY[particle], 20, 20);
		
		fill(0,204,204);
		text("Q", this.positionX[particle], this.positionY[particle])
	}
		
	// insert collision criteria here
	}
	
	
}

