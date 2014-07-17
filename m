From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: [tytso-DPNOqEs/LNQ@public.gmane.org: [PATCH, RFC] random: introduce getrandom(2) system
 call]
Date: Thu, 17 Jul 2014 16:25:22 -0400
Message-ID: <20140717202522.GR1491@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Sorry, I typo'ed the mailing list for linux-api originally....

       	 	     	     	      		- Ted


--opJtzjQTFsWo+cga
Content-Type: message/rfc822
Content-Disposition: inline

Return-path: <tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Envelope-to: mit-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org
Delivery-date: Thu, 17 Jul 2014 09:18:40 +0000
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34])
	by imap.thunk.org with esmtp (Exim 4.80)
	(envelope-from <tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>)
	id 1X7hpo-0002WW-41
	for mit-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org; Thu, 17 Jul 2014 09:18:40 +0000
Received: from mailhub-dmz-2.mit.edu ( [18.7.62.37])
	(using TLS with cipher AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by dmz-mailsec-scanner-5.mit.edu (Symantec Messaging Gateway) with SMTP id FD.AA.29976.AE497C35; Thu, 17 Jul 2014 05:18:34 -0400 (EDT)
Received: from dmz-mailsec-scanner-8.mit.edu (dmz-mailsec-scanner-8.mit.edu [18.7.68.37])
	by mailhub-dmz-2.mit.edu (8.13.8/8.9.2) with ESMTP id s6H9HvjU022645
	for <tytso-3s7WtUTddSA@public.gmane.org>; Thu, 17 Jul 2014 05:18:34 -0400
X-AuditID: 12074422-f79be6d000007518-d1-53c794eadb02
Authentication-Results: symauth.service.identifier
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97])
	(using TLS with cipher AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by dmz-mailsec-scanner-8.mit.edu (Symantec Messaging Gateway) with SMTP id 2D.B0.28072.AE497C35; Thu, 17 Jul 2014 05:18:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org; s=ef5046eb;
	h=Message-Id:Date:Subject:Cc:To:From; bh=bDp+OrE51ZaENnM24z0a8lDCcq48UPdDxYeJ9IvTet4=;
	b=b8GhC/PfPTQQ6jeRjrk9u4ywTo3ZPuxnX4CYGHDpT8Jd89Yj3Gg6lGk3dxFg2LKjECPdesmrX16b3ULxFrkX/BYxqFBEV1dNYi1ounLePPKL0QsJ5lh4e4ucENQEEbUU+L84S9Z1xXDglUue8wIrBUX+12WrkUJcykxlD9e2Nsg=;
Received: from root (helo=closure.thunk.org)
	by imap.thunk.org with local-esmtp (Exim 4.80)
	(envelope-from <tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>)
	id 1X7hpg-0002WP-58; Thu, 17 Jul 2014 09:18:32 +0000
Received: by closure.thunk.org (Postfix, from userid 15806)
	id 392225807F2; Thu, 17 Jul 2014 05:18:26 -0400 (EDT)
From: "Theodore Ts'o" <tytso-DPNOqEs/LNQ@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-abi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org,
        "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Date: Thu, 17 Jul 2014 05:18:15 -0400
Message-Id: <1405588695-12014-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
X-Mailer: git-send-email 2.0.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixG6nqvtqyvFgg51/jS3ud3UxOzB6tOy/
	xhbAGMVlk5Kak1mWWqRvl8CVMeXuO/aCX84Va2dcZmpgvGTexcjJISFgIjG39xAzhC0mceHe
	erYuRi4OIYFZTBKXP++Bcq4zShxoWMsK03Hl9wN2EJtRwEhi97lXrBBFS5gkDkzYygjisAg8
	YZLoePGCHSKzg1Fi6ZX5TCAtQgLFEmsO9IGNYhNQldiy6j9YXERAQWJz7zOwOLNAucS55o1g
	cWEBB4kdH5sZQWwWoPr7Pf1gNbwCthIHlp6HOklOouHGJzYIW1Pi4KVNLBC2isTBDd+hnvOS
	eL/tEhPIQRICh9gl/u/7xD6BUXQBI8MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXVO93MwSvdSU
	0k2M4GB2UdrB+POg0iFGAQ5GJR7ene3HgoVYE8uKK3MPMUpyMCmJ8upNOB4sxJeUn1KZkVic
	EV9UmpNafIhRgoNZSYR3WxdQjjclsbIqtSgfJiXNwaIkzvvW2ipYSCA9sSQ1OzW1ILUIJivD
	waEkwas4GahRsCg1PbUiLTOnBCHNxMEJMpwHaHgaSA1vcUFibnFmOkT+FKOilDhv2iSghABI
	IqM0D64XlmxeMYoDvSLMGwfSzgNMVHDdr4AGMwENli4HG1ySiJCSamDUbf+edrRKOfrj0s4K
	Y9246FpGFulKL+nQsI1LHPSfv9zevip4+fTC30wSjN4PDmiZhT5Ou73ylH7VouaeOZdfXnhr
	0HepVvBP95IFG1LEZ9x7qbJX4fHaY09jq6yfFaosXecZ8+3h0UwX+bkvls33lLl5c6JUf9BC
	lmbpgKd2swyZJv3IXhaoxFKckWioxVxUnAgA734mehEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRWlGSWpSXmKPExsXidf5Vou6rKceDDb7vFrBo7fnJ7sDo0XTm
	KHMAYxSXTUpqTmZZapG+XQJXxpS779gLfjlXrJ1xmamB8ZJ5FyMnh4SAicSV3w/YQWxGASOJ
	3edesULExSQu3FvP1sXIxSEksIRJ4sCErYwgDovAEyaJjhcv2CEyOxglll6ZzwTSIiRQLLHm
	QB9YO5uAssTduacZQWwRAQWJzb3PwOLMAkUST+Y+BasXFnCQ2PGxGayGRUBV4n5PP1gNr4Ct
	xIGl56HOkJNouPGJDcLWlDh4aRMLhK0icXDDd2YI20vi/bZLTBMYBRcwMqxilE3JrdLNTczM
	KU5N1i1OTszLSy3StdDLzSzRS00p3cQIDDMhdhfVHYwTDikdYhTgYFTi4d3ZfixYiDWxrLgy
	9xCjJAeTkiiv3oTjwUJ8SfkplRmJxRnxRaU5qcWHGCU4mJVEeLd1AeV4UxIrq1KL8mFS0hws
	SuK8b62tgoUE0hNLUrNTUwtSi2CyTBzshxhlODiUJHhZgZElJFiUmp5akZaZU4KshhNEcIGs
	4QFaIwVSyFtckJhbnJkOUXSKUVFKnPfMZKCEAEgiozQPbgAsNVxilJUS5mVkYGAQ4gG6AOhx
	VPlXjOJATwvzioKM58nMK4Gb/gpoMRPQYulysMUliQgpqQbGCKYAboO9OvnKulMl5zlkKZYa
	POZXCjL14vvmM/2rV//ftLUbuO9Or7n11usM58Vd5XffN6mFPDe7cPsQc836HZdFhK9zJYQ8
	tj5oNsVsvfmi7RPMji5Iv7rJMbLab+kzO54zQbNDjyiufPHox7Iqlei4nrn/lv/0WqpiI8V5
	iHubQ983X/fzSizFGYmGWsxFxYkAELp8BQgDAAA=
X-SA-Exim-Connect-IP: 18.7.68.34
X-SA-Exim-Mail-From: tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on imap.thunk.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	RCVD_IN_DNSWL_BLOCKED,SPF_SOFTFAIL,T_DKIM_INVALID,URIBL_BLOCKED autolearn=no
	version=3.3.2
Subject: [PATCH, RFC] random: introduce getrandom(2) system call
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on imap.thunk.org)

