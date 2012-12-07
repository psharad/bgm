# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def expiration_in_words(expiration)
    distance_of_time_in_words(expiration - Time.now)
  end
  
  def photo_display(group)
    if group.photo_file_name.nil?
      if group.gender == 'Men'
        image_tag 'male.png', :alt => 'men', :height => '50'
      elsif group.gender == 'Women'
        image_tag 'female.png', :alt => 'women', :height => '50'
      elsif group.gender == 'Mixed'
        image_tag 'mixed.png', :alt => 'mixed', :height => '50'
      end
    else
      image_tag group.photo.url(:small)
    end
  end
  
  def photo_in_view_group(group, dtype=nil, gender=nil)
    str = []
    if group.photo_file_name.nil?
      if (gender == 'Male') or (group.gender == 'Men')
        str <<  '/images/male.png'
        str <<  'men'
        str << '50px'
        str <<  '/images/male.png'
      elsif (gender == 'Female') or (group.gender == 'Women')
        str <<  '/images/female.png'
        str <<  'female'
        str << '50px'
        str <<  '/images/female.png'
      elsif group.gender == 'Mixed'
        str <<  '/images/mixed.png'
        str <<  'mixed'
        str << '50px'
        str <<  '/images/mixed.png'
      end
    else
      str << group.photo.url(:small)
      if dtype.nil?
        str << group.name
      end
      str << '100%'
      str << group.photo.url(:original)
    end

    return str

  end
  
  def photo_member_view(member)
    str = []
    if member.photo_file_name.nil? 
      if member.sex == 'Male' or member.sex == 'Men'
        str <<  '/images/male.png'
        str <<  'men'
        str << '50px'
        str <<  '/images/male.png'
      elsif member.sex == 'Female' or member.sex == 'Women'
        str <<  '/images/female.png'
        str <<  'female'
        str << '50px'
        str <<  '/images/female.png'
      end
    else
      str << member.photo.url(:small)
      str << member.sex
      str << '100%'
      str << member.photo.url(:original)
    end

    return str

  end

  def facebook_photo(data)
    begin
      image_tag(current_fb_session.fql("select src from photo where aid='#{data}'").first.src, :style => "width:100px")
    rescue
      image_tag("questionmark.jpg", :style => "width:100px")
    end
  end
  
  def gender_check(group)
    if group.members.all(:select => 'distinct sex').first.sex == "Women"
      "Women"
    elsif group.members.all(:select => 'distinct sex').first.sex == "Men"
      "Men"
    else
      "Mixed"
    end
  end
  
  def display_content_with_links(tweet)
    tweet.gsub(/(http:\/\/[a-zA-Z0-9\/\.\+\-_:?&=]+)/) {|a| "<a href=\"#{a}\" target=\"_blank\">#{a}</a>"}
  end
  
  def list_of_cities(type=nil)
    # old code
    # return [['New York City, NY', '1'], ['Buffalo, NY', '33'], ['Los Angeles, CA', '140'], ['Richmond, VA', '204']]
    # case type
    # when 'select_tag'
    #   return [['Select', nil], ['New York City, NY', '1'], ['Richmond, VA', '204']]
    # else
    #   return [['New York City, NY', '1'], ['Richmond, VA', '204']]
    # end
    
    city_list = []
    
    case type
    when 'select_tag'
      city_list << ['City', nil]
    when 'optional_tag'
      city_list << ['Optional', nil]
    else
    end
      
    # if type.eql? 'select_tag'
    #   city_list << ['Select', nil]
    # end
    
    City.displayed.each do |city|
      city_list << [city.abbrev, city.id]
    end
    
    return city_list
  end
  
  def list_size_group(type=nil)
    case type
    when 'age'
      range = 18..99
      arr = [['Age', nil]]
    else
      range = 2..10
      arr = [['Size Of My Group', nil]]
    end
    #arr = [['Age', nil]]
    range.each do |r|
      rw = [r,r]
      arr << rw
    end
    return arr
  end
  
  def blogger_latest_post(blogger)
    admin = Admin.find_by_username(blogger)
    if admin
      post  = admin.posts.last(:conditions => false)
    end
    return post
  end
  
  def graph_picture(data, type ='large')
    "https://graph.facebook.com/#{data}/picture?type=#{type}"
  end
  
  def should_be_scrolled(cn, ac)
    if cn.downcase.eql?('groups') && ac.downcase.eql?('show')
      return true
    else
      return false
    end
  end

  def list_object(obj, type=nil)
    arr = []
    obj.find(:all).each do |p|
      item = [ p.text, p.id ]
      arr << item
    end
    if type == 'select_tag'
      arr.insert(0, ['Select', nil])
    end

    return arr
  end
  
  def clear_notice(n)
    flash[:notice] = ''
    return n
  end



end
