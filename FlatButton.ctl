VERSION 5.00
Begin VB.UserControl FlatButton 
   AutoRedraw      =   -1  'True
   ClientHeight    =   705
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   1665
   DefaultCancel   =   -1  'True
   HasDC           =   0   'False
   LockControls    =   -1  'True
   PropertyPages   =   "FlatButton.ctx":0000
   ScaleHeight     =   705
   ScaleWidth      =   1665
   ToolboxBitmap   =   "FlatButton.ctx":0035
   Begin VB.Label lblLine 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Height          =   180
      Left            =   1185
      TabIndex        =   1
      Top             =   255
      UseMnemonic     =   0   'False
      Visible         =   0   'False
      Width           =   90
   End
   Begin VB.Label lblCaption 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Height          =   180
      Left            =   705
      TabIndex        =   0
      Top             =   255
      UseMnemonic     =   0   'False
      Visible         =   0   'False
      Width           =   90
   End
   Begin VB.Image imgIcon 
      Height          =   240
      Left            =   315
      Stretch         =   -1  'True
      Top             =   240
      Visible         =   0   'False
      Width           =   240
   End
End
Attribute VB_Name = "FlatButton"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
' ƽ�水ť�ؼ�
' �汾: 2.0.1.2
' ����: �Գ�
' ����: 2003.8.14

Option Explicit

Private Declare Function SetCapture Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function GetCapture Lib "user32" () As Long
Private Declare Function ReleaseCapture Lib "user32" () As Long
Private Declare Function GetActiveWindow Lib "user32" () As Long
Private Declare Sub InitCommonControls Lib "comctl32.dll" ()
Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long
Private Declare Function DestroyWindow Lib "user32" (ByVal hWnd As Long) As Long
Private Declare Function CreateWindowEx Lib "user32" Alias "CreateWindowExA" _
                            (ByVal dwExStyle As Long, ByVal lpClassName As String, _
                             ByVal lpWindowName As String, ByVal dwStyle As Long, _
                             ByVal X As Long, ByVal Y As Long, _
                             ByVal nWidth As Long, ByVal nHeight As Long, _
                             ByVal hwndParent As Long, ByVal hMenu As Long, _
                             ByVal hInstance As Long, lpParam As Any) As Long

'Private Const WM_MOUSEMOVE = &H200
'Private Const WM_LBUTTONDOWN = &H201
'Private Const WM_LBUTTONUP = &H202

Public Enum eButtonStyle
    bsNormal = 0
    bsPicture = 1
    bsPush = 2
    bsFlat = 3
End Enum

Public Enum eUseButton
    ubLeftButton = vbLeftButton
    ubRightButton = vbRightButton
End Enum

Public Enum eIconSize
    is16x16 = 16
    is32x32 = 32
    is48x48 = 48
End Enum

#Const WIN32_IE = &H400   ' 1024

Const TTDT_AUTOMATIC = 0
Const TTDT_RESHOW = 1
Const TTDT_AUTOPOP = 2
Const TTDT_INITIAL = 3
Const TOOLTIPS_CLASS = "tooltips_class32"
Const TTS_ALWAYSTIP = &H1
Const WM_USER = &H400

Private Enum TT_Msgs
    TTM_SETDELAYTIME = (WM_USER + 3)

    #If UNICODE Then
        TTM_ADDTOOL = (WM_USER + 50)
        TTM_UPDATETIPTEXT = (WM_USER + 57)
        TTM_ENUMTOOLS = (WM_USER + 58)
    #Else
        TTM_ADDTOOL = (WM_USER + 4)
        TTM_UPDATETIPTEXT = (WM_USER + 12)
        TTM_ENUMTOOLS = (WM_USER + 14)
    #End If   ' UNICODE

    #If (WIN32_IE >= &H300) Then
        TTM_SETMAXTIPWIDTH = (WM_USER + 24)
    #End If   ' (WIN32_IE >= &H300)
End Enum   ' TT_Msgs

Private Enum ttDelayTimeConstants
  ttDelayDefault = TTDT_AUTOMATIC '= 0
  ttDelayInitial = TTDT_INITIAL '= 3
  ttDelayShow = TTDT_AUTOPOP '= 2
  ttDelayReshow = TTDT_RESHOW '= 1
  ttDelayMask = 3
End Enum

Private Enum TT_Flags
    TTF_IDISHWND = &H1
    TTF_SUBCLASS = &H10
End Enum   ' TT_Flags

Private Type RECT   ' rct
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Private Type TOOLINFO
    cbSize As Long
    uFlags As TT_Flags
    hWnd As Long
    uId As Long
    RECT As RECT
    hinst As Long
    lpszText As String   ' Long
    #If (WIN32_IE >= &H300) Then
        lParam As Long
    #End If
End Type   ' TOOLINFO

Const ICON_SPACE = 80

'ȱʡ����ֵ:
Const m_def_IconSize = is16x16
Const m_def_AutoSize = False
Const m_def_NormalForeColor = vbBlack
Const m_def_BackColor = vbButtonFace
Const m_def_OverBackColor = 0
Const m_def_DownBackColor = 0
Const m_def_OverBorderColor = 0
Const m_def_DownBorderColor = 0
Const m_def_BorderColor = 0
Const m_def_FocusColor = vbButtonShadow
Const m_def_ToolTip = ""
Const m_def_HotColor = vbBlue
Const m_def_EnableHot = False
Const m_def_DisableColor = vbGrayText
Const m_def_LightBorderColor1 = vb3DHighlight
Const m_def_DarkBorderColor1 = vbButtonShadow
Const m_def_LightBorderColor2 = vb3DLight
Const m_def_DarkBorderColor2 = vb3DDKShadow
Const m_def_Style = bsNormal
Const m_def_UseButton = ubLeftButton
Const m_def_Value = False
Const m_def_Caption = ""

Dim m_hWndTT As Long
Dim m_cMaxTip As Long

