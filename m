From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] capabilities: Ambient capability set V2
Date: Thu, 26 Feb 2015 16:14:33 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502261612370.8994@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


V1->V2:
 - Fix up the processing of the caps bits after discussions
   with Any and Serge. Make patch less intrusive.

Ambient caps are something like restricted root privileges.
A process has a set of additional capabilities and those
are inherited without have to set capabilites in other
binaries involved. This allow the partial use of root
like features in a controlled way. It is often useful
to do this for user space device drivers or software that
needs increased priviledges for networking or to control
its own scheduling. Ambient caps allow one to avoid
having to run these with full root priviledges.

Control over this feature is avaialable via a new
prctl option called PR_CAP_AMBIENT. The second argument to prctl
is a the capability number and the third the desired state.
0 for off. Otherwise on.

Ambient bits are enabled regardless of the inheritance
mask of the target binary. They are only restricted
by the bounding set.

History:

Linux capabilities have suffered from the problem that they are not
inheritable like unregular process characteristics under Unix. This is
behavior that is counter intuitive to the expected behavior of processes
in Unix.

In particular there has been recently software that controls NICs from user
space and provides IP stack like behavior also in user space (DPDK and RDMA
kernel API based implementations). Those typically need either capabilities
to allow raw network access or have to be run setsuid. There is scripting and
LD_PREFLOAD etc involved, arbitrary binaries may be run from those scripts
including those setting additional capabilites or requiring root access.

That does not go well with having file capabilities set that would enable
the capabilities. Maybe it would work if one would setup capabilities on
all executables but that would also defeat a secure design since these
binaries may only need those caps for certain situations. Ok setting the
inheritable flags on everything may also get one there (if there would not
be the issues with LD_PRELOAD, debugging etc etc).

The easy solution is to allow some capabilities be inherited like setsuid
is. We really prefer to use capabilities instead of setsuid (we want to
limit what damage someone can do after all!). Therefore we have been
running a patch like this in production for the last 6 years. At some
point it becomes tedious to run your own custom kernel so we would like
to have this functionality upstream.

See some of the earlier related discussions on the problems with capability
inheritance:

0. Recent surprise:
                https://lkml.org/lkml/2014/1/21/175

1. Attempt to revise caps
                http://www.madore.org/~david/linux/newcaps/

2. Problems of passing caps through exec
                http://unix.stackexchange.com/questions/128394/passing-capabilities-through-exec

3. Problems of binding to privileged ports
                http://stackoverflow.com/questions/413807/is-there-a-way-for-non-root-processes-to-bind-to-privileged-ports-1024-on-l

4. Reviving capabilities
                http://lwn.net/Articles/199004/

There does not seem to be an alternative on the horizon. Some involved
in security development under Linux have even stated that they want to
rip out the whole thing and replace it. Its been a couple of years now
and we are still suffering from the capabilities mess. Let us just
fix it. Others have already done implementations like this like Nokia
for the N900.


This patch does not change the default behavior but it allows to set up
a list of capabilities via prctl that will enable regular
unix inheritance only for the selected group of capabilities.

With that it is then possible to do something trivial like setting
CAP_NET_RAW on an executable that can then allow that capability to
be inherited by others.

Lets have a look at a coding example of a wrapper that enables
a couple of capabilities:

------------------------------ ambient_test.c
/*
 * Test program for the ambient capabilities
 *
 *
 * Compile using:
 *	gcc -o ambient_test ambient_test.o
 *
 * This program must have the following capabilities to run properly:
 * CAP_SETPCAP, CAP_NET_RAW, CAP_NET_ADMIN, CAP_SYS_NICE
 *
 * A command to equip this with the right caps is:
 *
 *	setcap cap_setpcap,cap_net_raw,cap_net_admin,cap_sys_nice+eip ambient_test
 *
 * To get a shell with additional caps that can be inherited do:
 *
 * ./ambient_test /bin/bash
 *
 */

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <sys/prctl.h>
#include <linux/capability.h>

