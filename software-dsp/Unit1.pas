unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, Series, TeEngine, TeeProcs, Chart,
  ComCtrls, CPort,Math;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Chart2: TChart;
    Label27: TLabel;
    Label34: TLabel;
    Series1: TFastLineSeries;
    Chart3: TChart;
    Label31: TLabel;
    Label35: TLabel;
    Series2: TFastLineSeries;
    Chart1: TChart;
    Label1: TLabel;
    Label2: TLabel;
    FastLineSeries1: TFastLineSeries;
    GroupBox2: TGroupBox;
    Chart4: TChart;
    Label3: TLabel;
    Label4: TLabel;
    FastLineSeries2: TFastLineSeries;
    Chart5: TChart;
    Label5: TLabel;
    Label6: TLabel;
    FastLineSeries3: TFastLineSeries;
    GroupBox3: TGroupBox;
    RdBttnButterworth: TRadioButton;
    RdBttnChebyshev: TRadioButton;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    RdBttnLowPass: TRadioButton;
    RdBttnHiPass: TRadioButton;
    RdBttnBandPass: TRadioButton;
    RdBttnBandStop: TRadioButton;
    Label8: TLabel;
    Label9: TLabel;
    EditFcLow: TEdit;
    EditFcHi: TEdit;
    ButtonFrekRespFilter: TButton;
    ButtonFiltering: TButton;
    GroupBox6: TGroupBox;
    BttnLoadFile: TButton;
    EditLoadNamaFile: TEdit;
    Panel1: TPanel;
    LabelNamaFile: TLabel;
    LabelTimeSampling: TLabel;
    GroupBox7: TGroupBox;
    RdBttn100Hz: TRadioButton;
    RdBttn200Hz: TRadioButton;
    RdBttn500Hz: TRadioButton;
    RdBttn1000Hz: TRadioButton;
    RdBttn2000Hz: TRadioButton;
    BttnPortSetting: TButton;
    GroupBox10: TGroupBox;
    S1: TShape;
    S2: TShape;
    ButtonSaveFile: TButton;
    EditSaveNamaFile: TEdit;
    Label12: TLabel;
    EditMaxData: TEdit;
    ComPort1: TComPort;
    GroupBox8: TGroupBox;
    Label20: TLabel;
    Label21: TLabel;
    EditAmp1: TEdit;
    EditFrek1: TEdit;
    GroupBox9: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    EditAmp2: TEdit;
    EditFrek2: TEdit;
    GroupBox11: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    EditAmp3: TEdit;
    EditFrek3: TEdit;
    SpeedBttnSinyalCampur: TSpeedButton;
    Label13: TLabel;
    Label14: TLabel;
    EditA1: TEdit;
    EditA2: TEdit;
    EditB0: TEdit;
    EditB1: TEdit;
    EditB2: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    OpenDialog1: TOpenDialog;
    SpdBttnAdcToRam: TSpeedButton;
    SpdBttnGetDataRam: TSpeedButton;
    SpdBttnOpenPort: TSpeedButton;
    RdBttnOrde2: TRadioButton;
    RdBttnOrde4: TRadioButton;
    EditA3: TEdit;
    EditA4: TEdit;
    EditB3: TEdit;
    EditB4: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    EditA0: TEdit;
    Label26: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    procedure delay(lama:longint);
    procedure GetParammeter;
    procedure DFT;
    procedure SpeedBttnSinyalCampurClick(Sender: TObject);
    procedure ButtonFrekRespFilterClick(Sender: TObject);
    procedure GetKoefisienFilter;
    procedure ButtonFilteringClick(Sender: TObject);
    procedure RdBttnLowPassClick(Sender: TObject);
    procedure RdBttnHiPassClick(Sender: TObject);
    procedure BttnLoadFileClick(Sender: TObject);
    procedure baca_data(nfile:string);
    procedure BttnPortSettingClick(Sender: TObject);
    procedure SpdBttnOpenPortClick(Sender: TObject);
    procedure SpdBttnAdcToRamClick(Sender: TObject);
    procedure SpdBttnGetDataRamClick(Sender: TObject);
    procedure ButtonSaveFileClick(Sender: TObject);
    procedure SimpanFile(nFile:string);
    procedure RdBttnBandPassClick(Sender: TObject);
    procedure RdBttnBandStopClick(Sender: TObject);
    procedure EnabledSaveFile;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
