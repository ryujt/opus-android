#include "opus.h"

void test()
{
    int errorCode;
    OpusEncoder* opus_ = opus_encoder_create(48000, 2, OPUS_APPLICATION_AUDIO, &errorCode);
}