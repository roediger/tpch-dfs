select
		o_orderpriority,
		count(*) as order_count
from
		orders
where
		o_orderdate >= date '1993-07-01'
		and o_orderdate < date '1993-10-01'
		and exists (
				select
						*
				from
						lineitem
				where
						l_orderkey = o_orderkey
						and l_commitdate < l_receiptdate
		)
group by
		o_orderpriority
order by
		o_orderpriority;\g
select execution_time from iivwprof_query;\g
select concat('async_io ', SUM(async_io)) from iivwprof;\g
