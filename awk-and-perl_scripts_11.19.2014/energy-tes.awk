#     http://network-simulator-ns-2.7690.n7.nabble.com/LAR-Patch-td27351.html

BEGIN {
        initialenergy = 1000
        maxenergy=0
        n=21
        nodeid=9
}
{
    # Trace line format: energy
        event = $1
        time = $2
        if (event == "r" || event == "d" || event == "s"|| event == "f") {
        node_id = $3
        energy=$14
        }
        if (event=="N"){
        node_id = $5
        energy=$7
        }
    # Store remaining energy
    finalenergy[node_id]=energy
}
END {
    # Compute consumed energy for each node
    
    for (i in finalenergy) {
        consumenergy[i]=initialenergy-finalenergy[i]
        totalenergy = 0
        for (i = 0; i <= n; i = i + 1)  
        totalenergy += consumenergy[i]
        if(maxenergy<consumenergy[i]){
        maxenergy=consumenergy[i]
        nodeid=i
        }
    }
    ###compute average energy
    averagenergy=totalenergy/n
    ####output
    
    for (i=0; i<n; i++) {
        print("node",i, consumenergy[i])
        }
        print("average",averagenergy)
        print("total energy",totalenergy)
}
