class OSC {

  /*
    Stores relevant oscillation variables for nice
    looping animations. 
    
    val: "Midpoint" of oscillation. This is the value if there was no oscillation
    amp: Amplitude of oscillation. How far it goes from val up and down. Scaled by SCL.
    frq: Frequency. How many times it oscillates within FRAMES. Kept to an int for perfect loop.
    phs: Phase. Not always necessary, but helps adjust the look. Set to PI/2 for cosine if you fancy.
    
    I feel like if phase is changed for each oscillator the animation looks more fluid instead of just
    back and forth. 
  */
  
  float val, amp, vel, phs;

  OSC(float _val, float _amp, int _frq, float _phs) {
    val = _val*SCL;
    amp = _amp*SCL;
    vel = 2*PI*_frq/FRAMES;
    phs = _phs;
  }

  float getVal(float p_t) {
    return val + amp*sin(vel * p_t + phs);
  }
}
