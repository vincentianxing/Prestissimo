FactoryBot.define do
	factory :course do
		dept { "CSCI" }
		title { "Principles of Computer Science" }
		professor { "Geitz, Bob" }
		proficiencies { "CD" }
		building { "King" }
		room { "221" }
		cnum { 214 }
		crn { 532 }
	end
end
