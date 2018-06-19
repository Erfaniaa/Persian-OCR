unit Unit1;         {end 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, Math, ExtDlgs, Spin, ComCtrls;

type
  TForm1 = class(TForm)
    Image: TImage;
    Shape: TShape;
    btnClear: TButton;
    imgSmall: TImage;
    btnNormalize: TButton;
    imgSmall2: TImage;
    imgBlurred: TImage;
    btnSaveChar: TButton;
    imgSmall3: TImage;
    imgCut: TImage;
    opennvazn: TButton;
    edtChar: TEdit;
    ProgressBar1: TProgressBar;
    lblRecognized: TLabel;
    lblRecognized2: TLabel;
    Button1: TButton;
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnClearClick(Sender: TObject);
    procedure btnNormalizeClick(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnNormalize2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadWClick(Sender: TObject);
    procedure btnSaveCharClick(Sender: TObject);
    procedure edtCharChange(Sender: TObject);
    procedure btnRecognizeClick(Sender: TObject);
    procedure opennvaznClick(Sender: TObject);
    procedure rahnamayiClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  type

    neuron = OBJECT
      w, X: array [1 .. 320] of extended;
      z, s, a, output: extended;
      endofarray: Integer;
      procedure update;                                   {260 nemone 174noron}
      procedure train;
    END;

  type
    network = OBJECT
      hiden: array [1 .. 320] of neuron;
      o: neuron;
      input: array [1 .. 260] of extended;
      procedure update;
      procedure train(delkhah,alpha: extended);
    END;

    { Private declarations }
  public
    { Public declarations }

    networks: array [1 .. 16 { tedahorof } ] of network;
    networks2: array [1 .. 16 { tedahorof } ] of network;
  end;
  TBytesArray = array of Byte;
  TPixelArray = array [0..49, 0..61] of Boolean;
  TBinaryArray = array [0..49, 0..61] of ShortInt;
  TSegment = array [1..240, 1..300] of ShortInt;
  TCrosses = array [1..8] of Word;
  T2Int = array [1..2] of Integer;
  TMatrix = array [-180..+180, -180..+180] of SmallInt;
  TRGB = array [1..3] of Int64;
  TRGBArray = array [0..500, 0..350] of TRGB;
  TNoghteha = array [1..2] of TpixelArray;
  THistograms = array [1..2, 1..15] of ShortInt;
  THistogramelyar = array [1..35] of shortInt;
const
  Size = 3;
  Size2 = 3;
  Radius = 5;
  Radius2 = 2;
  tedadhorof = 16;
  hiddennorons = 250;
  hiddennorons2 = 70;
  tedadnemone = 25;
  tedadvorodi=225;
  tedadvorodi2=51;
  tedadtrain=106;
  Adres='..\Ocrtest\';
  //adress='D:\Copy (2) of aghaye sabbaghi\Ocrtest\';
var
  Form1: TForm1;
  Moves, I, MaxX, MaxY: Word;
  Bytes: TBytesArray;
  nBytes: Integer;
  //Pixels, Pixels2: TPixelArray;
  Pixels, Pixels2, BinPixels, PartDots, PartChar: TBinaryArray;
  Last: TPoint;
  Count: Real;
  Pnt: array [1..1000] of TPoint;
  Matrix: TMatrix;
  Sum: Int64;
  Pix: TRGBArray;
  Noghteha: TNoghteha;
  Histograms: THistograms;
  Closed, Lines_1, Lines_2, Dense, Po, PoP,popo: Integer;
  C: TCrosses;

implementation

{$R *.dfm}
function azta(s:string;a:integer;b:integer):integer;
 var
  t:string;
begin
  t:='';
  for a:=a to b  do
    t:=t+s[a];
  Result:=StrToint(t);
end;
procedure ShowPixels(BinPixels: TBinaryArray; var Image: TImage); overload;
var
  X, Y: ShortInt;
begin
  for X := 1 to Image.Width do
    for Y := 1 to Image.Height do
      if BinPixels[X, Y] = 1 then
        Image.Canvas.Pixels[X - 1, Y - 1] := clBlack
      else
        Image.Canvas.Pixels[X - 1, Y - 1] := clWhite;
end;

procedure ShowPixels(BinPixels: TBinaryArray; var StringGrid: TStringGrid); overload;
var
  X, Y: ShortInt;
begin
  for X := 1 to StringGrid.ColCount - 1 do
    for Y := 1 to StringGrid.RowCount - 1 do
      if BinPixels[X, Y] = 1 then
        StringGrid.Cells[X, Y] := '1'
      else
        StringGrid.Cells[X, Y] := '0';
end;

procedure savevazn;
var
  h,h2,h3:integer;
  f:TextFile;
begin
  AssignFile(f,adres+'shabake.txt');
  Rewrite(f);
  for h := 1 to  tedadhorof  do
  begin
    for h2 := 1 to hiddennorons  do
      begin
        for h3 := 1 to tedadvorodi  do
        writeln(f,form1.networks[h].hiden[h2].w[h3]);

      end;
  end;
  for h := 1 to tedadhorof  do
  begin
    for h2 := 1 to hiddennorons  do
      Writeln(f,form1.networks[h].o.w[h2]);
  end;
  for h := 1 to  tedadhorof  do
  begin
    for h2 := 1 to hiddennorons2  do
      begin
        for h3 := 1 to tedadvorodi2  do
        writeln(f,form1.networks2[h].hiden[h2].w[h3]);

      end;
  end;
  for h := 1 to tedadhorof  do
  begin
    for h2 := 1 to hiddennorons2  do
      Writeln(f,form1.networks2[h].o.w[h2]);
  end;
  CloseFile(F);
end;
procedure openvazn;
var
  h,h2,h3:integer;
  f:TextFile;
  s:string;
begin
  AssignFile(f,adres+'shabake.txt');
  Reset(f);
  for h := 1 to  tedadhorof  do
  begin
    for h2 := 1 to hiddennorons  do
      begin
        for h3 := 1 to tedadvorodi  do
        begin
        read(f,form1.networks[h].hiden[h2].w[h3]);
        end;
      end;
  end;
  for h := 1 to tedadhorof  do
  begin
    for h2 := 1 to hiddennorons  do
    begin
      read(f,form1.networks[h].o.w[h2]);
    end;
  end;
  for h := 1 to  tedadhorof  do
  begin
    for h2 := 1 to hiddennorons2  do
      begin
        for h3 := 1 to tedadvorodi2  do
        begin
        read(f,form1.networks2[h].hiden[h2].w[h3]);
        end;
      end;
  end;
  for h := 1 to tedadhorof  do
  begin
    for h2 := 1 to hiddennorons2  do
    begin
      read(f,form1.networks2[h].o.w[h2]);
    end;
  end;
  CloseFile(F);
end;

procedure endofarraysetig;
var
  horof: Integer;
  noron,x: Integer;
begin
  for horof := 1 to tedadhorof do
  begin
    for noron := 1 to hiddennorons  do
    Form1.networks[horof].hiden[noron].endofarray:=tedadvorodi;
  end;
  for horof := 1 to tedadhorof  do
    form1.networks[horof].o.endofarray:=hiddennorons;
  for horof := 1 to tedadhorof do
  begin
    for noron := 1 to hiddennorons2  do
    Form1.networks2[horof].hiden[noron].endofarray:=tedadvorodi2;
  end;
  for horof := 1 to tedadhorof  do
    form1.networks2[horof].o.endofarray:=hiddennorons2;

  {for horof := 1 to tedadhorof  do
  begin
    for noron := 1 to hiddennorons  do
      begin
        for x := 1 to 5 do
        form1.networks[horof].hiden[noron].no:=1;
        for x := 6 to 35 do
        form1.networks[horof].hiden[noron].no:=2;



      end;
    form1.networks[horof].o.no:=3;

  end;}
end;

procedure randomi;
var
  h: Integer;
  no: Integer;
  ww: Integer;
begin
  for h := 1 to tedadhorof do
  BEGIN
    for no := 1 to hiddennorons do
    begin
      for ww := 1 to tedadvorodi do
      begin
        { .hiden[no].w[ww]:=random(20); }
        Form1.networks[h].hiden[no].w[ww] := (random(101)-50) /50;
      {  if Form1.networks[h].hiden[no].w[ww]=0 then
        Form1.networks[h].hiden[no].w[ww]:=2.5;   }
      end;
    end;
  END;
  for h := 1 to tedadhorof do
  begin
    for no := 1 to hiddennorons do
    begin
      Form1.networks[h].o.w[no] := (random(101)-50) /50;
    {  if Form1.networks[h].o.w[no] =0 then
      Form1.networks[h].o.w[no] := 1.78;     }
    end;
  end;
  for h := 1 to tedadhorof do
  BEGIN
    for no := 1 to hiddennorons2 do
    begin
      for ww := 1 to tedadvorodi2 do
      begin
        { .hiden[no].w[ww]:=random(20); }
        Form1.networks2[h].hiden[no].w[ww] := (random(101)-50) /50;
      {  if Form1.networks[h].hiden[no].w[ww]=0 then
        Form1.networks[h].hiden[no].w[ww]:=2.5;   }
      end;
    end;
  END;
  for h := 1 to tedadhorof do
  begin
    for no := 1 to hiddennorons2 do
    begin
      Form1.networks2[h].o.w[no] := (random(101)-50) /50;
    {  if Form1.networks[h].o.w[no] =0 then
      Form1.networks[h].o.w[no] := 1.78;     }
    end;
  end;

end;

function ff(z: extended): extended;
var
  t:extended;
begin
  t:=exp(-z);
  Result := 1 / (1 + exp(-z));
end;

function ffpirim(z: extended): extended;
begin
  Result := ff(z) * (1 - ff(z));
end;

procedure TForm1.neuron.update;
var
  h: Integer;
  Y: extended;
begin
  z := 0;
  Y := z;
  for h := 1 to endofarray do
  begin
    {if (x[h]=0) and (((endofarray=230)and (h>5))or (endofarray=151)) then
    x[h]:=-1;     }
    z := z + X[h] * w[h];
  end;
  output := ff(z);
end;

procedure TForm1.neuron.train;
var
  h: Integer;
begin
  for h := 1 to endofarray do
    w[h] := w[h] + ffpirim(z) * X[h] * s * a;
end;

procedure TForm1.network.update;
var
  Y, X: Integer;
  h: Integer;
begin


for Y := 1 to hiden[1].endofarray do
  begin
    for h := 1 to o.endofarray { tedadhidennoron } do
      hiden[h].X[y] := input[{X}y];
  end;

  for h := 1 to o.endofarray{ tedadhidennoron } do
    hiden[h].update;
   //o.endofarray := hiden[1].endofarray;
   for h := 1 to o.endofarray { hiddennoron } do
  begin
    o.X[h] := hiden[h].output;
  end;
  //o.endofarray := hiddennorons; { hidennoron }
  o.update;
end;

procedure TForm1.network.train(delkhah,alpha: extended);
var
  h: Integer;
  s, t, Y: extended;
begin

  o.a := alpha;
  s := delkhah - o.output;
  o.s := s;

  for h := 1 to  o.endofarray { hidennoron } do
  begin
    hiden[h].s := o.s * o.w[h];
    hiden[h].a := alpha;
    hiden[h].train;
  end;
  o.train;

end;

procedure train;
var
  s: string;
  h3,h, harf, X, Y, numbernemone, numbernemone2, harf56,h6: Integer;
  f: textfile;
  trainarray: array[1..tedadhorof,1..tedadnemone,1..tedadvorodi+tedadvorodi2]of real;
  networksanswer:array[1..tedadhorof,1..tedadnemone,1..tedadhorof]of extended;
  harf2,maxn: Integer;
  delkhah,max: extended;
  nemone: Integer;
  hhh: Integer;
  nemone2: Integer;
  h2,h4,h5: Integer;
  al:real;
begin
  endofarraysetig;
  randomi;
  s := '';
  for harf := 1 to tedadhorof do
  begin
    s := adres + inttostr(harf) + '.txt';
    AssignFile(f, s);
    Append(f);
    reset(f);
    numbernemone := 1;
    for h := 1 to tedadnemone  do
    begin
      readln(f,s);
      readln(f,s);
      trainarray[harf,h,1]:=strtoint(s);{taghato}

      readln(f,s);
      readln(f,s);
      trainarray[harf,h,2]:=strtoint(s){baste};

      readln(f,s);
      readln(f,s);
      trainarray[harf,h,3]:=strtoint(s){khat1};


      readln(f,s);
      trainarray[harf,h,4]:=strtoint(s){khat2};

      readln(f,s);
      readln(f,s);
      trainarray[harf,h,5]:=strtoint(s){tarakon};
      readln(f,s);
      readln(f,s);
      h3:=1;
      h5:=1;
      for h2 := 1 to length(s)  do
      begin
      if s[h2]=' ' then
      begin
        trainarray[harf,h,h5+5]:=azta(s,h3,h2-1);
        h3:=h2+1;
        h5:=h5+1;
      end;

      end;
      readln(f,s);
       h3:=1;
      h5:=1;
      for h2 := 1 to length(s)  do
      begin
      if s[h2]=' ' then
      begin
        trainarray[harf,h,h5+20]:=azta(s,h3,h2-1);
        h3:=h2+1;
        h5:=h5+1;
      end;

      end;
      readln(f,s);
      for h2 := 36 to 51 do
        trainarray[harf,h,h2]:=0;
       for h6 := 1 to 15  do
      begin
        readln(f,s);
        h3:=1;
        h5:=1;
        for h2 := 1 to length(s)  do
        begin
        if s[h2]=' ' then
        begin
          trainarray[harf,h,(h6-1)*15 + h5 +tedadvorodi2]:=azta(s,h3,h2-1);
          h3:=h2+1;
          h5:=h5+1;
        end;

      end;

      end;

      {if (harf=16) and (h=11) then
      closefile(f)
      else  }
      readln(f,s);
        //Form1.Caption:=s;
       // closefile(f);
    end;
    Y := 0;
    //if harf<>16 then
    CloseFile(f);
  end;
  al:=1.0;
    for hhh := 1 to tedadtrain do
    begin
      for harf56 := 1 to tedadhorof do
      begin
        for nemone2 := 1 to tedadnemone  do
        begin
          for harf2 := 1 to tedadhorof do
          begin
            for X := 52 to tedadvorodi+51 do
            begin

                Form1.networks[harf56].input[X-51] := trainarray[harf2,nemone2
                { numbernemone },x ];
            end;
            Form1.networks[harf56].update;
            if harf56 = harf2 then
              delkhah := 1
            else
              delkhah := 0;
            Form1.networks[harf56].train(delkhah, al);
          end;
        end;
      end;
    al:=al-(1 / tedadtrain);
  //Form1.Caption:=inttostr(hhh);
  end;
  for hhh := 1 to 1 do
  begin
      for harf56 := 1 to tedadhorof do
      begin
        for nemone2 := 1 to tedadnemone  do
        begin
          for harf2 := 1 to tedadhorof do
          begin
            for X := 52 to tedadvorodi+51 do
            begin

                Form1.networks[harf56].input[X-51] := trainarray[harf2,nemone2
                { numbernemone },x ];
            end;
            Form1.networks[harf56].update;
            networksanswer[harf56,nemone2,harf2]:=Form1.networks[harf56].o.output;
          end;
        end;
      end;
Form1.ProgressBar1.Position:=hhh;
  al:=al-0.01;
//  Form1.Caption:=inttostr(hhh);
  end;
  for harf56 := 1 to tedadhorof do
  begin
    for nemone2 := 1 to tedadnemone  do
    begin
    max:=-100;
      for harf2 := 1 to tedadhorof do
      begin
        if networksanswer[harf56,nemone2,harf2]>max then
        begin
          max:=networksanswer[harf56,nemone2,harf2];
          maxn:=harf2;
        end;
        networksanswer[harf56,nemone2,harf2]:=0;
      end;
      networksanswer[harf56,nemone2,maxn]:=1;
      trainarray[harf56,nemone2,maxn+35]:=1;  {this}
    end;
  end;
//  Form1.ProgressBar1.Max:=1{00};
  al:=1.0;
  for hhh := 1 to tedadtrain do
  begin
      for harf56 := 1 to tedadhorof do
      begin
        for nemone2 := 1 to tedadnemone  do
        begin
          for harf2 := 1 to tedadhorof do
          begin
            for X := 1 to 51 do
            begin

                Form1.networks2[harf56].input[X] := trainarray[harf2,nemone2
                { numbernemone },x ];
            end;
            Form1.networks2[harf56].update;
            if harf56 = harf2 then
              delkhah := 1
            else
              delkhah := 0;
            Form1.networks2[harf56].train(delkhah, al);
          end;
        end;
      end;
Form1.ProgressBar1.Position:=hhh;
  al:=al-(1/ tedadtrain);
  //Form1.Caption:=inttostr(hhh)+'dovom';
  end;
  savevazn;

end;
function anser(a:THistogramelyar;pixels3,pixels:TBinaryArray;dots:TBinaryArray;po,pop,popo:integer):string;
var
  horof: array [1 .. tedadhorof] of extended;
  h, h2: Integer;
  Y, X, maxn,m: Integer;
  max: extended;
  pixels2:TBinaryArray;
  endofendtedads:integer;
  f:file;
function chand(var a:TBinaryArray;xx,yy:integer):boolean;
var
  x,y,h:integer;
begin
            h:=0;
            for x := xx-1 to xx+1 do
            begin
              for y := yy-1 to yy+1  do
              begin
                if a[x,y]=1 then
                h:=h+1;

              end;
            end;
            if h>1 then
            Result:=TRUE
            else
            Result:=false;

end;

function enddots(var a:TBinaryArray;xx,yy:integer):boolean;
var
  x,y,h:integer;
  //aa:array[1..3,1..3]of integer;

begin
h:=0;
for x := xx-1 to xx+1  do
begin
  for y := yy-1 to yy+1  do
    begin
      if (a[x,y]=1) and ((x<>xx)or (y<>yy))then
      begin
        if chand(a,x,y) then
        h:=h+1
        else
        h:=h+0;
      end
      else
      h:=h+0;
    end;

end;
if h>1 then
Result:=true
else
Result:=false;

end;

{function chand2(a:TBinaryArray;x,y:integer):integer;
var
xx,yy,h:integer;
begin
    h:=0;
    for x := xx-1 to xx+1 do
    begin
      for y := yy-1 to yy+1  do
      begin
        if a[x,y]=1 then
        h:=h+1;

      end;
    end;
    if h>1 then
    Result:=TRUE
    else
    Result:=false;

end;   }
function iss(var a:TBinaryArray;x,y:integer):boolean;
var
  xx,yy,h:integer;
begin
Result:=true;
h:=0;
for xx := x-1 to x+1  do
  begin
    for yy := y-1 to y+1  do
      begin
        if a[xx,yy]=1 then
        begin
        h:=h+1;


        end;
      end;
  end;
  if h>1 then
  Result:=false;

end;
procedure boroto(var a:TBinaryArray;x,y:integer;var t:integer);
var
h,h2:integer;
begin

if a[x,y]=1 then
begin
  if iss(a,x,y) then
  t:=t+1;
end;
a[x,y]:=0;
if a[x+1,y]=1 then
boroto(a,x+1,y,t);
if a[x-1,y]=1 then
boroto(a,x-1,y,t);
if a[x,y+1]=1 then
boroto(a,x,y+1,t);
if a[x,y-1]=1 then
boroto(a,x,y-1,t);

end;
function tedadenddots(var a:TBinaryArray):ShortInt;
var
  x,y,h,h2,t,xxx,yyy:integer;
begin
h2:=0;
  for x := 1 to 36 do
  begin
  if h2=456 then
  break;
    for y := 1 to 45 do
    begin
      if a[x,y]=1 then
      begin
        if enddots(a,x,y) then
        begin
           h2:=456;

          xxx:=x;
          yyy:=y;
              break;
       end;
      end;

    end;

  end;
  t:=0;
  boroto(a,xxx,yyy,t);
   Result:=t;

end;
function ish:ShortInt;
var
  x,y,x2,y2,x3,y3,h,h2,max,min,maxn,minn:Integer;
begin
min:=999999;
max:=-999999;
minn:=min;
maxn:=max;
  for x := 1 to 36 do
  begin
    for y := 1 to 45  do
    begin
      if PartChar[x,y]=1 then
      begin
        if y>max then
        max:=y;
        if y<min then
        min:=y;
      end;
      if PartDots[x,y]=1 then
      begin
        if y>maxn then
        maxn:=y;
        if y<minn then
        minn:=y;
      end;
      end;
  end;
  if ((max>=maxn)and (min<=maxn) and (min<=minn) and (max>=minn)) and (maxn<>max) then
  begin
    Result:=1
  end else if (max<maxn)and (max<minn) then
  begin
   Result:=2
  end else
   Result:=3;
  //Form1.Caption := IntToStr(Result);
end;
function  bady:integer;
  var
    h,maxn:integer;
    max:Extended;
begin
max:=-999999999;
  for h := 1 to tedadhorof do
  begin
    if horof[h]>max then
    begin
      max:=horof[h];
      Result:=h;
    end;

  end;

end;
var
  C1, C2, C3: ShortInt;
begin
  endofarraysetig;
  max := -100;
  for h := 1 to 16 do
    horof[h] := 0;

  for h := 1 to tedadhorof do
  begin
    for X := 1 to 35{tedadvorodi}{tedad data} do
    begin
       { if a[x]=0 then
        a[x]:=-1;     }
        Form1.networks2[h].input[X] := a[X];
    end;
    for X := 36 to tedadvorodi2 do
    begin
       { if a[x]=0 then
        a[x]:=-1;     }
        Form1.networks2[h].input[X] := 0;
    end;
    for y := 1 to 15 do
    begin
      for x := 1 to 15  do
      Form1.networks[h].input[(y-1)*15 + x ]:=pixels3[x,y];
    end;

    Form1.networks[h].update;
{    for h2 := 1 to 5 { hiddennoron  do
    begin

      Form1.networks[h].o.X[h2] := Form1.networks[h].hiden[h2].output;
      Form1.networks[h].hiden[h2].update;
    end;
    Form1.networks[h].o.endofarray := 5; { hidennoron
    Form1.networks[h].o.a := 1;
    Form1.networks[h].o.update;}
  end;
  max:=-100;
  for h := 1 to tedadhorof do
  begin
    if form1.networks[h].o.output>max then
    begin
      max:=form1.networks[h].o.output;
      maxn:=h;
    end;
  end;
  for h := 1 to tedadhorof do
    form1.networks2[h].input[maxn+35]:=1;
  for h := 1 to tedadhorof  do
  begin
  form1.networks2[h].update;
  horof[h]:=Form1.networks2[h].o.output*2 + form1.networks[h].o.output * 1;
  end;
  {}{}{}{}{}{}{}
  pixels2:=pixels;
  endofendtedads :=(tedadenddots(pixels2));
  //form1.Caption:=inttostr(endofendtedads)+'ttt';
  while true do
  begin
    m:=bady;
    if horof[m]=-4545 then
    begin
    Result:='مشخّص نیست';
    break;
    end;
    horof[m]:=-4545;
    {if (m=1)and (po>1)and (a[2]=0)and (a[1]=0) then
    begin
    Result:='آ';
    break;
    end
    else }if (m=1)and (po=0)and (a[2]=0)and (a[1]=0) then
    begin
    Result:='ا';
    break;
    end
    else if (m=2)and (po=1)and (pop=2)and (a[2]=0) then
    begin
    Result:='ب';
    break;
    end
    else if (m=2)and (po>=3)and (pop=2)and (a[2]=0) then
    begin
    Result:='پ';
    break;
    end
    else if (m=2)and (po=2)and (pop=1)and (a[2]=0) then
    begin
    Result:='ت';
    break;
    end
    else if (m=2)and (po>=3)and (pop=1)and (a[2]=0) then
    begin
    Result:='ث';
    break;
    end
    else if (m=3)and (po=1){and (pop=1) and (popo=2)and (a[2]=0)}and (ish=1)then
    begin
    Result:='ج';
    break;
    end
    else if (m=3)and (po>=3){and (pop=1) }and (ish=1)then
    begin
    Result:='چ';
    break;
    end
    else if (m=3)and (po=0){and (pop=1) }and (Form1.networks2[3].o.Output>form1.networks2[9].o.output) then
    begin
    Result:='ح';
    break;
    end
    else if (m=3)and (po=1){and (pop=1) and (popo=2)} and (ish=3)and (Form1.networks2[3].o.Output>form1.networks2[9].o.output) then
    begin
    Result:='خ';
    break;
    end
    else if (m=4)and (po=0){and (pop=1) }and (a[2]=0){and (endofendtedads=2)}then
    begin
    Result:='د';
    break;
    end
    else if (m=4)and (po=1)and (pop=1)and (a[2]=0) then
    begin
    Result:='ذ';
    break;
    end
    else if (m=5)and (po=0){and (pop=1) }and (a[2]=0) and (a[1]=0)then
    begin
    Result:='ر';
    break;
    end
    else if (m=5)and (po=1)and (pop=1)and (a[2]=0) and (a[1]=0) then
    begin
    Result:='ز';
    break;
    end
    else if (m=5)and (po>=3)and (pop=1)and (a[2]=0) and (a[1]=0) then
    begin
    Result:='ژ';
    break;
    end
    else if (m=6)and (po=0){and (pop=1) }and (a[2]=0)and (endofendtedads>2)then
    begin
    Result:='س';
    break;
    end
    else if (m=6)and (po>=3)and (pop=1)and (a[2]=0) and (endofendtedads>2)then
    begin
    Result:='ش';
    break;
    end
    else if (m=7)and (po=0){and (pop=1) }and (a[2]>0)then
    begin
    Result:='ص';
    break;
    end
    else if (m=7)and (po=1)and (pop=1)and (a[2]>0) then
    begin
    Result:='ض';
    break;
    end
    else if (m=8)and (po=0){and (pop=1) }and (a[2]>0)then
    begin
    Result:='ط';
    break;
    end
    else if (m=8)and (po=1)and (pop=1)and (a[2]>0) then
    begin
    Result:='ظ';
    break;
    end
    else if (m=9)and (po=0){and (pop=1) }and (a[2]=0)and (endofendtedads>2)and (Form1.networks2[3].o.Output<form1.networks2[9].o.output)then
    begin
    Result:='ع';
    break;
    end
    else if (m=9)and (po=1)and (pop=1)and (a[2]=0)and (endofendtedads>2) {}and (ish=3){} and (Form1.networks2[3].o.Output<form1.networks2[9].o.output)then
    begin
    Result:='غ';
    break;
    end
    else if (m=10)and (po=1)and (pop=1)and (a[2]>0) then
    begin
    Result:='ف';
    break;
    end
    else if (m=10)and (po=2)and (pop=1) and (a[2]>0)then
    begin
    Result:='ق';
    break;
    end
    else if (m=11)and (po=0){and (pop=1)}and (a[2]=0) and (endofendtedads<3) then
    begin
    Result:='ک';
    break;
    end
    else if (m=11)and (po=2)and (pop=1)and (a[2]=0) then
    begin
    Result:='گ';
    break;
    end
    else if (m=12)and (po=0){and (pop=1) }and (a[2]=0)then
    begin
    Result:='ل';
    break;
    end
    else if (m=13)and (po=0){and (pop=1) }then
    begin
    Result:='م';
    break;
    end
      else if (m=2)and (po=1)and (pop=1)and (a[2]=0) then
    begin
    Result:='ن';
    break;
    end
    else if (m=14)and (po=0){and (pop=1) }and (a[2]>0)then
    begin
    Result:='و';
    break;
    end
    else if (m=15)and (po=0){and (pop=1) }and (a[2]>0)then
    begin
    Result:='ه';
    break;
    end
    else if (m=16)and (po=0){and (pop=1) }and (a[2]=0)and (endofendtedads<3)then
    begin
    Result:='ی';
    break;
    end;
  end;
  C1 := 0;
  C2 := 0;
  C3 := 0;
  for I := 1 to 15 do
  begin
    if Histograms[2, I] <= 2 then
      Inc(C1);
    if Histograms[2, I] >= 13 then
      Inc(C2);
    if Histograms[2, I] = 0 then
      Inc(C3);
  end;
  if {((C1 <= 7) and (C2 = 1) and (C3 > 3)) and}
    (((Result = 'ک') or (Result = 'گ')
      { or (Result = 'ث') } or (Result = 'ر') or (Result = 'د') or (Result = 'ل')) and (Form1.imgCut.Width / Form1.imgCut.Height <= 0.3)) then
    { if Po > 1 then
      Result := 'آ'
      else }
    Result := 'ا';

{  if maxn=1 then
  result:='آ';
  if maxn=2 then
  begin
    if noght then

  end;
            }

end;

function noghte(a: TBinaryArray): Integer;
  procedure vasl(var a: TPixelArray; X, Y, X2, Y2: Integer);
  begin
    while (X <> X2) or (Y <> Y2) do
    begin
      if (X2 > X) and (Y2 > Y) then
      begin
        a[X + 1, Y + 1] := True;
        X := X + 1;
        Y := Y + 1;
      end
      else if (X2 < X) and (Y2 < Y) then
      begin
        a[X - 1, Y - 1] := True;
        X := X - 1;
        Y := Y - 1;
      end
      else if (X2 < X) and (Y2 > Y) then
      begin
        a[X - 1, Y + 1] := True;
        X := X - 1;
        Y := Y + 1;
      end
      else if (X2 > X) and (Y2 < Y) then
      begin
        a[X + 1, Y - 1] := True;
        X := X + 1;
        Y := Y - 1;
      end
      else if (X2 = X) and (Y2 > Y) then
      begin
        a[X, Y + 1] := True;
        Y := Y + 1;
      end
      else if (X2 = X) and (Y2 < Y) then
      begin
        a[X, Y - 1] := True;
        Y := Y - 1;
      end
      else if (X2 > X) and (Y2 = Y) then
      begin
        a[X + 1, Y] := True;
        X := X + 1;
      end
      else if (X2 < X) and (Y2 = Y) then
      begin
        a[X - 1, Y] := True;
        X := X - 1;
      end;
    end;
  end;

  procedure noghtebaste(a: TPixelArray; var Baste, min: Integer);
  { araye ye a bayad in ghone bashad: aghar siyah:1 aghar khali:0 }
  { for noghte }
  var
    X, Y, G, ma, Color, maxcolor, endy, endx, max: Integer;
    function saveBBmasahat(X, Y: Integer; var tedadtekrar: Integer;
      Color: Integer): Integer;
    begin
      a[X, Y] := True;

      Inc(tedadtekrar);
      if (a[X + 1, Y] = false) and (X + 1 < endx + 1) and (X + 1 > -1) then
        saveBBmasahat(X + 1, Y, tedadtekrar, Color);
      if (a[X - 1, Y] = false) and (X - 1 > -1) and (X < endx + 1) then
        saveBBmasahat(X - 1, Y, tedadtekrar, Color);
      if (a[X, Y + 1] = false) and (Y + 1 < endy + 1) and (Y + 1 > -1) then
        saveBBmasahat(X, Y + 1, tedadtekrar, Color);
      if (a[X, Y - 1] = false) and (Y - 1 > -1) and (Y < endy + 1) then
        saveBBmasahat(X, Y - 1, tedadtekrar, Color);
    end;

  begin
    ma := -1;
    Color := 1;
    min := 0;
    endy := 31;
    endx := 25;
    max := -1;
    for X := 1 to endx do
    begin
      for Y := 1 to endy do
      begin
        if a[X, Y] = false then
        begin
          ma := ma + 1;
          G := 0;
          Color := Color + 1;
          saveBBmasahat(X, Y, G, Color);
          min := min + G;
          if G > max then
          begin
            max := G;
          end;

        end;
      end;
    end;
    min := min - max;
    Baste := ma;
  end;

  function vasl2(var a: TPixelArray; X, Y, X2, Y2: Integer):boolean;
  begin
  Result:=True;
    while (X <> X2) or (Y <> Y2) do
    begin
      if (X2 > X) and (Y2 > Y) then
      begin
        if a[x+1,y+1] then
        Result:=false;
        a[X + 1, Y + 1] := True;
        X := X + 1;
        Y := Y + 1;

      end
      else if (X2 < X) and (Y2 < Y) then
      begin
        if a[x-1,y-1] then
        Result:=false;

        a[X - 1, Y - 1] := True;
        X := X - 1;
        Y := Y - 1;
      end
      else if (X2 < X) and (Y2 > Y) then
      begin
      if a[x-1,y+1] then
        Result:=false;

        a[X - 1, Y + 1] := True;
        X := X - 1;
        Y := Y + 1;
      end
      else if (X2 > X) and (Y2 < Y) then
      begin
      if a[x+1,y-1] then
        Result:=false;

        a[X + 1, Y - 1] := True;
        X := X + 1;
        Y := Y - 1;
      end
      else if (X2 = X) and (Y2 > Y) then
      begin
      if a[x,y+1] then
        Result:=false;

        a[X, Y + 1] := True;
        Y := Y + 1;
      end
      else if (X2 = X) and (Y2 < Y) then
      begin
      if a[x,y-1] then
        Result:=false;

        a[X, Y - 1] := True;
        Y := Y - 1;
      end
      else if (X2 > X) and (Y2 = Y) then
      begin
      if a[x+1,y] then
        Result:=false;

        a[X + 1, Y] := True;
        X := X + 1;
      end
      else if (X2 < X) and (Y2 = Y) then
      begin
      if a[x-1,y] then
        Result:=false;

        a[X - 1, Y] := True;
        X := X - 1;
      end;
    end;
  end;
  procedure findendpixxel(a: TPixelArray; var X1, Y1, X2, Y2: Integer);
  function Dis(X, Y, X1, Y2: Integer): Real;
    begin
      Dis := Sqrt(Sqr(Abs(X1 - X2)) + Sqr(Abs(Y1 - Y2)));
    end;


  function tedad(X, Y: Integer): Boolean;
    var
      X2, Y2, ted: Integer;
    begin
      ted := 0;
      for X2 := X - 1 to X + 1 do
      begin
        for Y2 := Y - 1 to Y + 1 do
        begin
          if (a[X2, Y2] = True)  {and (y2>0) and (y2<31) and (x2>0) and (x2<25) }
          { and (x2>0) and (y2>0 ) and (x2<25) and (y2<31) } then
            ted := ted + 1;
        end;
      end;
      if (ted = 2) and (a[X, Y] = True) then
        tedad := True
      else
        tedad := false;
    end;
    function tedad2(X, Y: Integer): Boolean;
    var
      X2, Y2, ted: Integer;
    begin
      ted := 0;
      for X2 := X - 1 to X + 1 do
      begin
        for Y2 := Y - 1 to Y + 1 do
        begin
          if (a[X2, Y2] = True)  {and (y2>0) and (y2<31) and (x2>0) and (x2<25) }
          { and (x2>0) and (y2>0 ) and (x2<25) and (y2<31) } then
            ted := ted + 1;
        end;
      end;
      if (ted = 0) {and {(a[X, Y] = True)} then
        tedad2 := True
      else
        tedad2 := false;
    end;
    procedure boroto(x,y:integer);
    begin
      a[x,y]:=false;
      if tedad2(x,y) then
      begin
        if x1=-2 then
        begin
          x1:=x;
          y1:=y;
        end
        else
        begin
          x2:=x;
          y2:=y;
        end;
      end;
      if (a[x+1,y]) and (x+1<25) then
      boroto(x+1,y);
      if (a[x-1,y])and (x-1>0) then
      boroto(x-1,y);
      if (a[x,y+1]) and (y+1<31)then
      boroto(x,y+1);
      if (a[x,y-1])and (y-1>0) then
      boroto(x,y-1);
    end;
    procedure  miyanghin(var x3334,y3334:integer);
  var
    h,h2,xx,yy,x1,y1,x2,y2,xn,yn:integer;
    x,y,min:extended;
  begin
  x2:=-3333344;
  y2:=x2;
  x1:=999999;
  y1:=x1;
  for xx := 1 to 36 do
  begin
    for yy := 1 to 45  do
      begin
        if a[xx,yy] then
        begin
          if xx>x2 then
          x2:=xx;
          if xx<x1 then
          x1:=xx;
          if yy>y2 then
          y2:=yy;
          if yy<y1 then
          y1:=yy;

        end;
      end;
  end;
  x:=(x1+x2)/2;
  y:=(y1+y2)/2;
  min:=999999;
  for xx := 1 to 36 do
  begin
    for yy := 1 to 45  do
      begin
        if (a[xx,yy])and (dis(xx,yy,round(x),round(y))<min) then
        begin
        min:=dis(xx,yy,round(x),round(y));
        xn:=xx;
        yn:=yy;
        end;
      end;
  end;
  x:=xn;
  y:=yn;
 // boroto(xn,yn);
 x3334:=xn;
 y3334:=yn;
  end;

  var
    X, Y, h, h2, x3, y3,h4,xx,yy: Integer;
    max, f: Real;
   { x2: TObject;
    y2: TObject;    }
  procedure ttt;
    var
      x,y,h,h2,h3,x22,y22:longint;
      max:Extended;
      b:TPixelArray;
    begin
    max:=-324234;
      for x := 1 to 36  do
      begin
        for y := 1 to 45 do
        begin
          for x22 := 1 to 36 do
          begin
            for y22 := 1 to 45  do
            begin
              if (x<>x22) or (y22<>Y) {and (Dis(x,y,x22,y22)>max)}and (a[x,y])and (a[x22,y22]){AND (vasl2(a,x,y,x22,y22))} then
              begin
                b:=a;
                vasl(b,x,y,x22,y22);  noghtebaste(b,h2,h3);
              b:=a;
                vasl(b,x22,y22,x,y);  noghtebaste(b,h2,h4);
               if h4>h3 then
               h3:=+h4;

             if (h3>max) and (a[x,y]) and (a[x22,y22]) then
             begin
                max:=h3;
                x1:=x;
                y1:=y;
                x2:=x22;
                y2:=y22;
             end;
              end;
            end;
          end;



        end;
      end;
    end;
    procedure tt;
    var
      x111,y111,h,m,x,y,h2:longint;
      max:real;
      b,c:TPixelArray;
    begin
    max:=-11212122;
    for x := 1 to 36  do
      begin
        for y := 1 to 45 do
        begin
          if (a[x,y])and ((x<>x1)or (y<>y1)){and (dis(x,y,x1,y1)>max)and (vasl2(a,x,y,x1,y1))} then
          begin
            b:=a;
            vasl(b,x,y,x1,y1);
            noghtebaste(b,x111,h);
            b:=a;
            vasl(b,x1,y1,x,y);
            noghtebaste(b,x111,h2);
            if h2>h  then
            h:=h2;
            if h>max then
            begin
            max:=h;
            x2:=x;
            y2:=y;

            end;
          end;

        end;

      end;


    end;

  begin
    max := -100;
    X1 := -2;
    Y1 := -2;
    X2 := -2;
    Y2 := -2;
    miyanghin(xx,yy);
    boroto(xx,yy);
    {for X := 1 to 36 do
    begin
      for Y := 1 to 45 do
      begin
        if (a[X, Y] = True) and (tedad(X, Y) = True) then
        begin
          if X1 = -2 then
          begin
            X1 := X;
            Y1 := Y;
          end
          else
          begin
            X2 := X;
            Y2 := Y;
          end;
        end
        else if (a[X, Y] = True) and (X1 <> -2) and (X2 = -2) then
        begin
          f := Dis(X, Y, X1, Y1);
          if f > max then
          begin
            max := f;
            x3 := X;
            y3 := Y;
          end;

        end;
      end;
    end;
    if (X1 <> -2) and (X2 = -2) then
    begin
      tt;
    end;
    if x1+x2=-4 then
    ttt;      }

  end;
  procedure Joda2(a: TBinaryArray; var noghte, harf: TBinaryArray;
    var noghteha: Tnoghteha; var tedadejodashode: Integer; var Image: TImage;
    var tedadnum1, tedadnum2: Integer);
  { araye ye a bayad in ghone bashad: aghar siyah:1 aghar khali:0 }
    function saveBBmasahat(X, Y: Integer; var tedadtekrar: Integer;
      Color: Integer): Integer;
    var
      X2, Y2: Integer;
    begin
      a[X, Y] := Color;
      Inc(tedadtekrar);
      for X2 := X - 1 to X + 1 do
        for Y2 := Y - 1 to Y + 1 do
          if a[X2, Y2] = 1 then
            saveBBmasahat(X2, Y2, tedadtekrar, Color);
    end;

  var
    X, Y, G, Color, max, maxcolor, uu, number1, number2: Integer;
  begin
    Color := 1;
    max := -100;
    tedadnum1 := 0;
    tedadnum2 := 0;
    for X := 1 to Image.Width do
    begin
      for Y := 1 to Image.Height do
      begin
        if a[X, Y] = 1 then
        begin
          G := 0;
          Color := Color + 1;
          saveBBmasahat(X, Y, G, Color);
          if G > max then
          begin
            max := G;
            maxcolor := Color;
          end;
        end;
      end;
    end;
    uu := 0;
    number1 := 0;
    number2 := 0;
    tedadejodashode := Color - 2;
    for X := 2 to Color do
    begin
      if X = maxcolor then
        uu := 1
      else
      begin
        if X <> maxcolor then
        begin
          if number1 = 0 then
            number1 := X
          else
            number2 := X;
        end;
      end;
    end;
    if number1 < 1 then
      number1 := -3;
    if number2 < 1 then
      number2 := -3;

    for X := 1 to Image.Width do
    begin
      for Y := 1 to Image.Height do
      begin
        if a[X, Y] <> maxcolor then
        begin
          if a[X, Y] <> 0 then
          begin
            /// a[x,y]:=1;{1 = noghte}
            noghte[X, Y] := 1;
            harf[X, Y] := 0;

            Image.Canvas.Pixels[X - 1, Y - 1] := clBlue;
            if a[X, Y] = number1 then
            begin
              noghteha[1][X, Y] := True;
              tedadnum1 := tedadnum1 + 1;
            end
            else
              noghteha[1][X, Y] := false;
            if a[X, Y] = number2 then
            begin
              noghteha[2][X, Y] := True;
              tedadnum2 := tedadnum2 + 1;
            end
            else
              noghteha[2][X, Y] := false;
          end
          else
          begin { dsfgfdg }
            harf[X, Y] := 0;
            noghte[X, Y] := 0;
            a[X, Y] := 0;
            Image.Canvas.Pixels[X - 1, Y - 1] := clWhite;
            noghteha[1][X, Y] := false;
            noghteha[2][X, Y] := false;
          end;
        end
        else
        begin
          harf[X, Y] := 1;
          noghte[X, Y] := 0;
          Image.Canvas.Pixels[X - 1, Y - 1] := clBlack;
          noghteha[1][X, Y] := false;
          noghteha[2][X, Y] := false;
        end;
      end;
    end;
  end;

var
  C, harf, noghte: TBinaryArray;
  noghteha: Tnoghteha;
  B: TPixelArray;
  tedadeghesmatha, h, addnoghte, tedadbaste, andaze, tedadbaste2, andaze2, X1,
    Y1, X2, Y2, tedadpixelnoghte1, tedadpixelnoghte2: Integer;
begin
  Joda2(a, noghte, harf, noghteha, tedadeghesmatha, Form1.imgSmall2,
    tedadpixelnoghte1, tedadpixelnoghte2);

  if tedadeghesmatha = 3 then
    Result := 3
  else
  begin
    addnoghte := 0;
    for h := 1 to tedadeghesmatha do
    begin
      findendpixxel(noghteha[h], X1, Y1, X2, Y2);
      B := noghteha[h];
      vasl(B, X1, Y1, X2, Y2);
 //     ShowPixels(B, Form1.imgSmall2);
      noghtebaste(B, tedadbaste, andaze);
      noghtebaste(noghteha[h], tedadbaste2, andaze2);
      if (tedadbaste2 > 0) then
        addnoghte := addnoghte + 3
      else if ((tedadbaste > 0) and (andaze > size) and (X1 <> -2) and
          (X2 <> -2)) then
        addnoghte := addnoghte + 3
      else if (((h = 1) and (tedadpixelnoghte1 > size2)) or
          ((h = 2) and (tedadpixelnoghte2 > size2)))
      { and ( (x1<>-2) and (x2<>-2)) } then
        addnoghte := addnoghte + 2
      else
        addnoghte := addnoghte + 1;
    end;
    Result := addnoghte;
  end;

end;

function makannoghte(harf,noghte:TBinaryArray):ShortInt;
var
  x: Integer;
  y,vasatharf,vasatnoghte,tedadharf,tedadnoghte: Integer;
begin
  vasatharf:=0;
  vasatnoghte:=0;
  tedadharf:=0;
  tedadnoghte:=0;
  for x :=1 to 25 do
  begin
    for y := 1 to 31 do
    begin
      if harf[x,y]=1 then
      begin
        tedadharf:=tedadharf +1;
        vasatharf:=vasatharf +y;
      end;
      if noghte[x,y]=1 then
      begin
        tedadnoghte:=tedadnoghte +1;
        vasatnoghte:=vasatnoghte + y;
      end;
    end;
  end;
  if (tedadharf<>0)  and (tedadnoghte<>0)then
  begin
    if (vasatharf / tedadharf )> (vasatnoghte / tedadnoghte) then
      Result:=1{balaث}
    else
      Result:=2;{payin پ}
  end;
end;
 function makannoghtehkh(harf,noghte:TBinaryArray):ShortInt;
var
  x,maxh,maxn: Integer;
  y,vasatharf,vasatnoghte,tedadharf,tedadnoghte: Integer;
begin
  vasatharf:=0;
  vasatnoghte:=0;
  tedadharf:=0;
  tedadnoghte:=0;
  maxh:=-99999999999;
  maxn:=maxh;
  for x :=1 to 25 do
  begin
    for y := 1 to 31 do
    begin
      if (harf[x,y]=1) and (y>maxh) then
      begin
      maxh:=y;
      end;
      if (noghte[x,y]=1) and (y>maxn) then
      begin
      maxn:=y;
      end;
    end;
  end;
  if (tedadharf<>0)  and (tedadnoghte<>0)then
  begin
    if maxn>maxh then
    Result:=1
    else
    Result:=2;

  end;
end;

function Tarakom(Pixels: TBinaryArray): ShortInt;
var
  I, X, Y, Max: SmallInt;
  C: array [1..4] of SmallInt;
begin
  for I := 1 to 4 do
    C[I] := 0;
  if MaxX mod 2 = 1 then
    Inc(MaxX);
  if MaxY mod 2 = 1 then
    Inc(MaxY);
  for X := 1 to MaxX div 2 do
    for Y := 1 to MaxY div 2 do
    begin
      if Pixels[X, Y] = 1 then
        Inc(C[1]);
      if Pixels[X + MaxX div 2, Y] = 1 then
        Inc(C[2]);
      if Pixels[X, Y + MaxY div 2] = 1 then
        Inc(C[3]);
      if Pixels[X + MaxX div 2, Y + MaxY div 2] = 1 then
        Inc(C[4]);
    end;
  Max := -1;
  for I := 1 to 4 do
    if C[I] > Max then
    begin
      Max := C[I];
      Result := I;
    end;
end;

function ColorToRGB (Color: TColor): TRGB;
begin
  Result[1] := GetRValue (Color);
  Result[2] := GetGValue (Color);
  Result[3] := GetBValue (Color);
end;

function Density(Image: TImage): ShortInt;
var
  X, Y, I: ShortInt;
  Color: array [1..4] of TRGB;
  Max: Extended;
  Pixel: TRGB;
begin
  for I := 1 to 4 do
    Color[I] := ColorToRGB(clBlack);
  for X := 1 to 12 do
    for Y := 1 to 15 do
    begin
      Pixel := ColorToRGB(Image.Canvas.Pixels[(X - 1) * 1, (Y - 1) * 1]);
      for I := 1 to 3 do
        Color[1, I] := Color[1, I] + Pixel[I];
      Pixel := ColorToRGB(Image.Canvas.Pixels[(X + 12 - 1) * 1, (Y - 1) * 1]);
      for I := 1 to 3 do
        Color[2, I] := Color[2, I] + Pixel[I];
      Pixel := ColorToRGB(Image.Canvas.Pixels[(X - 1) * 1, (Y + 15 - 1) * 1]);
      for I := 1 to 3 do
        Color[3, I] := Color[3, I] + Pixel[I];
      Pixel := ColorToRGB(Image.Canvas.Pixels[(X + 12 - 1) * 1, (Y + 15 - 1) * 1]);
      for I := 1 to 3 do
        Color[4, I] := Color[4, I] + Pixel[I];
    end;
  Max := 1000000;
  for I := 1 to 4 do
  begin
    Color[I, 1] := Round(Color[I, 1] / (12 * 15));
    Color[I, 2] := Round(Color[I, 2] / (12 * 15));
    Color[I, 3] := Round(Color[I, 3] / (12 * 15));
    if 0.29 * Color[I, 1] + 0.59 * Color[I, 2] + 0.11 * Color[I, 3] < Max then
    begin
      Max := 0.29 * Color[I, 1] + 0.59 * Color[I, 2] + 0.11 * Color[I, 3];
      Result := I;
    end;
  end;
end;


function Dis (X1, Y1, X2, Y2: Real): Real;
begin
  Dis := Sqrt (Sqr (X2 - X1) + Sqr (Y2 - Y1));
end;

function BlurMatrixX (Value: Word): TMatrix;
var
  I: Integer;
begin
  if Value <> 0 then
    for I := -Value to +Value do
      Result[0, I] := Value - Abs (I);
end;

function BlurMatrixY (Value: Word): TMatrix;
var
  I: Integer;
begin
  if Value <> 0 then
    for I := -Value to +Value do
      Result[I, 0] := Value - Abs (I);
end;

function BlurMatrix (Radius: TPoint): TMatrix;
var
  M: Real;
  X, Y: Integer;
begin
  M := Max (Radius.X, Radius.Y);
  Matrix := BlurMatrixX (Radius.X);
  Matrix := BlurMatrixY (Radius.Y);
  Sum := 0;
  for X := -Radius.X to +Radius.X do
    for Y := -Radius.Y to +Radius.Y do
    begin
      if Dis (X, Y, 0, 0) <= M then
      begin
        Result[X, Y] := Matrix[X, 0] * Matrix[0, Y];
        Sum := Sum + Result[X, Y];
      end
      else
        Result[X, Y] := 0;
    end;
end;

function BytesPerPixel(APixelFormat: TPixelFormat): Integer;
begin
  Result := -1;
  case APixelFormat of
    pf8bit: Result := 1;
    pf16bit: Result := 2;
    pf24bit: Result := 3;
    pf32bit: Result := 4;
  end;
end;

procedure BitmapToBytes(Bitmap: TBitmap; out Bytes: TBytesArray; var nBytes : Longint);
var
  BytesPerLine: Integer;
  Row, BPP: Integer;
  PPixels : Pointer;
  PBytes : ^TBytesArray;
begin
  BPP := BytesPerPixel(Bitmap.PixelFormat);
  if BPP < 1 then
    raise Exception.Create('Unknown pixel format');
  nBytes := Bitmap.Width * Bitmap.Height * BPP;
  SetLength(Bytes, nBytes);
  BytesPerLine := Bitmap.Width * BPP;
  for Row := 0 to Bitmap.Height-1 do
  begin
    PBytes := @Bytes[Row * BytesPerLine];
    PPixels := Bitmap.ScanLine[Row];
    CopyMemory(PBytes, PPixels, BytesPerLine);
  end;
end;

procedure BytesToBitmap(const Bytes: TBytesArray; Bitmap: TBitmap;
  APixelFormat: TPixelFormat; AWidth, AHeight: Integer);
var
  BytesPerLine: Integer;
  Row, Col, BPP: Integer;
  PPixels, PBytes : Pointer;
begin
  BPP := BytesPerPixel(APixelFormat);
  if BPP < 1 then
    raise Exception.Create('Unknown pixel format');
  if (AWidth * AHeight * BPP) <> Length(Bytes) then
    raise Exception.Create('Bytes do not match image properties');
  Bitmap.Width := AWidth;
  Bitmap.Height := AHeight;
  Bitmap.PixelFormat := APixelFormat;
  BytesPerLine := Bitmap.Width * BPP;
  for Row := 0 to Bitmap.Height-1 do
  begin
    PBytes := @Bytes[Row * BytesPerLine];
    PPixels := Bitmap.ScanLine[Row];
    CopyMemory(PPixels, PBytes, BytesPerLine);
  end;
end;

procedure Median(Image1: TImage; var Image2: TImage; Radius: TPoint);
const
  K = 30;
  K2 = 30;
var
  R, G, B, D: Int64;
  X, Y, X2, Y2, Divisor: Integer;
  Color: TColor;
  Bytes2: TBytesArray;
begin
  Divisor := (Radius.X * 2 + 1) * (Radius.Y * 2 + 1);
  Image2.Picture := Image1.Picture;
  BitmapToBytes(Image1.Picture.Bitmap, Bytes, nBytes);
  Bytes2 := Bytes;
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
    begin
      R := 0;
      G := 0;
      B := 0;
      D := 0;
      for X2 := X - Radius.X to X + Radius.X do
        for Y2 := Y - Radius.Y to Y + Radius.Y do
        begin
          if (X2 < 0) or (X2 > Image1.Picture.Width - 1) or (Y2 < 0) or (Y2 > Image1.Picture.Height - 1) then
            Inc (D)
          else
          begin
            R := R + Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 2];
            G := G + Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 1];
            B := B + Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 0];
          end;
        end;
      R := Round (R / (Divisor - D));
      G := Round (G / (Divisor - D));
      B := Round (B / (Divisor - D));
      if 0.299 * R + 0.587 * G + 0.114 * B > 130 then
      begin
        Bytes[3 * (Y * Image1.Picture.Width + X) + 2] := Min((R + K), 255);
        Bytes[3 * (Y * Image1.Picture.Width + X) + 1] := Min((G + K), 255);
        Bytes[3 * (Y * Image1.Picture.Width + X) + 0] := Min((B + K), 255);
      end
      else
        if 0.299 * R + 0.587 * G + 0.114 * B < 100 then
        begin
          Bytes[3 * (Y * Image1.Picture.Width + X) + 2] := Max((R - K2), 0);
          Bytes[3 * (Y * Image1.Picture.Width + X) + 1] := Max((G - K2), 0);
          Bytes[3 * (Y * Image1.Picture.Width + X) + 0] := Max((B - K2), 0);
        end
        else
        begin
          Bytes[3 * (Y * Image1.Picture.Width + X) + 2] := R;
          Bytes[3 * (Y * Image1.Picture.Width + X) + 1] := G;
          Bytes[3 * (Y * Image1.Picture.Width + X) + 0] := B;
        end;
    end;
  BytesToBitmap(Bytes, Image2.Picture.Bitmap, Image1.Picture.Bitmap.PixelFormat, Image1.Picture.Bitmap.Width, Image1.Picture.Bitmap.Height);
end;

procedure GaussianBlur (Image1: TImage; var Image2: TImage; Matrix: TMatrix; Radius: TPoint; Divisor: Real);
const
  K = 30;
  K2 = 30;
var
  R, G, B, D: Int64;
  X, Y, X2, Y2, Divisor2: Integer;
  Color: TColor;
  Bytes2: TBytesArray;
  Bl: Boolean;
begin
  Divisor2 := (Radius.X * 2 + 1) * (Radius.Y * 2 + 1);
  Image2.Picture := Image1.Picture;
  BitmapToBytes(Image1.Picture.Bitmap, Bytes, nBytes);
  Bytes2 := Bytes;
  for X := 0 to Image1.Picture.Width - 1 do
    for Y := 0 to Image1.Picture.Height - 1 do
    begin
      R := 0;
      G := 0;
      B := 0;
      D := Round(0.30 * Bytes2[3 * (Y * Image1.Picture.Width + X) + 2] + 0.59 * Bytes2[3 * (Y * Image1.Picture.Width + X) + 1] + 0.11 * Bytes2[3 * (Y * Image1.Picture.Width + X) + 0]);
      //Bl := (D > 25) and (D < 200);
      Bl := False;
      D := 0;
      for X2 := X - Radius.X to X + Radius.X do
        for Y2 := Y - Radius.Y to Y + Radius.Y do
        begin
          if (X2 < 0) or (X2 > Image1.Picture.Width - 1) or (Y2 < 0) or (Y2 > Image1.Picture.Height - 1) then
          begin
            if Bl then
              Inc(D)
            else
              Inc (D, Matrix[X2 - X, Y2 - Y]);
          end
          else
            if Bl then
            begin
              R := R + Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 2];
              G := G + Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 1];
              B := B + Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 0];
            end
            else
            begin
              R := R + Matrix[X2 - X, Y2 - Y] * Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 2];
              G := G + Matrix[X2 - X, Y2 - Y] * Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 1];
              B := B + Matrix[X2 - X, Y2 - Y] * Bytes2[3 * (Y2 * Image1.Picture.Width + X2) + 0];
            end;
        end;
      if Bl then
      begin
        R := Round (R / (Divisor2 - D));
        G := Round (G / (Divisor2 - D));
        B := Round (B / (Divisor2 - D));
      end
      else
      begin
        R := Round (R / (Divisor - D));
        G := Round (G / (Divisor - D));
        B := Round (B / (Divisor - D));
      end;
      if 0.299 * R + 0.587 * G + 0.114 * B > 130 then
      begin
        Bytes[3 * (Y * Image1.Picture.Width + X) + 2] := Min((R + K), 255);
        Bytes[3 * (Y * Image1.Picture.Width + X) + 1] := Min((G + K), 255);
        Bytes[3 * (Y * Image1.Picture.Width + X) + 0] := Min((B + K), 255);
      end
      else
        if 0.299 * R + 0.587 * G + 0.114 * B < 90 then
        begin
          Bytes[3 * (Y * Image1.Picture.Width + X) + 2] := Max((R - K2), 0);
          Bytes[3 * (Y * Image1.Picture.Width + X) + 1] := Max((G - K2), 0);
          Bytes[3 * (Y * Image1.Picture.Width + X) + 0] := Max((B - K2), 0);
        end
        else
        begin
          Bytes[3 * (Y * Image1.Picture.Width + X) + 2] := R;
          Bytes[3 * (Y * Image1.Picture.Width + X) + 1] := G;
          Bytes[3 * (Y * Image1.Picture.Width + X) + 0] := B;
        end;
    end;
  BytesToBitmap(Bytes, Image2.Picture.Bitmap, Image1.Picture.Bitmap.PixelFormat, Image1.Picture.Bitmap.Width, Image1.Picture.Bitmap.Height);
