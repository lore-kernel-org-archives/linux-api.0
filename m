From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v06 05/36] uapi linux/sysctl.h: use __kernel_size_t instead of size_t
Date: Sun,  6 Aug 2017 18:43:56 +0200
Message-ID: <20170806164428.2273-6-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Matthew Whitehead <tedheadster-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Joel Scherpelz <jscherpelz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lorenzo Colitti <lorenzo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Fixes userspace compilation error:

error: unknown type name ‘size_t’

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
---
 include/uapi/linux/sysctl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index e13d48058b8d..35a4b8b417fe 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -35,9 +35,9 @@ struct __sysctl_args {
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
 
-- 
2.13.3