'���Ա���:
Dim m_IconSize As eIconSize
Dim m_AutoSize As Boolean
Dim m_NormalForeColor As OLE_COLOR
Dim m_BackColor As OLE_COLOR
Dim m_OverBackColor As OLE_COLOR
Dim m_DownBackColor As OLE_COLOR
Dim m_OverBorderColor As OLE_COLOR
Dim m_DownBorderColor As OLE_COLOR
Dim m_BorderColor As OLE_COLOR
Dim m_FocusColor As OLE_COLOR
Dim m_ToolTip As String
Dim m_Icon As Picture
Dim m_HotColor As OLE_COLOR
Dim m_EnableHot As Boolean
Dim m_DisableColor As OLE_COLOR
Dim m_LightBorderColor1 As OLE_COLOR
Dim m_DarkBorderColor1 As OLE_COLOR
Dim m_LightBorderColor2 As OLE_COLOR
Dim m_DarkBorderColor2 As OLE_COLOR
Dim m_Picture As Picture
Dim m_DownPicture As Picture
Dim m_OverPicture As Picture
Dim m_Style As eButtonStyle
Dim m_UseButton As eUseButton
Dim m_Value As Boolean
Dim m_Caption As String
Dim m_MouseOver As Boolean
Dim m_MouseOut As Boolean
Dim m_Focus As Boolean
Dim m_FocusRect As Boolean
Dim m_Button As Integer

'�¼�����:
Public Event Click(Button As Integer)
Public Event ValueChange(Value As Boolean)
Public Event MouseOver()
Public Event MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Public Event MouseOut()


Private Sub imgIcon_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseDown(Button, Shift, 0, 0)
End Sub

Private Sub imgIcon_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseMove(Button, Shift, 0, 0)
End Sub

Private Sub imgIcon_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseUp(Button, Shift, 0, 0)
End Sub

Private Sub UserControl_KeyDown(KeyCode As Integer, Shift As Integer)
    On Error Resume Next

    If (KeyCode = vbKeySpace Or KeyCode = vbKeyReturn) And UserControl.Enabled Then
        RaiseEvent Click(Val(m_UseButton))
    End If
End Sub

Private Sub UserControl_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim Over As Boolean

    On Error Resume Next

    If Not UserControl.Enabled Then Exit Sub

    Over = (X >= 0) And (X <= ScaleWidth) And (Y >= 0) And (Y <= ScaleHeight)

    If m_EnableHot Then
        lblCaption.ForeColor = m_HotColor
        lblLine.ForeColor = m_HotColor
    End If
    If Not m_Focus And (Button And m_UseButton) = m_UseButton And Over Then
        m_Button = Button
        m_Focus = True
        Call ItemDown
    End If
End Sub

Private Sub UserControl_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim Over As Boolean

    On Error Resume Next

    If Not UserControl.Enabled Then Exit Sub

    Over = (X >= 0) And (X <= ScaleWidth) And (Y >= 0) And (Y <= ScaleHeight)

    If Over Then
    ' ��갴ţ̌��ʱ���ڰ�ť�ϡ�
        If m_Focus Then
        ' �н��㡣
            If (Button And m_UseButton) = m_UseButton And (Button And m_Button) = m_Button Then
                Call ResetButton
                RaiseEvent ValueChange(m_Value)
                If m_Value Then
                ' �Ѱ���
                    Call ItemDown
                Else
                    Call ItemOut
                End If
                If m_EnableHot Then
                    lblCaption.ForeColor = m_NormalForeColor
                    lblLine.ForeColor = m_NormalForeColor
                End If
                RaiseEvent MouseOut
                RaiseEvent Click(Button)
            End If
        End If
    Else
    ' ��갴ţ̌��ʱ�����ڰ�ť�ϡ�
        If (Button And m_Button) = m_Button Then
            Call ResetButton
            If m_Value Then
                Call ItemDown
            Else
                Call ItemOut
            End If
            If m_EnableHot Then
                lblCaption.ForeColor = m_NormalForeColor
                lblLine.ForeColor = m_NormalForeColor
            End If
            RaiseEvent MouseOut
        End If
    End If
End Sub

Private Sub UserControl_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim Over As Boolean

    On Error Resume Next

    'If (Not UserControl.Enabled) Then Exit Sub

    If (GetActiveWindow() <> UserControl.Parent.hWnd) Or (Not UserControl.Enabled) Then
        'Call ResetButton
        Exit Sub
    End If

    Over = (X >= 0) And (X <= ScaleWidth) And (Y >= 0) And (Y <= ScaleHeight)

    If Over Then
    ' ����ƶ�����ť�ϡ�
        If GetCapture() <> UserControl.hWnd Then
            Call SetCapture(UserControl.hWnd)
            'UserControl.SetFocus
        End If
        If Not m_MouseOver Then
            m_MouseOver = True
            m_MouseOut = False
            If m_Focus Then
            ' ����ƶ�����ť��ʱ�н��㣨��ť���ñ�����ͬ����
            ' ����ʾ���°�ť��
                If (Button And m_UseButton) = m_UseButton Then Call ItemDown
            Else
            ' û�н��㣬����ʾ����ť��
                If m_EnableHot Then
                    lblCaption.ForeColor = m_HotColor
                    lblLine.ForeColor = m_HotColor
                End If
                RaiseEvent MouseOver
                If m_Value Then
                ' �Ѱ���
                    Call ItemDown
                Else
                    Call ItemOver
                End If
            End If
        End If
        RaiseEvent MouseMove(Button, Shift, X, Y)
    Else
    ' ����Ƴ���ť��
        If Not m_MouseOut Then
            m_MouseOut = True
            m_MouseOver = False
            If m_Focus Then
            ' ����Ƴ���ťʱ����ť���ñ�����ͬ���н��㣬
            ' ����ʾ����ť��
                If (Button And m_UseButton) = m_UseButton Then
                    If m_Value Then
                        Call ItemDown
                    Else
                        Call ItemOver
                    End If
                End If
            Else
                If m_Value Then
                ' �Ѱ���
                    Call ItemDown
                Else
                    Call ItemOut
                End If
                Call ResetButton
                If m_EnableHot Then
                    lblCaption.ForeColor = m_NormalForeColor
                    lblLine.ForeColor = m_NormalForeColor
                End If
                RaiseEvent MouseOut
            End If
        End If
    End If
End Sub

Private Sub lblCaption_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseDown(Button, Shift, 0, 0)
End Sub

Private Sub lblCaption_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseUp(Button, Shift, 0, 0)
End Sub

Private Sub lblCaption_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseMove(Button, Shift, 0, 0)
End Sub

Private Sub lblLine_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseDown(Button, Shift, 0, 0)
End Sub

