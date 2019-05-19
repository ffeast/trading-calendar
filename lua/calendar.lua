MARKET = require("market")
TRADING_DAYS = require("calendar-data")

local mod = {}

local function is_sane_date(year, month, day)
    if TRADING_DAYS[year] == nil then
        return false
    end
    if TRADING_DAYS[year][month] == nil then
        return false
    end

    return true
end

function mod.is_nth_trading_day(year, month, day, n)
    if is_sane_date(year, month, day) == false then
        return nil
    end
    local days = TRADING_DAYS[year][month]
    local norm_n
    if n > 0 then
        norm_n = n
    else
        norm_n = #days + n + 1
    end

    for i, dayno in ipairs(days) do
        if day == dayno then
            if i == norm_n then
                return true
            else
                return false
            end
        end
    end

    return false
end

function mod.is_first_trading_day(year, month, day)
    return mod.is_nth_trading_day(year, month, day, 1)
end

function mod.is_last_trading_day(year, month, day)
    return mod.is_nth_trading_day(year, month, day, -1)
end

function mod.is_trading_day(year, month, day)
    if is_sane_date(year, month, day) == false then
        return nil
    end
    for i, dayno in ipairs(TRADING_DAYS[year][month]) do
        if day == dayno then
            return true
        end
    end
    return false
end

function mod.is_first_minute(market, hour, minute)
    if market == MARKET.MOEX.STOCKS or market == MARKET.MOEX.FUTS then
        if hour == 10 and minute == 0 then
            return true
        end
        return false
    end
    return nil
end

function mod.is_last_minute(market, hour, minute)
    if market == MARKET.MOEX.STOCKS then
        return hour == 18 and minute == 39
    elseif market == MARKET.MOEX.FUTS then
        return hour == 23 and minute == 49
    end
    return nil
end

function mod.is_closing_auction(market, hour, minute)
    if market == MARKET.MOEX.STOCKS then
        if hour == 18 and minute >= 40 and minute < 45 then
            return true
        else
            return false
        end
    elseif market == MARKET.MOEX.FUTS then
        return false
    end
    return nil
end

function mod.is_opening_auction(market, hour, minute)
    if market == MARKET.MOEX.STOCKS then
        if hour == 9 and minute >= 50 and minute < 59 then
            return true
        else
            return false
        end
    elseif market == MARKET.MOEX.FUTS then
        return false
    end
    return nil
end

function mod.parse_datetime(date, time)
    local date = mod.parse_date(date)
    if date == nil then
        return nil
    end
    local time = mod.parse_time(time)
    if time == nil then
        return nil
    end
    return {
        day = date.day,
        month = date.month,
        year = date.year,
        hour = time.hour,
        min = time.min,
        sec = time.sec
    }
end

function mod.parse_date(date)
    local day, month, year = string.match(date, "(%d+).(%d+).(%d+)")
    if day == nil then
        return nil
    end
    day = tonumber(day)
    month = tonumber(month)
    year = tonumber(year)
    if (month < 1
            or month > 12
            or day < 1
            or day > 31) then
        return nil
    end
    return {
        day = day,
        month = month,
        year = year
    }
end

function mod.parse_time(time)
    local hour, min, sec = string.match(time, "(%d+)%p(%d+)%p(%d+)")
    if hour == nil then
        return nil
    end
    hour = tonumber(hour)
    min = tonumber(min)
    sec = tonumber(sec)
    if (hour > 23
            or min > 59
            or sec > 59) then
        return nil
    end
    return {
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    }
end

function mod.get_weekday(year, month, day)
    return os.date("*t", os.time{year=year, month=month, day=day})["wday"]
end

function mod.format_date(year, month, day, format)
    if format == nil then
        error("empty format")
    end
    return os.date(format, os.time{year=year, month=month, day=day})
end

function mod.format_time(hour, min, sec, format)
    if format == nil then
        error("empty format")
    end
    if not (hour >= 0 and hour <= 23) then
        error("invalid hour: " .. hour)
    end
    if not (min >= 0 and min <= 59) then
        error("invalid min: " .. min)
    end
    if not (sec >= 0 and sec <= 59) then
        error("invalid sec: " .. sec)
    end
    local time_struct = {
        year = 2019,
        month = 1,
        day = 1,
        hour = hour,
        min = min,
        sec = sec
    }
    return os.date(format, os.time(time_struct))
end

function mod.get_weekday_name(year, month, day)
    local wday = mod.get_weekday(year, month, day)
    return ({"sun", "mon", "tue", "wed", "thu", "fri", "sat" })[wday]
end
return mod
