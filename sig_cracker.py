from Cryptodome.Hash import keccak
import sys
import pdb
import time
import string
import itertools
import multiprocessing as mp

alphanum = string.ascii_lowercase + string.ascii_uppercase + string.digits

# find a matching 4 byte function selector for the given function name
def find_sig(func_sig, func_sel, max_len):
    t = time.perf_counter()
    func_name = func_sig[:func_sig.find(b'(')]
    func_args = func_sig[func_sig.find(b'('):]
    counter = 0
    for search_name in generate_alphanumeric_strings(max_len):
        counter += 1
        search_sel = keccak.new(digest_bits=256,
                                data=search_name + func_args).hexdigest()[:8]

        if search_sel == func_sel and search_name != func_name:
            print("Found matching selector: ",
                  (search_name + func_args).decode('utf-8'), search_sel)
            stop.set()
            return

        if (counter % 50000 == 0 and stop.is_set()):
            return

    print(
        f"No match found for length: {max_len}; time elapsed: {(time.perf_counter() - t):.2f}s")

# Thanks chatgpt


def generate_alphanumeric_strings(n):
    """
    Generate all possible alphanumeric strings of length n.
    """
    for chars in itertools.product(alphanum, repeat=n):
        yield ''.join(chars).encode('utf-8')


def init(e):
    global stop
    stop = e


if __name__ == '__main__':
    stop = mp.Event()

    print(
        f"Finding a matching function selector for the following function name: {sys.argv[1]}")

    # First argument will be function sig - e.g. transfer(address,uint256)
    func_sig = sys.argv[1].encode('utf-8')
    processes = []

    func_sel = keccak.new(digest_bits=256, data=func_sig).hexdigest()[:8]
    print(f"Function selector for {func_sig.decode('utf-8')}: 0x{func_sel}")
    try:
        with mp.Pool(mp.cpu_count() - 1, initializer=init, initargs=(stop,)) as p:
            p.starmap(find_sig, [(func_sig, func_sel, i)
                      for i in range(1, 10)])

    except SystemExit:

        pdb.set_trace()
