calendar = require("calendar")

describe("is_trading_day", function()
    it("true", function()
        assert.is_true(calendar.is_trading_day("MOEX", 2019, 1, 3))
        assert.is_true(calendar.is_trading_day("MOEX", 2021, 11, 25))
    end)

    it("false", function()
        assert.is_false(calendar.is_trading_day("MOEX", 2019, 2, 2))
        assert.is_false(calendar.is_trading_day("MOEX", 2019, 2, 30))
        assert.is_false(calendar.is_trading_day("MOEX", 2019, 2, 30))
        assert.is_false(calendar.is_trading_day("NYSE", 2021, 11, 25))
        assert.is_false(calendar.is_trading_day("NASDAQ", 2021, 11, 25))
    end)

    it("nil", function()
        assert.is_nil(calendar.is_trading_day("MOEX", 1990, 1, 1))
        assert.is_nil(calendar.is_trading_day("NYSE", 1990, 1, 1))
    end)
end)

describe("is_nth_trading_day", function()
    it("true", function()
        assert.is_true(calendar.is_nth_trading_day("MOEX", 2019, 1, 3, 1))
        assert.is_true(calendar.is_nth_trading_day("MOEX", 2019, 1, 4, 2))
        assert.is_true(calendar.is_nth_trading_day("MOEX", 2019, 1, 31, -1))
        assert.is_true(calendar.is_nth_trading_day("MOEX", 2019, 1, 3, -20))
        assert.is_true(calendar.is_nth_trading_day("MOEX", 2019, 12, 2, 1))
    end)

    it("false", function()
        assert.is_false(calendar.is_nth_trading_day("MOEX", 2019, 1, 3, 2))
        assert.is_false(calendar.is_nth_trading_day("MOEX", 2019, 1, 4, -1))
        assert.is_false(calendar.is_nth_trading_day("MOEX", 2019, 1, 31, -2))
        assert.is_false(calendar.is_nth_trading_day("MOEX", 2019, 1, 3, -25))
    end)

    it("nil", function()
        assert.is_nil(calendar.is_trading_day("MOEX", 1990, 1, 1))
        assert.is_nil(calendar.is_trading_day("NYSE", 1990, 1, 1))
        assert.is_nil(calendar.is_trading_day("MOEX", 2019, 15, 15))
    end)
end)

describe("is_first_trading_day", function()
    it("true", function()
        assert.is_true(calendar.is_first_trading_day("MOEX", 2019, 2, 1))
    end)
    it("false", function()
        assert.is_false(calendar.is_first_trading_day("MOEX", 2019, 2, 2))
        assert.is_false(calendar.is_first_trading_day("MOEX", 2019, 2, 28))
    end)
end)

describe("is_last_trading_day", function()
    it("true", function()
        assert.is_true(calendar.is_last_trading_day("MOEX", 2019, 1, 31))
        assert.is_true(calendar.is_last_trading_day("MOEX", 2019, 2, 28))
        assert.is_true(calendar.is_last_trading_day("MOEX", 2019, 12, 31))
    end)
    it("false", function()
        assert.is_false(calendar.is_last_trading_day("MOEX", 2019, 2, 27))
        assert.is_false(calendar.is_last_trading_day("MOEX", 2019, 2, 1))
    end)
end)

describe("is_first_minute", function()
    describe("when stocks", function()
        it("and 10:00", function()
            assert.is_true(calendar.is_first_minute("MOEX", "TQBR", 10, 0))
        end)
        it("and not 10:00", function()
            assert.is_false(calendar.is_first_minute("MOEX", "TQBR", 10, 5))
        end)
    end)

    describe("when futures", function()
        it("and 10:00", function()
            assert.is_true(calendar.is_first_minute("MOEX", "SPBFUT", 10, 0))
        end)
        it("and not 10:00", function()
            assert.is_false(calendar.is_first_minute("MOEX", "SPBFUT", 10, 5))
        end)
    end)

    describe("when unknown market", function()
        it("and 10:00", function()
            assert.is_nil(calendar.is_first_minute("MOEX", "UNK", 10, 0))
        end)
        it("and not 10:00", function()
            assert.is_nil(calendar.is_first_minute("MOEX", "UNK", 10, 5))
        end)
    end)
end)

