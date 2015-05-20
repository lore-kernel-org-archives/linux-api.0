From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 1/9] y2038: remove unneeded ipc uapi header files
Date: Wed, 20 May 2015 17:12:57 +0200
Message-ID: <2723942.OTLu65T7Lp@wuerfel>
References: <1432134445-804487-1-git-send-email-arnd@arndb.de> <1432134445-804487-2-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432134445-804487-2-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: baolin.wang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, albert.aribaud-iEu9NFBzPZE@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, ruchandani.tina-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wednesday 20 May 2015 17:07:17 Arnd Bergmann wrote:
> Eight architectures contain copies of the original i386
> ipcbuf/msgbuf/sembuf/shmbuf header files, which are all identical
> to the version in uapi/asm-generic.
> 
> This patch removes the files and replaces them with 'generic-y'
> statements, to avoid having to modify each copy when we extend
> sysvipc to deal with 64-bit time_t.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

This patch got caught in some filters because of the size, I'm
sending it again with 'git diff -D' below, which omits the contents
of the deleted files, sorry for the inconvenience.

	Arnd

8<-----
Subject: [PATCH] y2038: remove unneeded ipc uapi header files

Eight architectures contain copies of the original i386
ipcbuf/msgbuf/sembuf/shmbuf header files, which are all identical
to the version in uapi/asm-generic.

This patch removes the files and replaces them with 'generic-y'
statements, to avoid having to modify each copy when we extend
sysvipc to deal with 64-bit time_t.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 arch/alpha/include/asm/Kbuild          |  4 ++++
 arch/alpha/include/uapi/asm/ipcbuf.h   |  1 -
 arch/alpha/include/uapi/asm/msgbuf.h   | 27 ---------------------------
 arch/alpha/include/uapi/asm/sembuf.h   | 22 ----------------------
 arch/alpha/include/uapi/asm/shmbuf.h   | 38 --------------------------------------
 arch/avr32/include/asm/Kbuild          |  4 ++++
 arch/avr32/include/uapi/asm/Kbuild     |  1 -
 arch/avr32/include/uapi/asm/msgbuf.h   | 31 -------------------------------
 arch/avr32/include/uapi/asm/sembuf.h   | 25 -------------------------
 arch/avr32/include/uapi/asm/shmbuf.h   | 42 ------------------------------------------
 arch/cris/include/asm/Kbuild           |  6 +++++-
 arch/cris/include/uapi/asm/ipcbuf.h    |  1 -
 arch/cris/include/uapi/asm/msgbuf.h    | 33 ---------------------------------
 arch/cris/include/uapi/asm/sembuf.h    | 25 -------------------------
 arch/cris/include/uapi/asm/shmbuf.h    | 42 ------------------------------------------
 arch/frv/include/asm/Kbuild            |  4 ++++
 arch/frv/include/uapi/asm/ipcbuf.h     |  1 -
 arch/frv/include/uapi/asm/msgbuf.h     | 32 --------------------------------
 arch/frv/include/uapi/asm/sembuf.h     | 26 --------------------------
 arch/frv/include/uapi/asm/shmbuf.h     | 43 -------------------------------------------
 arch/ia64/include/asm/Kbuild           |  4 ++++
 arch/ia64/include/uapi/asm/ipcbuf.h    |  1 -
 arch/ia64/include/uapi/asm/msgbuf.h    | 27 ---------------------------
 arch/ia64/include/uapi/asm/sembuf.h    | 22 ----------------------
 arch/ia64/include/uapi/asm/shmbuf.h    | 38 --------------------------------------
 arch/m32r/include/asm/Kbuild           |  4 ++++
 arch/m32r/include/uapi/asm/ipcbuf.h    |  1 -
 arch/m32r/include/uapi/asm/msgbuf.h    | 31 -------------------------------
 arch/m32r/include/uapi/asm/sembuf.h    | 25 -------------------------
 arch/m32r/include/uapi/asm/shmbuf.h    | 42 ------------------------------------------
 arch/mn10300/include/asm/Kbuild        |  4 ++++
 arch/mn10300/include/uapi/asm/ipcbuf.h |  1 -
 arch/mn10300/include/uapi/asm/msgbuf.h | 31 -------------------------------
 arch/mn10300/include/uapi/asm/sembuf.h | 25 -------------------------
 arch/mn10300/include/uapi/asm/shmbuf.h | 42 ------------------------------------------
 arch/s390/include/asm/Kbuild           |  4 +++-
 arch/s390/include/asm/compat.h         | 32 ++++++++++++++++----------------
 arch/s390/include/uapi/asm/msgbuf.h    | 37 -------------------------------------
 arch/s390/include/uapi/asm/sembuf.h    | 29 -----------------------------
 arch/s390/include/uapi/asm/shmbuf.h    | 48 ------------------------------------------------
 40 files changed, 48 insertions(+), 808 deletions(-)

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index 76aeb8fa551a..0d2f8e2ebdcb 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -3,9 +3,13 @@
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
+generic-y += ipcbuf.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += msgbuf.h
 generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += trace_clock.h
