const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const db = admin.firestore();

const { sendNotification } = require("./utils/notification.sender");
const { getUserNameById } = require("./utils/user.helper");

exports.onMasterAdminsUpdate = functions.firestore
    .document("masterAdmins/{userId}")
    .onWrite(async (change, context) => {
        const beforeSnap = change.before;
        const afterSnap = change.after;
        const userId = context.params.userId;

        let userName = await getUserNameById(userId);

        if (!beforeSnap.exists && afterSnap.exists) {
            // Document created
            await sendNotification(
                [`master_admins`],
                {
                    enTitle: "Master Admin Access Granted",
                    arTitle: "إذن المدير الرئيسي للموقع",
                    enBody: `${userName} has been granted master admin access.`,
                    arBody: `${userName} تم إعطاءه إذن المدير الرئيسي للموقع`,
                },
                {
                    action: "access_granted",
                    newRole: "master_admin",
                    userId: userId,
                }
            );
            await sendNotification(
                [`user_${userId}`],
                {
                    enTitle: "Master Admin Access Granted",
                    arTitle: "إذن المدير الرئيسي للموقع",
                    enBody: `You have been granted master admin access.`,
                    arBody: `لقد تم إعطاءك إذن المدير الرئيسي للموقع`,
                },
                {
                    action: "access_granted",
                    newRole: "master_admin",
                    userId: userId,
                }
            );
            console.log(`masterAdmins doc created for user ${userId}`);
        } else if (beforeSnap.exists && !afterSnap.exists) {
            // Document deleted
            await sendNotification(
                [`master_admins`],
                {
                    enTitle: "Master Admin Access Removed",
                    arTitle: "إذن المدير الرئيسي للموقع",
                    enBody: `${userName} has been removed from master admin access.`,
                    arBody: `${userName} تم إزالته من إذن المدير الرئيسي للموقع`,
                },
                {
                    action: "access_removed",
                    oldRole: "master_admin",
                    userId: userId,
                }
            );
            await sendNotification(
                [`user_${userId}`],
                {
                    enTitle: "Master Admin Access Removed",
                    arTitle: "إذن المدير الرئيسي للموقع",
                    enBody: `You have been removed from master admin access.`,
                    arBody: `لقد تم إزالتك من إذن المدير الرئيسي للموقع`,
                },
                {
                    action: "access_removed",
                    oldRole: "master_admin",
                    userId: userId,
                }
            );
            console.log(`masterAdmins doc deleted for user ${userId}`);
        } else {
            // Updated (we don't care)
            console.log(`masterAdmins doc for user ${userId} updated, ignoring`);
            return;
        }
    });
