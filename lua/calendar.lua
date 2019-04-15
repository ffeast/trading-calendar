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
    day, month, year = string.match(date, "(%d%d).(%d%d).(%d%d%d%d)")
    if day == nil then
        return nil
    end
    hour, min, sec = string.match(time, "(%d+)%p(%d%d)%p(%d%d)")
    if hour == nil then
        return nil
    end
    return {
        day = tonumber(day),
        month = tonumber(month),
        year = tonumber(year),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec)
    }
end

function mod.get_weekday(year, month, day)
    return os.date("*t", os.time{year=year, month=month, day=day})["wday"]
end

function mod.get_weekday_name(year, month, day)
    local wday = mod.get_weekday(year, month, day)
    return ({"sun", "mon", "tue", "wed", "thu", "fri", "sat" })[wday]
end
return mod
