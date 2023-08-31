codeunit 50102 RSMUSFinancialReporting
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// Print.
    /// </summary>
    /// <param name="FinancialReport">Record "Financial Report".</param>
    procedure Print(FinancialReport: Record "Financial Report")
    var
        RSMUSAccountSchedule: Report "RSMUSAccount Schedule";
    begin
        RSMUSAccountSchedule.SetFinancialReportName(FinancialReport.Name);
        RSMUSAccountSchedule.Run();
    end;

    /// <summary>
    /// PrintAndZip.
    /// </summary>
    /// <param name="FinancialReport">Record "Financial Report".</param>
    procedure PrintAndZip(FinancialReport: Record "Financial Report")
    var
        Dim: Record Dimension;
        DimVal: Record "Dimension Value";
        Rep50100: Report "RSMUSAccount Schedule";
        Zip: Codeunit "Data Compression";
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
        IStream: InStream;
        XMLParams: Text;
        NewDateFilter, NewDim1Filter : Text;
        StartDate, EndDate : Text;
        FileName: Text;
    begin
        // prepare request page
        Clear(Rep50100);
        Rep50100.SetAccSchedName(FinancialReport.Name);
        Rep50100.SetFinancialReportName(FinancialReport.Name);
        XMLParams := Rep50100.RunRequestPage();
        if XMLParams <> '' then begin
            // extract dates from request page xml
            GetNodeValue(XMLParams, 'StartDate', StartDate);
            GetNodeValue(XMLParams, 'EndDate', EndDate);

            // initialize zip
            Zip.CreateZipArchive();

            NewDateFilter := StartDate + '..' + EndDate;

            Dim.Get('DEPARTMENT');
            DimVal.SetRange("Dimension Code", Dim.Code);
            DimVal.SetRange(Blocked, false);
            if DimVal.FindSet() then
                repeat
                    // run report for each dim and add to zip
                    Clear(Rep50100);
                    NewDim1Filter := DimVal.Code;
                    Rep50100.SetFilters(NewDateFilter, '', '', '', NewDim1Filter, '', '', '');
                    TempBlob.CreateOutStream(OStream);
                    Rep50100.SaveAs(XMLParams, ReportFormat::Pdf, OStream);
                    TempBlob.CreateInStream(IStream);
                    FileName := DimVal.Code + '.pdf';
                    Zip.AddEntry(IStream, FileName);
                until DimVal.Next() = 0;

            // download zip
            TempBlob.CreateOutStream(OStream);
            Zip.SaveZipArchive(OStream);
            TempBlob.CreateInStream(IStream);
            FileName := FinancialReport.Name + ' data.zip';
            DownloadFromStream(IStream, '', '', '', FileName);
        end;
    end;

    local procedure GetNodeValue(XMLParams: Text; NodeName: Text; var NodeVariable: Text)
    var
        XMLBuffer, Dim1Node : Record "XML Buffer";
        XMLBufferWriter: Codeunit "XML Buffer Writer";
    begin
        XMLBufferWriter.InitializeXMLBufferFromText(XMLBuffer, XMLParams);
        XMLBuffer.SetFilter(Path, '/ReportParameters/Options/Field/@name');
        XMLBuffer.SetRange(Value, NodeName);
        if XMLBuffer.FindLast() then
            if Not Dim1Node.Get(XMLBuffer."Parent Entry No.") then Error('some bad data');
        NodeVariable := Dim1Node.Value;
    end;
}