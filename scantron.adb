with
    Ada.Text_IO,
    Ada.Float_Text_IO,
    Ada.Integer_Text_IO;

use Ada.Text_IO;

PROCEDURE Scantron IS
    File            : File_Type;
    Max_Score       : Integer := 100;
    Quiz_Size       : Integer := 0;
    type FA is array (0..100) of Integer;
    Frequency_Array : FA := (others => 0);

    procedure Open_File(File: out File_Type) is
        Name        : String(1..100);
        Size        : Natural;
    begin
        loop
            begin
                Put("Enter filename: ");
                Get_Line (Name, Size);
                Open(File, Mode => In_File, Name => Name(1..Size));
                exit;
            exception
                when Name_Error | Use_Error =>
                    Put_Line("Invalid filename -- please try again.");
            end;
        end loop;
    end Open_File;

BEGIN
    Open_File(File);
    Ada.Integer_Text_IO.Get(File, Item => Quiz_Size);

    declare
        subtype Quiz_Index is Positive range 1 .. Quiz_Size;
        type Respond is array(Quiz_Index) of Integer;
        type Student is
            record
                id      : String(1..5);
                res     : Respond;
                score   : Integer;
            end record;

        type Student_Array is array(1 .. 1000) of Student;


        Answer          : Respond;
        Students        : Student_Array;
        Student_Index   : Integer := 0;
        Score           : Integer;

        function Get_Respond(File : File_Type) return Respond is
            Result : Respond;
        begin
            for i in Respond'Range loop
                Ada.Integer_Text_IO.Get(File, Item => Result(i));
            end loop;
            return Result;
        end Get_Respond;

        function Get_Score(Answer : Respond; S: Student) return Integer is
            Result  : Integer := 0;
            Unit    : Integer;
        begin
            Unit := Max_Score / Quiz_Size;
            for i in Answer'Range loop
                if Answer(i) = S.res(i) then
                    Result := Result + Unit;
                end if;
            end loop;
            return Result;
        end Get_Score;

        procedure Print_Student_Array(s : Student_Array; size: Integer) is
        begin
            Put(Item => "Student ID    Score");
            New_Line;
            Put(Item => "===================");
            New_Line;
            for i in 1 .. size loop
                Put(Item => s(i).id & "         ");
                Ada.Integer_Text_IO.Put(Item => s(i).score, width => 3);
                New_Line;
            end loop;
            Put(Item => "===================");
            New_Line;
            Put(Item => "Tests graded = ");
            Ada.Integer_Text_IO.Put(Item => size, width => 2);
            New_Line;
            Put(Item => "===================");
            New_Line;
        end Print_Student_Array;

        procedure Print_Frequency_Array(Frequency_Array : FA) is
            Total   : Integer := 0;
            Num     : Integer := 0;
            Average : Float := 0.0;
        begin
            Put(Item => "Score     Frequency");
            New_Line;
            Put(Item => "===================");
            New_Line;
            for i in reverse Frequency_Array'Range loop
                if Frequency_Array(i) /= 0 then
                    Total   := Total + i * Frequency_Array(i);
                    Num     := Num + Frequency_Array(i);
                    Ada.Integer_Text_IO.Put(Item => i, width => 3);
                    Ada.Integer_Text_IO.Put(Item => Frequency_Array(i));
                    New_Line;
                end if;
            end loop;
            Put(Item => "===================");
            New_Line;
            Average := Float(Total) / Float(Num);
            Put(Item => "Class Average = ");
            Ada.Float_Text_IO.Put(Item => Average, Fore => 0, AFT => 0, EXP => 0);
            New_Line;
        end Print_Frequency_Array;

    begin
        Answer := Get_Respond(File);
        while not End_Of_File (File) loop
            Student_Index := Student_Index + 1;
            Get(File, Item => Students(Student_Index).id);
            Students(Student_Index).res := Get_Respond(File);

            Score := Get_Score(Answer, Students(Student_Index));

            Students(Student_Index).score := Score;
            Frequency_Array(Score) := Frequency_Array(Score) + 1;

        end loop;


        Print_Student_Array(Students, Student_Index);
        Print_Frequency_Array(Frequency_Array);
    end;
    Close (file);
END Scantron;