VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Begin VB.Form frmLogin 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fixed Single
   Caption         =   "�û���¼"
   ClientHeight    =   3030
   ClientLeft      =   2835
   ClientTop       =   3480
   ClientWidth     =   7170
   Icon            =   "frmLogin.frx":0000
   LockControls    =   -1  'True
   MaxButton       =   0   'False
   MinButton       =   0   'False
   NegotiateMenus  =   0   'False
   ScaleHeight     =   3030
   ScaleWidth      =   7170
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '��Ļ����
   Begin Othello.FlatButton fltbtnOption 
      Height          =   360
      Left            =   5190
      TabIndex        =   9
      Top             =   2475
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   635
      Caption         =   "��������(&S)"
      MousePointer    =   99
      Style           =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "����"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      EnableHot       =   -1  'True
      ForeColor       =   0
   End
   Begin VB.Timer AutoLoginTimer 
      Enabled         =   0   'False
      Interval        =   1
      Left            =   4635
      Top             =   1905
   End
   Begin Othello.FlatButton fltbtnRegister 
      Height          =   360
      Left            =   3645
      TabIndex        =   8
      Top             =   2475
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   635
      Caption         =   "ע����(&W)"
      MousePointer    =   99
      Style           =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "����"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      EnableHot       =   -1  'True
      ForeColor       =   0
   End
   Begin Othello.FlatButton fltbtnCancel 
      Cancel          =   -1  'True
      Height          =   360
      Left            =   2115
      TabIndex        =   7
      Top             =   2475
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   635
      Caption         =   "ȡ��(&C)"
      MousePointer    =   99
      Style           =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "����"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      EnableHot       =   -1  'True
      ForeColor       =   0
   End
   Begin Othello.FlatButton fltbtnOK 
      Default         =   -1  'True
      Height          =   360
      Left            =   570
      TabIndex        =   6
      Top             =   2475
      Width           =   1410
      _ExtentX        =   2487
      _ExtentY        =   635
      Caption         =   "ȷ��(&O)"
      MousePointer    =   99
      Style           =   2
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "����"
         Size            =   9
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      EnableHot       =   -1  'True
      ForeColor       =   0
   End
   Begin VB.ComboBox cboUserName 
      Height          =   300
      IntegralHeight  =   0   'False
      ItemData        =   "frmLogin.frx":000C
      Left            =   1710
      List            =   "frmLogin.frx":000E
      TabIndex        =   1
      Top             =   240
      Width           =   2580
   End
   Begin VB.CheckBox chkSavePassword 
      Caption         =   "��ס��¼�ɹ��������(&R)"
      Height          =   195
      Left            =   1710
      TabIndex        =   4
      Top             =   1695
      Width           =   2370
   End
   Begin VB.CheckBox chkAutoLogin 
      Caption         =   "�����������Զ���¼(&A)"
      Height          =   195
      Left            =   1710
      TabIndex        =   5
      Top             =   1995
      Width           =   2190
   End
   Begin InetCtlsObjects.Inet ietLogin 
      Left            =   5145
      Top             =   1755
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      URL             =   "http://"
      RequestTimeout  =   30
   End
   Begin VB.TextBox txtPassword 
      Height          =   300
      IMEMode         =   3  'DISABLE
      Left            =   1710
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   1170
      Width           =   2580
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "��������Ҹ���԰BBS �Ļ�Ա������ʹ��BBS���û����������¼��"
      Height          =   630
      Left            =   4620
      TabIndex        =   11
      Top             =   1170
      Width           =   2190
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label1 
      Caption         =   "�����������û���������: Hex,�Ҹ���԰ �ȡ�"
      Height          =   405
      Left            =   1755
      TabIndex        =   10
      Top             =   615
      Width           =   2190
      WordWrap        =   -1  'True
   End
   Begin VB.Image imgLogin 
      Height          =   675
      Left            =   4620
      MousePointer    =   99  'Custom
      Picture         =   "frmLogin.frx":0010
      ToolTipText     =   "�����Ҹ���԰BBS"
      Top             =   240
      Width           =   2175
   End
   Begin VB.Label lblUserName 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "�û���(&U):"
      BeginProperty Font 
         Name            =   "����"
         Size            =   12
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   315
      TabIndex        =   0
      Top             =   255
      Width           =   1305
   End
   Begin VB.Label lblPassword 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "��  ��(&P):"
      BeginProperty Font 
         Name            =   "����"
         Size            =   12
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   240
      Left            =   330
      TabIndex        =   2
      Top             =   1185
      Width           =   1320
   End
End
Attribute VB_Name = "frmLogin"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim Auto As Boolean

Dim mblnServerOK As Boolean

Dim mblnAutoLogin As Boolean
Dim mblnSavePassword As Boolean

Private Sub fltbtnOption_Click(Button As Integer)
    Call frmOption.ShowEx(2)
End Sub

