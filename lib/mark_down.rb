# coding: utf-8
class MarkDown
  def self.format(text)
    # self.link_mention_user(text)
    # self.link_mention_floor(text)
    return text
  end

  def self.find_association_users(text)
    users = text.scan(self.find_user_regexp)
    users.collect! {|user| user[1]}
    users.uniq
  end

  private

  def self.link_mention_floor(text)
    text.gsub!(/#(\d+)([楼Ff])/) {
    %(<a href="#reply#{$1}" class="at_floor" data-reply-floor="#{$1}">##{$1}#{$2}</a>)}
  end

  # convert '@user' to link
  # match any user even not exist.
  def self.link_mention_user(text)
    text.gsub!(self.find_user_regexp) {
    %(#{$1}<a href="/users/#{User.find_by_nickname($2).number}" class="at_user" title="@#{$2}"><i>@</i>#{$2}</a>)}
  end

  def self.find_user_regexp
    /(^|[^a-zA-Z0-9_!#\$%&*@＠])@([\u4e00-\u9fa5_a-zA-Z0-9]{1,20})/io
  end
end
