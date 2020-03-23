module AccountActivationsHelper
  def get_matched_mentor_emails(stdout)
      splits = stdout.split(',')
      splits.map { |email| email.delete!("\n") }
      return splits
  end

  # Need to implement this
  def build_user_profile_as_string(profile)
  end

  def find_match(mentee, mentors)
      query = ["python3", "app/helpers/matching_ruby_compatible.py"]
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
end
