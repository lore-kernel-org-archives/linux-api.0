From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH, RESEND2] getrusage: fill ru_maxrss value
Date: Wed, 17 Dec 2008 19:48:44 +0900 (JST)
Message-ID: <20081217194646.F677.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081217105639.63e765eb@psychotron.englab.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081217105639.63e765eb-YzwxZg+R7evSU73v1vjTzyO4YDw3rz4rAInAS/Ez/D0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jpirko-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michael Kerrisk <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hugh-DTz5qymZ9yRBDgjK7y7TUQ@public.gmane.org>, jlim-sJ/iWh9BUns@public.gmane.org
List-Id: linux-api@vger.kernel.org

> (updated)
> 
> This patch makes ->ru_maxrss value in struct rusage filled accordingly to
> rss hiwater mark. This struct is filled as a parameter to
> getrusage syscall. ->ru_maxrss value is set to pages which might be correct
> as "time" application converts it to KBs.

Why?
if kernel convert to KB, glibc don't need any change.



--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
