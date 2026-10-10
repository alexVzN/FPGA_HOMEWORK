#include "moving_max.h"

void moving_max(int in[N_SAMPLES], int out[N_SAMPLES]) {
    int win[WIN];
    for (int k = 0; k < WIN; k++) {
        win[k] = 0;
    }

    for (int n = 0; n < N_SAMPLES; n++) {
#ifdef PIPE_II1
#pragma HLS PIPELINE II=1
#endif
        int x = in[n];

        for (int k = WIN - 1; k > 0; k--) {
            win[k] = win[k - 1];
        }
        win[0] = x;

        int m = x;
        for (int k = 1; k < WIN; k++) {
            if (k <= n && win[k] > m) {
                m = win[k];
            }
        }
        out[n] = m;
    }
}
