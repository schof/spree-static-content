class Page < ActiveRecord::Base
  default_scope :order => "position ASC"

  validates_presence_of :title
  validates_presence_of [:slug, :body], :if => :not_using_foreign_link?
<<<<<<< HEAD:app/models/page.rb

  named_scope :header_links, :conditions => ["show_in_header = ?", true], :order => 'position'
  named_scope :footer_links, :conditions => ["show_in_footer = ?", true], :order => 'position'
  named_scope :sidebar_links,:conditions => ["show_in_sidebar = ?", true], :order => 'position'

  named_scope :visible, :conditions => {:visible => true}
=======
  
  scope :header_links, where(["show_in_header = ?", true])
  scope :footer_links, where(["show_in_footer = ?", true])
  scope :sidebar_links, where(["show_in_sidebar = ?", true])
  scope :visible, where(:visible => true)
  
  before_save :update_positions_and_slug
>>>>>>> f622601fb9d417347245fdb060f7dabf3b148faf:app/models/page.rb

  def initialize(*args)
    super(*args)
    last_page = Page.last
    self.position = last_page ? last_page.position + 1 : 0
  end

  def link
    foreign_link.blank? ? slug_link : foreign_link
  end

private

  def update_positions_and_slug
    unless new_record?
      return unless prev_position = Page.find(self.id).position
      if prev_position > self.position
        Page.update_all("position = position + 1", ["? <= position AND position < ?", self.position, prev_position])
      elsif prev_position < self.position
        Page.update_all("position = position - 1", ["? < position AND position <= ?", prev_position,  self.position])
      end
    end
<<<<<<< HEAD:app/models/page.rb

    if not_using_foreign_link?
      self.slug = slug_link
    else
      self.slug = nil
    end

  end
=======
>>>>>>> f622601fb9d417347245fdb060f7dabf3b148faf:app/models/page.rb

    self.slug = slug_link  
  end
<<<<<<< HEAD:app/models/page.rb

  private

=======
  
>>>>>>> f622601fb9d417347245fdb060f7dabf3b148faf:app/models/page.rb
  def not_using_foreign_link?
    foreign_link.blank?
  end

  def slug_link
    ensure_slash_prefix slug
  end

  def ensure_slash_prefix(str)
    str.index('/') == 0 ? str : '/' + str
  end
end