//------------------------------------parameter data
  FrekSampling,MaxFrek:integer;
  MaxData,MaxDataIn:integer;
//------------------------------------parameter filter
  JenisFilter,TipeFilter: string;
  Order,FcLow,FcHi: Integer;
  TimeSampling:real;
//------------------------------------parameter DFT
  H_real,H_imj: array [0..1024] of real;
  X,Y,OuputFFT: array [-20..1024] of real;
  Filtered:boolean;
//------------------------------------KOEFISIEN filter
  b0,b1,b2,b3,b4,a0,a1,a2,a3,a4 : real;
//------------------------------------parameter File
  filename                : textfile;
  files                   : string;
  opnFile                 : string;
  volt4                   : array [0..2048] of real;
  time                    : array [0..2048] of real;
  lab1                    :string;
  lab2                    :string;
//------------------------------------Parameter Serial ADC
  PortOpen: Boolean;
implementation

{$R *.dfm}
//================================Delay
procedure TFORM1.delay(lama:longint);
var ref:longint;
begin
  ref:=gettickcount;
  repeat application.processmessages;
  until ((gettickcount-ref)>=lama);
end;

//================================GET Init PARAMETER
procedure TForm1.GetParammeter;
begin
//------------------seleksi jenis & tipe filter
  if RdBttnButterworth.checked = true then
      JenisFilter:= 'Butterworth';
  if RdBttnChebyshev.checked = true then
      JenisFilter:= 'Chebyshev';
//---
  if RdBttnLowPass.checked = true then
      TipeFilter:= 'LowPass';
  if RdBttnHiPass.checked = true then
      TipeFilter:= 'HiPass';
  if RdBttnBandPass.checked = true then
      TipeFilter:= 'BandPass';
  if RdBttnBandStop.checked = true then
      TipeFilter:= 'BandStop';
//------------------get parameter filter
  if RdBttnOrde2.checked = true then Order:=2;
  if RdBttnOrde4.checked = true then Order:=4;
  FcLow:=strtoint(EditFcLow.text);
  FcHi :=strtoint(EditFcHi.text);
//------------------get parameter sampling
  if RdBttn100Hz.checked = true then
      FrekSampling:= 100;
  if RdBttn200Hz.checked = true then
      FrekSampling:= 200;
  if RdBttn500Hz.checked = true then
      FrekSampling:= 500;
  if RdBttn1000Hz.checked = true then
      FrekSampling:= 1000;
  if RdBttn2000Hz.checked = true then
      FrekSampling:= 2000;
//---
  MaxFrek     :=Round(FrekSampling/2);
  TimeSampling:=1/FrekSampling;
  EditMaxData.text:= inttostr(MaxFrek);
  MaxData     :=StrToInt(EditMaxData.text);
//---
  Chart2.BottomAxis.Maximum:=MaxData;
  Chart2.BottomAxis.Minimum:=0;
end;

//================================DFT
procedure TForm1.DFT ;
var I,J :integer;
begin
  Series2.Clear;
//----------------------------------get DFT Sinyal
  for i := 0 to MaxFrek-1 do
  begin
    H_real[i] := 0;
    H_imj[i]  := 0;
//-----------------------
    for j := 0 to MaxData-1 do
    begin
      H_real[i]:= H_real[i] + X[j]*cos(pi*i*j/MaxFrek);
      H_imj[i] := H_imj[i]  - X[j]*sin(pi*i*j/MaxFrek);
    end;
//---
    OuputFFT[i] := (sqrt(sqr(H_real[i])+sqr(H_imj[i]))/(MaxFrek/2));
//--------------Plot DFT Sinyal Campuran
    Series2.AddXY(I,OuputFFT[i]);
  end;
end;

//================================GET SINYAL CAMPUR
procedure TForm1.SpeedBttnSinyalCampurClick(Sender: TObject);
var
  i : integer;
  A1,F1,A2,F2,A3,F3: real;
begin
  ButtonFiltering.Enabled:=false;
  Series1.clear ;//Plot Sinyal asli
  Series2.clear ;//Spektrum sinyal asli
  FastLineSeries2.Clear;
  FastLineSeries3.Clear;
  GetParammeter;