Private Sub lblLine_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseUp(Button, Shift, 0, 0)
End Sub

Private Sub lblLine_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Call ReleaseCapture
    Call UserControl_MouseMove(Button, Shift, 0, 0)
End Sub

Private Sub ItemOut()
    On Error Resume Next

    Select Case m_Style
        Case bsNormal
            'UserControl.BackColor = m_BackColor
            Call ClearPicture
            ' �����
            Call DrawFocusRect(m_FocusRect)
            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE, (ScaleHeight - lblCaption.Height) \ 2)
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2, (ScaleHeight - lblCaption.Height) \ 2)
            End If
            Call DisplayLine

        Case bsPicture
            'UserControl.BackColor = m_BackColor
            Set UserControl.Picture = m_Picture

        Case bsPush
            'UserControl.BackColor = m_BackColor
            'Debug.Print "Out"
            Call ClearPicture
            If Extender.Default And UserControl.Enabled Then
                Call DrawEdge(GetTwipX(1), GetTwipY(1), ScaleWidth - GetTwipX(2), ScaleHeight - GetTwipY(2), m_LightBorderColor1, m_DarkBorderColor1)
                UserControl.Line (0, 0)-(ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1)), m_DarkBorderColor2, B
            Else
                Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_LightBorderColor1, m_DarkBorderColor1)
            End If

            ' �����
            Call DrawFocusRect(m_FocusRect)

            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE, (ScaleHeight - lblCaption.Height) \ 2)
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2, (ScaleHeight - lblCaption.Height) \ 2)
            End If
            Call DisplayLine

        Case bsFlat
            UserControl.BackColor = m_BackColor
            Call ClearPicture
            Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_BorderColor, m_BorderColor)
            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE, (ScaleHeight - lblCaption.Height) \ 2)
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2, (ScaleHeight - lblCaption.Height) \ 2)
            End If
            Call DisplayLine

    End Select
    'Call UserControl.Refresh
End Sub

Private Sub ItemOver()
    On Error Resume Next

    Select Case m_Style
        Case bsNormal
            'UserControl.BackColor = m_BackColor
            Call ClearPicture
            Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_LightBorderColor1, m_DarkBorderColor1)
            ' �����
            Call DrawFocusRect(m_FocusRect)
            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE, (ScaleHeight - lblCaption.Height) \ 2)
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2, (ScaleHeight - lblCaption.Height) \ 2)
            End If
            Call DisplayLine

        Case bsPicture
            'UserControl.BackColor = m_BackColor
            If m_OverPicture Is Nothing Then
                Set UserControl.Picture = m_Picture
            Else
                Set UserControl.Picture = m_OverPicture
            End If

        Case bsPush
            'UserControl.BackColor = m_BackColor
            Call ClearPicture
            ' �ڿ�
            Call DrawEdge(GetTwipX(1), GetTwipY(1), ScaleWidth - GetTwipX(2), ScaleHeight - GetTwipY(2), m_LightBorderColor2, m_DarkBorderColor1)
            ' ���
            Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_LightBorderColor1, m_DarkBorderColor2)

            ' �����
            Call DrawFocusRect(m_FocusRect)

            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE, (ScaleHeight - lblCaption.Height) \ 2)
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2, (ScaleHeight - lblCaption.Height) \ 2)
            End If
            Call DisplayLine

        Case bsFlat
            UserControl.BackColor = m_OverBackColor
            Call ClearPicture
            Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_OverBorderColor, m_OverBorderColor)
            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2, (ScaleHeight - imgIcon.Height) \ 2)
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE, (ScaleHeight - lblCaption.Height) \ 2)
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2, (ScaleHeight - lblCaption.Height) \ 2)
            End If
            Call DisplayLine

    End Select
    'Call UserControl.Refresh
End Sub

Private Sub ItemDown()
    On Error Resume Next

    Select Case m_Style
        Case bsNormal
            'UserControl.BackColor = m_BackColor
            Call ClearPicture
            Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_DarkBorderColor1, m_LightBorderColor1)
            ' �����
            Call DrawFocusRect(m_FocusRect)
            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2 + GetTwipX(1), (ScaleHeight - imgIcon.Height) \ 2 + GetTwipY(1))
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + GetTwipX(1), (ScaleHeight - imgIcon.Height) \ 2 + GetTwipY(1))
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE + GetTwipX(1), (ScaleHeight - lblCaption.Height) \ 2 + GetTwipY(1))
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2 + GetTwipX(1), (ScaleHeight - lblCaption.Height) \ 2 + GetTwipY(1))
            End If
            Call DisplayLine

        Case bsPicture
            'UserControl.BackColor = m_BackColor
            If m_DownPicture Is Nothing Then
                Set UserControl.Picture = m_Picture
            Else
                Set UserControl.Picture = m_DownPicture
            End If

        Case bsPush
            'UserControl.BackColor = m_BackColor
            Call ClearPicture
            ' �ڿ�
            Call DrawEdge(GetTwipX(1), GetTwipY(1), ScaleWidth - GetTwipX(2), ScaleHeight - GetTwipY(2), m_DarkBorderColor1, m_LightBorderColor2)
            ' ���
            Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_DarkBorderColor2, m_LightBorderColor1)

            ' �����
            Call DrawFocusRect(m_FocusRect)

            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2 + GetTwipX(1), (ScaleHeight - imgIcon.Height) \ 2 + GetTwipY(1))
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + GetTwipX(1), (ScaleHeight - imgIcon.Height) \ 2 + GetTwipY(1))
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE + GetTwipX(1), (ScaleHeight - lblCaption.Height) \ 2 + GetTwipY(1))
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2 + GetTwipX(1), (ScaleHeight - lblCaption.Height) \ 2 + GetTwipY(1))
            End If
            Call DisplayLine

        Case bsFlat
            UserControl.BackColor = m_DownBackColor
            Call ClearPicture
            Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), m_DownBorderColor, m_DownBorderColor)
            If Not (m_Icon Is Nothing) Then
                Set imgIcon.Picture = m_Icon
                If m_Caption = "" Then
                    Call imgIcon.Move((ScaleWidth - imgIcon.Width) \ 2 + GetTwipX(1), (ScaleHeight - imgIcon.Height) \ 2 + GetTwipY(1))
                Else
                    Call imgIcon.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + GetTwipX(1), (ScaleHeight - imgIcon.Height) \ 2 + GetTwipY(1))
                End If
                imgIcon.Visible = True
                Call lblCaption.Move((ScaleWidth - (imgIcon.Width + lblCaption.Width + ICON_SPACE)) \ 2 + imgIcon.Width + ICON_SPACE + GetTwipX(1), (ScaleHeight - lblCaption.Height) \ 2 + GetTwipY(1))
            Else
                Call lblCaption.Move((ScaleWidth - lblCaption.Width) \ 2 + GetTwipX(1), (ScaleHeight - lblCaption.Height) \ 2 + GetTwipY(1))
            End If
            Call DisplayLine
    End Select
    'Call UserControl.Refresh
