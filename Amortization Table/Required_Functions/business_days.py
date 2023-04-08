from datetime import datetime, timedelta

def business_days(start_date, end_date):
    dates = []
    delta = timedelta(days=1)
    while start_date <= end_date:
        if start_date.weekday() not in [5, 6]: # check if the date is not a Saturday or Sunday
            dates.append(start_date.strftime('%Y-%m-%d'))
        start_date += delta

    return dates