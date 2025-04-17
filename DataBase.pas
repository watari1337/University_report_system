unit DataBase;

interface

uses System.SysUtils, Vcl.Dialogs;

procedure createData();
procedure loadData();

type
    TLearntSubject = Record
      id: integer;
      name: string[100];
//      teacher: string[100];
    End;

    TTeacher = Record
      id: integer;
      name: string[255]; //должность + ФИО
    End;

    {Tpattern = Record
      id: integer;
      name: string[100];
    End;}
    TarrPattern = array of string;

//    TSemester = Record
//      value: integer;
//      group: array[1..40] of string[100]; //ФИО
//    End;

    TStudent = Record
      id: integer;
      group: integer;
      name: String[100];
    End;

    TPairSabjectTeacher = Record
      sbj: integer;
      teacher: integer;
    End;

    TPairSemestrAndLearntSBJ = Record
      semestr: integer;
      arrSbj: array[0..20] of TPairSabjectTeacher
    End;

    TGroup = Record
      id: integer;
      arrSemestr: array[0..9] of TPairSemestrAndLearntSBJ;
    End;

    TSpisiality = Record
      id: integer;
      facultyId: integer;
      name: string[60];
//      semester: TSemester; //1-8
//      subjects: array[1..15] of TSubject;
    End;

    TLearntForm = Record
      id: integer;
      name: string[100];
    End;

    TFaculty = Record
      id: integer;
      name: string[60];
      decanName: string[60];    //в дательном падеже
      //spisiality: array[0..10] of TSpisiality;
    End;

    //это для типизированного файла, а в проге ещё в каждом должен быть адрес
    //элемента выше, чтобы зная студента можно было определять его семестр и предметы

var
  arrPattern: TArrPattern;

implementation

Procedure createFileFaculty();
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

Procedure createFileSBJ();
const
   nameSbj: array[0..49] of string = (
   'математика', 'физика', 'химия', 'биология', 'информатика',
   'программирование', 'история', 'философия', 'экономика', 'социология',
    'психология', 'литература', 'русский язык', 'английский язык', 'немецкий язык',
    'французский язык', 'политология', 'право', 'география', 'статистика',
    'линейная алгебра', 'дифференциальные уравнения', 'теория вероятностей',
    'алгоритмы', 'базы данных', 'компьютерные сети', 'искусственный интеллект',
    'машинное обучение', 'физическая химия', 'органическая химия', 'генетика',
    'экология', 'анатомия', 'микробиология', 'культурология', 'этика', 'логика',
    'маркетинг', 'менеджмент', 'финансы', 'бухгалтерский учет', 'микроэкономика',
    'макроэкономика', 'международные отношения', 'конституционное право',
    'гражданское право', 'уголовное право', 'история искусства', 'архитектура', 'дизайн'
   );
var
   myFile: File of TLearntSubject;
   temp: TLearntSubject;
begin
  AssignFile(myFile, 'Data\Subject');
  reWrite(myFile);
  for var i:= Low(nameSbj) to High(nameSbj) do begin
    temp.id:= i;
    temp.name:= nameSbj[i];
    Seek(myFile, i);
    Write(myFile, temp);
  end;
  CloseFile(myFile);
end;

