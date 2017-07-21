program PutImage_Speedtest;

{$mode objfpc}{$H+}

uses
  sysutils,
  ptcgraph,
  ptccrt,
  agg_pixfmt_rgb_packed, //for pixfmt_rgb565
  agg_2D;

const
  IMAGE_WIDTH = 800;
  IMAGE_HEIGHT = 600;
  RGB_WIDTH =2; //16bit RGB565 format
  LINE_COUNT = 30;

type

TGraphBitmapBuffer=packed record
  width,
  height,
  reserved:	longint;//per info in http://lists.freepascal.org/pipermail/fpc-pascal/2017-June/051524.html
  data: 	array[0..RGB_WIDTH*IMAGE_WIDTH*IMAGE_HEIGHT-1] of byte;
end;

var
  gd,gm : smallint;
  graph_buffer,graph_buffer2: TGraphBitmapBuffer;

procedure DrawStuff(agg: Agg2D_ptr);
var
  i: Integer;
  x, y, px, py, d: Double;
  c1, c2: Color;
begin
  // draw a full screen graph with grid
  agg^.clearAll(0, 0, 0);
  agg^.lineColor(0, 0, 0, 255);
  agg^.lineWidth(3);
  agg^.rectangle(0, 0, IMAGE_WIDTH, IMAGE_HEIGHT);
  agg^.lineWidth(1);
  agg^.lineColor(0, 155, 0, 255);
  agg^.rectangle(10, 10, 50, 50);
//  agg^.font(fontfile, 16);
  d := IMAGE_WIDTH / LINE_COUNT;
  agg^.lineColor(0, 0, 0, 100);
  agg^.lineWidth(1);
  for i := 1 to LINE_COUNT - 1 do
  begin
    x := i * d;
    agg^.line(x, 0, x, IMAGE_HEIGHT);
  end;
  for i := 1 to trunc(IMAGE_HEIGHT / d) do
  begin
    y := i * d;
    agg^.line(0, y, IMAGE_WIDTH, y);
  end;
  x := 0;
  y := IMAGE_HEIGHT / 2;
  px := x;
  py := y;
  agg^.lineColor(255, 0, 0, 200);
  agg^.fillColor(0, 0, 0, 200);
  agg^.lineWidth(1);
  for i := 0 to LINE_COUNT - 1 do
  begin
    x := x + d;
    y := y + Random(Round(IMAGE_HEIGHT / 3)) - IMAGE_HEIGHT / 6;
    if y < 0 then
      y := IMAGE_HEIGHT / 6;
    if y >= IMAGE_HEIGHT then
      y := IMAGE_HEIGHT - IMAGE_HEIGHT / 6;
    agg^.line(px, py, x, y);
//    agg^.text(x, y, char_ptr(IntToStr(i) + ' point'));
    px := x;
    py := y;
  end;

  // Star shape
  agg^.LineCap(CapRound);
  agg^.LineWidth(5);
  agg^.LineColor($32 ,$cd ,$32 );
  c1.Construct(0, 0 , 255, 200);
  c2.Construct(0, 0, 255, 50);
  agg^.FillLinearGradient(100, 100, 150, 150, c1, c2);
  agg^.Star(100 ,150 ,30 ,70 ,55 ,5 );

  // Draw Arc from 45 degrees to 270 degrees
  agg^.LineColor($4C, $6C, $9C);
  agg^.LineWidth(5 );
  agg^.Arc(300 ,320 ,80 ,50 ,Deg2Rad(45 ) ,Deg2Rad(270 ) );
end;

procedure DrawAndDisplay;
var
  start,stop:double;
  agg: Agg2D_ptr;
  i:word;
begin
//agg draw
  New(agg, Construct(@pixfmt_rgb565));
  agg^.attach(@graph_buffer.data, IMAGE_WIDTH, IMAGE_HEIGHT, IMAGE_WIDTH * RGB_WIDTH);
  DrawStuff(agg);
  graph_buffer.width:=IMAGE_WIDTH;
  graph_buffer.height:=IMAGE_HEIGHT;
  ptcgraph.PutImage(0,0,graph_buffer,NormalPut);

        start:=now;
        For i:=1 to 1000 do
        begin
        ptcgraph.GetImage(0,0,Image_Width-1,Image_Height-1,graph_buffer);
        end;
        stop:=now-start;
        ptcgraph.PutImage(0,0,graph_buffer,NormalPut);
        setcolor($373);
        settextstyle(Defaultfont,HORIZDIR,2);
        outtextxy(240,30,'Finished in: '+FormatDateTime('ss.zzz',stop)+' Seconds');
        readkey;
        ptcgraph.GetImage(0,0,Image_Width-1,Image_Height-1,graph_buffer2);
        ptcgraph.PutImage(0,0,graph_buffer2,NotPut);

  Dispose(agg, Destruct); // not necessary to keep it after rendering is finished
end;


begin
  gd:=d16Bit;
  gm:=m800x600;
  ptcgraph.Initgraph(gd,gm,'');
  Randomize;
  DrawAndDisplay;
  ptccrt.readkey;
  ptcgraph.Closegraph;
end.

