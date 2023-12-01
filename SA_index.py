path="/home/tharunsai/Documents/Project/code/Systolic-Array-main/"
def matrix_to_file(A,name,bits):
    pathM=path+name
    F=open(pathM,"w")
    row=len(A)
    for i in range(0,row):
        temp=bits.format(A[i])
        F.write(temp+"\n")
    F.close()
def write_matrix_index(N):
    res=[]
    for i in range(N-1,-1,-1):
        for j in range(0,N):
            res.append((i<<4)|(j))
    return res
def fun(s,e):
    N=e
    j=0
    flag=True
    zeros=e-1
    res=[]
    for i in range(0,2*N-1):
        j=0
        if(flag==False):
            for k in range(0,zeros):
                res.append(255)
        while(j<=s):
            if(flag):
                res.append((j<<4)|(N-s+j-1))
            else:
                res.append(((N-s+j-1)<<4)|(j))
            j=j+1
        if(flag):
            for k in range(0,zeros):
                res.append(255)
        s=s+1 if(i<N-1) else s-1
        flag=True if(i<N-1) else False
        zeros= zeros-1 if(i<N-1) else zeros+1
    return res