end;

function NemudarOfoqi(A: TBinaryArray): Integer;
const
  endx=24;
  endy=30;
var
  x,g,j,tedad,hazfshode: integer;
  nemodar: array[1..endy] of ShortInt;
  miyangimnemodar: real;
function baghimande2(k:integer):integer;
var
  x,tedad:integer;
begin
  tedad:=0;
  for x := 1 to endy  do
    begin
      if nemodar[x]>0 then
      tedad:=tedad + 1;
    end;
  baghimande2:=tedad;
end;
procedure Yeksansazi;
var
  x:integer;
begin
for x := 1 to endy - j + 1 do
  begin
   if (abs(nemodar[x] - nemodar[x+1])<7) and (nemodar[x+1]>1)and (nemodar[x]>1) then
   begin
     nemodar[x+1]:=nemodar[x]+nemodar[x+1];
     nemodar[x]:=0;
     hazfshode:=hazfshode +1;
   end;
  end;
end;
procedure YeksansaziEnd;
var
  x, xx: Integer;
begin
  for x := 1 to endy - 1 do
    if (nemodar[x]>0) then
      for xx := x+1 to endy  do
        if nemodar[xx]>0 then
          if abs(xx - x)<5 then
            nemodar[x]:=0;
end;
function miyangin:real;
var
  x,tedad,uu:integer;
