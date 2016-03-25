From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH] UAPI: Rename all '__unused' struct fields to '__unused1'
Date: Fri, 25 Mar 2016 13:52:47 +0000
Message-ID: <20160325135247.GH21187@decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5Mfx4RzfBqgnTE/w"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 522773-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org, Thorsten Glaser <tg-vpiyNrvJqjezQB+pC5nmwQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


--5Mfx4RzfBqgnTE/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

'__unused' is defined as a macro by some BSD-derived userland software.
We should avoid using it in the UAPI.

References: https://bugs.debian.org/522773
Reported-by: Thorsten Glaser <tg-vpiyNrvJqjezQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
---
Build-tested on x86 only.  I also grepped for uses of the supposedly
 __unused fields on other architectures and found nothing.

Ben.

 arch/alpha/include/uapi/asm/stat.h       | 2 +-
 arch/arm64/include/uapi/asm/ucontext.h   | 2 +-
 arch/ia64/include/uapi/asm/stat.h        | 2 +-
 arch/powerpc/include/uapi/asm/ucontext.h | 2 +-
 arch/s390/include/uapi/asm/stat.h        | 2 +-
 arch/s390/include/uapi/asm/ucontext.h    | 4 ++--
 arch/sparc/include/uapi/asm/fcntl.h      | 4 ++--
 arch/sparc/include/uapi/asm/stat.h       | 2 +-
 arch/x86/include/uapi/asm/stat.h         | 8 ++++----
 include/uapi/linux/icmp.h                | 2 +-
 include/uapi/linux/sysctl.h              | 2 +-
 11 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/stat.h b/arch/alpha/include/uapi/a=
sm/stat.h
index 07ad3e6b3f3e..f13899ad8d85 100644
--- a/arch/alpha/include/uapi/asm/stat.h
+++ b/arch/alpha/include/uapi/asm/stat.h
@@ -42,7 +42,7 @@ struct stat64 {
 	unsigned long	st_mtime_nsec;
 	unsigned long	st_ctime;
 	unsigned long   st_ctime_nsec;
-  	long		__unused[3];
+	long		__unused1[3];
 };
=20
 #endif
diff --git a/arch/arm64/include/uapi/asm/ucontext.h b/arch/arm64/include/ua=
pi/asm/ucontext.h
index 791de8e89e35..37b343d2492e 100644
--- a/arch/arm64/include/uapi/asm/ucontext.h
+++ b/arch/arm64/include/uapi/asm/ucontext.h
@@ -24,7 +24,7 @@ struct ucontext {
 	stack_t		  uc_stack;
 	sigset_t	  uc_sigmask;
 	/* glibc uses a 1024-bit sigset_t */
-	__u8		  __unused[1024 / 8 - sizeof(sigset_t)];
+	__u8		  __unused1[1024 / 8 - sizeof(sigset_t)];
 	/* last for future expansion */
 	struct sigcontext uc_mcontext;
 };
diff --git a/arch/ia64/include/uapi/asm/stat.h b/arch/ia64/include/uapi/asm=
/stat.h
index 367bb90cdffa..aa1e4f942942 100644
--- a/arch/ia64/include/uapi/asm/stat.h
+++ b/arch/ia64/include/uapi/asm/stat.h
@@ -24,7 +24,7 @@ struct stat {
 	unsigned long	st_ctime_nsec;
 	unsigned long	st_blksize;
 	long		st_blocks;
-	unsigned long	__unused[3];
+	unsigned long	__unused1[3];
 };
=20
 #define STAT_HAVE_NSEC 1
