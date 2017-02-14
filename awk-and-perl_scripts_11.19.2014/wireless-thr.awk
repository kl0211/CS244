{
	if(init == 0){
		start = $1;
		init = 1;
	}

	bytes += $2;

	if($1 >= (start + window)){
		bytes -= $2;
		while($1 >= (start + window)){

			print start + window/2 " " (bytes * 8 / (window))

			start += window;
			bytes = 0;
		}
		
		bytes = $2
	}
}
