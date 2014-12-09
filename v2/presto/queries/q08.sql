select
		o.year,
		sum(case
				when nation = 'BRAZIL' then volume
				else 0
		end) / sum(volume) as mkt_share
from
		(
				select
						extract(year from o.orderdate) as o.year,
						l.extendedprice * (1 - l.discount) as volume,
						n2.n.name as nation
				from
						part,
						supplier,
						lineitem,
						orders,
						customer,
						nation n1,
						nation n2,
						region
				where
						p.partkey = l.partkey
						and s.suppkey = l.suppkey
						and l.orderkey = o.orderkey
						and o.custkey = c.custkey
						and c.nationkey = n1.n.nationkey
						and n1.n.regionkey = r.regionkey
						and r.name = 'AMERICA'
						and s.nationkey = n2.n.nationkey
						and o.orderdate between date '1995-01-01' and date '1996-12-31'
						and p.type = 'ECONOMY ANODIZED STEEL'
		) as all_nations
group by
		o.year
order by
		o.year
