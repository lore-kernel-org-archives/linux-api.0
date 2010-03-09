From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for
	prctl()
Date: Tue, 9 Mar 2010 23:17:04 +0100
Message-ID: <20100309221704.GA1401@redhat.com>
References: <201003052142.o25Lgbpg029522@imap1.linux-foundation.org> <20100306095705.GA26221@infradead.org> <20100309134105.7CDB.A69D9226@jp.fujitsu.com> <4B95DAF3.5050605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B95DAF3.5050605-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/08, Ulrich Drepper wrote:
>
> On 03/08/2010 08:44 PM, KOSAKI Motohiro wrote:
> > I don't think this is big matter. Does using syscall have any benefit?
> > I don't have strong mention. merely, Timo's original proposal used
> > prctl.
>
> Syscalls don't have to go through the multiplexer in grab bag calls like
> prctl, ioctl, etc.  And they are more reliably to test for at runtime.
> An ENOSYS error is unmistakably clear.  An EINVAL error, as returned by
> prctl when encountering an unknown function argument, could also mean
> the argument isn't valid.  That's a common problem of most multiplexer
> syscalls and a reason why they should be avoided.

Agreed, but this applies to any prtcl() request. And we already have
PR_GET_NAME/PR_SET_NAME which is very close to PR_SET_PROCTITLE_AREA.

So, do you really think that this particular case deserves the new
syscall?

Oleg.