/* Defintion to be updated in the user space include files */
#define PR_CAP_AMBIENT 45

int main(int argc, char **argv)
{
	int rc;

	if (prctl(PR_CAP_AMBIENT, CAP_NET_RAW))
		perror("Cannot set CAP_NET_RAW");

	if (prctl(PR_CAP_AMBIENT, CAP_NET_ADMIN))
		perror("Cannot set CAP_NET_ADMIN");

	if (prctl(PR_CAP_AMBIENT, CAP_SYS_NICE))
		perror("Cannot set CAP_SYS_NICE");

	printf("Ambient_test forking shell\n");
	if (execv(argv[1], argv + 1))
		perror("Cannot exec");

	return 0;
}
-------------------------------- ambient_test.c

Allows the inheritance of CAP_SYS_NICE, CAP_NET_RAW and CAP_NET_ADMIN.
With that device raw access is possible and also real time priorities
can be set from user space. This is a frequently needed set of
priviledged operations in HPC and HFT applications. User space
processes need to be able to directly access devices as well as
have full control over scheduling.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/security/commoncap.c
===================================================================
--- linux.orig/security/commoncap.c	2015-02-25 13:43:06.929973954 -0600
+++ linux/security/commoncap.c	2015-02-26 16:10:02.347913397 -0600
@@ -347,15 +347,17 @@ static inline int bprm_caps_from_vfs_cap
 		*has_cap = true;

 	CAP_FOR_EACH_U32(i) {
+		__u32 ambient = current_cred()->cap_ambient.cap[i];
 		__u32 permitted = caps->permitted.cap[i];
 		__u32 inheritable = caps->inheritable.cap[i];

 		/*
-		 * pP' = (X & fP) | (pI & fI)
+		 * pP' = (X & fP) | (pI & (fI | pA))
 		 */
 		new->cap_permitted.cap[i] =
 			(new->cap_bset.cap[i] & permitted) |
-			(new->cap_inheritable.cap[i] & inheritable);
+			(new->cap_inheritable.cap[i] &
+					(inheritable | ambient));

 		if (permitted & ~new->cap_permitted.cap[i])
 			/* insufficient to execute correctly */
@@ -453,8 +455,18 @@ static int get_file_caps(struct linux_bi
 		if (rc == -EINVAL)
 			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
 				__func__, rc, bprm->filename);
-		else if (rc == -ENODATA)
+		else if (rc == -ENODATA) {
 			rc = 0;
+			if (!cap_isclear(current_cred()->cap_ambient)) {
+				/*
+				 * The ambient caps are permitted for
+				 * files that have no caps
+				 */
+				bprm->cred->cap_permitted =
+					current_cred()->cap_ambient;
+				*effective = true;
+			}
+		}
 		goto out;
 	}

@@ -549,9 +561,20 @@ skip:
 	new->sgid = new->fsgid = new->egid;

 	if (effective)
+		/*
+		 * pE' = pP' & (fE | pA)
+		 *
+		 * fE is implicity all set if effective == true.
+		 * Therefore the above reduces to
+		 *
+		 * pE' = pP'
+		 */
 		new->cap_effective = new->cap_permitted;
 	else
 		cap_clear(new->cap_effective);
+
+	/* pA' = pA */
+	new->cap_ambient = old->cap_ambient;
 	bprm->cap_effective = effective;

 	/*
@@ -566,7 +589,7 @@ skip:
 	 * Number 1 above might fail if you don't have a full bset, but I think
 	 * that is interesting information to audit.
 	 */
