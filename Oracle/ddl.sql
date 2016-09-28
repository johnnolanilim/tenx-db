DROP TABLE administrator_dump;
DROP TABLE cloas_dump;
DROP TABLE health_dump;

CREATE TABLE administrator_dump( policytype       VARCHAR2( 20 )
                               , policyid         VARCHAR2( 20 )
                               , title            VARCHAR2( 20 )
                               , forename         VARCHAR2( 50 )
                               , surname          VARCHAR2( 50 )
                               , ppsn             VARCHAR2( 50 )
                               , dob              DATE
                               , gender           VARCHAR2( 1 )
                               , mstat            VARCHAR2( 1 )
                               , status           VARCHAR2( 2 )
                               , retiredate       DATE
                               , plannum          VARCHAR2( 50 )
                               , planname         VARCHAR2( 50 )
                               , address_1        VARCHAR2( 50 )
                               , address_2        VARCHAR2( 50 )
                               , address_3        VARCHAR2( 50 )
                               , address_4        VARCHAR2( 50 )
                               , address_5        VARCHAR2( 50 )
                               , fundvalue        NUMBER
                               , monthlypremium   NUMBER );

CREATE TABLE cloas_dump( policy_type     VARCHAR2( 20 )
                       , policyno        VARCHAR2( 20 )
                       , surname         VARCHAR2( 50 )
                       , forename        VARCHAR2( 50 )
                       , middlename      VARCHAR2( 50 )
                       , title           VARCHAR2( 10 )
                       , birthdate       DATE
                       , sex             VARCHAR2( 1 )
                       , maritalstatus   VARCHAR2( 1 )
                       , maturitydate    DATE
                       , plannum         VARCHAR2( 50 )
                       , planname        VARCHAR2( 50 )
                       , addressline1    VARCHAR2( 50 )
                       , addressline2    VARCHAR2( 50 )
                       , addressline3    VARCHAR2( 50 )
                       , policystatus    VARCHAR2( 1 )
                       , polvalue        NUMBER
                       , investamount    NUMBER );

CREATE TABLE health_dump( policytype       VARCHAR2( 20 )
                        , policyid         VARCHAR2( 20 )
                        , title            VARCHAR2( 20 )
                        , forename         VARCHAR2( 50 )
                        , surname          VARCHAR2( 50 )
                        , ppsn             VARCHAR2( 20 )
                        , dob              DATE
                        , gender           VARCHAR2( 1 )
                        , mstat            VARCHAR2( 1 )
                        , planname         VARCHAR2( 20 )
                        , startdate        DATE
                        , renewaldate      DATE
                        , address_1        VARCHAR2( 50 )
                        , address_2        VARCHAR2( 50 )
                        , address_3        VARCHAR2( 50 )
                        , address_4        VARCHAR2( 50 )
                        , address_5        VARCHAR2( 50 )
                        , monthlypremium   NUMBER );