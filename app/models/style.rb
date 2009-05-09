class Style < ActiveRecord::Base
  include ValidationRegExp
  require 'color'
  require 'color/palette'
  require 'color/palette/monocontrast'
  
  # callbacks
  before_validation :prepare_hex
  
  # serialized attributes
  serialize :palette
  
  # validation statements
  validates_presence_of :heading_colour, :border_type
  validates_format_of :heading_colour, :with => RE_HEX_COLOUR, :message => MSG_HEX_COLOUR_BAD
  
  # TODO: this validates_inclusion should probably be looking at a lookup table to get the acceptable values!
  validates_inclusion_of :border_type, :in =>%w(thin fat polaroid)
                                                  
  # association statements
  belongs_to :user
  belongs_to :theme
  belongs_to :font
  
  # protect the following attributes from mass-assignement
  # attr_protected :palette
  
  def heading_colour
    palette.foreground
  end
  
  def heading_colour=(colour)
    self.palette = ColourPalette.new(self.theme.background_colour, colour)
  end
  
  #TODO: need to find a better way of determening which alt heading colour to use!
  def alt_heading_colour
    if self.theme.background_colour == Color::RGB::White.html
      self.palette.foreground_dark
    else
      self.palette.foreground_light
    end
  end
  
  # method to create a default style
  def self.default
    random_theme = Theme.random
    palette = ColourPalette.new(random_theme.background_colour, random_colour)
    new(:theme_id => random_theme.id,
        :border_type => random_border_type,
        :font_id => Font.random.id,
        :palette => palette)
  end
  
  def is_new?
    self.created_at == self.updated_at
  end
  
  protected
  
  def prepare_hex
    if self.heading_colour =~ /^#[0-9a-f]{3}$/i
      self.heading_colour = Color::RGB.from_html(self.heading_colour).html
    end
  end
  
  private
  
  def self.random_colour
    hex_colour = String.new
    3.times do
      a = rand(255).to_s(16)
      if a.length == 1
        a = "0" + a
      end
      hex_colour << a
    end
    "#" + hex_colour
  end
  
  def self.random_border_type
    ["thin", "fat", "polaroid"].at(rand(3))
  end
  
  # TODO: this needs to be refactored since fonts are a model now
  def self.random_heading_font
    ["calibri", "ashby_light", "geo_sans_light", "bodoni_xt", "communist",
     "serif", "cocktail", "anarchistic", "elliot_land_j", "futurist_fixed"].at(rand(10))
  end
end
