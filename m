From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/3] System call design: preadv & pwritev.
Date: Thu, 18 Dec 2008 12:42:19 +0100
Message-ID: <1229600542-11585-1-git-send-email-kraxel@redhat.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

  Hi folks,

Guess I have your attention now thanks to LWN ;)

Next round of the preadv & pwritev patch series, hopefully finally
solving the architecture issues.  I've decided to go with the suggestion
from the s390 guys:  split the 64bit offset into two explicitly coded
32bit halves.  The syscall prototype should work now for all archs
without (in-kernel) wrappers.  glibc must wrap the syscalls though to
hide that split from the applications.  But there is no way around glibc
wrappers anyway, so I think that is sensible decision.

cheers,
  Gerd

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