diff --git a/arch/alpha/include/uapi/asm/ipcbuf.h b/arch/alpha/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51cb6d0..000000000000
diff --git a/arch/alpha/include/uapi/asm/msgbuf.h b/arch/alpha/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 98496501a2bb..000000000000
diff --git a/arch/alpha/include/uapi/asm/sembuf.h b/arch/alpha/include/uapi/asm/sembuf.h
deleted file mode 100644
index 7b38b1534784..000000000000
diff --git a/arch/alpha/include/uapi/asm/shmbuf.h b/arch/alpha/include/uapi/asm/shmbuf.h
deleted file mode 100644
index 37ee84f05085..000000000000
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 528d70d47a54..fd65fc13809f 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -7,16 +7,20 @@ generic-y += div64.h
 generic-y += emergency-restart.h
 generic-y += exec.h
 generic-y += futex.h
+generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += irq_work.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
+generic-y += msgbuf.h
 generic-y += param.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += vga.h
diff --git a/arch/avr32/include/uapi/asm/Kbuild b/arch/avr32/include/uapi/asm/Kbuild
index 08d8a3d76ea8..198196499c84 100644
--- a/arch/avr32/include/uapi/asm/Kbuild
+++ b/arch/avr32/include/uapi/asm/Kbuild
@@ -26,7 +26,6 @@ generic-y += errno.h
 generic-y += fcntl.h
 generic-y += ioctl.h
 generic-y += ioctls.h
-generic-y += ipcbuf.h
 generic-y += kvm_para.h
 generic-y += mman.h
 generic-y += param.h
diff --git a/arch/avr32/include/uapi/asm/msgbuf.h b/arch/avr32/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 9eae6effad14..000000000000
diff --git a/arch/avr32/include/uapi/asm/sembuf.h b/arch/avr32/include/uapi/asm/sembuf.h
deleted file mode 100644
index 6c6f7cf1e75a..000000000000
diff --git a/arch/avr32/include/uapi/asm/shmbuf.h b/arch/avr32/include/uapi/asm/shmbuf.h
deleted file mode 100644
index b94cf8b60b73..000000000000
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 057e51859b0a..b438857651bf 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -5,10 +5,11 @@ generic-y += cmpxchg.h
 generic-y += cputime.h
 generic-y += device.h
 generic-y += div64.h
-generic-y += exec.h
 generic-y += emergency-restart.h
+generic-y += exec.h
 generic-y += futex.h
 generic-y += hardirq.h
+generic-y += ipcbuf.h
 generic-y += irq_regs.h
 generic-y += irq_work.h
 generic-y += kdebug.h
@@ -19,10 +20,13 @@ generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += module.h
+generic-y += msgbuf.h
 generic-y += percpu.h
 generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += topology.h
 generic-y += trace_clock.h
 generic-y += vga.h
