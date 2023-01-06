# Wordy Passwords

This is a nonsense project trying to make passwords with words.

The whole thing is obsoleted with the following Linux command:

```sh
grep -oP '[a-z]{3,}' /usr/share/dict/words | shuf -n4 | paste -sd-
# forearm-heehawed-eggshell-skylines
```

- `grep -oP '[a-z]{3,}' /usr/share/dict/words` filter for words 3 lowercase letters or more.
- `shuf -n4` get 4 of them randomly.
- `paste -sd-` join the lines together with dashes.

## Sherlock Holmes

The system dictionary can contain some obscure words, so we try to get more common words from Sir Arthur Conan Doyle.

`Makefile` uses https://www.gutenberg.org to fetch the texts, parse the words, and create `dist/words`.
