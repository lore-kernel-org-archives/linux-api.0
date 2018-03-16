From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH ghak32 V2 04/13] audit: add containerid filtering
Date: Fri, 16 Mar 2018 05:00:31 -0400
Message-ID: <b933f93762435990e9b1e6d5aebf15f186ac8951.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1521179281.git.rgb@redhat.com>
In-Reply-To: <cover.1521179281.git.rgb@redhat.com>
References: <cover.1521179281.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Implement container ID filtering using the AUDIT_CONTAINERID field name
to send an 8-character string representing a u64 since the value field
is only u32.

Sending it as two u32 was considered, but gathering and comparing two
fields was more complex.

The feature indicator is AUDIT_FEATURE_BITMAP_CONTAINERID_FILTER.

This requires support from userspace to be useful.
See: https://github.com/linux-audit/audit-userspace/issues/40
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h      |  1 +
 include/uapi/linux/audit.h |  5 ++++-
 kernel/audit.h             |  1 +
 kernel/auditfilter.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/auditsc.c           |  3 +++
 5 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 3acbe9d..f10ca1b 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -76,6 +76,7 @@ struct audit_field {
 	u32				type;
 	union {
 		u32			val;
+		u64			val64;
 		kuid_t			uid;
 		kgid_t			gid;
 		struct {
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index e83ccbd..8443a8f 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -262,6 +262,7 @@
 #define AUDIT_LOGINUID_SET	24
 #define AUDIT_SESSIONID	25	/* Session ID */
 #define AUDIT_FSTYPE	26	/* FileSystem Type */
+#define AUDIT_CONTAINERID	27	/* Container ID */
 
 				/* These are ONLY useful when checking
 				 * at syscall exit time (AUDIT_AT_EXIT). */
@@ -342,6 +343,7 @@ enum {
 #define AUDIT_FEATURE_BITMAP_SESSIONID_FILTER	0x00000010
 #define AUDIT_FEATURE_BITMAP_LOST_RESET		0x00000020
 #define AUDIT_FEATURE_BITMAP_FILTER_FS		0x00000040
+#define AUDIT_FEATURE_BITMAP_CONTAINERID_FILTER	0x00000080
 
 #define AUDIT_FEATURE_BITMAP_ALL (AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT | \
 				  AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME | \
@@ -349,7 +351,8 @@ enum {
 				  AUDIT_FEATURE_BITMAP_EXCLUDE_EXTEND | \
 				  AUDIT_FEATURE_BITMAP_SESSIONID_FILTER | \
 				  AUDIT_FEATURE_BITMAP_LOST_RESET | \
-				  AUDIT_FEATURE_BITMAP_FILTER_FS)
+				  AUDIT_FEATURE_BITMAP_FILTER_FS | \
+				  AUDIT_FEATURE_BITMAP_CONTAINERID_FILTER)
 
 /* deprecated: AUDIT_VERSION_* */
 #define AUDIT_VERSION_LATEST 		AUDIT_FEATURE_BITMAP_ALL
diff --git a/kernel/audit.h b/kernel/audit.h
index 214e149..aaa651a 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -234,6 +234,7 @@ static inline int audit_hash_ino(u32 ino)
 
 extern int audit_match_class(int class, unsigned syscall);
 extern int audit_comparator(const u32 left, const u32 op, const u32 right);
+extern int audit_comparator64(const u64 left, const u32 op, const u64 right);
 extern int audit_uid_comparator(kuid_t left, u32 op, kuid_t right);
 extern int audit_gid_comparator(kgid_t left, u32 op, kgid_t right);
 extern int parent_len(const char *path);
diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index d7a807e..c4c8746 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -410,6 +410,7 @@ static int audit_field_valid(struct audit_entry *entry, struct audit_field *f)
 	/* FALL THROUGH */
 	case AUDIT_ARCH:
 	case AUDIT_FSTYPE:
+	case AUDIT_CONTAINERID:
 		if (f->op != Audit_not_equal && f->op != Audit_equal)
 			return -EINVAL;
 		break;
@@ -584,6 +585,14 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 			}
 			entry->rule.exe = audit_mark;
 			break;
+		case AUDIT_CONTAINERID:
+			if (f->val != sizeof(u64))
+				goto exit_free;
+			str = audit_unpack_string(&bufp, &remain, f->val);
+			if (IS_ERR(str))
+				goto exit_free;
+			f->val64 = ((u64 *)str)[0];
+			break;
 		}
 	}
 
@@ -666,6 +675,11 @@ static struct audit_rule_data *audit_krule_to_data(struct audit_krule *krule)
 			data->buflen += data->values[i] =
 				audit_pack_string(&bufp, audit_mark_path(krule->exe));
 			break;
+		case AUDIT_CONTAINERID:
+			data->buflen += data->values[i] = sizeof(u64);
+			for (i = 0; i < sizeof(u64); i++)
+				((char *)bufp)[i] = ((char *)&f->val64)[i];
+			break;
 		case AUDIT_LOGINUID_SET:
 			if (krule->pflags & AUDIT_LOGINUID_LEGACY && !f->val) {
 				data->fields[i] = AUDIT_LOGINUID;
@@ -752,6 +766,10 @@ static int audit_compare_rule(struct audit_krule *a, struct audit_krule *b)
 			if (!gid_eq(a->fields[i].gid, b->fields[i].gid))
 				return 1;
 			break;
+		case AUDIT_CONTAINERID:
+			if (a->fields[i].val64 != b->fields[i].val64)
+				return 1;
+			break;
 		default:
 			if (a->fields[i].val != b->fields[i].val)
 				return 1;
@@ -1210,6 +1228,31 @@ int audit_comparator(u32 left, u32 op, u32 right)
 	}
 }
 
+int audit_comparator64(u64 left, u32 op, u64 right)
+{
+	switch (op) {
+	case Audit_equal:
+		return (left == right);
+	case Audit_not_equal:
+		return (left != right);
+	case Audit_lt:
+		return (left < right);
+	case Audit_le:
+		return (left <= right);
+	case Audit_gt:
+		return (left > right);
+	case Audit_ge:
+		return (left >= right);
+	case Audit_bitmask:
+		return (left & right);
+	case Audit_bittest:
+		return ((left & right) == right);
+	default:
+		BUG();
+		return 0;
+	}
+}
+
 int audit_uid_comparator(kuid_t left, u32 op, kuid_t right)
 {
 	switch (op) {
@@ -1348,6 +1391,10 @@ int audit_filter(int msgtype, unsigned int listtype)
 				result = audit_comparator(audit_loginuid_set(current),
 							  f->op, f->val);
 				break;
+			case AUDIT_CONTAINERID:
+				result = audit_comparator64(audit_get_containerid(current),
+							      f->op, f->val64);
+				break;
 			case AUDIT_MSGTYPE:
 				result = audit_comparator(msgtype, f->op, f->val);
 				break;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 65be110..2bba324 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -614,6 +614,9 @@ static int audit_filter_rules(struct task_struct *tsk,
 		case AUDIT_LOGINUID_SET:
 			result = audit_comparator(audit_loginuid_set(tsk), f->op, f->val);
 			break;
+		case AUDIT_CONTAINERID:
+			result = audit_comparator64(audit_get_containerid(tsk), f->op, f->val64);
+			break;
 		case AUDIT_SUBJ_USER:
 		case AUDIT_SUBJ_ROLE:
 		case AUDIT_SUBJ_TYPE:
-- 
1.8.3.1
