const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const db = admin.firestore();

const { sendNotification } = require("./utils/notification.sender");

exports.onNotificationUpdate = functions.firestore
    .document("sendNotification/{id}")
    .onWrite(async (change, context) => {
        const id = context.params.id;
        const doc = change.after.data();
        return sendNotification(doc.topics,
            {
                enTitle: doc.enTitle || doc.title || "",
                arTitle: doc.arTitle || doc.title || "",
                enBody: doc.enBody || doc.body || "",
                arBody: doc.arBody || doc.body || "",
            },
            doc.data || {}
        );
    });