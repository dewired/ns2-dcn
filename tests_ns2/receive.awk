BEGIN 	{
	count = 0;
	}

{
if(($1 == "r")&&($5 =="cbr"))
	count++;
}

END	{
	printf("No.of received packets= %d \n", count);
	}
