declare -a winid_old
declare -a winid
while true
do
 if [ ${#winid_old[@]} -eq 0 ]; then
    #echo "no old windows foud creating array..."
    window_ids=$(wmctrl -l | cut -f1 -d " ")
    for window_id in $window_ids
    do
        # echo "$window_id"
        # echo "hello"
         winid_old+=("$window_id")
        #echo "${winid_old[@]}"
    done
    #echo "array creation complete"

    for i in ${winid_old[@]}
	do
	    state=$(xprop -id $i | grep "_NET_WM_STATE(ATOM)")
            decor_state=$(xprop -id $i | grep "_MOTIF_WM_HINTS")
	    #echo $state
            #echo $decor_state
	    if [[ "$state" == *"_NET_WM_STATE_SKIP_PAGER"* || "$state" == *"_NET_WM_STATE_SHADED"* || "$state" == *"_NET_WM_STATE_STICKY"* || "$decor_state" == *"0x2, 0x0, 0x0, 0x0, 0x0"* ]]
            then
	    :
	    else
	    #echo "removing titlebar"
	    xprop -id "$i" -f  _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x2, 0x0, 0x0"
	    fi
	done


 else
    #echo "Old array found"
   #make new array to compare to old array
    window_ids=$(wmctrl -l | cut -f1 -d " ")
    winid=()
    for window_id in $window_ids
    do
         winid+=("$window_id")
    done
   #compare both arrays
   array_compare=(`echo ${winid_old[@]} ${winid[@]} | tr ' ' '\n' | sort | uniq -u `)
  # echo ${#array_compare[@]}
   #detect if any new values are there
   if [ ${#array_compare[@]} -eq 0 ]; then
	#   echo "no new values found"
	#   echo "do nothing"
        :
   else
	 #  echo "new values found"
	 #  echo "do things"
#          echo "${winid[@]}"
      #     echo "${array_compare[@]}"

		for i in ${array_compare[@]}
			do
			    state=$(xprop -id $i | grep "_NET_WM_STATE(ATOM)")
                            decor_state=$(xprop -id $i | grep "_MOTIF_WM_HINTS")
		#	    echo $state
        #                   echo $decor_state
			    if [[ "$state" == *"_NET_WM_STATE_SKIP_PAGER"* || "$state" == *"_NET_WM_STATE_SHADED"* || "$state" == *"_NET_WM_STATE_STICKY"* || "$decor_state" == *"0x2, 0x0, 0x0, 0x0, 0x0"* ]]
                            then
                            :
			    else
		#	    echo "removing titlebar"
			    xprop -id "$i" -f  _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "0x2, 0x0, 0x2, 0x0, 0x0" &> /dev/null || :  #echo "command failed"
			    fi
			done

	   winid_old=("${winid[@]}")   #set new values to old array

   fi
 fi



#finished on  14/9/2022 2:14 PM
#sleep 5
done
