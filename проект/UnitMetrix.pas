unit UnitMetrix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RegExpr;

type
  TFormMetrix = class(TForm)
    MemoCode: TMemo;
    LCode: TLabel;
    OpenDlgCode: TOpenDialog;
    PCMetrix: TPageControl;
    TShCode: TTabSheet;
    TShMak: TTabSheet;
    MemoMcCabe: TMemo;
    EditCiclomatic: TEdit;
    LOperatorsMap: TLabel;
    LMc_CabeNumber: TLabel;
    EditArcsCount: TEdit;
    EditTopsCount: TEdit;
    LArcsCount: TLabel;
    LTopsCount: TLabel;
    GBChekedAction: TGroupBox;
    BOpenCode: TButton;
    BCorrectCode: TButton;
    BMcMetrix: TButton;
    EditRowsCount: TEdit;
    LRowsCount: TLabel;
    procedure BOpenCodeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BMakMetrixClick(Sender: TObject);
    procedure TextClear;
    procedure CreateListOfReservWords;
    procedure MakeMetrix;
    procedure Mc_Cabe(MetrixFile:string);
    procedure CreateTempFuncFiles(ActiveFile:string);
    procedure DeleteTempFiles;
    procedure BCorrectCodeClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MemoCodeKeyPress(Sender: TObject; var Key: Char);
    function  CreateNameNewFunction(ChekedString:string):string;

 end;

var
  FormMetrix : TFormMetrix;
  StringListCode, StringListFunctions, StringListReserveWords : TStringList;
  BlocksCount, PositionProcString, ArcsCount : integer;

implementation

{$R *.dfm}


Procedure TFormMetrix.FormActivate(Sender : TObject);
begin
  StringListCode := TStringList.Create;
end;

Procedure TFormMetrix.MemoCodeKeyPress(Sender: TObject; var Key: Char);
begin
  EditRowsCount.Text := IntToStr(MemoCode.Lines.Count);
end;

Procedure TFormMetrix.BOpenCodeClick(Sender : TObject);
begin
  if OpenDlgCode.Execute then
  begin
    MemoCode.Lines.LoadFromFile(OpenDlgCode.FileName);
    EditRowsCount.Text := IntToStr(MemoCode.Lines.Count);
  end;
end;


Procedure TFormMetrix.TextClear;

procedure DeleteGaps;
var
  count : integer;
begin
  for count := 0 to StringListCode.Count-1 do
  begin
  if (length(StringListCode[count]) > 0) then
    if (StringListCode[count][length(StringListCode[count])] = ' ') and
      (length(StringListCode[count]) > 1) then
    repeat
      StringListCode[count] := Copy(StringListCode[count],1,length(StringListCode[count])-1);
    until (StringListCode[count][length(StringListCode[count])] <> ' ') or (length(StringListCode[count]) = 1);
  end;
end;

procedure DeleteLongComments;

const
  OpenCommentSymbols = '/*';
  CloseCommentSymbols = '*/';
var
  SymbolOpenCommentCount, SymbolCloseCommentCount, RowsCount, StartCommentPosition,
  EndCommentPosition, counter, StartCommentStringNumber,EndCommentStringNumber, ChekedSymbolPosition : integer;
  ChekedSymbols:string[2];
  FindCommentSymbols : boolean;

