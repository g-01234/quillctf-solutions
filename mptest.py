import multiprocessing

# Define a global variable
global_var = 0

# Define a function to increment the global variable by a certain amount
def increment_global_var(amount):
    print(amount)
    global global_var
    global_var += amount


if __name__ == '__main__':
    # Define a list of arguments to pass to the function
    args_list = [(1,), (2,), (3,), (4,), (5,), (6,), (7,), (8,), (9,), (10,)]

    # Create a multiprocessing pool with 4 processes
    pool = multiprocessing.Pool(processes=4)

    # Use pool.starmap to apply the function to each set of arguments in parallel
    pool.starmap(increment_global_var, args_list)


    # Print the final value of the global variable
    print("Final value of global_var:", global_var)