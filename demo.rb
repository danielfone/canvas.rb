#!/usr/bin/ruby -w
#
# Test script for demonstrating canvas.rb library.
# Sprites derived from the popular figLet font "acrobatic"
#
# (c) 2008 Daniel Fone
#
require 'canvas';

$stdout.sync = true;
system "clear";
puts
puts
15.times do print ' ' end
puts "A demo in 20k (not including the Ruby interpreter)"
15.times do print ' ' end
puts "Feel free to hum a soundtrack of your choice"
puts
puts
puts
printf 'Compiling animation';
animation = Animator::Animation.new(78, 23);

animation.loadSprites("sprites");

##################
# Loading screen #
##################
animation.sprites["loading"].show(:end, 25, 6).finishSprite.hide;
printf '.';

################
# Introduction #
################
firstMan = animation.sprites["man_walking"].show(:end, 77, 6).moveHorizontal(-35).morph("man_waving").play(10).morph("man_beckoning").play(10);
printf '.';

#####
# H #
#####
animation.setMarker('H');
firstMan.morph("man_walking").moveHorizontal(-33).morph("m1");
animation.sprites["man_walking"].show('H', 77, 6).moveHorizontal(-65).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-3).morph("m8");
animation.sprites["man_walking"].show('H+10', 77, 6).moveHorizontal(-61).morph("m5");
animation.sprites["man_walking"].show('H+18', 77, 6).moveHorizontal(-58).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-5).morph("m3");
animation.sprites["man_walking"].show('H+28', 77, 6).moveHorizontal(-58).morph("man_climbing").moveVertical(-6).morph("man_walking").moveHorizontal(-10).morph("m2");
printf '.';

#####
# A #
#####
animation.setMarker('A');
animation.sprites["man_walking"].show('A+0', 77, 6).moveHorizontal(-55).morph("m6");
animation.sprites["man_walking"].show('A+10', 77, 6).moveHorizontal(-52).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-3).morph("m4");
animation.sprites["man_walking"].show('A+20', 77, 6).moveHorizontal(-48).morph("m1");
animation.sprites["man_walking"].show('A+30', 77, 6).moveHorizontal(-45).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-4).morph("m9");
printf '.';

#####
# P #
#####
animation.setMarker('P');
animation.sprites["man_walking"].show('P+0', 77, 6).moveHorizontal(-43).morph("m1");
animation.sprites["man_walking"].show('P+10', 77, 6).moveHorizontal(-40).morph("man_climbing").moveVertical(3).morph("man_walking").moveHorizontal(-3).morph("m1");
animation.sprites["man_walking"].show('P+20', 77, 6).moveHorizontal(-40).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-3).morph("m8");
animation.sprites["man_walking"].show('P+30', 77, 6).moveHorizontal(-39).morph("m7");
animation.sprites["man_walking"].show('P+40', 77, 6).moveHorizontal(-36).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-3).morph("m3");
printf '.';

#####
# P #
#####
animation.sprites["man_walking"].show('P+50', 77, 6).moveHorizontal(-32).morph("m1");
animation.sprites["man_walking"].show('P+60', 77, 6).moveHorizontal(-29).morph("man_climbing").moveVertical(3).morph("man_walking").moveHorizontal(-3).morph("m1");
animation.sprites["man_walking"].show('P+70', 77, 6).moveHorizontal(-29).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-3).morph("m8");
animation.sprites["man_walking"].show('P+80', 77, 6).moveHorizontal(-28).morph("m7");
animation.sprites["man_walking"].show('P+90', 77, 6).moveHorizontal(-25).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-3).morph("m3");
printf '.';

#####
# Y #
#####
animation.setMarker('Y');
animation.sprites["man_walking"].show('Y+0', 77, 6).moveHorizontal(-20).morph("m12");
animation.sprites["man_walking"].show('Y+10', 77, 6).moveHorizontal(-16).morph("man_climbing").moveVertical(3).morph("man_walking").moveHorizontal(-5).morph("m7");
animation.sprites["man_walking"].show('Y+20', 77, 6).moveHorizontal(-16).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-5).morph("m10");
animation.sprites["man_walking"].show('Y+30', 77, 6).moveHorizontal(-16).morph("m11");
animation.sprites["man_walking"].show('Y+40', 77, 6).moveHorizontal(-13).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-1).morph("m10");
printf '.';

#####
# 2 #
#####
animation.setMarker('2');
animation.sprites["man_walking"].show('2+0', 77, 18).moveHorizontal(-68).morph("m11");
animation.sprites["man_walking"].show('2+10', 77, 18).moveHorizontal(-64).morph("man_climbing").moveVertical(-3).morph("m11");
animation.sprites["man_walking"].show('2+20', 77, 18).moveHorizontal(-60).morph("man_climbing").moveVertical(-6).morph("man_walking").moveHorizontal(-5).morph("m3");
animation.sprites["man_walking"].show('2+30', 77, 18).moveHorizontal(-65).morph("m14");
animation.sprites["man_walking"].show('2+40', 77, 18).moveHorizontal(-60).morph("man_climbing").moveVertical(-8).morph("man_walking").moveHorizontal(-8).morph("man_climbing").moveVertical(3).morph("m13");
printf '.';

#####
# 1 #
#####
animation.setMarker('1');
animation.sprites["man_walking"].show('1+0', 77, 18).moveHorizontal(-56).morph("m17");
animation.sprites["man_walking"].show('1+10', 77, 18).moveHorizontal(-53).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-2).morph("m16");
animation.sprites["man_walking"].show('1+20', 77, 18).moveHorizontal(-53).morph("man_climbing").moveVertical(-6).morph("man_walking").moveHorizontal(-2).morph("m15");
printf '.';

#####
# s #
#####
animation.setMarker('s');
animation.sprites["man_walking"].show('s+0', 77, 18).moveHorizontal(-49).morph("m18");
animation.sprites["man_walking"].show('s+10', 77, 18).moveHorizontal(-44).morph("man_climbing").moveVertical(-1).morph("man_walking").moveHorizontal(-2).morph("m12");
animation.sprites["man_walking"].show('s+20', 77, 18).moveHorizontal(-43).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-3).morph("m19");
printf '.';

#####
# t #
#####
animation.setMarker('t');
animation.sprites["man_walking"].show('t+0', 77, 18).moveHorizontal(-36).morph("m21");
animation.sprites["man_walking"].show('t+10', 77, 18).moveHorizontal(-34).morph("man_climbing").moveVertical(-3).morph("man_walking").moveHorizontal(-2).morph("m20");
animation.sprites["man_walking"].show('t+20', 77, 18).moveHorizontal(-34).morph("man_climbing").moveVertical(-6).morph("man_walking").moveHorizontal(-3).morph("m10");
printf '.';
#puts " Done!"
#animation.dump;
animation.run('slow');
#animation.showLastFrame;
