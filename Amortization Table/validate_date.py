# date validation function for use in amortization table
from datetime import datetime
def validate_date(start_date, end_date):
    if isinstance(start_date, datetime) and isinstance(end_date, datetime):
        return True
    elif isinstance(start_date, str) and isinstance(end_date, str):
        try:
            datetime.strptime(start_date, '%Y-%m-%d')
            datetime.strptime(end_date, '%Y-%m-%d')
            return True
        except ValueError:
            return False
    else:
        return False