End Sub

Private Sub UserControl_AccessKeyPress(KeyAscii As Integer)
    On Error Resume Next

    If UserControl.Enabled Then
        KeyAscii = 0
        RaiseEvent Click(Val(m_UseButton))
    End If
End Sub

Private Sub UserControl_AmbientChanged(PropertyName As String)
    'Debug.Print PropertyName; " "
    Call ReDraw
End Sub

Private Sub UserControl_EnterFocus()
    Call DrawFocusRect(True)
End Sub

Private Sub UserControl_ExitFocus()
    Call DrawFocusRect(False)
End Sub

Private Sub UserControl_Resize()
    Call ReDraw
End Sub

Private Sub ReDraw()
    Dim i As Long

    On Error Resume Next

    Select Case m_Style
        Case bsNormal, bsPush, bsFlat
            i = InStr(1, m_Caption, "&")
            If i > 0 Then
                UserControl.AccessKeys = Mid(m_Caption, i + 1, 1)
                lblCaption.Caption = Left(m_Caption, i - 1) & Mid(m_Caption, i + 1)
                lblLine.Caption = Space(StrLen(Left(m_Caption, i - 1))) & "_" & Space(StrLen(m_Caption) - i)
                'Debug.Print UserControl.AccessKeys
                'lblCaption
            Else
                UserControl.AccessKeys = ""
                lblCaption.Caption = m_Caption
                lblLine.Caption = ""
            End If

            Set UserControl.Picture = Nothing
            lblCaption.Visible = True
            lblLine.Visible = True
            imgIcon.Width = GetTwipX(m_IconSize)
            imgIcon.Height = GetTwipY(m_IconSize)
            imgIcon.Visible = True

            If m_AutoSize Then
                With UserControl
                    .Width = lblCaption.Width + GetTwipX(10)
                    .Height = lblCaption.Height + GetTwipY(8)
                End With
            End If

            If m_Value Then
                Call ItemDown
            Else
                If Ambient.UserMode Then
                    ' ����ģʽ
                    If m_Focus And m_MouseOver Then
                        Call ItemDown
                    ElseIf m_Focus Then
                        Call ItemOver
                    Else
                        Call ItemOut
                    End If
                Else
                    ' ���ģʽ
                    If m_Style = bsFlat Then
                        Call ItemOut
                    Else
                        Call ItemOver
                    End If
                End If
            End If

        Case bsPicture
            lblCaption.Visible = False
            lblLine.Visible = False
            imgIcon.Visible = False
            'Set UserControl.Picture = m_Picture
            If m_Value Then
            ' �Ѱ���
                Call ItemDown
            Else
                If m_Focus And m_MouseOver Then
                    Call ItemDown
                ElseIf m_Focus Then
                    Call ItemOver
                Else
                    Call ItemOut
                End If
            End If
            If m_AutoSize Then
                With UserControl
                    .Width = UserControl.Width
                    .Height = UserControl.Height
                End With
            End If
    End Select

    If Not UserControl.Enabled Then
        lblCaption.ForeColor = m_DisableColor
    Else
        If m_EnableHot Then
            If m_MouseOver Then
                lblCaption.ForeColor = m_HotColor
            ElseIf Not m_Focus Then
                lblCaption.ForeColor = m_NormalForeColor
            End If
        Else
            lblCaption.ForeColor = m_NormalForeColor
        End If
    End If
    lblLine.ForeColor = lblCaption.ForeColor
    Call imgIcon.Refresh
    Call UserControl.Refresh
End Sub

Private Sub UserControl_Initialize()
    m_MouseOver = False
    m_MouseOut = False
    m_Focus = False
    m_Button = 0
    m_hWndTT = 0
    'If m_Style <> bsPicture Then lblCaption.Visible = True
End Sub

Private Sub ResetButton()
    Call SetCapture(UserControl.hWnd)
    Call ReleaseCapture
    m_MouseOver = False
    m_MouseOut = False
    m_Focus = False
    m_Button = 0
End Sub

Private Sub DisplayLine()
    Call lblLine.Move(lblCaption.Left, lblCaption.Top)
End Sub

Private Sub ClearPicture()
    Call DrawEdge(GetTwipX(1), GetTwipY(1), ScaleWidth - GetTwipX(2), ScaleHeight - GetTwipY(2), UserControl.BackColor, UserControl.BackColor)
    Call DrawEdge(0, 0, ScaleWidth - GetTwipX(1), ScaleHeight - GetTwipY(1), UserControl.BackColor, UserControl.BackColor)
End Sub

Private Sub DrawEdge(ByVal X1 As Single, ByVal Y1 As Single, ByVal X2 As Single, ByVal Y2 As Single, ByVal Color1 As OLE_COLOR, ByVal Color2 As OLE_COLOR)
    On Error Resume Next

    UserControl.Line (X1, Y1)-(X2, Y1), Color1      ' Top Line
    UserControl.Line (X1, Y1)-(X1, Y2), Color1    ' Left Line
    UserControl.Line (X2, Y2)-(X1 - 10, Y2), Color2  ' Bottom Line
    UserControl.Line (X2, Y2)-(X2, Y1 - 10), Color2 ' Right Line
End Sub

Private Sub DrawFocusRect(ByVal Draw As Boolean)
    On Error Resume Next

    If m_Style <> bsPicture And m_Style <> bsFlat Then
        If Draw Then
            UserControl.Line (GetTwipX(2), GetTwipY(2))-(ScaleWidth - GetTwipX(3), ScaleHeight - GetTwipY(3)), m_FocusColor, B
            m_FocusRect = True
        Else
            UserControl.Line (GetTwipX(2), GetTwipY(2))-(ScaleWidth - GetTwipX(3), ScaleHeight - GetTwipY(3)), UserControl.BackColor, B
            m_FocusRect = False
        End If
    End If
