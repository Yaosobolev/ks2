unit uLines;

interface
uses Types, Classes, Controls, Graphics, umAnimateLines;


const
	DEFAULT_COLOR1	= $00E80011;
  DEFAULT_COLOR2	= $000000FB;
	DEFAULT_COLOR3	= $000000FB;
  DEFAULT_WIDTH		= 1;
  DEFAULT_SENSV		= 5;
  DEF_ANIMATESPEED = 900;



type
	TmLineTypes	= (lt_line, lt_optic);

	TmLine = class
  protected
  	FPoints: TList;//����� �����
    FCanvas: TCanvas;
    FLType: TmLineTypes;

    FColor1,
    FCOlor2: TColor;
    FWidth: integer;
    FScale: integer;

    FAnimateThread: TmAnimateLines;

    procedure SetCanvas(cv: TCanvas);
    procedure SetColor(clr: TColor);
    procedure SetWidth(w: integer);
    function GetCount: integer;
    procedure SetLType(l: TmLineTypes);
    function GetLength: real;
    function GetCost: real;
    procedure SetScale(s: integer);
  public
  	Sensitivity: integer;//����������������
    Visible: boolean;

  	constructor Create;
    destructor Destroy; override;

    procedure Draw;
    procedure AddPoint(p: TPoint);
    procedure RemPoint(p: TPoint);
    procedure Animate(fromPoint, toPoint: PPoint); overload;
		procedure Animate(fromPoint: PPoint); overload;
    procedure Animate; overload;
    procedure Stop;

    property Canvas: TCanvas read FCanvas write SetCanvas;
    property Width: integer read FWidth write SetWidth;
    property Count: integer read GetCount;
    property LType: TmLineTypes read FLType write SetLType;
    property Length: real read GetLength;
    property Cost: real read GetCost;
    //�������, ������� �������� � 1 ��. ���.
    property Scale: integer read FScale write SetScale;
  end;

var
	LNCOSTS: array[TmLineTypes] of Real;  

implementation



function TmLine.GetCost: real;
begin
  Result:= Length * LNCOSTS[FLTYPE];
end;

function Distance(p1, p2: TPoint): real;
var
	k1, k2: real;
begin
  k1:= abs(p1.X-p2.X);
  k2:= abs(p1.Y-p2.Y);
  result:= sqrt(sqr(k1)+sqr(k2));
end;

function TmLine.GetLength: real;
var
	i: integer;
begin
	Result:= 0;
  for i:= 0 to FPoints.Count-2 do
		Result:= Result + Distance(TPoint(FPoints[i]^), TPoint(FPoints[i+1]^)) / Scale;
end;

procedure TmLine.SetScale(s: integer);
begin
	if s<=0 then s:= 1;
  FScale:= s;
end;

procedure TmLine.SetLType(l: TmLineTypes);
begin
	FLType:= l;
  Draw;
end;

function TmLine.GetCount: integer;
begin
	Result:= FPoints.Count;
end;

procedure TmLine.Stop;
begin
	if Assigned(FAnimateThread) then FAnimateThread.Terminate;
  FAnimateThread:= nil;
end;

procedure TmLine.Animate;
begin
	if FPoints.Count=0 then Exit;
	Animate(FPoints.Items[0], FPoints.Items[FPoints.Count-1]);
end;

procedure TmLine.Animate(fromPoint: PPoint);
begin
	if FPoints.Count=0 then Exit;
	if FPoints.IndexOf(fromPoint)=0 then//������ �����
  	Animate(fromPoint, FPoints.Items[FPoints.Count-1])
  else
    Animate(FPoints.Items[0], fromPoint);
end;

procedure TmLine.Animate(fromPoint, toPoint: PPoint);
var
	aInfo: TAmimateInfo;
  i1, i2: integer;
begin
	if not Assigned(FCanvas) then Exit;
  
	aInfo.Color1:=	FColor1;
  aInfo.Color2:=	FCOlor2;
  aInfo.width:=		FWidth;
  aInfo.Canvas:=	FCanvas;
  aInfo.Speed:=		DEF_ANIMATESPEED;

	i1:= FPoints.IndexOf(fromPoint);
  i2:= FPoints.IndexOf(toPoint);

  if (i1<0) OR (i2<0) then Exit;

  if i1>i2 then
  begin
    SetLength(aInfo.Points,   i1-i2+1);
		for i2:= i2 to i1 do aInfo.Points[i2]:= PPoint(FPoints.Items[i2])^;
  end else
  begin
  	SetLength(aInfo.Points,   i2-i1+1);
		for i1:= i1 to i2 do aInfo.Points[i1]:= PPoint(FPoints.Items[i1])^;
  end;

  FAnimateThread:= TmAnimateLines.Create(TRUE);
  FAnimateThread.AnimateInfo:= aInfo;
  FAnimateThread.Resume;
end;

procedure TmLine.SetColor(clr: TColor);
begin
	FColor1:= clr;
  Draw;
end;

procedure TmLine.SetWidth(w: integer);
begin
	FWidth:= w;
  Draw;
end;

procedure TmLine.Draw;
var
	i: integer;
  points: array of TPoint;
  oldColor: TColor;
  oldWidth: integer;
begin
	if not Visible then Exit;
  
	if Assigned(FCanvas) then
  begin
  	if FPoints.Count=0 then Exit;

    oldColor:= FCanvas.Pen.Color;
    oldWidth:= FCanvas.Pen.Width;
    if FLType=lt_line then FCanvas.Pen.Color:= DEFAULT_COLOR1
    else FCanvas.Pen.Color:= DEFAULT_COLOR2;
    FCanvas.Pen.Width:= FWidth;

  	SetLength(points, FPoints.Count);
    for i:= 0 to FPoints.Count-1 do points[i]:= PPoint(FPoints.items[i])^;
  	FCanvas.Polyline(points);

		FCanvas.Pen.Color:= oldColor;
    FCanvas.Pen.Width:= oldWidth;
    SetLength(points, 0);
  end;
end;

procedure TmLine.SetCanvas(cv: TCanvas);
begin
	FCanvas:= cv;
  Draw;
end;

procedure TmLine.RemPoint(p: TPoint);
var
	i: integer;
begin
	//���������, ��� ����� ������ ��������� ��������� �����
  //� ������� ��, ���� ����� ������� (� ������ ����������������)
	for i:= 0 to FPoints.Count-1 do
  begin
		if (abs(PPoint(FPoints.Items[i])^.X-p.X)<=Sensitivity)
    	AND (abs(PPoint(FPoints.Items[i])^.Y-p.Y)<=Sensitivity) then
      begin
      	FPoints.Delete(i);
        //Draw;
        Break;
      end;
  end;
end;

procedure TmLine.AddPoint(p: TPoint);
var
	pTmp: PPoint;
begin
	New(pTmp);
  pTmp^.X:= p.X;
  pTmp^.Y:= p.Y;
  FPoints.Add(pTmp);
  Draw;
end;

constructor TmLine.Create;
begin
	inherited Create;
  FPoints:= TList.Create;

  Scale:= 1;
  FColor1:= DEFAULT_COLOR1;
  FColor2:= DEFAULT_COLOR2;
  FWidth:=	DEFAULT_WIDTH;
  Sensitivity:= DEFAULT_SENSV;
  Visible:= TRUE;
end;

destructor TmLine.Destroy;
var
	i: integer;
begin
	for i:= 0 to FPoints.Count-1 do Dispose(PPoint(FPoints[i]));
  FPoints.Free;

  inherited Destroy;
end;

end.
