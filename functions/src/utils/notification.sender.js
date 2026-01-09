const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const db = admin.firestore();


/**
 * Convert topics to condition
 * @param {string[]} topics
 * @returns {string}
 */
function topicsToCondition(topics) {
    if (!Array.isArray(topics) || topics.length === 0) {
        throw new Error("topics must be a non-empty array");
    }
    return topics
        .map(t => `'${t}' in topics`)
        .join(' || ');
}

/**
 * Send notification to topics
 * @param {string[]} topics
 * @param {object} notification
 * @param {object} data
 * @returns {Promise<void>}
 */
async function sendNotification(topics, notification, data) {
    const uniqueTopics = [...new Set((topics || []).filter(Boolean))];
    if (!uniqueTopics.length) return;
    const message = {
        condition: topicsToCondition(uniqueTopics),
        notification: {
            title: notification.enTitle || notification.arTitle || "",
            body: notification.enBody || notification.arBody || "",
        },
        data: data || {},
    };

    try {
        const response = await admin.messaging().send(message);
        console.log('Successfully sent topic notifications:', response);
    } catch (error) {
        console.error("Error sending topic notifications:", error);
    }

    try {
        const notifRef = db.collection("notifications").doc();
        await notifRef.set({
            id: notifRef.id,
            title: notification.enTitle,
            body: notification.enBody,
            enTitle: notification.enTitle,
            arTitle: notification.arTitle,
            enBody: notification.enBody,
            arBody: notification.arBody,
            topics: uniqueTopics,
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            data: data || {},
        });
    } catch (e) {
        console.error("Failed to save notification document:", e);
    }
}

module.exports = { sendNotification };