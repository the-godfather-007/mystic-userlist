uses
  user,
  cfg

Const
  MaxLines = 12            // Max number of lines to display to screen for 80x25
(*  Maxlines132= 19        // Max number of lines to display to screen for 132x37 *)
  sy = 11                  // Top right y (line) location you want the user list to begin listing within the ansi
  sx = 3                   // Top right x (column) location you want to start the user listing 
  hx = 3                   //header text  
  hy = 9                   //header text 
  my = 24                  // menu prompt y location
  mx = 1                   // menu prompt x location  
  cl = 51                  // menu prompt total character length (including spaces)
  cs = 76
  HB = '[0;40 D|24|15'  // High Bar (Light Bar) Color -- Ansi codes are Amiga Topaz, if you want to remove, do so carefully.
  LB = '[0;40 D|16|08'  // Low bar (no light bar) Color -- Ansi codes are Amiga Topaz, if you want to remove, do so carefully.
  XS = '|[X03'             // currently screen 2 X position  
                           // without stripping ALL color by using WriteXY.   
  C1 = '|15'               // SORTING:  Color of highlighted column being sorted
  C2 = '|08'               // SORTING:  Color of non highlighted columns.  
  C3 = '|12'               // header text Capital first letter color  
  C4 = '|04'               // header text lower case color  

Type
  UserRecord = Record
    Active     : Boolean
    Name       : String[30]
    Location   : String[30]
    Gender     : Char
    Age        : Byte
    FirstOn    : LongInt;                                // Date/Time of First Call Unix
    LastOn     : LongInt;                                // Date/Time of Last Call Unix
    Calls      : LongInt;                                // Number of calls to BBS
 End;

Var
  UserCount : Integer = 1        //user loop counter 
  LineCount : Integer = 1        //line counter for cursor placement to remain under 10 line header
  MaxUser   : Integer
  Idx       : Integer=1          //Index marker for the lightbar
  UserIdx   : Integer=1
  ListUser  : UserRecord 

Procedure Clear                       //clear ansi to next 10 users below header
Var
  g  : Byte
begin

  for g:=sy to TermSizeY-1 Do WriteXY(sx,g,7,StrRep(' ',cs))
End

Procedure Header
Begin
  ClrScr
  DispFile('rcsuserlisthr')
  write('|[0')
  gotoxy(hx,hy)
  write(C3+'A'+C4+'lias'+C3+'                 L'+C4+'ocation                '+C3+'S'+C4+'ecLvl'+C3+'  F'+C4+'irstOn    '+C3+'L'+C4+'astOn')
  gotoxy(sx,sy)   
end

Procedure Header2
Begin
  ClrScr
  Dispfile('rcsuserlisthr')
  write('|[0')
  gotoxy(hx,hy)
  Write(C3+'A'+C4+'lias                  '+C3+'S'+C4+'eclev  '+C3+'C'+C4+'alls  '+C3+'P'+C4+'osts  '+C3+'U'+C4+'Ls    '+C3+'D'+C4+'Ls   '+C3+'F'+C4+'irstOn   '+C3+'L'+C4+'astOn')
  gotoxy(sx,sy)
End 
  
Procedure ListUsers
Var
  Count  : Integer
Begin
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(Count) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        WriteLn(XS+HB+useralias+'|$X24 |15|$T21'+usercity+'|$X50 |15'+Int2Str(UserSec)+'|$X56 |15'+datestr(DateU2D(userFirstOn),1)+'|$X66 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=Idx
      End
      Else WriteLn(XS+C1+useralias+LB+'|$X24 |$T21'+usercity+'|$X50 '+Int2Str(UserSec)+'|$X56 '+datestr(DateU2D(userFirstOn),1)+'|$X66 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

(* Procedure ListUsers132
Var
  Count  : Integer
Begin
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(Count) And LineCount<=MaxLines132 Do        
  Begin
    If LineCount<=MaxLines132 Then
    begin
      If Count=Idx Then WriteLn('[0;40 D|24|[X09|15'+useralias+'|[X29|15'+usercity+'|[X51|15'+datestr(DateU2D(userFirstOn),1)+'|[X65|15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
      Else WriteLn('[0;40 D|16|[X09|08'+useralias+'|[X29|08'+usercity+'|[X51'+datestr(DateU2D(userFirstOn),1)+'|[X65'+datestr(DateU2D(userlaston),1)+'[0;0 D')  //All other users without lightbar
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End *)

Procedure ListUsersMore //This function will display more information about the user, including Total Calls, Posts, Uploads, Messages, Downloads, etc...
Var
  Count  : Integer
Begin
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(Count) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
      Else WriteLn(XS+LB+useralias+'|$X25 '+Int2Str(UserSec)+'|$X33 '+Int2Str(userCalls)+'|$X40 '+Int2Str(userPosts)+'|$X47 '+Int2Str(UserUL)+'|$X54 '+Int2Str(UserDL)+'|$X60 '+datestr(DateU2D(userFirstOn),1)+'|$X70 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure ListUsersCalls //This function will sort and list the users in sorted order by calls
Type
  UserCallRecord = Record
    Index   : Integer
    ListIdx : Integer
    Calls   : Integer
End
Var
  Count      : Integer=1
  UserCall   : Array[1..500] Of UserCallRecord
  x,y,z,temp : Integer
Begin
  While GetUser(Count) Do
  Begin
    UserCall[Count].Index:=Count
    UserCall[Count].Calls:=UserCalls
    Count:=Count+1
  End
  z:=Count
  temp:=Count+1
  For x:=1 to Count Do
    For y:=1 to Count Do
      If UserCall[x].Calls > UserCall[y].Calls Then
      Begin
        UserCall[temp]:=UserCall[x]
        UserCall[x]:=UserCall[y]
        UserCall[y]:=UserCall[temp]
      End
  UserCall[temp].Index:=0
  Count:=1
  While Count<MaxUser+1 Do
  Begin
    UserCall[Count].ListIdx:=Count
    Count:=Count+1
  End
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(UserCall[Count].Index) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=UserCall[Count].Index
      End
      Else WriteLn(XS+LB+useralias+'|$X25 '+Int2Str(UserSec)+'|$X33 '+C1+Int2Str(userCalls)+LB+'|$X40 '+Int2Str(userPosts)+'|$X47 '+Int2Str(UserUL)+'|$X54 '+Int2Str(UserDL)+'|$X60 '+datestr(DateU2D(userFirstOn),1)+'|$X70 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure ListUsersLastOn //This function will sort and list the users in sorted order by LastOn date
Type
  UserCallRecord = Record
    Index   : Integer
    ListIdx : Integer
    LastOn  : LongInt
End
Var
  Count      : Integer=1
  UserCall   : Array[1..1500] Of UserCallRecord
  x,y,z,temp : Integer
Begin
  While GetUser(Count) Do
  Begin
    UserCall[Count].Index:=Count
    UserCall[Count].LastOn:=UserLastOn
    Count:=Count+1
  End
  z:=Count
  temp:=Count+1
  For x:=1 to Count Do
    For y:=1 to Count Do
      If UserCall[x].LastOn > UserCall[y].LastOn Then
      Begin
        UserCall[temp]:=UserCall[x]
        UserCall[x]:=UserCall[y]
        UserCall[y]:=UserCall[temp]
      End
  UserCall[temp].Index:=0
  Count:=1
  While Count<MaxUser+1 Do
  Begin
    UserCall[Count].ListIdx:=Count
    Count:=Count+1
  End
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(UserCall[Count].Index) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=UserCall[Count].Index
      End
      Else WriteLn(XS+LB+useralias+'|$X25 '+Int2Str(UserSec)+'|$X33 '+Int2Str(userCalls)+'|$X40 '+Int2Str(userPosts)+'|$X47 '+Int2Str(UserUL)+'|$X54 '+Int2Str(UserDL)+'|$X60 '+datestr(DateU2D(userFirstOn),1)+'|$X70 '+C1+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure ListUsersFirstOn //This function will sort and list the users in sorted order by FirstOn date
Type
  UserCallRecord = Record
    Index   : Integer
    ListIdx : Integer
    FirstOn : LongInt
End
Var
  Count      : Integer=1
  UserCall   : Array[1..1500] Of UserCallRecord
  x,y,z,temp : Integer
Begin
  While GetUser(Count) Do
  Begin
    UserCall[Count].Index:=Count
    UserCall[Count].FirstOn:=UserFirstOn
    Count:=Count+1
  End
  z:=Count
  temp:=Count+1
  For x:=1 to Count Do
    For y:=1 to Count Do
      If UserCall[x].FirstOn > UserCall[y].FirstOn Then
      Begin
        UserCall[temp]:=UserCall[x]
        UserCall[x]:=UserCall[y]
        UserCall[y]:=UserCall[temp]
      End
  UserCall[temp].Index:=0
  Count:=1
  While Count<MaxUser+1 Do
  Begin
    UserCall[Count].ListIdx:=Count
    Count:=Count+1
  End
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(UserCall[Count].Index) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=UserCall[Count].Index
      End
      Else WriteLn(XS+LB+useralias+'|$X25 '+Int2Str(UserSec)+'|$X33 '+Int2Str(userCalls)+'|$X40 '+Int2Str(userPosts)+'|$X47 '+Int2Str(UserUL)+'|$X54 '+Int2Str(UserDL)+'|$X60 '+C1+datestr(DateU2D(userFirstOn),1)+LB+'|$X70 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure ListUsersSecLev //This function will sort and list the users in sorted order by Security Level
Type
  UserCallRecord = Record
    Index   : Integer
    ListIdx : Integer
    SecLev  : Byte
End
Var
  Count      : Integer=1
  UserCall   : Array[1..1500] Of UserCallRecord
  x,y,z,temp : Integer
Begin
  While GetUser(Count) Do
  Begin
    UserCall[Count].Index:=Count
    UserCall[Count].SecLev:=UserSec
    Count:=Count+1
  End
  z:=Count
  temp:=Count+1
  For x:=1 to Count Do
    For y:=1 to Count Do
      If UserCall[x].SecLev > UserCall[y].SecLev Then
      Begin
        UserCall[temp]:=UserCall[x]
        UserCall[x]:=UserCall[y]
        UserCall[y]:=UserCall[temp]
      End
  UserCall[temp].Index:=0
  Count:=1
  While Count<MaxUser+1 Do
  Begin
    UserCall[Count].ListIdx:=Count
    Count:=Count+1
  End
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(UserCall[Count].Index) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=UserCall[Count].Index
      End
      Else WriteLn(XS+LB+useralias+'|$X25 '+C1+Int2Str(UserSec)+LB+'|$X33 '+Int2Str(userCalls)+'|$X40 '+Int2Str(userPosts)+'|$X47 '+Int2Str(UserUL)+'|$X54 '+Int2Str(UserDL)+'|$X60 '+datestr(DateU2D(userFirstOn),1)+'|$X70 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure ListUsersPosts //This function will sort and list the users in sorted order by Posts
Type
  UserCallRecord = Record
    Index   : Integer
    ListIdx : Integer
    Posts   : Integer
End
Var
  Count      : Integer=1
  UserCall   : Array[1..1500] Of UserCallRecord
  x,y,z,temp : Integer
Begin
  While GetUser(Count) Do
  Begin
    UserCall[Count].Index:=Count
    UserCall[Count].Posts:=UserPosts
    Count:=Count+1
  End
  z:=Count
  temp:=Count+1
  For x:=1 to Count Do
    For y:=1 to Count Do
      If UserCall[x].Posts > UserCall[y].Posts Then
      Begin
        UserCall[temp]:=UserCall[x]
        UserCall[x]:=UserCall[y]
        UserCall[y]:=UserCall[temp]
      End
  UserCall[temp].Index:=0
  Count:=1
  While Count<MaxUser+1 Do
  Begin
    UserCall[Count].ListIdx:=Count
    Count:=Count+1
  End
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(UserCall[Count].Index) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=UserCall[Count].Index
      End
      Else WriteLn(XS+LB+useralias+'|$X25 '+Int2Str(UserSec)+'|$X33 '+Int2Str(userCalls)+'|$X40 '+C1+Int2Str(userPosts)+LB+'|$X47 '+Int2Str(UserUL)+'|$X54 '+Int2Str(UserDL)+'|$X60 '+datestr(DateU2D(userFirstOn),1)+'|$X70 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure ListUsersULs //This function will sort and list the users in sorted order by Uploads
Type
  UserCallRecord = Record
    Index   : Integer
    ListIdx : Integer
    ULs     : Integer
End
Var
  Count      : Integer=1
  UserCall   : Array[1..1500] Of UserCallRecord
  x,y,z,temp : Integer
Begin
  While GetUser(Count) Do
  Begin
    UserCall[Count].Index:=Count
    UserCall[Count].ULs:=UserUL
    Count:=Count+1
  End
  z:=Count
  temp:=Count+1
  For x:=1 to Count Do
    For y:=1 to Count Do
      If UserCall[x].ULs > UserCall[y].ULs Then
      Begin
        UserCall[temp]:=UserCall[x]
        UserCall[x]:=UserCall[y]
        UserCall[y]:=UserCall[temp]
      End
  UserCall[temp].Index:=0
  Count:=1
  While Count<MaxUser+1 Do
  Begin
    UserCall[Count].ListIdx:=Count
    Count:=Count+1
  End
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(UserCall[Count].Index) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=UserCall[Count].Index
      End
      Else WriteLn(XS+LB+useralias+'|$X25 '+Int2Str(UserSec)+'|$X33 '+Int2Str(userCalls)+'|$X40 '+Int2Str(userPosts)+'|$X47 '+C1+Int2Str(UserUL)+LB+'|$X54 '+Int2Str(UserDL)+'|$X60 '+datestr(DateU2D(userFirstOn),1)+'|$X70 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure ListUsersDLs //This function will sort and list the users in sorted order by Downloads
Type
  UserCallRecord = Record
    Index   : Integer
    ListIdx : Integer
    DLs     : Integer
End
Var
  Count      : Integer=1
  UserCall   : Array[1..1500] Of UserCallRecord
  x,y,z,temp : Integer
Begin
  While GetUser(Count) Do
  Begin
    UserCall[Count].Index:=Count
    UserCall[Count].DLs:=UserDL
    Count:=Count+1
  End
  z:=Count
  temp:=Count+1
  For x:=1 to Count Do
    For y:=1 to Count Do
      If UserCall[x].DLs > UserCall[y].DLs Then
      Begin
        UserCall[temp]:=UserCall[x]
        UserCall[x]:=UserCall[y]
        UserCall[y]:=UserCall[temp]
      End
  UserCall[temp].Index:=0
  Count:=1
  While Count<MaxUser+1 Do
  Begin
    UserCall[Count].ListIdx:=Count
    Count:=Count+1
  End
  gotoxy(sx,sy)
  LineCount:=1
  Count:=UserCount
  While GetUser(UserCall[Count].Index) And LineCount<=MaxLines Do        
  Begin
    If LineCount<=MaxLines Then
    begin
      If Count=Idx Then
      Begin
        Writeln(XS+HB+useralias+'|$X25 |15'+Int2Str(UserSec)+'|$X33 |15'+Int2Str(userCalls)+'|$X40 |15'+Int2Str(userPosts)+'|$X47 |15'+Int2Str(UserUL)+'|$X54 |15'+Int2Str(UserDL)+'|$X60 |15'+datestr(DateU2D(userFirstOn),1)+'|$X70 |15'+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')  //User to display with lightbar
        UserIdx:=UserCall[Count].Index
      End
      Else WriteLn(XS+LB+useralias+'|$X25 '+Int2Str(UserSec)+'|$X33 '+Int2Str(userCalls)+'|$X40 '+Int2Str(userPosts)+'|$X47 '+Int2Str(UserUL)+'|$X54 '+C1+Int2Str(UserDL)+LB+'|$X60 '+datestr(DateU2D(userFirstOn),1)+'|$X70 '+datestr(DateU2D(userlaston),1)+'[0;0 D|16|07')
      Count:=Count+1
      LineCount:=LineCount+1
    end 
    Else LineCount:=1
  End
End

Procedure Menu
Var
  Ch1      : Char=''
  Ch2      : Char
  Done     : Boolean=False
  Top      : Boolean=False
  Bottom   : Boolean=False
  MoreInfo : Byte=1
  MaxScreen: Byte=8
Begin
  clear
  Repeat  //Keep it looping within this repeat loop
    Case MoreInfo Of
      1 : ListUsers
      2 : ListUsersSecLev
      3 : ListUsersCalls
      4 : ListUsersPosts
      5 : ListUsersULs
      6 : ListUsersDLs
      7 : ListUsersFirstOn
      8 : ListUsersLastOn
    Else ListUsers
    End
    If Top Or Bottom Then //Checks to see if we are at the top of bottom of the list
    Begin
      gotoxy(mx,my)
      Write(StrRep(' ',cl))
      gotoxy(mx,my) 
      If Top Then Write('[1;30mÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[0m [1mYou''re at the beginning of the list[0m [1;30mÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ[0m')
      Else If Bottom Then Write('[0m[1;30mÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[0m [1mYou''re at the end of the list [30mÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ[0m')
      Delay(1000)
      gotoxy(mx,my)
      Write(StrRep(' ',cl))
      gotoxy(sx,sy)
      Top:=False
      Bottom:=False
    End
    Repeat
      gotoxy(mx,my)
      Write('[0m[1;30mÀÄÄÄÄÄÄÄÄÄÄÄÄ[37m[30m Arrow[0m [1;30mto[0m [1;30mScroll[0m [1m [30mto Sort  [37mENTER  [30mor[0m [1mE[30mmail  [37mQ[30muitÄÄÄÄÄÄÄÄÄÄÄÄÄÙ[0m')
      Ch1:=Upper(ReadKey)
    Until Ch1='E' Or Ch1='Q' Or Ch1=#27 Or Ch1=#13 Or IsArrow
    If IsArrow Then
    Begin
      Case Ch1 Of
        #72 : Begin  //Up Arrow
                If Idx>1 Then Idx:=Idx-1
                If Idx<UserCount Then UserCount:=UserCount-1
                If Idx=1 Then Top:=True
              end 
        #80 : Begin  //Down Arrow
                If Idx<MaxUser Then Idx:=Idx+1
                If Idx>=MaxLines+UserCount And Idx<MaxUser And UserCount<MaxUser Then
                  UserCount:=UserCount+1
                If Idx>=MaxUser Then Bottom:=True
                If Idx>=MaxUser Then Idx:=MaxUser-1
              end
        #73 : Begin  //Page Up
                If UserCount>MaxLines And Idx=UserCount Then UserCount:=UserCount-MaxLines
                Else If UserCount>MaxLines And Idx>UserCount Then Idx:=UserCount
                If Idx>MaxLines Then Idx:=UserCount
                Else Idx:=1
                If Idx=1 Then UserCount:=1
                If UserCount=1 And Idx=1 Then Top:=True
              End
        #81 : Begin  //Page Down
                If UserCount+MaxLines-1>Idx Then Idx:=UserCount+MaxLines-1
                Else 
                Begin
                  Idx:=Idx+MaxLines
                  UserCount:=UserCount+MaxLines
                End
                If UserCount>=MaxUser-MaxLines Then 
                Begin
                  Bottom:=True
                  UserCount:=MaxUser-MaxLines
                  Idx:=MaxUser-1
                End
                If Idx>=MaxUser Then Idx:=MaxUser-1
              End
        #09,#77 : Begin  //Right Arrow
                header2
                MoreInfo:=MoreInfo+1
                If MoreInfo>MaxScreen Then MoreInfo:=MaxScreen
              End
        #75 : Begin  //Left Arrow
                MoreInfo:=MoreInfo-1
                if MoreInfo=1 then header
                If MoreInfo>1 then header2                
                If MoreInfo<1 Then MoreInfo:=1
             End
      End
    End
  Else
    Begin
      Case Upper(Ch1) Of  
        #27,'Q' : Begin
                    Write('|[1')
                    Done:=True
                  End
        #13,'E' : Begin  //Email user
                    write('|CL')
                    write('[0;0 D');
                    write('|[1')
                    GetUser(UserIdx)
                    MenuCmd ('MW','/to:'+Replace(UserAlias,' ','_')) //Needs to replace any space with the underscore
                    header
                    write('|[0')
                  end
      End
    End
  PurgeInput //Clear keyboard buffer for next repeat
  Until Done
end

Procedure FindMaxUsers  //Find max number of users
Begin
  MaxUser:=1
  While GetUser(MaxUser) Do MaxUser:=MaxUser+1
End

Begin
  clrscr
  FindMaxUsers
  header
  Menu
  write('[0;0 D|[1');
  clrScr
  halt
End.
