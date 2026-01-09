const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const db = admin.firestore();

const { getUserNameById } = require("./utils/user.helper");
const { getContractSharedWith } = require("./utils/contract.helper");
const { sendNotification } = require("./utils/notification.sender");

function normalizeTimestampKey(ts) {
    if (!ts) return "";
    try {
        if (typeof ts.toMillis === "function") return String(ts.toMillis());
        if (typeof ts.seconds === "number") return `${ts.seconds}:${ts.nanoseconds || 0}`;
        if (typeof ts._seconds === "number") return `${ts._seconds}:${ts._nanoseconds || 0}`;
        return JSON.stringify(ts);
    } catch (_) {
        return "";
    }
}

function commentKey(c) {
    if (!c || typeof c !== "object") return "";
    const createdAt = normalizeTimestampKey(c.createdAt);
    const userId = (c.userId || "").toString();
    const comment = (c.comment || "").toString();
    const oldStatus = (c.oldStatus || "").toString();
    const newStatus = (c.newStatus || "").toString();
    return `${createdAt}|${userId}|${comment}|${oldStatus}|${newStatus}`;
}

function prettyStatus(s) {
    const x = (s || "").toString().trim();
    if (!x) return "";
    return x.charAt(0).toUpperCase() + x.slice(1);
}

exports.onEmergencyVisitCreate = functions.firestore
    .document("emergencyVisits/{visitId}")
    .onCreate(async (snap, context) => {
        const visitId = context.params.visitId;
        const visit = snap.data() || {};

        const contractId = (visit.contractId || "").toString();
        if (!contractId) return null;

        const requesterId = (visit.requestedBy || "").toString();
        const requesterName = await getUserNameById(requesterId);

        const sharedWith = await getContractSharedWith(contractId);
        const userIds = sharedWith.filter((uid) => uid && uid !== requesterId);
        const topics = userIds.map((uid) => `user_${uid}`);

        return sendNotification(
            topics,
            {
                enTitle: "Emergency Visit Request",
                arTitle: "طلب زيارى طارئ",
                enBody: `${requesterName} requested an emergency visit`,
                arBody: `${requesterName} طلب زيارة طوارئ`,
            },
            {
                type: "emergency_visit",
                event: "created",
                visitId: visitId,
                contractId: contractId,
            },
        );
    });

exports.onEmergencyVisitUpdate = functions.firestore
    .document("emergencyVisits/{visitId}")
    .onUpdate(async (change, context) => {
        const visitId = context.params.visitId;
        const before = change.before.data() || {};
        const after = change.after.data() || {};

        const beforeComments = Array.isArray(before.comments) ? before.comments : [];
        const afterComments = Array.isArray(after.comments) ? after.comments : [];

        // Only act when comments array changes
        if (JSON.stringify(beforeComments) === JSON.stringify(afterComments)) {
            return null;
        }

        const contractId = (after.contractId || "").toString();
        if (!contractId) return null;

        const beforeSet = new Set(beforeComments.map(commentKey));
        const added = afterComments.filter((c) => !beforeSet.has(commentKey(c)));
        const candidates = added.length ? added : afterComments;

        if (!candidates.length) return null;

        // Pick most recent by createdAt (fallback: last item)
        const sorted = [...candidates].sort((a, b) => {
            const ak = normalizeTimestampKey(a?.createdAt);
            const bk = normalizeTimestampKey(b?.createdAt);
            return ak.localeCompare(bk);
        });
        const latest = sorted[sorted.length - 1] || {};

        const actorId = (latest.userId || "").toString() || (after.requestedBy || "").toString();
        const actorName = await getUserNameById(actorId);

        const oldStatus = (latest.oldStatus || "").toString();
        const newStatus = (latest.newStatus || "").toString();

        let enTitle, arTitle, enBody, arBody;
        if (oldStatus && newStatus && oldStatus !== newStatus) {
            enTitle = `Emergency Visit Request`;
            arTitle = `طلب زيارى طارئ`;
            enBody = `${actorName} changed request #${after.code} status to ${prettyStatus(newStatus)}`;
            arBody = `${actorName} غيّر حالة الطلب #${after.code} إلى ${prettyStatus(newStatus)}`;
        } else {
            enTitle = `Emergency Visit Request`;
            arTitle = `طلب زيارى طارئ`;
            enBody = `${actorName} commented on request #${after.code}: ${latest.comment}`;
            arBody = `${actorName} أضاف تعليق على الطلب #${after.code}: ${latest.comment}`;
        }

        const sharedWith = await getContractSharedWith(contractId);
        const userIds = sharedWith.filter((uid) => uid && uid !== actorId);
        const topics = userIds.map((uid) => `user_${uid}`);

        return sendNotification(
            topics,
            {
                enTitle: enTitle,
                arTitle: arTitle,
                enBody: enBody,
                arBody: arBody,
            },
            {
                type: "emergency_visit",
                event: "comment",
                visitId: visitId,
                contractId: contractId,
            },
        );
    });
