class Theme < ActiveRecord::Base
  include ValidationRegExp
  require 'color'
  require 'color/palette'
  require 'color/palette/monocontrast'
  
  # callbacks
  before_validation :prepare_hex
  
  # validation statements
  validates_presence_of :name, :border_colour, :text_colour
  validates_uniqueness_of :name
  validates_format_of :border_colour, :with => RE_HEX_COLOUR, :message => MSG_HEX_COLOUR_BAD
  validates_format_of :background_colour, :with => RE_HEX_COLOUR, :message => MSG_HEX_COLOUR_BAD
  validates_format_of :text_colour, :with => RE_HEX_COLOUR, :message => MSG_HEX_COLOUR_BAD
  
  # association statements
  has_many :styles
  
  # scopes
  named_scope :available, :conditions => {:available => true}
  
  def background_colour_rgb
    background_colour.gsub("#","").scan(/../).map {|colour| colour.to_i(16)}
  end
  
  def background_colour_brightness
    #((Red value X 299) + (Green value X 587) + (Blue value X 114)) / 1000
    ((background_colour_rgb[0] * 299) + (background_colour_rgb[1] * 587) + (background_colour_rgb[2] * 114)) / 1000
  end
  
  def self.random
    find(:all, :conditions => {:available => true}).at(rand(available.size))
  end
  
  protected
  
  def prepare_hex
    if self.background_colour =~ /^#[0-9a-f]{3}$/i
      self.background_colour = Color::RGB.from_html(self.background_colour).html
    end
    
    if self.border_colour =~ /^#[0-9a-f]{3}$/i
      self.border_colour = Color::RGB.from_html(self.border_colour).html
    end
    
    if self.text_colour =~ /^#[0-9a-f]{3}$/i
      self.text_colour = Color::RGB.from_html(self.text_colour).html
    end
  end
end
