create or replace function sqs.processorUrl (
    @db CODE default current database
) returns STRING DETERMINISTIC
begin

    declare @option STRING;

    set @option = util.getUserOption('sqs.processor.url.' + @db);

    return @option;

end;


create or replace function sqs.processorHeaders (
    @db CODE default current database
) returns STRING DETERMINISTIC
begin

    declare @option STRING;

    set @option = util.getUserOption('sqs.processor.headers.' + @db);

    return @option;

end;
