require 'opencv'
require 'RMagick'
require 'open-uri'
include OpenCV

module MagickCv
  def magickcv_read(image_to_read)
    # Read Image with RMagick from a URL or FILE
    image = nil

    #Open image and read into Image
    open(image_to_read, 'rb') do |f|
      image = Magick::Image::from_blob(f.read)
    end

    img = image[0]
    pixels = img.export_pixels(0,0,img.columns,img.rows,"BGR")

    # Create a CvSize with dimensions of image
    size = CvSize.new
    size.width = img.columns
    size.height = img.rows

    # Create cvMat from Image
    CvMat.new(size.height, size.width).set_data(pixels)
  end

  def display_image(cvMat,name)
    window = GUI::Window.new(name) # Create a window for display.
    window.show(cvMat) # Show our image inside it.
    GUI::wait_key # Wait for a keystroke in the window.
  end
end
