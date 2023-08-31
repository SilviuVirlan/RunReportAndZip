pageextension 50104 RSMUSFinancialReports extends "Financial Reports"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore(Print)
        {
            action(RSMUSPrintRSM)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print (Custom)';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    RSMUSFinancialReportMgt: Codeunit RSMUSFinancialReporting;
                begin
                    RSMUSFinancialReportMgt.Print(Rec);
                end;
            }
            action(RSMUSPrintAndZip)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print Per Dept. and ZIP (Custom)';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';

                trigger OnAction()
                var
                    RSMUSFinancialReportMgt: Codeunit RSMUSFinancialReporting;
                begin
                    RSMUSFinancialReportMgt.PrintAndZip(Rec);
                end;
            }
        }
    }


}