//----------------------------------get parameter
  A1:= StrToFloat(EditAmp1.Text);
  F1:= StrToFloat(EditFrek1.Text);
  A2:= StrToFloat(EditAmp2.Text);
  F2:= StrToFloat(EditFrek2.Text);
  A3:= StrToFloat(EditAmp3.Text);
  F3:= StrToFloat(EditFrek3.Text);
//----------------------------------get Sinyal Campuran
  for i:= 0 to MaxData do
    begin
    X[i]:= (A1*sin(pi*F1*i/MaxFrek))
          +(A2*sin(pi*F2*i/MaxFrek))
          +(A3*sin(pi*F3*i/MaxFrek));
//--------Plot Sinyal Campuran
    Series1.AddXY(i,X[i]);
    Volt4[i]:=X[i];
    end;

//----------------------------------get DFT Sinyal Campuran
    DFT;
//-------------------------------data filter ready
  ButtonFiltering.Enabled:=true;
  MaxDataIn:=MaxData;
  EnabledSaveFile;
end;

//==========================GET FREKUENSI RESPONSE FILTER
procedure TForm1.ButtonFrekRespFilterClick(Sender: TObject);
var
  H_Atas,H_Bawah:real;
  H_omega : array [0..1024] of real;
  i:integer;
begin
  GetParammeter;
//---------------------------
  GetKoefisienFilter;
//-----------------------
  FastLineSeries1.Clear;
//----------------Estimasi Frekuensi Respon Magnitude H
  for i:= 0 to MaxFrek do
    begin
//--------Magnitude H Numerator
    H_Atas:= sqrt(
//-----Real Numerator
               (sqr(B0
                   +B1*cos(1*pi*i/MaxFrek)
                   +B2*cos(2*pi*i/MaxFrek)
                   +B3*cos(3*pi*i/MaxFrek)
                   +B4*cos(4*pi*i/MaxFrek)))+
//-----Imajiner Numerator
                (sqr(B1*sin(1*pi*i/MaxFrek)
                    +B2*sin(2*pi*i/MaxFrek)
                    +B3*sin(3*pi*i/MaxFrek)
                    +B4*sin(4*pi*i/MaxFrek))));
//--------Magnitude H Denumerator
        H_Bawah:= sqrt(
//-----Real Denumerator
                (sqr(1
                    +A1*cos(1*pi*i/MaxFrek)
                    +A2*cos(2*pi*i/MaxFrek)
                    +A3*cos(3*pi*i/MaxFrek)
                    +A4*cos(4*pi*i/MaxFrek)))+
//-----Imaj Denumerator
                (sqr(A1*sin(1*pi*i/MaxFrek)
                    +A2*sin(2*pi*i/MaxFrek)
                    +A3*sin(3*pi*i/MaxFrek)
                    +A4*sin(4*pi*i/MaxFrek))));
//--------Magnitude H
        H_omega[i]   := H_Atas/H_Bawah;
        FastLineSeries1.AddXY(i,H_omega[i]);
      end;
end;
//==========================GET SINYAL TERFILTER
procedure TForm1.ButtonFilteringClick(Sender: TObject);
var
  i,j:integer;
begin
  GetParammeter;
//---------------------------
  GetKoefisienFilter;
//----------------------------------FILTERING
  FastLineSeries2.Clear;
//------------------------
  for i:=1 to 20 do
    begin
    Y[1-i]:= 0;
    X[1-i]:= 0;
    end;
//-----------------------
  for i:=0 to MaxData do
  begin
    Y[i]:= B0*x[i]
          +B1*x[i-1]
          +B2*x[i-2]
          +B3*x[i-3]
          +B4*x[i-4]
//-------
          -A1*y[i-1]
          -A2*y[i-2]
          -A3*y[i-3]
          -A4*y[i-4];
    FastLineSeries2.AddXY(i,y[i]);
  end;

//----------------------------------get DFT Sinyal Terfilter
  FastLineSeries3.Clear;
  for i := 0 to MaxFrek-1 do
  begin
    H_real[i] := 0;
    H_imj[i]  := 0;
