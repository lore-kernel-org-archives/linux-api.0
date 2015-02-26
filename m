From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] capabilities: Ambient capability set V1
Date: Thu, 26 Feb 2015 15:09:48 -0600 (CST)
Message-ID: <alpine.DEB.2.11.1502261507450.8274@gentwo.org>
References: <20150224154715.GA20682@mail.hallyn.com> <alpine.DEB.2.11.1502240956400.29006@gentwo.org> <20150224164429.GB29685@ubuntumail> <alpine.DEB.2.11.1502241120270.29416@gentwo.org> <20150225033247.GC29685@ubuntumail> <alpine.DEB.2.11.1502251423580.13489@gentwo.org>
 <20150226153524.GC15182@mail.hallyn.com> <alpine.DEB.2.11.1502261224580.7451@gentwo.org> <20150226193200.GA17709@mail.hallyn.com> <alpine.DEB.2.11.1502261412250.7451@gentwo.org> <20150226203405.GB18926@mail.hallyn.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150226203405.GB18926@mail.hallyn.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Serge Hallyn <serge.hallyn@canonical.com>, Andy Lutomirski <luto@amacapital.net>, Aaron Jones <aaronmdjones@gmail.com>, Ted Ts'o <tytso@mit.edu>, linux-security-module@vger.kernel.org, akpm@linuxfoundation.org, "Andrew G. Morgan" <morgan@kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Markku Savela <msa@moth.iki.fi>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Thu, 26 Feb 2015, Serge E. Hallyn wrote:

> > Same problem as before. The ambient bits will not be set in pE'.
>
> And what if I weren't scatterbrained and we did
>
>  	if (pA)
>  		pE' = pP'
>  	else
>  		pE' = pP' & fE
>
> All pP' bits would be set in pE'.

Ok and the non ambient case would break because fE is not available?
Doesnt this reduce to

pE' = pP'

in either case?

Here is a a patch that does just that. The patch works. Maybe I just dont
understand how this is supposed to work.

Subject: [PATCH] capabilities: Ambient capability set V2(draft)

V1->V2(draft):
 - Modify bit calculations.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/security/commoncap.c
===================================================================
--- linux.orig/security/commoncap.c	2015-02-25 13:43:06.929973954 -0600
+++ linux/security/commoncap.c	2015-02-26 12:36:32.361726374 -0600
@@ -347,15 +347,16 @@ static inline int bprm_caps_from_vfs_cap
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
+			(new->cap_inheritable.cap[i] & (inheritable | ambient));

 		if (permitted & ~new->cap_permitted.cap[i])
 			/* insufficient to execute correctly */
@@ -453,8 +454,12 @@ static int get_file_caps(struct linux_bi
 		if (rc == -EINVAL)
 			printk(KERN_NOTICE "%s: get_vfs_caps_from_disk returned %d for %s\n",
 				__func__, rc, bprm->filename);
-		else if (rc == -ENODATA)
+		else if (rc == -ENODATA) {
 			rc = 0;
+			/* The ambient caps are permitted for files that have no caps */
+			bprm->cred->cap_permitted = bprm->cred->cap_effective =
+				current_cred()->cap_ambient;
+		}
 		goto out;
 	}

@@ -548,10 +553,16 @@ skip:
 	new->suid = new->fsuid = new->euid;
 	new->sgid = new->fsgid = new->egid;

-	if (effective)
-		new->cap_effective = new->cap_permitted;
-	else
-		cap_clear(new->cap_effective);
+	/* pE' = pP' & (fE | pA)
+	new->cap_effective = cap_intersect(new->cap_permitted,
+			cap_combine(new->cap_effective, old->cap_ambient));
+	 */
+
+	/* fE is not available */
+	new->cap_effective = new->cap_permitted;
+
+	/* pA' = pA */
+	new->cap_ambient = old->cap_ambient;
 	bprm->cap_effective = effective;

 	/*
@@ -566,7 +577,7 @@ skip:
 	 * Number 1 above might fail if you don't have a full bset, but I think
 	 * that is interesting information to audit.
 	 */
-	if (!cap_isclear(new->cap_effective)) {
+	if (!cap_issubset(new->cap_effective, new->cap_ambient)) {
 		if (!cap_issubset(CAP_FULL_SET, new->cap_effective) ||
 		    !uid_eq(new->euid, root_uid) || !uid_eq(new->uid, root_uid) ||
 		    issecure(SECURE_NOROOT)) {
@@ -598,7 +609,7 @@ int cap_bprm_secureexec(struct linux_bin
 	if (!uid_eq(cred->uid, root_uid)) {
 		if (bprm->cap_effective)
 			return 1;
-		if (!cap_isclear(cred->cap_permitted))
+		if (!cap_issubset(cred->cap_permitted, cred->cap_ambient))
 			return 1;
 	}

@@ -933,6 +944,23 @@ int cap_task_prctl(int option, unsigned
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
