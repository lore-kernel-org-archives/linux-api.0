From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: [tytso-DPNOqEs/LNQ@public.gmane.org: [PATCH, RFC -v3] random: introduce getrandom(2)
 system call]
Date: Fri, 18 Jul 2014 08:56:06 -0400
Message-ID: <20140718125606.GH1491@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="eJnRUKwClWJh1Khz"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Apologies, screwed up the e-mail address again.

						- Ted

--eJnRUKwClWJh1Khz
Content-Type: message/rfc822
Content-Disposition: inline

Return-path: <tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Envelope-to: mit-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org
Delivery-date: Fri, 18 Jul 2014 10:00:02 +0000
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36])
	by imap.thunk.org with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>)
	id 1X84xM-0004kY-OE
	for mit-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org; Fri, 18 Jul 2014 10:00:02 +0000
Received: from mailhub-dmz-3.mit.edu ( [18.9.21.42])
	(using TLS with cipher AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by dmz-mailsec-scanner-7.mit.edu (Symantec Messaging Gateway) with SMTP id 88.EE.01660.A10F8C35; Fri, 18 Jul 2014 05:59:54 -0400 (EDT)
Received: from dmz-mailsec-scanner-2.mit.edu (dmz-mailsec-scanner-2.mit.edu [18.9.25.13])
	by mailhub-dmz-3.mit.edu (8.13.8/8.9.2) with ESMTP id s6I9xkVm026369
	for <tytso-3s7WtUTddSA@public.gmane.org>; Fri, 18 Jul 2014 05:59:54 -0400
X-AuditID: 12074424-f79146d00000067c-d2-53c8f01a076d
Authentication-Results: symauth.service.identifier
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97])
	(using TLS with cipher AES128-SHA (128/128 bits))
	(Client did not present a certificate)
	by dmz-mailsec-scanner-2.mit.edu (Symantec Messaging Gateway) with SMTP id 4E.CB.12039.A10F8C35; Fri, 18 Jul 2014 05:59:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org; s=ef5046eb;
	h=Message-Id:Date:Subject:Cc:To:From; bh=ZtjUsEzw6730ZfhfpxrLQuSFpNz0MV5r3qIUfpL48sM=;
	b=YbNp+skbezthwKJiFit/+8nee1FPomvZpeUQvzyXBdB39BJ/f8jw2dpyaqukRGk7CTToOBqhLM2pg7s4d6hPXVL2GEp3SoOnO9gKuvRYRDn0aUXsyxGS8cE5wNg0nZpi0r9Ml3Ma5MCNvMYpra+maGkSg2ZfHfnoH5v5B/K5VUE=;
Received: from root (helo=closure.thunk.org)
	by imap.thunk.org with local-esmtp (Exim 4.80)
	(envelope-from <tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>)
	id 1X84x9-0004kR-Ta; Fri, 18 Jul 2014 09:59:51 +0000
Received: by closure.thunk.org (Postfix, from userid 15806)
	id 91C8858079E; Fri, 18 Jul 2014 05:59:26 -0400 (EDT)
From: "Theodore Ts'o" <tytso-DPNOqEs/LNQ@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-abi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, beck-7YlrpqBBQ3VAfugRpC6u6w@public.gmane.org,
        deraadt-VON6Tr2NNtkmbxgs1yVkuA@public.gmane.org, "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Date: Fri, 18 Jul 2014 05:59:24 -0400
