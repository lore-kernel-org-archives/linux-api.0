From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v4 76/79] coda_psdev.h: move upc_req definition from uapi to kernel side headers
Date: Thu, 15 Oct 2015 07:56:54 +0200
Message-ID: <1444888618-4506-77-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mikko.rapeli-X3B1VOXEql0@public.gmane.org, Jan Harkes <jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>, coda-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org, codalist-/uMB558Y47wP4a1z8dhFYw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Only users of upc_req in kernel side fs/coda/psdev.c and fs/coda/upcall=
=2Ec
already include linux/coda_psdev.h.

Suggested by Jan Harkes <jaharkes-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org> on lkml message
<20150531111913.GA23377-ETDLCGt7PQU3uPMLIKxrzw@public.gmane.org>.

=46ixes these include/uapi/linux/coda_psdev.h compilation errors in use=
rspace:

=2E/linux/coda_psdev.h:12:19: error: field =E2=80=98uc_chain=E2=80=99 h=
as incomplete type
  struct list_head    uc_chain;
                   ^
=2E/linux/coda_psdev.h:13:2: error: unknown type name =E2=80=98caddr_t=E2=
=80=99
  caddr_t             uc_data;
  ^
=2E/linux/coda_psdev.h:14:2: error: unknown type name =E2=80=98u_short=E2=
=80=99
  u_short             uc_flags;
  ^
=2E/linux/coda_psdev.h:15:2: error: unknown type name =E2=80=98u_short=E2=
=80=99
  u_short             uc_inSize;  /* Size is at most 5000 bytes */
  ^
=2E/linux/coda_psdev.h:16:2: error: unknown type name =E2=80=98u_short=E2=
=80=99
  u_short             uc_outSize;
  ^
=2E/linux/coda_psdev.h:17:2: error: unknown type name =E2=80=98u_short=E2=
=80=99
  u_short             uc_opcode;  /* copied from data to save lookup */
  ^
=2E/linux/coda_psdev.h:19:2: error: unknown type name =E2=80=98wait_que=
ue_head_t=E2=80=99
  wait_queue_head_t   uc_sleep;   /* process' wait queue */
  ^

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/linux/coda_psdev.h      | 11 +++++++++++
 include/uapi/linux/coda_psdev.h | 13 -------------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 5b8721e..b3c0830 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -19,6 +19,17 @@ struct venus_comm {
 	struct mutex	    vc_mutex;
 };
=20
+/* messages between coda filesystem in kernel and Venus */
+struct upc_req {
+        struct list_head    uc_chain;
+        caddr_t             uc_data;
+        u_short             uc_flags;
+        u_short             uc_inSize;  /* Size is at most 5000 bytes =
*/
+        u_short             uc_outSize;
+        u_short             uc_opcode;  /* copied from data to save lo=
okup */
+        int                 uc_unique;
+        wait_queue_head_t   uc_sleep;   /* process' wait queue */
+};
=20
 static inline struct venus_comm *coda_vcp(struct super_block *sb)
 {
diff --git a/include/uapi/linux/coda_psdev.h b/include/uapi/linux/coda_=
psdev.h
index 79d0598..e2c44d2 100644
--- a/include/uapi/linux/coda_psdev.h
+++ b/include/uapi/linux/coda_psdev.h
@@ -6,19 +6,6 @@
 #define CODA_PSDEV_MAJOR 67
 #define MAX_CODADEVS  5	   /* how many do we allow */
=20
-
-/* messages between coda filesystem in kernel and Venus */
-struct upc_req {
-	struct list_head    uc_chain;
-	caddr_t	            uc_data;
-	u_short	            uc_flags;
-	u_short             uc_inSize;  /* Size is at most 5000 bytes */
-	u_short	            uc_outSize;
-	u_short	            uc_opcode;  /* copied from data to save lookup */
-	int		    uc_unique;
-	wait_queue_head_t   uc_sleep;   /* process' wait queue */
-};
-
 #define CODA_REQ_ASYNC  0x1
 #define CODA_REQ_READ   0x2
 #define CODA_REQ_WRITE  0x4
--=20
2.5.0
