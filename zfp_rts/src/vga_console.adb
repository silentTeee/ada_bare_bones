package body VGA_Console is
   procedure Put
     (Char       : Character;
      X          : Screen_Width_Range;
      Y          : Screen_Height_Range;
      Foreground : Foreground_Color := White;
      Background : Background_Color := Black) is
   begin
      Video_Memory (Y)(X).Char             := Char;
      Video_Memory (Y)(X).Color.Foreground := Foreground;
      Video_Memory (Y)(X).Color.Background := Background;
   end Put;

   procedure Put
     (Str        : String;
      X          : Screen_Width_Range;
      Y          : Screen_Height_Range;
      Foreground : Foreground_Color := White;
      Background : Background_Color := Black) is
   begin
      for Index in Str'First .. Str'Last loop
         Put (Str (Index),
              X + Screen_Width_Range (Index) - 1,
              Y,
              Foreground,
              Background);
      end loop;
   end Put;

   procedure Clear (Background : Background_Color := Black) is
   begin
      for X in Screen_Width_Range'First .. Screen_Width_Range'Last loop
         for Y in Screen_Height_Range'First .. Screen_Height_Range'Last loop
            Put (' ', X, Y, Background => Background);
         end loop;
      end loop;
   end Clear;
end VGA_Console;