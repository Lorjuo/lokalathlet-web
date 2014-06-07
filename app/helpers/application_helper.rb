module ApplicationHelper
  # http://andre.arko.net/2013/02/02/nested-layouts-on-rails--31/
  # or this for haml
  # http://stackoverflow.com/questions/8885651/switch-layout-columns-based-on-controller
  def inside_layout(parent_layout)
    view_flow.set :layout, capture { yield }
    render template: "layouts/#{parent_layout}"
  end
end
