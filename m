From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 143/166] preadv/pwritev: Add preadv and pwritev system
 calls.
Date: Fri, 3 Apr 2009 08:03:22 -0700 (PDT)
Message-ID: <alpine.LFD.2.00.0904030739540.4130@localhost.localdomain>
References: <200904022359.n32NxNYu022834@imap1.linux-foundation.org> <alpine.LFD.2.00.0904021839390.15441@localhost.localdomain> <49D5CA58.20908@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <49D5CA58.20908@redhat.com>
Sender: linux-arch-owner@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, arnd@arndb.de, "H. Peter Anvin" <hpa@zytor.com>, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, ralf@linux-mips.org, tglx@linutronix.de, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org



On Fri, 3 Apr 2009, Gerd Hoffmann wrote:

> Linus Torvalds wrote:
> > 
> > How married are people to this crazy 2x "32 bits" model?
> 
> The tricky corner case are 32bit compat syscalls on 64bit kernel, where
> a noticable number of archs (IIRC at least ppc, mips and s390) can't
> pass unaligned 64bit values through the syscall abi.  The 32/32 split
> was done because of that.

I really think that the 32-bit interfaces are fine. So I'm literally 
suggesting a patch something like the appended.

Some notes:

 - I changed the order to "low first". Why? Because when we have it like 
   this, the 64-bit system calls now don't use the "pos_high" argument at 
   all, and it makes more sense for the native system call to simply match 
   the user-mode prototype.

   But I don't much _care_ about this particular change. I just made it 
   because it seems more logical to me, and if we're changing the order 
   anyway..

 - I checked the resulting assembly code. At least on x86-64, gcc is 
   indeed smart enough to convert the "shift by half twice" into just a 
   zero, and I get the following code:

        testq   %rcx, %rcx      # pos_l
        js      .L122   #,
        movq    %rcx, -48(%rbp) # pos_l, pos

   which is from the C source

        loff_t pos = pos_from_hilo(pos_h, pos_l);
	...
        if (pos < 0)
                return -EINVAL;

   and the 'pos_h' register isn't even touched. So this does indeed 
   improve code generation. 

 - It _used_ to generate code like

        mov     %r8d, %r8d      # pos_low, pos_low
        salq    $32, %rcx       #, tmp71
        movq    %r8, %rax       # pos_low, pos.386
        orq     %rcx, %rax      # tmp71, pos.386
        js      .L122   #,
        movq    %rax, -48(%rbp) # pos.386, pos

   which isn't _that_ horrible, but I just think the new thing is more 
   sensible. Does it really matter? Probably not. 

(In both code sequences, the actual code had other instructions 
interspersed, so the above code-sequences are just me manually picking out 
the relevant instructions. Maybe I did something wrong).

So I'm not going to commit the suggested patch, but I just personally 
think it makes more sense that way.

Note: in all cases the user code wrapper can again be the same. You can 
just do

	#define HALF_BITS (sizeof(unsigned long)*4)
	__syscall(PWRITEV, fd, iov, count, offset, (offset >> HALF_BITS) >> HALF_BITS);

or something like that (and passing in a zero for the last argument is a 
good idea, even if nobody will ever care - this will be the _least_ of our 
problems if we ever do 128-bit loff_t). So the user call wrapper isn't 
really any more complicated - the HALF_BITS thing may look more 
complicated than just doing a hard-coded '16' there twice, but if you 
understand what it's doing it's actually more logical.

I think.

Comments?

			Linus

---
 fs/compat.c              |    4 ++--
 fs/read_write.c          |   14 ++++++++++----
 include/linux/compat.h   |    4 ++--
 include/linux/syscalls.h |    4 ++--
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 1c859da..3f84d5f 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1236,7 +1236,7 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 
 asmlinkage ssize_t
 compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
-		  unsigned long vlen, u32 pos_high, u32 pos_low)
+		  unsigned long vlen, u32 pos_low, u32 pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
@@ -1293,7 +1293,7 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 
 asmlinkage ssize_t
 compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
-		   unsigned long vlen, u32 pos_high, u32 pos_low)
+		   unsigned long vlen, u32 pos_low, u32 pos_high)
 {
 	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
diff --git a/fs/read_write.c b/fs/read_write.c
index 6d5d8ff..9ac8b6f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -731,10 +731,16 @@ SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 	return ret;
 }
 
+static inline loff_t pos_from_hilo(unsigned long high, unsigned long low)
+{
+#define HALF_LONG_BITS (BITS_PER_LONG / 2)
+	return ((high << HALF_LONG_BITS) << HALF_LONG_BITS) | low;
+}
+
 SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen, u32, pos_high, u32, pos_low)
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
 	struct file *file;
 	ssize_t ret = -EBADF;
 	int fput_needed;
@@ -757,9 +763,9 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 }
 
 SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
-		unsigned long, vlen, u32, pos_high, u32, pos_low)
+		unsigned long, vlen, unsigned long, pos_l, unsigned long, pos_h)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	loff_t pos = pos_from_hilo(pos_h, pos_l);
 	struct file *file;
 	ssize_t ret = -EBADF;
 	int fput_needed;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index 9723edd..f2ded21 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -193,10 +193,10 @@ asmlinkage ssize_t compat_sys_writev(unsigned long fd,
 		const struct compat_iovec __user *vec, unsigned long vlen);
 asmlinkage ssize_t compat_sys_preadv(unsigned long fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_high, u32 pos_low);
+		unsigned long vlen, u32 pos_low, u32 pos_high);
 asmlinkage ssize_t compat_sys_pwritev(unsigned long fd,
 		const struct compat_iovec __user *vec,
-		unsigned long vlen, u32 pos_high, u32 pos_low);
+		unsigned long vlen, u32 pos_low, u32 pos_high);
 
 int compat_do_execve(char * filename, compat_uptr_t __user *argv,
 	        compat_uptr_t __user *envp, struct pt_regs * regs);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b299a82..18771ca 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -462,9 +462,9 @@ asmlinkage long sys_pread64(unsigned int fd, char __user *buf,
 asmlinkage long sys_pwrite64(unsigned int fd, const char __user *buf,
 			     size_t count, loff_t pos);
 asmlinkage long sys_preadv(unsigned long fd, const struct iovec __user *vec,
-			   unsigned long vlen, u32 pos_high, u32 pos_low);
+			   unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
 asmlinkage long sys_pwritev(unsigned long fd, const struct iovec __user *vec,
-			    unsigned long vlen, u32 pos_high, u32 pos_low);
+			    unsigned long vlen, unsigned long pos_l, unsigned long pos_h);
 asmlinkage long sys_getcwd(char __user *buf, unsigned long size);
 asmlinkage long sys_mkdir(const char __user *pathname, int mode);
 asmlinkage long sys_chdir(const char __user *filename);
