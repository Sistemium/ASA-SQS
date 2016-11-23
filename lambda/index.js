'use strict';

const AWS = require('aws-sdk');
const SQS = new AWS.SQS({apiVersion: '2012-11-05'});
const _ = require('lodash');

const QUEUE_URL_DEFAULT = process.env['QUEUE_URL_DEFAULT'];
const QUEUE_URL_PREFIX = process.env['QUEUE_URL_PREFIX'];

function queueUrl(name) {
    return `${QUEUE_URL_PREFIX}/${name||QUEUE_URL_DEFAULT}`;
}

function createMessage(message) {

    const params = {
        QueueUrl: queueUrl(message.queue),
        MessageBody: message.body
    };

    console.log('createMessage:', params);

    return new Promise((resolve, reject) => {
        SQS.sendMessage(params, (err, data) => err ? reject(err) : resolve(data));
    });
}

function createBunchOfMessages(messagesArray) {
    messagesArray = _.filter(messagesArray, 'message');
    return Promise.all(_.map(messagesArray, message => createMessage(message.message)))
        .then(res => {
            if (!res.length) {
                return Promise.reject('No messages found');
            }
            return res;
        });
}

exports.handler = function (event, context, callback) {
    try {
        let promise;

        if (_.isArray(event)) {
            promise = createBunchOfMessages(event);
        } else if (event.message) {
            promise = createMessage(event.message);
        } else {
            console.log(event);
            callback('No messages found in event');
            return;
        }

        promise
            .then(res => callback(null, res))
            .catch(callback);

    } catch (err) {
        callback(err);
    }
};
