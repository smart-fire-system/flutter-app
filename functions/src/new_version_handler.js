const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const db = admin.firestore();

const { sendNotification } = require("./utils/notification.sender");

exports.onNewVersionUpdate = functions.firestore
    .document("androidVersions/{versionId}")
    .onWrite(async (change, context) => {
        const versionId = context.params.versionId;
        return sendNotification(
            ["android_users"],
            {
                enTitle: "New Version Available",
                arTitle: "النسخة الجديدة متاحة",
                enBody: `Version ${versionId} is now available. Click to update.`,
                arBody: `النسخة الجديدة ${versionId} متاحة الآن. انقر للتحديث.`,
            },
            {
                action: "new_version_available",
                clickAction: "OPEN_PLAY_STORE",
                versionId: versionId,
            }
        );
    });

exports.onNewVersionNotifications = functions.firestore
    .document("iosVersions/{versionId}")
    .onWrite(async (change, context) => {
        const versionId = context.params.versionId;
        return sendNotification(
            ["ios_users"],
            {
                enTitle: "New Version Available",
                arTitle: "النسخة الجديدة متاحة",
                enBody: `Version ${versionId} is now available. Click to update.`,
                arBody: `النسخة الجديدة ${versionId} متاحة الآن. انقر للتحديث.`,
            },
            {
                action: "new_version_available",
                clickAction: "OPEN_APP_STORE",
                versionId: versionId,
            }
        );
    });