The getrandom(2) system call was requested by the LibreSSL Portable
developers.  It is analoguous to the getentropy(2) system call in
OpenBSD.

The rationale of this system call is to provide resiliance against
file descriptor exhaustion attacks, where the attacker consumes all
available file descriptors, forcing the use of the fallback code where
/dev/[u]random is not available.  Since the fallback code is often not
well-tested, it is better to eliminate this potential failure mode
entirely.

The other feature provided by this new system call is the ability to
request randomness from the /dev/urandom entropy pool, but to block
until at least 128 bits of entropy has been accumulated in the
/dev/urandom entropy pool.  Historically, the emphasis in the
/dev/urandom development has been to ensure that urandom pool is
initialized as quickly as possible after system boot, and preferably
before the init scripts start execution.  This is because changing
/dev/urandom reads to block represents an interface change that could
potentially break userspace which is not acceptable.  In practice, on
most x86 desktop and server systems, in general the entropy pool can
be initialized before it is needed (and in modern kernels, we will
printk a warning message if not).  However, on an embedded system,
this may not be hte case.  And so with a new interface, we can provide
this requested functionality of blocking until the urandom pool has
been initialized.  Any userspace program which uses this new
functionality must make sure that if it is used in early boot, that it
will not cause the boot up scripts or other portions of the system
startup to hang indefinitely.

SYNOPSIS
	#include <linux/random.h>

	int getrandom(void *buf, size_t buflen, unsigned int flags);

