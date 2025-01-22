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
