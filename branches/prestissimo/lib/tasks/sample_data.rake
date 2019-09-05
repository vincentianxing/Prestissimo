namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Course.create!(dept: "CSCI",
                   cname: "Principles of Computer Science",
                   professor: "Geitz, Bob",
                   proficiencies: "CD",
                   building: "King",
                   room:	"221",
                   cnum: 214,
                   nmax: 3,
                   crmax: 3,
                   crmin: 1,
                   days_off: "MWF",
                   descrip: "THIS IS A COURSE DESCRIPTION",
                   crn: 532,
                   semester: "f12",
                   mods: 1,
                   start_time: Time.new,
                   end_time: Time.new + 2,
                   semcrn: "f12_532")

    Course.create!(dept: "ATHL",
                   cname: "Bowling XIV",
                   professor: "Reid, Tom",
                   proficiencies: "QP,CD",
                   building: "Severence",
                   room:	"-1",
                   cnum: 781,
                   smax: 3,
                   crmax: 4,
                   crmin: 2,
                   days_off: "T",
                   descrip: "THIS IS A COURSE DESCRIPTION",
                   crn: 3920,
                   semester: "f12",
                   mods: 2,
                   start_time: Time.new,
                   end_time: Time.new + 2,
                   semcrn: "f12_3920")

    Course.create!(dept: "ECON",
                   cname: "The Open Door Policy: Shut the Door!",
                   professor: "Cheung, Ron",
                   proficiencies: "WR",
                   building: "Rice",
                   room:	"100",
                   cnum: 204,
                   hmax: 2,
                   crmax: 2,
                   crmin: 2,
                   days_off: "RFSU",
                   descrip: "THIS IS A COURSE DESCRIPTION",
                   crn: 32,
                   semester: "f12",
                   mods: 3,
                   start_time: Time.new,
                   end_time: Time.new + 2,
                   semcrn: "f12_32")

    Course.create!(dept: "PHYS",
                   cname: "Molecular Cleaning: Destroying One Pesky Electron at a Time",
                   professor: "Sagan, Carl",
                   proficiencies: "WR",
                   building: "Afrikan Heritage House",
                   room:	"100",
                   cnum: 204,
                   hmax: 2,
                   crmax: 2,
                   crmin: 2,
                   days_off: "RF",
                   descrip: "THIS IS A COURSE DESCRIPTION",
                   crn: 5873,
                   semester: "f12",
                   mods: 4,
                   start_time: Time.new,
                   end_time: Time.new + 2,
                   semcrn: "f12_5873")

    9.times do |n|
      dept = "CSCI"
      cname = "Computer Class"
      professor = Faker::Name.name
      proficiencies= "CD"
      building = "King"
      room = "2#{n+1}"
      cnum= n+100
      crn = n+1000
      mods = n % 4 + 1
      crmax = n
      nmax = n
      smax = n
      hmax = n
      emax = n
      cdmax = n
      starttime = Time.new + n
      endtime = Time.new + n + 1
      Course.create!(dept: dept,
                     cname: cname,
                     professor: professor,
                     proficiencies: proficiencies,
                     building: building,
                     room: room,
                     cnum: cnum,
                     descrip: "THIS IS COURSE DESCRIPTION NUMBER #{n}",
                     crn: crn,
                     semester: "s12",
                     mods: mods,
                     crmax: crmax,
                     nmax: nmax,
                     smax: smax,
                     hmax: hmax,
                     emax: emax,
                     cdmax: cdmax,
                     start_time: starttime,
                     end_time: endtime	)
    end
  end
end