Message-Id: <1405677564-16802-1-git-send-email-tytso-3s7WtUTddSA@public.gmane.org>
X-Mailer: git-send-email 2.0.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHIsWRmVeSWpSXmKPExsUixCmqpSv14USwwfm/1hb3u7qYHRg9WvZf
	YwtgjOKySUnNySxLLdK3S+DKeH+3g6VgZ1zFlKmtrA2M+726GDk5JARMJHrn3WGCsMUkLtxb
	z9bFyMUhJDCLSWL/k1tMEM51Rok93T1sMB2N+zeA2YwCRhK7z71ihShawiSx9PpqdhCHReAJ
	k8SWVyehMjsYJe7t+sgI0iIkUCxx5NZLZhCbTUBVYsuq/2DLRQQUJDb3PgNrYBaYwCixpL+H
	pYuRg0NYwEXi6GNNkBoWoPrFDS1gc3gFbCWmnJnAAnGSnETDjU9Q52lKHLy0CSquInFww3dm
	CNtL4v22S2D/SAgcY5doO9bPNIFRdAEjwypG2ZTcKt3cxMyc4tRk3eLkxLy81CJdc73czBK9
	1JTSTYygYGZ3UdnB2HxI6RCjAAejEg/vg2vHg4VYE8uKK3MPMUpyMCmJ8n55dCJYiC8pP6Uy
	I7E4I76oNCe1+BCjBAezkghv9n2gct6UxMqq1KJ8mJQ0B4uSOO9ba6tgIYH0xJLU7NTUgtQi
	mKwMB4eSBK/ve6ChgkWp6akVaZk5JQhpJg5OkOE8QMO9QWp4iwsSc4sz0yHypxgVpcR5H7wD
	SgiAJDJK8+B6YcnmFaM40CvCvKEg7TzARAXX/QpoMBPQYOlykKuLSxIRUlINjLvOOBWsc6x3
	4dzQsadT0aeycypn98xzf/N6LI4fX3T4yQz+H1a8QWYef+RjfytsO7bUJ2jxucD9Cz4W53Tf
	O7iVe3YST/PbtIb5KjP0UyZ22tytSZ+/YP5VVuYr7sFPmL9frWxYH1PEn1LYXh4hM5cp03Ai
	E9PGgHN1VXci+oKnfU0Qy+DLVWIpzkg01GIuKk4EAEw5nCsRAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRWlGSWpSXmKPExsXidf5Voq7UhxPBBs+vCFm09vxkd2D0aDpz
	lDmAMYrLJiU1J7MstUjfLoEr4/3dDpaCnXEVU6a2sjYw7vfqYuTkkBAwkWjcv4ENxGYUMJLY
	fe4VK0RcTOLCvfVAcS4OIYElTBJLr69mB3FYBJ4wSWx5dZIVIrODUeLero+MIC1CAsUSR269
	ZAax2QSUJe7OPQ0WFxFQkNjc+wysgVmgl1Fi/YX1QAkODmEBF4mjjzVBalgEVCUWN7SA1fMK
	2EpMOTOBBeIMOYmGG5/YIGxNiYOXNkHFVSQObvjODGF7SbzfdolpAqPgAkaGVYyyKblVurmJ
	mTnFqcm6xcmJeXmpRbpGermZJXqpKaWbGIFhJsQpybuD8d1BpUOMAhyMSjy8D64dDxZiTSwr
	rsw9xCjJwaQkyvvl0YlgIb6k/JTKjMTijPii0pzU4kOMEhzMSiK82feBynlTEiurUovyYVLS
	HCxK4rxvra2ChQTSE0tSs1NTC1KLYLJMHOyHGGU4OJQkeH3fA00WLEpNT61Iy8wpQVbDCSK4
	QNbwAK3xBinkLS5IzC3OTIcoOsWoKCXO++AdUEIAJJFRmgc3AJYaLjHKSgnzMjIwMAjxAF0A
	9Diq/CtGcaCnhXlDQcbzZOaVwE1/BbSYCWixdDnIf8UliQgpqQZGX4nuicGe38UFJkaHnPFm
	+vZCty5/Edu0I+0N/HVpB8XfP36TsUtIKOPV5ZcZvw9HMc9zOGMy0awgcKGGwPv4ae27whYK
	xT4L1ApPP1HxcP2aje5Cq+v3TmO55Rhe2TvfwubaxH93ps0OuJr8IMopN3X6nmQL0TvX3FnF
	20yftU7Xv3Hz8ktBJZbijERDLeai4kQAraayBggDAAA=
X-SA-Exim-Connect-IP: 18.7.68.36
X-SA-Exim-Mail-From: tytso-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on imap.thunk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	SPF_SOFTFAIL,T_DKIM_INVALID,URIBL_BLOCKED,URIBL_WS_SURBL autolearn=no
	version=3.3.2
Subject: [PATCH, RFC -v3] random: introduce getrandom(2) system call
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
before the init scripts start execution.

This is because changing /dev/urandom reads to block represents an
interface change that could potentially break userspace which is not
acceptable.  In practice, on most x86 desktop and server systems, in
general the entropy pool can be initialized before it is needed (and
in modern kernels, we will printk a warning message if not).  However,
on an embedded system, this may not be the case.  And so with this new
interface, we can provide the functionality of blocking until the
urandom pool has been initialized.  Any userspace program which uses
this new functionality must take care to assure that if it is used
during the boot process, that it will not cause the init scripts or
other portions of the system startup to hang indefinitely.

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
	/dev/random pool instead of the /dev/urandom pool.  The
	/dev/random pool is limited based on the entropy that can be
	obtained from environmental noise, so if there is insufficient
	entropy, the requested number of bytes may not be returned.
	If there is no entropy available at all, getrandom(2) will
	either block, or return an error with errno set to EAGAIN if
	the GRND_NONBLOCK bit is set in flags.

	If the GRND_RANDOM bit is not set, then the /dev/urandom pool
	will be used.  Unlike using read(2) to fetch data from
	/dev/urandom, if the urandom pool has not been sufficiently
	initialized, getrandom(2) will block or return -1 with the
	errno set to EGAIN if the GRND_NONBLOCK bit is set in flags.

	The getentropy(2) system call in OpenBSD can be emulated using
	the following function:

            int getentropy(void *buf, size_t buflen)
            {
                    int     ret;

                    if (buflen > 256)
                            goto failure;

                    ret = getrandom(buf, buflen, 0);
                    if (ret < 0)
                            return ret;
                    if (ret != buflen)
                    failure:
                            errno = EIO;
                            return -1;
                    }
                    return 0;
            }

