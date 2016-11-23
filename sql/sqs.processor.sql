create or replace procedure sqs.processor (
    @url STRING default sqs.processorUrl(),
    @headers STRING default sqs.processorHeaders(),
    @top INT default 100
) begin

    declare local temporary table @Undelivered (
        id ID,
        [queue] CODE,
        [body] text,
        cts TS
    );

    declare @res STRING;

    insert into @Undelivered (
        select top @top
            id,
            [queue],
            body,
            cts
        from sqs.Undelivered
        order by cts
    );

    for c as c cursor for select nullIf((
        select
            [body], [queue]
        from @Undelivered as [message] for json auto
    ), '') as @json having @json is not null do begin

        set @res = sqs.post (@url, @headers, @json);

        update sqs.Msg set
            lastError = 0,
            isDelivered = 1
        where id in (
            select id from @Undelivered
        );

    exception WHEN OTHERS THEN

        update sqs.Msg set lastError = @@error
        where id in (select id from @Undelivered)

    end end for;

end;