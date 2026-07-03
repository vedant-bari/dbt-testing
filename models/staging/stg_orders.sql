select

    order_id,

    user_id as customer_id,

    cast(order_timestamp as date) as order_date,

    status,

    amount

from {{ source('raw','orders') }}