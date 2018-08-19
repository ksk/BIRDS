---
layout: default
---

# BIRDS tutorial: basics

* Declare the view and the base tables in Datalog by using two special symbols: `%s:` for base tables (source tables), `%v:` for views. For example, this statement is for a base table `people` which has two columns `id` and `name`:

    ```prolog
    %s: people(ID, NAME).
    ```
* Database modifications (Insertion, Deletion, Updates): we can use datalog for describing data modications on a base table by writing rules for delta relations of this base table:
  * Delta predicate: a delta predicate is a normal predicate following a symbol `+` or `-`
    * The predicate `+R` corresponds to the delta relation of tuples being inserted into base table `R`
    * The predicte `−R` corresponds to the delta relation of tuples being deleted from `R`
    * Updates on `R` can be represented by using both `+R` and `-R`
  * Delta rule: a delta rule is a rule for modifying data in a base table, it is a Datalog rule with a delta predicate in its head. For example, the following rule means any tuple `X`, which is in `s1` but not in `v`, will be deleted from `s1`:

    ```prolog
    -s1(X) :- s1(X), not v(X).
    ```

Suppose that given two base tables `s1` and `s2`, both have a single column `X`, a view `v` over these two base tables can be defined with the following steps:

1. Write an update trategy on a view v(X) to base tables s1(X) and s2(X) by using Datalog ([basic_sample.dl]({{site.github.repository_url}}/examples/basic_sample.dl)):

    ```prolog
    %s: s1(X).
    %s: s2(X).
    %v: v(X).
    -s1(X) :- s1(X), not v(X).
    -s2(X) :- s2(X), not v(X).
    +s1(X) :- v(X), not s1(X), not s2(X).
    ```

1. Derive view definition and transform this update trategy to SQL statements ([basic_sample.sql]({{site.github.repository_url}}/examples/basic_sample.sql)):
    ```bash
    birds -s public -f examples/basic_sample.dl -o examples/basic_sample.sql
    ```

