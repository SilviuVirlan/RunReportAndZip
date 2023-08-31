pageextension 50105 "RSMUSAccount Schedule Overview" extends "Acc. Schedule Overview"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Print)
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
                    FinRep: Record "Financial Report";
                    RSMUSFinancialReportMgt: Codeunit RSMUSFinancialReporting;
                begin
                    FinRep.Get(Rec."Schedule Name");
                    RSMUSFinancialReportMgt.Print(FinRep);
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
                    FinRep: Record "Financial Report";
                    RSMUSFinancialReportMgt: Codeunit RSMUSFinancialReporting;
                begin
                    FinRep.Get(Rec."Schedule Name");
                    RSMUSFinancialReportMgt.PrintAndZip(FinRep);
                end;
            }
        }
    }
}