for num in {02..20}
do
    echo "Running test with buffer size ${num}..."
    sed -i "s/set val(ifqlen) [0-9][0-9]/set val(ifqlen) ${num}/g" wireless.tcl
    for i in {1 2 3 4 5}
    do
        ns wireless.tcl && ./ns2stats.py out.tr >> stats.PriQueue.ran${num}.txt
    done
done
