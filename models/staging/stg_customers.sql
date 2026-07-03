select

    id as customer_id,

    first_name,

    last_name,

    lower(email) as email,

    signup_date

from {{ source('raw','customers') }}