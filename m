From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for prctl()
Date: Tue,  9 Mar 2010 13:44:03 +0900 (JST)
Message-ID: <20100309134105.7CDB.A69D9226@jp.fujitsu.com>
References: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org> <20100306095705.GA26221@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100306095705.GA26221-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

> On Fri, Mar 05, 2010 at 01:42:37PM -0800, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org wrote:
> > This patch makes it possible for userspace to implement setproctitle()
> > cleanly.  It adds a new PR_SET_PROCTITLE_AREA option for prctl(), which
> > updates task's mm_struct->arg_start and arg_end to the given area.
> 
> Why can't we make this a proper system call?

I don't think this is big matter. Does using syscall have any benefit?
I don't have strong mention. merely, Timo's original proposal used
prctl.