End Sub

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=0
Public Function Reset() As Boolean
    If m_Value Then
        Call ItemDown
    Else
        Call ItemOut
    End If
    Call ResetButton
    Reset = True
End Function

'Ϊ�û��ؼ���ʼ������
Private Sub UserControl_InitProperties()
    On Error Resume Next

    m_Caption = Extender.Name
    m_BackColor = m_def_BackColor
    m_NormalForeColor = m_def_NormalForeColor
    m_Value = m_def_Value
    m_UseButton = m_def_UseButton
    m_Style = m_def_Style
    m_HotColor = m_def_HotColor
    m_EnableHot = m_def_EnableHot
    m_DisableColor = m_def_DisableColor
    m_LightBorderColor1 = m_def_LightBorderColor1
    m_DarkBorderColor1 = m_def_DarkBorderColor1
    m_LightBorderColor2 = m_def_LightBorderColor2
    m_DarkBorderColor2 = m_def_DarkBorderColor2
    m_ToolTip = m_def_ToolTip
    m_FocusColor = m_def_FocusColor
    m_OverBorderColor = m_def_OverBorderColor
    m_DownBorderColor = m_def_DownBorderColor
    m_BorderColor = m_def_BorderColor
    m_OverBackColor = m_def_OverBackColor
    m_DownBackColor = m_def_DownBackColor
    m_AutoSize = m_def_AutoSize
    m_IconSize = m_def_IconSize
    Set m_Picture = Nothing
    Set m_DownPicture = Nothing
    Set m_OverPicture = Nothing
    Set m_Icon = Nothing

    Call ReDraw
End Sub

Private Sub UserControl_Terminate()
    If m_hWndTT > 0 Then
        Call DestroyWindow(m_hWndTT)
    End If
End Sub

'�Ӵ������м�������ֵ
Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    On Error Resume Next

    'UserControl.BackColor = UserControl.BackColor
    lblCaption.ForeColor = PropBag.ReadProperty("ForeColor", &H80000012)
    UserControl.MousePointer = PropBag.ReadProperty("MousePointer", 0)
    UserControl.Enabled = PropBag.ReadProperty("Enabled", True)
    Set lblCaption.Font = PropBag.ReadProperty("Font", Ambient.Font)
    Set lblLine.Font = lblCaption.Font
    Set MouseIcon = PropBag.ReadProperty("MouseIcon", Nothing)
    Set m_Picture = PropBag.ReadProperty("Picture", Nothing)
    Set m_DownPicture = PropBag.ReadProperty("DownPicture", Nothing)
    Set m_OverPicture = PropBag.ReadProperty("OverPicture", Nothing)
    m_LightBorderColor1 = PropBag.ReadProperty("LightBorderColor1", m_def_LightBorderColor1)
    m_DarkBorderColor1 = PropBag.ReadProperty("DarkBorderColor1", m_def_DarkBorderColor1)
    m_LightBorderColor2 = PropBag.ReadProperty("LightBorderColor2", m_def_LightBorderColor2)
    m_DarkBorderColor2 = PropBag.ReadProperty("DarkBorderColor2", m_def_DarkBorderColor2)
    m_Value = PropBag.ReadProperty("Value", m_def_Value)
    m_UseButton = PropBag.ReadProperty("UseButton", m_def_UseButton)
    m_AutoSize = PropBag.ReadProperty("AutoSize", m_def_AutoSize)
    m_Style = PropBag.ReadProperty("Style", m_def_Style)
    m_Caption = PropBag.ReadProperty("Caption", Extender.Name)
    m_DisableColor = PropBag.ReadProperty("DisableColor", m_def_DisableColor)
    m_HotColor = PropBag.ReadProperty("HotColor", m_def_HotColor)
    m_EnableHot = PropBag.ReadProperty("EnableHot", m_def_EnableHot)
    m_BackColor = PropBag.ReadProperty("BackColor", m_def_BackColor)
    m_NormalForeColor = PropBag.ReadProperty("NormalForeColor", m_def_NormalForeColor)
    m_ToolTip = PropBag.ReadProperty("ToolTip", m_def_ToolTip)
    m_FocusColor = PropBag.ReadProperty("FocusColor", m_def_FocusColor)
    m_OverBorderColor = PropBag.ReadProperty("OverBorderColor", m_def_OverBorderColor)
    m_DownBorderColor = PropBag.ReadProperty("DownBorderColor", m_def_DownBorderColor)
    m_BorderColor = PropBag.ReadProperty("BorderColor", m_def_BorderColor)
    m_OverBackColor = PropBag.ReadProperty("OverBackColor", m_def_OverBackColor)
    m_DownBackColor = PropBag.ReadProperty("DownBackColor", m_def_DownBackColor)
    m_IconSize = PropBag.ReadProperty("IconSize", m_def_IconSize)
    Set m_Icon = PropBag.ReadProperty("Icon", Nothing)

    ' ��ʼ��������ʾ
    Call SetToolTip(m_ToolTip)

    Call ReDraw
End Sub