DESCRIPTION

	The system call getrandom() fills the buffer pointed to by buf
	with up to buflen random bytes which can be used to seed user
	space random number generators (i.e., DRBG's) or for other
	cryptographic processes.  It should not be used Monte Carlo
	simulations or for other probabilistic sampling applications.

	If the GRND_RANDOM flags bit is set, then draw from the
	/dev/random pool instead of /dev/urandom pool.  The
	/dev/random pool is limited based on the entropy that can be
	obtained from environmental noise, so if there is insufficient
	entropy, the requested number of bytes may not be returned.
	If there is no entropy available at all, getrandom(2) will
	either return an error with errno set to EAGAIN, or block if
	the GRND_BLOCK flags bit is set.

	If the GRND_RANDOM flags bit is not set, then the /dev/raundom
	pool will be used.  Unlike reading from the /dev/urandom, if
	the urandom pool has not been sufficiently initialized,
	getrandom(2) will either return an error with errno set to
	EGAIN, or block if the GRND_BLOCK flags bit is set.

RETURN VALUE
       On success, the number of bytes that was returned is returned.

       On error, -1 is returned, and errno is set appropriately

ERRORS
	EINVAL		The buflen value was invalid.

	EFAULT		buf is outside your accessible address space.

	EAGAIN		The requested entropy was not available, and the
			getentropy(2) would have blocked if GRND_BLOCK flag
			was set.

Signed-off-by: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
---
 arch/x86/syscalls/syscall_32.tbl  |  1 +
 arch/x86/syscalls/syscall_64.tbl  |  1 +
 drivers/char/random.c             | 35 +++++++++++++++++++++++++++++++++--
 include/linux/syscalls.h          |  3 +++
 include/uapi/asm-generic/unistd.h |  4 +++-
 include/uapi/linux/random.h       |  9 +++++++++
 6 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index d6b8679..f484e39 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -360,3 +360,4 @@
 351	i386	sched_setattr		sys_sched_setattr
 352	i386	sched_getattr		sys_sched_getattr
 353	i386	renameat2		sys_renameat2
+354	i386	getrandom		sys_getrandom
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index ec255a1..6705032 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -323,6 +323,7 @@
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
 316	common	renameat2		sys_renameat2
+317	common	getrandom		sys_getrandom
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/drivers/char/random.c b/drivers/char/random.c
index aa22fe5..76a56f6 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -258,6 +258,8 @@
 #include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
+#include <linux/syscalls.h>
+#include <linux/completion.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -469,6 +471,8 @@ static struct entropy_store nonblocking_pool = {
 					push_to_pool),
 };
 
+DECLARE_COMPLETION(urandom_initialized);
+
 static __u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
@@ -657,6 +661,7 @@ retry:
 		r->entropy_total = 0;
 		if (r == &nonblocking_pool) {
 			prandom_reseed_late();
+			complete_all(&urandom_initialized);
 			pr_notice("random: %s pool is initialized\n", r->name);
 		}
 	}
@@ -1355,7 +1360,7 @@ static int arch_random_refill(void)
 }
 
 static ssize_t
-random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+_random_read(int nonblock, char __user *buf, size_t nbytes)
 {
 	ssize_t n;
 
@@ -1379,7 +1384,7 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 		if (arch_random_refill())
 			continue;
 
-		if (file->f_flags & O_NONBLOCK)
+		if (nonblock)
 			return -EAGAIN;
 
 		wait_event_interruptible(random_read_wait,
@@ -1391,6 +1396,12 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 }
 
 static ssize_t
+random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+{
+	return _random_read(file->f_flags & O_NONBLOCK, buf, nbytes);
+}
+
+static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	int ret;
@@ -1533,6 +1544,26 @@ const struct file_operations urandom_fops = {
 	.llseek = noop_llseek,
 };
 
+SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
+		unsigned int, flags)
+{
+	int r;
+
+	if (count > 256)
+		return -EINVAL;
+
+	if (flags & GRND_RANDOM) {
+		return _random_read(!(flags & GRND_BLOCK), buf, count);
+	}
+	if (flags & GRND_BLOCK) {
+		r = wait_for_completion_interruptible(&urandom_initialized);
+		if (r)
+			return r;
+	} else if (!completion_done(&urandom_initialized))
+		return -EAGAIN;
+	return urandom_read(NULL, buf, count, NULL);
+}
+
 /***************************************************************
  * Random UUID interface
  *
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b0881a0..cd82f72f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -866,4 +866,7 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+asmlinkage long sys_getrandom(char __user * buf, size_t count,
+			      unsigned int flags);
+
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 3336406..2926b1d 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -699,9 +699,11 @@ __SYSCALL(__NR_sched_setattr, sys_sched_setattr)
 __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
 #define __NR_renameat2 276
 __SYSCALL(__NR_renameat2, sys_renameat2)
+#define __NR_getrandom 277
+__SYSCALL(__NR_getrandom, sys_getrandom)
 
 #undef __NR_syscalls
-#define __NR_syscalls 277
+#define __NR_syscalls 278
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/uapi/linux/random.h b/include/uapi/linux/random.h
index fff3528..6c13442 100644
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -40,4 +40,13 @@ struct rand_pool_info {
 	__u32	buf[0];
 };
 
+/*
+ * Flags for getrandom(2)
+ *
+ * GAND_BLOCK 		Allow getrandom(2) to block
+ * GAND_RANDOM		Use the /dev/random pool instead of /dev/urandom
+ */
+#define GRND_BLOCK	0x0001
+#define GRND_RANDOM	0x0002
+
 #endif /* _UAPI_LINUX_RANDOM_H */
-- 
2.0.0


--opJtzjQTFsWo+cga--
