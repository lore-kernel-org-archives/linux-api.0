From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 91/98] include/uapi/linux/android/binder.h: use __kernel_pid_t and __kernel_uid_t
Date: Sat, 30 May 2015 17:39:23 +0200
Message-ID: <1433000370-19509-92-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Purnendu Kapadia <pro8linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors:

error: unknown type name =E2=80=98pid_t=E2=80=99
  pid_t  sender_pid
error: unknown type name =E2=80=98uid_t=E2=80=99
  uid_t  sender_euid;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/android/binder.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/android/binder.h b/include/uapi/linux/a=
ndroid/binder.h
index 41420e3..4e4a385 100644
--- a/include/uapi/linux/android/binder.h
+++ b/include/uapi/linux/android/binder.h
@@ -142,8 +142,8 @@ struct binder_transaction_data {
=20
 	/* General information about the transaction. */
 	__u32	        flags;
-	pid_t		sender_pid;
-	uid_t		sender_euid;
+	__kernel_pid_t		sender_pid;
+	__kernel_uid_t		sender_euid;
 	binder_size_t	data_size;	/* number of bytes of data */
 	binder_size_t	offsets_size;	/* number of bytes of offsets */
=20
--=20
2.1.4
