module ApplicationHelper

  def all_categories
    Category.all
  end

  def fix_url(url)
    url.start_with?('http://') ? url : "http://#{url}"
  end

  def custom_time_ago_in_words(time)
    difference_day = (Time.zone.now.to_date - time.to_date).to_i

    if difference_day >= 1
      if logged_in? && !current_user.time_zone.blank?
        time = time.in_time_zone(current_user.time_zone)
      end

      "at #{time.strftime("%m/%d/%Y %H:%M:%S %Z")}" #06/23/2014 23:20:59 UTC
    else
      "#{time_ago_in_words(time)} ago"
    end
  end

  def asia_zones
    @asia_zones ||= ActiveSupport::TimeZone.all.find_all { |z| z.name =~ /Taipei|Beijing|Hong Kong|Singapore|Osaka|Sapporo|Seoul|Tokyo/ }
  end
end
