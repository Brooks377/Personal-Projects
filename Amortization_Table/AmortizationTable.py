# This is the .py version of the Amortization Scheduler project
#
#
# just spend an hour fixing a problem that didn't exist. All because Jan 1 2033 is a weekend... love bdays
#
# INFO:
#
# All the bank loan amort calcs I found rounded the interest payment amount, and then calculate the total payment 
#  based on the total interest + the principal
#
# TO FIX:
#
# A way for the user to input their personalized parameters using a terminal.
#
# Final x-axis tic set to total payment period amount
#
# State that principal paid is actually: "principal paid (minus bonus)"
#  this is kindof implied but could be clearer
#
# Arguably the bonus payment type: seems standard (see below in TO ADD section)
#
# Add back bonus indicator in final period/row (or analyze why not)
#
# TO ADD:
# M-365 (365/365 or month-actual with 365 days instead of 360
#
# A pie graph that shows total amount paid in interest vs pricipal
#
# add a folder for the imported functions and change the import path
#
# add bar graph monthly payment distribution
#
# add bonus payment type (default=by_periods) (options: yearly, one-time)
#  for yearly: add optional bonus_date parameter (default=start_date)
#    bonus_date would act double as the one-time payment date parameter
#

import os
from datetime import datetime, timedelta
from dateutil.relativedelta import relativedelta
import pandas as pd
import calendar
from statistics import mean
import seaborn as sns
import matplotlib.pyplot as plt

# functions created for this project (should create links if I ever share this)
from Required_Functions.validate_date import validate_date
from Required_Functions.business_days import business_days
from Required_Functions.cumulative_values import cumulative_values


