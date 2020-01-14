class Barrier {
		
	constructor() {
		
		this.yPos =  height/2 + random(-200,200);
		this.xPos = width + 50;
		this.gap = 100;
		this.passed = false; //bool
	}
	
	render() {
		this.xPos-=gameSpeed;
		fill(0,255,0);
	
		
		rectMode(CORNERS);
		rect(this.xPos-20, -50, this.xPos+20, this.yPos-this.gap/2);
		rect(this.xPos-20, height+50, this.xPos+20, this.yPos+this.gap/2);
		
		
		if (qubit.y > this.yPos+ this.gap/2 || qubit.y < this.yPos- this.gap/2)
			if (qubit.x > this.xPos-20 && qubit.x < this.xPos+20)
				gameRunning = false;
		
		if (qubit.x > this.xPos+20 && !this.passed) {
			score++;
			this.passed = true;
		}
	}
}