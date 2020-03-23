def get_matched_mentor_emails(stdout)
    splits = stdout.split(',')
    puts splits
end

# Need to implement this
def build_user_profile_as_string(profile)
end

def find_match(mentee, mentors)
    query = ["python3", "matching_ruby_compatible.py"]
    query.append(mentee)
    mentors.each do |item|
        query.append(item)
    end
    query.append(:err=>[:child, :out])
    result = nil
    IO.popen(query) {|ls_io|
        result = ls_io.read
    }
    matches = get_matched_mentor_emails(result)
    return matches
end

# Make sure you run python3 -m spacy download en_core_web_sm

# All users are saved as a tuple -> (email_id, country of origin, languages spoken, goals, bio)
mentee_ = 'mentee@gmail.com|Iraq|Arabic,English|Some day, I hope to be an astronaut and fly to the moon in a SpaceX rocket.|I enjoy reading astrophysics books and watching astrophysics videos online.'
mentor_1 = 'mentor1@gmail.com|Italy|English,Spanish,Italian,German|I want to start my own company|My family is very important to me, and I grew up living with three sisters and a brother.'
mentor_2 = "mentor2@gmail.com|Iraq|Arabic|Set aside money for my children's education|I am 20 year old interested in technology, IT and computer science."
mentor_3 = "mentor3@gmail.com|India|Hindi,English,Tamil|I hope to buy a big house|I like eating Indian food and watching Bollywood movies. I spent three years learning how to dance."
mentor_4 = "mentor4@gmail.com|Turkey|Turkish,English|Get my dream car|I play the guitar and enjoy discovering new musicians online. I also like computers."
mentor_5 = "mentor5@gmail.com|China|Mandarin,Cantonese,English|I hope I can star in a movie someday|I have lived in China my entire life. I like to read books in my free time."
mentors = [mentor_1, mentor_2, mentor_3, mentor_4, mentor_5]
puts find_match(mentee_, mentors)