begin
  SymbolOpenCommentCount := 0;
  SymbolCloseCommentCount := 0;

  StartCommentStringNumber := 0;
  EndCommentStringNumber := 0;

  StartCommentPosition := 0;
  EndCommentPosition := 0;

  RowsCount := 0;
  while RowsCount < StringListCode.Count do
  begin
    ChekedSymbolPosition := 1;
    while ChekedSymbolPosition < length(StringListCode[RowsCount])do
    begin
      FindCommentSymbols := false;
      ChekedSymbols := Copy(StringListCode[RowsCount], ChekedSymbolPosition, 2);
      if ChekedSymbols = OpenCommentSymbols then
      begin
        FindCommentSymbols := true;
        if (SymbolOpenCommentCount = 0) then
        begin
          StartCommentPosition := ChekedSymbolPosition;
          StartCommentStringNumber := RowsCount;
        end;
        Inc(SymbolOpenCommentCount);
      end
      else
      begin
        if ChekedSymbols = CloseCommentSymbols then
        begin
          FindCommentSymbols := true;
          if (SymbolCloseCommentCount = SymbolOpenCommentCount-1) then
          begin
            EndCommentPosition := ChekedSymbolPosition+1;
            EndCommentStringNumber := RowsCount;
          end;
          Inc(SymbolCloseCommentCount);
        end;
      end;

      if not FindCommentSymbols then
        inc(ChekedSymbolPosition)
      else
        ChekedSymbolPosition := ChekedSymbolPosition+2;
    end;

    if (SymbolOpenCommentCount = SymbolCloseCommentCount) and (SymbolOpenCommentCount <> 0) then
    begin
      if (EndCommentStringNumber = StartCommentStringNumber) then
        StringListCode[StartCommentStringNumber] := Copy(StringListCode[StartCommentStringNumber], 1, StartCommentPosition-1)
        + Copy(StringListCode[StartCommentStringNumber], EndCommentPosition+1, length(StringListCode[StartCommentStringNumber])-EndCommentPosition)
      else
      begin
        for counter := StartCommentStringNumber+1 to  EndCommentStringNumber-1 do
          StringListCode[counter] := ' ';
        StringListCode[StartCommentStringNumber] := Copy(StringListCode[StartCommentStringNumber], 1, StartCommentPosition-1);
        StringListCode[EndCommentStringNumber] := Copy(StringListCode[EndCommentStringNumber], EndCommentPosition+1, length(StringListCode[EndCommentStringNumber])-EndCommentPosition);
      end;
      SymbolOpenCommentCount := 0;
      SymbolCloseCommentCount := 0;
    end;

    Inc(RowsCount);
  end;
end;


procedure DeleteComments;
var
  FindComments : TRegExpr;
begin
  FindComments := TRegExpr.Create;
  FindComments.InputString := StringListCode.Text;
  FindComments.Expression := '('#39'(.*?)'#39')';
  if (FindComments.Exec(StringListCode.Text)) then
    StringListCode.Text := FindComments.Replace(StringListCode.Text,'');
  FindComments.Expression := '(//(.*?)\n)';
  if (FindComments.Exec(StringListCode.Text)) then
    StringListCode.Text := FindComments.Replace(StringListCode.Text,'');
  FindComments.Free;
end;

begin
  DeleteGaps;
  DeleteLongComments;
  DeleteComments;
end;


Function WordExistInString(SubString, StringForSearch : string) : boolean;
var
  FirstWord, LastWord, Word, Operator : string;
begin
  Result := false;
  if length(SubString) = length(StringForSearch) then
  begin
    if StringForSearch = SubString then
      Result := true;
  end
  else
    if length(SubString) < length(StringForSearch) then
    begin
      FirstWord := SubString+' ';
      LastWord := ' '+SubString;
      Word := ' '+SubString+' ';
      Operator := SubString+'(';
      if ((pos(Word, StringForSearch) <> 0) or (pos(FirstWord, StringForSearch) = 1)
       or(pos(LastWord, StringForSearch) = length(StringForSearch)-length(LastWord)+1)
       or(pos(Operator, StringForSearch) <> 0))  then
        Result := true;
    end;
end;


Procedure TFormMetrix.CreateListOfReservWords;
begin
  StringListReserveWords := TStringList.Create;
  with StringListReserveWords do
  begin
    Add('void');
    Add('int');
    Add('char');
    Add('signed');
    Add('unsigned');
    Add('short');
    Add('long');
  end;
end;


Function TFormMetrix.CreateNameNewFunction(ChekedString : string) : string;
var
  FindFunction : boolean;
  CountReservWord : integer;
  NewFunctionName : string;

function SearchFunctionDeclaration(SubString, SearchString : string) : string;
var
  StartOfName,EndOfName : integer;
  SubStringPointer : string;
begin
  Result := '';
  SubString := SubString+' ';
  SubStringPointer := SubString+'*';
  if SearchString <> '' then
  begin
    if (SearchString[length(SearchString)] = '{') or (SearchString[length(SearchString)] = ')') then
      if (pos(SubString, SearchString) <> 0) or (pos(SubStringPointer, SearchString) <> 0) then
      begin
        EndOfName := pos('(', SearchString);
        if (pos(SubString, SearchString) <> 0) then
          StartOfName := pos(SubString, SearchString)+length(SubString)
        else
          StartOfName := pos(SubStringPointer, SearchString)+length(SubStringPointer);
        Result := Copy(SearchString, StartOfName, EndOfName-StartOfName);
      end
      else
  end;
end;

begin
  Result := '';
  CountReservWord := 0;
  FindFunction := false;
  while (CountReservWord < StringListReserveWords.Count) and (not (FindFunction))  do
  begin
    NewFunctionName := SearchFunctionDeclaration(StringListReserveWords[CountReservWord], ChekedString);
    if NewFunctionName <> '' then
    begin
      FindFunction := true;
      Result := NewFunctionName;
    end;
    Inc(CountReservWord);
  end;
