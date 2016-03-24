From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Subject: [RFC v1 09/17] selftest/seccomp: Extend seccomp_data until matches[6]
Date: Thu, 24 Mar 2016 03:53:54 +0100
Message-ID: <1458788042-26173-1-git-send-email-mic@digikod.net>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1458784008-16277-1-git-send-email-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Kerrisk <mtk-ASgREoAs3yw@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, "Serge E . Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/test=
ing/selftests/seccomp/seccomp_bpf.c
index 023717bf3185..edaa405111aa 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -84,13 +84,21 @@ struct seccomp_data {
 	__u32 arch;
 	__u64 instruction_pointer;
 	__u64 args[6];
+	__u32 is_valid_syscall; /* SECCOMP_DATA_VALIDSYS_PRESENT */
+	__u32 checker_group; /* SECCOMP_DATA_ARGEVAL_PRESENT */
+	__u64 arg_matches[6]; /* SECCOMP_DATA_ARGEVAL_PRESENT */
 };
+
+#define SECCOMP_DATA_ARGEVAL_PRESENT
 #endif
=20
 #if __BYTE_ORDER =3D=3D __LITTLE_ENDIAN
 #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]))
+#define match_arg(_n) (offsetof(struct seccomp_data, arg_matches[_n]))
 #elif __BYTE_ORDER =3D=3D __BIG_ENDIAN
 #define syscall_arg(_n) (offsetof(struct seccomp_data, args[_n]) + siz=
eof(__u32))
+#define match_arg(_n) \
+	(offsetof(struct seccomp_data, arg_matches[_n]) + sizeof(__u32))
 #else
 #error "wut? Unknown __BYTE_ORDER?!"
 #endif
@@ -502,7 +510,11 @@ TEST_SIGNAL(KILL_one_arg_six, SIGSYS)
 TEST(arg_out_of_range)
 {
 	struct sock_filter filter[] =3D {
+#ifdef SECCOMP_DATA_ARGEVAL_PRESENT
+		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, match_arg(6)),
+#else
 		BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(6)),
+#endif
 		BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
 	};
 	struct sock_fprog prog =3D {
--=20
2.8.0.rc3