'������ֵд���洢��
Private Sub UserControl_WriteProperties(PropBag As PropertyBag)
    On Error Resume Next

    Call PropBag.WriteProperty("Caption", m_Caption, Extender.Name)
    Call PropBag.WriteProperty("Value", m_Value, m_def_Value)
    Call PropBag.WriteProperty("MousePointer", UserControl.MousePointer, 0)
    Call PropBag.WriteProperty("MouseIcon", MouseIcon, Nothing)
    Call PropBag.WriteProperty("UseButton", m_UseButton, m_def_UseButton)
    Call PropBag.WriteProperty("Style", m_Style, m_def_Style)
    Call PropBag.WriteProperty("Picture", m_Picture, Nothing)
    Call PropBag.WriteProperty("DownPicture", m_DownPicture, Nothing)
    Call PropBag.WriteProperty("OverPicture", m_OverPicture, Nothing)
    Call PropBag.WriteProperty("Enabled", UserControl.Enabled, True)
    Call PropBag.WriteProperty("Font", lblCaption.Font, Ambient.Font)
    Call PropBag.WriteProperty("LightBorderColor1", m_LightBorderColor1, m_def_LightBorderColor1)
    Call PropBag.WriteProperty("DarkBorderColor1", m_DarkBorderColor1, m_def_DarkBorderColor1)
    Call PropBag.WriteProperty("LightBorderColor2", m_LightBorderColor2, m_def_LightBorderColor2)
    Call PropBag.WriteProperty("DarkBorderColor2", m_DarkBorderColor2, m_def_DarkBorderColor2)
    Call PropBag.WriteProperty("DisableColor", m_DisableColor, m_def_DisableColor)
    Call PropBag.WriteProperty("HotColor", m_HotColor, m_def_HotColor)
    Call PropBag.WriteProperty("EnableHot", m_EnableHot, m_def_EnableHot)
    Call PropBag.WriteProperty("Icon", m_Icon, Nothing)
    Call PropBag.WriteProperty("ToolTip", m_ToolTip, m_def_ToolTip)
    Call PropBag.WriteProperty("FocusColor", m_FocusColor, m_def_FocusColor)
    Call PropBag.WriteProperty("OverBorderColor", m_OverBorderColor, m_def_OverBorderColor)
    Call PropBag.WriteProperty("DownBorderColor", m_DownBorderColor, m_def_DownBorderColor)
    Call PropBag.WriteProperty("BorderColor", m_BorderColor, m_def_BorderColor)
    Call PropBag.WriteProperty("OverBackColor", m_OverBackColor, m_def_OverBackColor)
    Call PropBag.WriteProperty("DownBackColor", m_DownBackColor, m_def_DownBackColor)
    Call PropBag.WriteProperty("BackColor", m_BackColor, m_def_BackColor)
    Call PropBag.WriteProperty("ForeColor", lblCaption.ForeColor, &H80000012)
    Call PropBag.WriteProperty("NormalForeColor", m_NormalForeColor, m_def_NormalForeColor)
    Call PropBag.WriteProperty("AutoSize", m_AutoSize, m_def_AutoSize)
    Call PropBag.WriteProperty("IconSize", m_IconSize, m_def_IconSize)
End Sub

Private Sub InitToolTip()
    On Error Resume Next

    If m_hWndTT = 0 Then
        Call InitCommonControls

        ' Filling the hwndParent param below allows the tooltip window to
        ' be owned by the specified form and be destroyed along with it,
        ' but we'll cleanup in Class_Terminate anyway.
        ' No WS_EX_TOPMOST or TTS_ALWAYSTIP per Win95 UI rules...
        m_hWndTT = CreateWindowEx(0, TOOLTIPS_CLASS, _
                                  vbNullString, TTS_ALWAYSTIP, _
                                  0, 0, _
                                  0, 0, _
                                  UserControl.Parent.hWnd, 0, _
                                  App.hInstance, ByVal 0)
    End If
    Call MaxTipWidth(240)
    Call TipDelayTime(ttDelayShow, 5000)
End Sub

Private Sub SetToolTip(ByVal sText As String)
    Dim ti As TOOLINFO

    On Error Resume Next

    If m_hWndTT = 0 And sText <> "" Then
        Call InitToolTip
    End If

    If m_hWndTT = 0 Then Exit Sub

    If GetToolInfo(Me.hWnd, ti) Then
        ti.lpszText = sText
        m_cMaxTip = Max(m_cMaxTip, Len(sText) + 1)
        ' The tooltip won't appear for the control if lpszText is an empty string
        Call SendMessage(m_hWndTT, TTM_UPDATETIPTEXT, 0, ti)    ' no rtn val
    Else
        With ti
            .cbSize = Len(ti)
            ' TTF_IDISHWND must be specified to tell the tooltip control
            ' to retrieve the control's rect from it's hWnd specified in uId.
            .uFlags = TTF_SUBCLASS Or TTF_IDISHWND
            .hWnd = UserControl.Parent.hWnd  'ctrl.Container.hWnd
            .uId = Me.hWnd
            .lpszText = sText

            ' Maintain the maximun tip text length for GetToolInfo
            m_cMaxTip = Max(m_cMaxTip, Len(.lpszText) + 1)
        End With
        Call SendMessage(m_hWndTT, TTM_ADDTOOL, 0, ti)
    End If
End Sub

Private Sub MaxTipWidth(ByVal cx As Long)
    If m_hWndTT = 0 Then Exit Sub
    If cx < 1 Then cx = -1
    Call SendMessage(m_hWndTT, TTM_SETMAXTIPWIDTH, 0, ByVal cx)
End Sub

Private Sub TipDelayTime(dwType As ttDelayTimeConstants, dwMilliSecs As Long)
    If m_hWndTT = 0 Then Exit Sub
    Call SendMessage(m_hWndTT, TTM_SETDELAYTIME, (dwType And ttDelayMask), ByVal dwMilliSecs)  ' no rtn val
End Sub

Private Function Max(Param1 As Long, Param2 As Long) As Long
    Max = IIf(Param1 > Param2, Param1, Param2)
End Function

Private Function GetToolInfo(ByVal hWndTool As Long, _
                             ByRef ti As TOOLINFO, _
                             Optional ByVal fGetText As Boolean = False) As Boolean
    'Dim i As Integer

    On Error Resume Next

    ti.cbSize = LenB(ti)
    If fGetText Then ti.lpszText = String(m_cMaxTip, 0)

    ' call returns 1 on success, 0 on failure...
    If SendMessage(m_hWndTT, TTM_ENUMTOOLS, 0, ti) = 1 Then
        If hWndTool = ti.uId Then
            GetToolInfo = True
        Else
            GetToolInfo = False
        End If
    End If
End Function

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=13,0,0,
Public Property Get Caption() As String
Attribute Caption.VB_Description = "��ť���⡣"
Attribute Caption.VB_UserMemId = -518
    Caption = m_Caption
End Property

Public Property Let Caption(ByVal New_Caption As String)
    m_Caption = New_Caption

    Call ReDraw
    Call PropertyChanged("Caption")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=0,0,0,False
Public Property Get Value() As Boolean
Attribute Value.VB_Description = "��ť״ֵ̬��"
    Value = m_Value
End Property

