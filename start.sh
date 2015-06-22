#!/bin/bash
# Script to download bbc iplayer tv series

#set the input field separator
IFS=','

# check if showlist file exists on /config, if not create blank showlist
if [ -f "/config/showlist" ]; then

	echo "showlist exists"
	
else
	
	# create blank showlist file on /config
	echo "#!/bin/bash" >> /config/showlist
	echo "" >> /config/showlist
	echo "# the list of shows to download" >> /config/showlist
	echo "SHOWLIST=\"\"" >> /config/showlist
	
fi

# import showlists from file - sets environment variable
test -f /config/showlist && . /config/showlist

#check to make sure env set and is not empty
if [ ${SHOWLIST:+x} ]

	then echo "TV show list defined as ($SHOWLIST), looping over list..."
	
	else echo "TV show list is not defined and/or is blank, please specify shows to download in the /config/showlist file"
	
fi

# re-run command every 12 hours
while true
do

	#loop over list of shows - show list set via env variable from showlist file
	for show_name in $SHOWLIST;

		do
		
		#delete any partial files
		rm -rf "/data/$show_name/*partial*"
		
		#run get_iplayer for each show
		/usr/bin/get_iplayer --profile-dir /config --get --nopurge --modes=flashhd,flashvhigh,flashhigh,flashstd,flashnormal,flashlow --file-prefix="$show_name - <senum> - <episodeshort>" "$show_name" --output "/data/$show_name"
		
	done

	#if env variable SCHEDULE not defined then use default
	if [[ -z "${SCHEDULE}" ]]; then

		sleep 12h
		
	else
	
		sleep $SCHEDULE
		
	fi
	
done
