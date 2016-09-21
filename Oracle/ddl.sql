CREATE TABLE administrator_dump( refno       NUMBER( 10 )
                               , title       VARCHAR2( 5 )
                               , forename    VARCHAR2( 50 )
                               , surname     VARCHAR2( 50 )
                               , ppsn        VARCHAR2( 15 )
                               , dob         DATE
                               , gender      VARCHAR2( 1 )
                               , mstat       VARCHAR2( 1 )
                               , status      VARCHAR2( 2 )
                               , retire_dt   DATE
                               , scheme_no   NUMBER( 10 )
                               , scheme_nm   VARCHAR2( 50 )
                               , address_1   VARCHAR2( 50 )
                               , address_2   VARCHAR2( 50 )
                               , address_3   VARCHAR2( 50 )
                               , address_4   VARCHAR2( 50 )
                               , address_5   VARCHAR2( 50 ) );

CREATE TABLE cloas_dump( policy_no        NUMBER( 10 )
                       , title            VARCHAR2( 5 )
                       , forename         VARCHAR2( 50 )
                       , surname          VARCHAR2( 50 )
                       , dob              DATE
                       , gender           VARCHAR2( 1 )
                       , marital_status   VARCHAR2( 1 )
                       , retirement_dt    DATE
                       , scheme_no        VARCHAR2( 10 )
                       , scheme_nm        VARCHAR2( 50 )
                       , address_1        VARCHAR2( 50 )
                       , address_2        VARCHAR2( 50 )
                       , address_3        VARCHAR2( 50 )
                       , policy_status    VARCHAR2( 1 ) );

CREATE TABLE health_dump( policy_no    VARCHAR2( 20 )
                        , title        VARCHAR2( 5 )
                        , forename     VARCHAR2( 50 )
                        , surname      VARCHAR2( 50 )
                        , ppsn         VARCHAR2( 20 )
                        , dob          DATE
                        , gender       VARCHAR2( 1 )
                        , mstat        VARCHAR2( 1 )
                        , plan_type    VARCHAR2( 10 )
                        , start_dt     DATE
                        , renewal_dt   DATE
                        , address_1    VARCHAR2( 50 )
                        , address_2    VARCHAR2( 50 )
                        , address_3    VARCHAR2( 50 )
                        , address_4    VARCHAR2( 50 )
                        , address_5    VARCHAR2( 50 ) );