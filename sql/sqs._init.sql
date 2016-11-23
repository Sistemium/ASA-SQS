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

util.setUserOption 'sqs.processor.url.r50d', 'http://aws.sistemium.net/execute-api/gozy5p0624/prod';
util.setUserOption 'sqs.processor.headers.r50d', 'x-api-key:BXAjWM62wD4zPVYpAXZni8QhIgGojakx7fE2dUk3';

commit

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
