module CommentsHelper

	# Takes a TIME object and converts it to human readable timestamp for comments
	def translate_time(t)
		time_frozen = t.in_time_zone("Eastern Time (US & Canada)").to_s
		time = time_frozen.dup
		5.times { time.chop! }
		time << "EST"
		tarray = time.split(" ")
		3.times{tarray[1].chop!}
		if (tarray[1].start_with?("13", "14", "15", "16", "17", "18", "19", "2"))
			hours = tarray[1][0,2]
			hours = Integer(hours) - 12
			tarray[1] = String(hours) << tarray[1][2, 3]
			tarray[1] << " pm"
		else
			tarray[1] << " am"
		end
		t.month.to_s+"-"+t.day.to_s+"-"+t.year.to_s+" at "+tarray[1]+" "+tarray[2]
	end

end
