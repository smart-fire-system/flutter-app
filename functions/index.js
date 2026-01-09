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
admin.initializeApp();

const emergencyHandler = require("./src/emergency.handler");
const roleChangeHandler = require("./src/role.change.handler");
const newVersionHandler = require("./src/new_version_handler");
const notificationHandler = require("./src/notification.handler");
exports.onNewVersionUpdate = newVersionHandler.onNewVersionUpdate;

exports.onNotificationUpdate = notificationHandler.onNotificationUpdate;
exports.onMasterAdminsUpdate = roleChangeHandler.onMasterAdminsUpdate;
exports.onEmergencyVisitCreate = emergencyHandler.onEmergencyVisitCreate;
exports.onEmergencyVisitUpdate = emergencyHandler.onEmergencyVisitUpdate;