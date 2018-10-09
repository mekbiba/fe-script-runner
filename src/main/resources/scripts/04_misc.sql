UPDATE program_products SET id = id + 20000;

DO $$
    BEGIN
        BEGIN
           ALTER TABLE transaction_products ADD COLUMN remarks TEXT;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column remarks already exists in transaction_products.';
        END;
    END;
$$



CREATE OR REPLACE FUNCTION public.stock_control_card(v_node_id integer, v_ppid_id integer, v_from timestamp without time zone, v_to timestamp without time zone)
  RETURNS TABLE(action_id integer, date timestamp without time zone, ref_no text, from_or_to text, txn_type text, txn_qty numeric, txn_direction boolean, quantity_before_transaction numeric, balance numeric, username text, remarks text)
  LANGUAGE sql
AS
$body$
--
SELECT * FROM (SELECT
                   ac.ordinal_number as order,
                   t.transaction_timestamp AS DATE,
                   pr.dispatch_number as ref_no ,
                    CASE WHEN a.adjustment_type IS NOT NULL THEN a.adjustment_type
                         WHEN r.name IS NOT NULL THEN r.name
                         WHEN sn.name IS NOT NULL THEN sn.name
                         WHEN issues_to_facilities.facility_name IS NOT NULL THEN issues_to_facilities.facility_name
                    END AS from_or_to  ,
    				tt.name AS txn_type,
                   tp.quantity AS txn_qty,
                   nt.positive as txn_direction ,
  				   -999.0 as quantity_before_transaction ,
                   -999.0 AS balance,
                   u.username, '{"TRANSACTION_REMARK":"' || tp.remarks ||'"}'
  FROM node_transactions nt INNER JOIN transactions t ON nt.transaction_id = t.id
  INNER JOIN actions ac ON t.action_id = ac.id
  INNER JOIN transaction_types tt ON t.transaction_type = tt.id
  INNER JOIN transaction_products tp ON t.id = tp.transaction_id
  INNER JOIN program_products pp ON tp.program_product_id = pp.id
  INNER JOIN products p ON p.id = pp.productid
  INNER JOIN node_products np ON tp.program_product_id = np.program_product_id
  LEFT JOIN users u ON u.id = t.user_id
  LEFT JOIN adjustments a ON a.transaction_id = t.id
  LEFT JOIN product_receipt pr ON pr.transaction_id = t.id
  LEFT JOIN nodes sn ON pr.source_id = sn.id
  LEFT JOIN (SELECT itof.transaction_id, f.name as facility_name from issues_to_other_facilities itof inner join  facilities f on itof.facility_id = f.id ) issues_to_facilities on issues_to_facilities.transaction_id = t.id
  LEFT JOIN productsource ps ON pr.source_id = ps.id
    LEFT JOIN (SELECT * FROM (SELECT * FROM node_transactions nt
             INNER JOIN nodes n ON nt.node_id = n.id ) AS recipienttxn) r  ON r.transaction_id = t.id AND nt.positive  !=  r.positive
           WHERE nt.node_id =  v_node_id AND pp.id =  v_ppid_id
    AND t.id NOT IN (SELECT reversed_transaction_id FROM reversal_transactions)
    AND t.id NOT IN (SELECT reversal_transaction_id FROM reversal_transactions)

  UNION

  SELECT  ac.ordinal_number as order, pc.date , NULL AS ref_no , 'Physical Count'  AS from_or_to , 'PHYSICAL_COUNT' , NULL AS txn_qty , NULL AS txn_direction,
  NULL as quantity_before_transaction , counted_quantity AS balance , u.username , NULL AS remarks  FROM physical_counts pc
  INNER JOIN actions ac ON  pc.action_id = ac.id
  INNER JOIN node_products np ON pc.node_product_id = np.id
  LEFT OUTER JOIN users u ON pc.user_id = u.id
  WHERE pc.node_product_id = np.id AND np.program_product_id =   v_ppid_id AND np.node_id =  v_node_id)
  AS T
  WHERE
   T.date >= (SELECT CASE WHEN v_from  IS NULL THEN (SELECT MIN(transaction_timestamp) FROM transactions) ELSE v_from END)
  AND  T.date <= (SELECT CASE WHEN v_to  IS NULL THEN (SELECT MAX(transaction_timestamp) FROM transactions) ELSE v_to END)
  ORDER BY T.order DESC;
$body$
  VOLATILE
  COST 100
  ROWS 1000;
