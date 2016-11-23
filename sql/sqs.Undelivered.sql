create or replace view sqs.Undelivered as select
    id,
    [queue],
    [body],
    cts
from sqs.Msg
where isDelivered = 0
;


create or replace procedure sqs.[notify] (
    @queue MEDIUM,
    @body text
) begin

    insert into sqs.Undelivered with auto name select
        @queue as [queue],
        @body as [body]
    ;

    trigger event sqs_notify_event;

end;