def loan_amortization(principal, interest_rate,  term_years, start_date, periodtype="M-30", bonus=0, PLOT=False):
    
    """ 
    Args:
        principal (int or float): The principal amount of the loan.
        interest_rate (int or float): The annual interest rate, expressed as a percent (e.g. 5% = 5).
        term_years (int or float): Loan/Borrowing term in years.
        start_date (str or datetime): The start date of the loan as a string in 'YYYY-MM-DD' format or as a datetime object.
        periodtype (str, default="M-30"): The type of period to use for the loan payments, which can be one of the following:
            'D' (daily)
            'bdays' (daily, only includes business days)
            'W' (weekly)
            'BW' (biweekly)
            'M-30' (months where there is 30 days per month and 360 days per year (30/360))
            'M-Actual' (months where months' lengths are accurate, and there are 360 days per year (Actual/360))
            'Q' (quarterly)
            'S' (semi-annual)
            'Y' (Annual)
        bonus= (int or float, default=0): Optional, additional principal paid per period.
        PLOT= (Bool, default=False): With PLOT set to True, the function will create a folder in the cwd
                                    and download the loan amortization graph as a .png file.
                                - The .png file will have the following naming structure:
                                    - /Loan_Graphs/'Principal_Rate_TermYears_StartDate_PeriodType_bonus.png'
    Returns:
        pandas.DataFrame: A DataFrame containing the amortization schedule for the loan
    """
    # input validation for start_date
    if validate_date(start_date) is False:
        raise TypeError("start_date must be a string in 'YYYY-MM-DD' format or a datetime object")

    # if the date is in the string format, convert it
    if not isinstance(start_date, datetime):
        start_date = datetime.strptime(start_date, '%Y-%m-%d')

    # input type checking for principal, interest_rate, term_years, and bonus
    if not isinstance(principal, (int, float)):
        raise TypeError("Principal amount should be numeric (int or float)")
    if not isinstance(interest_rate, (int, float)):
        raise TypeError("Interest rate should be numeric and in % (int or float)")
    if not isinstance(term_years, (int, float)):
        raise TypeError("term_years should be numeric (int or float)")
    if not isinstance(bonus, (int, float)):
        raise TypeError("bonus should be numeric (int or float)")
    if bonus < 0:
        raise TypeError("bonus should be a positive integer")

    # shift the day forward one when using Daily to assume no payment is made today
    if periodtype == "D":
        start_date = start_date + timedelta(days=1)

    # create end date of term using term_years
    end_date = start_date + relativedelta(years=term_years)

    # create a list of business days for the bday index
    bdays_dates = business_days(start_date, end_date)

    # create a list of weeks for weekly and biweekly index, starting at second week
    week_range = pd.date_range(start=start_date + pd.Timedelta(weeks=1) + pd.Timedelta(days=1), periods=52*term_years, freq='W')
    week_list = [f'{date.week}-{date.year}' for date in week_range]

    # force start and end date to first day of month for month indexing (luv u feb)
    start_date_first = datetime(start_date.year, start_date.month, 1)
    end_date_first = datetime(end_date.year, end_date.month, 1)

    # shift start_date_first forward one month
    if start_date_first.month == 12:
        # handle special case where the month is December
        new_month = 1
        new_year = start_date_first.year + 1
    else:
        new_month = start_date_first.month + 1
        new_year = start_date_first.year
    start_date_p1 = start_date_first.replace(year=new_year, month=new_month)
    # shift end_date_first forward one month
    if end_date_first.month == 12:
        # handle special case where the month is December
        new_month = 1
        new_year = end_date_first.year + 1
    else:
        new_month = end_date_first.month + 1
        new_year = end_date_first.year
    end_date_first_p1 = end_date_first.replace(year=new_year, month=new_month)

    # create month_dates index
    month_dates = [start_date_p1.strftime("%m""-""%Y")]
    month_dates_4D = [start_date_p1]
    current_date = start_date_p1
    while current_date < end_date_first_p1:
        current_date += relativedelta(months=1)
        month_dates_4D.append(current_date)
        month_dates.append(current_date.strftime("%m""-""%Y"))
    # remove last month because 1 is start_date
    month_dates.pop()
    month_dates_4D.pop()

    # create list of days in the month of each date
    days_in_month = [calendar.monthrange(date.year, date.month)[1] for date in month_dates_4D]

    # period-type definition
    if periodtype == 'D':
        periods = int((end_date - start_date).days)
        adjusted_rate = interest_rate / 36525
    elif periodtype == 'bdays':
        periods = len(bdays_dates)
        adjusted_rate = interest_rate / 26100
    elif periodtype == 'W':
        periods = int(52 * term_years)
        adjusted_rate = interest_rate / 5200
    elif periodtype == 'BW':
        periods = int((52 * term_years) / 2)
        adjusted_rate = interest_rate / 2600
    elif periodtype == 'M-30':
        periods = int(12 * term_years)
        adjusted_rate = interest_rate / 1200
    elif periodtype == 'M-Actual':
        periods = int(12 * term_years)
        monthly_rate = [interest_rate / 36000 * days_in_month[i] for i in range(len(month_dates))]
        adjusted_rate = mean(monthly_rate)
    elif periodtype == 'Y':
        periods = term_years
        adjusted_rate = interest_rate / 100
    elif periodtype == 'S':
        periods = int(len(month_dates[1::6]))
        adjusted_rate = interest_rate / 200
    elif periodtype == 'Q':
        periods = int(len(month_dates[1::3]))
        adjusted_rate = interest_rate / 400
    else:
        raise TypeError("periodtype should be one of the following: 'D', 'W', 'BW', 'bdays', 'M-30', 'M-Actual', 'Q', 'S', 'Y'")

    # find payment amount
    monthly_payment = (principal * adjusted_rate / (1 - (1 + adjusted_rate) ** (-periods)))
    monthly_payment_fmt = "{:,.2f}".format(monthly_payment)
    monthly_for_plot = f"{monthly_payment_fmt} + {bonus}"
    actual_payment = (principal * adjusted_rate / (1 - (1 + adjusted_rate) ** (-periods))) + bonus

    # create a list of dates for each payment
    if periodtype == 'M-Actual' or periodtype == 'M-30':
        payment_dates = month_dates
    elif periodtype == 'Y':
        payment_dates = [(start_date + relativedelta(years=1 * i)).year for i in range(periods)]
    elif periodtype == 'bdays':
        payment_dates = bdays_dates
    elif periodtype == 'W':
        payment_dates = week_list
    elif periodtype == 'BW':
        payment_dates = week_list[::2]
    elif periodtype == 'S':
        month_dates.insert(0, start_date.strftime("%m""-""%Y"))
        payment_dates = month_dates[:-6:6]
    elif periodtype == 'Q':
        payment_dates = month_dates[1::3]
    else:
        payment_dates_nfmt = [start_date + relativedelta(days=(i)) for i in range(periods)]
        payment_dates = []
        for elem in payment_dates_nfmt:
            dates_formatted = elem.strftime('%Y-%m-%d')
            payment_dates.append(dates_formatted)

    # lists for the payment number, payment amount, interest, principal, and balance
    payment_number = list(range(1, periods + 1))
    payment_amount = [actual_payment] * periods
    interest = []
    principal_paid = []
    beg_balance = [principal]
    end_balance = []
    pct_interest = []
    pct_principal = []
    bonus_list = [bonus] * periods

    # interest, principal, and balance for each payment period (exlcuding M-actual)
    if not periodtype == "M-Actual":
        for i in range(periods):
            interest.append(beg_balance[i] * adjusted_rate)
            principal_paid.append((monthly_payment) - interest[i])
            beg_balance.append(beg_balance[i] - principal_paid[i] - bonus)
            end_balance.append(beg_balance[i] - principal_paid[i] - bonus)
            pct_interest.append((interest[i] / payment_amount[i]) * 100)
            pct_principal.append(((principal_paid[i] + bonus) / payment_amount[i]) * 100)
    elif periodtype == "M-Actual":
        for i in range(periods):
            interest.append((beg_balance[i] * monthly_rate[i]))
            principal_paid.append((monthly_payment) - interest[i])
            beg_balance.append(beg_balance[i] - principal_paid[i] - bonus)
            end_balance.append(beg_balance[i] - principal_paid[i] - bonus)
            pct_interest.append((interest[i] / payment_amount[i]) * 100)
            pct_principal.append(((principal_paid[i] + bonus) / payment_amount[i]) * 100)
        principal_paid[-1] = beg_balance[-2]
        payment_amount[-1] = principal_paid[-1] + interest[-1]
        end_balance[-1] = 0

    # if bonus > 0: do fake amortization without bonus for calc of interest saved
    if bonus > 0:
        interest2 = []
        principal_paid2 = []
        beg_balance2 = [principal]
        end_balance2 = []
        if not periodtype == "M-Actual":
            for i in range(periods):
                interest2.append(beg_balance2[i] * adjusted_rate)
                principal_paid2.append((monthly_payment) - interest2[i])
                beg_balance2.append(beg_balance2[i] - principal_paid2[i])
                end_balance2.append(beg_balance2[i] - principal_paid2[i])
        elif periodtype == "M-Actual":
            for i in range(periods):
                interest2.append((beg_balance2[i] * monthly_rate[i]))
                principal_paid2.append((monthly_payment) - interest2[i])
                beg_balance2.append(beg_balance2[i] - principal_paid2[i])
                end_balance2.append(beg_balance2[i] - principal_paid2[i])

    # make the amortization-schedule dataframe
    data = {
        'Payment Number': payment_number,
        'Payment Date': payment_dates,
        'Beginning Balance': beg_balance[:-1],
        'Payment Amount': payment_amount,
        'Bonus': bonus_list,
        'Interest Paid': interest,
        'Principal Paid': principal_paid,
        'Ending Balance': end_balance,
        '% Paid In Interest': pct_interest,
        '% Paid To Principal': pct_principal
    }
    # dataframe creation
    df = pd.DataFrame(data)

    # truncate df with bonus
    if bonus > 0:
        index_balance = (df['Ending Balance'] <= 0).idxmax()
        df = df.iloc[:index_balance + 1]
        df["Principal Paid"].iloc[-1] = df["Beginning Balance"].iloc[-1]
        df["Payment Amount"].iloc[-1] = df["Principal Paid"].iloc[-1] + df["Interest Paid"].iloc[-1]
        df["Bonus"].iloc[-1] = 0
        df["Ending Balance"].iloc[-1] = 0
        periods_b4save = periods
        periods = int(len(df.index))
        # find amount saved by extra payment
        amount_saved_nfmt = sum(interest2) - df["Interest Paid"].sum()
        amount_saved = "{:,.2f}".format(amount_saved_nfmt)
        # find periods saved
        periods_saved = periods_b4save - periods

    # create stats for plot
    # create total interest ****
    total_interest_nfmt = df["Interest Paid"].sum()
    total_interest = "{:,.2f}".format(total_interest_nfmt)

    # create total payment
    total_payment_nfmt = total_interest_nfmt + principal
    total_payment = "{:,.2f}".format(total_payment_nfmt)

    # format data for graph
    if bonus > 0:
        start_value = 0
        loan_balance_list = df["Ending Balance"].tolist()
        loan_balance = loan_balance_list.copy()
        loan_balance.insert(0, principal)
        interest_list = df["Interest Paid"].tolist()
        cumulative_interest_list = cumulative_values(interest_list)
        cumulative_interest = cumulative_interest_list.copy()
        cumulative_interest.insert(0, start_value)
        principal_paid_list = df["Principal Paid"].tolist()
        principal_paid_plot = [x + bonus if i < len(principal_paid_list)-1 else x for i, x in enumerate(principal_paid_list)] 
        cumulative_principal_list = cumulative_values(principal_paid_plot)
        cumulative_principal = cumulative_principal_list.copy()
        cumulative_principal.insert(0, start_value)
    else:
        start_value = 0
        loan_balance = end_balance.copy()
        loan_balance.insert(0, principal)
        cumulative_interest_list = cumulative_values(interest)
        cumulative_interest = cumulative_interest_list.copy()
        cumulative_interest.insert(0, start_value)
        cumulative_principal_list = cumulative_values(principal_paid)
        cumulative_principal = cumulative_principal_list.copy()
        cumulative_principal.insert(0, start_value)

    # set index to dates
    df.set_index('Payment Date', inplace=True)
    if periodtype == "M-Actual" or periodtype == "M-30" or periodtype == "Q" or periodtype == "S":
        df.index.name = "Payment Month"
    elif periodtype == "W" or periodtype == "BW":
        df.index.name = "Payment Week"
    elif periodtype == "Y":
        df.index.name = "Payment Year"
    else:
        df.index.name = 'Payment Date'

    # apply formating for dollar signs and two decimals (new df to retain old format)
    df['Payment Amount'] = df['Payment Amount'].apply(lambda x: '${:,.2f}'.format(x))
    df['Interest Paid'] = df['Interest Paid'].apply(lambda x: '${:,.2f}'.format(x))
    df['Principal Paid'] = df['Principal Paid'].apply(lambda x: '${:,.2f}'.format(x))
    df['Beginning Balance'] = df['Beginning Balance'].apply(lambda x: '${:,.2f}'.format(x))
    df['Ending Balance'] = df['Ending Balance'].apply(lambda x: '${:,.2f}'.format(x))
    df['% Paid In Interest'] = df['% Paid In Interest'].apply(lambda x: '{:,.3f}%'.format(x))
    df['% Paid To Principal'] = df['% Paid To Principal'].apply(lambda x: '{:,.3f}%'.format(x))

    plot_data = {
        'Loan Balance': loan_balance,
        'Cumulative Interest': cumulative_interest,
        'Principal Paid': cumulative_principal
    }

    # make plot
    plot = sns.lineplot(data=plot_data)
    
    # find period amount
    df_length = len(df["Payment Amount"])
    index_name = df.index.name

    # tweak visual aspects of plot
    plot.set_title(f"Loan Amortization Graph (${principal:,}|{interest_rate}%|{term_years} years|{periodtype})")
    plot.set_xlabel(f"Payment Number (Total Payments: {df_length})\n(Initial {index_name}: {df.index[0]} | Final {index_name}: {df.index[-1]})")
    plot.set_ylabel("Amount (in Dollars)")
    plt.grid(True)
    plot.set_xlim(0, periods)
    plot.set_ylim(0)

    # change line color
    lines = plot.lines
    lines[0].set(color='blue', linestyle='-')
    lines[1].set(color='red', linestyle='-')
    lines[2].set(color='green', linestyle='-')

    # make sure legend matches line color
    ax = plot.axes
    handles, labels = ax.get_legend_handles_labels()
    handles[0].set(color='blue', linestyle='-')
    handles[1].set(color='red', linestyle='-')
    handles[2].set(color='green', linestyle='-')
    ax.legend(handles=handles, labels=labels, loc='center left')

    # add the total stats as annotations
    plt.annotate(f'Total Cost of Loan: ${total_payment}', xy=((periods * .3), (principal)), xytext=((periods * .279), (ax.get_ylim()[1] - (ax.get_ylim()[1] * .045))), bbox=dict(facecolor='white', boxstyle='round'))
    plt.annotate(f'Total Interest Paid: ${total_interest}', xy=((periods * .3), (principal)), xytext=((periods * .2815), (ax.get_ylim()[1] - (ax.get_ylim()[1] * .11))), bbox=dict(facecolor='white', boxstyle='round'))
    plt.annotate(f'Payment: ${monthly_for_plot}', xy=((periods * .3), (principal)), xytext=((periods * .31), (ax.get_ylim()[1] - (ax.get_ylim()[1] * .175))), bbox=dict(facecolor='white', boxstyle='round'))

    # add addition annotations if there is bonus
    if bonus > 0:
        plt.annotate(f'Interest Saved w/ Bonus: ${amount_saved}', xy=((periods * .3), (principal)), xytext=(0 - (periods * .015) , (ax.get_ylim()[1] * 1.095)), bbox=dict(facecolor='white', boxstyle='round'))
        plt.annotate(f'Periods Saved w/ Bonus: {periods_saved}', xy=((periods * .3), (principal)), xytext=(periods - (periods * .365) , (ax.get_ylim()[1] * 1.095)), bbox=dict(facecolor='white', boxstyle='round'))

    # tighen layout of plot for saving
    plt.tight_layout()

    # save plot to graphs folder if PLOT=True
    if PLOT is True:
        if not os.path.exists('loan_graphs'):
            os.makedirs('loan_graphs')
        # save plot with filename based on input parameters
        plot_filename = f"loan_graphs/{principal}_{interest_rate}_{term_years}_{start_date.date()}_{periodtype}_bonus{bonus}.png"
        if not os.path.isfile(plot_filename):  # ensure plot doesn't attmept to save twice
            plt.savefig(plot_filename)

    return df

# test ouptut (same as first example on .ipynb)
schedule = loan_amortization(200000, 3.5, 30, "2023-1-1", PLOT=True)

print(schedule)