diff --git a/arch/cris/include/uapi/asm/ipcbuf.h b/arch/cris/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51cb6d0..000000000000
diff --git a/arch/cris/include/uapi/asm/msgbuf.h b/arch/cris/include/uapi/asm/msgbuf.h
deleted file mode 100644
index ada63df1d574..000000000000
diff --git a/arch/cris/include/uapi/asm/sembuf.h b/arch/cris/include/uapi/asm/sembuf.h
deleted file mode 100644
index 7fed9843796d..000000000000
diff --git a/arch/cris/include/uapi/asm/shmbuf.h b/arch/cris/include/uapi/asm/shmbuf.h
deleted file mode 100644
index 3239e3f000e8..000000000000
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index e3f81b53578e..a279ad1ad6a2 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -2,8 +2,12 @@
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
+generic-y += ipcbuf.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += msgbuf.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += trace_clock.h
diff --git a/arch/frv/include/uapi/asm/ipcbuf.h b/arch/frv/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51cb6d0..000000000000
diff --git a/arch/frv/include/uapi/asm/msgbuf.h b/arch/frv/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 97ceb55a06fb..000000000000
diff --git a/arch/frv/include/uapi/asm/sembuf.h b/arch/frv/include/uapi/asm/sembuf.h
deleted file mode 100644
index 164b12786d6d..000000000000
diff --git a/arch/frv/include/uapi/asm/shmbuf.h b/arch/frv/include/uapi/asm/shmbuf.h
deleted file mode 100644
index 4c6e711a4779..000000000000
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index 9b41b4bcc073..1cfb2db15cd1 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -1,10 +1,14 @@
 
 generic-y += clkdev.h
 generic-y += exec.h
+generic-y += ipcbuf.h
 generic-y += irq_work.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
+generic-y += msgbuf.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += trace_clock.h
 generic-y += vtime.h
diff --git a/arch/ia64/include/uapi/asm/ipcbuf.h b/arch/ia64/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51cb6d0..000000000000
diff --git a/arch/ia64/include/uapi/asm/msgbuf.h b/arch/ia64/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 6c64c0d2aae1..000000000000
diff --git a/arch/ia64/include/uapi/asm/sembuf.h b/arch/ia64/include/uapi/asm/sembuf.h
deleted file mode 100644
index 1340fbc04d3e..000000000000
diff --git a/arch/ia64/include/uapi/asm/shmbuf.h b/arch/ia64/include/uapi/asm/shmbuf.h
deleted file mode 100644
index 585002a77acd..000000000000
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index 2edc793372fc..20b0e8240926 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -2,10 +2,14 @@
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
+generic-y += ipcbuf.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += module.h
+generic-y += msgbuf.h
 generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += trace_clock.h
diff --git a/arch/m32r/include/uapi/asm/ipcbuf.h b/arch/m32r/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51cb6d0..000000000000
diff --git a/arch/m32r/include/uapi/asm/msgbuf.h b/arch/m32r/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 0d5a877b813e..000000000000
diff --git a/arch/m32r/include/uapi/asm/sembuf.h b/arch/m32r/include/uapi/asm/sembuf.h
deleted file mode 100644
index c9873d6890e2..000000000000
diff --git a/arch/m32r/include/uapi/asm/shmbuf.h b/arch/m32r/include/uapi/asm/shmbuf.h
deleted file mode 100644
index b0cdf0aa7d65..000000000000
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index f892d9de47d9..6dc433f17f2f 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -3,9 +3,13 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
+generic-y += ipcbuf.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += msgbuf.h
 generic-y += preempt.h
 generic-y += scatterlist.h
 generic-y += sections.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += trace_clock.h
