# Combining skimr, labelled, and xlsx returns expected snapshot

    Code
      wb_list
    Output
      [[1]]
      [[1]][[1]]
              REDCap Instrument Name REDCap Instrument Description
      2             redcap_form_name             redcap_form_label
      3                  nonrepeated                   Nonrepeated
      4                 nonrepeated2                  Nonrepeated2
      5                     repeated                      Repeated
      6             data_field_types              Data Field Types
      7  text_input_validation_types   Text Input Validation Types
      8                api_no_access                 API No Access
      9              api_no_access_2               API No Access 2
      10                      survey                        Survey
      11               repeat_survey                 Repeat Survey
      12             REDCap Metadata                          <NA>
         Repeating or Nonrepeating? # of Rows in Data # of Columns in Data
      2                   structure         data_rows            data_cols
      3                nonrepeating                 4                    4
      4                nonrepeating                 4                    4
      5                   repeating                 4                    5
      6                nonrepeating                 4                   31
      7                nonrepeating                 4                   18
      8                nonrepeating                 4                    3
      9                nonrepeating                 4                    5
      10               nonrepeating                 4                    9
      11                  repeating                 3                   10
      12                       <NA>              <NA>                 <NA>
         Data size in Memory % of Data Missing Sheet #
      2            data_size       data_na_pct Sheet #
      3              2.28 kB              0.25       1
      4              1.94 kB               0.5       2
      5              2.58 kB                 0       3
      6              7.71 kB 0.293103448275862       4
      7              7.40 kB              0.75       5
      8              1.78 kB                 1       6
      9              2.06 kB                 1       7
      10             3.73 kB 0.392857142857143       8
      11             3.94 kB 0.142857142857143       9
      12                <NA>              <NA>      10
      
      [[1]][[2]]
        Record ID Text Box Input Text Box Input REDCap Instrument Completed?
      2 record_id    nonrepeat_1    nonrepeat_2         form_status_complete
      3         1              1              2                   Incomplete
      4         2              A              B                   Incomplete
      5         3           <NA>           <NA>                   Incomplete
      6         4    Test Survey    Test Survey                     Complete
      
      [[1]][[3]]
        Record ID   Test data   Test data REDCap Instrument Completed?
      2 record_id nonrepeat_3 nonrepeat_4         form_status_complete
      3         1           3           4                   Incomplete
      4         2           5           6                   Incomplete
      5         3        <NA>        <NA>                   Incomplete
      6         4        <NA>        <NA>                   Incomplete
      
      [[1]][[4]]
        Record ID REDCap Form Instance Text Box Input: Text Box Input:
      2 record_id redcap_form_instance        repeat_1        repeat_2
      3         1                    1               1               2
      4         1                    2               3               4
      5         1                    3               5               6
      6         3                    1               C               D
        REDCap Instrument Completed?
      2         form_status_complete
      3                   Incomplete
      4                   Incomplete
      5                   Incomplete
      6                   Incomplete
      
      [[1]][[5]]
        Record ID   NA    NA         NA              NA           NA
      2 record_id text  note calculated dropdown_single radio_single
      3         1 text notes          2             one            B
      4         2 <NA>  <NA>          2           three            C
      5         3 <NA>  <NA>       <NA>            <NA>         <NA>
      6         4 <NA>  <NA>          2            <NA>         <NA>
                           NA                    NA                    NA
      2 radio_duplicate_label checkbox_multiple___1 checkbox_multiple___2
      3                  <NA>               Checked             Unchecked
      4                  <NA>               Checked             Unchecked
      5                  <NA>             Unchecked             Unchecked
      6                  <NA>             Unchecked             Unchecked
                           NA                    NA                    NA
      2 checkbox_multiple___3 checkbox_multiple___4 checkbox_multiple___5
      3             Unchecked               Checked             Unchecked
      4             Unchecked               Checked             Unchecked
      5             Unchecked             Unchecked             Unchecked
      6             Unchecked             Unchecked             Unchecked
                           NA                    NA                    NA
      2 checkbox_multiple___6 checkbox_multiple___7 checkbox_multiple___8
      3             Unchecked             Unchecked               Checked
      4             Unchecked               Checked             Unchecked
      5             Unchecked             Unchecked             Unchecked
      6             Unchecked             Unchecked             Unchecked
                           NA                     NA                      NA
      2 checkbox_multiple___9 checkbox_multiple___10 checkbox_multiple___-99
      3             Unchecked              Unchecked               Unchecked
      4             Unchecked                Checked                 Checked
      5             Unchecked              Unchecked               Unchecked
      6             Unchecked              Unchecked               Unchecked
                             NA                       NA                        NA
      2 checkbox_multiple___-98 checkbox_multiple_2___aa checkbox_multiple_2___b1b
      3               Unchecked                Unchecked                 Unchecked
      4               Unchecked                Unchecked                   Checked
      5               Unchecked                Unchecked                 Unchecked
      6               Unchecked                Unchecked                 Unchecked
                                NA                          NA
      2 checkbox_multiple_2___ccc2 checkbox_multiple_2___3dddd
      3                  Unchecked                   Unchecked
      4                  Unchecked                     Checked
      5                  Unchecked                   Unchecked
      6                  Unchecked                   Unchecked
                                  NA    NA    NA                            NA
      2 checkbox_multiple_2___4eeee5 yesno    NA                     signature
      3                    Unchecked   yes FALSE signature_2022-08-02_1114.png
      4                    Unchecked  <NA>    NA                          <NA>
      5                    Unchecked  <NA>    NA                          <NA>
      6                    Unchecked  <NA>    NA                          <NA>
                               NA     NA
      2                fileupload slider
      3 gas_receipt_20220729.jpeg     73
      4                      <NA>   <NA>
      5                      <NA>   <NA>
      6                      <NA>   <NA>
        This is a radio selection meant to be a descriptive text field.
      2                                                radio_dtxt_error
      3                                                            <NA>
      4                                                            <NA>
      5                                                            <NA>
      6                                                            <NA>
        REDCap Instrument Completed?
      2         form_status_complete
      3                     Complete
      4                   Unverified
      5                   Incomplete
      6                   Incomplete
      
      [[1]][[6]]
        Record ID   Text DMY   Text MDY   Text YMD         Text DMY HM
      2 record_id   text_dmy   text_mdy   text_ymd         text_dmy_hm
      3         1 2022-08-03 2022-08-03 2022-08-03 2022-08-03 15:15:00
      4         2       <NA>       <NA>       <NA>                <NA>
      5         3       <NA>       <NA>       <NA>                <NA>
      6         4       <NA>       <NA>       <NA>                <NA>
                Text MDY HM         Text YMD HM        Text DMY HMS
      2         text_mdy_hm         text_ymd_hm        text_dmy_hms
      3 2022-08-03 15:15:00 2022-08-03 15:15:00 2022-08-03 15:15:04
      4                <NA>                <NA>                <NA>
      5                <NA>                <NA>                <NA>
      6                <NA>                <NA>                <NA>
               Text MDY HMS        Text YMD HMS Text MRN     Text Phone    Text SSN
      2        text_mdy_hms        text_ymd_hms text_mrn     text_phone    text_ssn
      3 2022-08-03 15:15:04 2022-08-03 15:15:05 00123456 (987) 654-3210 999-99-9999
      4                <NA>                <NA>     <NA>           <NA>        <NA>
      5                <NA>                <NA>     <NA>           <NA>        <NA>
      6                <NA>                <NA>     <NA>           <NA>        <NA>
        Text HMS  Text HM  Text MS Text ZIP REDCap Instrument Completed?
      2 text_hms  text_hm  text_ms text_zip         form_status_complete
      3 15:15:49 15:15:00 15:00:00    08001                   Incomplete
      4     <NA>     <NA>     <NA>     <NA>                   Incomplete
      5     <NA>     <NA>     <NA>     <NA>                   Incomplete
      6     <NA>     <NA>     <NA>     <NA>                   Incomplete
      
      [[1]][[7]]
        Record ID Test Field REDCap Instrument Completed?
      2 record_id   api_text         form_status_complete
      3         1       <NA>                   Incomplete
      4         2       <NA>                   Incomplete
      5         3       <NA>                   Incomplete
      6         4       <NA>                   Incomplete
      
      [[1]][[8]]
        Record ID Test Field Test Field Test Field REDCap Instrument Completed?
      2 record_id api_text_2 api_text_3 api_text_4         form_status_complete
      3         1       <NA>       <NA>       <NA>                   Incomplete
      4         2       <NA>       <NA>       <NA>                   Incomplete
      5         3       <NA>       <NA>       <NA>                   Incomplete
      6         4       <NA>       <NA>       <NA>                   Incomplete
      
      [[1]][[9]]
        Record ID           NA Radio field:                    NA
      2 record_id survey_yesno survey_radio survey_checkbox___one
      3         1          yes     Choice 1             Unchecked
      4         2           no     Choice 2             Unchecked
      5         3         <NA>         <NA>             Unchecked
      6         4         <NA>         <NA>             Unchecked
                           NA                      NA REDCap Survey Identifier
      2 survey_checkbox___two survey_checkbox___three redcap_survey_identifier
      3               Checked                 Checked                     <NA>
      4               Checked                 Checked                     <NA>
      5             Unchecked               Unchecked                     <NA>
      6             Unchecked               Unchecked                     <NA>
        REDCap Survey Timestamp REDCap Instrument Completed?
      2 redcap_survey_timestamp         form_status_complete
      3     2022-11-09 10:33:35                     Complete
      4                    <NA>                   Incomplete
      5                    <NA>                   Incomplete
      6                    <NA>                   Incomplete
      
      [[1]][[10]]
        Record ID REDCap Form Instance                 NA          Radio field:
      2 record_id redcap_form_instance repeatsurvey_yesno repeatsurvey_radio_v2
      3         1                    1                yes              Choice 1
      4         1                    2                 no              Choice 2
      5         4                    1                yes              Choice 1
                                    NA                             NA
      2 repeatsurvey_checkbox_v2___one repeatsurvey_checkbox_v2___two
      3                        Checked                      Unchecked
      4                      Unchecked                        Checked
      5                        Checked                      Unchecked
                                      NA REDCap Survey Identifier
      2 repeatsurvey_checkbox_v2___three redcap_survey_identifier
      3                        Unchecked                     <NA>
      4                          Checked                     <NA>
      5                        Unchecked                     <NA>
        REDCap Survey Timestamp REDCap Instrument Completed?
      2 redcap_survey_timestamp         form_status_complete
      3     2022-11-09 12:09:34                     Complete
      4     2022-11-09 12:10:50                     Complete
      5     2022-11-09 12:21:04                     Complete
      
      [[1]][[11]]
              REDCap Instrument Name REDCap Instrument Description
      2             redcap_form_name             redcap_form_label
      3                         <NA>                          <NA>
      4                  nonrepeated                   Nonrepeated
      5                  nonrepeated                   Nonrepeated
      6                 nonrepeated2                  Nonrepeated2
      7                 nonrepeated2                  Nonrepeated2
      8                     repeated                      Repeated
      9                     repeated                      Repeated
      10            data_field_types              Data Field Types
      11            data_field_types              Data Field Types
      12            data_field_types              Data Field Types
      13            data_field_types              Data Field Types
      14            data_field_types              Data Field Types
      15            data_field_types              Data Field Types
      16            data_field_types              Data Field Types
      17            data_field_types              Data Field Types
      18            data_field_types              Data Field Types
      19            data_field_types              Data Field Types
      20            data_field_types              Data Field Types
      21            data_field_types              Data Field Types
      22            data_field_types              Data Field Types
      23            data_field_types              Data Field Types
      24            data_field_types              Data Field Types
      25            data_field_types              Data Field Types
      26            data_field_types              Data Field Types
      27            data_field_types              Data Field Types
      28            data_field_types              Data Field Types
      29            data_field_types              Data Field Types
      30            data_field_types              Data Field Types
      31            data_field_types              Data Field Types
      32            data_field_types              Data Field Types
      33            data_field_types              Data Field Types
      34            data_field_types              Data Field Types
      35            data_field_types              Data Field Types
      36            data_field_types              Data Field Types
      37            data_field_types              Data Field Types
      38            data_field_types              Data Field Types
      39 text_input_validation_types   Text Input Validation Types
      40 text_input_validation_types   Text Input Validation Types
      41 text_input_validation_types   Text Input Validation Types
      42 text_input_validation_types   Text Input Validation Types
      43 text_input_validation_types   Text Input Validation Types
      44 text_input_validation_types   Text Input Validation Types
      45 text_input_validation_types   Text Input Validation Types
      46 text_input_validation_types   Text Input Validation Types
      47 text_input_validation_types   Text Input Validation Types
      48 text_input_validation_types   Text Input Validation Types
      49 text_input_validation_types   Text Input Validation Types
      50 text_input_validation_types   Text Input Validation Types
      51 text_input_validation_types   Text Input Validation Types
      52 text_input_validation_types   Text Input Validation Types
      53 text_input_validation_types   Text Input Validation Types
      54 text_input_validation_types   Text Input Validation Types
      55               api_no_access                 API No Access
      56             api_no_access_2               API No Access 2
      57             api_no_access_2               API No Access 2
      58             api_no_access_2               API No Access 2
      59                      survey                        Survey
      60                      survey                        Survey
      61                      survey                        Survey
      62                      survey                        Survey
      63                      survey                        Survey
      64               repeat_survey                 Repeat Survey
      65               repeat_survey                 Repeat Survey
      66               repeat_survey                 Repeat Survey
      67               repeat_survey                 Repeat Survey
      68               repeat_survey                 Repeat Survey
                    Variable / Field Name
      2                        field_name
      3                         record_id
      4                       nonrepeat_1
      5                       nonrepeat_2
      6                       nonrepeat_3
      7                       nonrepeat_4
      8                          repeat_1
      9                          repeat_2
      10                             text
      11                             note
      12                       calculated
      13                  dropdown_single
      14                     radio_single
      15            radio_duplicate_label
      16            checkbox_multiple___1
      17            checkbox_multiple___2
      18            checkbox_multiple___3
      19            checkbox_multiple___4
      20            checkbox_multiple___5
      21            checkbox_multiple___6
      22            checkbox_multiple___7
      23            checkbox_multiple___8
      24            checkbox_multiple___9
      25           checkbox_multiple___10
      26          checkbox_multiple___-99
      27          checkbox_multiple___-98
      28         checkbox_multiple_2___aa
      29        checkbox_multiple_2___b1b
      30       checkbox_multiple_2___ccc2
      31      checkbox_multiple_2___3dddd
      32     checkbox_multiple_2___4eeee5
      33                            yesno
      34                        truefalse
      35                        signature
      36                       fileupload
      37                           slider
      38                 radio_dtxt_error
      39                         text_dmy
      40                         text_mdy
      41                         text_ymd
      42                      text_dmy_hm
      43                      text_mdy_hm
      44                      text_ymd_hm
      45                     text_dmy_hms
      46                     text_mdy_hms
      47                     text_ymd_hms
      48                         text_mrn
      49                       text_phone
      50                         text_ssn
      51                         text_hms
      52                          text_hm
      53                          text_ms
      54                         text_zip
      55                         api_text
      56                       api_text_2
      57                       api_text_3
      58                       api_text_4
      59                     survey_yesno
      60                     survey_radio
      61            survey_checkbox___one
      62            survey_checkbox___two
      63          survey_checkbox___three
      64               repeatsurvey_yesno
      65            repeatsurvey_radio_v2
      66   repeatsurvey_checkbox_v2___one
      67   repeatsurvey_checkbox_v2___two
      68 repeatsurvey_checkbox_v2___three
                                                             Field Label Field Type
      2                                                      field_label field_type
      3                                                        Record ID       text
      4                                                   Text Box Input       text
      5                                                   Text Box Input       text
      6                                                        Test data       text
      7                                                        Test data       text
      8                                                  Text Box Input:       text
      9                                                  Text Box Input:       text
      10                                                            <NA>       text
      11                                                            <NA>      notes
      12                                                            <NA>       calc
      13                                                            <NA>   dropdown
      14                                                            <NA>      radio
      15                                                            <NA>      radio
      16                                                            <NA>   checkbox
      17                                                            <NA>   checkbox
      18                                                            <NA>   checkbox
      19                                                            <NA>   checkbox
      20                                                            <NA>   checkbox
      21                                                            <NA>   checkbox
      22                                                            <NA>   checkbox
      23                                                            <NA>   checkbox
      24                                                            <NA>   checkbox
      25                                                            <NA>   checkbox
      26                                                            <NA>   checkbox
      27                                                            <NA>   checkbox
      28                                                            <NA>   checkbox
      29                                                            <NA>   checkbox
      30                                                            <NA>   checkbox
      31                                                            <NA>   checkbox
      32                                                            <NA>   checkbox
      33                                                            <NA>      yesno
      34                                                            <NA>  truefalse
      35                                                            <NA>       file
      36                                                            <NA>       file
      37                                                            <NA>     slider
      38 This is a radio selection meant to be a descriptive text field.      radio
      39                                                        Text DMY       text
      40                                                        Text MDY       text
      41                                                        Text YMD       text
      42                                                     Text DMY HM       text
      43                                                     Text MDY HM       text
      44                                                     Text YMD HM       text
      45                                                    Text DMY HMS       text
      46                                                    Text MDY HMS       text
      47                                                    Text YMD HMS       text
      48                                                        Text MRN       text
      49                                                      Text Phone       text
      50                                                        Text SSN       text
      51                                                        Text HMS       text
      52                                                         Text HM       text
      53                                                         Text MS       text
      54                                                        Text ZIP       text
      55                                                      Test Field       text
      56                                                      Test Field       text
      57                                                      Test Field       text
      58                                                      Test Field       text
      59                                                 Yes - No field:      yesno
      60                                                    Radio field:      radio
      61                                        Checkbox Field: Choice 1   checkbox
      62                                        Checkbox Field: Choice 2   checkbox
      63                                        Checkbox Field: Choice 3   checkbox
      64                                                 Yes - No field:      yesno
      65                                                    Radio field:      radio
      66                                        Checkbox Field: Choice 1   checkbox
      67                                        Checkbox Field: Choice 2   checkbox
      68                                        Checkbox Field: Choice 3   checkbox
         Section Header Prior to this Field
      2                      section_header
      3                                <NA>
      4                                <NA>
      5                                <NA>
      6                                <NA>
      7                                <NA>
      8                                <NA>
      9                                <NA>
      10                               <NA>
      11                               <NA>
      12                               <NA>
      13                               <NA>
      14                               <NA>
      15                               <NA>
      16                               <NA>
      17                               <NA>
      18                               <NA>
      19                               <NA>
      20                               <NA>
      21                               <NA>
      22                               <NA>
      23                               <NA>
      24                               <NA>
      25                               <NA>
      26                               <NA>
      27                               <NA>
      28                               <NA>
      29                               <NA>
      30                               <NA>
      31                               <NA>
      32                               <NA>
      33                               <NA>
      34                               <NA>
      35                               <NA>
      36                               <NA>
      37                               <NA>
      38                               <NA>
      39                               <NA>
      40                               <NA>
      41                               <NA>
      42                               <NA>
      43                               <NA>
      44                               <NA>
      45                               <NA>
      46                               <NA>
      47                               <NA>
      48                               <NA>
      49                               <NA>
      50                               <NA>
      51                               <NA>
      52                               <NA>
      53                               <NA>
      54                               <NA>
      55                               <NA>
      56                               <NA>
      57                               <NA>
      58                               <NA>
      59                               <NA>
      60                               <NA>
      61                               <NA>
      62                               <NA>
      63                               <NA>
      64                               <NA>
      65                               <NA>
      66                               <NA>
      67                               <NA>
      68                               <NA>
                                                                       Choices, Calculations, or Slider Labels
      2                                                                         select_choices_or_calculations
      3                                                                                                   <NA>
      4                                                                                                   <NA>
      5                                                                                                   <NA>
      6                                                                                                   <NA>
      7                                                                                                   <NA>
      8                                                                                                   <NA>
      9                                                                                                   <NA>
      10                                                                                                  <NA>
      11                                                                                                  <NA>
      12                                                                                                   1+1
      13                                                       choice_1, one | choice_2, two | choice_3, three
      14                                                               choice_1, A | choice_2, B | choice_3, C
      15                                                               choice_1, A | choice_2, A | choice_3, C
      16 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      17 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      18 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      19 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      20 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      21 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      22 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      23 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      24 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      25 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      26 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      27 1, 1 | 2, 2 | 3, 3 | 4, 4 | 5, 5 | 6, 6 | 7, 7 | 8, 8 | 9, 9 | 10, 10 | -99, Unknown | -98, Not Given
      28                                    Aa, Red | B1b, Green | Ccc2, Blue | 3dddd, Yellow | 4eeee5, Purple
      29                                    Aa, Red | B1b, Green | Ccc2, Blue | 3dddd, Yellow | 4eeee5, Purple
      30                                    Aa, Red | B1b, Green | Ccc2, Blue | 3dddd, Yellow | 4eeee5, Purple
      31                                    Aa, Red | B1b, Green | Ccc2, Blue | 3dddd, Yellow | 4eeee5, Purple
      32                                    Aa, Red | B1b, Green | Ccc2, Blue | 3dddd, Yellow | 4eeee5, Purple
      33                                                                                                  <NA>
      34                                                                                                  <NA>
      35                                                                                                  <NA>
      36                                                                                                  <NA>
      37                                                                                                  <NA>
      38                                                                                                  <NA>
      39                                                                                                  <NA>
      40                                                                                                  <NA>
      41                                                                                                  <NA>
      42                                                                                                  <NA>
      43                                                                                                  <NA>
      44                                                                                                  <NA>
      45                                                                                                  <NA>
      46                                                                                                  <NA>
      47                                                                                                  <NA>
      48                                                                                                  <NA>
      49                                                                                                  <NA>
      50                                                                                                  <NA>
      51                                                                                                  <NA>
      52                                                                                                  <NA>
      53                                                                                                  <NA>
      54                                                                                                  <NA>
      55                                                                                                  <NA>
      56                                                                                                  <NA>
      57                                                                                                  <NA>
      58                                                                                                  <NA>
      59                                                                                                  <NA>
      60                                                               1, Choice 1 | 2, Choice 2 | 3, Choice 3
      61                                                       one, Choice 1 | two, Choice 2 | three, Choice 3
      62                                                       one, Choice 1 | two, Choice 2 | three, Choice 3
      63                                                       one, Choice 1 | two, Choice 2 | three, Choice 3
      64                                                                                                  <NA>
      65                                                               1, Choice 1 | 2, Choice 2 | 3, Choice 3
      66                                                       one, Choice 1 | two, Choice 2 | three, Choice 3
      67                                                       one, Choice 1 | two, Choice 2 | three, Choice 3
      68                                                       one, Choice 1 | two, Choice 2 | three, Choice 3
         Field Note Text Validation Type OR Show Slider Number
      2  field_note text_validation_type_or_show_slider_number
      3        <NA>                                       <NA>
      4        <NA>                                       <NA>
      5        <NA>                                       <NA>
      6        <NA>                                       <NA>
      7        <NA>                                       <NA>
      8        <NA>                                       <NA>
      9        <NA>                                       <NA>
      10       <NA>                                       <NA>
      11       <NA>                                       <NA>
      12       <NA>                                       <NA>
      13       <NA>                                       <NA>
      14       <NA>                                       <NA>
      15       <NA>                                       <NA>
      16       <NA>                                       <NA>
      17       <NA>                                       <NA>
      18       <NA>                                       <NA>
      19       <NA>                                       <NA>
      20       <NA>                                       <NA>
      21       <NA>                                       <NA>
      22       <NA>                                       <NA>
      23       <NA>                                       <NA>
      24       <NA>                                       <NA>
      25       <NA>                                       <NA>
      26       <NA>                                       <NA>
      27       <NA>                                       <NA>
      28       <NA>                                       <NA>
      29       <NA>                                       <NA>
      30       <NA>                                       <NA>
      31       <NA>                                       <NA>
      32       <NA>                                       <NA>
      33       <NA>                                       <NA>
      34       <NA>                                       <NA>
      35       <NA>                                  signature
      36       <NA>                                       <NA>
      37       <NA>                                       <NA>
      38       <NA>                                       <NA>
      39       <NA>                                   date_dmy
      40       <NA>                                   date_mdy
      41       <NA>                                   date_ymd
      42       <NA>                               datetime_dmy
      43       <NA>                               datetime_mdy
      44       <NA>                               datetime_ymd
      45       <NA>                       datetime_seconds_dmy
      46       <NA>                       datetime_seconds_mdy
      47       <NA>                       datetime_seconds_ymd
      48       <NA>                                     mrn_8d
      49       <NA>                                      phone
      50       <NA>                                        ssn
      51       <NA>                              time_hh_mm_ss
      52       <NA>                                       time
      53       <NA>                                 time_mm_ss
      54       <NA>                                    zipcode
      55       <NA>                                       <NA>
      56       <NA>                                       <NA>
      57       <NA>                                       <NA>
      58       <NA>                                       <NA>
      59       <NA>                                       <NA>
      60       <NA>                                       <NA>
      61       <NA>                                       <NA>
      62       <NA>                                       <NA>
      63       <NA>                                       <NA>
      64       <NA>                                       <NA>
      65       <NA>                                       <NA>
      66       <NA>                                       <NA>
      67       <NA>                                       <NA>
      68       <NA>                                       <NA>
         Minimum Accepted Value for Text Validation
      2                         text_validation_min
      3                                        <NA>
      4                                        <NA>
      5                                        <NA>
      6                                        <NA>
      7                                        <NA>
      8                                        <NA>
      9                                        <NA>
      10                                       <NA>
      11                                       <NA>
      12                                       <NA>
      13                                       <NA>
      14                                       <NA>
      15                                       <NA>
      16                                       <NA>
      17                                       <NA>
      18                                       <NA>
      19                                       <NA>
      20                                       <NA>
      21                                       <NA>
      22                                       <NA>
      23                                       <NA>
      24                                       <NA>
      25                                       <NA>
      26                                       <NA>
      27                                       <NA>
      28                                       <NA>
      29                                       <NA>
      30                                       <NA>
      31                                       <NA>
      32                                       <NA>
      33                                       <NA>
      34                                       <NA>
      35                                       <NA>
      36                                       <NA>
      37                                       <NA>
      38                                       <NA>
      39                                       <NA>
      40                                       <NA>
      41                                       <NA>
      42                                       <NA>
      43                                       <NA>
      44                                       <NA>
      45                                       <NA>
      46                                       <NA>
      47                                       <NA>
      48                                       <NA>
      49                                       <NA>
      50                                       <NA>
      51                                       <NA>
      52                                       <NA>
      53                                       <NA>
      54                                       <NA>
      55                                       <NA>
      56                                       <NA>
      57                                       <NA>
      58                                       <NA>
      59                                       <NA>
      60                                       <NA>
      61                                       <NA>
      62                                       <NA>
      63                                       <NA>
      64                                       <NA>
      65                                       <NA>
      66                                       <NA>
      67                                       <NA>
      68                                       <NA>
         Maximum Accepted Value for Text Validation Is this Field an Identifier?
      2                         text_validation_max                   identifier
      3                                        <NA>                         <NA>
      4                                        <NA>                         <NA>
      5                                        <NA>                         <NA>
      6                                        <NA>                         <NA>
      7                                        <NA>                         <NA>
      8                                        <NA>                         <NA>
      9                                        <NA>                         <NA>
      10                                       <NA>                         <NA>
      11                                       <NA>                         <NA>
      12                                       <NA>                         <NA>
      13                                       <NA>                         <NA>
      14                                       <NA>                         <NA>
      15                                       <NA>                         <NA>
      16                                       <NA>                         <NA>
      17                                       <NA>                         <NA>
      18                                       <NA>                         <NA>
      19                                       <NA>                         <NA>
      20                                       <NA>                         <NA>
      21                                       <NA>                         <NA>
      22                                       <NA>                         <NA>
      23                                       <NA>                         <NA>
      24                                       <NA>                         <NA>
      25                                       <NA>                         <NA>
      26                                       <NA>                         <NA>
      27                                       <NA>                         <NA>
      28                                       <NA>                         <NA>
      29                                       <NA>                         <NA>
      30                                       <NA>                         <NA>
      31                                       <NA>                         <NA>
      32                                       <NA>                         <NA>
      33                                       <NA>                         <NA>
      34                                       <NA>                         <NA>
      35                                       <NA>                         <NA>
      36                                       <NA>                         <NA>
      37                                       <NA>                         <NA>
      38                                       <NA>                         <NA>
      39                                       <NA>                         <NA>
      40                                       <NA>                         <NA>
      41                                       <NA>                         <NA>
      42                                       <NA>                         <NA>
      43                                       <NA>                         <NA>
      44                                       <NA>                         <NA>
      45                                       <NA>                         <NA>
      46                                       <NA>                         <NA>
      47                                       <NA>                         <NA>
      48                                       <NA>                         <NA>
      49                                       <NA>                         <NA>
      50                                       <NA>                         <NA>
      51                                       <NA>                         <NA>
      52                                       <NA>                         <NA>
      53                                       <NA>                         <NA>
      54                                       <NA>                         <NA>
      55                                       <NA>                         <NA>
      56                                       <NA>                         <NA>
      57                                       <NA>                         <NA>
      58                                       <NA>                         <NA>
      59                                       <NA>                         <NA>
      60                                       <NA>                         <NA>
      61                                       <NA>                         <NA>
      62                                       <NA>                         <NA>
      63                                       <NA>                         <NA>
      64                                       <NA>                         <NA>
      65                                       <NA>                         <NA>
      66                                       <NA>                         <NA>
      67                                       <NA>                         <NA>
      68                                       <NA>                         <NA>
         Branching Logic (Show field only if...) Is this Field Required?
      2                          branching_logic          required_field
      3                                     <NA>                    <NA>
      4                                     <NA>                    <NA>
      5                                     <NA>                    <NA>
      6                                     <NA>                    <NA>
      7                                     <NA>                    <NA>
      8                                     <NA>                    <NA>
      9                                     <NA>                    <NA>
      10                                    <NA>                    <NA>
      11                                    <NA>                    <NA>
      12                                    <NA>                    <NA>
      13                                    <NA>                    <NA>
      14                                    <NA>                    <NA>
      15                                    <NA>                    <NA>
      16                                    <NA>                    <NA>
      17                                    <NA>                    <NA>
      18                                    <NA>                    <NA>
      19                                    <NA>                    <NA>
      20                                    <NA>                    <NA>
      21                                    <NA>                    <NA>
      22                                    <NA>                    <NA>
      23                                    <NA>                    <NA>
      24                                    <NA>                    <NA>
      25                                    <NA>                    <NA>
      26                                    <NA>                    <NA>
      27                                    <NA>                    <NA>
      28                                    <NA>                    <NA>
      29                                    <NA>                    <NA>
      30                                    <NA>                    <NA>
      31                                    <NA>                    <NA>
      32                                    <NA>                    <NA>
      33                                    <NA>                    <NA>
      34                                    <NA>                    <NA>
      35                                    <NA>                    <NA>
      36                                    <NA>                    <NA>
      37                                    <NA>                    <NA>
      38                                    <NA>                    <NA>
      39                                    <NA>                    <NA>
      40                                    <NA>                    <NA>
      41                                    <NA>                    <NA>
      42                                    <NA>                    <NA>
      43                                    <NA>                    <NA>
      44                                    <NA>                    <NA>
      45                                    <NA>                    <NA>
      46                                    <NA>                    <NA>
      47                                    <NA>                    <NA>
      48                                    <NA>                    <NA>
      49                                    <NA>                    <NA>
      50                                    <NA>                    <NA>
      51                                    <NA>                    <NA>
      52                                    <NA>                    <NA>
      53                                    <NA>                    <NA>
      54                                    <NA>                    <NA>
      55                                    <NA>                    <NA>
      56                                    <NA>                    <NA>
      57                                    <NA>                    <NA>
      58                                    <NA>                    <NA>
      59                                    <NA>                    <NA>
      60                                    <NA>                    <NA>
      61                                    <NA>                    <NA>
      62                                    <NA>                    <NA>
      63                                    <NA>                    <NA>
      64                                    <NA>                    <NA>
      65                                    <NA>                    <NA>
      66                                    <NA>                    <NA>
      67                                    <NA>                    <NA>
      68                                    <NA>                    <NA>
         Custom Alignment Question Number (surveys only) Matrix Group Name
      2  custom_alignment                question_number matrix_group_name
      3              <NA>                           <NA>              <NA>
      4              <NA>                           <NA>              <NA>
      5              <NA>                           <NA>              <NA>
      6              <NA>                           <NA>              <NA>
      7              <NA>                           <NA>              <NA>
      8              <NA>                           <NA>              <NA>
      9              <NA>                           <NA>              <NA>
      10             <NA>                           <NA>              <NA>
      11             <NA>                           <NA>              <NA>
      12             <NA>                           <NA>              <NA>
      13             <NA>                           <NA>              <NA>
      14             <NA>                           <NA>              <NA>
      15             <NA>                           <NA>              <NA>
      16             <NA>                           <NA>              <NA>
      17             <NA>                           <NA>              <NA>
      18             <NA>                           <NA>              <NA>
      19             <NA>                           <NA>              <NA>
      20             <NA>                           <NA>              <NA>
      21             <NA>                           <NA>              <NA>
      22             <NA>                           <NA>              <NA>
      23             <NA>                           <NA>              <NA>
      24             <NA>                           <NA>              <NA>
      25             <NA>                           <NA>              <NA>
      26             <NA>                           <NA>              <NA>
      27             <NA>                           <NA>              <NA>
      28             <NA>                           <NA>              <NA>
      29             <NA>                           <NA>              <NA>
      30             <NA>                           <NA>              <NA>
      31             <NA>                           <NA>              <NA>
      32             <NA>                           <NA>              <NA>
      33             <NA>                           <NA>              <NA>
      34             <NA>                           <NA>              <NA>
      35             <NA>                           <NA>              <NA>
      36             <NA>                           <NA>              <NA>
      37               RH                           <NA>              <NA>
      38             <NA>                           <NA>              <NA>
      39             <NA>                           <NA>              <NA>
      40             <NA>                           <NA>              <NA>
      41             <NA>                           <NA>              <NA>
      42             <NA>                           <NA>              <NA>
      43             <NA>                           <NA>              <NA>
      44             <NA>                           <NA>              <NA>
      45             <NA>                           <NA>              <NA>
      46             <NA>                           <NA>              <NA>
      47             <NA>                           <NA>              <NA>
      48             <NA>                           <NA>              <NA>
      49             <NA>                           <NA>              <NA>
      50             <NA>                           <NA>              <NA>
      51             <NA>                           <NA>              <NA>
      52             <NA>                           <NA>              <NA>
      53             <NA>                           <NA>              <NA>
      54             <NA>                           <NA>              <NA>
      55             <NA>                           <NA>              <NA>
      56             <NA>                           <NA>              <NA>
      57             <NA>                           <NA>              <NA>
      58             <NA>                           <NA>              <NA>
      59             <NA>                           <NA>              <NA>
      60             <NA>                           <NA>              <NA>
      61             <NA>                           <NA>              <NA>
      62             <NA>                           <NA>              <NA>
      63             <NA>                           <NA>              <NA>
      64             <NA>                           <NA>              <NA>
      65             <NA>                           <NA>              <NA>
      66             <NA>                           <NA>              <NA>
      67             <NA>                           <NA>              <NA>
      68             <NA>                           <NA>              <NA>
         Matrix Ranking? Field Annotation Data Type Count of Missing Values
      2   matrix_ranking field_annotation skim_type               n_missing
      3             <NA>             <NA>      <NA>                    <NA>
      4             <NA>             <NA> character                       1
      5             <NA>             <NA> character                       1
      6             <NA>             <NA>   numeric                       2
      7             <NA>             <NA>   numeric                       2
      8             <NA>             <NA> character                       0
      9             <NA>             <NA> character                       0
      10            <NA>             <NA> character                       3
      11            <NA>             <NA> character                       3
      12            <NA>             <NA>   numeric                       1
      13            <NA>             <NA>    factor                       2
      14            <NA>             <NA>    factor                       2
      15            <NA>             <NA>    factor                       4
      16            <NA>             <NA>   logical                       0
      17            <NA>             <NA>   logical                       0
      18            <NA>             <NA>   logical                       0
      19            <NA>             <NA>   logical                       0
      20            <NA>             <NA>   logical                       0
      21            <NA>             <NA>   logical                       0
      22            <NA>             <NA>   logical                       0
      23            <NA>             <NA>   logical                       0
      24            <NA>             <NA>   logical                       0
      25            <NA>             <NA>   logical                       0
      26            <NA>             <NA>   logical                       0
      27            <NA>             <NA>   logical                       0
      28            <NA>             <NA>   logical                       0
      29            <NA>             <NA>   logical                       0
      30            <NA>             <NA>   logical                       0
      31            <NA>             <NA>   logical                       0
      32            <NA>             <NA>   logical                       0
      33            <NA>             <NA>   logical                       3
      34            <NA>             <NA>   logical                       3
      35            <NA>             <NA> character                       3
      36            <NA>             <NA> character                       3
      37            <NA>             <NA>   numeric                       3
      38            <NA>             <NA>    factor                       4
      39            <NA>             <NA>      Date                       3
      40            <NA>             <NA>      Date                       3
      41            <NA>             <NA>      Date                       3
      42            <NA>             <NA>   POSIXct                       3
      43            <NA>             <NA>   POSIXct                       3
      44            <NA>             <NA>   POSIXct                       3
      45            <NA>             <NA>   POSIXct                       3
      46            <NA>             <NA>   POSIXct                       3
      47            <NA>             <NA>   POSIXct                       3
      48            <NA>             <NA> character                       3
      49            <NA>             <NA> character                       3
      50            <NA>             <NA> character                       3
      51            <NA>             <NA>  difftime                       3
      52            <NA>             <NA>  difftime                       3
      53            <NA>             <NA>  difftime                       3
      54            <NA>             <NA> character                       3
      55            <NA>             <NA>   logical                       4
      56            <NA>             <NA>   logical                       4
      57            <NA>             <NA>   logical                       4
      58            <NA>             <NA>   logical                       4
      59            <NA>             <NA>   logical                       2
      60            <NA>             <NA>    factor                       2
      61            <NA>             <NA>   logical                       0
      62            <NA>             <NA>   logical                       0
      63            <NA>             <NA>   logical                       0
      64            <NA>             <NA>   logical                       0
      65            <NA>             <NA>    factor                       0
      66            <NA>             <NA>   logical                       0
      67            <NA>             <NA>   logical                       0
      68            <NA>             <NA>   logical                       0
         Proportion of Non-Missing Values Shortest Value (Fewest Characters)
      2                     complete_rate                      character.min
      3                              <NA>                               <NA>
      4                              0.75                                  1
      5                              0.75                                  1
      6                               0.5                               <NA>
      7                               0.5                               <NA>
      8                                 1                                  1
      9                                 1                                  1
      10                             0.25                                  4
      11                             0.25                                  5
      12                             0.75                               <NA>
      13                              0.5                               <NA>
      14                              0.5                               <NA>
      15                                0                               <NA>
      16                                1                               <NA>
      17                                1                               <NA>
      18                                1                               <NA>
      19                                1                               <NA>
      20                                1                               <NA>
      21                                1                               <NA>
      22                                1                               <NA>
      23                                1                               <NA>
      24                                1                               <NA>
      25                                1                               <NA>
      26                                1                               <NA>
      27                                1                               <NA>
      28                                1                               <NA>
      29                                1                               <NA>
      30                                1                               <NA>
      31                                1                               <NA>
      32                                1                               <NA>
      33                             0.25                               <NA>
      34                             0.25                               <NA>
      35                             0.25                                 29
      36                             0.25                                 25
      37                             0.25                               <NA>
      38                                0                               <NA>
      39                             0.25                               <NA>
      40                             0.25                               <NA>
      41                             0.25                               <NA>
      42                             0.25                               <NA>
      43                             0.25                               <NA>
      44                             0.25                               <NA>
      45                             0.25                               <NA>
      46                             0.25                               <NA>
      47                             0.25                               <NA>
      48                             0.25                                  8
      49                             0.25                                 14
      50                             0.25                                 11
      51                             0.25                               <NA>
      52                             0.25                               <NA>
      53                             0.25                               <NA>
      54                             0.25                                  5
      55                                0                               <NA>
      56                                0                               <NA>
      57                                0                               <NA>
      58                                0                               <NA>
      59                              0.5                               <NA>
      60                              0.5                               <NA>
      61                                1                               <NA>
      62                                1                               <NA>
      63                                1                               <NA>
      64                                1                               <NA>
      65                                1                               <NA>
      66                                1                               <NA>
      67                                1                               <NA>
      68                                1                               <NA>
         Longest Value (Most Characters) Count of Empty Values Count of Unique Values
      2                    character.max       character.empty     character.n_unique
      3                             <NA>                  <NA>                   <NA>
      4                               11                     0                      3
      5                               11                     0                      3
      6                             <NA>                  <NA>                   <NA>
      7                             <NA>                  <NA>                   <NA>
      8                                1                     0                      4
      9                                1                     0                      4
      10                               4                     0                      1
      11                               5                     0                      1
      12                            <NA>                  <NA>                   <NA>
      13                            <NA>                  <NA>                   <NA>
      14                            <NA>                  <NA>                   <NA>
      15                            <NA>                  <NA>                   <NA>
      16                            <NA>                  <NA>                   <NA>
      17                            <NA>                  <NA>                   <NA>
      18                            <NA>                  <NA>                   <NA>
      19                            <NA>                  <NA>                   <NA>
      20                            <NA>                  <NA>                   <NA>
      21                            <NA>                  <NA>                   <NA>
      22                            <NA>                  <NA>                   <NA>
      23                            <NA>                  <NA>                   <NA>
      24                            <NA>                  <NA>                   <NA>
      25                            <NA>                  <NA>                   <NA>
      26                            <NA>                  <NA>                   <NA>
      27                            <NA>                  <NA>                   <NA>
      28                            <NA>                  <NA>                   <NA>
      29                            <NA>                  <NA>                   <NA>
      30                            <NA>                  <NA>                   <NA>
      31                            <NA>                  <NA>                   <NA>
      32                            <NA>                  <NA>                   <NA>
      33                            <NA>                  <NA>                   <NA>
      34                            <NA>                  <NA>                   <NA>
      35                              29                     0                      1
      36                              25                     0                      1
      37                            <NA>                  <NA>                   <NA>
      38                            <NA>                  <NA>                   <NA>
      39                            <NA>                  <NA>                   <NA>
      40                            <NA>                  <NA>                   <NA>
      41                            <NA>                  <NA>                   <NA>
      42                            <NA>                  <NA>                   <NA>
      43                            <NA>                  <NA>                   <NA>
      44                            <NA>                  <NA>                   <NA>
      45                            <NA>                  <NA>                   <NA>
      46                            <NA>                  <NA>                   <NA>
      47                            <NA>                  <NA>                   <NA>
      48                               8                     0                      1
      49                              14                     0                      1
      50                              11                     0                      1
      51                            <NA>                  <NA>                   <NA>
      52                            <NA>                  <NA>                   <NA>
      53                            <NA>                  <NA>                   <NA>
      54                               5                     0                      1
      55                            <NA>                  <NA>                   <NA>
      56                            <NA>                  <NA>                   <NA>
      57                            <NA>                  <NA>                   <NA>
      58                            <NA>                  <NA>                   <NA>
      59                            <NA>                  <NA>                   <NA>
      60                            <NA>                  <NA>                   <NA>
      61                            <NA>                  <NA>                   <NA>
      62                            <NA>                  <NA>                   <NA>
      63                            <NA>                  <NA>                   <NA>
      64                            <NA>                  <NA>                   <NA>
      65                            <NA>                  <NA>                   <NA>
      66                            <NA>                  <NA>                   <NA>
      67                            <NA>                  <NA>                   <NA>
      68                            <NA>                  <NA>                   <NA>
         Count of Values that are all Whitespace         Mean Standard Deviation 
      2                     character.whitespace numeric.mean          numeric.sd
      3                                     <NA>         <NA>                <NA>
      4                                        0         <NA>                <NA>
      5                                        0         <NA>                <NA>
      6                                     <NA>            4     1.4142135623731
      7                                     <NA>            5     1.4142135623731
      8                                        0         <NA>                <NA>
      9                                        0         <NA>                <NA>
      10                                       0         <NA>                <NA>
      11                                       0         <NA>                <NA>
      12                                    <NA>            2                   0
      13                                    <NA>         <NA>                <NA>
      14                                    <NA>         <NA>                <NA>
      15                                    <NA>         <NA>                <NA>
      16                                    <NA>         <NA>                <NA>
      17                                    <NA>         <NA>                <NA>
      18                                    <NA>         <NA>                <NA>
      19                                    <NA>         <NA>                <NA>
      20                                    <NA>         <NA>                <NA>
      21                                    <NA>         <NA>                <NA>
      22                                    <NA>         <NA>                <NA>
      23                                    <NA>         <NA>                <NA>
      24                                    <NA>         <NA>                <NA>
      25                                    <NA>         <NA>                <NA>
      26                                    <NA>         <NA>                <NA>
      27                                    <NA>         <NA>                <NA>
      28                                    <NA>         <NA>                <NA>
      29                                    <NA>         <NA>                <NA>
      30                                    <NA>         <NA>                <NA>
      31                                    <NA>         <NA>                <NA>
      32                                    <NA>         <NA>                <NA>
      33                                    <NA>         <NA>                <NA>
      34                                    <NA>         <NA>                <NA>
      35                                       0         <NA>                <NA>
      36                                       0         <NA>                <NA>
      37                                    <NA>           73                <NA>
      38                                    <NA>         <NA>                <NA>
      39                                    <NA>         <NA>                <NA>
      40                                    <NA>         <NA>                <NA>
      41                                    <NA>         <NA>                <NA>
      42                                    <NA>         <NA>                <NA>
      43                                    <NA>         <NA>                <NA>
      44                                    <NA>         <NA>                <NA>
      45                                    <NA>         <NA>                <NA>
      46                                    <NA>         <NA>                <NA>
      47                                    <NA>         <NA>                <NA>
      48                                       0         <NA>                <NA>
      49                                       0         <NA>                <NA>
      50                                       0         <NA>                <NA>
      51                                    <NA>         <NA>                <NA>
      52                                    <NA>         <NA>                <NA>
      53                                    <NA>         <NA>                <NA>
      54                                       0         <NA>                <NA>
      55                                    <NA>         <NA>                <NA>
      56                                    <NA>         <NA>                <NA>
      57                                    <NA>         <NA>                <NA>
      58                                    <NA>         <NA>                <NA>
      59                                    <NA>         <NA>                <NA>
      60                                    <NA>         <NA>                <NA>
      61                                    <NA>         <NA>                <NA>
      62                                    <NA>         <NA>                <NA>
      63                                    <NA>         <NA>                <NA>
      64                                    <NA>         <NA>                <NA>
      65                                    <NA>         <NA>                <NA>
      66                                    <NA>         <NA>                <NA>
      67                                    <NA>         <NA>                <NA>
      68                                    <NA>         <NA>                <NA>
            Minimum 25th Percentile      Median 75th Percentile      Maximum
      2  numeric.p0     numeric.p25 numeric.p50     numeric.p75 numeric.p100
      3        <NA>            <NA>        <NA>            <NA>         <NA>
      4        <NA>            <NA>        <NA>            <NA>         <NA>
      5        <NA>            <NA>        <NA>            <NA>         <NA>
      6           3             3.5           4             4.5            5
      7           4             4.5           5             5.5            6
      8        <NA>            <NA>        <NA>            <NA>         <NA>
      9        <NA>            <NA>        <NA>            <NA>         <NA>
      10       <NA>            <NA>        <NA>            <NA>         <NA>
      11       <NA>            <NA>        <NA>            <NA>         <NA>
      12          2               2           2               2            2
      13       <NA>            <NA>        <NA>            <NA>         <NA>
      14       <NA>            <NA>        <NA>            <NA>         <NA>
      15       <NA>            <NA>        <NA>            <NA>         <NA>
      16       <NA>            <NA>        <NA>            <NA>         <NA>
      17       <NA>            <NA>        <NA>            <NA>         <NA>
      18       <NA>            <NA>        <NA>            <NA>         <NA>
      19       <NA>            <NA>        <NA>            <NA>         <NA>
      20       <NA>            <NA>        <NA>            <NA>         <NA>
      21       <NA>            <NA>        <NA>            <NA>         <NA>
      22       <NA>            <NA>        <NA>            <NA>         <NA>
      23       <NA>            <NA>        <NA>            <NA>         <NA>
      24       <NA>            <NA>        <NA>            <NA>         <NA>
      25       <NA>            <NA>        <NA>            <NA>         <NA>
      26       <NA>            <NA>        <NA>            <NA>         <NA>
      27       <NA>            <NA>        <NA>            <NA>         <NA>
      28       <NA>            <NA>        <NA>            <NA>         <NA>
      29       <NA>            <NA>        <NA>            <NA>         <NA>
      30       <NA>            <NA>        <NA>            <NA>         <NA>
      31       <NA>            <NA>        <NA>            <NA>         <NA>
      32       <NA>            <NA>        <NA>            <NA>         <NA>
      33       <NA>            <NA>        <NA>            <NA>         <NA>
      34       <NA>            <NA>        <NA>            <NA>         <NA>
      35       <NA>            <NA>        <NA>            <NA>         <NA>
      36       <NA>            <NA>        <NA>            <NA>         <NA>
      37         73              73          73              73           73
      38       <NA>            <NA>        <NA>            <NA>         <NA>
      39       <NA>            <NA>        <NA>            <NA>         <NA>
      40       <NA>            <NA>        <NA>            <NA>         <NA>
      41       <NA>            <NA>        <NA>            <NA>         <NA>
      42       <NA>            <NA>        <NA>            <NA>         <NA>
      43       <NA>            <NA>        <NA>            <NA>         <NA>
      44       <NA>            <NA>        <NA>            <NA>         <NA>
      45       <NA>            <NA>        <NA>            <NA>         <NA>
      46       <NA>            <NA>        <NA>            <NA>         <NA>
      47       <NA>            <NA>        <NA>            <NA>         <NA>
      48       <NA>            <NA>        <NA>            <NA>         <NA>
      49       <NA>            <NA>        <NA>            <NA>         <NA>
      50       <NA>            <NA>        <NA>            <NA>         <NA>
      51       <NA>            <NA>        <NA>            <NA>         <NA>
      52       <NA>            <NA>        <NA>            <NA>         <NA>
      53       <NA>            <NA>        <NA>            <NA>         <NA>
      54       <NA>            <NA>        <NA>            <NA>         <NA>
      55       <NA>            <NA>        <NA>            <NA>         <NA>
      56       <NA>            <NA>        <NA>            <NA>         <NA>
      57       <NA>            <NA>        <NA>            <NA>         <NA>
      58       <NA>            <NA>        <NA>            <NA>         <NA>
      59       <NA>            <NA>        <NA>            <NA>         <NA>
      60       <NA>            <NA>        <NA>            <NA>         <NA>
      61       <NA>            <NA>        <NA>            <NA>         <NA>
      62       <NA>            <NA>        <NA>            <NA>         <NA>
      63       <NA>            <NA>        <NA>            <NA>         <NA>
      64       <NA>            <NA>        <NA>            <NA>         <NA>
      65       <NA>            <NA>        <NA>            <NA>         <NA>
      66       <NA>            <NA>        <NA>            <NA>         <NA>
      67       <NA>            <NA>        <NA>            <NA>         <NA>
      68       <NA>            <NA>        <NA>            <NA>         <NA>
            Histogram Is the Categorical Value Ordered? Count of Unique Values
      2  numeric.hist                                NA        factor.n_unique
      3          <NA>                                NA                   <NA>
      4          <NA>                                NA                   <NA>
      5          <NA>                                NA                   <NA>
      6         ▇▁▁▁▇                                NA                   <NA>
      7         ▇▁▁▁▇                                NA                   <NA>
      8          <NA>                                NA                   <NA>
      9          <NA>                                NA                   <NA>
      10         <NA>                                NA                   <NA>
      11         <NA>                                NA                   <NA>
      12        ▁▁▇▁▁                                NA                   <NA>
      13         <NA>                             FALSE                      2
      14         <NA>                             FALSE                      2
      15         <NA>                             FALSE                      0
      16         <NA>                                NA                   <NA>
      17         <NA>                                NA                   <NA>
      18         <NA>                                NA                   <NA>
      19         <NA>                                NA                   <NA>
      20         <NA>                                NA                   <NA>
      21         <NA>                                NA                   <NA>
      22         <NA>                                NA                   <NA>
      23         <NA>                                NA                   <NA>
      24         <NA>                                NA                   <NA>
      25         <NA>                                NA                   <NA>
      26         <NA>                                NA                   <NA>
      27         <NA>                                NA                   <NA>
      28         <NA>                                NA                   <NA>
      29         <NA>                                NA                   <NA>
      30         <NA>                                NA                   <NA>
      31         <NA>                                NA                   <NA>
      32         <NA>                                NA                   <NA>
      33         <NA>                                NA                   <NA>
      34         <NA>                                NA                   <NA>
      35         <NA>                                NA                   <NA>
      36         <NA>                                NA                   <NA>
      37        ▁▁▇▁▁                                NA                   <NA>
      38         <NA>                             FALSE                      0
      39         <NA>                                NA                   <NA>
      40         <NA>                                NA                   <NA>
      41         <NA>                                NA                   <NA>
      42         <NA>                                NA                   <NA>
      43         <NA>                                NA                   <NA>
      44         <NA>                                NA                   <NA>
      45         <NA>                                NA                   <NA>
      46         <NA>                                NA                   <NA>
      47         <NA>                                NA                   <NA>
      48         <NA>                                NA                   <NA>
      49         <NA>                                NA                   <NA>
      50         <NA>                                NA                   <NA>
      51         <NA>                                NA                   <NA>
      52         <NA>                                NA                   <NA>
      53         <NA>                                NA                   <NA>
      54         <NA>                                NA                   <NA>
      55         <NA>                                NA                   <NA>
      56         <NA>                                NA                   <NA>
      57         <NA>                                NA                   <NA>
      58         <NA>                                NA                   <NA>
      59         <NA>                                NA                   <NA>
      60         <NA>                             FALSE                      2
      61         <NA>                                NA                   <NA>
      62         <NA>                                NA                   <NA>
      63         <NA>                                NA                   <NA>
      64         <NA>                                NA                   <NA>
      65         <NA>                             FALSE                      2
      66         <NA>                                NA                   <NA>
      67         <NA>                                NA                   <NA>
      68         <NA>                                NA                   <NA>
           Most Frequent Values Proportion of TRUE Values Count of Logical Values
      2       factor.top_counts              logical.mean           logical.count
      3                    <NA>                      <NA>                    <NA>
      4                    <NA>                      <NA>                    <NA>
      5                    <NA>                      <NA>                    <NA>
      6                    <NA>                      <NA>                    <NA>
      7                    <NA>                      <NA>                    <NA>
      8                    <NA>                      <NA>                    <NA>
      9                    <NA>                      <NA>                    <NA>
      10                   <NA>                      <NA>                    <NA>
      11                   <NA>                      <NA>                    <NA>
      12                   <NA>                      <NA>                    <NA>
      13 one: 1, thr: 1, two: 0                      <NA>                    <NA>
      14       B: 1, C: 1, A: 0                      <NA>                    <NA>
      15             A: 0, C: 0                      <NA>                    <NA>
      16                   <NA>                       0.5          FAL: 2, TRU: 2
      17                   <NA>                         0                  FAL: 4
      18                   <NA>                         0                  FAL: 4
      19                   <NA>                       0.5          FAL: 2, TRU: 2
      20                   <NA>                         0                  FAL: 4
      21                   <NA>                         0                  FAL: 4
      22                   <NA>                      0.25          FAL: 3, TRU: 1
      23                   <NA>                      0.25          FAL: 3, TRU: 1
      24                   <NA>                         0                  FAL: 4
      25                   <NA>                      0.25          FAL: 3, TRU: 1
      26                   <NA>                      0.25          FAL: 3, TRU: 1
      27                   <NA>                         0                  FAL: 4
      28                   <NA>                         0                  FAL: 4
      29                   <NA>                      0.25          FAL: 3, TRU: 1
      30                   <NA>                         0                  FAL: 4
      31                   <NA>                      0.25          FAL: 3, TRU: 1
      32                   <NA>                         0                  FAL: 4
      33                   <NA>                         1                  TRU: 1
      34                   <NA>                         0                  FAL: 1
      35                   <NA>                      <NA>                    <NA>
      36                   <NA>                      <NA>                    <NA>
      37                   <NA>                      <NA>                    <NA>
      38                     :                       <NA>                    <NA>
      39                   <NA>                      <NA>                    <NA>
      40                   <NA>                      <NA>                    <NA>
      41                   <NA>                      <NA>                    <NA>
      42                   <NA>                      <NA>                    <NA>
      43                   <NA>                      <NA>                    <NA>
      44                   <NA>                      <NA>                    <NA>
      45                   <NA>                      <NA>                    <NA>
      46                   <NA>                      <NA>                    <NA>
      47                   <NA>                      <NA>                    <NA>
      48                   <NA>                      <NA>                    <NA>
      49                   <NA>                      <NA>                    <NA>
      50                   <NA>                      <NA>                    <NA>
      51                   <NA>                      <NA>                    <NA>
      52                   <NA>                      <NA>                    <NA>
      53                   <NA>                      <NA>                    <NA>
      54                   <NA>                      <NA>                    <NA>
      55                   <NA>                   #VALUE!                      : 
      56                   <NA>                   #VALUE!                      : 
      57                   <NA>                   #VALUE!                      : 
      58                   <NA>                   #VALUE!                      : 
      59                   <NA>                       0.5          FAL: 1, TRU: 1
      60 Cho: 1, Cho: 1, Cho: 0                      <NA>                    <NA>
      61                   <NA>                         0                  FAL: 4
      62                   <NA>                       0.5          FAL: 2, TRU: 2
      63                   <NA>                       0.5          FAL: 2, TRU: 2
      64                   <NA>         0.666666666666667          TRU: 2, FAL: 1
      65 Cho: 2, Cho: 1, Cho: 0                      <NA>                    <NA>
      66                   <NA>         0.666666666666667          TRU: 2, FAL: 1
      67                   <NA>         0.333333333333333          FAL: 2, TRU: 1
      68                   <NA>         0.333333333333333          FAL: 2, TRU: 1
           Earliest     Latest      Median Count of Unique Values            Earliest
      2    Date.min   Date.max Date.median          Date.n_unique         POSIXct.min
      3        <NA>       <NA>        <NA>                   <NA>                <NA>
      4        <NA>       <NA>        <NA>                   <NA>                <NA>
      5        <NA>       <NA>        <NA>                   <NA>                <NA>
      6        <NA>       <NA>        <NA>                   <NA>                <NA>
      7        <NA>       <NA>        <NA>                   <NA>                <NA>
      8        <NA>       <NA>        <NA>                   <NA>                <NA>
      9        <NA>       <NA>        <NA>                   <NA>                <NA>
      10       <NA>       <NA>        <NA>                   <NA>                <NA>
      11       <NA>       <NA>        <NA>                   <NA>                <NA>
      12       <NA>       <NA>        <NA>                   <NA>                <NA>
      13       <NA>       <NA>        <NA>                   <NA>                <NA>
      14       <NA>       <NA>        <NA>                   <NA>                <NA>
      15       <NA>       <NA>        <NA>                   <NA>                <NA>
      16       <NA>       <NA>        <NA>                   <NA>                <NA>
      17       <NA>       <NA>        <NA>                   <NA>                <NA>
      18       <NA>       <NA>        <NA>                   <NA>                <NA>
      19       <NA>       <NA>        <NA>                   <NA>                <NA>
      20       <NA>       <NA>        <NA>                   <NA>                <NA>
      21       <NA>       <NA>        <NA>                   <NA>                <NA>
      22       <NA>       <NA>        <NA>                   <NA>                <NA>
      23       <NA>       <NA>        <NA>                   <NA>                <NA>
      24       <NA>       <NA>        <NA>                   <NA>                <NA>
      25       <NA>       <NA>        <NA>                   <NA>                <NA>
      26       <NA>       <NA>        <NA>                   <NA>                <NA>
      27       <NA>       <NA>        <NA>                   <NA>                <NA>
      28       <NA>       <NA>        <NA>                   <NA>                <NA>
      29       <NA>       <NA>        <NA>                   <NA>                <NA>
      30       <NA>       <NA>        <NA>                   <NA>                <NA>
      31       <NA>       <NA>        <NA>                   <NA>                <NA>
      32       <NA>       <NA>        <NA>                   <NA>                <NA>
      33       <NA>       <NA>        <NA>                   <NA>                <NA>
      34       <NA>       <NA>        <NA>                   <NA>                <NA>
      35       <NA>       <NA>        <NA>                   <NA>                <NA>
      36       <NA>       <NA>        <NA>                   <NA>                <NA>
      37       <NA>       <NA>        <NA>                   <NA>                <NA>
      38       <NA>       <NA>        <NA>                   <NA>                <NA>
      39 2022-08-03 2022-08-03  2022-08-03                      1                <NA>
      40 2022-08-03 2022-08-03  2022-08-03                      1                <NA>
      41 2022-08-03 2022-08-03  2022-08-03                      1                <NA>
      42       <NA>       <NA>        <NA>                   <NA> 2022-08-03 15:15:00
      43       <NA>       <NA>        <NA>                   <NA> 2022-08-03 15:15:00
      44       <NA>       <NA>        <NA>                   <NA> 2022-08-03 15:15:00
      45       <NA>       <NA>        <NA>                   <NA> 2022-08-03 15:15:04
      46       <NA>       <NA>        <NA>                   <NA> 2022-08-03 15:15:04
      47       <NA>       <NA>        <NA>                   <NA> 2022-08-03 15:15:05
      48       <NA>       <NA>        <NA>                   <NA>                <NA>
      49       <NA>       <NA>        <NA>                   <NA>                <NA>
      50       <NA>       <NA>        <NA>                   <NA>                <NA>
      51       <NA>       <NA>        <NA>                   <NA>                <NA>
      52       <NA>       <NA>        <NA>                   <NA>                <NA>
      53       <NA>       <NA>        <NA>                   <NA>                <NA>
      54       <NA>       <NA>        <NA>                   <NA>                <NA>
      55       <NA>       <NA>        <NA>                   <NA>                <NA>
      56       <NA>       <NA>        <NA>                   <NA>                <NA>
      57       <NA>       <NA>        <NA>                   <NA>                <NA>
      58       <NA>       <NA>        <NA>                   <NA>                <NA>
      59       <NA>       <NA>        <NA>                   <NA>                <NA>
      60       <NA>       <NA>        <NA>                   <NA>                <NA>
      61       <NA>       <NA>        <NA>                   <NA>                <NA>
      62       <NA>       <NA>        <NA>                   <NA>                <NA>
      63       <NA>       <NA>        <NA>                   <NA>                <NA>
      64       <NA>       <NA>        <NA>                   <NA>                <NA>
      65       <NA>       <NA>        <NA>                   <NA>                <NA>
      66       <NA>       <NA>        <NA>                   <NA>                <NA>
      67       <NA>       <NA>        <NA>                   <NA>                <NA>
      68       <NA>       <NA>        <NA>                   <NA>                <NA>
                      Latest              Median Count of Unique Values      Minimum
      2          POSIXct.max      POSIXct.median       POSIXct.n_unique difftime.min
      3                 <NA>                <NA>                   <NA>         <NA>
      4                 <NA>                <NA>                   <NA>         <NA>
      5                 <NA>                <NA>                   <NA>         <NA>
      6                 <NA>                <NA>                   <NA>         <NA>
      7                 <NA>                <NA>                   <NA>         <NA>
      8                 <NA>                <NA>                   <NA>         <NA>
      9                 <NA>                <NA>                   <NA>         <NA>
      10                <NA>                <NA>                   <NA>         <NA>
      11                <NA>                <NA>                   <NA>         <NA>
      12                <NA>                <NA>                   <NA>         <NA>
      13                <NA>                <NA>                   <NA>         <NA>
      14                <NA>                <NA>                   <NA>         <NA>
      15                <NA>                <NA>                   <NA>         <NA>
      16                <NA>                <NA>                   <NA>         <NA>
      17                <NA>                <NA>                   <NA>         <NA>
      18                <NA>                <NA>                   <NA>         <NA>
      19                <NA>                <NA>                   <NA>         <NA>
      20                <NA>                <NA>                   <NA>         <NA>
      21                <NA>                <NA>                   <NA>         <NA>
      22                <NA>                <NA>                   <NA>         <NA>
      23                <NA>                <NA>                   <NA>         <NA>
      24                <NA>                <NA>                   <NA>         <NA>
      25                <NA>                <NA>                   <NA>         <NA>
      26                <NA>                <NA>                   <NA>         <NA>
      27                <NA>                <NA>                   <NA>         <NA>
      28                <NA>                <NA>                   <NA>         <NA>
      29                <NA>                <NA>                   <NA>         <NA>
      30                <NA>                <NA>                   <NA>         <NA>
      31                <NA>                <NA>                   <NA>         <NA>
      32                <NA>                <NA>                   <NA>         <NA>
      33                <NA>                <NA>                   <NA>         <NA>
      34                <NA>                <NA>                   <NA>         <NA>
      35                <NA>                <NA>                   <NA>         <NA>
      36                <NA>                <NA>                   <NA>         <NA>
      37                <NA>                <NA>                   <NA>         <NA>
      38                <NA>                <NA>                   <NA>         <NA>
      39                <NA>                <NA>                   <NA>         <NA>
      40                <NA>                <NA>                   <NA>         <NA>
      41                <NA>                <NA>                   <NA>         <NA>
      42 2022-08-03 15:15:00 2022-08-03 15:15:00                      1         <NA>
      43 2022-08-03 15:15:00 2022-08-03 15:15:00                      1         <NA>
      44 2022-08-03 15:15:00 2022-08-03 15:15:00                      1         <NA>
      45 2022-08-03 15:15:04 2022-08-03 15:15:04                      1         <NA>
      46 2022-08-03 15:15:04 2022-08-03 15:15:04                      1         <NA>
      47 2022-08-03 15:15:05 2022-08-03 15:15:05                      1         <NA>
      48                <NA>                <NA>                   <NA>         <NA>
      49                <NA>                <NA>                   <NA>         <NA>
      50                <NA>                <NA>                   <NA>         <NA>
      51                <NA>                <NA>                   <NA>        54949
      52                <NA>                <NA>                   <NA>        54900
      53                <NA>                <NA>                   <NA>        54000
      54                <NA>                <NA>                   <NA>         <NA>
      55                <NA>                <NA>                   <NA>         <NA>
      56                <NA>                <NA>                   <NA>         <NA>
      57                <NA>                <NA>                   <NA>         <NA>
      58                <NA>                <NA>                   <NA>         <NA>
      59                <NA>                <NA>                   <NA>         <NA>
      60                <NA>                <NA>                   <NA>         <NA>
      61                <NA>                <NA>                   <NA>         <NA>
      62                <NA>                <NA>                   <NA>         <NA>
      63                <NA>                <NA>                   <NA>         <NA>
      64                <NA>                <NA>                   <NA>         <NA>
      65                <NA>                <NA>                   <NA>         <NA>
      66                <NA>                <NA>                   <NA>         <NA>
      67                <NA>                <NA>                   <NA>         <NA>
      68                <NA>                <NA>                   <NA>         <NA>
              Maximum          Median Count of Unique Values
      2  difftime.max difftime.median      difftime.n_unique
      3          <NA>            <NA>                   <NA>
      4          <NA>            <NA>                   <NA>
      5          <NA>            <NA>                   <NA>
      6          <NA>            <NA>                   <NA>
      7          <NA>            <NA>                   <NA>
      8          <NA>            <NA>                   <NA>
      9          <NA>            <NA>                   <NA>
      10         <NA>            <NA>                   <NA>
      11         <NA>            <NA>                   <NA>
      12         <NA>            <NA>                   <NA>
      13         <NA>            <NA>                   <NA>
      14         <NA>            <NA>                   <NA>
      15         <NA>            <NA>                   <NA>
      16         <NA>            <NA>                   <NA>
      17         <NA>            <NA>                   <NA>
      18         <NA>            <NA>                   <NA>
      19         <NA>            <NA>                   <NA>
      20         <NA>            <NA>                   <NA>
      21         <NA>            <NA>                   <NA>
      22         <NA>            <NA>                   <NA>
      23         <NA>            <NA>                   <NA>
      24         <NA>            <NA>                   <NA>
      25         <NA>            <NA>                   <NA>
      26         <NA>            <NA>                   <NA>
      27         <NA>            <NA>                   <NA>
      28         <NA>            <NA>                   <NA>
      29         <NA>            <NA>                   <NA>
      30         <NA>            <NA>                   <NA>
      31         <NA>            <NA>                   <NA>
      32         <NA>            <NA>                   <NA>
      33         <NA>            <NA>                   <NA>
      34         <NA>            <NA>                   <NA>
      35         <NA>            <NA>                   <NA>
      36         <NA>            <NA>                   <NA>
      37         <NA>            <NA>                   <NA>
      38         <NA>            <NA>                   <NA>
      39         <NA>            <NA>                   <NA>
      40         <NA>            <NA>                   <NA>
      41         <NA>            <NA>                   <NA>
      42         <NA>            <NA>                   <NA>
      43         <NA>            <NA>                   <NA>
      44         <NA>            <NA>                   <NA>
      45         <NA>            <NA>                   <NA>
      46         <NA>            <NA>                   <NA>
      47         <NA>            <NA>                   <NA>
      48         <NA>            <NA>                   <NA>
      49         <NA>            <NA>                   <NA>
      50         <NA>            <NA>                   <NA>
      51        54949        15:15:49                      1
      52        54900        15:15:00                      1
      53        54000        15:00:00                      1
      54         <NA>            <NA>                   <NA>
      55         <NA>            <NA>                   <NA>
      56         <NA>            <NA>                   <NA>
      57         <NA>            <NA>                   <NA>
      58         <NA>            <NA>                   <NA>
      59         <NA>            <NA>                   <NA>
      60         <NA>            <NA>                   <NA>
      61         <NA>            <NA>                   <NA>
      62         <NA>            <NA>                   <NA>
      63         <NA>            <NA>                   <NA>
      64         <NA>            <NA>                   <NA>
      65         <NA>            <NA>                   <NA>
      66         <NA>            <NA>                   <NA>
      67         <NA>            <NA>                   <NA>
      68         <NA>            <NA>                   <NA>
      
      
      [[2]]
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
      
      [[3]]
      [[3]]$fileVersion
      NULL
      
      [[3]]$fileSharing
      NULL
      
      [[3]]$workbookPr
      [1] "<workbookPr date1904=\"false\"/>"
      
      [[3]]$alternateContent
      NULL
      
      [[3]]$revisionPtr
      NULL
      
      [[3]]$absPath
      NULL
      
      [[3]]$workbookProtection
      NULL
      
      [[3]]$bookViews
      [1] "<bookViews><workbookView windowHeight=\"130000\" windowWidth=\"6000\"/></bookViews>"
      
      [[3]]$sheets
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
      
      [[3]]$functionGroups
      NULL
      
      [[3]]$externalReferences
      NULL
      
      [[3]]$definedNames
      NULL
      
      [[3]]$calcPr
      NULL
      
      [[3]]$oleSize
      NULL
      
      [[3]]$customWorkbookViews
      NULL
      
      [[3]]$pivotCaches
      NULL
      
      [[3]]$smartTagPr
      NULL
      
      [[3]]$smartTagTypes
      NULL
      
      [[3]]$webPublishing
      NULL
      
      [[3]]$fileRecoveryPr
      NULL
      
      [[3]]$webPublishObjects
      NULL
      
      [[3]]$extLst
      NULL
      
      
      [[4]]
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
      
      [[5]]
       [1]  1  2  3  4  5  6  7  8  9 10 11
      
      [[6]]
       [1] "Table of Contents"           "Nonrepeated"                
       [3] "Nonrepeated2"                "Repeated"                   
       [5] "Data Field Types"            "Text Input Validation Types"
       [7] "API No Access"               "API No Access 2"            
       [9] "Survey"                      "Repeat Survey"              
      [11] "REDCap Metadata"            
      