begin
  tedad:=0;
  uu:=0;
  for x := 1 to endy {- j+1}  do
    if nemodar[x]>0 then
    begin
      tedad:=tedad+ nemodar[x];
      uu:=uu +1;
    end;
  miyangin:=((tedad / (uu)));
end;
begin
  j:=0;
  for g := 1 to endy do
  begin
    tedad:=0;
    for x:=1 to endx do
      if a[x,g] = 1 then
        tedad:=tedad+1;
    if tedad>3 then
      nemodar[g]:=tedad
    else
      nemodar[g]:=0;
    if tedad=0 then
      j:=j+1;
  end;
  hazfshode:=0;
  while baghimande2(1)>3  do
  begin
    yeksansazi;
    miyangimnemodar := miyangin;
    if baghimande2(3) < 4 then
      break;
    for x := 1 to endy - j + 1 do
      if (nemodar[x]<=miyangimnemodar) and (nemodar[x]>0) then
      begin
        nemodar[x]:=-12;
        hazfshode:=hazfshode +1;
      end;
  end;
  yeksansazi;
  yeksansaziend;
  Result:=baghimande2(1);
end;

function NemudarAmudi(A: TBinaryArray): Integer;
const
  endx=25;
  endy=31;
var
  x,g,j,tedad,hazfshode: integer;
  nemodar: array[1..endx] of ShortInt;
  miyangimnemodar: real;