//-----------------------
    for j := 0 to MaxData-1 do
    begin
      H_real[i]:= H_real[i] + Y[j]*cos(pi*i*j/MaxFrek);
      H_imj[i] := H_imj[i]  - Y[j]*sin(pi*i*j/MaxFrek);
    end;
//---
    OuputFFT[i] := (sqrt(sqr(H_real[i])+sqr(H_imj[i]))/(MaxFrek/2));
//--------------Plot DFT Sinyal Terfilter
    FastLineSeries3.AddXY(I,OuputFFT[i]);
  end;
end;

//===================================GET KOEFISISEN FILTER
procedure TForm1.GetKoefisienFilter;
Label
  LowPassOrder2,LowPassOrder4,
  HiPassOrder2,HiPassOrder4,
  BandPassOrder2,BandPassOrder4,
  BandStopOrder2,BandStopOrder4,Normalisasi;
var
  t, rad, sinus, cosinus, tan : real;
  M, Wa,Wah,Wal,W,W02         : real;
  b_Hp, a1_Hp, a2_Hp, a3_Hp   : real;
  Fc,Fh,Fl: integer;
//-------
  C,D,F,G,H,I,J,K :real;
  S:string;
begin
//-----------------------hitung parameter awal
  Fc:= FcLow;
  if TipeFilter= 'LowPass' then Fc:= FcLow;
  if TipeFilter= 'HiPass' then Fc:= FcHi;
  if TipeFilter= 'BandPass' then
    begin
     Fh:= FcHi;
     Fl:= FcLow;
    end;
  if TipeFilter= 'BandStop' then
    begin
     Fh:= FcHi;
     Fl:= FcLow;
    end;
  T       := TimeSampling; // 1/FrekSampling;  //T:=1/Ns
  M       := 2/T;
//------------------Parameter LoPas-BandPas
  Rad     := 2*pi*Fc*T/2;
  Sinus   := sin(rad);
  Cosinus := cos(rad);
  tan     := sinus/cosinus;
  wa      := M*tan; //// (2/T) Tan(2*pi*f*t/2)//

//-------------------Parameter BandPas-BandStop
  Rad     := 2*pi*Fh*T/2;
  Sinus   := sin(rad);
  Cosinus := cos(rad);
  tan     := sinus/cosinus;
  wah     := M*tan;
//-------lo
  Rad     := 2*pi*Fl*T/2;
  Sinus   := sin(rad);
  Cosinus := cos(rad);
  tan     := sinus/cosinus;
  wal     := M*tan;
//-------center Frek-Bandwith
  w02     := wah * wal;
  W       := wah - wal;
//
//----------------------seleksi tipe filter
  if TipeFilter= 'LowPass' then
    begin
    if order=2 then goto LowPassOrder2;
    if order=4 then goto LowPassOrder4;
    end;
//----hi
  if TipeFilter= 'HiPass' then
    begin
    if order=2 then goto HiPassOrder2;
    if order=4 then goto HiPassOrder4;
    end;
//----band
  if TipeFilter= 'BandPass' then
    begin
    if order=2 then goto BandPassOrder2;
    if order=4 then goto BandPassOrder4;
    end;
//-----stop
  if TipeFilter= 'BandStop' then
    begin
    if order=2 then goto BandStopOrder2;
    if order=4 then goto BandStopOrder4;
    end;
//
//========================================LOW PASS FILTER
LowPassOrder2:
  b_Hp    := sqr(wa);
  a1_Hp   := 1;
  a2_Hp   := 1.4142*wa;
  a3_Hp   := sqr(wa);
//-------
  b0 :=  b_Hp;
  b1 := b_Hp*2;
  b2 := b_Hp;
  b3 := 0;
  b4 := 0;
//--
  a0 := (a1_Hp*sqr(M))+(a2_Hp*M)+(a3_Hp);
  a1 := (a1_Hp*sqr(M)*-2)+(sqr(wa)*2);
  a2 := (a1_Hp*sqr(M))+(a2_Hp*M*-1)+(a3_Hp);
  a3 := 0;
  a4 := 0;
//-------normalisasi
  GoTo Normalisasi;
