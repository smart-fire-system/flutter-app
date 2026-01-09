const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const db = admin.firestore();

/**
 * Get user name by userId
 * @param {string|number} userId
 * @returns {Promise<string>}
 */
async function getUserNameById(userId) {
  const uid = (userId || "").toString().trim();
  if (!uid) return "Unknown";

  try {
    const snap = await db.collection("users").doc(uid).get();
    if (!snap.exists) return uid;
    const data = snap.data() || {};
    const name = (data.name || "").toString().trim();
    return name || uid;
  } catch (e) {
    console.error("getUserNameById failed:", e);
    return uid;
  }
}

module.exports = { getUserNameById };
