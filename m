From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v4 54/79] include/uapi/asm-generic/ucontext.h: include asm/signal.h and asm/sigcontext.h
Date: Thu, 15 Oct 2015 07:56:32 +0200
Message-ID: <1444888618-4506-55-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compiler errors:

error: unknown type name =E2=80=98stack_t=E2=80=99
error: field =E2=80=98uc_mcontext=E2=80=99 has incomplete type
struct sigcontext uc_mcontext;
error: unknown type name =E2=80=98sigset_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/asm-generic/ucontext.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/asm-generic/ucontext.h b/include/uapi/asm-gen=
eric/ucontext.h
index ad77343..4481528 100644
--- a/include/uapi/asm-generic/ucontext.h
+++ b/include/uapi/asm-generic/ucontext.h
@@ -1,6 +1,9 @@
 #ifndef __ASM_GENERIC_UCONTEXT_H
 #define __ASM_GENERIC_UCONTEXT_H
=20
+#include <asm/signal.h>
+#include <asm/sigcontext.h>
+
 struct ucontext {
 	unsigned long	  uc_flags;
 	struct ucontext  *uc_link;
--=20
2.5.0
