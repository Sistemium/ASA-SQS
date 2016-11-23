sa_make_object 'event', 'sqs_notify_event';
drop event sqs_notify_event;

create event sqs_notify_event
handler begin

    if EVENT_PARAMETER('NumActive') <> '1' then
        return;
    end if;

    WaitFor Delay '00:00:03';

    call sqs.processor ();

end;


alter event sqs_notify_event add SCHEDULE heartBeat
    between '00:00' and '23:59'
    every 10 seconds
    on ('Monday','Tuesday','Wednesday','Thursday','Friday', 'Saturday', 'Sunday')
;