diff --git a/arch/powerpc/include/uapi/asm/ucontext.h b/arch/powerpc/includ=
e/uapi/asm/ucontext.h
index d9a4ddf0cc86..cb08c035e427 100644
--- a/arch/powerpc/include/uapi/asm/ucontext.h
+++ b/arch/powerpc/include/uapi/asm/ucontext.h
@@ -28,7 +28,7 @@ struct ucontext {
 	sigset_t	uc_sigmask;
 	/* glibc has 1024-bit signal masks, ours are 64-bit */
 #ifdef __powerpc64__
-	sigset_t	__unused[15];	/* Allow for uc_sigmask growth */
+	sigset_t	__unused1[15];	/* Allow for uc_sigmask growth */
 	struct sigcontext uc_mcontext;	/* last for extensibility */
 #else
 	int		uc_maskext[30];
diff --git a/arch/s390/include/uapi/asm/stat.h b/arch/s390/include/uapi/asm=
/stat.h
index b4ca97d91466..5e493c1aa1f6 100644
--- a/arch/s390/include/uapi/asm/stat.h
+++ b/arch/s390/include/uapi/asm/stat.h
@@ -93,7 +93,7 @@ struct stat {
 	unsigned long  st_ctime_nsec;
         unsigned long  st_blksize;
         long           st_blocks;
-        unsigned long  __unused[3];
+        unsigned long  __unused1[3];
 };
=20
 #endif /* __s390x__ */
diff --git a/arch/s390/include/uapi/asm/ucontext.h b/arch/s390/include/uapi=
/asm/ucontext.h
index 64a69aa5dde0..59d915f9ac27 100644
--- a/arch/s390/include/uapi/asm/ucontext.h
+++ b/arch/s390/include/uapi/asm/ucontext.h
@@ -23,7 +23,7 @@ struct ucontext_extended {
 	_sigregs	  uc_mcontext;
 	sigset_t	  uc_sigmask;
 	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
-	unsigned char	  __unused[128 - sizeof(sigset_t)];
+	unsigned char	  __unused1[128 - sizeof(sigset_t)];
 	_sigregs_ext	  uc_mcontext_ext;
 };
=20
@@ -34,7 +34,7 @@ struct ucontext {
 	_sigregs          uc_mcontext;
 	sigset_t	  uc_sigmask;
 	/* Allow for uc_sigmask growth.  Glibc uses a 1024-bit sigset_t.  */
-	unsigned char	  __unused[128 - sizeof(sigset_t)];
+	unsigned char	  __unused1[128 - sizeof(sigset_t)];
 };
=20
 #endif /* !_ASM_S390_UCONTEXT_H */
diff --git a/arch/sparc/include/uapi/asm/fcntl.h b/arch/sparc/include/uapi/=
asm/fcntl.h
index 7e8ace5bf760..9f5d4383170a 100644
--- a/arch/sparc/include/uapi/asm/fcntl.h
+++ b/arch/sparc/include/uapi/asm/fcntl.h
@@ -48,8 +48,8 @@
 #define F_WRLCK		2
 #define F_UNLCK		3
=20
-#define __ARCH_FLOCK_PAD	short __unused;
-#define __ARCH_FLOCK64_PAD	short __unused;
+#define __ARCH_FLOCK_PAD	short __unused1;
+#define __ARCH_FLOCK64_PAD	short __unused1;
=20
 #include <asm-generic/fcntl.h>
=20
diff --git a/arch/sparc/include/uapi/asm/stat.h b/arch/sparc/include/uapi/a=
sm/stat.h
index a232e9e1f4e5..0b4b4ae9a05d 100644
--- a/arch/sparc/include/uapi/asm/stat.h
+++ b/arch/sparc/include/uapi/asm/stat.h
@@ -43,7 +43,7 @@ struct stat64 {
 	unsigned long	st_mtime_nsec;
 	unsigned long	st_ctime;
 	unsigned long	st_ctime_nsec;
-	long		__unused[3];
+	long		__unused1[3];
 };
=20
 #else
diff --git a/arch/x86/include/uapi/asm/stat.h b/arch/x86/include/uapi/asm/s=
tat.h
index bc03eb5d6360..64ba4e324f57 100644
--- a/arch/x86/include/uapi/asm/stat.h
+++ b/arch/x86/include/uapi/asm/stat.h
@@ -99,15 +99,15 @@ struct stat {
 	__kernel_ulong_t	st_mtime_nsec;
 	__kernel_ulong_t	st_ctime;
 	__kernel_ulong_t	st_ctime_nsec;
-	__kernel_long_t		__unused[3];
+	__kernel_long_t		__unused1[3];
 };
=20
 /* We don't need to memset the whole thing just to initialize the padding =
*/
 #define INIT_STRUCT_STAT_PADDING(st) do {	\
 	st.__pad0 =3D 0;				\
-	st.__unused[0] =3D 0;			\
-	st.__unused[1] =3D 0;			\
-	st.__unused[2] =3D 0;			\
+	st.__unused1[0] =3D 0;			\
+	st.__unused1[1] =3D 0;			\
+	st.__unused1[2] =3D 0;			\
 } while (0)
=20
 #endif
diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index 16fff055f734..78d71b13f9e5 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -76,7 +76,7 @@ struct icmphdr {
 	} echo;
 	__be32	gateway;
 	struct {
-		__be16	__unused;
+		__be16	__unused1;
 		__be16	mtu;
 	} frag;
   } un;
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 0956373b56db..177aa35a8ce8 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -40,7 +40,7 @@ struct __sysctl_args {
 	size_t __user *oldlenp;
 	void __user *newval;
 	size_t newlen;
-	unsigned long __unused[4];
+	unsigned long __unused1[4];
 };
=20
 /* Define sysctl names first */

--5Mfx4RzfBqgnTE/w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBVvVCrue/yOyVhhEJAQprMg//eiXLtnCPc0gya655DL/VSuuilPm+fj01
vC0pPai/07p1UTsFoMtBQYWa6iBR6lWKbOk3lTfyGGK7MfCHGCRA6gUB1sxIPS2U
TtrPtAoRPseSwp3mD4X5J8tHavAQMX2NSKo3q94GB0li4zZVWuE+Hzm2+oTJ4DIr
iQ2zlIaQiQzOghuChOaJ0jBF27e+GYc3ptlhbVJ4tuK/XUMDfwxMysZMtF6crf6m
oyp9rYXaNFSGuz9SAon2mqbKt//rLM8cSp48UBCILUKAdjuG9wlswgIMV3qG2h8T
UPTSvEIt7tcds9ZBFefYDgA/jpXYRuMYq3Koo/UpelSXgfv64HHefil/tIdPji+4
UEWcBg293Ip+cOI7BzmLftk5XNq2sBuWLWBW57Fqs+h1jVUTCIIyD31jieMJy7Pb
Ic/FAsVe8qtV01/J55KLHUrUSmPBDBOatx9mVIAzYPPxDN6mq3/ZP/9kIkAO1mTk
YmcjWUTu3wV+ab4BLKcJXQ0m2i1bUUFpb0rQmHcC+yiLTbwR088sI556Gj8OMn3n
C6k+W/aP1lkRSH9WYXO0eO5xGPiQ+wMmii1LI0R5RGKptrGaOpQfRyhaaxlyaMOb
pPAXjMBD9PszX2OZUY0xQboQQ/2SHOYDsudeDs5fi5cpZvItU2axYJNJmspLIB3r
MjOZDRlr5Mk=
=osTZ
-----END PGP SIGNATURE-----

--5Mfx4RzfBqgnTE/w--
