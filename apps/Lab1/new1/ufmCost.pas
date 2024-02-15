unit ufmCost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uCmn, ExtCtrls;

type
  TfmCost = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbLine: TLabel;
    lbSwitches: TLabel;
    lbWStation: TLabel;
    lbServers: TLabel;
    Label6: TLabel;
    lbTotal: TLabel;
    lbLineInfo: TLabel;
    Shape1: TShape;
    Shape2: TShape;
  private
    { Private declarations }
    procedure SetDescr(d: TmFlrDescription);
  public
    { Public declarations }
    property Description: TmFlrDescription write SetDescr;
  end;

var
  fmCost: TfmCost;

implementation

uses uLines;

{$R *.dfm}


procedure TfmCost.SetDescr(d: TmFlrDescription);
var
	fs: TFormatSettings;
begin
  fs.CurrencyDecimals:= 2;

  d.lnCost:= d.lnCost + d.lnCost+(LNCOSTS[lt_optic]*200);
	lbLine.Caption:= '�� ����� '+FloatToStr(d.lnCost, fs);
  lbLineInfo.Caption:= '����� ����� ������     '+FloatToStr(d.LineLn, fs);

  lbSwitches.Caption:= IntToStr(d.Switches)+' ��, �� ����� '+FloatToStr(d.sCost, fs);
  lbWStation.Caption:= IntToStr(d.WStations)+' ��, �� ����� '+FloatToStr(d.wCost, fs);
  lbServers.Caption:= IntToStr(d.Servers)+' ��, �� ����� '+FloatToStr(d.srvCost, fs);

  lbTotal.Caption:= FloatToStr(d.lnCost+d.Switches+d.wCost+d.srvCost, fs);
end;

end.