Procedure createFileTeacher();
const
   name: array[0..29] of string = (
   'профессор кафедры математики, иванов пётр александрович',
   'доцент кафедры физики, петрова анна сергеевна',
   'профессор кафедры химии, смирнов дмитрий иванович',
   'доцент кафедры биологии, соколов николай павлович',
   'профессор кафедры информатики, кузнецова екатерина михайловна',
   'доцент кафедры программирования, попов алексей викторович',
   'профессор кафедры истории, васильева мария николаевна',
   'доцент кафедры философии, морозов игорь олегович',
   'профессор кафедры экономики, новикова ольга дмитриевна',
   'доцент кафедры социологии, федоров сергей андреевич',
   'профессор кафедры психологии, михайлова юлия владимировна',
   'доцент кафедры литературы, белов владимир степанович',
   'профессор кафедры русского языка, кравченко наталья игоревна',
   'доцент кафедры английского языка, григорьев артем валерьевич',
   'профессор кафедры политологии, орлова светлана алексеевна',
   'доцент кафедры права, зотов андрей борисович',
   'профессор кафедры географии, сидорова татьяна романовна',
   'доцент кафедры статистики, лазарев михаил юрьевич',
   'профессор кафедры линейной алгебры, воробьёва елена викторовна',
   'доцент кафедры алгоритмов, гусев олег константинович',
   'профессор кафедры баз данных, авдеева алина петровна',
   'доцент кафедры компьютерных сетей, рябов виктор сергеевич',
   'профессор кафедры искусственного интеллекта, королёва дарья александровна',
   'доцент кафедры машинного обучения, тимофеев павел геннадьевич',
   'профессор кафедры физической химии, борисова надежда фёдоровна',
   'доцент кафедры органической химии, жуков леонид васильевич',
   'профессор кафедры генетики, шарова вера николаевна',
   'доцент кафедры экологии, котов даниил антонович',
   'профессор кафедры анатомии, медведева лидия ивановна',
   'доцент кафедры микробиологии, соловьёв ярослав эдуардович'
   );
var
   myFile: File of TTeacher;
   temp: TTeacher;
begin
  AssignFile(myFile, 'Data\Teacher');
  reWrite(myFile);
  for var i:= Low(name) to High(name) do begin
    temp.id:= i;
    temp.name:= name[i];
    Seek(myFile, i);
    Write(myFile, temp);
  end;
  CloseFile(myFile);
end;

Procedure createFileTLearntForm();
const
   name: array[0..8] of string = ('дневная', 'обучение студентов-граждан иностранных государств',
   'вечера', 'заочка', 'дистанционная', 'интегрированная вечера', 'интегрированная заочка',
   'интегрированная дистанционная', 'интегрированная дневная'
   );
   id: array[0..8] of integer = (0,1,3,4,5,6,7,8,9);
var
   myFile: File of TLearntForm;
   temp: TLearntForm;
begin
  AssignFile(myFile, 'Data\LearntForm');
  reWrite(myFile);
  for var i:= Low(name) to High(name) do begin
    temp.id:= id[i];
    temp.name:= name[i];
    Seek(myFile, i);
    Write(myFile, temp);
  end;
  CloseFile(myFile);
end;

{Procedure createFileTLearntForm();
const
   name: array[0..8] of string = ('дневная', 'обучение студентов-граждан иностранных государств',
   'вечера', 'заочка', 'дистанционная', 'интегрированная вечера', 'интегрированная заочка',
   'интегрированная дистанционная', 'интегрированная дневная'
   );
   id: array[0..8] of integer = (0,1,3,4,5,6,7,8,9);
var
   myFile: File of TLearntForm;
   temp: TLearntForm;
begin
  AssignFile(myFile, 'Data\LearntForm');
  reWrite(myFile);
  for var i:= Low(name) to High(name) do begin
    temp.id:= id[i];
    temp.name:= name[i];
    Seek(myFile, i);
    Write(myFile, temp);
  end;
  CloseFile(myFile);
end;}

procedure createData();
begin
  createFileFaculty();
  createFileSBJ();
  createFileTeacher();
  createFileTLearntForm
end;


//записывает все файлы txt из папки pattarn в массив result
function loadPattern(): TarrPattern;
const
  path: string = '.\Pattern\*.txt';
var
  searchResult: TSearchRec;
  i: integer;
begin
  {if DirectoryExists(path) then begin

  end
  else showMessage('no data to read');}
  SetLength(result, 10);
  i:= 0;
  if (FindFirst(path, FaAnyFile, searchResult) = 0) then begin
    try
      repeat
        if (i >= length(result)) then SetLength(result, length(result)*2);
        //result[i].id:= i;
        result[i]:= searchResult.Name;
        inc(i);
        //showMessage(searchResult.Name);
      until FindNext(searchResult) <> 0;
    finally
      FindClose(searchResult);
    end;
  end;

end;

procedure loadData();
begin
  arrPattern:= loadPattern();
end;

end.
