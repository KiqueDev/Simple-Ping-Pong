/**
 * mypong0.pde
 *
 * This program contains a little game between a human and an agent.
 * The human player is a blue ball; the agent is a green ball.
 * The human player can move with the arrow keys.
 * Repeated key presses increases the human player's velocity in each direction.
 * Each player scores a point if they touch either the left or right walls of the arena.
 * The game ends when either player reaches a score of 10.
 *
 * MODIFY THE SKETCH SO THAT IT SAVES THE POSITIONS OF EACH PLAYER IN A DATA
 * FILE. THEN THE DATA FILE WILL CONTAIN THE TRAJECTORY OF EACH PLAYER.
 *
 * created: 13-nov-2011/sklar
 *
 */
//import javax.swing.JOptionPane;

int     d = 100;            // diameter of both objects
float   m1 = 10, m2 = 10;   // mass of both objects
PVector v1, v2;             // velocities of each object
PVector p1, p2;             // positions of each object
boolean running;            // flag indicating that the simulation is running
int     score1 = 0, score2 = 0; // score for each player
PrintWriter output;
boolean login;              // set login
String loginName="";
String buff="";
/**
 * setup()
 */
void setup() {
  size( 800,600 );
//String num = JOptionPane.showInputDialog("Hi");
//print(num);
  //frameRate(10);
  // Create a new file in the sketch dierctory
  output = createWriter("output.txt");
  // set the objects' dimensions in proportion to their respective masses
  v1 = new PVector( 0, 0, 0 );
  p1 = new PVector( 10, 250, 0 );
  v2 = new PVector( -2, -2, 0 );
  p2 = new PVector( 690, 250, 0 );
  ellipseMode( CORNER );
  running = false;
  login = true;
  // initialize font for reporting the score of the game
  PFont font;
  font = loadFont( "ComicSansMS-Bold-16.vlw" ); 
  textFont( font );
} // end of setup()

/**
 * draw()
 */
void draw() {
  if(login){
    background(255);
    textSize(20);
    fill(0);
    text( "LOGIN: ", 250, 300 );
    text(loginName);
  }else{
  // clear screen
  background( #ffffff );
  // draw score
  // draw two objects
  stroke( #333333 );
  fill( #000066 );
  ellipse( p1.x, p1.y, d, d );
  text( loginName + " score: " + str( score1 ), 10, 15 );
  fill( #006600 );
  ellipse( p2.x, p2.y, d, d );
  text( "agent score: " + str( score2 ), 10, 30 );
  noFill();
  if ( running ) {
    // Write framecount and p1 and p2
    output.println(frameCount + " " + p1.x + " " + p1.y + " " + p2.x + " " + p2.y);
    // update positions of each object
    p1.x += v1.x;
    p1.y += v1.y;
    p2.x += v2.x;
    p2.y += v2.y;
    // did we collide?
    if ( isCollision() ) {
      println( "collide!" );
      float dv1x = ( m1 - m2 )/( m1 + m2 ) * v1.x + ( 2 * m2 )/( m1 + m2 ) * v2.x;
      float dv1y = ( m1 - m2 )/( m1 + m2 ) * v1.y + ( 2 * m2 )/( m1 + m2 ) * v2.y;
      float dv2x = ( 2 * m1 )/( m1 + m2 ) * v1.x  + ( m2 - m1 )/( m1 + m2 ) * v2.x;
      float dv2y = ( 2 * m1 )/( m1 + m2 ) * v1.y  + ( m2 - m1 )/( m1 + m2 ) * v2.y;
      v1.x = dv1x;
      v1.y = dv1y;
      v2.x = dv2x;
      v2.y = dv2y;
    }
    // bounce off of the edge of the display window
    if (( p1.x < 0 ) || ( p1.x > width-d )) {
      v1.x = - v1.x;
      score1++;
    }
    if (( p1.y < 0 ) || ( p1.y > height-d )) v1.y = - v1.y;
    if (( p2.x < 0 ) || ( p2.x > width-d )) {
      v2.x = - v2.x;
      score2++;
    }
    if (( p2.y < 0 ) || ( p2.y > height-d )) v2.y = - v2.y;
    if (( score1 == 10 ) || ( score2 == 10 )) {
      running = false;
    }
  }
  else if (( score1 == 10 ) && ( score2 == 10 )) {
    fill( #660000 );
    text( "Tie Game!", 350, 300 );
  }
  else if ( score1 == 10 ) {
    fill( #000066 );
    text( loginName +" Wins!", 350, 300 );
  }
  else if ( score2 == 10 ) {
    fill( #006600 );
    text( "Agent Wins!", 350, 300 );
  }
  }
} // end of draw()

/**
 * keyReleased()
 * this function is called when the user releases a key.
 * the arrow keys move the blue object.
 * in addition, the following keys are active:
 *  s or S to stop (pause) the game
 *  r or R to reset the game
 *  q or Q to quit the game
 */
void keyPressed() {
  //For Delete key
  if(login){
    buff=loginName;
    if (keyCode == BACKSPACE) {
      if (loginName.length() > 0) {
        loginName  = loginName.substring(0, loginName.length()-1);
      }
    } 
    else if (keyCode == DELETE) {
      loginName = ""; 
    } 
    //Capital Letters
    else if (keyCode != SHIFT) {
        loginName = loginName + key;
    }
    if (keyCode == ENTER) {
      login=false;
      loginName=buff;
    }
  }else{
    if ( key == CODED ) {
      running = true;
      switch ( keyCode ) {
      case UP:
        v1.y -= 1;
        break;
      case DOWN:
        v1.y += 1;
        break;
      case LEFT:
        v1.x -= 1;
        break;
      case RIGHT:
        v1.x += 1;
        break;
      }
    }
    else if (( key == 's' ) || ( key == 'S' )) {
      loginName=buff;
      running = ! ( running );
    }
    else if (( key == 'r' ) || ( key == 'R' )) {
      loginName=buff;    
      restart();
    }
    else if ( keyCode == ESC) {
      //Flush data into file and close
      output.flush();
      output.close();
      exit();
    }
  }
} // end of keyReleased()

/**
 * restart()
 */
void restart() {
  v1.set( 0, 0, 0 );
  p1.set( 10, 250, 0 );
  v2.set( -2, 2, 0 );
  p2.set( 690, 250, 0 );
  score1 = 0;
  score2 = 0;
} // end of restart()

/**
 * isCollision()
 * this function returns true if the two objects have collided; false otherwise.
 */
boolean isCollision() {
  float r = d/2; // radius of first object
  PVector p1center = new PVector( p1.x + r, p1.y + r ); // center of first object
  PVector p2center = new PVector( p2.x + r, p2.y + r ); // center of second object
  float dcenter = sqrt( sq(p1center.x - p2center.x) + sq(p1center.y - p2center.y )); // distance between the centers of the two objects
  if ( dcenter < r + r ) {
    return( true );
  }
  else {
    return( false );
  }
} // end of isCollision()

