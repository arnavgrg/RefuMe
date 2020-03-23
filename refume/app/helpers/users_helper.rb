module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def encrypt(input)
    encryptor = Encryption::Symmetric.new
    # 256-bit encryption key - AES (Symmetric)
    encryptor.key = '7w!z%C*F)J@NcRfUjXn2r5u8x/A?D(G+'
    encryptor.iv = 'Xn2r5u8x/A?D(G+K'
    encrypted_str = nil
    if input.is_a?(Array)
        encrypted_list = input.map{|item| encryptor.encrypt(item)}
        return encrypted_list
    else
        encrypted_str = encryptor.encrypt(input)
        return encrypted_str
    end
  end

  def decrypt(input)
    encryptor = Encryption::Symmetric.new
    # 256-bit encryption key - AES (Symmetric)
    encryptor.key = '7w!z%C*F)J@NcRfUjXn2r5u8x/A?D(G+'
    encryptor.iv = 'Xn2r5u8x/A?D(G+K'
    encrypted_str = nil
    if input.is_a?(Array)
        decrypted_list = input.map{|item| encryptor.decrypt(item)}
        return decrypted_list
    else
        decrypted_str = encryptor.decrypt(input)
        return decrypted_str
    end
  end

  # Use test encryption keys
  #SymmetricEncryption.cipher = SymmetricEncryption::Cipher.new(
  #  key:         '7w!z%C*F)J@NcRfU',
  #  iv:          'Xn2r5u8x/A?D(G+K',
  #  cipher_name: 'aes-128-cbc'
  #)

  #encrypted = SymmetricEncryption.encrypt('hello world')
  #SymmetricEncryption.decrypt(encrypted)

end
