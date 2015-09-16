From: Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/7] [media] use v4l2_get_timestamp where possible
Date: Wed, 16 Sep 2015 10:57:48 +0200
Message-ID: <55F92F0C.5000508@samsung.com>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de>
 <1442332148-488079-6-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1442332148-488079-6-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 15/09/15 17:49, Arnd Bergmann wrote:
> This is a preparation for a change to the type of v4l2 timestamps.
> v4l2_get_timestamp() is a helper function that reads the monotonic
> time and stores it into a 'struct timeval'. Multiple drivers implement
> the same thing themselves for historic reasons.
> 
> Changing them all to use v4l2_get_timestamp() is more consistent
> and reduces the amount of code duplication, and most importantly
> simplifies the following changes.
> 
> If desired, this patch can easily be split up into one patch per
> driver.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
> ---
For:

  drivers/media/platform/exynos4-is/fimc-lite.c
  drivers/media/platform/s3c-camif/camif-capture.c

Acked-by: Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
