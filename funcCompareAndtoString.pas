unit funcCompareAndtoString;

interface

uses DataBase;

function CompareTTeacher(first, second: TTeacher): boolean;
function CompareTLearntSubject(first, second: TLearntSubject): boolean;
function CompareTStudent(first, second: TStudent): boolean;
function CompareTPairSabjectTeacher(first, second: array of TPairSabjectTeacher): boolean;
function CompareTPairSL(first, second: array of TPairSemestrAndLearntSBJ): boolean;
function CompareTGroup(first, second: TGroup): boolean;
function CompareTSpecialty(first, second: TSpecialty): boolean;
function CompareTLearntForm(first, second: TLearntForm): boolean;
function CompareTFaculty(first, second: TFaculty): boolean;

function toStringTTeacher(element: TTeacher): string;
function toStringTLearntSubject(element: TLearntSubject): string;
function toStringTStudent(element: TStudent): string;
function toStringTPairSabjectTeacher(element: array of TPairSabjectTeacher): string;
function toStringTPairSL(element: array of TPairSemestrAndLearntSBJ): string;
function toStringTGroup(element: TGroup): string;
function toStringTSpecialty(element: TSpecialty): string;
function toStringTLearntForm(element: TLearntForm): string;
function toStringTFaculty(element: TFaculty): string;

implementation

uses System.SysUtils;

function CompareTTeacher(first, second: TTeacher): boolean;
begin
  result:= (first.id = second.id) and (first.name = second.name);
end;

function CompareTLearntSubject(first, second: TLearntSubject): boolean;
begin
  result:= (first.id = second.id) and (first.name = second.name);
end;

function CompareTStudent(first, second: TStudent): boolean;
begin
  result:= (first.year = second.year) and (first.id = second.id) and (first.name = second.name);
end;


function CompareTPairSabjectTeacher(first, second: array of TPairSabjectTeacher): boolean;
var
  i: integer;
begin
  result:= true;
  i:= 0;
  while (result <> false) and (i < length(first)) do begin
    result:= (first[i].sbj = second[i].sbj) and (first[i].teacher = second[i].teacher);
    inc(i);
  end;
end;

function CompareTPairSL(first, second: array of TPairSemestrAndLearntSBJ): boolean;
var
  i: integer;
begin
  result:= true;
  i:= 0;
  while (result <> false) and (i < length(first)) do begin
    result:= (first[i].semestr = second[i].semestr) and (first[i].numSBJ = second[i].numSBJ);
    if (result) then result:= CompareTPairSabjectTeacher(first[i].arrSbj, second[i].arrSbj);
    inc(i);
  end;

end;

function CompareTGroup(first, second: TGroup): boolean;
begin
  result:= (first.id = second.id) and (first.numSemestr = second.numSemestr) and
  CompareTPairSL(first.arrSemestr, second.arrSemestr);
end;

function CompareTSpecialty(first, second: TSpecialty): boolean;
begin
  result:= (first.id = second.id) and (first.facultyId = second.facultyId) and (first.name = second.name);
end;

function CompareTLearntForm(first, second: TLearntForm): boolean;
begin
  result:= (first.id = second.id) and (first.name = second.name);
end;

function CompareTFaculty(first, second: TFaculty): boolean;
begin
  result:= (first.id = second.id) and (first.name = second.name) and (first.decanName = second.decanName);
end;





function ToStringTTeacher(element: TTeacher): string;
begin
  result:= Format('%-6d %150s', [element.id, element.name]);
end;

function ToStringTLearntSubject(element: TLearntSubject): string;
begin
  result:= intToStr(element.id) + '  ' + element.name;
end;

function ToStringTStudent(element: TStudent): string;
begin
  result:= intToStr(element.year) + '  ' + intToStr(element.id) + '  ' + element.name;
end;


function ToStringTPairSabjectTeacher(element: array of TPairSabjectTeacher): string;
var
  i: integer;
begin
  i:= 0;
  while (i < length(element)) do begin
    result:= intToStr(element[i].sbj) + '  ' + intToStr(element[i].teacher);
    inc(i);
  end;
end;

function ToStringTPairSL(element: array of TPairSemestrAndLearntSBJ): string;
var
  i: integer;
begin
  i:= 0;
  while (i < length(element)) do begin
    result:= intToStr(element[i].semestr) + '  '  + intToStr(element[i].numSBJ) +
    ToStringTPairSabjectTeacher(element[i].arrSbj[i]);
    inc(i);
  end;
end;

function ToStringTGroup(element: TGroup): string;
begin
  result:= intToStr(element.id) + '  ' + intToStr(element.numSemestr) + '  ' +
  ToStringTPairSL(element.arrSemestr);
end;

function ToStringTSpecialty(element: TSpecialty): string;
begin
  result:= intToStr(element.id) + '  ' + intToStr(element.facultyId) +
  '  ' + element.name;
end;

function ToStringTLearntForm(element: TLearntForm): string;
begin
  result:= intToStr(element.id) + '  ' + element.name;
end;

function ToStringTFaculty(element: TFaculty): string;
begin
  result:= intToStr(element.id) + '  ' + element.name + '  ' + element.decanName;
end;

end.