function baghimande2(k:integer):integer;
var
  x,tedad:integer;
begin
  tedad:=0;
  for x := 1 to endx  do
    if nemodar[x]>0 then
      tedad:=tedad + 1;
  baghimande2:=tedad;
end;
procedure Yeksansazi;
var
  x:integer;
begin
for x := 1 to endx - j + 1 do
  begin
   if (abs(nemodar[x] - nemodar[x+1])<7) and (nemodar[x+1]>1)and (nemodar[x]>1) then
   begin
     nemodar[x+1]:=nemodar[x]+nemodar[x+1];
     nemodar[x]:=0;
     hazfshode:=hazfshode +1;
   end;
  end;
end;
procedure YeksansaziEnd;
var
  x, xx: Integer;
begin
  for x := 1 to endx - 1 do
    if (nemodar[x]>0) then
      for xx := x+1 to endx  do
        if nemodar[xx]>0 then
          if abs(xx - x)<5 then
            nemodar[x]:=0;
end;
function miyangin:real;
var
  x,tedad,uu:integer;
begin
  tedad:=0;
  uu:=0;
  for x := 1 to endx - j+1  do
    if nemodar[x]>0 then
    begin
      tedad:=tedad+ nemodar[x];
      uu:=uu +1;
    end;
  miyangin:=((tedad / (uu)));