RETURN VALUE
       On success, the number of bytes that was filled in the buf is
       returned.  This may not be all the bytes requested by the
       caller via buflen if insufficient entropy was present in the
       /dev/random pool, or if the system call was interrupted by a
       signal.

       On error, -1 is returned, and errno is set appropriately.

ERRORS
	EINVAL		An invalid flag was passed to getrandom(2)

	EFAULT		buf is outside the accessible address space.

	EAGAIN		The requested entropy was not available, and the
			getentropy(2) would have blocked if GRND_BLOCK flag
			was set.

	EINTR		While blocked waiting for entropy, the call was
			interrupted by a signal handler; see the description
			of how interrupted read(2) calls on "slow" devices
			are handled with and without the SA_RESTART flag
			in the signal(7) man page.

NOTES
	For small requests (buflen <= 256) getrandom(2) will not
	return EINTR when reading from the urandom pool once the
	entropy pool has been initialized, and it will return all of
	the bytes that have been requested.  This is the recommended
	way to use getrandom(2), and is designed for compatibility
	with OpenBSD's getentropy() system call.

	However, if you are using GRND_RANDOM, then getrandom(2) may
	block until the entropy accounting determines that sufficient
	environmental noise has been gathered such that getrandom(2)
	will be operating as a NRBG instead of a DRBG for those people
	who are working in the NIST SP 800-90 regime.  Since it may
	block for a long time, these guarantees do *not* apply.  The
	user may want to interrupt a hanging process using a signal,
	so blocking until all of the requested bytes are returned
	would be unfriendly.

	For this reason, the user of getrandom(2) MUST always check
	the return value, in case it returns some error, or if fewer
	bytes than requested was returned.  In the case of
	!GRND_RANDOM and small request, the latter should never
	happen, but the careful userspace code (and all crypto code
	should be careful) should check for this anyway!

Signed-off-by: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Reviewed-by: Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>
---

The change in the v3 version of the commit was to eliminate potential
short reads and EINTR returns when reading from urandom (once the
urandom pool is initialized).  This was based on comments and requests
from Theo de Raadt.  See the NOTES section in the suggested man page for
a more in-depth discussion of the issues involved.

 arch/x86/syscalls/syscall_32.tbl  |  1 +
 arch/x86/syscalls/syscall_64.tbl  |  1 +
 drivers/char/random.c             | 42 ++++++++++++++++++++++++++++++++++++---
 include/linux/syscalls.h          |  3 +++
 include/uapi/asm-generic/unistd.h |  4 +++-
 include/uapi/linux/random.h       |  9 +++++++++
 6 files changed, 56 insertions(+), 4 deletions(-)

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
index aa22fe5..91dd57e 100644
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
 
+static DECLARE_COMPLETION(urandom_initialized);
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
@@ -1174,13 +1179,14 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
+	int large_request = (nbytes > 256);
 
 	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
 	while (nbytes) {
-		if (need_resched()) {
+		if (large_request && need_resched()) {
 			if (signal_pending(current)) {
 				if (ret == 0)
 					ret = -ERESTARTSYS;
@@ -1355,7 +1361,7 @@ static int arch_random_refill(void)
 }
 
 static ssize_t
-random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+_random_read(int nonblock, char __user *buf, size_t nbytes)
 {
 	ssize_t n;
 
@@ -1379,7 +1385,7 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 		if (arch_random_refill())
 			continue;
 
-		if (file->f_flags & O_NONBLOCK)
+		if (nonblock)
 			return -EAGAIN;
 
 		wait_event_interruptible(random_read_wait,
@@ -1391,6 +1397,12 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
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
@@ -1533,6 +1545,30 @@ const struct file_operations urandom_fops = {
 	.llseek = noop_llseek,
 };
 
+SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
+		unsigned int, flags)
+{
+	int r;
+
+	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
+		return -EINVAL;
+
+	if (count > INT_MAX)
+		count = INT_MAX;
+
+	if (flags & GRND_RANDOM)
+		return _random_read(flags & GRND_NONBLOCK, buf, count);
+	if (flags & GRND_NONBLOCK) {
+		if (!completion_done(&urandom_initialized))
+			return -EAGAIN;
+	} else {
+		r = wait_for_completion_interruptible(&urandom_initialized);
+		if (r)
+			return r;
+	}
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
index fff3528..3f93d16 100644
--- a/include/uapi/linux/random.h
+++ b/include/uapi/linux/random.h
@@ -40,4 +40,13 @@ struct rand_pool_info {
 	__u32	buf[0];
 };
 
+/*
+ * Flags for getrandom(2)
+ *
+ * GRND_NONBLOCK	Don't block and return EAGAIN instead
+ * GRND_RANDOM		Use the /dev/random pool instead of /dev/urandom
+ */
+#define GRND_NONBLOCK	0x0001
+#define GRND_RANDOM	0x0002
+
 #endif /* _UAPI_LINUX_RANDOM_H */
-- 
2.0.0


--eJnRUKwClWJh1Khz--
