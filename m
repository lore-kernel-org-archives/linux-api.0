From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 67/79] include/uapi/linux/android/binder.h: use __kernel_pid_t and __kernel_uid_t
Date: Thu, 15 Oct 2015 07:56:45 +0200
Message-ID: <1444888618-4506-68-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors:

error: unknown type name =E2=80=98pid_t=E2=80=99
  pid_t  sender_pid
error: unknown type name =E2=80=98uid_t=E2=80=99
  uid_t  sender_euid;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
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
2.5.0
