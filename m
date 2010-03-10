From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 050/160] prctl: add PR_SET_PROCTITLE_AREA option for	prctl()
Date: Wed, 10 Mar 2010 10:42:23 +0900 (JST)
Message-ID: <20100310103910.7CFF.A69D9226@jp.fujitsu.com>
References: <20100309221704.GA1401@redhat.com> <4B96CCB8.9040507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B96CCB8.9040507-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, tss-X3B1VOXEql0@public.gmane.org, xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 03/09/2010 02:17 PM, Oleg Nesterov wrote:
> > So, do you really think that this particular case deserves the new
> > syscall?
> 
> Continuing a bad thing is never a good reason.  Break bad habits.

OK. the opinion of caller folks (i.e. you) should be important
rather than the patch maker. I'll make respin.

thanks.
