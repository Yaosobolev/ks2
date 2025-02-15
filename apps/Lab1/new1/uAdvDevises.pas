unit uAdvDevises;

interface
uses Types, uDevise, SysUtils, Classes, ExtCtrls, uCmn, uLines;


const
	SWITCH_PIC	= '\pictures\Switch_1.bmp';
  SERVER_PIC	= '\pictures\Server.bmp';
  WSTATION_PIC=	'\pictures\Workstation.bmp';


type
	TmSwitch = class(TmDevice)
  protected
    function GetDeviceInfoStr: string; override;
    procedure SendMesage(mes: TmMessages);
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure mMesage(mes: TmMesInfo); override;
    function GetConnectionPos(i: integer): TPoint; override;

    property Count: integer read FCount write SetCount;
  end;

  TmWorkstation = class(TmDevice)
  protected

  	function GetDeviceInfoStr: string; override;
    procedure SendMesage(mes: TmMessages);
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure mMesage(mes: TmMesInfo); override;
  end;

  TmServer = class(TmDevice)
  protected


		function GetDeviceInfoStr: string; override;
  	procedure SendMesage(mes: TmMessages);
  public
  	constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure mMesage(mes: TmMesInfo); override;
  end;



  
implementation



function TmWorkstation.GetDeviceInfoStr: string;
begin
	Result:= '������� �������'+#10#13+
  					'-----------------';
end;

function TmServer.GetDeviceInfoStr: string;
begin
	Result:= '������'+#10#13+
  					'-----------------';
end;

procedure TmWorkstation.SendMesage(mes: TmMessages);
var
	i, cnt: integer;
  m: TmMesInfo;
begin
	case mes of
  mm_Ping:
  	begin
    end;
  mm_Rmv:
  	begin
    	cnt:= FRmtDevices.Count-1;
      for i:= 0 to cnt do//�������� ����
      begin
      	m.Mes:= mm_Rmv;
        m.sDev:= Self;

        if i<cnt then
        begin
        	m.rDev:= TmDevice(FRmtDevices[i+1]);
        	m.rLine:= TmLine(FLines[i+1]);
        end else
        begin//���������� ������ �� ������
        	if cnt=0 then
          begin//���� ����� ���� � ������
          	m.rDev:= nil;
        		m.rLine:= nil;
          end else
          begin
        		m.rDev:= TmDevice(FRmtDevices[0]);
        		m.rLine:= nil;//TmLine(FLines[0]);
          end;
        end;

      	TmDevice(FRmtDevices[i]).mMesage(m);
      end;
      for i:= 0 to FLines.Count-1 do//�������� ����� ����� �� �����
      	TmLine(Flines[i]).RemPoint(GetConnectionPos(i));
    end;
  end;
end;

procedure TmServer.SendMesage(mes: TmMessages);
var
	i, cnt: integer;
  m: TmMesInfo;
begin
	case mes of
  mm_Ping:
  	begin
    end;
  mm_Rmv:
  	begin
    	cnt:= FRmtDevices.Count-1;
      for i:= 0 to cnt do//�������� ����
      begin
      	m.Mes:= mm_Rmv;
        m.sDev:= Self;

        if i<cnt then
        begin
        	m.rDev:= TmDevice(FRmtDevices[i+1]);
        	m.rLine:= TmLine(FLines[i+1]);
        end else
        begin//���������� ������ �� ������
        	if cnt=0 then
          begin//���� ����� ���� � ������
          	m.rDev:= nil;
        		m.rLine:= nil;
          end else
          begin
        		m.rDev:= TmDevice(FRmtDevices[0]);
        		m.rLine:= nil;//TmLine(FLines[0]);
          end;
        end;

      	TmDevice(FRmtDevices[i]).mMesage(m);
      end;
      for i:= 0 to FLines.Count-1 do//�������� ����� ����� �� �����
      	TmLine(Flines[i]).RemPoint(GetConnectionPos(i));
    end;
  end;
end;

function TmSwitch.GetConnectionPos(i: integer): TPoint;
begin
	Result:= Position;
  Result.X:= Left + i*(width div FCount);
end;

procedure TmSwitch.SendMesage(mes: TmMessages);
var
	i: integer;
  m: TmMesInfo;
begin
	case mes of
  mm_Ping:
  	begin
    end;
  mm_Rmv:
  	begin
      for i:= 0 to FRmtDevices.Count-1 do//�������� ����
      begin
      	m.Mes:= mm_Rmv;
        m.sDev:= Self;
        m.rDev:= nil;
        m.rLine:= nil;

      	TmDevice(FRmtDevices[i]).mMesage(m);
      end;
      for i:= 0 to FLines.Count-1 do//�������� ����� ����� �� �����
      	TmLine(Flines[i]).RemPoint(GetConnectionPos(i));
    end;
  end;
end;

procedure TmSwitch.mMesage(mes: TmMesInfo);
var
	i: integer;
