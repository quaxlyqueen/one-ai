SUB=("api=1" "test=2" "portfolio=3")

arraylength=${#SUB[@]}
for (( i=0; i<${arraylength}; i++ ));
do
  test="$(echo ${SUB[$i]} | cut -f1 -d=)"
  test2="$(echo ${SUB[$i]} | cut -f2 -d=)"
  echo $test $test2
done
