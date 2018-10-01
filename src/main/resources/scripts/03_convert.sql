ALTER TABLE transaction_products
    ADD COLUMN converted boolean ;

UPDATE transaction_products set converted = false;

ALTER TABLE node_program_product_daily_status
    ADD COLUMN converted boolean ;

UPDATE node_program_product_daily_status set converted = false;

ALTER TABLE node_program_product_daily_transaction_summary
    ADD COLUMN converted boolean ;

UPDATE node_program_product_daily_transaction_summary set converted = false;

ALTER TABLE physical_counts
    ADD COLUMN converted boolean ;

UPDATE physical_counts set converted = false;

ALTER TABLE node_products
    ADD COLUMN converted boolean ;

UPDATE node_products set converted = false;

ALTER TABLE requisition_line_items
    ADD COLUMN converted boolean ;

UPDATE requisition_line_items set converted = false;

------------------------------------------------------------------------------------------

UPDATE transaction_products tp
   SET quantity = tp.quantity * pct.conversion_factor,
       converted = TRUE
FROM program_products pp
  INNER JOIN products p ON pp.productid = p.id
  INNER JOIN product_conversion_temp pct ON pct.product_code = p.code
WHERE tp.converted = FALSE
AND   tp.program_product_id = pp.id

---------------------------------------------------------------------------------

UPDATE node_program_product_daily_status n
   SET beginnig_balance = beginnig_balance * pct.conversion_factor,
       final_balance = final_balance*pct.conversion_factor,
       minimum_balance = minimum_balance*pct.conversion_factor,
       converted = TRUE
FROM node_products np
  INNER JOIN program_products pp ON np.program_product_id = pp.id
  INNER JOIN products p ON pp.productid = p.id
  INNER JOIN product_conversion_temp pct ON pct.product_code = p.code
WHERE n.converted = FALSE AND np.id = n.node_program_product_id;


---------------------------------------------------------------------------------

UPDATE node_program_product_daily_transaction_summary n
   SET quantity = quantity*pct.conversion_factor,
       converted = TRUE
FROM node_products np
  INNER JOIN program_products pp ON np.program_product_id = pp.id
  INNER JOIN products p ON pp.productid = p.id
  INNER JOIN product_conversion_temp pct ON pct.product_code = p.code
WHERE n.converted = FALSE
AND   np.id = n.node_program_product_id


---------------------------------------------------------------------------------

UPDATE physical_counts pc
   SET expected_quantity = expected_quantity * pct.conversion_factor,
       counted_quantity = counted_quantity * pct.conversion_factor,
       difference = difference * pct.conversion_factor,
       converted = TRUE
FROM node_products np
  INNER JOIN program_products pp ON np.program_product_id = pp.id
  INNER JOIN products p ON pp.productid = p.id
  INNER JOIN product_conversion_temp pct ON pct.product_code = p.code
WHERE pc.converted = FALSE
AND  np.id = pc.node_product_id


---------------------------------------------------------------------------------

UPDATE node_products np
   SET total_inflow = total_inflow*pct.conversion_factor,
       total_outflow = total_outflow*pct.conversion_factor,
       total_adjustments = total_adjustments*pct.conversion_factor,
       quantity_on_hand = quantity_on_hand*pct.conversion_factor,
       converted = TRUE
FROM program_products pp
  INNER JOIN products p ON pp.productid = p.id
  INNER JOIN product_conversion_temp pct ON pct.product_code = p.code
WHERE np.program_product_id = pp.id
AND   np.converted = FALSE

---------------------------------------------------------------------------------

UPDATE requisition_line_items rli
   SET beginning_balance = rli.beginning_balance * pct.conversion_factor,
       quantity_received = rli.quantity_received * pct.conversion_factor,
       quantity_dispensed = rli.quantity_dispensed * pct.conversion_factor,
       stock_on_hand = rli.stock_on_hand * pct.conversion_factor,
       quantity_requested = rli.quantity_requested * pct.conversion_factor,
       calculated_order_quantity = rli.calculated_order_quantity * pct.conversion_factor,
       normalized_consumption = rli.normalized_consumption * pct.conversion_factor,
       amc = rli.amc * pct.conversion_factor,
       max_stock_quantity = rli.max_stock_quantity * pct.conversion_factor,
       quantity_approved = rli.quantity_approved * pct.conversion_factor,
       converted = TRUE
FROM products p
  INNER JOIN product_conversion_temp pct ON p.code = pct.product_code
WHERE rli.product_id = p.id
AND   rli.converted = FALSE


---------------------------------------------------------------------------------