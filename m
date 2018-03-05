From: Richard Guy Briggs <rgb@redhat.com>
Subject: [RFC PATCH] auditctl: add support for containerid filter
Date: Mon,  5 Mar 2018 03:06:06 -0500
Message-ID: <1520237166-15679-1-git-send-email-rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Cc: luto@kernel.org, jlayton@redhat.com, carlos@redhat.com, viro@zeniv.linux.org.uk, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, madzcar@gmail.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

A u64 container identifier has been added to the kernel view of tasks.
This allows container orchestrators to label tasks with a unique
tamperproof identifier that gets inherited by its children to be able to
track the provenance of actions by a container.

Add support to libaudit and auditctl for the containerid field to filter
based on container identifier.  Since it is a u64 and larger than any
other numeric field, send it as a string but do the appropriate
conversions on each end in each direction.

See: https://github.com/linux-audit/audit-userspace/issues/40
See: https://github.com/linux-audit/audit-kernel/issues/32
See: https://github.com/linux-audit/audit-testsuite/issues/64
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
Note: This is a userspace patch for the audit utils to support the
kernel RFC patchset, in optimism of kernel support acceptance.
ausearch would also need support added.
---
 docs/auditctl.8        |  3 +++
 lib/fieldtab.h         |  1 +
 lib/libaudit.c         | 36 ++++++++++++++++++++++++++++++++++++
 lib/libaudit.h         |  7 +++++++
 src/auditctl-listing.c | 21 +++++++++++++++++++++
 5 files changed, 68 insertions(+)

diff --git a/docs/auditctl.8 b/docs/auditctl.8
index 88466de..8bda43d 100644
--- a/docs/auditctl.8
+++ b/docs/auditctl.8
@@ -210,6 +210,9 @@ Parent's Process ID
 .B sessionid
 User's login session ID
 .TP
+.B containerid
+Process' container ID
+.TP
 .B subj_user
 Program's SE Linux User
 .TP
diff --git a/lib/fieldtab.h b/lib/fieldtab.h
index c425d5b..755800a 100644
--- a/lib/fieldtab.h
+++ b/lib/fieldtab.h
@@ -47,6 +47,7 @@ _S(AUDIT_OBJ_TYPE,     "obj_type"     )
 _S(AUDIT_OBJ_LEV_LOW,  "obj_lev_low"  )
 _S(AUDIT_OBJ_LEV_HIGH, "obj_lev_high" )
 _S(AUDIT_SESSIONID,    "sessionid"    )
+_S(AUDIT_CONTAINERID,  "containerid"  )
 
 _S(AUDIT_DEVMAJOR,     "devmajor"     )
 _S(AUDIT_DEVMINOR,     "devminor"     )
diff --git a/lib/libaudit.c b/lib/libaudit.c
index aa8258c..2e01a22 100644
--- a/lib/libaudit.c
+++ b/lib/libaudit.c
@@ -1737,6 +1737,42 @@ int audit_rule_fieldpair_data(struct audit_rule_data **rulep, const char *pair,
 			else if (strcmp(v, "unset") == 0)
 				rule->values[rule->field_count] = 4294967295;
 			break;
+		case AUDIT_CONTAINERID: {
+			unsigned long long val;
+
+			if ((audit_get_features() &
+				AUDIT_FEATURE_BITMAP_CONTAINERID_FILTER) == 0)
+				return -EAU_FIELDNOSUPPORT;
+			if (flags != AUDIT_FILTER_EXCLUDE &&
+			    flags != AUDIT_FILTER_USER &&
+			    flags != AUDIT_FILTER_EXIT)
+				return -EAU_FIELDNOFILTER;
+			if (isdigit((char)*(v))) 
+				val = strtoull(v, NULL, 0);
+			else if (strlen(v) >= 2 && *(v)=='-' && 
+						(isdigit((char)*(v+1)))) 
+				val = strtoll(v, NULL, 0);
+			else if (strcmp(v, "unset") == 0)
+				val = ULLONG_MAX;
+			else
+				return -EAU_FIELDVALNUM;
+			if (errno)
+				return -EAU_FIELDVALNUM;
+			vlen = sizeof(unsigned long long);
+			rule->values[rule->field_count] = vlen;
+			offset = rule->buflen;
+			rule->buflen += vlen;
+			*rulep = realloc(rule, sizeof(*rule) + rule->buflen);
+			if (*rulep == NULL) {
+				free(rule);
+				audit_msg(LOG_ERR, "Cannot realloc memory!\n");
+				return -3;
+			} else {
+				rule = *rulep;
+			}
+			*(unsigned long long*)(&rule->buf[offset]) = val;
+			break;
+		}
 		case AUDIT_DEVMAJOR...AUDIT_INODE:
 		case AUDIT_SUCCESS:
 			if (flags != AUDIT_FILTER_EXIT)
diff --git a/lib/libaudit.h b/lib/libaudit.h
index b681e8d..542ec62 100644
--- a/lib/libaudit.h
+++ b/lib/libaudit.h
@@ -320,6 +320,9 @@ extern "C" {
 #ifndef AUDIT_FEATURE_BITMAP_FILTER_FS
 #define AUDIT_FEATURE_BITMAP_FILTER_FS		0x00000040
 #endif
+#ifndef AUDIT_FEATURE_BITMAP_CONTAINERID_FILTER
+#define AUDIT_FEATURE_BITMAP_CONTAINERID_FILTER 0x00000080
+#endif
 
 /* Defines for interfield comparison update */
 #ifndef AUDIT_OBJ_UID
@@ -343,6 +346,10 @@ extern "C" {
 #define AUDIT_FSTYPE 26
 #endif
 
+#ifndef AUDIT_CONTAINERID
+#define AUDIT_CONTAINERID 27
+#endif
+
 #ifndef AUDIT_COMPARE_UID_TO_OBJ_UID
 #define AUDIT_COMPARE_UID_TO_OBJ_UID   1
 #endif
diff --git a/src/auditctl-listing.c b/src/auditctl-listing.c
index f670ff9..974dcb4 100644
--- a/src/auditctl-listing.c
+++ b/src/auditctl-listing.c
@@ -25,6 +25,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include "auditctl-listing.h"
 #include "private.h"
 #include "auditctl-llist.h"
@@ -460,6 +461,26 @@ static void print_rule(const struct audit_rule_data *r)
 						audit_operator_to_symbol(op),
 						audit_fstype_to_name(
 						r->values[i]));
+			} else if (field == AUDIT_CONTAINERID) {
+				unsigned long long val;
+
+				if (r->values[i] == sizeof(unsigned long long)) {
+					val = *(unsigned long long*)(&r->buf[boffset]);
+
+					if (val != ULLONG_MAX)
+						printf(" -F %s%s%llu", name,
+							audit_operator_to_symbol(op),
+							val);
+					else
+						printf(" -F %s%s%s", name,
+							audit_operator_to_symbol(op),
+							"unset");
+				} else {
+					printf(" -F %s%s%s", name,
+						audit_operator_to_symbol(op),
+						"inval");
+				}
+				boffset += r->values[i];
 			} else {
 				// The default is signed decimal
 				printf(" -F %s%s%d", name, 
-- 
1.8.3.1
