/*

grant connect to sqs;
grant dba to sqs;

meta.createDbspace 'sqs';

meta.defineType 'sqs.queue:MEDIUM';
meta.defineType 'sqs.body:text';
meta.defineType 'sqs.isDelivered:BOOL';
meta.defineType 'sqs.lastError:int,,nullAble';

meta.defineEntity 'sqs.Msg',
    'queue;body;isDelivered;lastError'
;

meta.createTable 'sqs.Msg', 0, 1;

create index XK_sqs_Msg_isDelivered_cts on sqs.Msg (isDelivered, cts);

*/

create or replace function sqs.post(
    url long varchar,
    headers long varchar,
    body text
) returns text
    url '!url'
    type 'HTTP:POST:application/json'
    header '!headers'
;