//------------------------
LowPassOrder4:
  C := 2.6131 ; D:=3.4142 ; G:= C*Wa*Wa*Wa ;
  H := D*Wa*Wa; I:=C*Wa;    J:= Wa*Wa*Wa*Wa;
//--------
{
  b0 := J;
  b1 := 4*J;
  b2 := 6*J;
  b3 := 4*J;
  b4 := J;
}
  b0 := Wa*Wa*Wa*Wa;
  b1 := 4*Wa*Wa*Wa*Wa;
  b2 := 6*Wa*Wa*Wa*Wa;
  b3 := 4*Wa*Wa*Wa*Wa;
  b4 := Wa*Wa*Wa*Wa;
//--------
{
  a0 := (M*M*M*M) + G*M*M*M + H*M*M + I*M + J;
  a1 := -4*(M*M*M*M) - 2*G*M*M*M - 2*H*M*M + 2*I*M + 4*J;
  a2 := 6*M*M*M*M - 2*H*M*M + 6*J;
  a3 := -4*(M*M*M*M) + 2*G*M*M*M + 4*J;
  a4 := (M*M*M*M) - G*M*M*M + H*M*M - I*M + J;
}
  a0 := (M*M*M*M) + 2.6131*Wa*M*M*M + 3.4142*Wa*Wa*M*M + 2.6131*Wa*Wa*Wa*M + Wa*Wa*Wa*Wa;
  a1 := -4*(M*M*M*M) - 2*2.6131*Wa*M*M*M + 0 + 2*2.6131*Wa*Wa*Wa*M + 4*Wa*Wa*Wa*Wa;
  a2 := 6*M*M*M*M + 0 - 2*3.4142*Wa*Wa*M*M + 0 + 6*Wa*Wa*Wa*Wa;
  a3 := -4*(M*M*M*M) + 2*2.6131*Wa*M*M*M + 0 - 2*2.6131*Wa*Wa*Wa*M + 4*Wa*Wa*Wa*Wa;
  a4 := (M*M*M*M) - 2.6131*Wa*M*M*M + 3.4142*Wa*Wa*M*M - 2.6131*Wa*Wa*Wa*M + Wa*Wa*Wa*Wa;
//-------normalisasi
  GoTo Normalisasi;
//
//
//========================================HIGH PASS FILTER
HiPassOrder2:
  b_Hp    := 1;
  a1_Hp   := sqr(wa);
  a2_Hp   := 1.4142*wa;
  a3_Hp   := 1;
//---------------
  b0 :=  sqr(M);
  b1 := sqr(M)*-2;
  b2 := sqr(M);
  b3 := 0;
  b4 := 0;
//---
  a0 := (a1_Hp)+(a2_Hp*M)+(sqr(M));
  a1 := (a1_Hp*2)+(sqr(M)*-2);
  a2 := (a1_Hp)+(a2_Hp*M*-1)+(sqr(M));
  a3 := 0;
  a4 := 0;
//-------normalisasi
  GoTo Normalisasi;
//---------------------------
HiPassOrder4:
  C := 2.6131 ; D:=3.4142 ; G:= C*Wa;
  H := D*Wa*Wa; I:=C*Wa*Wa*Wa; J:= Wa*Wa*Wa*Wa; K:= M*M*M*M;
//--------
  b0 := K;
  b1 := -4*K;
  b2 := 6*K;
  b3 := -4*K;
  b4 := K;
//--------
  a0 := (M*M*M*M) + G*M*M*M + H*M*M + I*M + Wa*Wa*Wa*Wa;
  a1 := -4*(M*M*M*M) - 2*G*M*M*M + 2*I*M + 4*Wa*Wa*Wa*Wa;
  a2 := 6*M*M*M*M - 2*H*M*M + 6*Wa*Wa*Wa*Wa;
  a3 := -4*(M*M*M*M) + 2*G*M*M*M - 2*I*M + 4*Wa*Wa*Wa*Wa;
  a4 := (M*M*M*M) - G*M*M*M + H*M*M - I*M + Wa*Wa*Wa*Wa;
//-------normalisasi
  GoTo Normalisasi;

//
//
//========================================BAND PASS FILTER
BandPassOrder2:
  b2 := -W * M;
  b1 := 0;
  b0 := W * M;
  b3 := 0;
  b4 := 0;
