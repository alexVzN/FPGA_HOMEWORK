#include <cstdio>
#include <cstdlib>
#include "moving_max.h"

static void reference(const int in[N_SAMPLES], int out[N_SAMPLES]) {
    for (int n = 0; n < N_SAMPLES; n++) {
        int m = in[n];
        for (int k = 1; k < WIN; k++) {
            if (n - k >= 0 && in[n - k] > m) {
                m = in[n - k];
            }
        }
        out[n] = m;
    }
}

static int run_case(const char *name, int in[N_SAMPLES]) {
    int out[N_SAMPLES];
    int ref[N_SAMPLES];
    int errors = 0;

    moving_max(in, out);
    reference(in, ref);

    for (int n = 0; n < N_SAMPLES; n++) {
        if (out[n] != ref[n]) {
            printf("%s: out[%d] = %d, expected %d\n", name, n, out[n], ref[n]);
            errors++;
        }
    }
    printf("%-12s %s\n", name, errors ? "FAIL" : "PASS");
    return errors;
}

int main() {
    int v[N_SAMPLES];
    int errors = 0;

    for (int i = 0; i < N_SAMPLES; i++) v[i] = 5;
    errors += run_case("constant", v);

    for (int i = 0; i < N_SAMPLES; i++) v[i] = i;
    errors += run_case("ramp_up", v);

    for (int i = 0; i < N_SAMPLES; i++) v[i] = N_SAMPLES - i;
    errors += run_case("ramp_down", v);

    for (int i = 0; i < N_SAMPLES; i++) v[i] = (i % 2) ? -i : i;
    errors += run_case("alternating", v);

    srand(1);
    for (int i = 0; i < N_SAMPLES; i++) v[i] = rand() % 2001 - 1000;
    errors += run_case("random", v);

    for (int i = 0; i < N_SAMPLES; i++) v[i] = (i == 10 || i == 40) ? 1000 : -1000 + i;
    errors += run_case("spikes", v);

    printf("total errors: %d\n", errors);
    return errors ? 1 : 0;
}
