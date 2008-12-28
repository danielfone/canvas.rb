#!/usr/bin/ruby -w
#
# Canvas class library.
#
# Designed for ascii animations
#
# (c) 2008 Daniel Fone
#

module Animator
  
  class Canvas
    
    attr_reader :width, :height, :buffer;
    
    def initialize(width, height)
      @width    = width;
      @height   = height;
      @buffer = [];
      height.times do |i|
        @buffer[i] = '';
        width.times do |j|
          k = j % 10
          #@buffer[i] += k.to_s;
          @buffer[i] += ' ';
        end
      end
    end

    def add(image, x, y)
      image.each do |line|
        break if not @buffer[y]
        next if @buffer[y].length < x + line.length
        @buffer[y][x, line.length] = line;
        y += 1;
      end
    end

    def print
      @buffer.each do |line|
        printf line+"\n";
        $stdout.flush;
      end
    end
  end
  
  # -------------------
  # This class positions sprites onto the animation
  # It is attached to a single frame
  # -------------------   
  class Pixmap    
    attr_reader :sprite, :frame, :x, :y, :aniFrameNo, :pxid;
    attr_writer :frame, :x, :y, :aniFrameNo, :sprite, :pxid;
    
    def initialize(sprite, x, y)
      @sprite = sprite;
      @animation = @sprite.animation;
      @frame = 0;
      @aniFrameNo = 0;
      @x = x;
      @y = y;
      @pxid = self.object_id;
    end
    
    def clone
      pixmap = Pixmap.new(@sprite, @x, @y)
      pixmap.frame = @frame;
      pixmap.aniFrameNo = @aniFrameNo;
      pixmap.pxid = @pxid;
      return pixmap;
    end
    
    def show(frameNo)
      frameNo = calcFrameNo(frameNo);
      #puts "Showing #{@pxid} on frame #{frameNo}";
      thisFrame = @animation.catchupFrames(@animation.lastFrameNo, frameNo);
      thisFrame.addPixmap(self);
      #dumpCurrentFrame;
      @aniFrameNo = frameNo;
      return self;
    end
    
    def hide
      thisFrame = @animation.frames[@aniFrameNo];
      thisFrame.delPixmap(@pxid);
      return self;
    end
    
    def play(length)
      #puts "Playing #{@pxid} forward #{length} from frame #{@aniFrameNo}";
      length.times do
        frame = @animation.catchupFrames(@aniFrameNo, @aniFrameNo+1);
        frame.addPixmap(self);
        @aniFrameNo += 1;
      end
      #dumpCurrentFrame;
      return self;
    end
    
    def playTo(frameNo)
      frameNo = calcFrameNo(frameNo);
      self.play(frameNo-@aniFrameNo);
    end
    
    def finishSprite
      length = @sprite.images.length;
      self.play(length);
      return self;
    end
    
    def moveHorizontal(x)
      #puts "Moving #{@pxid} #{x} on frame #{@aniFrameNo}";
      pixmap = self;
      direction = x/x.abs;
      x.abs.times do |i|        
        frame = @animation.catchupFrames(pixmap.aniFrameNo, pixmap.aniFrameNo+1);
        pixmap = frame.movePixmap(pixmap, direction, 0);        
        pixmap.aniFrameNo += 1;
        #pixmap.dumpCurrentFrame;
      end
      return pixmap
    end
    
    def moveVertical(y)
      pixmap = self;
      direction = y/y.abs;
      y.abs.times do |i|
        frame = @animation.catchupFrames(pixmap.aniFrameNo, pixmap.aniFrameNo+1);
        pixmap = frame.movePixmap(pixmap, 0, direction);
        pixmap.aniFrameNo += 1;
      end
      return pixmap
    end
    
    def morph(newSprite)
      #puts "Morphing #{@pxid} on #{@aniFrameNo }"
      newPixmap = self.clone;
      @animation.frames[@aniFrameNo].delPixmap(@pxid);
      newPixmap.sprite = @animation.sprites[newSprite];
      newPixmap.frame = 0;     
      @animation.frames[@aniFrameNo].addPixmap(newPixmap);
      #newPixmap.dumpCurrentFrame;
      return newPixmap;
    end
    
    def setMarker(marker)
      @animation.frames[@aniFrameNo].marker = marker;
      return self;
    end
    
    def calcFrameNo(frameNo)
      frameNo = frameNo == :end ? @animation.lastFrameNo : frameNo;
      if frameNo =~ /(\w*)(\+|\-)?(\d+)?/ then
          frameNo = @animation.getMarkedFrameNo($1);
          frameNo += $3.to_i if $2 == '+';
          frameNo -= $3 if $2 == '-';
      end;
      return frameNo;
    end
    
    def dumpCurrentFrame
      @animation.frames[@aniFrameNo].dump;
    end
    
  end

  # -------------------
  # A class containing an animated ASCII image.
  # Similar to a GIF
  # -------------------  
  class Sprite
    attr_reader :name, :images, :animation;
    attr_writer :animation;
    
    def initialize(name)
      @images = [];
      @animation = nil;
      @name = name;      
    end
    
    def getImage(frame)
      @images[frame];
    end
    
    def addImage(image)
      @images.push(image);
    end
    
    def show(frameNo, x, y)
      pixmap = Pixmap.new(self, x, y);
      pixmap.show(frameNo);
      return pixmap;
    end
  end
  
  # -------------------
  # Our core class.
  # Almost all the exposed API is defined in this class
  # -------------------
  class Animation
    attr_reader :sprites, :frames;
   
    def initialize(width, height)
      @frames = [];
      @frames.push(Frame.new(self));
      @canvases = [];
      @sprites = {};
      @width = width;
      @height = height;
    end

    private;  
      #
      # The all-important method that takes our
      # animation and turns it into a series of
      # canvases
      #
      def rasterise      
        @frames.each do |frame|
          printf '.';
          canvas = Canvas.new(@width, @height);
          @canvases.push(canvas);
          if frame.pixmaps.length == 0 then next; end;
          frame.pixmaps.each do |pixmap|
            img = pixmap.sprite.getImage(pixmap.frame);
            pixmap.frame = (pixmap.frame + 1) % (pixmap.sprite.images.length);
            canvas.add(img, pixmap.x, pixmap.y);
          end
        end      
      end
      
      # 
      # Collect a sprite
      #
      def addSprite(sprite)
        @sprites[sprite.name] = sprite;
        sprite.animation = self;
      end
    
    public;
      #
      # Run the animation once all the pixmaps have been loaded
      #
      def run(speed)
        printf 'Rasterising';
        rasterise;
        puts " Done! [Hit any key]"
        gets
        @canvases.each_index do |i|
          canvas = @canvases[i];
          #canvas.add(' Frame '+i.to_s+' ', 0, 0);
          canvas.print;
          sleep 0.1;
        end
      end

      #
      # Create neccessary frames and copy standing pixmaps
      #
      def catchupFrames(fromFrameNo, toFrameNo)
        #puts "#{fromFrameNo} --> #{toFrameNo}"
        for i in fromFrameNo..toFrameNo do
          #puts "Catching up frame #{i}:";
          if @frames.length <= i then
            @frames[i] = Frame.new(self);
            @frames[i-1].pixmaps.each do |pixmap|
              @frames[i].addPixmap(pixmap)
            end
          end
        end
        return @frames[toFrameNo];
      end
      
      def lastFrameNo
        return @frames.length-1;
      end
      
      def setMarker(marker)
        @frames.last.marker = marker;
      end
      
      def getMarkedFrameNo(marker)
        @frames.each_index {|i| return i if @frames[i].marker == marker }
        return nil;
      end
      
      def showLastFrame
        oldFrames = @frames.clone;
        @frames.clear
        @frames.push(oldFrames.last);
        self.run(1);
        @frames = oldFrames.clone;
      end
      
      def dump
        @frames.each do |f|
          f.dump;          
        end
      end
    
      #
      # Load a series of sprites from a file
      #
      def loadSprites(filename)
        lines = [];
  
        sprite = nil;
        IO.foreach(filename) do |line|
          line.chomp!
          if line =~ /^(\w+):/ then
            # We've named a new sprite
            if lines.length > 0 then
              # We've finished a sprite
              sprite.addImage(lines);
              addSprite(sprite);
              lines = [];
            end
            sprite = Sprite.new($1)
          elsif line =~ /::/
            # We've found the next frame for the current sprite
            sprite.addImage(lines);
            lines = [];
          else
            # Another line for the current frame
            lines.push(line);
          end
        end
        
        if lines.length > 0 then
          # We've finished a sprite
          sprite.addImage(lines);
          addSprite(sprite);
        end

      end
    
  end
  
  class Frame
    attr_reader :pixmaps, :marker;
    attr_writer :marker;
    
    def initialize(animation)
      @animation = animation;
      @pixmaps = []
      @marker = '';
    end
    
    def frameNo
      @animation.frames.index(self);
    end
    
    def dump
      printf "%4s(%2s): ", frameNo, @marker;
      @pixmaps.sort {|a,b| a.pxid <=> b.pxid }.each do |p|
        print "#{p.pxid}(#{p.sprite.name},#{p.x},#{p.y}) ";
      end
      puts "";
    end
    
    def addPixmap(pixmap)
      return if not pixmap;
      @pixmaps.each do |p|
        return if p.pxid == pixmap.pxid;
      end
      @pixmaps.push(pixmap);
      #puts "Added pixmap #{pixmap} to frame #{frameNo}";
    end
    
    def delPixmap(pxid)
       @pixmaps.delete_if {|p| p.pxid == pxid};
    end
    
    def movePixmap(pixmap, moveX, moveY)
      newPixmap = pixmap.clone;        
      newPixmap.x += moveX;
      newPixmap.y += moveY;
      newPixmap.frame = (pixmap.frame + 1) % (newPixmap.sprite.images.length);
      delPixmap(pixmap.pxid);
      addPixmap(newPixmap);
      return newPixmap;
    end
    
  end

end