//--------
  a2 := w02 + M*M - (W * M);
  a1 := 2 * (w02 - (M*M));
  a0 := M*M + w02 + W*M;
  a3 := 0;
  a4 := 0;
//-------normalisasi
  GoTo Normalisasi;
//--------------------------------
BandPassOrder4:
  C := 1.4142 ;  D := W02 ;
  F := W*W*M*M;  G := C*W*M*M*M ; H := (2*D + W*W)*M*M ;
  I := C*W*D*M ; J := M*M*M*M   ; K := D*D ;
//---------
  b0 := F ;
  b1 := 0 ;
  b2 := -2*F ;
  b3 := 0 ;
  b4 := F ;
//--------
  a0 := J + G + H + I + K;
  a1 := -4*J - 2*G + 2*I + + 4*K;
  a2 := 6*J - 2*H + 6*K;
  a3 := -4*J + 2*G - 2*I +4*K;
  a4 := J - G + H - I + K;
//-------normalisasi
  GoTo Normalisasi;
//========================================BAND STOP FILTER
BandStopOrder2:
  b2 := W02 + M*M;
  b1 := 2 * (W02 - (M*M));
  b0 := W02 + M*M;
  b3 := 0;
  b4 := 0;
//--------
  a2 := W02 + M*M - (W * M);
  a1 := 2 * (W02 - (M*M));
  a0 := M*M + W02 + W*M;
  a3 := 0;
  a4 := 0;
//-------normalisasi
  GoTo Normalisasi;
//---------------------------------
BandStopOrder4:
  C := 1.4142 ;    D := W02 ;
  F := M*M*M*M;    G := 2*D*M*M ;      H := D*D;
  I := C*W*M*M*M ; J := M*M*(W*W+2*D); K := C*W*D*M ;
//---------
  b0 := F+G+H ;
  b1 := -4*F + 4*H;
  b2 := 6*F - 2*G + 6*H;
  b3 := -4*F + 4*H ;
  b4 := F+G+H ;
//--------
  a0 := F+I+J+K+H;
  a1 := -4*F - 2*I + 2*K + 4*H;
  a2 := 6*F - 2*J + 6*H;
  a3 := -4*F + 2*I - 2*K + 4*H;
  a4 := F - I + J - K + H;
//
//
//================================KOEFISIENT NUMERATOR
Normalisasi:
  b0 := b0/a0;
  b1 := b1/a0;
  b2 := b2/a0;
  b3 := b3/a0;
  b4 := b4/a0;
//---
  a1 := a1/a0;
  a2 := a2/a0;
  a3 := a3/a0;
  a4 := a4/a0;
//-----------------------
  EditA0.Text := '1';
  Str(A1:3:3, s); EditA1.Text := s;
  Str(A2:3:3, s); EditA2.Text := s;
  Str(A3:3:3, s); EditA3.Text := s;
  Str(A4:3:3, s); EditA4.Text := s;
//-----
  Str(B0:3:3, s); EditB0.Text := s;
  Str(B1:3:3, s); EditB1.Text := s;
  Str(B2:3:3, s); EditB2.Text := s;
  Str(B3:3:3, s); EditB3.Text := s;
  Str(B4:3:3, s); EditB4.Text := s;
end;

//==================enbled edit frek
procedure TForm1.RdBttnLowPassClick(Sender: TObject);
begin
  EditFcLow.enabled:=true;
  EditFcHi.enabled :=false;
end;

procedure TForm1.RdBttnHiPassClick(Sender: TObject);
begin
  EditFcLow.enabled:=false;
  EditFcHi.enabled :=true;
end;

procedure TForm1.RdBttnBandPassClick(Sender: TObject);
begin
  EditFcLow.enabled:=true;
  EditFcHi.enabled :=true;
end;
procedure TForm1.RdBttnBandStopClick(Sender: TObject);
begin
  EditFcLow.enabled:=true;
  EditFcHi.enabled :=true;
end;
//
//======================================DATA FILE SIMULASI
//==================================Open File
procedure TForm1.BttnLoadFileClick(Sender: TObject);
var
  F: Textfile;
  s: string;
  i,j: integer;
Label
  GetTmSampl;
