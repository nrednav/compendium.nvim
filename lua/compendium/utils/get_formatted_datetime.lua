local function get_day_with_ordinal(day)
  if day > 3 and day < 21 then
    return day .. "th"
  end

  local last_digit = day % 10

  if last_digit == 1 then
    return day .. "st"
  elseif last_digit == 2 then
    return day .. "nd"
  elseif last_digit == 3 then
    return day .. "rd"
  else
    return day .. "th"
  end
end

local function get_formatted_datetime()
  local now = os.date("*t")
  local year = now.year
  ---@diagnostic disable-next-line: param-type-mismatch
  local month = os.date("%B", os.time(now))
  local day = now.day
  local day_with_ordinal = get_day_with_ordinal(day)
  local time_24h = string.format("%02d:%02d", now.hour, now.min)

  return string.format("%d - %s %s, %s", year, month, day_with_ordinal, time_24h)
end

return get_formatted_datetime
