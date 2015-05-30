From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 33/98] include/uapi/linux/sysctl.h: use __kernel_size_t instead of size_t
Date: Sat, 30 May 2015 17:38:25 +0200
Message-ID: <1433000370-19509-34-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, Ben Greear <greearb@candelatech.com>, Prarit Bhargava <prarit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

error: unknown type name =E2=80=98size_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/sysctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 0956373..6595f3a 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -37,9 +37,9 @@ struct __sysctl_args {
 	int __user *name;
 	int nlen;
 	void __user *oldval;
-	size_t __user *oldlenp;
+	__kernel_size_t __user *oldlenp;
 	void __user *newval;
-	size_t newlen;
+	__kernel_size_t newlen;
 	unsigned long __unused[4];
 };
=20
--=20
2.1.4
