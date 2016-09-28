CREATE OR REPLACE PACKAGE BODY mongo_load_pkg
IS
   --address_separator   VARCHAR2( 10 ) := ', ';
   address_separator   VARCHAR2( 10 ) := CHR( 10 );

   FUNCTION coalesce_address( in_address_1    administrator_dump.address_1%TYPE
                            , in_address_2    administrator_dump.address_2%TYPE
                            , in_address_3    administrator_dump.address_3%TYPE
                            , in_address_4    administrator_dump.address_4%TYPE
                            , in_address_5    administrator_dump.address_5%TYPE )
      RETURN VARCHAR2
   IS
      out_address   VARCHAR2( 4000 );
   BEGIN
      SELECT    in_address_1
             || NVL2( in_address_2, address_separator || in_address_2, NULL )
             || NVL2( in_address_3, address_separator || in_address_3, NULL )
             || NVL2( in_address_4, address_separator || in_address_4, NULL )
             || NVL2( in_address_5, address_separator || in_address_5, NULL )
        INTO out_address
        FROM DUAL;

      RETURN out_address;
   END coalesce_address;

   FUNCTION generate_mobile_no
      RETURN VARCHAR2
   IS
      out_number   VARCHAR2( 11 );
   BEGIN
      out_number :=    '08'
                    || TRUNC( DBMS_RANDOM.VALUE( 22000000
                                               , 99999999 ) );

      RETURN    SUBSTR( out_number
                      , 1
                      , 3 )
             || ' '
             || SUBSTR( out_number
                      , -7
                      , 7 );
   END generate_mobile_no;

   FUNCTION generate_username( in_forename    administrator_dump.forename%TYPE
                             , in_surname     administrator_dump.surname%TYPE )
      RETURN VARCHAR2
   IS
   BEGIN
      RETURN REGEXP_REPLACE(    in_forename
                             || '.'
                             || in_surname
                             || TRUNC( DBMS_RANDOM.VALUE( 0
                                                        , 999 ) )
                           , ' |''' );
   END generate_username;

   FUNCTION generate_email_address( in_username VARCHAR2 )
      RETURN VARCHAR2
   IS
      ln_rand     NUMBER;
      out_email   VARCHAR2( 200 );
   BEGIN
      ln_rand := DBMS_RANDOM.VALUE;

      CASE
         WHEN ln_rand < .5
         THEN
            out_email := '@gmail.com';
         WHEN ln_rand < .7
         THEN
            out_email := '@eircom.net';
         WHEN ln_rand < .85
         THEN
            out_email := '@yahoo.com';
         ELSE
            out_email := '@hotmail.com';
      END CASE;

      RETURN in_username || out_email;
   END generate_email_address;

   PROCEDURE generate_json
   IS
      person     json;
      policy     json;
      policies   json_list;
      ret_val    json_list;

      CURSOR cur_key_fields
      IS
         SELECT forename
              , surname
              , dob
              , address_1
           FROM administrator_dump
         UNION
         SELECT forename
              , surname
              , birthdate
              , addressline1
           FROM cloas_dump
         UNION
         SELECT forename
              , surname
              , dob
              , address_1
           FROM health_dump;

      CURSOR cur_person( p_forename     administrator_dump.forename%TYPE
                       , p_surname      administrator_dump.surname%TYPE
                       , p_dob          administrator_dump.dob%TYPE
                       , p_address_1    administrator_dump.address_1%TYPE )
      IS
         SELECT *
           FROM (SELECT title
                      , forename
                      , surname
                      , ppsn
                      , dob
                      , gender
                      , mstat
                      , address_1
                      , address_2
                      , address_3
                      , address_4
                      , address_5
                   FROM administrator_dump
                 UNION ALL
                 SELECT title
                      , forename
                      , surname
                      , NULL
                      , birthdate
                      , sex
                      , maritalstatus
                      , addressline1
                      , addressline2
                      , addressline3
                      , NULL
                      , NULL
                   FROM cloas_dump
                 UNION ALL
                 SELECT title
                      , forename
                      , surname
                      , ppsn
                      , dob
                      , gender
                      , mstat
                      , address_1
                      , address_2
                      , address_3
                      , address_4
                      , address_5
                   FROM health_dump) p
          WHERE forename = p_forename
            AND surname = p_surname
            AND dob = p_dob
            AND address_1 = p_address_1
            AND ROWNUM = 1;

      CURSOR cur_admin_policy( p_forename     administrator_dump.forename%TYPE
                             , p_surname      administrator_dump.surname%TYPE
                             , p_dob          administrator_dump.dob%TYPE
                             , p_address_1    administrator_dump.address_1%TYPE )
      IS
         SELECT policytype
              , policyid
              , fundvalue
              , retiredate
              , plannum
              , planname
              , monthlypremium
           FROM administrator_dump a
          WHERE a.forename = p_forename
            AND a.surname = p_surname
            AND a.dob = p_dob
            AND a.address_1 = p_address_1;

      CURSOR cur_cloas_policy( p_forename     administrator_dump.forename%TYPE
                             , p_surname      administrator_dump.surname%TYPE
                             , p_dob          administrator_dump.dob%TYPE
                             , p_address_1    administrator_dump.address_1%TYPE )
      IS
         SELECT policy_type as policytype
              , policyno as policyid
              , maturitydate
              , polvalue
              , investamount
              , planname
           FROM cloas_dump a
          WHERE a.forename = p_forename
            AND a.surname = p_surname
            AND a.birthdate = p_dob
            AND a.addressline1 = p_address_1;

      CURSOR cur_health_policy( p_forename     administrator_dump.forename%TYPE
                              , p_surname      administrator_dump.surname%TYPE
                              , p_dob          administrator_dump.dob%TYPE
                              , p_address_1    administrator_dump.address_1%TYPE )
      IS
         SELECT policytype
              , policyid
              , planname
              , startdate
              , renewaldate
              , monthlypremium
           FROM health_dump a
          WHERE a.forename = p_forename
            AND a.surname = p_surname
            AND a.dob = p_dob
            AND a.address_1 = p_address_1;
   BEGIN
      ret_val := json_list( );

      FOR rec IN cur_key_fields
      LOOP
         person := json( );

         FOR per_rec IN cur_person( rec.forename
                                  , rec.surname
                                  , rec.dob
                                  , rec.address_1 )
         LOOP
            person.put( 'username'
                      , generate_username( rec.forename
                                         , rec.surname ) );
            person.put( 'password'
                      , 'password12' );
            person.put( 'pin'
                      , '1234' );
            person.put( 'title'
                      , per_rec.title );
            person.put( 'forename'
                      , per_rec.forename );
            person.put( 'surname'
                      , per_rec.surname );
            person.put( 'ppsn'
                      , per_rec.ppsn );
            person.put( 'dob'
                      , json_ext.to_json_value( per_rec.dob ) );
            person.put( 'mobile'
                      , generate_mobile_no );
            person.put( 'email'
                      , generate_email_address( person.get( 'username' ).get_string ) );
            person.put( 'gender'
                      , per_rec.gender );
            person.put( 'maritalStatus'
                      , per_rec.mstat );
            person.put( 'address'
                      , coalesce_address( per_rec.address_1
                                        , per_rec.address_2
                                        , per_rec.address_3
                                        , per_rec.address_4
                                        , per_rec.address_5 ) );

            --Add policies
            policies := json_list( );

            FOR admin_rec IN cur_admin_policy( per_rec.forename
                                             , per_rec.surname
                                             , per_rec.dob
                                             , per_rec.address_1 )
            LOOP
               policy := json( );

               policy.put( 'policyType'
                         , admin_rec.policytype );
               policy.put( 'policyID'
                         , admin_rec.policyid );
               policy.put( 'Retire Date'
                         , json_ext.to_json_value( admin_rec.retiredate ) );
               policy.put( 'Plan No'
                         , admin_rec.plannum );
               policy.put( 'Plan Name'
                         , admin_rec.planname );
               policy.put( 'Fund Value'
                         , admin_rec.fundvalue );
               policy.put( 'Monthly Premium'
                         , admin_rec.monthlypremium );

               policies.append( policy.to_json_value );
            END LOOP;

            FOR cloas_rec IN cur_cloas_policy( per_rec.forename
                                             , per_rec.surname
                                             , per_rec.dob
                                             , per_rec.address_1 )
            LOOP
               policy := json( );

               policy.put( 'policyType'
                         , cloas_rec.policytype );
               policy.put( 'policyID'
                         , cloas_rec.policyid );
               policy.put( 'Maturity Date'
                         , json_ext.to_json_value( cloas_rec.maturitydate ) );
               policy.put( 'Policy Value '
                         , cloas_rec.polvalue );
               policy.put( 'Plan Name'
                         , cloas_rec.planname );
               policy.put( 'Invest Amount '
                         , cloas_rec.investamount );

               policies.append( policy.to_json_value );
            END LOOP;

            FOR health_rec IN cur_health_policy( per_rec.forename
                                               , per_rec.surname
                                               , per_rec.dob
                                               , per_rec.address_1 )
            LOOP
               policy := json( );

               policy.put( 'policyType'
                         , health_rec.policytype );
               policy.put( 'policyID'
                         , health_rec.policyid );
               policy.put( 'Plan Name'
                         , health_rec.planname );
               policy.put( 'Start Date'
                         , json_ext.to_json_value( health_rec.startdate ) );
               policy.put( 'Renewal Date'
                         , json_ext.to_json_value( health_rec.renewaldate ) );
               policy.put( 'Monthly Premium'
                         , health_rec.monthlypremium );

               policies.append( policy.to_json_value );
            END LOOP;

            person.put( 'policies'
                      , policies );
         END LOOP;

         ret_val.append( person.to_json_value );
      END LOOP;

      ret_val.PRINT;
   END generate_json;
END mongo_load_pkg;
/