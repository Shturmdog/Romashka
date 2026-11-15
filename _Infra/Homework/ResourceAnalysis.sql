--1 Группа Анализ закупки
select top 10
    pl.id as pricelistid,
    pl.productid as productfk,
    p.id as productpk,
    p.description as productname,
    pl.groupid as pricegroupfk,
    pg.pricegroupid as pricegrouppk,
    pg.description as pricegroupname,
    pl.basecost,
    pl.netcost
from dbo.pricelist pl
inner join dbo.product p on pl.productid = p.id
left join dbo.pricegroup pg on pl.groupid = pg.pricegroupid
where pl.productid is not null;

-- 1.1 Складские операции
select top 10
    so.id as operationid,
    so.productid as productfk,
    p.id as productpk,
    p.description as productname,
    so.storageid as storagefk,
    s.id as storagepk,
    s.description as storagename,
    so.operationid as operationtypefk,
    sot.id as operationtypepk,
    sot.description as operationtypename,
    so.count,
    so.amount,
    so.dateadd
from dbo.bm_storageoperations so
inner join dbo.product p on so.productid = p.id
inner join dbo.storages s on so.storageid = s.id
inner join dbo.bm_storageoperationstype sot on so.operationid = sot.id
where so.dateadd is not null
order by so.dateadd desc;

-- 2 Группа анализ продажи
select top 10
    j.transnumber,
    j.transtype as transtypefk,
    tt.transtypeid as transtypepk,
    tt.description as transtypename,
    j.dater,
    j.amount,
    j.quantity,
    j.price,
    j.loginid
from dbo.journal j
inner join dbo.transtype tt on j.transtype = tt.transtypeid
where j.dater is not null
order by j.dater desc;


-- 2.1 Связь деталей журнала с товарами
select top 10
    jd.id as detailid,
    jd.sourceid as journalfk,
    j.transnumber as journalpk,
    jd.productid as productfk,
    p.id as productpk,
    p.description as productname,
    jd.rangeid as sizefk,
    sz.id as sizepk,
    sz.description as sizename,
    jd.count,
    jd.quantity
from dbo.bm_journal_details jd
inner join dbo.journal j on jd.sourceid = j.transnumber
inner join dbo.product p on jd.productid = p.id
left join dbo.size sz on jd.rangeid = sz.id
where jd.dateadd is not null
order by jd.dateadd desc;

-- 3 Группа анализ взаимоотношений с поставщиками
select top 10
    v.id as vendorid,
    v.clientid as vendorcode,
    v.firstname as vendorname,
    v.clientgroup as vendorgroupfk,
    vg.vendorgroupid as vendorgrouppk,
    vg.description as vendorgroupname,
    v.inn,
    v.kpp,
    v.address
from dbo.vendors v
left join dbo.vendorgroup vg on v.clientgroup = vg.vendorgroupid
where v.id is not null;

-- 4 Группа анализ работы персонала 
select top 10
    bh.id as bonusid,
    bh.personid as personfk,
    p.personid as personpk,
    p.firstname + ' ' + p.lastname as employeename,
    bh.actionname,
    bh.bonusvalue,
    bh.period,
    bh.clientid,
    bh.ticketnumber
from dbo.bm_bonushistory bh
inner join dbo.personnel p on bh.personid = p.personid
where bh.period is not null
order by bh.period desc;

-- 5 Группа анализ остатков
select top 10
    so.id as operationid,
    so.documentid as documentfk,
    jbd.id as documentpk,
    jbd.documentnumber,
    so.productid as productfk,
    p.id as productpk,
    p.description as productname,
    p.categoryid as categoryfk,
    c.id as categorypk,
    c.description as categoryname,
    so.storageid as storagefk,
    s.id as storagepk,
    s.description as storagename,
    so.count,
    so.amount,
    so.dateadd
from dbo.bm_storageoperations so
inner join dbo.bm_journalbarnetdocs jbd on so.documentid = jbd.id
inner join dbo.product p on so.productid = p.id
left join dbo.category c on p.categoryid = c.id
inner join dbo.storages s on so.storageid = s.id
where so.dateadd is not null
order by so.dateadd desc;


-- 5.1 Складские операции
select top 20
    so.id as operationid,
    so.dateadd as operationdate,
    p.id as productid,
    p.description as productname,
    s.description as storagename,
    sot.description as operationtype,
    so.count as quantity,
    so.amount as totalamount,
    so.price as unitprice
from dbo.bm_storageoperations so
inner join dbo.product p on so.productid = p.id
inner join dbo.storages s on so.storageid = s.id
inner join dbo.bm_storageoperationstype sot on so.operationid = sot.id
where so.dateadd is not null
order by so.dateadd desc;

-- 5.3 Связь товаров с категориями и дополнительной информацией
select top 10
    p.id as productid,
    p.productid as productcode,
    p.description as productname,
    p.categoryid as categoryfk,
    c.id as categorypk,
    c.description as categoryname,
    pi.id as infoid,
    pi.productid as infoproductfk,
    pi.keyparam,
    pi.value,
    p.onhand,
    p.cost,
    p.price1
from dbo.product p
left join dbo.category c on p.categoryid = c.id
left join dbo.productinfo pi on p.id = pi.productid
where p.id is not null;
