DROP TABLE IF EXISTS public.transaction_products_bak;

CREATE TABLE public.transaction_products_bak
(
    id integer,
    quantity numeric,
    transaction_id integer,
    program_product_id integer,
    remarks text COLLATE pg_catalog."default",
    CONSTRAINT pk_bak_transaction_product_id PRIMARY KEY (id),
    CONSTRAINT fk_tpbak_program_product_id FOREIGN KEY (program_product_id)
        REFERENCES public.program_products (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT fk_tpbak_transaction_id FOREIGN KEY (transaction_id)
        REFERENCES public.transactions (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

------------------------------------------------------------------------

DROP TABLE  IF EXISTS public.node_program_product_daily_status_bak;
CREATE TABLE public.node_program_product_daily_status_bak
(
    id integer,
    node_program_product_id integer,
    beginnig_balance numeric,
    final_balance numeric,
    first_action integer,
    last_action integer,
    date date,
    minimum_balance numeric,
    CONSTRAINT pk_nppds_bak_id PRIMARY KEY (id),
    CONSTRAINT fk_nppds_bak_node_program_product_id FOREIGN KEY (node_program_product_id)
        REFERENCES public.node_products (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

------------------------------------------------------------------------

DROP TABLE  IF EXISTS public.node_program_product_daily_transaction_summary_bak;
CREATE TABLE public.node_program_product_daily_transaction_summary_bak
(
    id  integer,
    txn_type_id integer,
    quantity numeric,
    node_program_product_id integer,
    date date,
    CONSTRAINT pk_nppds_bak_daily_txn_summary_id PRIMARY KEY (id),
    CONSTRAINT fk_bak_node_program_product_id FOREIGN KEY (node_program_product_id)
        REFERENCES public.node_products (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_bak_txn_type_id FOREIGN KEY (txn_type_id)
        REFERENCES public.transaction_types (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

------------------------------------------------------------------------
DROP TABLE IF EXISTS public.physical_counts_bak;

CREATE TABLE public.physical_counts_bak
(
    id integer,
    node_product_id integer,
    expected_quantity numeric,
    counted_quantity numeric,
    difference numeric,
    date timestamp without time zone,
    user_id integer,
    action_id integer,
    CONSTRAINT pk_physical_count_bak_id PRIMARY KEY (id),
    CONSTRAINT fk_pcbak_action_id FOREIGN KEY (action_id)
        REFERENCES public.actions (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_pcbak_user_id FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

------------------------------------------------------------------------
DROP TABLE IF EXISTS public.node_products_bak;

CREATE TABLE public.node_products_bak
(
    id integer,
    total_inflow numeric,
    total_outflow numeric,
    total_adjustments numeric,
    latest_physical_count_id integer,
    node_id integer,
    quantity_on_hand numeric,
    program_product_id integer,
    CONSTRAINT pk_node_product_bak_id PRIMARY KEY (id),
    CONSTRAINT fk_bak_latest_physical_count_id FOREIGN KEY (latest_physical_count_id)
        REFERENCES public.physical_counts (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_bak_node_id FOREIGN KEY (node_id)
        REFERENCES public.nodes (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_bak_program_product_id FOREIGN KEY (program_product_id)
        REFERENCES public.program_products (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

-----

DROP TABLE IF EXISTS public.requisition_line_items_bak;

CREATE TABLE public.requisition_line_items_bak
(
    id integer,
    requisition_id integer,
    product_id integer,
    beginning_balance numeric,
    quantity_received numeric,
    quantity_dispensed numeric,
    stock_on_hand numeric,
    stock_out_days integer,
    new_patient_count integer,
    quantity_requested numeric,
    reason_for_requested_quantity character varying(200) COLLATE pg_catalog."default",
    amc numeric,
    normalized_consumption numeric,
    calculated_order_quantity numeric,
    max_stock_quantity numeric,
    dispensing_unit character varying(50) COLLATE pg_catalog."default",
    max_months_of_stock numeric,
    pack_size numeric,
    doses_per_month numeric,
    doses_per_dispensing_unit numeric,
    quantity_approved numeric,
    full_supply boolean,
    remarks text COLLATE pg_catalog."default",
    skipped boolean DEFAULT false,
    CONSTRAINT pk_bak_rli_id PRIMARY KEY (id),
    CONSTRAINT fk_rli_bak_product_id FOREIGN KEY (product_id)
        REFERENCES public.products (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT fk_bak_requisition_id FOREIGN KEY (requisition_id)
        REFERENCES public.requisitions (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

------------------------------------------------------------------------
------------------------------------------------------------------------

insert into transaction_products_bak
select * from transaction_products;

insert into node_program_product_daily_status_bak
select * from node_program_product_daily_status;

insert into node_program_product_daily_transaction_summary_bak
select * from node_program_product_daily_transaction_summary;

insert into physical_counts_bak
select * from physical_counts;

insert into node_products_bak
select * from node_products;

insert into requisition_line_items_bak
select * from requisition_line_items;

------------------------------------------------------------------------