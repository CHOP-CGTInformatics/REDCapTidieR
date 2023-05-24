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
         Section Header
      2  section_header
      3            <NA>
      4            <NA>
      5            <NA>
      6            <NA>
      7            <NA>
      8            <NA>
      9            <NA>
      10           <NA>
      11           <NA>
      12           <NA>
      13           <NA>
      14           <NA>
      15           <NA>
      16           <NA>
      17           <NA>
      18           <NA>
      19           <NA>
      20           <NA>
      21           <NA>
      22           <NA>
      23           <NA>
      24           <NA>
      25           <NA>
      26           <NA>
      27           <NA>
      28           <NA>
      29           <NA>
      30           <NA>
      31           <NA>
      32           <NA>
      33           <NA>
      34           <NA>
      35           <NA>
      36           <NA>
      37           <NA>
      38           <NA>
      39           <NA>
      40           <NA>
      41           <NA>
      42           <NA>
      43           <NA>
      44           <NA>
      45           <NA>
      46           <NA>
      47           <NA>
      48           <NA>
      49           <NA>
      50           <NA>
      51           <NA>
      52           <NA>
      53           <NA>
      54           <NA>
      55           <NA>
      56           <NA>
      57           <NA>
      58           <NA>
      59           <NA>
      60           <NA>
      61           <NA>
      62           <NA>
      63           <NA>
      64           <NA>
      65           <NA>
      66           <NA>
      67           <NA>
      68           <NA>
                                                                                Select Choices or Calculations
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
         Field Note Text Validation Type OR Show Slider Number Text Validation Min
      2  field_note text_validation_type_or_show_slider_number text_validation_min
      3        <NA>                                       <NA>                <NA>
      4        <NA>                                       <NA>                <NA>
      5        <NA>                                       <NA>                <NA>
      6        <NA>                                       <NA>                <NA>
      7        <NA>                                       <NA>                <NA>
      8        <NA>                                       <NA>                <NA>
      9        <NA>                                       <NA>                <NA>
      10       <NA>                                       <NA>                <NA>
      11       <NA>                                       <NA>                <NA>
      12       <NA>                                       <NA>                <NA>
      13       <NA>                                       <NA>                <NA>
      14       <NA>                                       <NA>                <NA>
      15       <NA>                                       <NA>                <NA>
      16       <NA>                                       <NA>                <NA>
      17       <NA>                                       <NA>                <NA>
      18       <NA>                                       <NA>                <NA>
      19       <NA>                                       <NA>                <NA>
      20       <NA>                                       <NA>                <NA>
      21       <NA>                                       <NA>                <NA>
      22       <NA>                                       <NA>                <NA>
      23       <NA>                                       <NA>                <NA>
      24       <NA>                                       <NA>                <NA>
      25       <NA>                                       <NA>                <NA>
      26       <NA>                                       <NA>                <NA>
      27       <NA>                                       <NA>                <NA>
      28       <NA>                                       <NA>                <NA>
      29       <NA>                                       <NA>                <NA>
      30       <NA>                                       <NA>                <NA>
      31       <NA>                                       <NA>                <NA>
      32       <NA>                                       <NA>                <NA>
      33       <NA>                                       <NA>                <NA>
      34       <NA>                                       <NA>                <NA>
      35       <NA>                                  signature                <NA>
      36       <NA>                                       <NA>                <NA>
      37       <NA>                                       <NA>                <NA>
      38       <NA>                                       <NA>                <NA>
      39       <NA>                                   date_dmy                <NA>
      40       <NA>                                   date_mdy                <NA>
      41       <NA>                                   date_ymd                <NA>
      42       <NA>                               datetime_dmy                <NA>
      43       <NA>                               datetime_mdy                <NA>
      44       <NA>                               datetime_ymd                <NA>
      45       <NA>                       datetime_seconds_dmy                <NA>
      46       <NA>                       datetime_seconds_mdy                <NA>
      47       <NA>                       datetime_seconds_ymd                <NA>
      48       <NA>                                     mrn_8d                <NA>
      49       <NA>                                      phone                <NA>
      50       <NA>                                        ssn                <NA>
      51       <NA>                              time_hh_mm_ss                <NA>
      52       <NA>                                       time                <NA>
      53       <NA>                                 time_mm_ss                <NA>
      54       <NA>                                    zipcode                <NA>
      55       <NA>                                       <NA>                <NA>
      56       <NA>                                       <NA>                <NA>
      57       <NA>                                       <NA>                <NA>
      58       <NA>                                       <NA>                <NA>
      59       <NA>                                       <NA>                <NA>
      60       <NA>                                       <NA>                <NA>
      61       <NA>                                       <NA>                <NA>
      62       <NA>                                       <NA>                <NA>
      63       <NA>                                       <NA>                <NA>
      64       <NA>                                       <NA>                <NA>
      65       <NA>                                       <NA>                <NA>
      66       <NA>                                       <NA>                <NA>
      67       <NA>                                       <NA>                <NA>
      68       <NA>                                       <NA>                <NA>
         Text Validation Max Identifier? Branching Logic (Show field only if...)
      2  text_validation_max  identifier                         branching_logic
      3                 <NA>        <NA>                                    <NA>
      4                 <NA>        <NA>                                    <NA>
      5                 <NA>        <NA>                                    <NA>
      6                 <NA>        <NA>                                    <NA>
      7                 <NA>        <NA>                                    <NA>
      8                 <NA>        <NA>                                    <NA>
      9                 <NA>        <NA>                                    <NA>
      10                <NA>        <NA>                                    <NA>
      11                <NA>        <NA>                                    <NA>
      12                <NA>        <NA>                                    <NA>
      13                <NA>        <NA>                                    <NA>
      14                <NA>        <NA>                                    <NA>
      15                <NA>        <NA>                                    <NA>
      16                <NA>        <NA>                                    <NA>
      17                <NA>        <NA>                                    <NA>
      18                <NA>        <NA>                                    <NA>
      19                <NA>        <NA>                                    <NA>
      20                <NA>        <NA>                                    <NA>
      21                <NA>        <NA>                                    <NA>
      22                <NA>        <NA>                                    <NA>
      23                <NA>        <NA>                                    <NA>
      24                <NA>        <NA>                                    <NA>
      25                <NA>        <NA>                                    <NA>
      26                <NA>        <NA>                                    <NA>
      27                <NA>        <NA>                                    <NA>
      28                <NA>        <NA>                                    <NA>
      29                <NA>        <NA>                                    <NA>
      30                <NA>        <NA>                                    <NA>
      31                <NA>        <NA>                                    <NA>
      32                <NA>        <NA>                                    <NA>
      33                <NA>        <NA>                                    <NA>
      34                <NA>        <NA>                                    <NA>
      35                <NA>        <NA>                                    <NA>
      36                <NA>        <NA>                                    <NA>
      37                <NA>        <NA>                                    <NA>
      38                <NA>        <NA>                                    <NA>
      39                <NA>        <NA>                                    <NA>
      40                <NA>        <NA>                                    <NA>
      41                <NA>        <NA>                                    <NA>
      42                <NA>        <NA>                                    <NA>
      43                <NA>        <NA>                                    <NA>
      44                <NA>        <NA>                                    <NA>
      45                <NA>        <NA>                                    <NA>
      46                <NA>        <NA>                                    <NA>
      47                <NA>        <NA>                                    <NA>
      48                <NA>        <NA>                                    <NA>
      49                <NA>        <NA>                                    <NA>
      50                <NA>        <NA>                                    <NA>
      51                <NA>        <NA>                                    <NA>
      52                <NA>        <NA>                                    <NA>
      53                <NA>        <NA>                                    <NA>
      54                <NA>        <NA>                                    <NA>
      55                <NA>        <NA>                                    <NA>
      56                <NA>        <NA>                                    <NA>
      57                <NA>        <NA>                                    <NA>
      58                <NA>        <NA>                                    <NA>
      59                <NA>        <NA>                                    <NA>
      60                <NA>        <NA>                                    <NA>
      61                <NA>        <NA>                                    <NA>
      62                <NA>        <NA>                                    <NA>
      63                <NA>        <NA>                                    <NA>
      64                <NA>        <NA>                                    <NA>
      65                <NA>        <NA>                                    <NA>
      66                <NA>        <NA>                                    <NA>
      67                <NA>        <NA>                                    <NA>
      68                <NA>        <NA>                                    <NA>
         Required Field? Custom Alignment Question Number (surveys only)
      2   required_field custom_alignment                question_number
      3             <NA>             <NA>                           <NA>
      4             <NA>             <NA>                           <NA>
      5             <NA>             <NA>                           <NA>
      6             <NA>             <NA>                           <NA>
      7             <NA>             <NA>                           <NA>
      8             <NA>             <NA>                           <NA>
      9             <NA>             <NA>                           <NA>
      10            <NA>             <NA>                           <NA>
      11            <NA>             <NA>                           <NA>
      12            <NA>             <NA>                           <NA>
      13            <NA>             <NA>                           <NA>
      14            <NA>             <NA>                           <NA>
      15            <NA>             <NA>                           <NA>
      16            <NA>             <NA>                           <NA>
      17            <NA>             <NA>                           <NA>
      18            <NA>             <NA>                           <NA>
      19            <NA>             <NA>                           <NA>
      20            <NA>             <NA>                           <NA>
      21            <NA>             <NA>                           <NA>
      22            <NA>             <NA>                           <NA>
      23            <NA>             <NA>                           <NA>
      24            <NA>             <NA>                           <NA>
      25            <NA>             <NA>                           <NA>
      26            <NA>             <NA>                           <NA>
      27            <NA>             <NA>                           <NA>
      28            <NA>             <NA>                           <NA>
      29            <NA>             <NA>                           <NA>
      30            <NA>             <NA>                           <NA>
      31            <NA>             <NA>                           <NA>
      32            <NA>             <NA>                           <NA>
      33            <NA>             <NA>                           <NA>
      34            <NA>             <NA>                           <NA>
      35            <NA>             <NA>                           <NA>
      36            <NA>             <NA>                           <NA>
      37            <NA>               RH                           <NA>
      38            <NA>             <NA>                           <NA>
      39            <NA>             <NA>                           <NA>
      40            <NA>             <NA>                           <NA>
      41            <NA>             <NA>                           <NA>
      42            <NA>             <NA>                           <NA>
      43            <NA>             <NA>                           <NA>
      44            <NA>             <NA>                           <NA>
      45            <NA>             <NA>                           <NA>
      46            <NA>             <NA>                           <NA>
      47            <NA>             <NA>                           <NA>
      48            <NA>             <NA>                           <NA>
      49            <NA>             <NA>                           <NA>
      50            <NA>             <NA>                           <NA>
      51            <NA>             <NA>                           <NA>
      52            <NA>             <NA>                           <NA>
      53            <NA>             <NA>                           <NA>
      54            <NA>             <NA>                           <NA>
      55            <NA>             <NA>                           <NA>
      56            <NA>             <NA>                           <NA>
      57            <NA>             <NA>                           <NA>
      58            <NA>             <NA>                           <NA>
      59            <NA>             <NA>                           <NA>
      60            <NA>             <NA>                           <NA>
      61            <NA>             <NA>                           <NA>
      62            <NA>             <NA>                           <NA>
      63            <NA>             <NA>                           <NA>
      64            <NA>             <NA>                           <NA>
      65            <NA>             <NA>                           <NA>
      66            <NA>             <NA>                           <NA>
      67            <NA>             <NA>                           <NA>
      68            <NA>             <NA>                           <NA>
         Matrix Group Name Matrix Ranking? Field Annotation Data Type
      2  matrix_group_name  matrix_ranking field_annotation skim_type
      3               <NA>            <NA>             <NA>      <NA>
      4               <NA>            <NA>             <NA> character
      5               <NA>            <NA>             <NA> character
      6               <NA>            <NA>             <NA>   numeric
      7               <NA>            <NA>             <NA>   numeric
      8               <NA>            <NA>             <NA> character
      9               <NA>            <NA>             <NA> character
      10              <NA>            <NA>             <NA> character
      11              <NA>            <NA>             <NA> character
      12              <NA>            <NA>             <NA>   numeric
      13              <NA>            <NA>             <NA>    factor
      14              <NA>            <NA>             <NA>    factor
      15              <NA>            <NA>             <NA>    factor
      16              <NA>            <NA>             <NA>   logical
      17              <NA>            <NA>             <NA>   logical
      18              <NA>            <NA>             <NA>   logical
      19              <NA>            <NA>             <NA>   logical
      20              <NA>            <NA>             <NA>   logical
      21              <NA>            <NA>             <NA>   logical
      22              <NA>            <NA>             <NA>   logical
      23              <NA>            <NA>             <NA>   logical
      24              <NA>            <NA>             <NA>   logical
      25              <NA>            <NA>             <NA>   logical
      26              <NA>            <NA>             <NA>   logical
      27              <NA>            <NA>             <NA>   logical
      28              <NA>            <NA>             <NA>   logical
      29              <NA>            <NA>             <NA>   logical
      30              <NA>            <NA>             <NA>   logical
      31              <NA>            <NA>             <NA>   logical
      32              <NA>            <NA>             <NA>   logical
      33              <NA>            <NA>             <NA>   logical
      34              <NA>            <NA>             <NA>   logical
      35              <NA>            <NA>             <NA> character
      36              <NA>            <NA>             <NA> character
      37              <NA>            <NA>             <NA>   numeric
      38              <NA>            <NA>             <NA>    factor
      39              <NA>            <NA>             <NA>      Date
      40              <NA>            <NA>             <NA>      Date
      41              <NA>            <NA>             <NA>      Date
      42              <NA>            <NA>             <NA>   POSIXct
      43              <NA>            <NA>             <NA>   POSIXct
      44              <NA>            <NA>             <NA>   POSIXct
      45              <NA>            <NA>             <NA>   POSIXct
      46              <NA>            <NA>             <NA>   POSIXct
      47              <NA>            <NA>             <NA>   POSIXct
      48              <NA>            <NA>             <NA> character
      49              <NA>            <NA>             <NA> character
      50              <NA>            <NA>             <NA> character
      51              <NA>            <NA>             <NA>  difftime
      52              <NA>            <NA>             <NA>  difftime
      53              <NA>            <NA>             <NA>  difftime
      54              <NA>            <NA>             <NA> character
      55              <NA>            <NA>             <NA>   logical
      56              <NA>            <NA>             <NA>   logical
      57              <NA>            <NA>             <NA>   logical
      58              <NA>            <NA>             <NA>   logical
      59              <NA>            <NA>             <NA>   logical
      60              <NA>            <NA>             <NA>    factor
      61              <NA>            <NA>             <NA>   logical
      62              <NA>            <NA>             <NA>   logical
      63              <NA>            <NA>             <NA>   logical
      64              <NA>            <NA>             <NA>   logical
      65              <NA>            <NA>             <NA>    factor
      66              <NA>            <NA>             <NA>   logical
      67              <NA>            <NA>             <NA>   logical
      68              <NA>            <NA>             <NA>   logical
         Count of Missing Values Percentage of Non-Missing Values
      2                n_missing                    complete_rate
      3                     <NA>                             <NA>
      4                        1                             0.75
      5                        1                             0.75
      6                        2                              0.5
      7                        2                              0.5
      8                        0                                1
      9                        0                                1
      10                       3                             0.25
      11                       3                             0.25
      12                       1                             0.75
      13                       2                              0.5
      14                       2                              0.5
      15                       4                                0
      16                       0                                1
      17                       0                                1
      18                       0                                1
      19                       0                                1
      20                       0                                1
      21                       0                                1
      22                       0                                1
      23                       0                                1
      24                       0                                1
      25                       0                                1
      26                       0                                1
      27                       0                                1
      28                       0                                1
      29                       0                                1
      30                       0                                1
      31                       0                                1
      32                       0                                1
      33                       3                             0.25
      34                       3                             0.25
      35                       3                             0.25
      36                       3                             0.25
      37                       3                             0.25
      38                       4                                0
      39                       3                             0.25
      40                       3                             0.25
      41                       3                             0.25
      42                       3                             0.25
      43                       3                             0.25
      44                       3                             0.25
      45                       3                             0.25
      46                       3                             0.25
      47                       3                             0.25
      48                       3                             0.25
      49                       3                             0.25
      50                       3                             0.25
      51                       3                             0.25
      52                       3                             0.25
      53                       3                             0.25
      54                       3                             0.25
      55                       4                                0
      56                       4                                0
      57                       4                                0
      58                       4                                0
      59                       2                              0.5
      60                       2                              0.5
      61                       0                                1
      62                       0                                1
      63                       0                                1
      64                       0                                1
      65                       0                                1
      66                       0                                1
      67                       0                                1
      68                       0                                1
         Minimum Length of Characters Maximum Length of Characters
      2                 character.min                character.max
      3                          <NA>                         <NA>
      4                             1                           11
      5                             1                           11
      6                          <NA>                         <NA>
      7                          <NA>                         <NA>
      8                             1                            1
      9                             1                            1
      10                            4                            4
      11                            5                            5
      12                         <NA>                         <NA>
      13                         <NA>                         <NA>
      14                         <NA>                         <NA>
      15                         <NA>                         <NA>
      16                         <NA>                         <NA>
      17                         <NA>                         <NA>
      18                         <NA>                         <NA>
      19                         <NA>                         <NA>
      20                         <NA>                         <NA>
      21                         <NA>                         <NA>
      22                         <NA>                         <NA>
      23                         <NA>                         <NA>
      24                         <NA>                         <NA>
      25                         <NA>                         <NA>
      26                         <NA>                         <NA>
      27                         <NA>                         <NA>
      28                         <NA>                         <NA>
      29                         <NA>                         <NA>
      30                         <NA>                         <NA>
      31                         <NA>                         <NA>
      32                         <NA>                         <NA>
      33                         <NA>                         <NA>
      34                         <NA>                         <NA>
      35                           29                           29
      36                           25                           25
      37                         <NA>                         <NA>
      38                         <NA>                         <NA>
      39                         <NA>                         <NA>
      40                         <NA>                         <NA>
      41                         <NA>                         <NA>
      42                         <NA>                         <NA>
      43                         <NA>                         <NA>
      44                         <NA>                         <NA>
      45                         <NA>                         <NA>
      46                         <NA>                         <NA>
      47                         <NA>                         <NA>
      48                            8                            8
      49                           14                           14
      50                           11                           11
      51                         <NA>                         <NA>
      52                         <NA>                         <NA>
      53                         <NA>                         <NA>
      54                            5                            5
      55                         <NA>                         <NA>
      56                         <NA>                         <NA>
      57                         <NA>                         <NA>
      58                         <NA>                         <NA>
      59                         <NA>                         <NA>
      60                         <NA>                         <NA>
      61                         <NA>                         <NA>
      62                         <NA>                         <NA>
      63                         <NA>                         <NA>
      64                         <NA>                         <NA>
      65                         <NA>                         <NA>
      66                         <NA>                         <NA>
      67                         <NA>                         <NA>
      68                         <NA>                         <NA>
         Count of Empty Characters Count of Unique Characters
      2            character.empty         character.n_unique
      3                       <NA>                       <NA>
      4                          0                          3
      5                          0                          3
      6                       <NA>                       <NA>
      7                       <NA>                       <NA>
      8                          0                          4
      9                          0                          4
      10                         0                          1
      11                         0                          1
      12                      <NA>                       <NA>
      13                      <NA>                       <NA>
      14                      <NA>                       <NA>
      15                      <NA>                       <NA>
      16                      <NA>                       <NA>
      17                      <NA>                       <NA>
      18                      <NA>                       <NA>
      19                      <NA>                       <NA>
      20                      <NA>                       <NA>
      21                      <NA>                       <NA>
      22                      <NA>                       <NA>
      23                      <NA>                       <NA>
      24                      <NA>                       <NA>
      25                      <NA>                       <NA>
      26                      <NA>                       <NA>
      27                      <NA>                       <NA>
      28                      <NA>                       <NA>
      29                      <NA>                       <NA>
      30                      <NA>                       <NA>
      31                      <NA>                       <NA>
      32                      <NA>                       <NA>
      33                      <NA>                       <NA>
      34                      <NA>                       <NA>
      35                         0                          1
      36                         0                          1
      37                      <NA>                       <NA>
      38                      <NA>                       <NA>
      39                      <NA>                       <NA>
      40                      <NA>                       <NA>
      41                      <NA>                       <NA>
      42                      <NA>                       <NA>
      43                      <NA>                       <NA>
      44                      <NA>                       <NA>
      45                      <NA>                       <NA>
      46                      <NA>                       <NA>
      47                      <NA>                       <NA>
      48                         0                          1
      49                         0                          1
      50                         0                          1
      51                      <NA>                       <NA>
      52                      <NA>                       <NA>
      53                      <NA>                       <NA>
      54                         0                          1
      55                      <NA>                       <NA>
      56                      <NA>                       <NA>
      57                      <NA>                       <NA>
      58                      <NA>                       <NA>
      59                      <NA>                       <NA>
      60                      <NA>                       <NA>
      61                      <NA>                       <NA>
      62                      <NA>                       <NA>
      63                      <NA>                       <NA>
      64                      <NA>                       <NA>
      65                      <NA>                       <NA>
      66                      <NA>                       <NA>
      67                      <NA>                       <NA>
      68                      <NA>                       <NA>
         Count of Whitespaces in Characters Mean of Numeric Values
      2                character.whitespace           numeric.mean
      3                                <NA>                   <NA>
      4                                   0                   <NA>
      5                                   0                   <NA>
      6                                <NA>                      4
      7                                <NA>                      5
      8                                   0                   <NA>
      9                                   0                   <NA>
      10                                  0                   <NA>
      11                                  0                   <NA>
      12                               <NA>                      2
      13                               <NA>                   <NA>
      14                               <NA>                   <NA>
      15                               <NA>                   <NA>
      16                               <NA>                   <NA>
      17                               <NA>                   <NA>
      18                               <NA>                   <NA>
      19                               <NA>                   <NA>
      20                               <NA>                   <NA>
      21                               <NA>                   <NA>
      22                               <NA>                   <NA>
      23                               <NA>                   <NA>
      24                               <NA>                   <NA>
      25                               <NA>                   <NA>
      26                               <NA>                   <NA>
      27                               <NA>                   <NA>
      28                               <NA>                   <NA>
      29                               <NA>                   <NA>
      30                               <NA>                   <NA>
      31                               <NA>                   <NA>
      32                               <NA>                   <NA>
      33                               <NA>                   <NA>
      34                               <NA>                   <NA>
      35                                  0                   <NA>
      36                                  0                   <NA>
      37                               <NA>                     73
      38                               <NA>                   <NA>
      39                               <NA>                   <NA>
      40                               <NA>                   <NA>
      41                               <NA>                   <NA>
      42                               <NA>                   <NA>
      43                               <NA>                   <NA>
      44                               <NA>                   <NA>
      45                               <NA>                   <NA>
      46                               <NA>                   <NA>
      47                               <NA>                   <NA>
      48                                  0                   <NA>
      49                                  0                   <NA>
      50                                  0                   <NA>
      51                               <NA>                   <NA>
      52                               <NA>                   <NA>
      53                               <NA>                   <NA>
      54                                  0                   <NA>
      55                               <NA>                   <NA>
      56                               <NA>                   <NA>
      57                               <NA>                   <NA>
      58                               <NA>                   <NA>
      59                               <NA>                   <NA>
      60                               <NA>                   <NA>
      61                               <NA>                   <NA>
      62                               <NA>                   <NA>
      63                               <NA>                   <NA>
      64                               <NA>                   <NA>
      65                               <NA>                   <NA>
      66                               <NA>                   <NA>
      67                               <NA>                   <NA>
      68                               <NA>                   <NA>
         Standard Deviation of Numeric Values 0th Percentile of Numeric Values
      2                            numeric.sd                       numeric.p0
      3                                  <NA>                             <NA>
      4                                  <NA>                             <NA>
      5                                  <NA>                             <NA>
      6                       1.4142135623731                                3
      7                       1.4142135623731                                4
      8                                  <NA>                             <NA>
      9                                  <NA>                             <NA>
      10                                 <NA>                             <NA>
      11                                 <NA>                             <NA>
      12                                    0                                2
      13                                 <NA>                             <NA>
      14                                 <NA>                             <NA>
      15                                 <NA>                             <NA>
      16                                 <NA>                             <NA>
      17                                 <NA>                             <NA>
      18                                 <NA>                             <NA>
      19                                 <NA>                             <NA>
      20                                 <NA>                             <NA>
      21                                 <NA>                             <NA>
      22                                 <NA>                             <NA>
      23                                 <NA>                             <NA>
      24                                 <NA>                             <NA>
      25                                 <NA>                             <NA>
      26                                 <NA>                             <NA>
      27                                 <NA>                             <NA>
      28                                 <NA>                             <NA>
      29                                 <NA>                             <NA>
      30                                 <NA>                             <NA>
      31                                 <NA>                             <NA>
      32                                 <NA>                             <NA>
      33                                 <NA>                             <NA>
      34                                 <NA>                             <NA>
      35                                 <NA>                             <NA>
      36                                 <NA>                             <NA>
      37                                 <NA>                               73
      38                                 <NA>                             <NA>
      39                                 <NA>                             <NA>
      40                                 <NA>                             <NA>
      41                                 <NA>                             <NA>
      42                                 <NA>                             <NA>
      43                                 <NA>                             <NA>
      44                                 <NA>                             <NA>
      45                                 <NA>                             <NA>
      46                                 <NA>                             <NA>
      47                                 <NA>                             <NA>
      48                                 <NA>                             <NA>
      49                                 <NA>                             <NA>
      50                                 <NA>                             <NA>
      51                                 <NA>                             <NA>
      52                                 <NA>                             <NA>
      53                                 <NA>                             <NA>
      54                                 <NA>                             <NA>
      55                                 <NA>                             <NA>
      56                                 <NA>                             <NA>
      57                                 <NA>                             <NA>
      58                                 <NA>                             <NA>
      59                                 <NA>                             <NA>
      60                                 <NA>                             <NA>
      61                                 <NA>                             <NA>
      62                                 <NA>                             <NA>
      63                                 <NA>                             <NA>
      64                                 <NA>                             <NA>
      65                                 <NA>                             <NA>
      66                                 <NA>                             <NA>
      67                                 <NA>                             <NA>
      68                                 <NA>                             <NA>
         25th Percentile of Numeric Values 50th Percentile of Numeric Values
      2                        numeric.p25                       numeric.p50
      3                               <NA>                              <NA>
      4                               <NA>                              <NA>
      5                               <NA>                              <NA>
      6                                3.5                                 4
      7                                4.5                                 5
      8                               <NA>                              <NA>
      9                               <NA>                              <NA>
      10                              <NA>                              <NA>
      11                              <NA>                              <NA>
      12                                 2                                 2
      13                              <NA>                              <NA>
      14                              <NA>                              <NA>
      15                              <NA>                              <NA>
      16                              <NA>                              <NA>
      17                              <NA>                              <NA>
      18                              <NA>                              <NA>
      19                              <NA>                              <NA>
      20                              <NA>                              <NA>
      21                              <NA>                              <NA>
      22                              <NA>                              <NA>
      23                              <NA>                              <NA>
      24                              <NA>                              <NA>
      25                              <NA>                              <NA>
      26                              <NA>                              <NA>
      27                              <NA>                              <NA>
      28                              <NA>                              <NA>
      29                              <NA>                              <NA>
      30                              <NA>                              <NA>
      31                              <NA>                              <NA>
      32                              <NA>                              <NA>
      33                              <NA>                              <NA>
      34                              <NA>                              <NA>
      35                              <NA>                              <NA>
      36                              <NA>                              <NA>
      37                                73                                73
      38                              <NA>                              <NA>
      39                              <NA>                              <NA>
      40                              <NA>                              <NA>
      41                              <NA>                              <NA>
      42                              <NA>                              <NA>
      43                              <NA>                              <NA>
      44                              <NA>                              <NA>
      45                              <NA>                              <NA>
      46                              <NA>                              <NA>
      47                              <NA>                              <NA>
      48                              <NA>                              <NA>
      49                              <NA>                              <NA>
      50                              <NA>                              <NA>
      51                              <NA>                              <NA>
      52                              <NA>                              <NA>
      53                              <NA>                              <NA>
      54                              <NA>                              <NA>
      55                              <NA>                              <NA>
      56                              <NA>                              <NA>
      57                              <NA>                              <NA>
      58                              <NA>                              <NA>
      59                              <NA>                              <NA>
      60                              <NA>                              <NA>
      61                              <NA>                              <NA>
      62                              <NA>                              <NA>
      63                              <NA>                              <NA>
      64                              <NA>                              <NA>
      65                              <NA>                              <NA>
      66                              <NA>                              <NA>
      67                              <NA>                              <NA>
      68                              <NA>                              <NA>
         75th Percentile of Numeric Values 100th Percentile of Numeric Values
      2                        numeric.p75                       numeric.p100
      3                               <NA>                               <NA>
      4                               <NA>                               <NA>
      5                               <NA>                               <NA>
      6                                4.5                                  5
      7                                5.5                                  6
      8                               <NA>                               <NA>
      9                               <NA>                               <NA>
      10                              <NA>                               <NA>
      11                              <NA>                               <NA>
      12                                 2                                  2
      13                              <NA>                               <NA>
      14                              <NA>                               <NA>
      15                              <NA>                               <NA>
      16                              <NA>                               <NA>
      17                              <NA>                               <NA>
      18                              <NA>                               <NA>
      19                              <NA>                               <NA>
      20                              <NA>                               <NA>
      21                              <NA>                               <NA>
      22                              <NA>                               <NA>
      23                              <NA>                               <NA>
      24                              <NA>                               <NA>
      25                              <NA>                               <NA>
      26                              <NA>                               <NA>
      27                              <NA>                               <NA>
      28                              <NA>                               <NA>
      29                              <NA>                               <NA>
      30                              <NA>                               <NA>
      31                              <NA>                               <NA>
      32                              <NA>                               <NA>
      33                              <NA>                               <NA>
      34                              <NA>                               <NA>
      35                              <NA>                               <NA>
      36                              <NA>                               <NA>
      37                                73                                 73
      38                              <NA>                               <NA>
      39                              <NA>                               <NA>
      40                              <NA>                               <NA>
      41                              <NA>                               <NA>
      42                              <NA>                               <NA>
      43                              <NA>                               <NA>
      44                              <NA>                               <NA>
      45                              <NA>                               <NA>
      46                              <NA>                               <NA>
      47                              <NA>                               <NA>
      48                              <NA>                               <NA>
      49                              <NA>                               <NA>
      50                              <NA>                               <NA>
      51                              <NA>                               <NA>
      52                              <NA>                               <NA>
      53                              <NA>                               <NA>
      54                              <NA>                               <NA>
      55                              <NA>                               <NA>
      56                              <NA>                               <NA>
      57                              <NA>                               <NA>
      58                              <NA>                               <NA>
      59                              <NA>                               <NA>
      60                              <NA>                               <NA>
      61                              <NA>                               <NA>
      62                              <NA>                               <NA>
      63                              <NA>                               <NA>
      64                              <NA>                               <NA>
      65                              <NA>                               <NA>
      66                              <NA>                               <NA>
      67                              <NA>                               <NA>
      68                              <NA>                               <NA>
         Histogram of Numeric Values Order of Factor Levels
      2                 numeric.hist                     NA
      3                         <NA>                     NA
      4                         <NA>                     NA
      5                         <NA>                     NA
      6                        ▇▁▁▁▇                     NA
      7                        ▇▁▁▁▇                     NA
      8                         <NA>                     NA
      9                         <NA>                     NA
      10                        <NA>                     NA
      11                        <NA>                     NA
      12                       ▁▁▇▁▁                     NA
      13                        <NA>                  FALSE
      14                        <NA>                  FALSE
      15                        <NA>                  FALSE
      16                        <NA>                     NA
      17                        <NA>                     NA
      18                        <NA>                     NA
      19                        <NA>                     NA
      20                        <NA>                     NA
      21                        <NA>                     NA
      22                        <NA>                     NA
      23                        <NA>                     NA
      24                        <NA>                     NA
      25                        <NA>                     NA
      26                        <NA>                     NA
      27                        <NA>                     NA
      28                        <NA>                     NA
      29                        <NA>                     NA
      30                        <NA>                     NA
      31                        <NA>                     NA
      32                        <NA>                     NA
      33                        <NA>                     NA
      34                        <NA>                     NA
      35                        <NA>                     NA
      36                        <NA>                     NA
      37                       ▁▁▇▁▁                     NA
      38                        <NA>                  FALSE
      39                        <NA>                     NA
      40                        <NA>                     NA
      41                        <NA>                     NA
      42                        <NA>                     NA
      43                        <NA>                     NA
      44                        <NA>                     NA
      45                        <NA>                     NA
      46                        <NA>                     NA
      47                        <NA>                     NA
      48                        <NA>                     NA
      49                        <NA>                     NA
      50                        <NA>                     NA
      51                        <NA>                     NA
      52                        <NA>                     NA
      53                        <NA>                     NA
      54                        <NA>                     NA
      55                        <NA>                     NA
      56                        <NA>                     NA
      57                        <NA>                     NA
      58                        <NA>                     NA
      59                        <NA>                     NA
      60                        <NA>                  FALSE
      61                        <NA>                     NA
      62                        <NA>                     NA
      63                        <NA>                     NA
      64                        <NA>                     NA
      65                        <NA>                  FALSE
      66                        <NA>                     NA
      67                        <NA>                     NA
      68                        <NA>                     NA
         Count of Unique Factor Levels Most Frequent Factor Levels
      2                factor.n_unique           factor.top_counts
      3                           <NA>                        <NA>
      4                           <NA>                        <NA>
      5                           <NA>                        <NA>
      6                           <NA>                        <NA>
      7                           <NA>                        <NA>
      8                           <NA>                        <NA>
      9                           <NA>                        <NA>
      10                          <NA>                        <NA>
      11                          <NA>                        <NA>
      12                          <NA>                        <NA>
      13                             2      one: 1, thr: 1, two: 0
      14                             2            B: 1, C: 1, A: 0
      15                             0                  A: 0, C: 0
      16                          <NA>                        <NA>
      17                          <NA>                        <NA>
      18                          <NA>                        <NA>
      19                          <NA>                        <NA>
      20                          <NA>                        <NA>
      21                          <NA>                        <NA>
      22                          <NA>                        <NA>
      23                          <NA>                        <NA>
      24                          <NA>                        <NA>
      25                          <NA>                        <NA>
      26                          <NA>                        <NA>
      27                          <NA>                        <NA>
      28                          <NA>                        <NA>
      29                          <NA>                        <NA>
      30                          <NA>                        <NA>
      31                          <NA>                        <NA>
      32                          <NA>                        <NA>
      33                          <NA>                        <NA>
      34                          <NA>                        <NA>
      35                          <NA>                        <NA>
      36                          <NA>                        <NA>
      37                          <NA>                        <NA>
      38                             0                          : 
      39                          <NA>                        <NA>
      40                          <NA>                        <NA>
      41                          <NA>                        <NA>
      42                          <NA>                        <NA>
      43                          <NA>                        <NA>
      44                          <NA>                        <NA>
      45                          <NA>                        <NA>
      46                          <NA>                        <NA>
      47                          <NA>                        <NA>
      48                          <NA>                        <NA>
      49                          <NA>                        <NA>
      50                          <NA>                        <NA>
      51                          <NA>                        <NA>
      52                          <NA>                        <NA>
      53                          <NA>                        <NA>
      54                          <NA>                        <NA>
      55                          <NA>                        <NA>
      56                          <NA>                        <NA>
      57                          <NA>                        <NA>
      58                          <NA>                        <NA>
      59                          <NA>                        <NA>
      60                             2      Cho: 1, Cho: 1, Cho: 0
      61                          <NA>                        <NA>
      62                          <NA>                        <NA>
      63                          <NA>                        <NA>
      64                          <NA>                        <NA>
      65                             2      Cho: 2, Cho: 1, Cho: 0
      66                          <NA>                        <NA>
      67                          <NA>                        <NA>
      68                          <NA>                        <NA>
         Mean of Logical Values Count of Logical Values Earliest Date Latest Date
      2            logical.mean           logical.count      Date.min    Date.max
      3                    <NA>                    <NA>          <NA>        <NA>
      4                    <NA>                    <NA>          <NA>        <NA>
      5                    <NA>                    <NA>          <NA>        <NA>
      6                    <NA>                    <NA>          <NA>        <NA>
      7                    <NA>                    <NA>          <NA>        <NA>
      8                    <NA>                    <NA>          <NA>        <NA>
      9                    <NA>                    <NA>          <NA>        <NA>
      10                   <NA>                    <NA>          <NA>        <NA>
      11                   <NA>                    <NA>          <NA>        <NA>
      12                   <NA>                    <NA>          <NA>        <NA>
      13                   <NA>                    <NA>          <NA>        <NA>
      14                   <NA>                    <NA>          <NA>        <NA>
      15                   <NA>                    <NA>          <NA>        <NA>
      16                    0.5          FAL: 2, TRU: 2          <NA>        <NA>
      17                      0                  FAL: 4          <NA>        <NA>
      18                      0                  FAL: 4          <NA>        <NA>
      19                    0.5          FAL: 2, TRU: 2          <NA>        <NA>
      20                      0                  FAL: 4          <NA>        <NA>
      21                      0                  FAL: 4          <NA>        <NA>
      22                   0.25          FAL: 3, TRU: 1          <NA>        <NA>
      23                   0.25          FAL: 3, TRU: 1          <NA>        <NA>
      24                      0                  FAL: 4          <NA>        <NA>
      25                   0.25          FAL: 3, TRU: 1          <NA>        <NA>
      26                   0.25          FAL: 3, TRU: 1          <NA>        <NA>
      27                      0                  FAL: 4          <NA>        <NA>
      28                      0                  FAL: 4          <NA>        <NA>
      29                   0.25          FAL: 3, TRU: 1          <NA>        <NA>
      30                      0                  FAL: 4          <NA>        <NA>
      31                   0.25          FAL: 3, TRU: 1          <NA>        <NA>
      32                      0                  FAL: 4          <NA>        <NA>
      33                      1                  TRU: 1          <NA>        <NA>
      34                      0                  FAL: 1          <NA>        <NA>
      35                   <NA>                    <NA>          <NA>        <NA>
      36                   <NA>                    <NA>          <NA>        <NA>
      37                   <NA>                    <NA>          <NA>        <NA>
      38                   <NA>                    <NA>          <NA>        <NA>
      39                   <NA>                    <NA>    2022-08-03  2022-08-03
      40                   <NA>                    <NA>    2022-08-03  2022-08-03
      41                   <NA>                    <NA>    2022-08-03  2022-08-03
      42                   <NA>                    <NA>          <NA>        <NA>
      43                   <NA>                    <NA>          <NA>        <NA>
      44                   <NA>                    <NA>          <NA>        <NA>
      45                   <NA>                    <NA>          <NA>        <NA>
      46                   <NA>                    <NA>          <NA>        <NA>
      47                   <NA>                    <NA>          <NA>        <NA>
      48                   <NA>                    <NA>          <NA>        <NA>
      49                   <NA>                    <NA>          <NA>        <NA>
      50                   <NA>                    <NA>          <NA>        <NA>
      51                   <NA>                    <NA>          <NA>        <NA>
      52                   <NA>                    <NA>          <NA>        <NA>
      53                   <NA>                    <NA>          <NA>        <NA>
      54                   <NA>                    <NA>          <NA>        <NA>
      55                #VALUE!                      :           <NA>        <NA>
      56                #VALUE!                      :           <NA>        <NA>
      57                #VALUE!                      :           <NA>        <NA>
      58                #VALUE!                      :           <NA>        <NA>
      59                    0.5          FAL: 1, TRU: 1          <NA>        <NA>
      60                   <NA>                    <NA>          <NA>        <NA>
      61                      0                  FAL: 4          <NA>        <NA>
      62                    0.5          FAL: 2, TRU: 2          <NA>        <NA>
      63                    0.5          FAL: 2, TRU: 2          <NA>        <NA>
      64      0.666666666666667          TRU: 2, FAL: 1          <NA>        <NA>
      65                   <NA>                    <NA>          <NA>        <NA>
      66      0.666666666666667          TRU: 2, FAL: 1          <NA>        <NA>
      67      0.333333333333333          FAL: 2, TRU: 1          <NA>        <NA>
      68      0.333333333333333          FAL: 2, TRU: 1          <NA>        <NA>
         Median Date Count of Unique Dates Earliest POSIXct Value
      2  Date.median         Date.n_unique            POSIXct.min
      3         <NA>                  <NA>                   <NA>
      4         <NA>                  <NA>                   <NA>
      5         <NA>                  <NA>                   <NA>
      6         <NA>                  <NA>                   <NA>
      7         <NA>                  <NA>                   <NA>
      8         <NA>                  <NA>                   <NA>
      9         <NA>                  <NA>                   <NA>
      10        <NA>                  <NA>                   <NA>
      11        <NA>                  <NA>                   <NA>
      12        <NA>                  <NA>                   <NA>
      13        <NA>                  <NA>                   <NA>
      14        <NA>                  <NA>                   <NA>
      15        <NA>                  <NA>                   <NA>
      16        <NA>                  <NA>                   <NA>
      17        <NA>                  <NA>                   <NA>
      18        <NA>                  <NA>                   <NA>
      19        <NA>                  <NA>                   <NA>
      20        <NA>                  <NA>                   <NA>
      21        <NA>                  <NA>                   <NA>
      22        <NA>                  <NA>                   <NA>
      23        <NA>                  <NA>                   <NA>
      24        <NA>                  <NA>                   <NA>
      25        <NA>                  <NA>                   <NA>
      26        <NA>                  <NA>                   <NA>
      27        <NA>                  <NA>                   <NA>
      28        <NA>                  <NA>                   <NA>
      29        <NA>                  <NA>                   <NA>
      30        <NA>                  <NA>                   <NA>
      31        <NA>                  <NA>                   <NA>
      32        <NA>                  <NA>                   <NA>
      33        <NA>                  <NA>                   <NA>
      34        <NA>                  <NA>                   <NA>
      35        <NA>                  <NA>                   <NA>
      36        <NA>                  <NA>                   <NA>
      37        <NA>                  <NA>                   <NA>
      38        <NA>                  <NA>                   <NA>
      39  2022-08-03                     1                   <NA>
      40  2022-08-03                     1                   <NA>
      41  2022-08-03                     1                   <NA>
      42        <NA>                  <NA>    2022-08-03 15:15:00
      43        <NA>                  <NA>    2022-08-03 15:15:00
      44        <NA>                  <NA>    2022-08-03 15:15:00
      45        <NA>                  <NA>    2022-08-03 15:15:04
      46        <NA>                  <NA>    2022-08-03 15:15:04
      47        <NA>                  <NA>    2022-08-03 15:15:05
      48        <NA>                  <NA>                   <NA>
      49        <NA>                  <NA>                   <NA>
      50        <NA>                  <NA>                   <NA>
      51        <NA>                  <NA>                   <NA>
      52        <NA>                  <NA>                   <NA>
      53        <NA>                  <NA>                   <NA>
      54        <NA>                  <NA>                   <NA>
      55        <NA>                  <NA>                   <NA>
      56        <NA>                  <NA>                   <NA>
      57        <NA>                  <NA>                   <NA>
      58        <NA>                  <NA>                   <NA>
      59        <NA>                  <NA>                   <NA>
      60        <NA>                  <NA>                   <NA>
      61        <NA>                  <NA>                   <NA>
      62        <NA>                  <NA>                   <NA>
      63        <NA>                  <NA>                   <NA>
      64        <NA>                  <NA>                   <NA>
      65        <NA>                  <NA>                   <NA>
      66        <NA>                  <NA>                   <NA>
      67        <NA>                  <NA>                   <NA>
      68        <NA>                  <NA>                   <NA>
         Latest POSIXct Value Median POSIXct Value Count of Unique POSIXct Values
      2           POSIXct.max       POSIXct.median               POSIXct.n_unique
      3                  <NA>                 <NA>                           <NA>
      4                  <NA>                 <NA>                           <NA>
      5                  <NA>                 <NA>                           <NA>
      6                  <NA>                 <NA>                           <NA>
      7                  <NA>                 <NA>                           <NA>
      8                  <NA>                 <NA>                           <NA>
      9                  <NA>                 <NA>                           <NA>
      10                 <NA>                 <NA>                           <NA>
      11                 <NA>                 <NA>                           <NA>
      12                 <NA>                 <NA>                           <NA>
      13                 <NA>                 <NA>                           <NA>
      14                 <NA>                 <NA>                           <NA>
      15                 <NA>                 <NA>                           <NA>
      16                 <NA>                 <NA>                           <NA>
      17                 <NA>                 <NA>                           <NA>
      18                 <NA>                 <NA>                           <NA>
      19                 <NA>                 <NA>                           <NA>
      20                 <NA>                 <NA>                           <NA>
      21                 <NA>                 <NA>                           <NA>
      22                 <NA>                 <NA>                           <NA>
      23                 <NA>                 <NA>                           <NA>
      24                 <NA>                 <NA>                           <NA>
      25                 <NA>                 <NA>                           <NA>
      26                 <NA>                 <NA>                           <NA>
      27                 <NA>                 <NA>                           <NA>
      28                 <NA>                 <NA>                           <NA>
      29                 <NA>                 <NA>                           <NA>
      30                 <NA>                 <NA>                           <NA>
      31                 <NA>                 <NA>                           <NA>
      32                 <NA>                 <NA>                           <NA>
      33                 <NA>                 <NA>                           <NA>
      34                 <NA>                 <NA>                           <NA>
      35                 <NA>                 <NA>                           <NA>
      36                 <NA>                 <NA>                           <NA>
      37                 <NA>                 <NA>                           <NA>
      38                 <NA>                 <NA>                           <NA>
      39                 <NA>                 <NA>                           <NA>
      40                 <NA>                 <NA>                           <NA>
      41                 <NA>                 <NA>                           <NA>
      42  2022-08-03 15:15:00  2022-08-03 15:15:00                              1
      43  2022-08-03 15:15:00  2022-08-03 15:15:00                              1
      44  2022-08-03 15:15:00  2022-08-03 15:15:00                              1
      45  2022-08-03 15:15:04  2022-08-03 15:15:04                              1
      46  2022-08-03 15:15:04  2022-08-03 15:15:04                              1
      47  2022-08-03 15:15:05  2022-08-03 15:15:05                              1
      48                 <NA>                 <NA>                           <NA>
      49                 <NA>                 <NA>                           <NA>
      50                 <NA>                 <NA>                           <NA>
      51                 <NA>                 <NA>                           <NA>
      52                 <NA>                 <NA>                           <NA>
      53                 <NA>                 <NA>                           <NA>
      54                 <NA>                 <NA>                           <NA>
      55                 <NA>                 <NA>                           <NA>
      56                 <NA>                 <NA>                           <NA>
      57                 <NA>                 <NA>                           <NA>
      58                 <NA>                 <NA>                           <NA>
      59                 <NA>                 <NA>                           <NA>
      60                 <NA>                 <NA>                           <NA>
      61                 <NA>                 <NA>                           <NA>
      62                 <NA>                 <NA>                           <NA>
      63                 <NA>                 <NA>                           <NA>
      64                 <NA>                 <NA>                           <NA>
      65                 <NA>                 <NA>                           <NA>
      66                 <NA>                 <NA>                           <NA>
      67                 <NA>                 <NA>                           <NA>
      68                 <NA>                 <NA>                           <NA>
         Minimum Difference in Time Maximum Difference in Time
      2                difftime.min               difftime.max
      3                        <NA>                       <NA>
      4                        <NA>                       <NA>
      5                        <NA>                       <NA>
      6                        <NA>                       <NA>
      7                        <NA>                       <NA>
      8                        <NA>                       <NA>
      9                        <NA>                       <NA>
      10                       <NA>                       <NA>
      11                       <NA>                       <NA>
      12                       <NA>                       <NA>
      13                       <NA>                       <NA>
      14                       <NA>                       <NA>
      15                       <NA>                       <NA>
      16                       <NA>                       <NA>
      17                       <NA>                       <NA>
      18                       <NA>                       <NA>
      19                       <NA>                       <NA>
      20                       <NA>                       <NA>
      21                       <NA>                       <NA>
      22                       <NA>                       <NA>
      23                       <NA>                       <NA>
      24                       <NA>                       <NA>
      25                       <NA>                       <NA>
      26                       <NA>                       <NA>
      27                       <NA>                       <NA>
      28                       <NA>                       <NA>
      29                       <NA>                       <NA>
      30                       <NA>                       <NA>
      31                       <NA>                       <NA>
      32                       <NA>                       <NA>
      33                       <NA>                       <NA>
      34                       <NA>                       <NA>
      35                       <NA>                       <NA>
      36                       <NA>                       <NA>
      37                       <NA>                       <NA>
      38                       <NA>                       <NA>
      39                       <NA>                       <NA>
      40                       <NA>                       <NA>
      41                       <NA>                       <NA>
      42                       <NA>                       <NA>
      43                       <NA>                       <NA>
      44                       <NA>                       <NA>
      45                       <NA>                       <NA>
      46                       <NA>                       <NA>
      47                       <NA>                       <NA>
      48                       <NA>                       <NA>
      49                       <NA>                       <NA>
      50                       <NA>                       <NA>
      51                      54949                      54949
      52                      54900                      54900
      53                      54000                      54000
      54                       <NA>                       <NA>
      55                       <NA>                       <NA>
      56                       <NA>                       <NA>
      57                       <NA>                       <NA>
      58                       <NA>                       <NA>
      59                       <NA>                       <NA>
      60                       <NA>                       <NA>
      61                       <NA>                       <NA>
      62                       <NA>                       <NA>
      63                       <NA>                       <NA>
      64                       <NA>                       <NA>
      65                       <NA>                       <NA>
      66                       <NA>                       <NA>
      67                       <NA>                       <NA>
      68                       <NA>                       <NA>
         Median Difference in Time Count of Unique Time Differences
      2            difftime.median                difftime.n_unique
      3                       <NA>                             <NA>
      4                       <NA>                             <NA>
      5                       <NA>                             <NA>
      6                       <NA>                             <NA>
      7                       <NA>                             <NA>
      8                       <NA>                             <NA>
      9                       <NA>                             <NA>
      10                      <NA>                             <NA>
      11                      <NA>                             <NA>
      12                      <NA>                             <NA>
      13                      <NA>                             <NA>
      14                      <NA>                             <NA>
      15                      <NA>                             <NA>
      16                      <NA>                             <NA>
      17                      <NA>                             <NA>
      18                      <NA>                             <NA>
      19                      <NA>                             <NA>
      20                      <NA>                             <NA>
      21                      <NA>                             <NA>
      22                      <NA>                             <NA>
      23                      <NA>                             <NA>
      24                      <NA>                             <NA>
      25                      <NA>                             <NA>
      26                      <NA>                             <NA>
      27                      <NA>                             <NA>
      28                      <NA>                             <NA>
      29                      <NA>                             <NA>
      30                      <NA>                             <NA>
      31                      <NA>                             <NA>
      32                      <NA>                             <NA>
      33                      <NA>                             <NA>
      34                      <NA>                             <NA>
      35                      <NA>                             <NA>
      36                      <NA>                             <NA>
      37                      <NA>                             <NA>
      38                      <NA>                             <NA>
      39                      <NA>                             <NA>
      40                      <NA>                             <NA>
      41                      <NA>                             <NA>
      42                      <NA>                             <NA>
      43                      <NA>                             <NA>
      44                      <NA>                             <NA>
      45                      <NA>                             <NA>
      46                      <NA>                             <NA>
      47                      <NA>                             <NA>
      48                      <NA>                             <NA>
      49                      <NA>                             <NA>
      50                      <NA>                             <NA>
      51                  15:15:49                                1
      52                  15:15:00                                1
      53                  15:00:00                                1
      54                      <NA>                             <NA>
      55                      <NA>                             <NA>
      56                      <NA>                             <NA>
      57                      <NA>                             <NA>
      58                      <NA>                             <NA>
      59                      <NA>                             <NA>
      60                      <NA>                             <NA>
      61                      <NA>                             <NA>
      62                      <NA>                             <NA>
      63                      <NA>                             <NA>
      64                      <NA>                             <NA>
      65                      <NA>                             <NA>
      66                      <NA>                             <NA>
      67                      <NA>                             <NA>
      68                      <NA>                             <NA>
      
      
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
      [[5]][[1]]
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
      
      [[5]][[2]]
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
      
      [[5]][[3]]
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
      
      [[5]][[4]]
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
      
      [[5]][[5]]
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
      
      [[5]][[6]]
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
      
      [[5]][[7]]
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
      
      [[5]][[8]]
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
      
      [[5]][[9]]
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
      
      [[5]][[10]]
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
      
      [[5]][[11]]
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
      
      
      [[6]]
      [[6]][[1]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table1.xml\"/>"
      
      [[6]][[2]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table2.xml\"/>"
      
      [[6]][[3]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table3.xml\"/>"
      
      [[6]][[4]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table4.xml\"/>"
      
      [[6]][[5]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table5.xml\"/>"
      
      [[6]][[6]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table6.xml\"/>"
      
      [[6]][[7]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table7.xml\"/>"
      
      [[6]][[8]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table8.xml\"/>"
      
      [[6]][[9]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table9.xml\"/>"
      
      [[6]][[10]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table10.xml\"/>"
      
      [[6]][[11]]
      [1] "<Relationship Id=\"rId1\" Type=\"http://schemas.openxmlformats.org/officeDocument/2006/relationships/table\" Target=\"../tables/table11.xml\"/>"
      
      
      [[7]]
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
      
      [[8]]
       [1]  1  2  3  4  5  6  7  8  9 10 11
      
      [[9]]
       [1] "Table of Contents"           "Nonrepeated"                
       [3] "Nonrepeated2"                "Repeated"                   
       [5] "Data Field Types"            "Text Input Validation Types"
       [7] "API No Access"               "API No Access 2"            
       [9] "Survey"                      "Repeat Survey"              
      [11] "REDCap Metadata"            
      

