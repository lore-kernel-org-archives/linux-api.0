From: <arnd-r2nGTMty4D4@public.gmane.org>
Subject: (unknown)
Date: Mon, 27 Apr 2009 10:42:16 -0400
Message-ID: <20090427143739.584082891@arndb.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

>From arnd-r2nGTMty4D4@public.gmane.org Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220-r2nGTMty4D4@public.gmane.org>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:24 +0200
From: arnd-r2nGTMty4D4@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: john.williams-g5w7nrANp4BDPfheJLI6IQ@public.gmane.org,
 monstr-pSz03upnqPeHXe+LvDLADg@public.gmane.org,
 linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 liqin.chen-+XGAvkf1AAHby3iVrkZq2A@public.gmane.org,
 Sam Ravnborg <sam-uyr5N9Q2VtJg9hUCZPvPmw@public.gmane.org>
Subject: [RFC 14/17] syscalls.h add the missing sys_pipe2 declaration
Content-Disposition: inline; filename=0034-Add-the-missing-sys_pipe2-declaration.patch
X-Provags-ID: V01U2FsdGVkX18BNhYLkO16wJIO7fZdR0d6C1KKxWKU4X9yTw1
 kHYWFxFh/i+KLpzMQTnyQq6hXXodV+gYI/28GueZLh1YDCU7wt
 Ve65kcnRHOC2kZYsfpLWg==

In order to build the generic syscall table, we need a declaration
for every system call. sys_pipe2 was added without a proper declaration,
so add this to syscalls.h now.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 include/linux/syscalls.h |    1 	1 +	0 -	0 !
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/linux/syscalls.h
===================================================================
--- linux-2.6.orig/include/linux/syscalls.h
+++ linux-2.6/include/linux/syscalls.h
@@ -433,6 +433,7 @@ asmlinkage long sys_fcntl(unsigned int f
 asmlinkage long sys_fcntl64(unsigned int fd,
 				unsigned int cmd, unsigned long arg);
 #endif
+asmlinkage long sys_pipe2(int __user *fildes, int flags);
 asmlinkage long sys_dup(unsigned int fildes);
 asmlinkage long sys_dup2(unsigned int oldfd, unsigned int newfd);
 asmlinkage long sys_dup3(unsigned int oldfd, unsigned int newfd, int flags);

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