Private Sub Form_Load()
    On Error Resume Next

    Set Me.Icon = MainForm.Icon
    Set imgLogin.MouseIcon = HandCursor

    Auto = False
    ' װ���û���ʷ��¼����������ݣ��Ƿ��Զ���½�ȣ�
    Call LoadUserList
    chkSavePassword.Value = Abs(mblnSavePassword)
    chkAutoLogin.Value = Abs(mblnAutoLogin)
End Sub

Private Sub AutoLoginTimer_Timer()
    AutoLoginTimer.Enabled = False
    Call fltbtnOK_Click(vbLeftButton)
End Sub

Private Sub cboUserName_Click()
    Call SetControlFocus(txtPassword)
End Sub

Private Sub fltbtnCancel_Click(Button As Integer)
    '����ȫ�ֱ���Ϊ false
    '����ʾʧ�ܵĵ�¼
    Call ietLogin.Cancel
    Call Unload(Me)
End Sub

Public Sub fltbtnOK_Click(Button As Integer)
    Dim strUrl As String
    Dim strStatus As String
    Dim strData As String
    Dim strID As String

    On Error Resume Next

    If Len(cboUserName.Text) < 2 Or Len(cboUserName.Text) > 15 Or Not CheckString(cboUserName.Text) Then
        If mblnAutoLogin And Auto Then
            Call MessageBox(Me.hWnd, LoadString(102), vbExclamation, LoadString(181))
            Call Unload(Me)
        Else
            Call MessageBox(Me.hWnd, LoadString(102), vbExclamation, LoadString(181))
            Call SetControlFocus(cboUserName)
            Call SendKeys("{Home}+{End}")
        End If
        Exit Sub
    End If
    
    If Len(txtPassword.Text) < 5 Or Len(txtPassword.Text) > 15 Or Not CheckString(txtPassword.Text) Then
        If mblnAutoLogin And Auto Then
            Call MessageBox(Me.hWnd, LoadString(103), vbExclamation, LoadString(181))
            'Me.Hide
            Call Unload(Me)
        Else
            Call MessageBox(Me.hWnd, LoadString(103), vbExclamation, LoadString(181))
            Call SetControlFocus(txtPassword)
            Call SendKeys("{Home}+{End}")
        End If
        Exit Sub
    End If

    Screen.MousePointer = vbHourglass
    Me.Caption = LoadString(250)
    cboUserName.Enabled = False
    txtPassword.Enabled = False

    ' ���Ȼ�õ�½���(��ð�ȫ�������)
    strUrl = gstrSave_ServerUrl & SERVER_ACTION_GET
    If ServerCommand(ietLogin, mblnServerOK, strUrl, strStatus, strData, True) Then
        If strStatus = STATUS_OK Then
            strID = GetRecord(strData, 1)
            gstrSecurity1 = GetRecord(strData, 2)
            gstrSecurity2 = GetRecord(strData, 3)
        End If
    End If

    strUrl = gstrSave_ServerUrl & SERVER_ACTION_LOGIN & "?username=" & ToUrlString(cboUserName.Text) & _
                                  "&password=" & MD5(txtPassword.Text) & _
                                  "&lanip=" & gstrLocalIP & _
                                  "&port=" & CStr(glngSave_GamePort) & _
                                  "&id=" & strID & _
                                  "&" & MakeServerPassword() & _
                                  "&" & MakeVersion()
    If ServerCommand(ietLogin, mblnServerOK, strUrl, strStatus, strData, Auto) Then
        Screen.MousePointer = vbDefault
        Me.Caption = LoadString(251)

        Select Case strStatus
            Case STATUS_OK
                Me.Enabled = False
                Call LoadUserInfo(gMyUserInfo, strData)
                gMyUserInfo.UserName = cboUserName.Text
                gMyUserInfo.Password = txtPassword.Text
                gstrIP = GetRecord(strData, 15)
                ' ȡ�ð�ȫ�������
                gstrSecurity1 = GetRecord(strData, 16)
                gstrSecurity2 = GetRecord(strData, 17)
                gblnLogin = True
                Call SaveUserList
                If GetRecordCount(strData) > 17 Then
                    Call MessageBox(Me.hWnd, GetRecord(strData, 18), vbInformation, LoadString(187))
                End If
                ' ������Ч
                Call PlaySoundEffects(SOUND_LOGIN, gstrSave_SoundValue(SOUND_LOGIN))

                Call MainForm.LoginSet
                Call Unload(Me)
                'If MessageBox(MainForm.hwnd, "���������������������", vbQuestion Or vbYesNo, "����") = vbYes Then
                '    Call frmCreateTable.Show(vbModal)
                'End If
            Case STATUS_ERROR
                cboUserName.Enabled = True
                txtPassword.Enabled = True
                If mblnAutoLogin And Auto Then
                    Call MessageBox(Me.hWnd, LoadString(167) & strData, vbExclamation, LoadString(181))
                    Call Unload(Me)
                Else
                    Call MessageBox(Me.hWnd, LoadString(167) & strData, vbExclamation, LoadString(181))
                    Call SetControlFocus(txtPassword)
                    Call SendKeys("{Home}+{End}")
                End If
            Case Else
                cboUserName.Enabled = True
                txtPassword.Enabled = True
                If mblnAutoLogin And Auto Then
                    Call MessageBox(Me.hWnd, LoadString(168), vbExclamation, LoadString(181))
                    Call Unload(Me)
                Else
                    Call MessageBox(Me.hWnd, LoadString(168), vbExclamation, LoadString(181))
                    Call SetControlFocus(txtPassword)
                    Call SendKeys("{Home}+{End}")
                End If
        End Select
    Else
        Screen.MousePointer = vbDefault
        Me.Caption = LoadString(251)
        cboUserName.Enabled = True
        txtPassword.Enabled = True
        Call SetControlFocus(cboUserName)
        If mblnAutoLogin And Auto Then
            'Call MsgBox("��½ʧ�ܣ�" + vbCr + vbCr + LoadString(101), vbCritical, "�Զ���½")
            Call Unload(Me)
        'Else
            'Call MessageBox(Me.hWnd, "��½ʧ�ܣ�" + vbCr + vbCr + LoadString(101))
        End If
    End If