-	if (!cap_isclear(new->cap_effective)) {
+	if (!cap_issubset(new->cap_effective, new->cap_ambient)) {
 		if (!cap_issubset(CAP_FULL_SET, new->cap_effective) ||
 		    !uid_eq(new->euid, root_uid) || !uid_eq(new->uid, root_uid) ||
 		    issecure(SECURE_NOROOT)) {
@@ -598,7 +621,7 @@ int cap_bprm_secureexec(struct linux_bin
 	if (!uid_eq(cred->uid, root_uid)) {
 		if (bprm->cap_effective)
 			return 1;
-		if (!cap_isclear(cred->cap_permitted))
+		if (!cap_issubset(cred->cap_permitted, cred->cap_ambient))
 			return 1;
 	}

@@ -933,6 +956,23 @@ int cap_task_prctl(int option, unsigned
 			new->securebits &= ~issecure_mask(SECURE_KEEP_CAPS);
 		return commit_creds(new);

+	case PR_CAP_AMBIENT:
+		if (!ns_capable(current_user_ns(), CAP_SETPCAP))
+			return -EPERM;
+
+		if (!cap_valid(arg2))
+			return -EINVAL;
+
+		if (!ns_capable(current_user_ns(), arg2))
+			return -EPERM;
+
+		new = prepare_creds();
+		if (arg3 == 0)
+			cap_lower(new->cap_ambient, arg2);
+		else
+			cap_raise(new->cap_ambient, arg2);
+		return commit_creds(new);
+
 	default:
 		/* No functionality available - continue with default */
 		return -ENOSYS;
Index: linux/include/linux/cred.h
===================================================================
--- linux.orig/include/linux/cred.h	2015-02-25 13:43:06.929973954 -0600
+++ linux/include/linux/cred.h	2015-02-25 13:43:06.925972078 -0600
@@ -122,6 +122,7 @@ struct cred {
 	kernel_cap_t	cap_permitted;	/* caps we're permitted */
 	kernel_cap_t	cap_effective;	/* caps we can actually use */
 	kernel_cap_t	cap_bset;	/* capability bounding set */
+	kernel_cap_t	cap_ambient;	/* Ambient capability set */
 #ifdef CONFIG_KEYS
 	unsigned char	jit_keyring;	/* default keyring to attach requested
 					 * keys to */
Index: linux/include/uapi/linux/prctl.h
===================================================================
--- linux.orig/include/uapi/linux/prctl.h	2015-02-25 13:43:06.929973954 -0600
+++ linux/include/uapi/linux/prctl.h	2015-02-25 13:43:06.925972078 -0600
@@ -185,4 +185,7 @@ struct prctl_mm_map {
 #define PR_MPX_ENABLE_MANAGEMENT  43
 #define PR_MPX_DISABLE_MANAGEMENT 44

+/* Control the ambient capability set */
+#define PR_CAP_AMBIENT 45
+
 #endif /* _LINUX_PRCTL_H */
Index: linux/fs/proc/array.c
===================================================================
--- linux.orig/fs/proc/array.c	2015-02-25 13:43:06.929973954 -0600
+++ linux/fs/proc/array.c	2015-02-25 13:43:06.925972078 -0600
@@ -302,7 +302,8 @@ static void render_cap_t(struct seq_file
 static inline void task_cap(struct seq_file *m, struct task_struct *p)
 {
 	const struct cred *cred;
-	kernel_cap_t cap_inheritable, cap_permitted, cap_effective, cap_bset;
+	kernel_cap_t cap_inheritable, cap_permitted, cap_effective,
+			cap_bset, cap_ambient;

 	rcu_read_lock();
 	cred = __task_cred(p);
@@ -310,12 +311,14 @@ static inline void task_cap(struct seq_f
 	cap_permitted	= cred->cap_permitted;
 	cap_effective	= cred->cap_effective;
 	cap_bset	= cred->cap_bset;
+	cap_ambient	= cred->cap_ambient;
 	rcu_read_unlock();

 	render_cap_t(m, "CapInh:\t", &cap_inheritable);
 	render_cap_t(m, "CapPrm:\t", &cap_permitted);
 	render_cap_t(m, "CapEff:\t", &cap_effective);
 	render_cap_t(m, "CapBnd:\t", &cap_bset);
+	render_cap_t(m, "CapAmb:\t", &cap_ambient);
 }

 static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
