with Ada.Text_Io; use Ada.Text_Io;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Numerics.Generic_Elementary_Functions;
with GNATCOLL.GMP; use GNATCOLL.GMP;
with GNATCOLL.GMP.Integers; use GNATCOLL.GMP.Integers;
with GNATCOLL.GMP.Integers.Number_Theoretic; use GNATCOLL.GMP.Integers.Number_Theoretic;
procedure Gcd_Test is
   package Elementary_Float_functions is new Ada.Numerics.Generic_Elementary_Functions(Float);
   use Elementary_Float_functions;
   Start_time, End_time : Time;
   Exec_time : Time_Span;

   function Gcd (A, B : Integer) return Integer is
      M : Integer := A;
      N : Integer := B;
      T : Integer;
   begin
      while N /= 0 loop
         T := M;
         M := N;
         N := T mod N;
      end loop;
      return M;
   end Gcd;

   function JWA_Gcd (A, B : Integer) return Integer is
      k : constant := 2**6; -- k-ary parameter for the reduction
      r : Integer := (if A > B then A/B mod k else B/A mod k);
      n1 : Integer := k;
      n2 : Integer := r;
      d1 : Integer := 0;
      d2 : Integer := 1;

      procedure swap(n1,n2,d1,d2 : in out Integer) is
         tmp : Integer;
      begin
         tmp := n1;
         n1 := n2;
         n2 := tmp;
         tmp := d1;
         d1 := d2;
         d2 := tmp;
      end swap;

   begin
      while n2 >= Integer(Float'Floor(sqrt(Float(k)))) loop
         n1 := n1 - Integer(Float'Floor(Float(n1)/Float(n2)))*n2;
         d1 := d1 - Integer(Float'Floor(Float(n1)/Float(n2)))*d2;
         n2 := n2 - Integer(Float'Floor(Float(n1)/Float(n2)))*n2;
         d2 := d2 - Integer(Float'Floor(Float(n1)/Float(n2)))*d2;
         swap(n1,n2,d1,d2);
      end loop;
      return n2;
   end JWA_Gcd;

   function GMP_Gcd(A, B : Integer) return Integer is
      M : Big_Integer := Make(A'Image);
      N : Big_Integer := Make(B'Image);
      R : Big_Integer;
   begin
      Get_GCD(M,N,R);
      return Integer'Value(Image(R));
   end GMP_Gcd;

begin

   Start_time := clock;
   Put("GCD(28865, 19203) = " & Integer'Image(Gcd(28865, 19203)));
   End_time := clock;
   Exec_Time := End_Time - Start_Time;
   Put_line (" Execution time : " & Duration'Image (To_Duration(Exec_Time)) & " sec ");

   Start_time := clock;
   Put("GMP_GCD(28865, 19203) = " & Integer'Image(GMP_Gcd(28865, 19203)));
   End_time := clock;
   Exec_Time := End_Time - Start_Time;
   Put_line (" Execution time : " & Duration'Image (To_Duration(Exec_Time)) & " sec ");

   Start_time := clock;
   Put("JWA_GCD(28865, 19203) = " & Integer'Image(JWA_Gcd(28865, 19203)));
   End_time := clock;
   Exec_Time := End_Time - Start_Time;
   Put_line (" Execution time : " & Duration'Image (To_Duration(Exec_Time)) & " sec ");

   Start_time := clock;
   Put("JWA_GCD(19203, 1053) = " & Integer'Image(JWA_Gcd(19203, 1053)));
   End_time := clock;
   Exec_Time := End_Time - Start_Time;
   Put_line (" Execution time : " & Duration'Image (To_Duration(Exec_Time)) & " sec ");

   Start_time := clock;
   Put("GCD(19203, 1053) = " & Integer'Image(Gcd(19203, 1053)));
   End_time := clock;
   Exec_Time := End_Time - Start_Time;
   Put_line (" Execution time : " & Duration'Image (To_Duration(Exec_Time)) & " sec ");

   Start_time := clock;
   Put("GMP_GCD(19203, 1053) = " & Integer'Image(GMP_Gcd(19203, 1053)));
   End_time := clock;
   Exec_Time := End_Time - Start_Time;
   Put_line (" Execution time : " & Duration'Image (To_Duration(Exec_Time)) & " sec ");

end Gcd_Test;
