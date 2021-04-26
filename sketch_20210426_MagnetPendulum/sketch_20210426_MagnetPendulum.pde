// Based on: https://www.youtube.com/watch?v=C5Jkgvw-Z6E
// THIS WILL TAKE A FEW MINUTES TO RUN

float theta, v_theta, a_theta;  // theta is the angle of the pendulum from vertical
float phi, v_phi, a_phi;        // phi is the angle of rotation of the pendulum
float x, y, z, t;

float g = 9.8;  // acc. from gravity
float m = 1;    // mass
float r = 10;   // length of pendulum
float damping = 0.85;
float dt = 0.1;
float t_max = 50;  // stabilizes within t=50 for these conditions, but may need longer for other parameters (damping, and magnet params)

class Magnet {

  float r, theta, phi, strength;
  PVector pos;
  color c = color(random(255), random(255), random(255));

  Magnet(float r, float theta, float phi, float strength) {
    this.r = r;
    this.theta = theta;
    this.phi = phi;
    this.strength = strength;
    pos = new PVector(r*sin(theta)*cos(phi), r*sin(theta)*sin(phi), -r*cos(theta));
  }
}

// Not exactly the same as the video because there the magnets where on a plane while here they are on a sphere
float mag_r = 1.1*r;
float mag_s = 110;
Magnet mag1 = new Magnet(mag_r, radians(20), radians(90), mag_s);
Magnet mag2 = new Magnet(mag_r, radians(30), radians(0), mag_s);
Magnet mag3 = new Magnet(mag_r, radians(30), radians(-120), 150);
Magnet[] magnets = {mag1, mag2, mag3};

float e = 0.0000011;  // for div/0 
float scl;            // scale system to fit canvas

// the lazy way to create initial points. n_theta*n_phi points
// will be clumping around theta = 0 and gaps between theta = PI/2
int n_theta = 200;    
int n_phi = 450;

void setup() {
  size(500, 500);
  scl = width/(2*r);

  background(0);
  for (Magnet mag : magnets) {
    fill(mag.c);
    ellipse(width/2 + mag.pos.x*scl, width/2 + mag.pos.y*scl, 15, 15);
  }
  noStroke();
  noLoop();
}

void draw() {
  translate(width/2, height/2);

  for (int i=0; i<n_theta; i++) {
    for (int j=0; j<n_phi; j++) {

      // INITIALIZE POSITION
      theta = (PI/2) * float(i)/n_theta;  // from a top down veiw, theta > PI/2 will overlap itself
      phi = (2*PI) * float(j)/n_phi;

      x = r*sin(theta)*cos(phi);
      y = r*sin(theta)*sin(phi);
      z = -r*cos(theta);
      v_theta = 0;  // angular velocity in theta direction
      a_theta = 0;  // angular acceleration in theta direction
      v_phi = 0;
      a_phi = 0;

      t = 0;
      PVector init_pos = new PVector(x, y, z);

      while (t < t_max) {
        PVector pendulum_pos = new PVector(x, y, z);

        PVector pendulum_r_dir = pendulum_pos.copy().normalize();
        PVector pendulum_phi_dir = new PVector(x, y).rotate(PI/2).normalize();
        PVector pendulum_theta_dir = pendulum_r_dir.cross(pendulum_phi_dir).normalize();

        /*
        Taking dot products to find the component of each force in theta and phi directions
         here alpha is angle between the force vector and theta direction
         beta is angle between the force vector and phi direciton
         
        ((theta+e)/abs(theta+e)) is trying to correct for when the pendulum is on the opposite of 0 from the magnet
        idk. it wasnt working without it. I think something to do with dot product
         */

        PVector force_grav_dir = new PVector(0, 0, -1);
        float force_grav_alpha = acos(force_grav_dir.dot(pendulum_theta_dir));
        float force_grav_theta = m*g*cos(force_grav_alpha)*((theta+e)/abs(theta+e));

        float force_mag_theta = 0;
        float force_mag_phi = 0;

        for (Magnet mag : magnets) {
          float d = PVector.dist(mag.pos, pendulum_pos);
          PVector force_mag_dir = PVector.sub(mag.pos, pendulum_pos).normalize();

          float force_mag_alpha = acos(force_mag_dir.dot(pendulum_theta_dir));
          force_mag_theta += mag.strength/sq(d) * cos(force_mag_alpha) * ((theta+e)/abs(theta+e));

          float force_mag_beta = acos(force_mag_dir.dot(pendulum_phi_dir));
          force_mag_phi += mag.strength/sq(d) * cos(force_mag_beta);
        }

        // divide by m for a in F=m*a
        // divide by r to convert from linear to angular acceleration
        a_theta = (force_grav_theta + force_mag_theta) / (m*r);
        v_theta = (v_theta + a_theta*dt);

        a_phi = (force_mag_phi)/(m*r);
        v_phi = (v_phi + a_phi*dt);

        // apply damping to the total velocity (maybe not right? idk, seems to work)
        // using pow() because damping is per t=1 not per dt
        float v_angle = atan2(v_theta, v_phi);
        float v_tot = sqrt(sq(v_theta) + sq(v_phi))*pow(damping, dt);
        v_theta = v_tot*sin(v_angle);
        v_phi = v_tot*cos(v_angle);

        theta = theta + v_theta*dt;
        phi = phi + v_phi*dt;

        x = r*sin(theta)*cos(phi);
        y = r*sin(theta)*sin(phi);
        z = -r*cos(theta);
        t += dt;
      }

      PVector final_pos = new PVector(x, y, z);

      float min_dist = 1000000;
      Magnet closest = null;
      for (Magnet mag : magnets) {
        float d = PVector.dist(mag.pos, final_pos);
        if (d < min_dist) {
          closest = mag;
          min_dist = d;
        }
      }
      if (closest != null) {
        fill(closest.c);
        ellipse(init_pos.x*scl, init_pos.y*scl, 1, 1);
      }
    }
  }
}