1. The result contains PostgreSQL SQL statements for creating this view `v` in the database schema `public` and a INSTEAD OF trigger on `v`, which make `v` updatable with the written update strategy. The SQL result can run directly in a PostgreSQL database:

    ```sql
    /*_____get datalog program_______
    ?- v(X).

    v(V_A1_X) :- v_med(V_A1_X) , not __dummy__delta__insert__s1(V_A1_X).

    v_med(X) :- s1(X).

    v_med(X) :- s2(X).

    __dummy__delta__insert__s1(X) :- v_med(X) , not s1(X) , not s2(X).

    ______________*/

    CREATE OR REPLACE VIEW public.v AS
    SELECT __dummy__.col0 AS X
    FROM (SELECT v_a1_0.col0 AS col0
    FROM (SELECT v_med_a1_0.col0 AS col0
        FROM (        SELECT s1_a1_0.X AS col0
            FROM public.s1 AS s1_a1_0
        UNION ALL
            SELECT s2_a1_0.X AS col0
            FROM public.s2 AS s2_a1_0  ) AS v_med_a1_0
        WHERE NOT EXISTS ( SELECT *
        FROM (SELECT v_med_a1_0.col0 AS col0
            FROM (            SELECT s1_a1_0.X AS col0
                FROM public.s1 AS s1_a1_0
            UNION ALL
                SELECT s2_a1_0.X AS col0
                FROM public.s2 AS s2_a1_0  ) AS v_med_a1_0
            WHERE NOT EXISTS ( SELECT *
            FROM public.s1 AS s1_a1
            WHERE s1_a1.X IS NOT DISTINCT FROM v_med_a1_0.col0 ) AND NOT EXISTS ( SELECT *
        FROM public.s2 AS s2_a1
        WHERE s2_a1.X IS NOT DISTINCT FROM v_med_a1_0.col0
    ) ) AS __dummy__delta__insert__s1_a1 WHERE __dummy__delta__insert__s1_a1.col0 IS NOT DISTINCT FROM v_med_a1_0.col0 ) ) AS v_a1_0  ) AS __dummy__;

    CREATE OR REPLACE FUNCTION public.v_procedure()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    SECURITY DEFINER
    AS $$
    DECLARE
    text_var1 text;
    text_var2 text;
    text_var3 text;
    temprec record;
    BEGIN

        CREATE TEMPORARY TABLE __temp__v WITH OIDS ON COMMIT DROP AS SELECT * FROM public.v;
        IF TG_OP = 'INSERT' THEN
        INSERT INTO __temp__v SELECT (NEW).*; 
        ELSIF TG_OP = 'UPDATE' THEN
        DELETE FROM __temp__v WHERE (X) = OLD;
        INSERT INTO __temp__v SELECT (NEW).*; 
        ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM __temp__v WHERE (X) = OLD;
        END IF;

        CREATE TEMPORARY TABLE __dummy__delta__delete__s1 WITH OIDS ON COMMIT DROP AS 
        SELECT __dummy__delta__delete__s1_a1_0.col0 AS col0 FROM (SELECT s1_a1_0.X AS col0 FROM public.s1 AS s1_a1_0 WHERE NOT EXISTS ( SELECT * FROM (SELECT __temp__v_a1_0.X AS col0 FROM __temp__v AS __temp__v_a1_0  ) AS v_a1 WHERE v_a1.col0 IS NOT DISTINCT FROM s1_a1_0.X ) ) AS __dummy__delta__delete__s1_a1_0  ;

        CREATE TEMPORARY TABLE __dummy__delta__delete__s2 WITH OIDS ON COMMIT DROP AS SELECT __dummy__delta__delete__s2_a1_0.col0 AS col0 FROM (SELECT s2_a1_0.X AS col0 FROM public.s2 AS s2_a1_0 WHERE NOT EXISTS ( SELECT * FROM (SELECT __temp__v_a1_0.X AS col0 FROM __temp__v AS __temp__v_a1_0  ) AS v_a1 WHERE v_a1.col0 IS NOT DISTINCT FROM s2_a1_0.X ) ) AS __dummy__delta__delete__s2_a1_0  ;

        CREATE TEMPORARY TABLE __dummy__delta__insert__s1 WITH OIDS ON COMMIT DROP AS SELECT __dummy__delta__insert__s1_a1_0.col0 AS col0 FROM (SELECT v_a1_0.col0 AS col0 FROM (SELECT __temp__v_a1_0.X AS col0 FROM __temp__v AS __temp__v_a1_0  ) AS v_a1_0 WHERE NOT EXISTS ( SELECT * FROM public.s1 AS s1_a1 WHERE s1_a1.X IS NOT DISTINCT FROM v_a1_0.col0 ) AND NOT EXISTS ( SELECT * FROM public.s2 AS s2_a1 WHERE s2_a1.X IS NOT DISTINCT FROM v_a1_0.col0 ) ) AS __dummy__delta__insert__s1_a1_0  ; 


        FOR temprec IN ( SELECT * FROM __dummy__delta__delete__s1) LOOP 
            DELETE FROM public.s1 WHERE (X) IS NOT DISTINCT FROM  (temprec.col0);
            END LOOP;

        FOR temprec IN ( SELECT * FROM __dummy__delta__delete__s2) LOOP 
            DELETE FROM public.s2 WHERE (X) IS NOT DISTINCT FROM  (temprec.col0);
            END LOOP;

        INSERT INTO public.s1 SELECT * FROM __dummy__delta__insert__s1;
        RETURN NULL;

    EXCEPTION
        WHEN object_not_in_prerequisite_state THEN
            RAISE object_not_in_prerequisite_state USING MESSAGE = 'no permission to insert to local db';
        WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS text_var1 = RETURNED_SQLSTATE,
                                    text_var2 = PG_EXCEPTION_DETAIL,
                                    text_var3 = MESSAGE_TEXT;
            RAISE SQLSTATE 'DA000' USING MESSAGE = 'something is wrong;; error code: ' || text_var1 || ' ;; ' || text_var2 ||' ;; ' || text_var3;
            RETURN NULL;
    END;
    
    $$;
    DROP TRIGGER IF EXISTS v_trigger ON public.v;
    CREATE TRIGGER v_trigger
        INSTEAD OF INSERT OR UPDATE OR DELETE ON
        public.v FOR EACH ROW EXECUTE PROCEDURE public.v_procedure();
    ```