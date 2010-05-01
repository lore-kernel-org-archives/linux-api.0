From: Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v21 002/100] eclone (2/11): Have alloc_pidmap() return actual
	error code
Date: Sat,  1 May 2010 10:14:44 -0400
Message-ID: <1272723382-19470-3-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Matt Helsley <matthltc@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

alloc_pidmap() can fail either because all pid numbers are in use or
because memory allocation failed.  With support for setting a specific
pid number, alloc_pidmap() would also fail if either the given pid
number is invalid or in use.

Rather than have callers assume -ENOMEM, have alloc_pidmap() return
the actual error.

Changelog[v1]:
	- [Oren Laadan] Rebase to kernel 2.6.33

Cc: linux-api@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/fork.c |    5 +++--
 kernel/pid.c  |   10 ++++++----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 44b0791..afdfb08 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1147,10 +1147,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_io;
 
 	if (pid != &init_struct_pid) {
-		retval = -ENOMEM;
 		pid = alloc_pid(p->nsproxy->pid_ns);
-		if (!pid)
+		if (IS_ERR(pid)) {
+			retval = PTR_ERR(pid);
 			goto bad_fork_cleanup_io;
+		}
 
 		if (clone_flags & CLONE_NEWPID) {
 			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
diff --git a/kernel/pid.c b/kernel/pid.c
index 52a371a..8330488 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -160,7 +160,7 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	for (i = 0; i <= max_scan; ++i) {
 		if (unlikely(!map->page))
 			if (alloc_pidmap_page(map) < 0)
-				break;
+				return -ENOMEM;
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
@@ -191,7 +191,7 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
-	return -1;
+	return -EBUSY;
 }
 
 int next_pidmap(struct pid_namespace *pid_ns, int last)
@@ -260,8 +260,10 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 	struct upid *upid;
 
 	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
-	if (!pid)
+	if (!pid) {
+		pid = ERR_PTR(-ENOMEM);
 		goto out;
+	}
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
@@ -295,7 +297,7 @@ out_free:
 		free_pidmap(pid->numbers + i);
 
 	kmem_cache_free(ns->pid_cachep, pid);
-	pid = NULL;
+	pid = ERR_PTR(nr);
 	goto out;
 }
 
-- 
1.6.3.3