end;
begin
  j:=0;
  for g := 1 to endx do
  begin              {  {{{{{{{{  }
    tedad:=0;
    for x:=1 to endy do
      if a[g,x] = 1 then
        tedad:=tedad+1;
    if tedad>2 then
      nemodar[g]:=tedad
    else
      nemodar[g]:=0;
    if tedad=0 then
      j:=j+1;
  end;
  hazfshode:=0;
  while baghimande2(1)>6  do
  begin
    yeksansazi;
    miyangimnemodar:=miyangin;
    if baghimande2(3)<4 then
      break;
    for x := 1 to endx  - j+1 do
      if (nemodar[x]<=miyangimnemodar) and (nemodar[x]>0) then
      begin
        nemodar[x]:=-12;
        hazfshode:=hazfshode +1;
      end;
  end;
  yeksansazi;
  {for I := 1 to 36 do
    Form1.StringGrid1.Cells[I, 0] := IntToStr(Nemodar[I]);}
  ///yeksansaziend;
  Result:=baghimande2(1);
end;

function ATan (xx, yy: Real): Real;
var
	xxx, yyy, Teta: Real;
begin
	xxx := Abs(xx);
  yyy := Abs(yy);
  if (xx >= 0) and (yy >= 0) and (xxx > yyy) then Teta := ArcTan (yyy / xxx);
  if (xx >= 0) and (yy >= 0) and (xxx < yyy) then Teta := Pi / 2 - ArcTan (xxx / yyy);
  if (xx >= 0) and (yy >= 0) and (xxx = yyy) then Teta := Pi / 4;
	if (xx <  0) and (yy >= 0) and (xxx > yyy) then Teta := Pi - ArcTan (yyy / xxx);
  if (xx <  0) and (yy >= 0) and (xxx < yyy) then Teta := Pi / 2 + ArcTan (xxx / yyy);
  if (xx <  0) and (yy >= 0) and (xxx = yyy) then Teta := Pi - Pi / 4;
	if (xx <  0) and (yy <  0) and (xxx > yyy) then Teta := Pi + ArcTan (yyy / xxx);
  if (xx <  0) and (yy <  0) and (xxx < yyy) then Teta := 3 * Pi / 2 - ArcTan (xxx / yyy);
	if (xx <  0) and (yy <  0) and (xxx = yyy) then Teta := Pi + Pi / 4;
  if (xx >= 0) and (yy <  0) and (xxx > yyy) then Teta := 2 * Pi - ArcTan (yyy / xxx);
	if (xx >= 0) and (yy <  0) and (xxx < yyy) then Teta := 3 * Pi / 2 + ArcTan (xxx / yyy);
  if (xx >= 0) and (yy <  0) and (xxx = yyy) then Teta := 2 * Pi - Pi / 4;
  ATan := Teta * 180 / Pi;
end;

function Baste(A: TBinaryArray): Integer;
{araye ye a bayad in ghone bashad: aghar siyah:1 aghar khali:0}
var
	x,y,g,ma,color,max,maxcolor,endy,endx:integer;
function saveBBmasahat(x,y:integer; var tedadtekrar:integer; color:integer):integer;
begin
  A[X,Y] := 1;
  Inc(TedadTekrar);
  if (a[x+1,y]=0) and (x+1<endx+1) and (x+1>-1) then
    saveBBmasahat(x+1,y,tedadtekrar,color);
  if (a[x-1,y]=0) and (x-1>-1) and (x<endx+1) then
    saveBBmasahat(x-1,y,tedadtekrar,color);
  if (a[x,y+1]=0) and (y+1<endy+1)and (y+1>-1) then
    saveBBmasahat(x,y+1,tedadtekrar,color);
  if (a[x,y-1]=0) and (y-1>-1) and (y<endy+1) then
    saveBBmasahat(x,y-1,tedadtekrar,color);
end;
begin
	ma:=-1;
	color:=1;
	max:=-100;
	endy:=17;
	endx:=17;
	for x := 1 to endx do
  begin
    for y := 1 to endy do
    begin
      if a[x,y]=0 then
      begin
				ma:=ma+1;
				g:=0;
				color:=color +1;
				saveBBmasahat(x,y,g,color);
				if g>max then
				begin
					max:=g;
					maxcolor:=color;
				end;
      end;
    end;
  end;
   baste:=ma;
end;

procedure Joda(A: TBinaryArray; var Noghte, Harf: TBinaryArray; var Image: TImage);
{araye ye a bayad in ghone bashad: aghar siyah:1 aghar khali:0}
function saveBBmasahat(x,y:integer; var tedadtekrar:integer; color:integer):integer;
var
  X2, Y2: Integer;
begin
 A[X, Y] := Color;
 Inc(TedadTekrar);
 for X2 := X - 1 to X + 1 do
  for Y2 := Y - 1 to Y + 1 do
    if A[X2, Y2] = 1 then
      SaveBBMasahat(X2, Y2, TedadTekrar, Color);
end;
var
	x,y,g,color,max,maxcolor:integer;
begin
  color:=1;
  max:=-100;
  for x := 1 to Image.Width do
  begin
    for y := 1 to Image.Height do
    begin
      if a[x,y]=1 then
      begin
        g:=0;
        color:=color +1;
        saveBBmasahat(x,y,g,color);
        if g>max then
        begin
          max:=g;
          maxcolor:=color;
        end;
      end;
    end;
  end;
  for x := 1 to Image.Width do
  begin
   for y := 1 to Image.Height do
     begin
       if a[x,y]<>maxcolor then
       begin
        if a[x,y]<>0 then
        begin
          a[x,y]:=1;{1 = noghte}
          noghte[x,y]:=1;
          harf[x,y]:=0;
          Image.Canvas.Pixels[x - 1,y - 1]:=clWhite;
        end
        else
        begin
          harf[x,y]:=0;
          noghte[x,y]:=0;
          a[x,y]:=0;
          Image.Canvas.Pixels[x - 1,y - 1]:=clWhite;
        end;
       end
       else
       begin
         harf[x,y]:=1;
         noghte[x,y]:=0;
         Image.Canvas.Pixels[x - 1,y - 1]:=clBlack;
       end;
     end;
  end;
end;

procedure ClearDots(A: TBinaryArray; var Noghte, Harf: TBinaryArray; var Image: TImage);
{araye ye a bayad in ghone bashad: aghar siyah:1 aghar khali:0}
function saveBBmasahat(x,y:integer; var tedadtekrar:integer; color:integer):integer;
var
  X2, Y2: Integer;
begin
 A[X, Y] := Color;
 Inc(TedadTekrar);
 for X2 := X - 1 to X + 1 do
  for Y2 := Y - 1 to Y + 1 do
    if A[X2, Y2] = 1 then
      SaveBBMasahat(X2, Y2, TedadTekrar, Color);
end;
var
	x,y,g,color,max,maxcolor:integer;
begin
  color:=1;
  max:=-100;
  for x := 1 to 36 do
  begin
    for y := 1 to 45 do
    begin
      if a[x,y]=1 then
      begin
        g:=0;
        color:=color + 1;
        saveBBmasahat(x,y,g,color);
        if g>max then
        begin
          max:=g;
          maxcolor:=color;
        end;
      end;
    end;
  end;
  for x := 1 to 36 do
  begin
   for y := 1 to 45 do
     begin
       if a[x,y]<>maxcolor then
       begin
        if a[x,y]<>0 then
        begin
          a[x,y]:=1;{1 = noghte}
          noghte[x,y]:=1;
          harf[x,y]:=0;
          //Image.Canvas.Pixels[x - 1,y - 1]:=clWhite;
          (*if ((X - 1) * 5 < Image.Width - 1) and ((Y - 1) * 5 < Image.Height - 1) then
          begin*)
            Image.Canvas.Brush.Color := clWhite;
            Image.Canvas.FillRect(Rect((X - 1) * 5 - 3, (Y - 1) * 5 - 3, X * 5 + 3, Y * 5 + 3));
          (*end;*)
        end
        else
        begin
          harf[x,y]:=0;
          noghte[x,y]:=0;
          a[x,y]:=0;
          //Image.Canvas.Pixels[x - 1,y - 1]:=clWhite;
        end;
       end
       else
       begin
         harf[x,y]:=1;
         noghte[x,y]:=0;
         //Image.Canvas.Pixels[x - 1,y - 1]:=clBlack;
       end;
     end;
  end;
end;

procedure Skeletonize(var Image: TImage; var Pixels: TBinaryArray);
const
  Points: array [1..9] of TPoint = ((X:-1; Y:-1), (X:0; Y:-1), (X:+1; Y:-1), (X:+1; Y:0), (X:+1; Y:+1), (X:0; Y:+1), (X:-1; Y:+1), (X:-1; Y:0), (X:-1; Y:-1));
var
  X, Y, X2, Y2, Count: ShortInt;
  Pixels2: TBinaryArray;
  Trans: Word;
begin
  Pixels2 := Pixels;
  for X := 0 to Image.Width + 1 do
    for Y := 0 to Image.Height + 1 do
      if (not X in [1..36]) and (not Y in [1..45]) then
        Pixels[X, Y] := 0;
  for X := 1 to Image.Width do
    for Y := 1 to Image.Height do
    begin
      if Pixels[X, Y] = 1 then
      begin
        Count := -1;
        Trans := 0;
        for X2 := X - 1 to X + 1 do
          for Y2 := Y - 1 to Y + 1 do
            if (X2 in [1..36]) and (Y2 in [1..45]) then
              Inc(Count, Pixels[X2, Y2]);
        for X2 := 1 to 8 do
          //if (X + Points[X2].X in [1..36]) and (Y + Points[X2].Y in [1..45]) and (X + Points[X2 + 1].X in [1..36]) and (Y + Points[X2 + 1].Y in [1..45]) then
            if (Pixels[X + Points[X2].X, Y + Points[X2].Y] = 0) and (Pixels[X + Points[X2 + 1].X, Y + Points[X2 + 1].Y] = 1) then
              Inc(Trans);
        if Trans = 1 then
        begin
          if (Pixels2[X - 1, Y] * Pixels2[X, Y] * Pixels2[X + 1, Y] * Pixels2[X - 1, Y + 1] * Pixels2[X, Y + 1] * Pixels2[X + 1, Y + 1] = 1) {and (Pixels2[X - 1, Y - 1] + Pixels2[X, Y - 1] + Pixels2[X + 1, Y - 1] = 0)} then
            Trans := 2;
          if (Pixels2[X, Y] * Pixels2[X, Y + 1]{ * Pixels2[X, Y + 2]} = 1) and (Pixels[X - 1, Y] + Pixels[X + 1, Y] = 0) then
            Trans := 2;
          if (Pixels2[X, Y - 1] + Pixels2[X, Y + 1] = 0)
            and (((Pixels2[X, Y] * Pixels2[X - 1, Y] * Pixels2[X - 2, Y] = 1) and ((Pixels2[X, Y - 1] + Pixels2[X - 1, Y - 1] + Pixels2[X - 2, Y - 1] = 0) or (Pixels2[X, Y + 1] + Pixels2[X - 1, Y + 1] + Pixels2[X - 2, Y + 1] = 0)))
            or ((Pixels2[X, Y] * Pixels2[X + 1, Y] * Pixels2[X + 2, Y] = 1) and ((Pixels2[X, Y - 1] + Pixels2[X + 1, Y - 1] + Pixels2[X + 2, Y - 1] = 0) or (Pixels2[X, Y + 1] + Pixels2[X + 1, Y + 1] + Pixels2[X + 2, Y + 1] = 0)))) then
            Trans := 2;
        end;
        if (Count in [2..6]) and (Trans = 1) then
          if ((Pixels[X, Y - 1] * Pixels[X + 1, Y] * Pixels[X, Y + 1] = 0) and (Pixels[X + 1, Y] * Pixels[X, Y + 1] * Pixels[X - 1, Y] = 0))
          or ((Pixels[X, Y - 1] * Pixels[X + 1, Y] * Pixels[X - 1, Y] = 0) and (Pixels[X, Y - 1] * Pixels[X, Y + 1] * Pixels[X - 1, Y] = 0)) then
          begin
            Pixels2[X, Y] := 0;
            Pixels[X, Y] := 0;
          end;
        if Pixels2[X, Y] = 1 then
          Image.Canvas.Pixels[X - 1, Y - 1] := clBlack
        else
          Image.Canvas.Pixels[X - 1, Y - 1] := clWhite;
        //Form1.StringGrid1.Cells[X, Y] := IntToStr(Trans);
      end
      else
        ;//Form1.StringGrid1.Cells[X, Y] := '';
    end;
  Pixels := Pixels2;
end;

procedure TrimImage(var Image: TImage; var Pixels: TBinaryArray); overload;
var
  X, Y, MinX, MinY: Word;
begin
  Image.Picture.Bitmap.Width := Image.Width;
  Image.Picture.Bitmap.Height := Image.Height;
  MinX := Image.Width;
  MinY := Image.Height;
  MaxX := 0;
  MaxY := 0;
  for X := 1 to Image.Width do
    for Y := 1 to Image.Height do
      if Pixels[X, Y] = 1 then
      begin
        if X < MinX then
          MinX := X;
        if Y < MinY then
          MinY := Y;
      end;
  for X := 1 to Image.Width do
    for Y := 1 to Image.Height do
    begin
      if (X in [1..Image.Width - MinX + 1]) and (Y in [1..Image.Height - MinY + 1]) then
        Pixels[X, Y] := Pixels[X + MinX - 1, Y + MinY - 1]
      else
        Pixels[X, Y] := 0;
      if Pixels[X, Y] = 1 then
        Image.Canvas.Pixels[X - 1, Y - 1] := clBlack
      else
        Image.Canvas.Pixels[X - 1, Y - 1] := clWhite;
    end;
end;

procedure TrimImage(var Image: TImage); overload;
var
  X, Y, MinX, MinY: ShortInt;
begin
  MinX := Image.Width;
  MinY := Image.Height;
  for X := 0 to Image.Width - 1 do
    for Y := 0 to Image.Height - 1 do
      if Image.Canvas.Pixels[X, Y] <> clWhite then
      begin
        if X < MinX then
          MinX := X;
        if Y < MinY then
          MinY := Y;
      end;
  for X := 0 to Image.Width - 1 do
    for Y := 0 to Image.Height - 1 do
    begin
      if (X in [0..Image.Width - MinX - 1]) and (Y in [0..Image.Height - MinY - 1]) then
        Image.Canvas.Pixels[X, Y] := Image.Canvas.Pixels[X + MinX, Y + MinY]
      else
        Image.Canvas.Pixels[X, Y] := clWhite;
    end;
end;

procedure TrimImage(var Pixels: TSegment); overload;
var
  X, Y, MinX, MinY: Word;
begin
  MinX := 36;
  MinY := 45;
  for X := 1 to 240 do
    for Y := 1 to 300 do
      if Pixels[X, Y] = 1 then
      begin
        if X < MinX then
          MinX := X;
        if Y < MinY then
          MinY := Y;
      end;
  for X := 1 to 240 do
    for Y := 1 to 300 do
    begin
      if (X in [1..240 - MinX + 1]) and (Y in [1..300 - MinY + 1]) then
        Pixels[X, Y] := Pixels[X + MinX - 1, Y + MinY -1]
      else
        Pixels[X, Y] := 0;
    end;
end;

procedure TrimImage(var Pixels: TBinaryArray); overload;
var
  X, Y, MinX, MinY: Word;
begin
  MinX := 36;
  MinY := 45;
  for X := 1 to 36 do
    for Y := 1 to 45 do
      if Pixels[X, Y] = 1 then
      begin
        if X < MinX then
          MinX := X;
        if Y < MinY then
          MinY := Y;
      end;
  for X := 1 to 36 do
    for Y := 1 to 45 do
      if (X in [1..36 - MinX + 1]) and (Y in [1..45 - MinY + 1]) then
        Pixels[X, Y] := Pixels[X + MinX - 1, Y + MinY -1]
      else
        Pixels[X, Y] := 0;
end;

procedure ImageToBin(Image: TImage; var Image2: TImage; var Pixels: TBinaryArray; Cols, Rows, MaxRGB: Word);
var
  W, H, X, Y, X2, Y2: Word;
  C: Real;
begin
  W := Image.Picture.Width;
  H := Image.Picture.Height;
  for Y := 0 to Rows - 1 do
    for X := 0 to Cols - 1 do
    begin
      C := 0;
      for X2 := X * (W div Cols) to X * (W div Cols) + (W div Cols) - 1 do
        for Y2 := Y * (H div Rows) to Y * (H div Rows) + (H div Rows) - 1 do
        begin
          C := C + Bytes[3 * (Y2 * W + X2) + 0] * 0.114;
          C := C + Bytes[3 * (Y2 * W + X2) + 1] * 0.587;
          C := C + Bytes[3 * (Y2 * W + X2) + 2] * 0.299;
        end;
      C := Round(C / ((W div Cols) * (H div Rows)));
      if C < MaxRGB then
        Pixels[X + 1, Y + 1] := 1
      else
        Pixels[X + 1, Y + 1] := 0;
      if Pixels[X + 1, Y + 1] = 1 then
        Image2.Canvas.Pixels[X, Y] := clBlack
      else
        Image2.Canvas.Pixels[X, Y] := clWhite;
    end;
end;

procedure ShowDensity(Image: TImage; var Image2: TImage; Cols, Rows: Word);
var
  W, H, X, Y, X2, Y2, C: Word;
begin
  Image2.Width := Cols;
  Image2.Height := Rows;
  Image2.Stretch := False;
  W := Image.Picture.Width;
  H := Image.Picture.Height;
  for Y := 0 to Rows - 1 do
    for X := 0 to Cols - 1 do
    begin
      C := 0;
      for X2 := X * (W div Cols) to X * (W div Cols) + (W div Cols) - 1 do
        for Y2 := Y * (H div Rows) to Y * (H div Rows) + (H div Rows) - 1 do
        begin
          C := C + Round(Bytes[3 * (Y2 * W + X2) + 0] * 0.114);
          C := C + Round(Bytes[3 * (Y2 * W + X2) + 1] * 0.587);
          C := C + Round(Bytes[3 * (Y2 * W + X2) + 2] * 0.299);
        end;
      C := Round(C / ((W div Cols) * (H div Rows)));
      Image2.Canvas.Pixels[X, Y] := RGB(C, C, C);
    end;
  //TrimImage(Image2);
  Image2.Width := W;
  Image2.Height := H;
  Image2.Stretch := True;
end;

function Crosses(var Image: TImage; BinPixels: TBinaryArray): TCrosses;
var
  X, Y, I: ShortInt;
  A: array [1..8] of ShortInt;
begin
  //BooleanToBin(Pixels, BinPixels);
  for I := 1 to 8 do
    Result[I] := 0;
  for Y := 0 to Image.Width - 1 do
    for X := 0 to Image.Height - 1 do
    begin
      for I := 1 to 8 do
        A[I] := 1;
      for I := 0 to 3 do
      begin
        A[1] := A[1] * BinPixels[X, Y - I] * BinPixels[X - I, Y];{_|}
        A[2] := A[2] * BinPixels[X, Y - I] * BinPixels[X + I, Y];{|_}
        A[3] := A[3] * BinPixels[X, Y + I] * BinPixels[X - I, Y];{^|}
        A[4] := A[4] * BinPixels[X, Y + I] * BinPixels[X + I, Y];{|^}
        A[5] := A[5] * BinPixels[X - I, Y + I] * BinPixels[X - I, Y - I];{>}
        A[6] := A[6] * BinPixels[X - I, Y - I] * BinPixels[X + I, Y - I];{V}
        A[7] := A[7] * BinPixels[X + I, Y - I] * BinPixels[X + I, Y + I];{<}
        A[8] := A[8] * BinPixels[X + I, Y + I] * BinPixels[X - I, Y + I];{^}
      end;
      for I := 1 to 8 do
        if A[I] = 1 then
        begin
          Inc(Result[I]);
          Image.Canvas.Pixels[X, Y] := clRed;
          Image.Canvas.Pixels[X - 1, Y] := clRed;
          Image.Canvas.Pixels[X, Y - 1] := clRed;
          Image.Canvas.Pixels[X + 1, Y] := clRed;
          Image.Canvas.Pixels[X, Y + 1] := clRed;
        end;
    end;
end;

function Lines(var Image: TImage; Pixels: TBinaryArray): T2Int;
var
  X, Y, I, J, J2: ShortInt;
  A: array [1..2] of ShortInt;
  BinPixels1, BinPixels2: TBinaryArray;
begin
  //BooleanToBin(Pixels, BinPixels);
  //BooleanToBin(Pixels, BinPixels1);
  //BooleanToBin(Pixels, BinPixels2);
  BinPixels := Pixels;
  BinPixels1 := Pixels;
  BinPixels2 := Pixels;
  for I := 1 to 2 do
    Result[I] := 0;
  for Y := 0 to Image.Width - 1 do
    for X := 0 to Image.Height - 1 do
    begin
      for I := 1 to 2 do
        A[I] := 1;
      for I := 0 to 5 do
      begin
        if X + I in [1..36] then
          A[1] := A[1] * BinPixels1[X + I, Y]
        else
          A[1] := 0;
        if Y + I in [1..45] then
          A[2] := A[2] * BinPixels2[X, Y + I]
        else
          A[2] := 0;
      end;
      for I := 1 to 2 do
        if A[I] = 1 then
        begin
          Inc(Result[I]);
          J := 0;
          while BinPixels1[X + J, Y] = 1 do
          begin
            BinPixels1[X + J, Y] := 0;
            Inc(J);
          end;
          J2 := J;
          //
          if BinPixels[X + J - 1, Y - 1] = 0 then
            while BinPixels[X + J2, Y - 1] = 1 do
            begin
              BinPixels1[X + J2, Y - 1] := 0;
              Inc(J2);
            end;
          if J2 - J >= 6 then
            //Form1.Caption := '1';//Dec(Result[1]);
          J2 := J;
          if BinPixels[X + J - 1, Y + 1] = 0 then
            while BinPixels[X + J2, Y + 1] = 1 do
            begin
              BinPixels1[X + J2, Y + 1] := 0;
              Inc(J2);
            end;
          if J2 - J >= 6 then
            //Form1.Caption := '2';//Dec(Result[1]);
          //
          J := 0;
          while BinPixels2[X, Y + J] = 1 do
          begin
            BinPixels2[X, Y + J] := 0;
            Inc(J);
          end;
          //
          J2 := J;
          if BinPixels[X - 1, Y + J - 1] = 0 then
            while BinPixels[X - 1, Y + J2] = 1 do
            begin
              BinPixels2[X - 1, Y + J2] := 0;
              Inc(J2);
            end;
          if J2 - J >= 6 then
            //Form1.Caption := '3';//Dec(Result[2]);
          J2 := J;
          if BinPixels[X + 1, Y + J - 1] = 0 then
            while BinPixels[X + 1, Y + J2] = 1 do
            begin
              BinPixels2[X + 1, Y + J2] := 0;
              Inc(J2);
            end;
          if J2 - J >= 6 then
            //Form1.Caption := '4';//Dec(Result[2]);}
        end;
    end;
end;

procedure Segmentate(var Image: TImage);
var
  Chars: array [1..1] of TSegment;
  X, Y, X2, Y2: Integer;
  I: Word;
  Min, Max: TPoint;
  Marked: array [0..240, 0..300] of Boolean;
function Mark(var S: TSegment; X, Y: Integer): TSegment;
var
  X2, Y2: Integer;
begin
  //S[X, Y] := 1;
  //Bytes[3 * (Y * Image.Width + X) + 0] := 255;
  //Image.Canvas.Pixels[X, Y] := clWhite;
  Marked[X, Y] := False;
  if X < Min.X then
    Min.X := X;
  if Y < Min.Y then
    Min.Y := Y;
  if X > Max.X then
    Max.X := X;
  if Y > Max.Y then
    Max.Y := Y;
  for X2 := X - 1 to X + 1 do
    for Y2 := Y - 1 to Y + 1 do
      if (X2 = X) or (Y2 = Y) then
        if Marked[X2, Y2] then
          if Image.Canvas.Pixels[X2, Y2] <> clWhite then
        //if Bytes[3 * (Y2 * Image.Width + X2) + 0] <> 255 then
            Mark(S, X2, Y2);
  //Result := S;
end;
begin
  I := 0;
  Image.Picture.Bitmap.PixelFormat := pf24bit;
  BitmapToBytes(Image.Picture.Bitmap, Bytes, nBytes);
  for Y2 := 1 to 101 do
    for X2 := 1 to 101 do
      Marked[X2, Y2] := True;
  for X := 0 to 100 do
    for Y := 0 to 100 do
      if {Bytes[3 * (Y * 240 + X) + 0] <> 255}(Image.Canvas.Pixels[X, Y] <> clWhite) and (Marked[X, Y]) then
      begin
        //Form1.Caption := IntToStr(X) + ' ' + IntToStr(Y);
        //Inc(I);
        Min := Point(Image.Width, Image.Height);
        Max := Point(-1, -1);
        {for Y2 := 1 to 101 do
          for X2 := 1 to 101 do
            //Marked[X, Y] := True;
            Chars[I, X2, Y2] := 0;}
        Mark(Chars[I], X, Y);
        TrimImage(Chars[I]);
        //Form1.Image2.Picture.Bitmap.Canvas.Pixels[Min.X, Min.Y] := clRed;
        //Form1.Image2.Picture.Bitmap.Canvas.Pixels[Max.X, Max.Y] := clRed;
        Exit;
      end;
end;

{function Lines(BinPixels: TBinaryArray; Sensitivity: Word): Word;
  function LineToPoint(var BinPixels: TBinaryArray; Index: Word
  begin
  end;
begin

end;}

type
  TRealArray = array [1..36, 1..45] of Real;

const
  Aplha = 0.2;
  Chars: array [1..3] of Char = ('H', 'L', 'N');

var
  W: array['A'..'Z'] of TRealArray;

procedure BinaryToNeural(var BinPixels: TBinaryArray);
var
  X, Y: ShortInt;
begin
  for X := 1 to 12 do
    for Y := 1 to 15 do
      if BinPixels[X, Y] = 0 then
        BinPixels[X, Y] := -1;
end;

procedure NNRandomWeights(C: Char);
var
  X, Y: ShortInt;
begin
  Randomize;
  for X := 1 to 12 do
    for Y := 1 to 15 do
      W[C, X, Y] := Random - Random;
end;

procedure NNSaveWeights(C: Char);
var
  X, Y: ShortInt;
  F: TextFile;
begin
  AssignFile(F, C + '.txt');
  Rewrite(F);
  for Y := 1 to 15 do
  begin
    for X := 1 to 12 do
      Write(F, W[C, X, Y]:0:10, '	');
    Writeln(F);
  end;
  CloseFile(F);
end;

procedure NNSaveChar(BinPixels: TBinaryArray; C: Char);
var
  X, Y: ShortInt;
  F: TextFile;
begin
  AssignFile(F, C + '.txt');
  Rewrite(F);
  for Y := 1 to 15 do
  begin
    for X := 1 to 12 do
      Write(F, BinPixels[X, Y], '	');
    Writeln(F);
  end;
  CloseFile(F);
end;

procedure NNLoadWeights(C: Char);
var
  X, Y: ShortInt;
  F: TextFile;
begin
  AssignFile(F, C + '.txt');
  Reset(F);
  for Y := 1 to 15 do
  begin
    for X := 1 to 11 do
      Read(F, W[C, X, Y]);
    Readln(F, W[C, 12, Y]);
  end;
  CloseFile(F);
end;

procedure NNLoadChar(BinPixels: TBinaryArray; C: Char);
var
  X, Y: ShortInt;
  F: TextFile;
begin
  AssignFile(F, C + '.txt');
  Reset(F);
  for Y := 1 to 15 do
  begin
    for X := 1 to 11 do
      Read(F, BinPixels[X, Y]);
    Readln(F, BinPixels[12, Y]);
  end;
  CloseFile(F);
end;

function NNCharOut(BinPixels: TBinaryArray; C: Char): Real;
var
  X, Y: ShortInt;
begin
  Result := 0;
  for X := 1 to 12 do
    for Y := 1 to 15 do
      Result := Result + BinPixels[X, Y] * W[C, X, Y];
end;

procedure NNChangeWeights(C: Char; BinPixels: TBinaryArray; Target: ShortInt);
var
  X, Y: ShortInt;
begin
  for I := 1 to 3 do
    for X := 1 to 12 do
      for Y := 1 to 15 do
        if Chars[I] = C then
          W[C, X, Y] := W[C, X, Y] + Target * BinPixels[X, Y] * Aplha
        else
          if Target * BinPixels[X, Y] * Aplha > 0 then
            W[Chars[I], X, Y] := W[Chars[I], X, Y] - Target * BinPixels[X, Y] * Aplha;
end;

procedure CutImage(Image: TImage; var Image2: TImage);
var
  MinX, MinY, MaxX, MaxY, X, Y: Word;
begin
  Image2.AutoSize := True;
  Image2.Picture.Bitmap.Width := 0;
  Image2.Picture.Bitmap.Height := 0;
  Image2.Picture.Bitmap.Width := Image.Picture.Bitmap.Width;
  Image2.Picture.Bitmap.Height := Image.Picture.Bitmap.Height;
  MinX := Image.Picture.Width;
  MinY := Image.Picture.Height;
  MaxX:= 0;
  MaxY := 0;
  for X := 0 to Image.Picture.Width - 1 do
    for Y := 0 to Image.Picture.Height - 1 do
    if Bytes[3 * (Y * Image.Picture.Width + X) + 0] + Bytes[3 * (Y * Image.Picture.Width + X) + 1] + Bytes[3 * (Y * Image.Picture.Width + X) + 2] {< 3 * 255}{= 0}< 100 then
    begin
      if X < MinX then
        MinX := X;
      if Y < MinY then
        MinY := Y;
      if X > MaxX then
        MaxX := X;
      if Y > MaxY then
        MaxY := Y;
    end;
  for X := MinX to MaxX do
    for Y := MinY to MaxY do
      Image2.Canvas.Pixels[X - MinX, Y - MinY] := RGB(Bytes[3 * (Y * Image.Picture.Width + X) + 2], Bytes[3 * (Y * Image.Picture.Width + X) + 1], Bytes[3 * (Y * Image.Picture.Width + X) + 0]);
  Image2.Picture.Bitmap.Width := MaxX - MinX + 1 + 0;
  Image2.Picture.Bitmap.Height := MaxY - MinY + 1 + 0;
  Image2.AutoSize := False;
  Image2.Picture.Bitmap.Width := Image2.Picture.Bitmap.Width + (15 - Image2.Picture.Bitmap.Width mod 15) mod 15;
  Image2.Picture.Bitmap.Height := Image2.Picture.Bitmap.Height + (15 - Image2.Picture.Bitmap.Height mod 15) mod 15;
  Image2.Width := Image2.Picture.Bitmap.Width;
  Image2.Height := Image2.Picture.Bitmap.Height;
end;

procedure ResizeImage(Image: TImage; var Image2: TImage; Pixels: TBinaryArray; Width, Height: Word);
var
  MinX, MinY, MaxX, MaxY, X, Y: Word;
begin
  Image2.Picture := Image.Picture;
  MaxX:= 0;
  MaxY := 0;
  MinX := Image.Width - 1;
  MinY := Image.Height - 1;
  for X := 0 to Image{.Picture}.Width - 1 do
    for Y := 0 to Image{.Picture}.Height - 1 do
    if Bytes[3 * (Y * Image.Picture.Width + X) + 0] + Bytes[3 * (Y * Image.Picture.Width + X) + 1] + Bytes[3 * (Y * Image.Picture.Width + X) + 2] < 3 * 255 then
    //if Image.Canvas.Pixels[X, Y] = clBlack then
    begin
      if X > MaxX then
        MaxX := X;
      if Y > MaxY then
        MaxY := Y;
      if X < MinX then
        MinX := X;
      if Y < MinY then
        MinY := Y;
    end;
  for X := MinX to MaxX do
    for Y := MinY to MaxY do
      Image2.Canvas.Pixels[X - MinX, Y - MinY] := RGB(Bytes[3 * (Y * Image.Picture.Width + X) + 2], Bytes[3 * (Y * Image.Picture.Width + X) + 1], Bytes[3 * (Y * Image.Picture.Width + X) + 0]);
  Image2.AutoSize := True;
  Image2.Picture.Bitmap.Width := MaxX - MinX + 1 + 0;
  Image2.Picture.Bitmap.Height := MaxY - MinY + 1 + 0;
  Image2.Stretch := True;
  Image2.AutoSize := False;
  Image2.Width := Width;
  Image2.Height := Height;
  Image2.Picture.Bitmap.Width := Width;
  Image2.Picture.Bitmap.Height := Height;
  Image2.Picture.Bitmap.SaveToFile('Img.bmp');
  Image2.Picture.Bitmap.LoadFromFile('Img.bmp');
  for X := 0 to Image2{.Picture}.Width - 1 do
    for Y := 0 to Image2{.Picture}.Height - 1 do
      if Image2{.Picture.Bitmap}.Canvas.Pixels[X, Y] = clBlack then
        Pixels[X + 1, Y + 1] := 1
      else
        Pixels[X + 1, Y + 1] := 0;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  Image.Canvas.FillRect(Rect(0, 0, Image.Width, Image.Height));
  Moves := 0;
  I := 0;
end;

procedure TForm1.btnLoadWClick(Sender: TObject);
begin
  //NNLoadWeights(edtChar.Text[1]);
end;

procedure TForm1.btnNormalize2Click(Sender: TObject);
begin
  //Segmentate(Image2);
end;

procedure Histogram(Pixels: TBinaryArray; var Histograms: THistograms);
var
  X, Y: Word;
begin
  for Y := 1 to 15 do
  begin
    Histograms[1, Y] := 0;
    for X := 1 to 15 do
      Inc(Histograms[1, Y], Pixels[X, Y]);
  end;
  for X := 1 to 15 do
  begin
    Histograms[2, X] := 0;
    for Y := 1 to 15 do
      Inc(Histograms[2, X], Pixels[X, Y]);
  end;
end;

procedure ShowHistogram(Histograms: THistograms; Index: ShortInt; var StringGrid: TStringGrid);
var
  X, Y, J: ShortInt;
begin
  for X := 1 to StringGrid.ColCount - 1 do
    for Y := 1 to StringGrid.RowCount - 1 do
      StringGrid.Cells[X, Y] := '';
  //StringGrid.Cells[I, 1] := IntToStr(Histograms[Index, I]);
  for I := 1 to 15 do
    for J := 0 to Histograms[Index, I] do
      StringGrid.Cells[I, StringGrid.RowCount - 1 - J] := '1';
end;

procedure Connect(var Pixels: TBinaryArray); overload;
const
  Points: array [1..9] of TPoint = ((X:-1; Y:-1), (X:0; Y:-1), (X:+1; Y:-1), (X:+1; Y:0), (X:+1; Y:+1), (X:0; Y:+1), (X:-1; Y:+1), (X:-1; Y:0), (X:-1; Y:-1));
var
  Count: Integer;
  M: array [1..24, 1..30] of Boolean;
  P: array [1..8] of TPoint;
  A, B: Integer;
procedure Mark(X, Y: Integer; var A: Integer);
var
  X2, Y2: Integer;
begin
  M[X, Y] := true;
  Inc(A);
  {if (X1 = Y1) and (X2 = Y2) then
    if Dist < Min then
      Min := Dist;}
  for X2 := X - 1 to X + 1 do
    for Y2 := Y - 1 to Y + 1 do
      if X2 in [1..24] then
        if Y2 in [1..30] then
          if Pixels[X2, Y2] = 1 then
            if not M[X2, Y2] then
              Mark(X2, Y2, A);
end;
var
  AX, AY, X, Y: Integer;
begin
  for X := 1 to 24 do
    for Y := 1 to 30 do
    begin
      if Pixels[X, Y] = 0 then
      begin
        Count := 0;
        for I := 1 to 8 do
          if (X + Points[I].X in [1..24]) and (Y + Points[I].Y in [1..30]) and (X + Points[I + 1].X in [1..24]) and (Y + Points[I + 1].Y in [1..30]) then
            if (Pixels[X + Points[I].X, Y + Points[I].Y] = 1) and (Pixels[X + Points[I + 1].X, Y + Points[I + 1].Y] = 0) then
            begin
              Inc(Count);
              P[Count] := Point(X + Points[I].X, Y + Points[I].Y);
            end;
        if Count = 2 then
        begin
          //Form1.Caption := IntToStr(X) + ' ' + IntToStr(Y);
          for AX := 1 to 24 do
            for AY := 1 to 30 do
              M[AX, AY] := False;
          A := 0;
          B := 0;
          Mark(P[1].X, P[1].Y, A);
          for AX := 1 to 24 do
            for AY := 1 to 30 do
              M[AX, AY] := false;
          Mark(P[2].X, P[2].Y, B);
          if (Min(A, B) / Max(A, B) > 1 / 4 + 1 / 8) and (Min(A, B) > 5) then
          begin
            Pixels[X, Y] := 1;
            break;
          end;
        end;
      end;
    end;
end;

procedure TForm1.btnNormalizeClick(Sender: TObject);
var
  I: Integer;
  C: TCrosses;
  L: T2Int;
  elyar:THistogramelyar;
  h: Integer;
  //X, Y: Word;
begin
  Image.Picture.Bitmap.PixelFormat := pf24bit;
  imgBlurred.Picture.Bitmap.PixelFormat := pf24bit;
  imgCut.Picture.Bitmap.PixelFormat := pf24bit;
  imgSmall.Picture.Bitmap.PixelFormat := pf24bit;
  imgSmall2.Picture.Bitmap.PixelFormat := pf24bit;
  imgBlurred.Picture := Image.Picture;
  GaussianBlur(Image, imgBlurred, Matrix, Point(Radius, Radius), Sum);
  //Median(Image, imgMedian, Point(Radius2, Radius2));
  //Image2.Picture := imgBlurred.Picture;
  ImageToBin(imgBlurred, imgSmall, Pixels, 36, 45, 210);
  Connect(Pixels);
  ShowPixels(Pixels, imgSmall);

  ClearDots(Pixels, PartDots, PartChar, imgBlurred);
  BitmapToBytes(imgBlurred.Picture.Bitmap, Bytes, nBytes);
  CutImage(imgBlurred, imgCut);
  BitmapToBytes(imgCut.Picture.Bitmap, Bytes, nBytes);
  ImageToBin(imgCut, imgSmall3, Pixels2, 15, 15, 200);
  for I := 1 to 2 do
    Skeletonize(imgSmall3, Pixels2);
  TrimImage(imgSmall3, Pixels2);
  Histogram(Pixels2, Histograms);
  //ShowHistogram(Histograms, 1, StringGrid1);
  Joda(Pixels, PartDots, PartChar, imgSmall2);
  TrimImage(imgSmall2, Pixels2);
  for I := 1 to 4 do
    Skeletonize(imgSmall, Pixels);
  TrimImage(imgSmall, Pixels);
  Joda(Pixels, PartDots, PartChar, imgSmall2);
  TrimImage(PartDots);
  TrimImage(PartChar);
  C := Crosses(imgSmall, PartChar);
  L := Lines(imgSmall, PartChar);
  Closed := Baste(PartChar);
  Lines_1 := NemudarOfoqi(PartChar);
  Lines_2 := NemudarAmudi(PartChar);
  Dense := Tarakom(Pixels);
  Joda(Pixels, PartDots, PartChar, imgSmall2);
  Po := Noghte(Pixels);
  PoP := MakanNoghte(PartChar, PartDots);
  popo:=makannoghtehkh(PartChar, PartDots);
  Joda(Pixels, PartDots, PartChar, imgSmall2);
  //lblCrosses.Caption := 'تقاطع ها: ' + IntToStr(C[1] + C[2] + C[3] + C[4] + C[5] + C[6] + C[7] + C[8]);
  elyar[1]:=C[1] + C[2] + C[3] + C[4] + C[5] + C[6] + C[7] + C[8]{Crosses(PartChar)};
  //lblClosed.Caption := 'مناطق بسته: ' + IntToStr(Elyar[2]);
  elyar[3]:=lines_1;
  elyar[4]:=lines_2;
  //lblLinesH.Caption := 'خطوط افقی: ' + IntToStr(L[1]);
  //lblLinesV.Caption := 'خطوط عمودی: ' + IntToStr(L[2]);
  //lblMoves.Caption := 'تعداد حرکت ها: ' + IntToStr(Moves);
  //lblLinesH2.Caption := 'خطوط افقی(2): ' + IntToStr(Lines_1);
  //lblLinesV2.Caption := 'خطوط عمودی(2): ' + IntToStr(Lines_2);
  Elyar[5]:=Dense;
  //lblDensity.Caption := 'منطقه ی پرتراکم: ' + IntToStr(Elyar[5]);
  //ShowPixels(Pixels2,StringGrid1);
  //lblDots1.Caption := 'تعداد نقاط: ' + IntToStr(Po);
  //lblDots2.Caption := 'مکان نقاط: ' + IntToStr(PoP);
  for h := 6 to 20  do
    elyar[h]:=histograms[1,h - 5];
  for h := 21 to 35  do
    elyar[h]:=histograms[2,h - 20];
  Joda(Pixels, PartDots, PartChar, imgSmall2);
  Closed := Baste(Pixels2);
  elyar[2]:=Closed;
  lblRecognized2.Caption:=(anser(Elyar,pixels2,pixels,PartDots,po,pop,popo));
///   train;
  {BinaryToNeural(Pixels);
  lblResult.Caption := FloatToStr(NNCharOut(Pixels, edtChar.Text[1]));
  for X := 1 to 12 do
    for Y := 1 to 15 do
    begin
      if W[edtChar.Text[1], X, Y] > 0 then
        StringGrid1.Cells[X, Y] := '+';
      if W[edtChar.Text[1], X, Y] < 0 then
        StringGrid1.Cells[X, Y] := '-';
      //if Round(W[edtChar.Text[1], X, Y]) = 0 then
      //  StringGrid1.Cells[X, Y] := 'o';
    end;}
end;

procedure TForm1.btnRecognizeClick(Sender: TObject);
var
  J: ShortInt;
  Count: Byte;
  Ch, Ch2: Char;
  F: TextFile;
  H: THistograms;
  C2, Closed2, Mo2, Lines2_1, Lines2_2, Dense2, Po2, PoP2, Pixel: Integer;
  B, Max: LongInt;
  A: Real;
begin
  Max := 0;
  {Count := 0;
  for J := 1 to 15 do
    for I := 1 to 15 do
      if Pixels2[I, J] = Pixel then
        Inc(Count); }
  for Ch := 'A' to 'Z' do
  begin
    I := 1;
    while FileExists({edtPath.Text +} Ch + IntToStr(I) + '.txt') do
    begin
      AssignFile(F, {edtPath.Text +} Ch + IntToStr(I) + '.txt');
      Reset(F);
      Readln(F);
      Readln(F, C2);
      Readln(F);
      Readln(F, Closed2);
      Readln(F);
      Readln(F, Mo2);
      Readln(F);
      Readln(F, Lines2_1);
      Readln(F, Lines2_2);
      Readln(F);
      Readln(F, Dense2);
      Readln(F);
      Readln(F, Po2);
      Readln(F);
      Readln(F, PoP2);
      Readln(F);
      Readln(F);
      Readln(F);
      {for I := 1 to 14 do
        Read(F, H[1, I]);
      Readln(F, H[1, 15]);
      for I := 1 to 14 do
        Read(F, H[2, I]);
      Readln(F, H[2, 15]);}
      Readln(F);
      B := 0;
      A := 0;
      for J := 1 to 15 do
      begin
        for I := 1 to 14 do
        begin
          Read(F, Pixel);
          if Pixels2[I, J] = Pixel then
            if Pixel = 1 then
              A := A + 1
            else
              A := A + 1;
        end;
        Readln(F, Pixel);
        if Pixels2[I, J] = Pixel then
          if Pixel = 1 then
            A := A + 1
          else
            A := A + 1;
      end;
      B := B + Round(A);
      //Dec(B, 2 * Abs(C2 - (C[1] + C[2] + C[3] + C[4] + C[5] + C[6] + C[7] + C[8])));
      //Dec(B, 6 * Abs(Closed2 - Closed));
      //(B, 8 * Abs(Mo2 - Moves));
      Dec(B, 6 * Abs(Lines2_1 - Lines_1));
      Dec(B, 6 * Abs(Lines2_2 - Lines_2));
      if Dense = Dense2 then
        Inc(B, 5);
      if Moves <> Mo2 then
        Dec(B, 10);
      if Closed <> Closed2 then
        Dec(B, 10);
      if Po > 0 then
      begin
        Dec(B, 8 * Abs(Po2 - Po));
        if (PoP <> PoP2) and (Po2 > 0) then
          Dec(B, 10);
      end
      else
        if PoP2 > 0 then
          Dec(B, 10);
      {for J := 1 to 2 do
        for I := 1 to 15 do
        begin
          if (Histograms[J, I] > 0) and (H[J, I] > 0) then
          begin
            if Abs(Histograms[J, I] - H[J, I]) <= 0 then
              Inc(B, 3)
            else if Abs(Histograms[J, I] - H[J, I]) <= 1 then
              Inc(B, 2);
            if Abs(Histograms[J, I] - H[J, I]) >= 7 then
              Dec(B, 2)
            else if Abs(Histograms[J, I] - H[J, I]) >= 3 then
              Dec(B);
          end;
        end;}
      if B > Max then
      begin
        Max := B;
        Ch2 := Ch;
      end;
      CloseFile(F);
    end;
  end;
  Caption := Ch2 + ' ' + IntToStr(Max);
end;

procedure TForm1.btnSaveCharClick(Sender: TObject);
var
  F: TextFile;
  J: ShortInt;
begin
  AssignFile(F,adres+ edtChar.Text + '.txt');
  append(F);
  Writeln(F, 'Crosses:');
  Writeln(F, C[1] + C[2] + C[3] + C[4] + C[5] + C[6] + C[7] + C[8]);
  Writeln(F, 'Closed zones:');
  Writeln(F, Closed);
  {Writeln(F, 'Moves:');
  Writeln(F, Moves);   }
  Writeln(F, 'Lines:');
  Writeln(F, Lines_1);
  Writeln(F, Lines_2);
  Writeln(F, 'Dense zone:');
  Writeln(F, Dense);
  {Writeln(F, 'Dots:');
  Writeln(F, Po);
  Writeln(F, 'Dots place:');
  Writeln(F, PoP); }
  Writeln(F, 'Histograms:');
  for I := 1 to 15 do
    Write(F, Histograms[1, I], ' ');
  Writeln(F);
  for I := 1 to 15 do
    Write(F, Histograms[2, I], ' ');
  Writeln(F);
  Writeln(F, 'Pixels:');
  for J := 1 to 15 do
  begin
    for I := 1 to 15 do
      Write(F, Pixels2[I, J], ' ');
    Writeln(F);
  end;
  writeln(f,'End');
  //writeln(f,'');
  CloseFile(F);
  {if chbChar.Checked then
  begin
    if edtChar.Text[1] <> 'Z' then
      Ch := Chr(Ord(edtChar.Text[1]) + 1)
    else
      Ch := 'A';
  end;
  edtChar.Text:= Ch;}
  //*if chbNum.Checked then
  //*  seNum.Value := seNum.Value + 1;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage('تشخیص حروف فارسی نسخه 1.2' + #10#13 + 'نوشته شده توسّط عرفان علی محمّدی و الیار علیزاده');
end;

procedure TForm1.edtCharChange(Sender: TObject);
begin
  {*I := 1;
  while FileExists(edtPath.Text + edtChar.Text[1] + IntToStr(I) + '.txt') do
    Inc(I);
  seNum.Value := I;*}
end;

procedure TForm1.FormCreate(Sender: TObject);
{var
  X: Integer;
  s:string;}
begin
  randomi;
  {s:='eptedaroye آماده سازی برای تشخیص حرف click konid vasepas harf ';
s:=s+'khod ra dar ghesmat sefid balaye ye panjere benevisid va ro ye تشخیص حرف click konid va baraye pak kardan mitavanid az rast ';
s:=s+'click ya dokmeye پاک کردن estefade konidva va in horof ra mitavanid be  bedahid: ی-ه-و-ن-م-ل-گ-ک-ق-ف-غ-ع-ظ-ط-ض-ص-ش-س-ژ-ز-ر-ذ-د-ح-خ-چ-ج-ث-ت-پ-ب-ا-آ';
ShowMessage(s);}
  {for X := 0 to StringGrid1.ColCount - 1 do
    StringGrid1.Cells[X, 0] := IntToStr(X);
  for X := 0 to StringGrid1.RowCount - 1 do
    StringGrid1.Cells[0, X] := IntToStr(X);}
  Matrix := BlurMatrix(Point(Radius, Radius));
  openvazn;
  endofarraysetig;
end;

procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft:
    begin
      Image.Canvas.Pen.Color := clBlack;
      Image.Canvas.Pen.Width := 7;
      Inc(Moves);
    end;
    mbRight:
    begin
      Image.Canvas.Pen.Color := clWhite;
      Image.Canvas.Pen.Width := 8;
    end;
  end;
  Image.Canvas.MoveTo(X, Y);
  Image.Canvas.LineTo(X, Y);
end;

procedure TForm1.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) or (ssRight in Shift) then
  begin
    if ssLeft in Shift then
    begin
      Image.Canvas.Pen.Color := clBlack;
      Image.Canvas.Pen.Width := 7;
    end;
    if ssRight in Shift then
    begin
      Image.Canvas.Pen.Color := clWhite;
      Image.Canvas.Pen.Width := 8;
    end;
    Image.Canvas.LineTo(X, Y);
    if Count >= 12 then
    begin
      Inc (I);
      Pnt[I] := Point(X, Y);
      Count := 0;
    end;
    if Count < 12 then
      Count := Count + Dis(Last.X, Last.Y, X, Y);
    Last := Point (X, Y);
  end;
end;

procedure TForm1.opennvaznClick(Sender: TObject);
begin
{openvazn;
endofarraysetig;}
train;
//savevazn;
end;


procedure TForm1.rahnamayiClick(Sender: TObject);
var
s:string;
begin
s:='eptedaroye آماده سازی برای تشخیص حرف click konid vasepas harf ';
s:=s+'khod ra dar ghesmat sefid balaye ye panjere benevisid va ro ye تشخیص حرف click konid va baraye pak kardan mitavanid az rast ';
s:=s+'click ya dokmeye پاک کردن estefade konidva va in horof ra mitavanid be  bedahid: ی-ه-و-ن-م-ل-گ-ک-ق-ف-غ-ع-ظ-ط-ض-ص-ش-س-ژ-ز-ر-ذ-د-ح-خ-چ-ج-ث-ت-پ-ب-ا-آ';
ShowMessage(s);
end;

procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  {for Y := 1 to StringGrid1.ColCount - 1 do
    for X := 1 to StringGrid1.RowCount - 1 do
      if Pixels[X, Y] = 1 then
        imgSmall.Canvas.Pixels[X - 1, Y - 1] := clBlack
      else
        imgSmall.Canvas.Pixels[X - 1, Y - 1] := clWhite;
  Dec(ACol);
  Dec(ARow);
  imgSmall.Canvas.Pixels[ACol, ARow] := clRed;
  imgSmall.Canvas.Pixels[ACol - 1, ARow] := clRed;
  imgSmall.Canvas.Pixels[ACol, ARow - 1] := clRed;
  imgSmall.Canvas.Pixels[ACol + 1, ARow] := clRed;
  imgSmall.Canvas.Pixels[ACol, ARow + 1] := clRed;}
end;

end.