begin
  ButtonSaveFile.Enabled:=false;
  EditSaveNamaFile.Enabled:=false;
  FastLineSeries2.Clear;
  FastLineSeries3.Clear;

//---------------------------
  OpenDialog1.Title := 'Open File';
  if OpenDialog1.Execute then
     OpnFile := OpenDialog1.FileName;
  EditLoadNamaFile.Text:=OpnFile;
  baca_data(OpnFile);
  LabelNamaFile.Caption:=lab1;
  LabelTimeSampling.Caption:=lab2;
//---------------------------cari '='
  i:=1;
  repeat
    S:= copy(lab2,i,1);
    i:=i+1;
  until S = '=';
//---------------------------'=' ketemu
    S:= copy(lab2,i,6);
  If S = '0.0100' then RdBttn100Hz.Checked:=true;
  If S = '0.0050' then RdBttn200Hz.Checked:=true;
  If S = '0.0020' then RdBttn500Hz.Checked:=true;
  If S = '0.0010' then RdBttn1000Hz.Checked:=true;
  If S = '0.0005' then RdBttn2000Hz.Checked:=true;
//----------------------------ubah parameter
  TimeSampling:=StrToFloat(S);
  FrekSampling:=Round(1/TimeSampling);
  MaxFrek     :=Round(FrekSampling/2);
  MaxData     :=MaxFrek;
  EditMaxData.text:= IntToStr(MaxData);
//---------------------------
  Chart2.BottomAxis.Maximum:=MaxData;
  Chart2.BottomAxis.Minimum:=0;
  Series1.Clear;
//---------------------------get Data Sinyal dr File
  for i:= 0 to MaxData do
    begin
    X[i]:= volt4[i];
//--------Plot Sinyal Data File
    Series1.AddXY(i,X[i]);
    end;
//
//---------------------------get DFT Data Sinyal dr File
  DFT;
//-------------------------------data filter ready
  ButtonFiltering.Enabled:=true;
end;

//==================================Baca Data
procedure TForm1.baca_data(nfile:string);
var
  i:integer;
begin
  i:=0;
  assignfile(filename,nfile);
  reset(filename);
  readln(filename,lab1);
  readln(filename,lab2);
  while not eof(filename) do
  begin
    readln(filename,time[i],volt4[i]);
    i:=i+1;
  end;
  closefile(filename);
end;
//
//======================================DATA EXTERNAL ADC
//==================================Setting Port Serial
procedure TForm1.BttnPortSettingClick(Sender: TObject);
begin
  ComPort1.ShowSetupDialog;
end;

//==================================Open Port Serial
procedure TForm1.SpdBttnOpenPortClick(Sender: TObject);
begin
  If SpdBttnOpenPort.Caption =   'OPEN PORT' then
    begin
      SpdBttnOpenPort.Caption := 'CLOSE PORT';
      Comport1.Open;
      PortOpen:=true;
      SpdBttnAdcToRam.Enabled:=true;
    end
  Else
  If SpdBttnOpenPort.Caption = 'CLOSE PORT' then
    begin
      SpdBttnOpenPort.Caption := 'OPEN PORT';
      Comport1.Close;
      PortOpen:=false;
      SpdBttnAdcToRam.Enabled:=False;
    end;
end;

//==============================Start Conversi ADC to RAM
procedure TForm1.SpdBttnAdcToRamClick(Sender: TObject);
  var fsc,stc:integer;
  Label Start,Selesai;
begin
  If SpdBttnAdcToRam.Caption = 'ADC to RAM' then
    begin
      SpdBttnAdcToRam.Caption := 'KONVERSI';
      S1.Brush.Color := clRed;
      Goto Start;
    end
  Else
  If SpdBttnAdcToRam.Caption = 'KONVERSI' then
    begin
      SpdBttnAdcToRam.Caption := 'ADC to RAM';
      S1.Brush.Color := clGreen;
      Goto Selesai;
    end;
//-----------------------------------
Start:
  Series1.Clear;
  Series2.Clear;
  FastLineSeries2.Clear;
  FastLineSeries3.Clear;
  SpdBttnGetDataRam.Enabled:=False;
  ButtonFiltering.Enabled:=False;