End Sub

Private Sub fltbtnRegister_Click(Button As Integer)
    On Error Resume Next

    Call Unload(Me)
    Call frmRegister.Show(vbModal, MainForm)
End Sub

Private Sub Form_Activate()
    If cboUserName.Text = "" Then
        Call SetControlFocus(cboUserName)
    Else
        Call SetControlFocus(txtPassword)
    End If
    'MainForm.fltbtnUser.Reset
End Sub

' װ���û���ʷ��¼�����������
Private Sub LoadUserList()
    Dim i As Integer

    On Error Resume Next

    ' װ���û���ʷ��¼
    For i = 1 To MAX_USER_LIST
        If gstrSave_UserList(i) <> "" Then
            Call cboUserName.AddItem(gstrSave_UserList(i))
        End If
    Next i
    cboUserName.Text = cboUserName.List(0)

    ' װ���������
    mblnAutoLogin = gblnSave_AutoLogin
    mblnSavePassword = gblnSave_SavePassword
    If gstrSave_UserName <> "" Then
        cboUserName.Text = gstrSave_UserName
    End If
    txtPassword.Text = Decipher(gstrLocalPassword, gstrSave_Password)
End Sub

' �����û���ʷ��¼�����������
Private Sub SaveUserList()
    Dim i As Integer
    Dim j As Integer
    Dim Temp As String
    Dim User(MAX_USER_LIST) As String

    On Error Resume Next

    For i = 1 To MAX_USER_LIST
        Temp = gstrSave_UserList(i)
        If Temp <> "" And Temp <> cboUserName.Text Then
            User(i) = Temp
        End If
    Next i

    For i = 1 To MAX_USER_LIST - 1
        For j = i + 1 To MAX_USER_LIST
            If User(i) = "" And User(j) <> "" Then
                Call Swap(User(i), User(j))
                Exit For
            End If
        Next j
    Next i
    For i = MAX_USER_LIST To 2 Step -1
        User(i) = User(i - 1)
    Next i
    User(1) = cboUserName.Text

    For i = 1 To MAX_USER_LIST
        gstrSave_UserList(i) = User(i)
    Next i

    Call SaveData
End Sub

Private Sub SaveData()
    If chkSavePassword.Value <> 0 And StrLen(txtPassword.Text) >= 5 Then
        gblnSave_AutoLogin = chkAutoLogin.Value
        gblnSave_SavePassword = chkSavePassword.Value
        gstrSave_UserName = cboUserName.Text
        gstrSave_Password = Cipher(gstrLocalPassword, txtPassword.Text)
    Else
        gblnSave_AutoLogin = False
        gblnSave_SavePassword = False
        gstrSave_UserName = ""
        gstrSave_Password = ""
    End If
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
    Call SaveData
End Sub

Private Sub ietLogin_StateChanged(ByVal State As Integer)
    'Dim strMess As String '��Ϣ������
    Select Case State
        Case icResponseReceived
            mblnServerOK = True
        Case icError  '11
            mblnServerOK = False
            '�õ������ı���
            'strMess = "ErrorCode: " & ietRegister.ResponseCode & " : " & ietRegister.ResponseInfo
    End Select
End Sub

Public Sub ShowEx()
    On Error Resume Next

    Call Load(frmLogin)
    If mblnAutoLogin Then
        'Me.Hide
        Auto = True
        AutoLoginTimer.Enabled = True
    Else
        Auto = False
        Call Me.Show(vbModal)
    End If
End Sub

Private Sub imgLogin_Click()
    On Error Resume Next

    Call ShellExecute(Me.hWnd, "open", HAPPY_FAMILY_BBS, 0, 0, 1)
End Sub

Private Sub txtPassword_GotFocus()
    Call AutoSelectText(txtPassword)
End Sub
