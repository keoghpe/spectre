class Project < ActiveRecord::Base
  has_many :suites, :dependent => :destroy
  has_one :baseline_suite, class_name: 'Suite'
  after_initialize :create_slug

  def create_slug
    self.slug ||= name.to_s.parameterize
  end

  def to_param
    slug
  end
end
