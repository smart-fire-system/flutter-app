/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp(); // Initializes the Admin SDK
const db = admin.firestore(); // Access Firestore

exports.assignDefaultClaims = functions.auth.user().onCreate(async (user) => {
  console.log("User object received:", user);

  const defaultClaims = {
    role: null,
    canAddBranch: false,
    canAddCompany: false,
  };

  try {
    if (!user || !user.uid) {
      throw new Error("User object or UID is missing");
    }

    await admin.auth().setCustomUserClaims(user.uid, defaultClaims);
    console.log(`Default claims set for user ${user.uid}`);
  } catch (error) {
    console.error("Error assigning default claims:", error);
  }
});

exports.updateUserClaims = functions.https.onCall(async (data, context) => {
  // Only allow authenticated admin users to update claims
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can update user claims.",
    );
  }

  const { uid, claims } = data;

  try {
    // Update the user"s custom claims
    await admin.auth().setCustomUserClaims(uid, claims);
    console.log(`Custom claims updated for user ${uid}`);
    return { message: `Claims updated for user ${uid}` };
  } catch (error) {
    console.error("Error updating claims:", error);
    throw new functions.https.HttpsError("unknown", "Failed to update claims.");
  }
});


exports.addMasterAdmin = functions.https.onCall(async (data, context) => {
  if (!context.auth || context.auth.token.role !== "masterAdmin") {
    throw new functions.https.HttpsError("permission-denied");
  }
  const { uid } = data;
  if (!uid) {
    throw new functions.https.HttpsError("invalid-argument");
  }
  try {
    const docRef = db.collection("masterAdmins").doc(uid);
    const doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({});
    }
    await admin.auth().setCustomUserClaims(uid,
      { role: "masterAdmin" },
    );
    return { message: "success" };
  } catch (error) {
    throw new functions.https.HttpsError("unknown");
  }

});

exports.deleteMasterAdmin = functions.https.onCall(async (data, context) => {
  if (!context.auth || context.auth.token.role !== "masterAdmin") {
    throw new functions.https.HttpsError("permission-denied");
  }
  const { uid } = data;
  if (!uid) {
    throw new functions.https.HttpsError("invalid-argument");
  }
  try {
    const docRef = db.collection("masterAdmins").doc(uid);
    const doc = await docRef.get();
    if (doc.exists) {
      await docRef.delete();
    }
    await admin.auth().setCustomUserClaims(uid, {});
    return { message: "success" };
  } catch (error) {
    throw new functions.https.HttpsError("unknown");
  }
});

exports.addCompanyManager = functions.https.onCall(async (data, context) => {
  if (!context.auth ||
    context.auth.token.isMasterAdmin !== true ||
    context.auth.token.canAddCompanyManagers !== true
  ) {
    throw new functions.https.HttpsError("permission-denied");
  }
  const {
    uid
    , companyId
    , canAddBranchManagers
    , canEditBranchManagers
    , canDeleteBranchManagers
    , canAddEmployees
    , canEditEmployees
    , canDeleteEmployees
    , canEditCompanies
    , canAddBranches
    , canEditBranches
    , canDeleteBranches,
  } = data;
  if (
    !uid ||
    typeof uid !== "string" ||
    typeof companyId !== "string" ||
    typeof canAddBranchManagers !== "boolean" ||
    typeof canEditBranchManagers !== "boolean" ||
    typeof canDeleteBranchManagers !== "boolean" ||
    typeof canAddEmployees !== "boolean" ||
    typeof canEditEmployees !== "boolean" ||
    typeof canDeleteEmployees !== "boolean" ||
    typeof canEditCompanies !== "boolean" ||
    typeof canAddBranches !== "boolean" ||
    typeof canEditBranches !== "boolean" ||
    typeof canDeleteBranches !== "boolean"
  ) {
    throw new functions.https.HttpsError("invalid-argument");
  }
  try {
    const updatedClaims = {
      role: "companyManager",
      companyId: companyId,
      canAddBranchManagers: canAddBranchManagers,
      canEditBranchManagers: canEditBranchManagers,
      canDeleteBranchManagers: canDeleteBranchManagers,
      canAddEmployees: canAddEmployees,
      canEditEmployees: canEditEmployees,
      canDeleteEmployees: canDeleteEmployees,
      canEditCompanies: canEditCompanies,
      canAddBranches: canAddBranches,
      canEditBranches: canEditBranches,
      canDeleteBranches: canDeleteBranches,
    };
    await admin.auth().setCustomUserClaims(uid, updatedClaims);
    console.log(`User ${uid} updated to companyManager with permissions.`);
    return { message: `User ${uid} updated to companyManager successfully.` };
  } catch (error) {
    console.error("Error setting user as company manager:", error);
    throw new functions.https.HttpsError(
      "unknown",
      "Failed to set user as company manager.",
    );
  }
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.onMasterAdminsChange = functions.firestore
  .document("masterAdmins/{userId}")
  .onWrite(async (change, context) => {
    const beforeSnap = change.before;
    const afterSnap = change.after;
    const userId = context.params.userId;

    let actionType = null;

    if (!beforeSnap.exists && afterSnap.exists) {
      // Document created
      actionType = "granted";
      console.log(`masterAdmins doc created for user ${userId}`);
    } else if (beforeSnap.exists && !afterSnap.exists) {
      // Document deleted
      actionType = "removed";
      console.log(`masterAdmins doc deleted for user ${userId}`);
    } else {
      // Updated (we don't care)
      console.log(`masterAdmins doc for user ${userId} updated, ignoring`);
      return;
    }

    // Fetch user tokens from: users/{userId}/tokens/{tokenDocId}
    const tokensSnapshot = await admin
      .firestore()
      .collection("users")
      .doc(userId)
      .collection("tokens")
      .get();

    if (tokensSnapshot.empty) {
      console.log(`No FCM tokens found for user ${userId}`);
      return;
    }

    const tokens = tokensSnapshot.docs
      .map((doc) => doc.data().token)
      .filter((t) => !!t);

    if (!tokens.length) {
      console.log(`User ${userId} has no valid token values`);
      return;
    }

    let title;
    let body;

    if (actionType === "granted") {
      title = "Admin Access Granted ✅";
      body = "You have been granted master admin access.";
    } else {
      title = "Admin Access Removed ❌";
      body = "Your master admin access has been revoked.";
    }

    const multicastMessage = {
      tokens,
      notification: {
        title,
        body,
      },
      data: {
        userId,
        action: actionType, // "granted" or "removed"
      },
    };

    try {
      const response = await admin.messaging().sendEachForMulticast(multicastMessage);
      console.log("FCM sendEachForMulticast response:", JSON.stringify(response));
    } catch (error) {
      console.error("Error sending FCM notifications:", error);
    }
  });

exports.onNewVersionNotifications = functions.firestore
  .document("androidVersions/{versionId}")
  .onCreate(async (change, context) => {
    const versionId = context.params.versionId;
    const message = {
      topic: 'android_users',
      notification: {
        title: 'New Version Available',
        body: `Version ${versionId} is now available.`,
      },
      data: {
        click_action: "OPEN_PLAY_STORE",
      },
    };
    try {
      const response = await admin.messaging().send(message);
      console.log('Successfully sent topic message:', response);

      // Add a document to notifications collection
      const notifRef = db.collection("notifications").doc();
      await notifRef.set({
        id: notifRef.id,
        title: message.notification.title,
        body: message.notification.body,
        topics: [message.topic],
        click_action: message.data.click_action,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      return null;
    } catch (error) {
      console.error('Error sending topic message:', error);
      return null;
    }

  });

