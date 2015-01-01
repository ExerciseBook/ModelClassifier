uses crt,dos;
Var re,model,acter,floor:text;
    s,str,code:ansistring;
    gs,fl:boolean;
    rk:char;
    i,modelu,acteri,floori:longint;
    t:text;
    lang:string;
    cf:boolean;
{****************************}
function MessageBox(hWnd:LONGINT;lpText:string;lpCaption:string;uType:DWORD):LONGINT;
  stdcall; external 'user32.dll' name 'MessageBoxA';
{****************************}
Function readstr(lang,strname:string):ansistring;
Var s,out:ansistring;
    t:text;
Begin
        assign(t,'language\'+lang+'.ini');
        reset(t);
        s:='';
        while (pos(strname,s)<>1) and (eof(t)=false) do begin
                readln(t,s);
        end;
        delete(s,1,length(strname)+1);
        if s='{' then begin
                while s<>'}' do begin
                        readln(t,s);
                        out:=out+char(10)+char(13)+s;
                end;
                s:=out;
                delete(s,length(s)-2,3);
        end;
        close(t);
        exit(s);
End;
{****************************}
function checkfile(st:string):boolean; //检查设置文件是否存在
begin
	Assign(t,st);
	{$I-}
	Reset(t);
	{$I+}
	if IOResult=0 then checkfile:=true
	else checkfile:=false;
end;
{****************************}
Begin
        exec('cmd','/k mode con cols=80 lines=25 & exit');
         str:=ParamStr(1);
        code:=paramstr(2);
        {str:='assets_manifest.txt';
        code:='101';}


	cf:=checkfile('setting.ini');
	if cf=false then begin
		assign(t,'setting.ini');rewrite(t);
		writeln(t,'zh_cn');
		writeln(t,'2');
		writeln(t,'zh_cn');
		writeln(t,'zh_tw');
		close(t);
	end;
	if cf=true then close(t);
	assign(t,'setting.ini');reset(t);
	readln(t,lang);
	close(t);


        fl:=true;
        {----------------}
		//if length(code)<>3 then gs:=false;
                if (length(code)=3) and
		   ((code[1]='1') or (code[1]='0')) and
	 	   ((code[2]='1') or (code[2]='0')) and
	  	   ((code[3]='1') or (code[3]='0')) then gs:=true;
                if (pos('assets_manifest.txt',str)=0) and (str<>'') then fl:=false;
                if (str='') and (code='') then gs:=true;
        {----------------}
        if (str='/?') or (gs=false) or (fl=false)then begin

                if (not fl) and (str<>'/?') then writeln(readstr(lang,'File_name_err'));
                if (not gs) and (str<>'/?') then writeln(readstr(lang,'Command_Err'));

                writeln;
		writeln(readstr(lang,'help'));
		readln;
		halt;
	end;
{*****************************************************************************************}
        if (str='') and (code='') then begin
		code:='000';
                writeln(readstr(lang,'Com_RK_Title'));
		writeln('');
		write(readstr(lang,'Com_RK_File'),':');
		repeat
                	readln(str);
			if (pos('assets_manifest.txt',str)=0) or (str='') then begin
				gotoxy(1,1);
				clrscr;

				writeln(readstr(lang,'Com_RK_Title'));
                                writeln();
				write(readstr(lang,'Com_RK_File'),readstr(lang,'Com_RK_File_Re'),':');
                        end;
		until pos('assets_manifest.txt',str)>0;
                writeln('');
                {*************************************************************************}
                writeln(readstr(lang,'Com_Rk_Model'));
		rk:=readkey;
                if not (rk in ['y' , 'n' , 'Y' , 'N']) then
                repeat
                        rk:=readkey;
                until rk in ['y' , 'n' , 'Y' , 'N'];
                if rk in ['y' , 'Y'] then code[1]:='1' else code[1]:='0';
		rk:='A';
                {*************************************************************************}
                writeln(readstr(lang,'Com_Rk_Actor'));
		rk:=readkey;
                if not (rk in ['y' , 'n' , 'Y' , 'N']) then
                repeat
                        rk:=readkey;
                until rk in ['y' , 'n' , 'Y' , 'N'];
                if rk in ['y' , 'Y'] then code[2]:='1' else code[2]:='0';
		{*************************************************************************}
		writeln(readstr(lang,'Com_Rk_Floor'));
		rk:=readkey;
                if not (rk in ['y' , 'n' , 'Y' , 'N']) then
                repeat
                        rk:=readkey;
                until rk in ['y' , 'n' , 'Y' , 'N'];
                if rk in ['y' , 'Y'] then code[3]:='1' else code[3]:='0';
        end;
{*****************************************************************************************}
        assign(re,str);reset(re);
        if code[1]='1' then begin assign(model,'assets_manifest.model.txt');rewrite(model); end;
        if code[2]='1' then begin assign(acter,'assets_manifest.acter.txt');rewrite(acter); end;
        if code[3]='1' then begin assign(floor,'assets_manifest.floor.txt');rewrite(floor); end;
        repeat
{*****************************************************************************************}
		readln(re,s);
                lowercase(s);
                if pos('.x',s)>0 then begin
                        delete(s,pos('.x',s)+2,length(s));
                        if (pos('model',s)=1) and (code[1]='1') then writeln(model,'/create ',s);
                        if ((pos('character',s))=1) and(code[2]='1') then writeln(acter,'/create ',s);
                end;
{*****************************************************************************************}
                if (pos('.dds',s)>0) and (pos('texture/tileset',s)=1) and (code[3]='1') then begin
                        delete(s,pos('.dds',s)+4,length(s));
                        writeln(floor,s);
                end;
{*****************************************************************************************}
        until eof(re);

        close(re);
        if code[1]='1' then close(model);
        if code[2]='1' then close(acter);
        if code[3]='1' then close(floor);
        MessageBox(0,readstr(lang,'Info_Con'),readstr(lang,'Info_Title'),64);
End.