end;


Procedure TFormMetrix.CreateTempFuncFiles(ActiveFile : string);
var
  NameFunctionFile, DeclaredFunctionName : string;
  FileForNewFunction : TextFile;

Function CreateNewFile : string;
begin
    Result := '';
    DeclaredFunctionName := CreateNameNewFunction(StringListCode[PositionProcString]);
    if (DeclaredFunctionName <> '') and (DeclaredFunctionName <> 'main') then
    begin
      NameFunctionFile := DeclaredFunctionName+'.txt';
      AssignFile(FileForNewFunction, NameFunctionFile);
      Rewrite(FileForNewFunction);
      StringListFunctions.Add(DeclaredFunctionName);
      CloseFile(FileForNewFunction);
      Result := NameFunctionFile;
    end
end;

Procedure SaveFuncToFile(FileForRecordThisFunction : string);
var
  CurrentFile : TextFile;
  OpenBracketCount, CloseBracketCount : integer;
  NewFuncFile : string;
begin
  AssignFile(CurrentFile, FileForRecordThisFunction);
  Append(CurrentFile);

  OpenBracketCount := 0;
  CloseBracketCount := 0;
  while  ((OpenBracketCount <> CloseBracketCount) or (CloseBracketCount = 0))
    and (PositionProcString < StringListCode.Count-1) do
  begin
    Inc(PositionProcString);
    NewFuncFile := CreateNewFile;
    if NewFuncFile <> '' then
      SaveFuncToFile(NewFuncFile);
    if pos('{', StringListCode[PositionProcString]) <> 0 then
      Inc(OpenBracketCount);
    if pos('}', StringListCode[PositionProcString]) <> 0 then
      Inc(CloseBracketCount);
    Writeln(CurrentFile, StringListCode[PositionProcString]);
  end;
  CloseFile(CurrentFile);
  Inc(PositionProcString);
end;

begin
  while PositionProcString < StringListCode.Count-1 do
     SaveFuncToFile(ActiveFile)
end;


Function WhileExistInString(ChekedString : string) : boolean;
var
  SubString : string;
begin
  result := false;
  SubString := 'while';
  if ( pos(substring,ChekedString) <> 0) and
    (ChekedString[length(ChekedString)] = ')') then
    result := true;
end;

Function TernaryOperatorExistInString (ChekedString : string):boolean;
var
  FindComments : TRegExpr;
begin
  result := false;
  FindComments := TRegExpr.Create;
  FindComments.InputString := ChekedString;
  FindComments.Expression := '(\?(.*?):)';
  if (FindComments.Exec(ChekedString)) then
    result := true;
  FindComments.Free;
end;


Procedure TFormMetrix.Mc_Cabe(MetrixFile : string);
var
  CodeFile : TextFile;
  ChekedString, FindFunctionName : string;

function FunctionNameInString(ChekedString : string) : string;
var
  counter : integer;
  FoundFunctionName : boolean;
begin
  counter := 0;
  FoundFunctionName := false;
  Result := '';
  while (counter < StringListFunctions.Count) and (not (FoundFunctionName)) do
  begin
    if WordExistInString(StringListFunctions[Counter], ChekedString) then
    begin
      FoundFunctionName := true;
      Result := StringListFunctions[Counter];
    end
    else
      Inc(counter);
  end;
end;


Procedure ProcessedFunction(FunctionName : string);
var
  FunctionFileName : string;
begin
  FunctionFileName := FunctionName+'.txt';
  Mc_Cabe(FunctionFileName);
end;

procedure SearchOperators;

procedure  ActionsWhenFindReservWord(ReservWord : string);
var
  StringForOperateEnd : string;
begin
    Inc(BlocksCount);
    Inc(ArcsCount,2);
    MemoMcCabe.Lines.Add(ReservWord);
    SearchOperators;
    StringForOperateEnd := 'end'+ReservWord;
    MemoMcCabe.Lines.Add(StringForOperateEnd);
end;

