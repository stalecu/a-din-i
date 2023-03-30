#!/usr/bin/env python
# Copyright 2023 Alecu Ștefan-Iulian
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import sys
import fileinput
import re

# https://wiki.ceata.org/index.php/Scrierea_cuvintelor_cu_%C3%AE_%C8%99i_%C3%A2_%C3%AEn_rom%C3%A2n%C4%83
lista_prefixe = ["alt", "auto", "bine", "de", "ex", "foto", "ne",
                 "nemai", "ori", "prea", "pre", "răs", "re", "semi",
                 "sub", "super", "supra", "tele"]


def converteste_a_in_i(cuvinte: list[str]) -> list[str]:
    for i, _ in enumerate(cuvinte):
        cuvinte[i] = cuvinte[i].replace("â", "î").replace("romîn", "român")
    return cuvinte


def converteste_i_in_a(cuvinte: list[str]) -> list[str]:
    # print(cuvinte)
    for i, _ in enumerate(cuvinte):
        cuvinte[i] = cuvinte[i].replace("î", "â")

        if any(cuvinte[i].startswith(item) for item in lista_prefixe):
            prefix = lista_prefixe[list(
                map(lambda w: cuvinte[i].startswith(w), lista_prefixe)).index(True)]
            # cuvinte[i] = cuvinte[i].replace("â", "î", len(prefix))
            cuvinte[i] = cuvinte[i][:len(
                prefix)] + "î" + cuvinte[i][len(prefix)+1:].replace("î", "â")

        if cuvinte[i].startswith("â"):
            cuvinte[i] = cuvinte[i].replace("â", "î", 1)
        if cuvinte[i].endswith("â"):
            cuvinte[i] = cuvinte[i][::-1].replace("â", "î", 1)[::-1]

    return cuvinte


def main() -> None:
    parser = argparse.ArgumentParser(description="Convertor â <-> î",
                                     formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("-a", "--a-din-i", action="store_true",
                        help="Convertește din â în î")
    parser.add_argument("-i", "--i-din-a", action="store_true",
                        help="Convertește din î în â")
    parser.add_argument("fisier", help="Fișierul care va fi convertit")
    args = parser.parse_args()

    try:
        with fileinput.input(args.fisier, inplace=True) as fh:
            for linie in fh:
                cuvinte = re.split(r'(\S+)', linie)
                if args.a_din_i:
                    linie_noua: str = "".join(converteste_a_in_i(cuvinte))
                elif args.i_din_a:
                    linie_noua: str = "".join(converteste_i_in_a(cuvinte))
                print(linie_noua, end='')

    except FileNotFoundError:
        print(f"Fisierul {args.fisier} nu exista!", file=sys.stderr)
        exit(1)


if __name__ == "__main__":
    main()
