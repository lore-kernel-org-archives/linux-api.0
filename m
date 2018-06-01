From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH 3/5] ipc: get rid of ids->tables_initialized hack
Date: Fri,  1 Jun 2018 09:01:23 -0700
Message-ID: <20180601160125.30031-4-dave@stgolabs.net>
References: <20180601160125.30031-1-dave@stgolabs.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601160125.30031-1-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: tgraf@suug.ch, herbert@gondor.apana.org.au, manfred@colorfullife.com, mhocko@kernel.org, guillaume.knispel@supersonicimagine.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-api@vger.kernel.org

In sysvipc we have an ids->tables_initialized regarding the
rhashtable, introduced in:

    0cfb6aee70b (ipc: optimize semget/shmget/msgget for lots of keys).

It's there, specifically, to prevent nil pointer dereferences,
from using an uninitialized api. Considering how rhashtable_init()
can fail (probably due to ENOMEM, if anything), this made the
overall ipc initialization capable of failure as well. That alone
is ugly, but fine, however I've spotted a few issues regarding the
semantics of tables_initialized (however unlikely they may be):

- There is inconsistency in what we return to userspace: ipc_addid()
returns ENOSPC which is certainly _wrong_, while ipc_obtain_object_idr()
returns EINVAL.

- After we started using rhashtables, ipc_findkey() can return nil upon
!tables_initialized, but the caller expects nil for when the ipc structure
isn't found, and can therefore call into ipcget() callbacks.

Now that rhashtable initialization cannot fail, we can properly
get rid of the hack altogether.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/ipc_namespace.h |  1 -
 ipc/util.c                    | 23 ++++++++---------------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index b5630c8eb2f3..37f3a4b7c637 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -16,7 +16,6 @@ struct user_namespace;
 struct ipc_ids {
 	int in_use;
 	unsigned short seq;
-	bool tables_initialized;
 	struct rw_semaphore rwsem;
 	struct idr ipcs_idr;
 	int max_id;
diff --git a/ipc/util.c b/ipc/util.c
index 4e81182fa0ac..823e09e72c58 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -125,7 +125,6 @@ int ipc_init_ids(struct ipc_ids *ids)
 	if (err)
 		return err;
 	idr_init(&ids->ipcs_idr);
-	ids->tables_initialized = true;
 	ids->max_id = -1;
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	ids->next_id = -1;
@@ -178,19 +177,16 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
  */
 static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 {
-	struct kern_ipc_perm *ipcp = NULL;
+	struct kern_ipc_perm *ipcp;
 
-	if (likely(ids->tables_initialized))
-		ipcp = rhashtable_lookup_fast(&ids->key_ht, &key,
+	ipcp = rhashtable_lookup_fast(&ids->key_ht, &key,
 					      ipc_kht_params);
+	if (!ipcp)
+		return NULL;
 
-	if (ipcp) {
-		rcu_read_lock();
-		ipc_lock_object(ipcp);
-		return ipcp;
-	}
-
-	return NULL;
+	rcu_read_lock();
+	ipc_lock_object(ipcp);
+	return ipcp;
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
@@ -255,7 +251,7 @@ int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int limit)
 	if (limit > IPCMNI)
 		limit = IPCMNI;
 
-	if (!ids->tables_initialized || ids->in_use >= limit)
+	if (ids->in_use >= limit)
 		return -ENOSPC;
 
 	idr_preload(GFP_KERNEL);
@@ -566,9 +562,6 @@ struct kern_ipc_perm *ipc_obtain_object_idr(struct ipc_ids *ids, int id)
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
 
-	if (unlikely(!ids->tables_initialized))
-		return ERR_PTR(-EINVAL);
-
 	out = idr_find(&ids->ipcs_idr, lid);
 	if (!out)
 		return ERR_PTR(-EINVAL);
-- 
2.16.3
