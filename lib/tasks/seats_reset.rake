namespace :seats_reset do
  desc "全てクローズ"
  task close: :environment do

    Seat.find_each {|seat| seat.update!(is_used: true)}

  end

  desc "全てオープン"
  task open: :environment do

    Seat.find_each {|seat| seat.update!(is_used: false)}

  end
end