Public Property Let Value(ByVal New_Value As Boolean)
    m_Value = New_Value
    Call ReDraw
    Call PropertyChanged("Value")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,MousePointer
Public Property Get MousePointer() As MousePointerConstants
Attribute MousePointer.VB_Description = "����/���õ���꾭������ĳһ����ʱ����ָ�����͡�"
    MousePointer = UserControl.MousePointer
End Property

Public Property Let MousePointer(ByVal New_MousePointer As MousePointerConstants)
    UserControl.MousePointer() = New_MousePointer
    Call PropertyChanged("MousePointer")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,MouseIcon
Public Property Get MouseIcon() As Picture
Attribute MouseIcon.VB_Description = "����һ���Զ������ͼ�ꡣ"
    Set MouseIcon = UserControl.MouseIcon
End Property

Public Property Set MouseIcon(ByVal New_MouseIcon As Picture)
    Set UserControl.MouseIcon = New_MouseIcon
    If Not (UserControl.MouseIcon Is Nothing) Then
        Me.MousePointer = vbCustom
    End If
    Call PropertyChanged("MouseIcon")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=7,0,0,vbLeftButton
Public Property Get UseButton() As eUseButton
Attribute UseButton.VB_Description = "��ťʹ�õ���갴ť��"
    UseButton = m_UseButton
End Property

Public Property Let UseButton(ByVal New_UseButton As eUseButton)
    m_UseButton = New_UseButton
    Call PropertyChanged("UseButton")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=23,0,0,bsNormal
Public Property Get Style() As eButtonStyle
Attribute Style.VB_Description = "��ť��ʽ��"
    Style = m_Style
End Property

Public Property Let Style(ByVal New_Style As eButtonStyle)
    m_Style = New_Style
    Call ReDraw
    Call PropertyChanged("Style")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=11,0,0,0
Public Property Get Picture() As Picture
Attribute Picture.VB_Description = "����/���ÿؼ�����ʾ��ͼ�Ρ�"
    Set Picture = m_Picture
End Property

Public Property Set Picture(ByVal New_Picture As Picture)
    Set m_Picture = New_Picture
    Call ReDraw
    Call PropertyChanged("Picture")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=11,0,0,0
Public Property Get DownPicture() As Picture
Attribute DownPicture.VB_Description = "��ť����ʱ��ʾ��ͼƬ��"
    Set DownPicture = m_DownPicture
End Property

Public Property Set DownPicture(ByVal New_DownPicture As Picture)
    Set m_DownPicture = New_DownPicture
    Call PropertyChanged("DownPicture")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=11,0,0,0
Public Property Get OverPicture() As Picture
Attribute OverPicture.VB_Description = "��꾭����ťʱ��ʾ��ͼƬ��"
    Set OverPicture = m_OverPicture
End Property

Public Property Set OverPicture(ByVal New_OverPicture As Picture)
    Set m_OverPicture = New_OverPicture
    Call PropertyChanged("OverPicture")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,Enabled
Public Property Get Enabled() As Boolean
Attribute Enabled.VB_Description = "����/����һ��ֵ������һ�������Ƿ���Ӧ�û������¼���"
    Enabled = UserControl.Enabled
End Property

Public Property Let Enabled(ByVal New_Enabled As Boolean)
    UserControl.Enabled() = New_Enabled
    Call SetCapture(UserControl.hWnd)
    Call ReleaseCapture
    Call ResetButton
    Call ReDraw
    Call PropertyChanged("Enabled")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vb3DHighlight
Public Property Get LightBorderColor1() As OLE_COLOR
Attribute LightBorderColor1.VB_Description = "���߿���ɫ1(����)"
    LightBorderColor1 = m_LightBorderColor1
End Property

Public Property Let LightBorderColor1(ByVal New_LightBorderColor1 As OLE_COLOR)
    m_LightBorderColor1 = New_LightBorderColor1
    Call ReDraw
    Call PropertyChanged("LightBorderColor1")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vbButtonShadow
Public Property Get DarkBorderColor1() As OLE_COLOR
Attribute DarkBorderColor1.VB_Description = "���߿���ɫ1(����)"
    DarkBorderColor1 = m_DarkBorderColor1
End Property

Public Property Let DarkBorderColor1(ByVal New_DarkBorderColor1 As OLE_COLOR)
    m_DarkBorderColor1 = New_DarkBorderColor1
    Call ReDraw
    Call PropertyChanged("DarkBorderColor1")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vb3DLight
Public Property Get LightBorderColor2() As OLE_COLOR
Attribute LightBorderColor2.VB_Description = "���߿���ɫ2(����)"
    LightBorderColor2 = m_LightBorderColor2
End Property

Public Property Let LightBorderColor2(ByVal New_LightBorderColor2 As OLE_COLOR)
    m_LightBorderColor2 = New_LightBorderColor2
    Call ReDraw
    Call PropertyChanged("LightBorderColor2")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vb3DDKShadow
Public Property Get DarkBorderColor2() As OLE_COLOR
Attribute DarkBorderColor2.VB_Description = "���߿���ɫ2(����)"
    DarkBorderColor2 = m_DarkBorderColor2
End Property

Public Property Let DarkBorderColor2(ByVal New_DarkBorderColor2 As OLE_COLOR)
    m_DarkBorderColor2 = New_DarkBorderColor2
    Call ReDraw
    Call PropertyChanged("DarkBorderColor2")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=lblCaption,lblCaption,-1,Font
Public Property Get Font() As Font
Attribute Font.VB_Description = "����һ�� Font ����"
Attribute Font.VB_UserMemId = -512
    Set Font = lblCaption.Font
End Property

Public Property Set Font(ByVal New_Font As Font)
    Set lblCaption.Font = New_Font
    Set lblLine.Font = New_Font
    Call PropertyChanged("Font")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vbGrayText
Public Property Get DisableColor() As OLE_COLOR
Attribute DisableColor.VB_Description = "��Чʱ����ɫ��"
    DisableColor = m_DisableColor
End Property

