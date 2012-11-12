class Call < ActiveRecord::Base
  validates_presence_of :call_sid,
                        :phone_number,
                        :contact_number,
                        :question

  def phone_number
    format_phone(self[:phone_number])
  end

  def contact_number
    format_phone(self[:contact_number])
  end

  private

  def format_phone(number)
    if number.length == 10
      number = number.sub(/(\d{3})(\d{3})(\d{4})/, "(\\1) \\2-\\3")
    elsif number.length == 7
      number = number.sub(/(\d{3})(\d{4})/, "\\1-\\2")
    end
    number
  end
end
