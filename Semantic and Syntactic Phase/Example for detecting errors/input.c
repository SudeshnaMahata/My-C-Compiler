int main(){
    int primeno[] = {2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157};
    long long int l1,l2,i,count=0,num;
    int sum=0,sums=0,t,j
    int a[100];
    for(j=0;j<37;j++){
	t = primeno[j]
        a[t] = 1
        }
   char sum;
    while(test>0){
	count = 0;
        for(i=l1;i<=l2;i++){
            num = i;
	    sum = 0;
	    sums = 0;
            while(num>0){
                t = num%10;
                sum+=t;
                sums+= (t*t);
                num = num/10;
                }
            if(a[sum] == 1 && a[sums] == 1)
                count++;
            }
        cout<<count;
        test--;
        }
    return 0;
    }
