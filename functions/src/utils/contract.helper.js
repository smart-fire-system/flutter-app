const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const db = admin.firestore();

/**
 * Get contract shared with by contractId
 * @param {string} contractId
 * @returns {Promise<string[]>}
 */
async function getContractSharedWith(contractId) {
    const id = (contractId || "").toString();
    if (!id) return [];
    try {
        const snap = await db.collection("contracts").doc(id).get();
        if (!snap.exists) return [];
        const data = snap.data() || {};
        const sharedWith = Array.isArray(data.sharedWith) ? data.sharedWith : [];

        const meta = (data.metaData && typeof data.metaData === "object") ? data.metaData : {};
        const employeeId = (meta.employeeId || meta.employee?.info?.id || "").toString();
        const clientId = (meta.clientId || meta.client?.info?.id || "").toString();

        const all = [
            ...sharedWith.map(x => (x || "").toString()),
            employeeId,
            clientId,
        ].filter(Boolean);

        return [...new Set(all)];
    } catch (e) {
        console.error("getContractSharedWith failed:", e);
        return [];
    }
}

module.exports = { getContractSharedWith };
