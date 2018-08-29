BEGIN	{
		receive_count_0_3 = 0;
		receive_count_2_5 = 0;
	}

{
	if(($1 == "r")&&($9 =="3")&&($31 =="0.0")&&($35 =="tcp"))
		receive_count_0_3++;
	if(($1 == "r")&&($9 =="5")&&($31 =="2.0")&&($35 =="tcp"))
		receive_count_2_5++;
}

END	{
		printf("No.of packets received by node N3 from node N0= %d \n", receive_count_0_3);
		printf("No.of packets received by node N5 from node N2= %d \n", receive_count_2_5);
	}
