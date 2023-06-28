profile = {
    'name' : 'N/A',
    'email' : 'N/A',
    'phone' : 'N/A'
}

user_input = {
    'name' : 'Bob',
    'phone' : '123-456-7890',
}

profile = {**profile, **user_input}

print(profile)