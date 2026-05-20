# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.
import argparse


def process(inputPath, outputPath):
    with open(inputPath,'r') as input, open(outputPath,'w') as output:
        previous_line = None
        previous_chr = None
        previous_printed = False
        for line in input:
            chr = line.split()[0]
            if previous_line is None:
                previous_line = line
                previous_chr = chr
                previous_printed = False
            else:
                if previous_chr == chr:
                    if not previous_printed:
                        output.write(previous_line)
                        previous_printed = True
                    output.write(line)
                else:
                    previous_line = line
                    previous_chr = chr
                    previous_printed = False


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    ap = argparse.ArgumentParser(description="deletes entries from a Mpileup where there is only one line for a chromosome")

    ap.add_argument("-i", "--input", required=True)
    ap.add_argument("-o", "--output", required=True)

    args = vars(ap.parse_args())
    process(args['input'],args['output'])

# See PyCharm help at https://www.jetbrains.com/help/pycharm/

