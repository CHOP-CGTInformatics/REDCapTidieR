# Combining skimr, labelled, and xlsx returns expected snapshot

    Code
      wb_list
    Output
      [[1]]
         tab_name tab_sheet tab_ref
      1    Table1         1  A2:H12
      2    Table2         2   A2:D6
      3    Table3         3   A2:D6
      4    Table4         4   A2:E6
      5    Table5         5  A2:AE6
      6    Table6         6   A2:R6
      7    Table7         7   A2:C6
      8    Table8         8   A2:E6
      9    Table9         9   A2:I6
      10  Table10        10   A2:J5
      11  Table11        11 A2:AZ68
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   tab_xml
      1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="1" name="Table1" displayName="Table1" ref="A2:H12" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:H12"/><tableColumns count="8"><tableColumn id="1" name="redcap_form_name"/><tableColumn id="2" name="redcap_form_label"/><tableColumn id="3" name="structure"/><tableColumn id="4" name="data_rows"/><tableColumn id="5" name="data_cols"/><tableColumn id="6" name="data_size"/><tableColumn id="7" name="data_na_pct"/><tableColumn id="8" name="Sheet #"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="2" name="Table2" displayName="Table2" ref="A2:D6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:D6"/><tableColumns count="4"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="nonrepeat_1"/><tableColumn id="3" name="nonrepeat_2"/><tableColumn id="4" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="3" name="Table3" displayName="Table3" ref="A2:D6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:D6"/><tableColumns count="4"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="nonrepeat_3"/><tableColumn id="3" name="nonrepeat_4"/><tableColumn id="4" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="4" name="Table4" displayName="Table4" ref="A2:E6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:E6"/><tableColumns count="5"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="redcap_form_instance"/><tableColumn id="3" name="repeat_1"/><tableColumn id="4" name="repeat_2"/><tableColumn id="5" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="5" name="Table5" displayName="Table5" ref="A2:AE6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:AE6"/><tableColumns count="31"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="text"/><tableColumn id="3" name="note"/><tableColumn id="4" name="calculated"/><tableColumn id="5" name="dropdown_single"/><tableColumn id="6" name="radio_single"/><tableColumn id="7" name="radio_duplicate_label"/><tableColumn id="8" name="checkbox_multiple___1"/><tableColumn id="9" name="checkbox_multiple___2"/><tableColumn id="10" name="checkbox_multiple___3"/><tableColumn id="11" name="checkbox_multiple___4"/><tableColumn id="12" name="checkbox_multiple___5"/><tableColumn id="13" name="checkbox_multiple___6"/><tableColumn id="14" name="checkbox_multiple___7"/><tableColumn id="15" name="checkbox_multiple___8"/><tableColumn id="16" name="checkbox_multiple___9"/><tableColumn id="17" name="checkbox_multiple___10"/><tableColumn id="18" name="checkbox_multiple___-99"/><tableColumn id="19" name="checkbox_multiple___-98"/><tableColumn id="20" name="checkbox_multiple_2___aa"/><tableColumn id="21" name="checkbox_multiple_2___b1b"/><tableColumn id="22" name="checkbox_multiple_2___ccc2"/><tableColumn id="23" name="checkbox_multiple_2___3dddd"/><tableColumn id="24" name="checkbox_multiple_2___4eeee5"/><tableColumn id="25" name="yesno"/><tableColumn id="26" name="truefalse"/><tableColumn id="27" name="signature"/><tableColumn id="28" name="fileupload"/><tableColumn id="29" name="slider"/><tableColumn id="30" name="radio_dtxt_error"/><tableColumn id="31" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="6" name="Table6" displayName="Table6" ref="A2:R6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:R6"/><tableColumns count="18"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="text_dmy"/><tableColumn id="3" name="text_mdy"/><tableColumn id="4" name="text_ymd"/><tableColumn id="5" name="text_dmy_hm"/><tableColumn id="6" name="text_mdy_hm"/><tableColumn id="7" name="text_ymd_hm"/><tableColumn id="8" name="text_dmy_hms"/><tableColumn id="9" name="text_mdy_hms"/><tableColumn id="10" name="text_ymd_hms"/><tableColumn id="11" name="text_mrn"/><tableColumn id="12" name="text_phone"/><tableColumn id="13" name="text_ssn"/><tableColumn id="14" name="text_hms"/><tableColumn id="15" name="text_hm"/><tableColumn id="16" name="text_ms"/><tableColumn id="17" name="text_zip"/><tableColumn id="18" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="7" name="Table7" displayName="Table7" ref="A2:C6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:C6"/><tableColumns count="3"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="api_text"/><tableColumn id="3" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      8                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="8" name="Table8" displayName="Table8" ref="A2:E6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:E6"/><tableColumns count="5"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="api_text_2"/><tableColumn id="3" name="api_text_3"/><tableColumn id="4" name="api_text_4"/><tableColumn id="5" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      9                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="9" name="Table9" displayName="Table9" ref="A2:I6" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:I6"/><tableColumns count="9"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="survey_yesno"/><tableColumn id="3" name="survey_radio"/><tableColumn id="4" name="survey_checkbox___one"/><tableColumn id="5" name="survey_checkbox___two"/><tableColumn id="6" name="survey_checkbox___three"/><tableColumn id="7" name="redcap_survey_identifier"/><tableColumn id="8" name="redcap_survey_timestamp"/><tableColumn id="9" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      10                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="10" name="Table10" displayName="Table10" ref="A2:J5" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:J5"/><tableColumns count="10"><tableColumn id="1" name="record_id"/><tableColumn id="2" name="redcap_form_instance"/><tableColumn id="3" name="repeatsurvey_yesno"/><tableColumn id="4" name="repeatsurvey_radio_v2"/><tableColumn id="5" name="repeatsurvey_checkbox_v2___one"/><tableColumn id="6" name="repeatsurvey_checkbox_v2___two"/><tableColumn id="7" name="repeatsurvey_checkbox_v2___three"/><tableColumn id="8" name="redcap_survey_identifier"/><tableColumn id="9" name="redcap_survey_timestamp"/><tableColumn id="10" name="form_status_complete"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
      11 <table xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" id="11" name="Table11" displayName="Table11" ref="A2:AZ68" totalsRowCount="0" totalsRowShown="0"><autoFilter ref="A2:AZ68"/><tableColumns count="52"><tableColumn id="1" name="redcap_form_name"/><tableColumn id="2" name="redcap_form_label"/><tableColumn id="3" name="field_name"/><tableColumn id="4" name="field_label"/><tableColumn id="5" name="field_type"/><tableColumn id="6" name="section_header"/><tableColumn id="7" name="select_choices_or_calculations"/><tableColumn id="8" name="field_note"/><tableColumn id="9" name="text_validation_type_or_show_slider_number"/><tableColumn id="10" name="text_validation_min"/><tableColumn id="11" name="text_validation_max"/><tableColumn id="12" name="identifier"/><tableColumn id="13" name="branching_logic"/><tableColumn id="14" name="required_field"/><tableColumn id="15" name="custom_alignment"/><tableColumn id="16" name="question_number"/><tableColumn id="17" name="matrix_group_name"/><tableColumn id="18" name="matrix_ranking"/><tableColumn id="19" name="field_annotation"/><tableColumn id="20" name="skim_type"/><tableColumn id="21" name="n_missing"/><tableColumn id="22" name="complete_rate"/><tableColumn id="23" name="character.min"/><tableColumn id="24" name="character.max"/><tableColumn id="25" name="character.empty"/><tableColumn id="26" name="character.n_unique"/><tableColumn id="27" name="character.whitespace"/><tableColumn id="28" name="numeric.mean"/><tableColumn id="29" name="numeric.sd"/><tableColumn id="30" name="numeric.p0"/><tableColumn id="31" name="numeric.p25"/><tableColumn id="32" name="numeric.p50"/><tableColumn id="33" name="numeric.p75"/><tableColumn id="34" name="numeric.p100"/><tableColumn id="35" name="numeric.hist"/><tableColumn id="36" name="factor.ordered"/><tableColumn id="37" name="factor.n_unique"/><tableColumn id="38" name="factor.top_counts"/><tableColumn id="39" name="logical.mean"/><tableColumn id="40" name="logical.count"/><tableColumn id="41" name="Date.min"/><tableColumn id="42" name="Date.max"/><tableColumn id="43" name="Date.median"/><tableColumn id="44" name="Date.n_unique"/><tableColumn id="45" name="POSIXct.min"/><tableColumn id="46" name="POSIXct.max"/><tableColumn id="47" name="POSIXct.median"/><tableColumn id="48" name="POSIXct.n_unique"/><tableColumn id="49" name="difftime.min"/><tableColumn id="50" name="difftime.max"/><tableColumn id="51" name="difftime.median"/><tableColumn id="52" name="difftime.n_unique"/></tableColumns><tableStyleInfo name="TableStyleLight8" showFirstColumn="0" showLastColumn="0" showRowStripes="1" showColumnStripes="0"/></table>
         tab_act
      1        1
      2        1
      3        1
      4        1
      5        1
      6        1
      7        1
      8        1
      9        1
      10       1
      11       1
      
      [[2]]
      [[2]]$fileVersion
      NULL
      
      [[2]]$fileSharing
      NULL
      
      [[2]]$workbookPr
      [1] "<workbookPr date1904=\"false\"/>"
      
      [[2]]$alternateContent
      NULL
      
      [[2]]$revisionPtr
      NULL
      
      [[2]]$absPath
      NULL
      
      [[2]]$workbookProtection
      NULL
      
      [[2]]$bookViews
      [1] "<bookViews><workbookView windowHeight=\"130000\" windowWidth=\"6000\"/></bookViews>"
      
      [[2]]$sheets
       [1] "<sheet name=\"Table of Contents\" sheetId=\"1\" state=\"visible\" r:id=\"rId1\"/>"          
       [2] "<sheet name=\"Nonrepeated\" sheetId=\"2\" state=\"visible\" r:id=\"rId2\"/>"                
       [3] "<sheet name=\"Nonrepeated2\" sheetId=\"3\" state=\"visible\" r:id=\"rId3\"/>"               
       [4] "<sheet name=\"Repeated\" sheetId=\"4\" state=\"visible\" r:id=\"rId4\"/>"                   
       [5] "<sheet name=\"Data Field Types\" sheetId=\"5\" state=\"visible\" r:id=\"rId5\"/>"           
       [6] "<sheet name=\"Text Input Validation Types\" sheetId=\"6\" state=\"visible\" r:id=\"rId6\"/>"
       [7] "<sheet name=\"API No Access\" sheetId=\"7\" state=\"visible\" r:id=\"rId7\"/>"              
       [8] "<sheet name=\"API No Access 2\" sheetId=\"8\" state=\"visible\" r:id=\"rId8\"/>"            
       [9] "<sheet name=\"Survey\" sheetId=\"9\" state=\"visible\" r:id=\"rId9\"/>"                     
      [10] "<sheet name=\"Repeat Survey\" sheetId=\"10\" state=\"visible\" r:id=\"rId10\"/>"            
      [11] "<sheet name=\"REDCap Metadata\" sheetId=\"11\" state=\"visible\" r:id=\"rId11\"/>"          
      
      [[2]]$functionGroups
      NULL
      
      [[2]]$externalReferences
      NULL
      
      [[2]]$definedNames
      NULL
      
      [[2]]$calcPr
      NULL
      
      [[2]]$oleSize
      NULL
      
      [[2]]$customWorkbookViews
      NULL
      
      [[2]]$pivotCaches
      NULL
      
      [[2]]$smartTagPr
      NULL
      
      [[2]]$smartTagTypes
      NULL
      
      [[2]]$webPublishing
      NULL
      
      [[2]]$fileRecoveryPr
      NULL
      
      [[2]]$webPublishObjects
      NULL
      
      [[2]]$extLst
      NULL
      
      
      [[3]]
       [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>"  
       [2] "<Relationship Id=\"rId2\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet2.xml\"/>"  
       [3] "<Relationship Id=\"rId3\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet3.xml\"/>"  
       [4] "<Relationship Id=\"rId4\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet4.xml\"/>"  
       [5] "<Relationship Id=\"rId5\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet5.xml\"/>"  
       [6] "<Relationship Id=\"rId6\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet6.xml\"/>"  
       [7] "<Relationship Id=\"rId7\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet7.xml\"/>"  
       [8] "<Relationship Id=\"rId8\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet8.xml\"/>"  
       [9] "<Relationship Id=\"rId9\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet9.xml\"/>"  
      [10] "<Relationship Id=\"rId10\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet10.xml\"/>"
      [11] "<Relationship Id=\"rId11\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet11.xml\"/>"
      [12] "<Relationship Id=\"rId12\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme\" Target=\"theme/theme1.xml\"/>"          
      [13] "<Relationship Id=\"rId13\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles\" Target=\"styles.xml\"/>"               
      
      [[4]]
      [[4]][[1]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="2" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:H12"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[2]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:D6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[3]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:D6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[4]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:E6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[5]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:AE6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[6]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:R6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[7]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:C6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[8]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:E6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[9]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:I6"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[10]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="1" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:J5"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      [[4]][[11]]
      <wbWorksheet>
        Public:
          add_page_break: function (row = NULL, col = NULL) 
          add_sparklines: function (sparklines) 
          append: function (field, value = NULL) 
          autoFilter: 
          cellWatches: 
          clean_sheet: function (dims = NULL, numbers = TRUE, characters = TRUE, styles = TRUE, 
          clone: function (deep = FALSE) 
          colBreaks: 
          cols_attr: <col min="1" max="2" bestFit="1" customWidth="1" hidden= ...
          conditionalFormatting: 
          controls: 
          customProperties: 
          customSheetViews: 
          dataConsolidate: 
          dataValidations: NULL
          dimension: <dimension ref="A1:AZ68"/>
          drawing: 
          drawingHF: 
          extLst: 
          fold_cols: function (col_df) 
          freezePane: 
          get_post_sheet_data: function () 
          get_prior_sheet_data: function () 
          headerFooter: list
          hyperlinks: list
          ignoredErrors: 
          initialize: function (tabColor = NULL, oddHeader = NULL, oddFooter = NULL, 
          legacyDrawing: 
          legacyDrawingHF: 
          mergeCells: 
          merge_cells: function (rows = NULL, cols = NULL) 
          oleObjects: 
          pageMargins: <pageMargins left="0.7" right="0.7" top="0.75" bottom="0 ...
          pageSetup: <pageSetup paperSize="9" orientation="portrait" horizont ...
          phoneticPr: 
          picture: 
          printOptions: <printOptions gridLines="1" gridLinesSet="1"/>
          protectedRanges: 
          relships: list
          rowBreaks: 
          scenarios: 
          set_print_options: function (gridLines = NULL, gridLinesSet = NULL, headings = NULL, 
          set_sheetview: function (colorId = NULL, defaultGridColor = NULL, rightToLeft = NULL, 
          sheetCalcPr: 
          sheetFormatPr: <sheetFormatPr baseColWidth="8.43" defaultRowHeight="16" ...
          sheetPr: 
          sheetProtection: 
          sheetViews: <sheetViews><sheetView showGridLines="1" showRowColHeade ...
          sheet_data: wbSheetData, R6
          smartTags: 
          sortState: 
          tableParts: <tablePart r:id="rId1"/>
          unfold_cols: function () 
          unmerge_cells: function (rows = NULL, cols = NULL) 
          webPublishItems: 
        Private:
          cols: NULL
          data_validation: function (type, operator, value, allowBlank, showInputMsg, showErrorMsg, 
          do_append_x14: function (x, s_name, l_name) 
          sheetData: NULL
      
      
      [[5]]
      [[5]][[1]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table1.xml\"/>"
      
      [[5]][[2]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table2.xml\"/>"
      
      [[5]][[3]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table3.xml\"/>"
      
      [[5]][[4]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table4.xml\"/>"
      
      [[5]][[5]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table5.xml\"/>"
      
      [[5]][[6]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table6.xml\"/>"
      
      [[5]][[7]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table7.xml\"/>"
      
      [[5]][[8]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table8.xml\"/>"
      
      [[5]][[9]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table9.xml\"/>"
      
      [[5]][[10]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table10.xml\"/>"
      
      [[5]][[11]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table11.xml\"/>"
      
      
      [[6]]
       [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet1.xml\"/>"  
       [2] "<Relationship Id=\"rId2\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet2.xml\"/>"  
       [3] "<Relationship Id=\"rId3\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet3.xml\"/>"  
       [4] "<Relationship Id=\"rId4\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet4.xml\"/>"  
       [5] "<Relationship Id=\"rId5\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet5.xml\"/>"  
       [6] "<Relationship Id=\"rId6\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet6.xml\"/>"  
       [7] "<Relationship Id=\"rId7\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet7.xml\"/>"  
       [8] "<Relationship Id=\"rId8\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet8.xml\"/>"  
       [9] "<Relationship Id=\"rId9\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet9.xml\"/>"  
      [10] "<Relationship Id=\"rId10\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet10.xml\"/>"
      [11] "<Relationship Id=\"rId11\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet\" Target=\"worksheets/sheet11.xml\"/>"
      [12] "<Relationship Id=\"rId12\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme\" Target=\"theme/theme1.xml\"/>"          
      [13] "<Relationship Id=\"rId13\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles\" Target=\"styles.xml\"/>"               
      
      [[7]]
       [1]  1  2  3  4  5  6  7  8  9 10 11
      
      [[8]]
       [1] "Table of Contents"           "Nonrepeated"                
       [3] "Nonrepeated2"                "Repeated"                   
       [5] "Data Field Types"            "Text Input Validation Types"
       [7] "API No Access"               "API No Access 2"            
       [9] "Survey"                      "Repeat Survey"              
      [11] "REDCap Metadata"            
      