//---------------pilih data frek sampling
  stc:=0;
  If S1.Brush.Color=clGreen Then S1.Brush.Color:=clRed;
  if RdBttn100Hz.Checked  then  fsc:=97;    //'a'
  if RdBttn200Hz.Checked  then  fsc:=98;    //'b'
  if RdBttn500Hz.Checked  then  fsc:=99;    //'c'
  if RdBttn1000Hz.Checked then  fsc:=100;   //'d'
  if RdBttn2000Hz.Checked then  fsc:=101;   //'e'
//-----------kirim data Frekuensi Sampling ke External ADC
  If PortOpen = true Then ComPort1.Write(fsc,1);
//-----------Wait External ADC selesai (data serial 's')
  repeat
    If PortOpen = false Then Goto Selesai;
    If PortOpen = true  Then ComPort1.Read(stc,1);
    delay(1);
  until stc=115;  //karakter 's'
//-----------Data Ready di RAM
  MessageDlg('Baca Data ADC, Simpan 2048 Data ke RAM Berhasil', mtInformation,[mbOk], 0);
//-----------
  SpdBttnGetDataRam.Enabled:=true;
Selesai:
  SpdBttnAdcToRam.Caption := 'ADC to RAM';
  S1.Brush.Color := clGreen;
end;

//==============================Get Data RAM
procedure TForm1.SpdBttnGetDataRamClick(Sender: TObject);
  var i,j,start_c,ch4 :integer;
  label Start,Selesai;
begin
  If SpdBttnGetDataRam.Caption = 'GET DATA RAM' then
    begin
      SpdBttnGetDataRam.Caption := 'READING RAM DATA';
      S2.Brush.Color := clRed;
      Goto Start;
    end
  Else
  If SpdBttnGetDataRam.Caption = 'READING RAM DATA' then
    begin
      SpdBttnGetDataRam.Caption := 'GET DATA RAM';
      S2.Brush.Color := clGreen;
      Goto Selesai;
    end;
//----------------dapatkan parameter dulu
Start:
  GetParammeter;      //  MaxData:=2048;
  ButtonFiltering.Enabled:=False;
//baca dari RAM simpan ke memori PC dahulu
  Start_c:=104;       //kirim karakter 'h'

//------------------------kirim data 'h'
  If PortOpen = true Then ComPort1.Write(start_c,1);

//------------------------Terima Data RAM
  Series1.clear ;//Plot Sinyal asli
  i:=0;
  repeat
    If PortOpen = false Then Goto Selesai;
    If PortOpen = true Then ComPort1.Read(ch4,1);
//-------
    Volt4[i] := ch4 * 0.02; //(5.1/255);
    if i < MaxData then
      begin
        X[i]:= Volt4[i];
        Series1.AddXY(i,X[i]);
      end;
    delay(1);
    i:=i+1;
  until i = 2048;
//
//-------------------------------data filter ready
Selesai:
  MaxDataIn:=i;
  if MaxDataIn > MaxData then     //data yg masuk cukup
    begin
      DFT;  //get DFT Sinyal Data RAM
      ButtonFiltering.Enabled:=true;
      EnabledSaveFile;
    end;
  SpdBttnGetDataRam.Caption := 'GET DATA RAM';
  S2.Brush.Color := clGreen;
  delay(10);
end;
//==============================Enable Tombol SAVE File
procedure TForm1.EnabledSaveFile;
Begin
  ButtonSaveFile.Enabled:=true;
  EditSaveNamaFile.Enabled:=true;
  EditSaveNamaFile.Text:='NamaFile.dat';
end;
//==============================Simpan Data RAM dalam File
procedure TForm1.ButtonSaveFileClick(Sender: TObject);
begin
  files:=EditSaveNamaFile.text;
  SimpanFile(files);
end;
//----------------
procedure TForm1.SimpanFile(nFile:string);
var
i:integer;
s:string;
begin
  assignfile(filename,nfile);
  rewrite(filename);
  writeln(filename,'Nama File =',nfile);
  writeln(filename,'Time Sampling =',TimeSampling:2:4);
  for i:=1 to MaxDataIn do
  begin
    writeln(filename,i,'  ',Volt4[i]:2:6);
  end;
  closefile(filename);
  ButtonSaveFile.Enabled:=false;
  EditSaveNamaFile.Enabled:=false;
end;
end.
