json.vouchers vouchers do | voucher |
  json.partial! '/api/vouchers/voucher', voucher: voucher
end