describe("is_last_minute", function()
    describe("when stocks", function()
        it("and 18:39", function()
            assert.is_true(calendar.is_last_minute("MOEX", "TQBR", 18, 39))
        end)
        it("and not 18:39", function()
            assert.is_false(calendar.is_last_minute("MOEX", "TQBR", 18, 40))
        end)
    end)

    describe("when futures", function()
        it("and 23:49", function()
            assert.is_true(calendar.is_last_minute("MOEX", "SPBFUT", 23, 49))
        end)
        it("and not 23:49", function()
            assert.is_false(calendar.is_last_minute("MOEX", "SPBFUT", 23, 50))
        end)
    end)

    describe("when unknown market", function()
        it("and 18:39", function()
            assert.is_nil(calendar.is_last_minute("MOEX", "UNK", 18, 39))
        end)
        it("and not 18:39", function()
            assert.is_nil(calendar.is_last_minute("MOEX", "UNK", 10, 30))
        end)
    end)
end)

describe("is_closing_auction", function()
    describe("when stocks", function()
        it("and 18:40", function()
            assert.is_true(calendar.is_closing_auction("MOEX", "TQBR", 18, 40))
        end)
        it("and 18:44", function()
            assert.is_true(calendar.is_closing_auction("MOEX", "TQBR", 18, 44))
        end)
        it("and 18:46", function()
            assert.is_false(calendar.is_closing_auction("MOEX", "TQBR", 18, 46))
        end)
        it("and 17:00", function()
            assert.is_false(calendar.is_closing_auction("MOEX", "TQBR", 17, 0))
        end)
    end)

    describe("when futures", function()
        it("and 18:40", function()
            assert.is_false(calendar.is_closing_auction("MOEX", "SPBFUT", 18, 40))
        end)
        it("and 22:00", function()
            assert.is_false(calendar.is_closing_auction("MOEX", "SPBFUT", 22, 0))
        end)
    end)

    describe("when usa via moex", function()
        it("and 22:58", function()
            assert.is_true(calendar.is_closing_auction("MOEX", "STOCK_USA", 22, 58))
        end)
        it("and 22:59", function()
            assert.is_false(calendar.is_closing_auction("MOEX", "STOCK_USA", 22, 59))
            assert.is_false(calendar.is_closing_auction("MOEX", "STOCK_USA", 22, 57))
        end)
    end)

    describe("when unknown market", function()
        it("and 18:40", function()
            assert.is_nil(calendar.is_closing_auction("MOEX", "UNK", 18, 40))
        end)
        it("and 10:00", function()
            assert.is_nil(calendar.is_closing_auction("MOEX", "UNK", 10, 0))
        end)
    end)
end)

describe("is_opening_auction", function()
    describe("when stocks", function()
        it("and 9:50", function()
            assert.is_true(calendar.is_opening_auction("MOEX", "TQBR", 9, 50))
        end)
        it("and 9:58", function()
            assert.is_true(calendar.is_opening_auction("MOEX", "TQBR", 9, 58))
        end)
        it("and 10:00", function()
            assert.is_false(calendar.is_opening_auction("MOEX", "TQBR", 10, 0))
        end)
    end)

    describe("when futures", function()
        it("and 9:50", function()
            assert.is_false(calendar.is_opening_auction("MOEX", "SPBFUT", 9, 50))
        end)
        it("and 22:00", function()
            assert.is_false(calendar.is_opening_auction("MOEX", "SPBFUT", 22, 0))
        end)
    end)

    describe("when unknown market", function()
        it("and 9:52", function()
            assert.is_nil(calendar.is_opening_auction("MOEX", "UNK", 9, 52))
        end)
        it("and 10:00", function()
            assert.is_nil(calendar.is_opening_auction("MOEX", "UNK", 10, 0))
        end)
    end)
end)

describe("parse_date", function()
    it("valid 1-digit day value", function()
        local dt = calendar.parse_date("7.03.2019")
        assert.are.same({
            day = 7,
            month = 3,
            year = 2019
        }, dt)
    end)
    it("valid 2-digit day value", function()
        local dt = calendar.parse_date("07.03.2019")
        assert.are.same({
            day = 7,
            month = 3,
            year = 2019
        }, dt)
    end)
    it("valid 1-digit month value", function()
        local dt = calendar.parse_date("27.3.2019")
        assert.are.same({
            day = 27,
            month = 3,
            year = 2019
        }, dt)
    end)
    it("invalid value", function()
        assert.is_nil(calendar.parse_date("broken"))
        assert.is_nil(calendar.parse_date("27.53.2019"))
        assert.is_nil(calendar.parse_date("270.12.2019"))
    end)
end)

