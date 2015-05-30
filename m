From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 78/98] include/uapi/asm-generic/ucontext.h: include asm/signal.h and asm/sigcontext.h
Date: Sat, 30 May 2015 17:39:10 +0200
Message-ID: <1433000370-19509-79-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-arch-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compiler errors:

error: unknown type name =E2=80=98stack_t=E2=80=99
error: field =E2=80=98uc_mcontext=E2=80=99 has incomplete type
struct sigcontext uc_mcontext;
error: unknown type name =E2=80=98sigset_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
2.1.4
