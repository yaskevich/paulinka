var freq;
var d;
var setLast = 0;
var listsize = 20;
var freq_all = 0;
// https://github.com/jfriend00/docReady
docReady(function() {
	document.getElementsByTagName('h1')[0].innerHTML = document.title;

    var svg = dimple.newSvg("#chart", 700, 400);
	d3.csv("data/pau_stat.csv", function(error, data) {
    var chart = new dimple.chart(svg, data);
	chart.setBounds(20, 20, 460, 360)
	y = chart.addMeasureAxis("p", "Рэплікі");
	// y.tickFormat = d3.format(",.3f");
	chart.addSeries("Роля", dimple.plot.pie);
	myl = chart.addLegend(500, 20, 90, 300, "left");
	myl.fontFamily = "PT Sans";
	myl.fontSize = "14px";
	chart.draw();
	
	// console.log(JSON.stringify(data));
	
	var d = document.getElementById('dataTable').getElementsByTagName('tbody')[0];
	
	 for (var key=0, size=data.length; key<size; key++){
		  var tr = document.createElement('tr');
		  
		 var th = document.createElement('th');
		 th.setAttribute('scope','row');
		 th.innerHTML = data[key]['Роля'];
		 tr.appendChild(th);
		 
		 makeCell(tr, data[key]['Рэплікі']);
		 makeCell(tr, data[key]['Усяго словаў']);
		 
		 d.appendChild(tr);
	}
	
	});
	
	d3.csv("data/pau_freq.csv", function(error, data) {
		freq = data;
		d = document.getElementById('dataTable2').getElementsByTagName('tbody')[0];
		freq_all = data.length;
		freqtab(0);
	});	
 
});

 function makeCell(tr, txt) {
	var td = document.createElement('td');
	td.innerHTML = txt;
	tr.appendChild(td);
	return td;
 }
 
 
 function freqtab(back) {
	var cursor = back?setLast-(listsize*2):setLast;
	console.log("cursor " +  cursor);
	console.log("start: " + setLast + " offset: " +listsize + " go " + (back ? 'back' : 'forward'));

	if (cursor >= 0 && !(!back && setLast > freq_all)){
		if (setLast) {
			while (d.firstChild) { d.removeChild(d.firstChild); }
			console.log ('reset');
		}
		var fragment = document.createDocumentFragment();	
		for (size=0; size < listsize; size++, cursor++){
			
				var tr = document.createElement('tr');
				if (freq[cursor]){
					makeCell(tr, freq[cursor]['1']);
					makeCell(tr, freq[cursor]['2']);
				} else  {
					makeCell(tr, '&nbsp;').setAttribute("colspan", "2");
				}
				fragment.appendChild(tr);
			 
		}
		setLast = cursor;
		d.appendChild(fragment);
		document.getElementById('freqinfo').innerHTML = "З №" + (cursor-listsize+1) + " па №" + cursor + " з " + freq_all;
	}
	
	
 }