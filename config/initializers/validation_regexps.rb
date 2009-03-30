# this is file contains regular expressions that will be used in validations
module ValidationRegExp
  RE_HEX_COLOUR = /^#[0-9a-f]{6}$/i
  MSG_HEX_COLOUR_BAD = "must be a 6 digit hex colour code, begining with a #"
end