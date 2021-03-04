# audio-bandpass-filter

Blackman Window bandpass filter design project.

A tuning fork with a known frequency of 329.6 Hz was recorded and the signal was mathematically altered with random noise. A Blackman Window bandpass filter is then applied to the signal to attenuate all frequencies outside of the range of 320-340 Hz. The signals are graphed to showcase the efficacy of the bandpass filter.

Original tuning fork recording:
![image](https://user-images.githubusercontent.com/22338183/109895624-6344b680-7c44-11eb-9a00-7f4e073bac17.png)

By applying a Discrete Fourier Transform to the audio signal and analyzing the result, we can see that the fundamental frequency lies somewhere around 330 Hz.


Noisy tuning fork signal:
![image](https://user-images.githubusercontent.com/22338183/109896141-507eb180-7c45-11eb-9a2f-57df83ac24f6.png)

The original tuning fork signal is modified by adding random noise using the _randn_ Matlab function. The Power Spectrum Densities of the pre-noise and post-noise signals are compared above. It appears obvious that the original signal is lost in the post-noise signal.


The bandpass filter is produced by subtracting one lowpass filter from another:
![image](https://user-images.githubusercontent.com/22338183/109896846-87a19280-7c46-11eb-9237-e67beeea7ae7.png)
![image](https://user-images.githubusercontent.com/22338183/109896854-8b351980-7c46-11eb-9cfb-b0adf0d68503.png)

Subtracting the lower lowpass filter from the upper lowpass filter results in a bandpass filter centered on 330 Hz:
![image](https://user-images.githubusercontent.com/22338183/109896899-a2740700-7c46-11eb-8a32-95ee40095db9.png)

By convolving the bandpass filter with the noisy tuning fork signal, the filter attenuates all frequencies outside of the 320-340 Hz range. The following figure shows the PSDs of the original signal, the post-noise signal, and the post-filter signal:
![image](https://user-images.githubusercontent.com/22338183/109897334-67be9e80-7c47-11eb-9e31-7a3dd02e0409.png)

The resulting signal is a remarkably clean sample of the original tuning fork audio.

All code for this project is written in Matlab.
