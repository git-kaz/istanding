module TopHelper
  def hp_color(hp)
    case hp
    when 81..100 then "#6A9B76"
    when 61..80  then "#8FB84A"
    when 41..60  then "#EFC027"
    when 21..40  then "#EF7F27"
    else              "#E24B4A"
    end
  end
end
