unit DataBase;

interface

Procedure createFaculty();

type
    TSubject = Record
      id: integer;
      name: string[100];
      teacher: string[100];
    End;

    TSemester = Record
      value: integer;
      group: array[1..40] of string[100]; //ФИО
    End;

    TSpisiality = Record
      id: integer;
      name: string[60];
      semester: TSemester; //1-8
      subjects: array[1..15] of TSubject;
    End;

    TFaculty = Record
      id: integer;
      name: string[60];
      decanName: string[60];
      //spisiality: array[0..10] of TSpisiality;
    End;

    //это для типизированного файла, а в проге ещё в каждом должен быть адрес
    //элемента выше, чтобы зная студента можно было определять его семестр и предметы

implementation

Procedure createFaculty();
const
   nameFac: array[0..9] of string = (
   'факультет довузовской подготовки и профессиональной ориентации',
   'факультет компьютерной проектировки',
   'факультет информационных технологий и управления',
   'военный факультет',
   'факультет радиотехники и электроники',
   'факультет компьютерных систем и сетей',
   'факультет инфокоммуникаций',
   'инженерно-экономический факультет',
   'институт информационных технологий',
   'факультет инновационного образования'
   );
   nameDecan: array[0..9] of string = (
   'Иванов Сергей Петрович', 'Петрова Анна Николаевна',
   'Сидоров Алексей Иванович', 'Кузнецова Мария Александровна',
   'Морозов Дмитрий Сергеевич', 'Васильева Ольга Викторовна',
   'Николаев Павел Андреевич', 'Смирнова Екатерина Юрьевна',
   'Козлов Игорь Михайлович', 'Лебедева Татьяна Олеговна'
   );
var
   myFile: File of TFaculty;
   temp: TFaculty;
begin
  AssignFile(myFile, 'Data\Faculty');
  reWrite(myFile);
  for var i:= Low(nameFac) to High(nameFac) do begin
    temp.id:= i;
    temp.name:= NameFac[i];
    temp.decanName:= nameDecan[i];
    Seek(myFile, i);
    Write(myFile, temp);
  end;
  CloseFile(myFile);
end;

procedure createData();
begin

end;

end.