Public Property Let DisableColor(ByVal New_DisableColor As OLE_COLOR)
    m_DisableColor = New_DisableColor
    Call PropertyChanged("DisableColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vbBlue
Public Property Get HotColor() As OLE_COLOR
Attribute HotColor.VB_Description = "�ȸ�����ɫ��"
    HotColor = m_HotColor
End Property

Public Property Let HotColor(ByVal New_HotColor As OLE_COLOR)
    m_HotColor = New_HotColor
    Call PropertyChanged("HotColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=0,0,0,False
Public Property Get EnableHot() As Boolean
Attribute EnableHot.VB_Description = "�Ƿ������ȸ��١�"
    EnableHot = m_EnableHot
End Property

Public Property Let EnableHot(ByVal New_EnableHot As Boolean)
    m_EnableHot = New_EnableHot
    Call PropertyChanged("EnableHot")
End Property
'
'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=11,0,0,0
Public Property Get Icon() As Picture
Attribute Icon.VB_Description = "��ťͼ�ꡣ"
    Set Icon = m_Icon
End Property

Public Property Set Icon(ByVal New_Icon As Picture)
    Set m_Icon = New_Icon
    Set imgIcon.Picture = m_Icon
    Call ReDraw
    Call PropertyChanged("Icon")
End Property
'
'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=13,0,0,
Public Property Get ToolTip() As String
Attribute ToolTip.VB_Description = "������ʾ�ı���"
    ToolTip = m_ToolTip
End Property

Public Property Let ToolTip(ByVal New_ToolTip As String)
    m_ToolTip = New_ToolTip
    Call SetToolTip(m_ToolTip)
    Call PropertyChanged("ToolTip")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=UserControl,UserControl,-1,hWnd
Public Property Get hWnd() As Long
Attribute hWnd.VB_Description = "����һ�������(from Microsoft Windows)һ������Ĵ��ڡ�"
    hWnd = UserControl.hWnd
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vbButtonShadow
Public Property Get FocusColor() As OLE_COLOR
Attribute FocusColor.VB_Description = "��������ɫ��"
    FocusColor = m_FocusColor
End Property

Public Property Let FocusColor(ByVal New_FocusColor As OLE_COLOR)
    m_FocusColor = New_FocusColor
    Call PropertyChanged("FocusColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,0
Public Property Get OverBorderColor() As OLE_COLOR
Attribute OverBorderColor.VB_Description = "Flat ��ʽ�߿���ɫ��"
    OverBorderColor = m_OverBorderColor
End Property

Public Property Let OverBorderColor(ByVal New_OverBorderColor As OLE_COLOR)
    m_OverBorderColor = New_OverBorderColor
    Call ReDraw
    Call PropertyChanged("OverBorderColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,0
Public Property Get DownBorderColor() As OLE_COLOR
Attribute DownBorderColor.VB_Description = "Flat ��ʽ���±߿���ɫ��"
    DownBorderColor = m_DownBorderColor
End Property

Public Property Let DownBorderColor(ByVal New_DownBorderColor As OLE_COLOR)
    m_DownBorderColor = New_DownBorderColor
    Call ReDraw
    Call PropertyChanged("DownBorderColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,0
Public Property Get BorderColor() As OLE_COLOR
Attribute BorderColor.VB_Description = "Flat ��ʽ�߿���ɫ��"
    BorderColor = m_BorderColor
End Property

Public Property Let BorderColor(ByVal New_BorderColor As OLE_COLOR)
    m_BorderColor = New_BorderColor
    Call ReDraw
    Call PropertyChanged("BorderColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,0
Public Property Get OverBackColor() As OLE_COLOR
Attribute OverBackColor.VB_Description = "����ɫ"
    OverBackColor = m_OverBackColor
End Property

Public Property Let OverBackColor(ByVal New_OverBackColor As OLE_COLOR)
    m_OverBackColor = New_OverBackColor
    Call ReDraw
    Call PropertyChanged("OverBackColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,0
Public Property Get DownBackColor() As OLE_COLOR
Attribute DownBackColor.VB_Description = "���±���ɫ"
    DownBackColor = m_DownBackColor
End Property

Public Property Let DownBackColor(ByVal New_DownBackColor As OLE_COLOR)
    m_DownBackColor = New_DownBackColor
    Call ReDraw
    Call PropertyChanged("DownBackColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,0
Public Property Get BackColor() As OLE_COLOR
Attribute BackColor.VB_Description = "����ɫ"
    BackColor = m_BackColor
End Property

Public Property Let BackColor(ByVal New_BackColor As OLE_COLOR)
    m_BackColor = New_BackColor
    Call ReDraw
    Call PropertyChanged("BackColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MappingInfo=lblCaption,lblCaption,-1,ForeColor
Public Property Get ForeColor() As OLE_COLOR
Attribute ForeColor.VB_Description = "����/���ö������ı���ͼ�ε�ǰ��ɫ��"
    ForeColor = lblCaption.ForeColor
End Property

Public Property Let ForeColor(ByVal New_ForeColor As OLE_COLOR)
    lblCaption.ForeColor() = New_ForeColor
    lblLine.ForeColor = New_ForeColor
    Call PropertyChanged("ForeColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=10,0,0,vbBlack
Public Property Get NormalForeColor() As OLE_COLOR
Attribute NormalForeColor.VB_Description = "��ͨǰ��ɫ��"
    NormalForeColor = m_NormalForeColor
End Property

Public Property Let NormalForeColor(ByVal New_NormalForeColor As OLE_COLOR)
    m_NormalForeColor = New_NormalForeColor
    lblCaption.ForeColor() = New_NormalForeColor
    lblLine.ForeColor = New_NormalForeColor
    Call PropertyChanged("NormalForeColor")
End Property

'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=0,0,0,False
Public Property Get AutoSize() As Boolean
Attribute AutoSize.VB_Description = "�����ؼ��Ƿ����Զ�������С����ʾ���е����ݡ�"
    AutoSize = m_AutoSize
End Property

Public Property Let AutoSize(ByVal New_AutoSize As Boolean)
    m_AutoSize = New_AutoSize
    Call ReDraw
    Call PropertyChanged("AutoSize")
End Property
'ע�⣡��Ҫɾ�����޸����б�ע�͵��У�
'MemberInfo=8,0,0,0
Public Property Get IconSize() As eIconSize
Attribute IconSize.VB_Description = "��ťͼ���С��"
    IconSize = m_IconSize
End Property

Public Property Let IconSize(ByVal New_IconSize As eIconSize)
    m_IconSize = New_IconSize
    Call ReDraw
    Call PropertyChanged("IconSize")
End Property
