From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to avoid DoS
Date: Wed, 18 Sep 2019 21:22:23 -0400
Message-ID: <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com, nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com, Richard Guy Briggs <rgb@redhat.com>
List-Id: linux-api@vger.kernel.org

Set an arbitrary limit on the number of audit container identifiers to
limit abuse.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/audit.c | 8 ++++++++
 kernel/audit.h | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 53d13d638c63..329916534dd2 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -139,6 +139,7 @@ struct audit_net {
 struct list_head audit_inode_hash[AUDIT_INODE_BUCKETS];
 /* Hash for contid-based rules */
 struct list_head audit_contid_hash[AUDIT_CONTID_BUCKETS];
+int audit_contid_count = 0;
 
 static struct kmem_cache *audit_buffer_cache;
 
@@ -2384,6 +2385,7 @@ void audit_cont_put(struct audit_cont *cont)
 		put_task_struct(cont->owner);
 		list_del_rcu(&cont->list);
 		kfree_rcu(cont, rcu);
+		audit_contid_count--;
 	}
 }
 
@@ -2456,6 +2458,11 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 					goto conterror;
 				}
 			}
+		/* Set max contids */
+		if (audit_contid_count > AUDIT_CONTID_COUNT) {
+			rc = -ENOSPC;
+			goto conterror;
+		}
 		if (!newcont) {
 			newcont = kmalloc(sizeof(struct audit_cont), GFP_ATOMIC);
 			if (newcont) {
@@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
 				newcont->owner = current;
 				refcount_set(&newcont->refcount, 1);
 				list_add_rcu(&newcont->list, &audit_contid_hash[h]);
+				audit_contid_count++;
 			} else {
 				rc = -ENOMEM;
 				goto conterror;
diff --git a/kernel/audit.h b/kernel/audit.h
index 162de8366b32..543f1334ba47 100644
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
 	return (contid & (AUDIT_CONTID_BUCKETS-1));
 }
 
+extern int audit_contid_count;
+
+#define AUDIT_CONTID_COUNT	1 << 16
+
 /* Indicates that audit should log the full pathname. */
 #define AUDIT_NAME_FULL -1
 
-- 
1.8.3.1
