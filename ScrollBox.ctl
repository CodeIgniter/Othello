VERSION 5.00
Begin VB.UserControl ScrollBox 
   AutoRedraw      =   -1  'True
   ClientHeight    =   2550
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2925
   LockControls    =   -1  'True
   ScaleHeight     =   170
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   195
   ToolboxBitmap   =   "ScrollBox.ctx":0000
   Begin VB.Timer ScrollTimer 
      Enabled         =   0   'False
      Interval        =   100
      Left            =   420
      Top             =   1980
   End
   Begin VB.PictureBox picText 
      AutoRedraw      =   -1  'True
      BorderStyle     =   0  'û��
      CausesValidation=   0   'False
      Height          =   1725
      Left            =   180
      ScaleHeight     =   115
      ScaleMode       =   3  'Pixel
      ScaleWidth      =   173
      TabIndex        =   0
      Top             =   90
      Visible         =   0   'False
      Width           =   2595
   End
End
Attribute VB_Name = "ScrollBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ������ؼ�
' �汾: 1.5
' ����: �Գ�
' ����: 2003.4.19


Option Explicit

Private Declare Function BitBlt Lib "gdi32" (ByVal hDestDC As Long, ByVal X As Long, ByVal Y As Long, ByVal nWidth As Long, ByVal nHeight As Long, ByVal hSrcDC As Long, ByVal xSrc As Long, ByVal ySrc As Long, ByVal dwRop As Long) As Long

Public Enum eBackStyle
    '͸�� = 0
    '��͸�� = 1
    bsTransparent = 0
    bsOpaque = 1
End Enum

Public Enum eBorderStyle
    '�ޱ߿� = 0
    '�б߿� = 1
    bsNone = 0
    bsFixed = 1
End Enum

Dim PosY As Single
'Dim MouseX As Single
Dim MouseY As Single
Dim MouseMoving As Boolean

'ȱʡ����ֵ:
Const m_def_TextHeight = 100

'���Ա���:
Dim m_TextHeight As Single

'�¼�����:
Public Event ScrollUp(Position As Single)


Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If (Button And vbLeftButton) = vbLeftButton Then
        Me.Scroll = False
        Set UserControl.MouseIcon = HandDownCursor
        Call SetCapture(UserControl.hWnd)
        MouseY = Y
        MouseMoving = True
    End If
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If (Button And vbLeftButton) = vbLeftButton And MouseMoving And GetCapture() = UserControl.hWnd Then
        Call ScrollBy(MouseY - Y)
        MouseY = Y
    End If
End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If (Button And vbLeftButton) = vbLeftButton And MouseMoving Then
        Set UserControl.MouseIcon = HandUpCursor
        Me.Scroll = True
        MouseMoving = False
    End If
End Sub

Private Sub ScrollTimer_Timer()
    ScrollTimer.Enabled = False
    RaiseEvent ScrollUp(PosY + ScaleHeight)
    Call ScrollBy(1)
    ScrollTimer.Enabled = True
End Sub

Private Sub ScrollBy(ByVal Position As Single)
    On Error Resume Next

    If Position < 1 Then Exit Sub

    Call BitBlt(UserControl.hDC, 0, 0, ScaleWidth, ScaleHeight, picText.hDC, 0, PosY, SRCCOPY)
    PosY = PosY + Position
    If PosY > picText.ScaleHeight - UserControl.ScaleHeight Then
        UserControl.Line (0, picText.ScaleHeight - PosY)-(UserControl.ScaleWidth, UserControl.ScaleHeight), Me.BackColor, BF
    End If
    If PosY > picText.ScaleHeight Then
        PosY = -ScaleHeight
    End If
    Call UserControl.Refresh
End Sub

Private Sub UserControl_Initialize()
    Call picText.Move(0, 0, ScaleWidth)  ', ScaleHeight
    Set UserControl.MouseIcon = HandUpCursor
    UserControl.MousePointer = vbCustom
    Call UserControl.Cls
End Sub

'Ϊ�û��ؼ���ʼ������
Private Sub UserControl_InitProperties()
    m_TextHeight = m_def_TextHeight
End Sub

'�Ӵ������м�������ֵ
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    On Error Resume Next

    UserControl.BackColor = PropBag.ReadProperty("BackColor", &H8000000F)
    picText.BackColor = PropBag.ReadProperty("BackColor", &H8000000F)
    UserControl.Enabled = PropBag.ReadProperty("Enabled", True)
    UserControl.BackStyle = PropBag.ReadProperty("BackStyle", 1)
    UserControl.BorderStyle = PropBag.ReadProperty("BorderStyle", 0)
    ScrollTimer.Enabled = PropBag.ReadProperty("Scroll", False)
    ScrollTimer.Interval = PropBag.ReadProperty("Speed", 100)
    picText.ForeColor = PropBag.ReadProperty("ForeColor", &H80000008)
    m_TextHeight = PropBag.ReadProperty("TextHeight", m_def_TextHeight)
    picText.CurrentX = PropBag.ReadProperty("CurrentX", 0)
    picText.CurrentY = PropBag.ReadProperty("CurrentY", 0)

    Call picText.Move(0, 0, ScaleWidth, m_TextHeight)
End Sub

