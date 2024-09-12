with System;

package VGA_Console is
   pragma Preelaborate (VGA_Console);

   type Background_Color is
     (Black,
      Blue,
      Green,
      Cyan,
      Red,
      Magenta,
      Brown,
      Light_Grey);

   for Background_Color use
     (Black      => 16#0#,
      Blue       => 16#1#,
      Green      => 16#2#,
      Cyan       => 16#3#,
      Red        => 16#4#,
      Magenta    => 16#5#,
      Brown      => 16#6#,
      Light_Grey => 16#7#);

   for Background_Color'Size use 4;

   type Foreground_Color is
     (Black,
      Blue,
      Green,
      Cyan,
      Red,
      Magenta,
      Brown,
      Light_Grey,
      Dark_Grey,
      Light_Blue,
      Light_Green,
      Light_Cyan,
      Light_Red,
      Light_Magenta,
      Yellow,
      White);

   for Foreground_Color use
     (Black         => 16#0#,
      Blue          => 16#1#,
      Green         => 16#2#,
      Cyan          => 16#3#,
      Red           => 16#4#,
      Magenta       => 16#5#,
      Brown         => 16#6#,
      Light_Grey    => 16#7#,
      Dark_Grey     => 16#8#,
      Light_Blue    => 16#9#,
      Light_Green   => 16#A#,
      Light_Cyan    => 16#B#,
      Light_Red     => 16#C#,
      Light_Magenta => 16#D#,
      Yellow        => 16#E#,
      White         => 16#F#);

   for Foreground_Color'Size use 4;

   type Cell_Color is
      record
         Foreground : Foreground_Color;
         Background : Background_Color;
      end record;

   for Cell_Color use
      record
         Foreground at 0 range 0 .. 3;
         Background at 0 range 4 .. 7;
      end record;

   for Cell_Color'Size use 8;

   type Cell is
      record
         Char   : Character;
         Color  : Cell_Color;
      end record;

   for Cell'Size use 16;

   Screen_Width  : constant Natural := 80;
   Screen_Height : constant Natural := 25;

   subtype Screen_Width_Range  is Natural range 1 .. Screen_Width;
   subtype Screen_Height_Range is Natural range 1 .. Screen_Height;

   type Row    is array (Screen_Width_Range) of Cell;
   type Screen is array (Screen_Height_Range) of Row;

   Video_Memory : Screen;

   for Video_Memory'Address use System'To_Address (16#000B_8000#);

   pragma Import (Ada, Video_Memory);

   procedure Put
     (Char       : Character;
      X          : Screen_Width_Range;
      Y          : Screen_Height_Range;
      Foreground : Foreground_Color := White;
      Background : Background_Color := Black);

   procedure Put
        (Str        : String;
         X          : Screen_Width_Range;
         Y          : Screen_Height_Range;
         Foreground : Foreground_Color := White;
         Background : Background_Color := Black);

   procedure Clear (Background : Background_Color := Black);
end VGA_Console;