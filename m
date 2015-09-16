From: Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/7] [media] exynos4-is: use monotonic timestamps as
 advertized
Date: Wed, 16 Sep 2015 10:55:40 +0200
Message-ID: <55F92E8C.3020701@samsung.com>
References: <1442332148-488079-1-git-send-email-arnd@arndb.de>
 <1442332148-488079-5-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <1442332148-488079-5-git-send-email-arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 15/09/15 17:49, Arnd Bergmann wrote:
> The exynos4 fimc capture driver claims to use monotonic
> timestamps but calls ktime_get_real_ts(). This is both
> an incorrect API use, and a bad idea because of the y2038
> problem and the fact that the wall clock time is not reliable
> for timestamps across suspend or settimeofday().
> 
> This changes the driver to use the normal v4l2_get_timestamp()
> function like all other drivers.
> 
> Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Acked-by: Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