begin
	case mes.Mes of
  mm_Ping:
  	begin
    end;
  mm_Rmv:
  	begin//����������, ��������� ���������, ���� �������
    	if mes.rDev<>nil then
      begin//������ �� ������
        i:= FRmtDevices.IndexOf(mes.sDev);
        if FRmtDevices.IndexOf(mes.rDev)<0 then//���� ������ ���������� ��� ��� � ������
        begin
        	FRmtDevices[i]:= mes.rDev;//�������� ��������� �����
          TmLine(FLines[i]).RemPoint(GetConnectionPos(i));//������� ���� ����� �� ������ �����
          mes.rLine.AddPoint(GetConnectionPos(i));//�������� � ����� �����
          FLines[i]:= mes.rLine;//��������� ������ �� �����
        end;
      end else
      begin//������ ��������
      	i:= FRmtDevices.IndexOf(mes.sDev);
        FRmtDevices.Delete(i);//������� ������ �� �-�� �� ������
        TmLine(FLines[i]).RemPoint(GetConnectionPos(i));//������� ���� ����� �� �����
        FLines.Delete(i);//������� ������ �� �����
      end;
    end;
  end;
end;

procedure TmWorkstation.mMesage(mes: TmMesInfo);
var
	i: integer;
begin
	case mes.Mes of
  mm_Ping:
  	begin
    end;
  mm_Rmv:
  	begin
    	if mes.rDev<>nil then
      begin//������ �� ������
        i:= FRmtDevices.IndexOf(mes.sDev);
        if FRmtDevices.IndexOf(mes.rDev)<0 then//���� ������ ���������� ��� ��� � ������
        begin
        	FRmtDevices[i]:= mes.rDev;//�������� ��������� �����
          if mes.rLine<>nil then
          begin
          	TmLine(FLines[i]).RemPoint(GetConnectionPos(i));//������� ���� ����� �� ������ �����
          	mes.rLine.AddPoint(GetConnectionPos(i));//�������� � ����� �����
          	FLines[i]:= mes.rLine;//��������� ������ �� �����
          end;
          Exit;
        end;
      end;
      //������ ��������
      i:= FRmtDevices.IndexOf(mes.sDev);
      FRmtDevices.Delete(i);//������� ������ �� �-�� �� ������
      TmLine(FLines[i]).RemPoint(GetConnectionPos(i));//������� ���� ����� �� �����
      FLines.Delete(i);//������� ������ �� �����
    end;
  end;
end;

procedure TmServer.mMesage(mes: TmMesInfo);
var
	i: integer;
begin
	case mes.Mes of
  mm_Ping:
  	begin
    end;
  mm_Rmv:
  	begin
    	if mes.rDev<>nil then
      begin//������ �� ������
        i:= FRmtDevices.IndexOf(mes.sDev);
        if FRmtDevices.IndexOf(mes.rDev)<0 then//���� ������ ���������� ��� ��� � ������
        begin
        	FRmtDevices[i]:= mes.rDev;//�������� ��������� �����
          if mes.rLine<>nil then
          begin
          	TmLine(FLines[i]).RemPoint(GetConnectionPos(i));//������� ���� ����� �� ������ �����
          	mes.rLine.AddPoint(GetConnectionPos(i));//�������� � ����� �����
          	FLines[i]:= mes.rLine;//��������� ������ �� �����
          end;
          Exit;
        end;
      end;
      //������ ��������
      i:= FRmtDevices.IndexOf(mes.sDev);
      FRmtDevices.Delete(i);//������� ������ �� �-�� �� ������
      TmLine(FLines[i]).RemPoint(GetConnectionPos(i));//������� ���� ����� �� �����
      FLines.Delete(i);//������� ������ �� �����
    end;
  end;
end;


function TmSwitch.GetDeviceInfoStr: string;
begin
	Result:= '����������'+#10#13+
  					'-----------------'+#10+#13+
  					' ������ '+IntToStr(FCount)+#10#13+
            ' ������ '+IntToStr(FRmtDevices.Count);
end;

constructor TmServer.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

  FDType:= dt_Server;
  Picture.LoadFromFile(ExePath+SERVER_PIC);
  FOrigPic.Assign(Picture);
  AutoSize:=		TRUE;
	Transparent:=	TRUE;

  FCount:= 3;
end;

destructor TmServer.Destroy;
begin
	SendMesage(mm_Rmv);

	inherited Destroy;
end;


constructor TmWorkstation.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

  FDType:= dt_Workstation;
	Picture.LoadFromFile(ExePath+WSTATION_PIC);
  FOrigPic.Assign(Picture);
  AutoSize:=		TRUE;
	Transparent:=	TRUE;

  FCount:= 3;
end;

destructor TmWorkstation.Destroy;
begin
  SendMesage(mm_Rmv);

	inherited Destroy;
end;

constructor TmSwitch.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);

	FDType:= dt_Switch;  
 	Picture.LoadFromFile(ExePath+SWITCH_PIC);
  FOrigPic.Assign(Picture);
  AutoSize:=		TRUE;
	Transparent:=	TRUE;

  FRmtDevices:= TList.Create;
  FLines:=			TList.Create;
end;

destructor TmSwitch.Destroy;
begin
	SendMesage(mm_Rmv);

	inherited Destroy;
end;

end.