'������ֵд���洢��
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    On Error Resume Next

    Call PropBag.WriteProperty("BackColor", UserControl.BackColor, &H8000000F)
    Call PropBag.WriteProperty("Enabled", UserControl.Enabled, True)
    Call PropBag.WriteProperty("BackStyle", UserControl.BackStyle, 1)
    Call PropBag.WriteProperty("BorderStyle", UserControl.BorderStyle, 0)
    Call PropBag.WriteProperty("Scroll", ScrollTimer.Enabled, False)
    Call PropBag.WriteProperty("Speed", ScrollTimer.Interval, 100)
    Call PropBag.WriteProperty("ForeColor", picText.ForeColor, &H80000008)
    Call PropBag.WriteProperty("TextHeight", m_TextHeight, m_def_TextHeight)
    Call PropBag.WriteProperty("CurrentX", picText.CurrentX, 0)
    Call PropBag.WriteProperty("CurrentY", picText.CurrentY, 0)
End Sub

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,BackColor
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "����/���ö������ı���ͼ�εı���ɫ��"
    BackColor = UserControl.BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    UserControl.BackColor() = New_BackColor
    picText.BackColor() = New_BackColor
    PropertyChanged "BackColor"
End Property
'

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,Enabled
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "����/����һ��ֵ������һ�������Ƿ���Ӧ�û������¼���"
    Enabled = UserControl.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    UserControl.Enabled() = New_Enabled
    PropertyChanged "Enabled"
End Property
'

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,BackStyle
Public Property Get BackStyle() As eBackStyle
Attribute BackStyle.VB_Description = "ָ�� Label �� Shape �ı�����ʽ��͸���Ļ��ǲ�͸���ġ�"
    BackStyle = UserControl.BackStyle
End Property

Public Property Let BackStyle(ByVal New_BackStyle As eBackStyle)
    UserControl.BackStyle() = New_BackStyle
    PropertyChanged "BackStyle"
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,BorderStyle
Public Property Get BorderStyle() As eBorderStyle
Attribute BorderStyle.VB_Description = "����/���ö���ı߿���ʽ��"
    BorderStyle = UserControl.BorderStyle
End Property

Public Property Let BorderStyle(ByVal New_BorderStyle As eBorderStyle)
    UserControl.BorderStyle() = New_BorderStyle
    PropertyChanged "BorderStyle"
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=0
Public Function TextOut(Text As String)
    picText.Print Text;
End Function

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=picText,picText,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "����һ�� Font ����"
Attribute Font.VB_UserMemId = -512
    Set Font = picText.Font
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=picText,picText,-1,Cls
Public Sub Cls()
Attribute Cls.VB_Description = "������塢ͼ���ͼƬ����������ʱ���ɵ�ͼ�κ��ı���"
    ScrollTimer.Enabled = False
    Call UserControl.Cls
    Call picText.Cls
    Call UserControl.Refresh
    PosY = -ScaleHeight
End Sub
''
'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=ScrollTimer,ScrollTimer,-1,Enabled
Public Property Get Scroll() As Boolean
Attribute Scroll.VB_Description = "�Ƿ�ʼ���������ʱ�����á�"
    Scroll = ScrollTimer.Enabled
End Property

Public Property Let Scroll(ByVal New_Scroll As Boolean)
    If Not Ambient.UserMode Then
        Call Err.Raise(387)
    Else
        ScrollTimer.Enabled() = New_Scroll
        PropertyChanged "Scroll"
    End If
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=ScrollTimer,ScrollTimer,-1,Interval
Public Property Get Speed() As Long
Attribute Speed.VB_Description = "�����ٶȣ���ֵԽ���ٶ�Խ����"
    Speed = ScrollTimer.Interval
End Property

Public Property Let Speed(ByVal New_Speed As Long)
    ScrollTimer.Interval() = New_Speed
    PropertyChanged "Speed"
End Property
'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=picText,picText,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "����/���ö������ı���ͼ�ε�ǰ��ɫ��"
    ForeColor = picText.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    picText.ForeColor() = New_ForeColor
    PropertyChanged "ForeColor"
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=12,0,0,100
Public Property Get TextHeight() As Single
Attribute TextHeight.VB_Description = "�ı�����߶ȡ�"
    TextHeight = m_TextHeight
End Property

Public Property Let TextHeight(ByVal New_TextHeight As Single)
    m_TextHeight = New_TextHeight
    Call picText.Move(0, 0, ScaleWidth, m_TextHeight)
    PropertyChanged "TextHeight"
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=picText,picText,-1,CurrentX
Public Property Get CurrentX() As Single
Attribute CurrentX.VB_Description = "����/�����´� print �� draw ������ˮƽ���ꡣ"
    CurrentX = picText.CurrentX
End Property

Public Property Let CurrentX(ByVal New_CurrentX As Single)
    picText.CurrentX() = New_CurrentX
    PropertyChanged "CurrentX"
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=picText,picText,-1,CurrentY
Public Property Get CurrentY() As Single
Attribute CurrentY.VB_Description = "����/�����´� print �� draw �����Ĵ�ֱ���ꡣ"
    CurrentY = picText.CurrentY
End Property

Public Property Let CurrentY(ByVal New_CurrentY As Single)
    picText.CurrentY() = New_CurrentY
    PropertyChanged "CurrentY"
End Property
