class ColourPalette
  require 'color'
  require 'color/palette'
  require 'color/palette/monocontrast'
  
  def initialize(background, foreground)
    @background = background
    @foreground = foreground
    @palette = Color::Palette::MonoContrast.new(Color::RGB.from_html(@background), Color::RGB.from_html(@foreground))
  end
  
  def foreground
    @foreground
  end
  
  def foreground=(colour)
    @palette = Color::Palette::MonoContrast.new(Color::RGB.from_html(@background), Color::RGB.from_html(colour))
    @foreground = colour
  end
  
  def foreground_colours
    a = Array.new
    @palette.foreground.values.each {|colour_value| a << colour_value.html}
    a.uniq.delete_if {|item| remove_unwanted_foreground_colours(item)} 
  end
  
  def foreground_dark
    Color::RGB.from_html(@foreground).darken_by(50).html
  end
  
  def foreground_light
    Color::RGB.from_html(@foreground).lighten_by(50).html
  end
  
  def background
    @background
  end
  
  def background=(colour)
    @palette = Color::Palette::MonoContrast.new(Color::RGB.from_html(colour), Color::RGB.from_html(@foreground))
    @background = colour
  end
  
  def background_colours
    a = Array.new
    @palette.background.values.each {|colour_value| a << colour_value.html}
    a.uniq.delete_if {|item| remove_unwanted_background_colours(item)}
  end
  
  private
  
  def remove_unwanted_foreground_colours(colour)
    unless @foreground == Color::RGB::White.html || @foreground == Color::RGB::Black.html
      colour == Color::RGB::White.html || colour == Color::RGB::Black.html || colour == @foreground
    else
      false
    end
  end
  
  def remove_unwanted_background_colours(colour)
    unless @background == Color::RGB::White.html || @background == Color::RGB::Black.html
      colour == Color::RGB::White.html || colour == Color::RGB::Black.html || colour == @background
    else
      false
    end
  end
end