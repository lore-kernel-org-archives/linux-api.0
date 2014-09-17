From: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
Subject: kexec.h:61: userspace cannot reference function or variable defined in the kernel
Date: Wed, 17 Sep 2014 21:35:23 +0200
Message-ID: <1410982523-8227-1-git-send-email-xypron.glpk@gmx.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
List-Id: linux-api@vger.kernel.org

make headers_check
on mips cavium octeon
for v3.17-rc5
results in
kexec.h:61: userspace cannot reference function or variable defined in the
 kernel

Best regards

Heinrich Schuchardt
