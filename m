From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: [REVIEW][PATCH 12/11] ipc: Directly call the security hook in
	ipc_ops.associate
Date: Sat, 24 Mar 2018 00:40:36 -0500
Message-ID: <877eq2m3or.fsf_-_@xmission.com>
References: <1520875093-18174-1-git-send-email-nagarathnam.muthusamy@oracle.com>
	<87vadzqqq6.fsf@xmission.com>
	<990e88fa-ab50-9645-b031-14e1afbf7ccc@oracle.com>
	<877eqejowd.fsf@xmission.com>
	<3a46a03d-e4dd-59b6-e25f-0020be1b1dc9@oracle.com>
	<87a7v2z2qa.fsf@xmission.com> <87vadmobdw.fsf_-_@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <87vadmobdw.fsf_-_-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> (Eric W. Biederman's message of
	"Fri, 23 Mar 2018 14:11:23 -0500")
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, prakash.sangappa-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Nagarathnam Muthusamy <nagarathnam.muthusamy-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org


After the last round of cleanups the shm, sem, and msg associate
operations just became trivial wrappers around the appropriate security
method.  Simplify things further by just calling the security method
directly.

Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
---
 ipc/msg.c | 10 +---------
 ipc/sem.c | 10 +---------
 ipc/shm.c | 10 +---------
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 825ad585a6ff..d667dd8e97ab 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -272,20 +272,12 @@ static void freeque(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 	ipc_rcu_putref(&msq->q_perm, msg_rcu_free);
 }
 
-/*
- * Called with msg_ids.rwsem and ipcp locked.
- */
-static inline int msg_security(struct kern_ipc_perm *ipcp, int msgflg)
-{
-	return security_msg_queue_associate(ipcp, msgflg);
-}
-
 SYSCALL_DEFINE2(msgget, key_t, key, int, msgflg)
 {
 	struct ipc_namespace *ns;
 	static const struct ipc_ops msg_ops = {
 		.getnew = newque,
-		.associate = msg_security,
+		.associate = security_msg_queue_associate,
 	};
 	struct ipc_params msg_params;
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 47b263960524..09d54af076a4 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -564,14 +564,6 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 }
 
 
-/*
- * Called with sem_ids.rwsem and ipcp locked.
- */
-static inline int sem_security(struct kern_ipc_perm *ipcp, int semflg)
-{
-	return security_sem_associate(ipcp, semflg);
-}
-
 /*
  * Called with sem_ids.rwsem and ipcp locked.
  */
@@ -592,7 +584,7 @@ SYSCALL_DEFINE3(semget, key_t, key, int, nsems, int, semflg)
 	struct ipc_namespace *ns;
 	static const struct ipc_ops sem_ops = {
 		.getnew = newary,
-		.associate = sem_security,
+		.associate = security_sem_associate,
 		.more_checks = sem_more_checks,
 	};
 	struct ipc_params sem_params;
diff --git a/ipc/shm.c b/ipc/shm.c
index 932b7e411c6c..018db3d0e70e 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -656,14 +656,6 @@ static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 	return error;
 }
 
-/*
- * Called with shm_ids.rwsem and ipcp locked.
- */
-static inline int shm_security(struct kern_ipc_perm *ipcp, int shmflg)
-{
-	return security_shm_associate(ipcp, shmflg);
-}
-
 /*
  * Called with shm_ids.rwsem and ipcp locked.
  */
@@ -684,7 +676,7 @@ SYSCALL_DEFINE3(shmget, key_t, key, size_t, size, int, shmflg)
 	struct ipc_namespace *ns;
 	static const struct ipc_ops shm_ops = {
 		.getnew = newseg,
-		.associate = shm_security,
+		.associate = security_shm_associate,
 		.more_checks = shm_more_checks,
 	};
 	struct ipc_params shm_params;
-- 
2.14.1
