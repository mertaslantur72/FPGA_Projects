#include<stdio.h>

char *gunisimi(char *gundizisi[], int uzunluk, int hangigun) {
	
	if(hangigun>=1 && hangigun<=7) {
		
		return gundizisi[hangigun-1];
		
	}
	
	else {
		return NULL;
		
	}
	
}



int main() {
	
	char *gunler[7] = {"Pazartesi","Sali","Carsamba","Persembe","Cuma","Cumartesi","Pazar"};
	
	char *p = gunisimi(gunler,7,5);
	
	
	if(p==NULL) {
		
		printf("NULL");
	}
	
	
	else {
		
		printf("%s",p);
	}
	
	
	return 0;
}
