Attribute VB_Name = "ResizePics"
Option Explicit

Const DocName As String = "27.Oct.2013 Fotos.docx"
Dim sh As InlineShape
Dim shObj As Shape

Sub ResizePics()
    For Each shObj In _
    Documents(DocName).Shapes
        shObj.ConvertToInlineShape
    Next shObj
    
    For Each sh In _
    Documents(DocName).InlineShapes
        If _
        (PointsToInches(sh.Width) > 3.13) And _
        (PointsToInches(sh.Width) < 7.7) _
        Then
            sh.Width = InchesToPoints(3.13)
        End If
    Next sh
End Sub

