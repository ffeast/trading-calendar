import json
import logging
import argparse

"""
This is a tool to convert the trading calendar into .lua

It can be further extended for other markets/schedules
"""

def convert_to_lua(calendar, target, spaces):
    logging.info('generating %s', target.name)
    target.write('--- THIS IS AUTOMATICALLY GENERATED FILE ---\n')
    target.write('--- PLEASE REFER TO https://github.com/ffeast/trading-calendar ---\n')
    target.write('return {\n')
    for exchange_i, exchange in enumerate(calendar):
        if exchange_i > 0:
                target.write(',\n')
        target.write(' ' * spaces + exchange + ' = {\n')
        for year_i, year in enumerate(calendar[exchange]):
            if year_i > 0 :
                target.write(',\n')
            target.write(' ' * spaces * 2 + '[' + year + '] = {\n')
            for month_i, month in enumerate(calendar[exchange][year]):
                if month_i > 0:
                    target.write(',\n')
                target.write(' ' * spaces * 3 + '{')
                target.write(', '.join(map(str, month)))
                target.write('}')
            target.write('\n')
            target.write(' ' * spaces * 2 + '}')
        target.write('\n')
        target.write(' ' * spaces + '}')
    target.write('\n}')
    logging.info('done')


def main():
    logging.basicConfig(format='%(message)s', level=logging.INFO)
    calendar = json.load(open('./trading-days.json'))
    with open('./lua/calendar-data.lua', 'w') as lua_target:
        convert_to_lua(calendar, lua_target, spaces=4)

if __name__ == '__main__':
    main()
