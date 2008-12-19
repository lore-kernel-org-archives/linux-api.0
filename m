From: y@redhat.com
Subject: [PATCH v5 0/6] Add preadv & pwritev system calls.
Date: Fri, 19 Dec 2008 16:58:19 +0100
Message-ID: <13649.1928286434$1229702432@news.gmane.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

  Hi folks,

Next round of the preadv & pwritev patch series, addressing review
comments:

 * Common code for the compat syscall versions is factored
   out in preparing patches.  
 * Added prototypes to syscall.h
 * Fixup some whitespace damage.

It's also the last release before I fall off the internet for the x-mas
and new-year holidays.  I'll be online again starting Jan 5th and will
deal with the remaining issues (if any) then.

cheers,
  Gerd

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
