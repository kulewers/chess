class String
  def bg_green
    "\e[#{42}m#{self}\e[0m"
  end

  def bg_gray
    "\e[#{47}m#{self}\e[0m"
  end
end