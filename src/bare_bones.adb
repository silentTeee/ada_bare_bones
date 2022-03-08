with VGA_Console;

procedure Bare_Bones is
begin
   VGA_Console.Clear;

   VGA_Console.Put ("Hello, bare bones in Ada.",
        VGA_Console.Screen_Width_Range'First,
        VGA_Console.Screen_Height_Range'First);
end Bare_Bones;