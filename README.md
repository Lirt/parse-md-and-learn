# Parse Markdown and Learn

This project is a simple script I use to learn and rehearse from my notes written in **markdown**.

Nice for rehearsing language notes or notes from book you've read.

## Rules and types of tests

There are several rules, that are used to parse and pose questions:

1. Keywords: words in bold (`**`) and italics (`__`)
2. Lists: Sentence ending with colon character (`:`) is question and answer are all following list items (lines starting with `[*-0-9]`).
3. Couples: Couples separated with sequence ` - `, where first part is usually question and second answer.

## Usage

Simply run `./mdteach.sh <FILE>`, eg. `./mdteach.sh francais.md`.

After that, pick section that you want to rehearse and choose type of test.

Test with example markdown file `./mdteach.sh example.md`.