diff --git a/arch/mn10300/include/uapi/asm/ipcbuf.h b/arch/mn10300/include/uapi/asm/ipcbuf.h
deleted file mode 100644
index 84c7e51cb6d0..000000000000
diff --git a/arch/mn10300/include/uapi/asm/msgbuf.h b/arch/mn10300/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 8b602450cc4a..000000000000
diff --git a/arch/mn10300/include/uapi/asm/sembuf.h b/arch/mn10300/include/uapi/asm/sembuf.h
deleted file mode 100644
index 301f3f9d8aa9..000000000000
diff --git a/arch/mn10300/include/uapi/asm/shmbuf.h b/arch/mn10300/include/uapi/asm/shmbuf.h
deleted file mode 100644
index 8f300cc35d6c..000000000000
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index c631f98fd524..a08933ae7b7e 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -1,8 +1,10 @@
 
-
 generic-y += clkdev.h
 generic-y += irq_work.h
 generic-y += mcs_spinlock.h
+generic-y += msgbuf.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sembuf.h
+generic-y += shmbuf.h
 generic-y += trace_clock.h
diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 91398bb0695c..d301b8271513 100644
--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -304,10 +304,10 @@ struct compat_ipc64_perm {
 
 struct compat_semid64_ds {
 	struct compat_ipc64_perm sem_perm;
-	compat_time_t  sem_otime;
-	compat_ulong_t __pad1;
-	compat_time_t  sem_ctime;
-	compat_ulong_t __pad2;
+	compat_ulong_t sem_otime;
+	compat_ulong_t sem_otime_high;
+	compat_ulong_t sem_ctime;
+	compat_ulong_t sem_ctime_high;
 	compat_ulong_t sem_nsems;
 	compat_ulong_t __unused1;
 	compat_ulong_t __unused2;
@@ -315,12 +315,12 @@ struct compat_semid64_ds {
 
 struct compat_msqid64_ds {
 	struct compat_ipc64_perm msg_perm;
-	compat_time_t   msg_stime;
-	compat_ulong_t __pad1;
-	compat_time_t   msg_rtime;
-	compat_ulong_t __pad2;
-	compat_time_t   msg_ctime;
-	compat_ulong_t __pad3;
+	compat_ulong_t msg_stime;
+	compat_ulong_t msg_stime_high;
+	compat_ulong_t msg_rtime;
+	compat_ulong_t msg_rtime_high;
+	compat_ulong_t msg_ctime;
+	compat_ulong_t msg_ctime_high;
 	compat_ulong_t msg_cbytes;
 	compat_ulong_t msg_qnum;
 	compat_ulong_t msg_qbytes;
@@ -333,12 +333,12 @@ struct compat_msqid64_ds {
 struct compat_shmid64_ds {
 	struct compat_ipc64_perm shm_perm;
 	compat_size_t  shm_segsz;
-	compat_time_t  shm_atime;
-	compat_ulong_t __pad1;
-	compat_time_t  shm_dtime;
-	compat_ulong_t __pad2;
-	compat_time_t  shm_ctime;
-	compat_ulong_t __pad3;
+	compat_ulong_t shm_atime;
+	compat_ulong_t shm_atime_high;
+	compat_ulong_t shm_dtime;
+	compat_ulong_t shm_dtime_high;
+	compat_ulong_t shm_ctime;
+	compat_ulong_t shm_ctime_high;
 	compat_pid_t   shm_cpid;
 	compat_pid_t   shm_lpid;
 	compat_ulong_t shm_nattch;
diff --git a/arch/s390/include/uapi/asm/msgbuf.h b/arch/s390/include/uapi/asm/msgbuf.h
deleted file mode 100644
index 1bbdee927924..000000000000
diff --git a/arch/s390/include/uapi/asm/sembuf.h b/arch/s390/include/uapi/asm/sembuf.h
deleted file mode 100644
index 32626b0cac4b..000000000000
diff --git a/arch/s390/include/uapi/asm/shmbuf.h b/arch/s390/include/uapi/asm/shmbuf.h
deleted file mode 100644
index eed2e280ce37..000000000000
