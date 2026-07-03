select

    customer_id,

    min(order_date) as first_order_date,

    max(order_date) as most_recent_order_date,

    count(order_id) as total_orders_placed,

    sum(amount) as customer_lifetime_value

from {{ ref('stg_orders') }}

group by customer_id