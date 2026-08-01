// hostname suffix generator

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define BASE32_LEN 7
#define BASE32_ALPHABET "0123456789abcdefghjkmnpqrstvwxyz"

#define GROUP_BITS 10
#define TIME_BITS 15
#define SALT_BITS 10

#define EPOCH 1205366400

const char base32_chars[] = BASE32_ALPHABET;

void
encode_base32(uint64_t val, char *out)
{
    for (int i = BASE32_LEN - 1; i >= 0; i--) {
        out[i] = base32_chars[val % 32];
        val /= 32;
    }
    out[BASE32_LEN] = '\0';
}

uint16_t
hash_group(const char *str)
{
    uint32_t hash = 4242;
    while (*str) {
        hash = ((hash << 4) + hash) + (unsigned char)(*str++);
    }
    return (uint16_t)(hash % 1024);
}

void
generate_code(const char *group, uint16_t time_offset, uint16_t salt, char *out)
{
    uint16_t group_id = hash_group(group);

    uint64_t packed = ((uint64_t)group_id << (TIME_BITS + SALT_BITS)) |
                      ((uint64_t)time_offset << SALT_BITS) | (uint64_t)salt;

    encode_base32(packed, out);
}

int
main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <desc>\n", argv[0]);
        return 1;
    }

    time_t now = time(NULL);
    uint16_t time_offset = (uint16_t)(now - EPOCH);

    srand(now);

    uint16_t salt = (uint16_t)(rand() % (1 << SALT_BITS));

    char code[BASE32_LEN + 1];
    generate_code(argv[1], time_offset, salt, code);

    printf("%s\n", code);
    return 0;
}
