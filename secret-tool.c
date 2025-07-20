#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    if (argc >= 2 && strcmp(argv[1], "lookup") == 0) {
        FILE *fp = fopen("/root/.local/share/keyrings/gnome-keyring.login.secret", "r");
        if (!fp) {
            perror("fopen");
            return 1;
        }
        char ch;
        while ((ch = fgetc(fp)) != EOF) putchar(ch);
        fclose(fp);
    } else {
        fprintf(stderr, "Usage: secret-tool lookup <attr> <value>\n");
        return 1;
    }
    return 0;
}