select

    c.customer_id,

    c.first_name,

    c.last_name,

    c.email,

    c.signup_date,

    m.first_order_date,

    m.most_recent_order_date,

    m.total_orders_placed,

    m.customer_lifetime_value

from {{ ref('stg_customers') }} c

left join {{ ref('int_customer_metrics') }} m
    on c.customer_id = m.customer_id