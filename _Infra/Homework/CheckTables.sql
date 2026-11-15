drop table if exists #CheckTables;

-- Создаю временную таблицу
create table #CheckTables (
    SchemaName NVARCHAR(128),
    TableName NVARCHAR(128),
    FullTableName AS SchemaName + '.' + TableName, -- Полное имя таблицы
    ColumnName NVARCHAR(128),
    IsPrimaryKey BIT,
    IsForeignKey BIT,
    ReferencesSchema NVARCHAR(128),
    ReferencesTable NVARCHAR(128),
    ReferencesColumn NVARCHAR(128)
)

-- Заполняю таблицу базовой информацией
insert into #CheckTables (SchemaName, TableName, ColumnName, IsPrimaryKey, IsForeignKey)
select 
    s.name as SchemaName,
    t.name as TableName,
    c.name as ColumnName,
    case when ic.column_id is not null then 1 else 0 end,
    0 -- Пока 0
    from sys.tables t
    inner join sys.schemas s on t.schema_id = s.schema_id
inner join sys.columns c on t.object_id = c.object_id
inner join sys.types ty on c.user_type_id = ty.user_type_id
left join sys.index_columns ic on c.object_id = ic.object_id and c.column_id = ic.column_id
left join sys.indexes i on ic.object_id = i.object_id and ic.index_id = i.index_id and i.is_primary_key = 1;

--Обновляю таблицу, находя внешние ключи
update #CheckTables
set
    IsForeignKey = 1,
    ReferencesSchema = object_schema_name(fk.referenced_object_id),
    ReferencesTable = object_name(fk.referenced_object_id),
    ReferencesColumn = col_name(fkc.referenced_object_id, fkc.referenced_column_id)
from #CheckTables tb
-- Связываю временную таблицу с системными таблицами внешних ключей
inner join sys.foreign_key_columns fkc on tb.TableName = object_name(fkc.parent_object_id) 
    and tb.ColumnName = col_name(fkc.parent_object_id, fkc.parent_column_id)
inner join sys.foreign_keys fk on fkc.constraint_object_id = fk.object_id;

select
    FullTableName,
    ColumnName,
    IsPrimaryKey,
    IsForeignKey,
    ReferencesSchema + '.' + ReferencesTable as ReferencesFullTable,
    ReferencesColumn
from #CheckTables
where ReferencesTable is not null
order by SchemaName, TableName, ColumnName;


drop table #CheckTables;
