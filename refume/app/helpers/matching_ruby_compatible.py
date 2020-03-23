from collections import Counter
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics.pairwise import linear_kernel
import sys
import spacy
import string

# Run python3 -m spacy download en_core_web_sm
nlp = spacy.load('en_core_web_sm', disable=['parser','ner'])

def is_from_same_country(mentee_country, mentor_country):
    ''' Checks if any mentor is from the same country. Returns boolean. '''
    if mentee_country.lower().strip() == mentor_country.lower().strip():
        return True
    return False

def number_of_common_languages(mentor_languages, mentee_languages):
    ''' Return number of common languages '''
    mentor_languages = set(mentor_languages)
    mentee_languages = set(mentee_languages)
    number_of_common_languages = mentor_languages.intersection(mentee_languages)
    if number_of_common_languages:
        return len(number_of_common_languages)
    return 0

def create_cosine_similarity(profiles):
    ''' Performs a cosine similarity of mentee with every mentor using tfidf scores '''
    mentee = profiles[0]
    mentors = profiles[1:]
    cosine_similarities = linear_kernel(mentee, mentors)
    return cosine_similarities

def transform_to_tfidf(profiles):
    ''' Return a tfidf transformed corpus '''
    vectorizer = TfidfVectorizer()
    transformed_profiles = vectorizer.fit_transform(profiles)
    return transformed_profiles

def find_top_k_indices(cosine_similarities, k):
    ''' Returns top k matches based on similarity '''
    # Sort in reverse order and pick top k elements
    indices = cosine_similarities.argsort()[::-1][:k]
    return indices

def find_mentor(mentee, mentors):
    ''' Matched mentor is returned as a tuple (mentee_email, mentor_email) '''
    # Extract mentee information
    mentee_email = mentee[0]
    mentee_country = mentee[1]
    mentee_languages = mentee[2]
    # Makes use of goals + bio
    mentee_profile = mentee[3].lower().strip() + ' ' + mentee[4].lower().strip()
    mentor_profiles = []
    # Makes use of goals + bio
    for mentor in mentors:
        mentor_profiles.append(mentor[3].lower().strip() + ' ' + mentor[4].lower().strip())
    mentor_profiles.insert(0, mentee_profile)
    # Strip punctuation since tf-idf is punctuation independent, change to lemmatized words
    for idx, mentor_bio in enumerate(mentor_profiles):
        profile = mentor_bio.translate(str.maketrans('', '', string.punctuation))
        doc = nlp(profile)
        lemma_profile = ''
        for token in doc:
            if token.lemma_ != '-PRON-':
                lemma_profile += token.lemma_ + ' '
        mentor_profiles[idx] = lemma_profile
    # Transform and find cosine similarities
    transformed_profiles = transform_to_tfidf(mentor_profiles)
    cosine_similarities = create_cosine_similarity(transformed_profiles)[0]
    # Boosting for same country and same languages
    for idx,mentor in enumerate(mentors):
        mentor_country = mentor[1]
        mentor_languages = mentor[2]
        if is_from_same_country(mentee_country, mentor_country):
            cosine_similarities[idx] += 0.15
        cosine_similarities[idx] += 0.05 * number_of_common_languages(mentee_languages, mentor_languages)
    # Top 'k' compatible mentors
    k = 2
    top_3_indices = find_top_k_indices(cosine_similarities, k)
    matches = []
    for index in range(k):
        matches.append(mentors[top_3_indices[index]][0])
    return matches

def get_languages(language_str):
    ''' Helper method to get languages back from user input'''
    return language_str.split(',')

def parse_input():
    ''' Helper method to convert ruby data to python '''
    mentee_raw = sys.argv[1]
    mentors_raw = sys.argv[2:]
    mentee_data = mentee_raw.split('|')
    mentee = (
        mentee_data[0],
        mentee_data[1],
        get_languages(mentee_data[2]),
        mentee_data[3],
        mentee_data[4]
    )
    mentors = []
    for mentor in mentors_raw:
        mentor_data = mentor.split('|')
        new_mentor = (
            mentor_data[0],
            mentor_data[1],
            get_languages(mentor_data[2]),
            mentor_data[3],
            mentor_data[4]
        )
        mentors.append(new_mentor)
    return mentee, mentors

def main():
    ''' Main driver function to match a potential mentee with a list of registered mentors '''
    # All users are saved as a tuple -> (email_id, country of origin, languages spoken, goals, bio)
    mentee, mentors = parse_input()
    matches = find_mentor(mentee, mentors)
    concatenated_matches = ''
    for match in matches:
        concatenated_matches += match + ','
    # print so it can be read by stdout
    print(concatenated_matches[:-1])

if __name__ == "__main__":
    main()
