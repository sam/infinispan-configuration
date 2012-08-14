package org.sam.infinispan;

public class Configuration {
	// THIS IS JUST A PLACEHOLDER to test my build!

  public static final String MY_STRING = "Hello, world.";
  public static enum DAYS {MONDAY, TUESDAY, WEDNESDAY};

  public static void main(String[] args) {
	System.out.println(MY_STRING);
  }

  public void getDay(DAYS day) {
	System.out.println("We got " + day);
  }
}