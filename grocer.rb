def consolidate_cart(cart)
  counted_cart = {}
  cart.each do |hash|
    hash.each do |key, value|
      if counted_cart[key]
        counted_cart[key][:count] += 1
      else
        counted_cart[key] = value
        counted_cart[key][:count] = 1

    end
  end
end
return counted_cart

end

def apply_coupons(cart, coupons)
 if coupons == []
   return cart
 end

  applied = cart
  coupons.each do |coupon|
    coupon_num = coupon[:num]
    item = coupon[:item]
      if applied["#{item} W/COUPON"]
        applied["#{item} W/COUPON"][:count] += coupon_num
        applied[item][:count] -= coupon_num
      elsif applied[item]
        applied["#{item} W/COUPON"] = {:price => coupon[:cost] / coupon_num,
          :clearance => cart[item][:clearance],
          :count => coupon_num }
          applied[item][:count] -= coupon_num
      end

  end

  return applied
end


def apply_clearance(cart)
  cleared = Hash.new
  cart.each do |key, value|
    cleared[key] = value
    if cleared[key][:clearance] == true
      saved = cleared[key][:price]. * 0.2
      final = cleared[key][:price] - saved
      cleared[key][:price] = final.round(2)
end
  end
  return cleared
end

def checkout(cart, coupons)
  total = 0
  consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated, coupons)
  cleared = apply_clearance(coupons_applied)
  consolidate_cleared = consolidate_cart(cleared)
  consolidate_cleared.each do |k, v|
    total += cleared[k][:price]
  end
  if total >= 100
    total = total * 0.90
  end
  return total

end
