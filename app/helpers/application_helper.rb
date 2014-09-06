module ApplicationHelper
  #Generates sequence of anchors from the current path by splitting it into its constituent 'pages'
  #The name of the current page is the only item in the sequence not marked up with a anchor.
  #Cutoff: array of strings which would abort the anchor sequence generation
  def breadcrumbs(cutoff = [])
    partial_path = ''
    pages = request.path[1..-1].split('/')
    last_crumb = !cutoff.include?(pages[-1])    #if URL is just one level deep (current page), do the cutoff check right away
    content_tag(:span, class: "breadcrumbs") do
      pages[0..-2].each do |page| 
        if cutoff.include?(page)
          last_crumb = false
          break
        end
        partial_path = "#{partial_path}/#{page}"
        concat link_to(page, partial_path, title: "Go to #{page}", class: 'crumb-link')
      end
      concat content_tag(:span, pages[-1], class: 'crumb-current') if last_crumb
    end
  end

  #Employs the current controller and action names to generate a human-readable page title
  #Tagline: string used for the homepage instead of the aforementioned names. Useful for SEO purposes.  
  def page_titles(tagline)
    if request.path == root_path
      tagline
    elsif request.path['edit'] || request.path['new']
      "#{action_name.capitalize} #{controller_name.singularize}"
    else
      "#{controller_name.singularize.capitalize} #{action_name}"
    end
  end

  #It checks for names of actions normally coupled with form-like views.
  #If the current action is of such name, add a link to the "filtered version" of the previously visited URL.
  #See ApplicationController's method 'back_url' for more info.
  def cancel_form
    if ['new', 'edit', 'create', 'update'].include?(action_name)
      link_to('Cancel', back_url, title: 'Back to previous page')
    end
  end

  #Outputs a standardized login link
  def login_link
    link_to("Log in", new_session_path, title: "Go to the login page", class: 'login-link') unless controller_name == 'sessions'
  end

  #Outputs a standardized signup link
  def signup_link
    link_to("Sign up", new_user_path, title: "Register as a new user", class: 'signup-link') unless controller_name == 'users'
  end
end