describe("parse_time", function()
    it("valid 1-digit hour value", function()
        local time = calendar.parse_time("9:15:52")
        assert.are.same({
            hour = 9,
            min = 15,
            sec = 52
        }, time)
    end)
    it("valid 2-digit hour value", function()
        local time = calendar.parse_time("09:15:52")
        assert.are.same({
            hour = 9,
            min = 15,
            sec = 52
        }, time)
    end)
    it("valid 1-digit minute value", function()
        local time = calendar.parse_time("09:1:52")
        assert.are.same({
            hour = 9,
            min = 1,
            sec = 52
        }, time)
    end)
    it("valid 1-digit seconds value", function()
        local time = calendar.parse_time("9:15:2")
        assert.are.same({
            hour = 9,
            min = 15,
            sec = 2
        }, time)
    end)
    it("invalid value", function()
        assert.is_nil(calendar.parse_time('broken'))
        assert.is_nil(calendar.parse_time("55:12:05"))
        assert.is_nil(calendar.parse_time("12:88:12"))
        assert.is_nil(calendar.parse_time("12:13:77"))
    end)
end)

describe("parse_datetime", function()
    it("valid value with 2-digit hour", function()
        local dt = calendar.parse_datetime("27.03.2019", "22:15:52")
        assert.are.same({
            day = 27,
            month = 3,
            year = 2019,
            hour = 22,
            min = 15,
            sec = 52
        }, dt)
    end)
    it("valid value with 1-digit hour", function()
        local dt = calendar.parse_datetime("27.03.2019", "9:15:52")
        assert.are.same({
            day = 27,
            month = 3,
            year = 2019,
            hour = 9,
            min = 15,
            sec = 52
        }, dt)
    end)
    it("broken date", function()
        local dt = calendar.parse_datetime("broken date", "22:15:52")
        assert.is_nil(dt)
    end)
    it("broken time", function()
        local dt = calendar.parse_datetime("27.03.2019", "broken time")
        assert.is_nil(dt)
    end)
end)

describe("get_weekday", function()
    it("valid value", function()
        assert.are.equal(calendar.get_weekday(2019, 3, 24), 1)
        assert.are.equal(calendar.get_weekday(2019, 3, 25), 2)
        assert.are.equal(calendar.get_weekday(2019, 3, 26), 3)
        assert.are.equal(calendar.get_weekday(2019, 3, 27), 4)
        assert.are.equal(calendar.get_weekday(2019, 3, 28), 5)
        assert.are.equal(calendar.get_weekday(2019, 3, 29), 6)
        assert.are.equal(calendar.get_weekday(2019, 3, 30), 7)
    end)
    it("invalid value", function()
        assert.has_error(function()
            calendar.get_weekday(2019, "oops", 24)
        end)
    end)
end)

describe("format_date", function()
    it("valid value", function()
        assert.are.equal(calendar.format_date(2019, 1, 1, '%Y-%m-%d'), "2019-01-01")
        assert.are.equal(calendar.format_date(2019, 5, 10, '%Y-%m'), "2019-05")
        assert.are.equal(calendar.format_date(2019, 12, 31, '%Y'), "2019")
    end)
    it("invalid value", function()
        assert.has_error(function()
            calendar.format_date(2019, "oops", 24, '%Y-%m-%d')
        end)
        assert.has_error(function()
            calendar.format_date(2019, 5, 24)
        end)
    end)
end)

describe("format_time", function()
    it("valid value", function()
        assert.are.equal(calendar.format_time(0, 0, 0, '%H:%M:%S'), "00:00:00")
        assert.are.equal(calendar.format_time(1, 1, 1, '%H:%M'), "01:01")
        assert.are.equal(calendar.format_time(23, 59, 59, '%H'), "23")
    end)
    it("invalid value", function()
        assert.has_error(function()
            calendar.format_time(10, "oops", 3, '%H:%M:%S')
        end)
        assert.has_error(function()
            calendar.format_time("oops", 15, 3, '%H:%M:%S')
        end)
        assert.has_error(function()
            calendar.format_time(10, 15, "oops", '%H:%M:%S')
        end)
        assert.has_error(function()
            calendar.format_time(10, 15, 20)
        end)
    end)
end)

describe("get_weekday_name", function()
    it("valid value", function()
        assert.are.equal(calendar.get_weekday_name(2019, 3, 24), "sun")
        assert.are.equal(calendar.get_weekday_name(2019, 3, 25), "mon")
        assert.are.equal(calendar.get_weekday_name(2019, 3, 26), "tue")
        assert.are.equal(calendar.get_weekday_name(2019, 3, 27), "wed")
        assert.are.equal(calendar.get_weekday_name(2019, 3, 28), "thu")
        assert.are.equal(calendar.get_weekday_name(2019, 3, 29), "fri")
        assert.are.equal(calendar.get_weekday_name(2019, 3, 30), "sat")
    end)
    it("invalid value", function()
        assert.has_error(function()
            calendar.get_weekday_name(2019, "oops", 24)
        end)
    end)
end)
