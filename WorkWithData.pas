unit WorkWithData;

interface

uses DataBase;

function makeTitle(listType: TAllType): Sarr;
procedure PushListT(element: VarArr);

implementation

function makeTitle(listType: TAllType): Sarr;
begin
  case listType of
    Teacher: result:= ['Id', 'Должность', 'ФИО'];
    LearntSubject: result:= ['Id', 'Название предмета'];
    Student: result:= ['Id студента', 'год поступления', 'группа', 'ФИО'];
    Group: result:= ['Номер группы', 'студентов в группе', 'предметов изучают'];
    Specialty: result:= ['Id спец.', 'id факультета', 'Имя специальности'];
    LearntForm: result:= ['Id', 'Форма обучения'];
    Faculty: result:= ['Id', 'Факультет', 'Имя декана'];
  end;
end;



procedure PushListT(element: VarArr);
var
  nowTeacher: TTeacher;
  nowLearntSubject: TLearntSubject;
  nowStudent: TStudent;
  nowGroup: TGroup;
  nowSpecialty: TSpecialty;
  nowLearntForm: TLearntForm;
  nowFaculty: TFaculty;
begin
  case workObjNow of
    Teacher: begin
      objTTeacher.WriteT(element, nowTeacher);
      objTTeacher.pushList(nowTeacher);
    end;
    LearntSubject: begin
      objTLearntSubject.WriteT(element, nowLearntSubject);
      objTLearntSubject.pushList(nowLearntSubject);
    end;
    Student: begin
      objTStudent.WriteT(element, nowStudent);
      objTStudent.pushList(nowStudent);
    end;
    Group: begin
      objTGroup.WriteT(element, nowGroup);
      objTGroup.pushList(nowGroup);
    end;
    Specialty: begin
      objTSpecialty.WriteT(element, nowSpecialty);
      objTSpecialty.pushList(nowSpecialty);
    end;
    LearntForm: begin
      objTLearntForm.WriteT(element, nowLearntForm);
      objTLearntForm.pushList(nowLearntForm);
    end;
    Faculty: begin
      objTFaculty.WriteT(element, nowFaculty);
      objTFaculty.pushList(nowFaculty);
    end;
  end;
end;

end.