begin
  while not (eof(CodeFile)) do
  begin
    Readln(CodeFile, ChekedString);
    if ChekedString <> '' then
    begin
      FindFunctionName := FunctionNameInString(ChekedString);
      if FindFunctionName <> '' then
        ProcessedFunction(FindFunctionName)
      else
        if WordExistInString('if', ChekedString) then
        begin
          ActionsWhenFindReservWord('if');
          Inc(ArcsCount);
        end
        else
          if TernaryOperatorExistInString(ChekedString) then
          begin
            Inc(BlocksCount);
            Inc(ArcsCount,2);
            MemoMcCabe.Lines.Add('if');
            MemoMcCabe.Lines.Add('endif');
          end
          else
          if WhileExistInString(ChekedString) then
          begin
            ActionsWhenFindReservWord('while');
            Inc(BlocksCount);
          end
          else
            if WordExistInString('for', ChekedString) then
            begin
              ActionsWhenFindReservWord('for');
              Inc(BlocksCount);
            end
            else
              if WordExistInString('do', ChekedString) then
              begin
                ActionsWhenFindReservWord('do');
                Inc(BlocksCount);
              end
              else
                if WordExistInString('case', ChekedString) then
                begin
                  Inc(BlocksCount);
                  Inc(ArcsCount);
                  MemoMcCabe.Lines.Add('case');
                  SearchOperators;
                end
                else
                  if WordExistInString('switch', ChekedString) then
                  begin
                    MemoMcCabe.Lines.Add('switch');
                    SearchOperators;
                    Dec(BlocksCount);
                    Inc(ArcsCount);
                    MemoMcCabe.Lines.Add('endswitch');
                  end;
    end;
  end;
end;

begin
  AssignFile(CodeFile,MetrixFile);
  Reset(CodeFile);
  SearchOperators;
  CloseFile(CodeFile);
end;

Procedure TFormMetrix.DeleteTempFiles;
var
  counter : integer;
  FileForDelete : string;
begin
  StringListFunctions.Add('Main');
  for counter := 0 to StringListFunctions.Count-1 do
  begin
    FileForDelete := StringListFunctions[counter]+'.txt';
    DeleteFile(FileForDelete);
  end;
end;

Procedure TFormMetrix.FormPaint(Sender: TObject);
begin
  EditRowsCount.Text := '0';
end;

Procedure TFormMetrix.MakeMetrix;
var
  NumberOfProcString : integer;
  MainFile : TextFile;

procedure Typedef(StringForSearch : string);
var
  counter : integer;
  NewReservWord : string;
begin
  if WordExistInString('typedef', StringForSearch) then
  begin
    counter := pos(';', StringForSearch);
    while StringForSearch[counter] <> ' ' do
      dec(counter);
    NewReservWord := Copy(StringForSearch,counter+1, pos(';', StringForSearch)-counter-1);
    StringListReserveWords.Add(NewReservWord);
  end;
end;

begin
  BlocksCount := 1;
  ArcsCount := 0;

  CreateListOfReservWords;
  NumberOfProcString := 0;
  while NumberOfProcString < StringListCode.Count do
  begin
    Typedef(StringListCode[NumberOfProcString]);
    Inc(NumberOfProcString);
  end;
  PositionProcString := 0;
  AssignFile(MainFile, 'Main.txt');
  Rewrite(MainFile);
  CloseFile(MainFile);
  StringListFunctions := TStringList.Create;
  Dec(PositionProcString);
  CreateTempFuncFiles('Main.txt');
  Inc(BlocksCount);
  Mc_Cabe('Main.txt');
  if  MemoMcCabe.Lines.Count=0 then
  begin
    EditArcsCount.Text := '0';
    EditTopsCount.Text := '0';
    EditCiclomatic.Text := '0';
  end
  else
  begin
    EditArcsCount.Text := IntToStr(ArcsCount);
    EditTopsCount.Text := IntToStr(BlocksCount);
    EditCiclomatic.Text := IntToStr(ArcsCount-BlocksCount+2);
  end;
  DeleteTempFiles;

end;

Procedure TFormMetrix.BMakMetrixClick(Sender : TObject);
begin
  if MemoCode.Text = '' then
    MessageDLG('Загрузите код!',mtError,[mbOk],0)
  else
  begin
    MemoMcCabe.Clear;
    StringListCode.Clear;
    StringListCode.Text := MemoCode.Text;
    TextClear;
    PCMetrix.ActivePageIndex := 1;
    TextClear;
    MakeMetrix;
  end;
end;


procedure TFormMetrix.BCorrectCodeClick(Sender: TObject);
begin
   if MemoCode.Text = '' then
    MessageDLG('Загрузите код!',mtError,[mbOk],0)
  else
  begin
    StringListCode.Text := MemoCode.Text;
    TextClear;
    MemoCode.Text := StringListCode.Text;
    EditRowsCount.Text := IntToStr(MemoCode.Lines.Count);
  end;
end;


end.
