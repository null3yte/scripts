import os
from collections import defaultdict
import argparse
import tldextract


def readSubs(filePath):
    with open(filePath, 'r') as file:
        subs = [line.strip() for line in file.readlines()]
        return subs


def groupSubsByDomain(subs):
    groupedSubs = defaultdict(list)
    for sub in subs:
        extracted = tldextract.extract(sub)
        domain = extracted.domain + "." + extracted.suffix
        groupedSubs[domain].append(sub)
    return groupedSubs


def writeSubsToFiles(groupedSubs, outputDir):
    os.makedirs(outputDir, exist_ok=True)
    for domain, subs in groupedSubs.items():
        file_path = os.path.join(outputDir, f"{domain}.subs")
        with open(file_path, 'w') as file:
            for sub in subs:
                file.write(sub + "\n")


def main(file, directory):
    subs = readSubs(filePath=file)
    grouped_subs = groupSubsByDomain(subs=subs)
    writeSubsToFiles(groupedSubs=grouped_subs, outputDir=directory)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '-f',
        '--file',
        type=str,
        required=True,
        metavar='PATH',
        help='full subs file path'
    )

    parser.add_argument(
        '-o',
        '--output',
        type=str,
        required=True,
        metavar='PATH',
        help='full output directory'
    )

    args = parser.parse_args()
    output = args.output
    file = args.file

    main(file=file, directory=output)
