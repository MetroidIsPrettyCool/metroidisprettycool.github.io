document.addEventListener("DOMContentLoaded", function (event) {

    const c = document.getElementById("backAuto");
    const ctx = c.getContext("2d");

    c.width = Math.min(window.innerHeight, window.innerWidth);
    c.height = window.innerHeight;
    
    ctx.imageSmoothingEnabled = false;

    // I hate you JavaScript, I really do
    let cells = new Array(c.height);
    for (let i = 0; i < c.height; i++) {
	cells [i] = new Array(c.width);
	for (let j = 0; j < c.width; j++) {
	    cells [i][j] = -1;
	}
    }

    cells [0][0] = 0;

    const rule = [
	[
	    [1, 1],
	    [0, 0]
	],
	[
	    [0, 0],
	    [1, 1]
	],
    ];
    
    var line = 0;
    var reset = false;

    setInterval(function () {
	if (c.width !== Math.min(window.innerHeight, window.innerWidth) || c.height !== window.innerHeight) {
	    c.width  = Math.min(window.innerHeight, window.innerWidth)
	    c.height = window.innerHeight;
	    reset = true;
	}
	
	const data = ctx.createImageData(c.width, c.height);
	let p = 0;
	for (let i = 0; i < c.width; i++) {
	    for (let j = 0; j < c.height; j++) {
		if (cells [i] [j] === 0) {
		    data.data[p]     = 217;
		    data.data[p + 1] = 209;
		    data.data[p + 2] = 217;
		}
		else if (cells [i] [j] === 1) {
		    data.data[p]     = 6;
		    data.data[p + 1] = 4;
		    data.data[p + 2] = 25;
		}
		else if (cells [i] [j] === -1) {
		    data.data[p]     = 181;
		    data.data[p + 1] = 26;
		    data.data[p + 2] = 66;
		}
		data.data[p + 3] = 255;
		p += 4;
	    }
	}
	ctx.putImageData(data, 0, 0);
    }, 20);

    setInterval(function () {
	if (line === c.height + 100 || reset) {
	    reset = false;
	    line = 0;
	    cells = new Array(c.height);
	    for (let i = 0; i < c.height; i++) {
		cells [i] = new Array(c.width);
		for (let j = 0; j < c.width; j++) {
		    cells [i][j] = -1;
		}
	    }
	    let r = Math.floor(Math.random() * 4) + 1;
	    for (let i = 0; i < r; i++) {
		cells [0][Math.floor(Math.random() * 256)] = 0;
	    }
	    rule[0][0][0] = (Math.floor(Math.random() * 10) % 2);
	    rule[0][0][1] = (Math.floor(Math.random() * 10) % 2);
	    rule[0][1][0] = (Math.floor(Math.random() * 10) % 2);
	    rule[0][1][1] = (Math.floor(Math.random() * 10) % 2);
	    rule[1][0][0] = (Math.floor(Math.random() * 10) % 2);
	    rule[1][0][1] = (Math.floor(Math.random() * 10) % 2);
	    rule[1][1][0] = (Math.floor(Math.random() * 10) % 2);
	    rule[1][1][1] = (Math.floor(Math.random() * 10) % 2);
	    return;
	}
	if (line === 0 || line > c.height - 1) {
	    line++;
	    return;
	}

	cells [line][0] = rule[Math.abs(cells[line - 1][c.width - 1])][Math.abs(cells[line - 1][0])][Math.abs(cells[line - 1][1])];
	if (cells[line - 1][0] === -1) cells[line][0] *= -1;
	for (let i = 1; i < c.width - 1; i++) {
	    cells [line][i] = rule[Math.abs(cells[line - 1][i - 1])][Math.abs(cells[line - 1][i])][Math.abs(cells[line - 1][i + 1])];
	    if (cells[line - 1][i] === -1) cells[line][i] *= -1;
	}
	cells [line][c.width - 1] = rule[Math.abs(cells[line - 1][c.width - 2])][Math.abs(cells[line - 1][c.width - 1])][Math.abs(cells[line - 1][0])];
	if (cells[line - 1][c.width - 1] === -1) cells[line][c.width - 1] *= -1;
	line++;
	
    }, 100);
    
})
