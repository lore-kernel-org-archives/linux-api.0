From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v4] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Tue, 3 Nov 2009 23:07:47 +0900 (JST)
Message-ID: <20091103230548.0B45.A69D9226@jp.fujitsu.com>
References: <20091101211321.F3FC.A69D9226@jp.fujitsu.com> <20091103094703.GB11134@hack.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091103094703.GB11134-lyUE10xJyvyny3qCrzbmXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Americo Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Timo Sirainen <tss-X3B1VOXEql0@public.gmane.org>, Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

> >+		case PR_SET_PROCTITLE_AREA: {
> >+			struct mm_struct *mm = current->mm;
> >+			unsigned long addr = arg2;
> >+			unsigned long len = arg3;
> >+			unsigned long end = arg2 + arg3;
> >+
> >+			if (len > PAGE_SIZE)
> >+				return -EINVAL;
> >+
> >+			if (addr >= end)
> >+				return -EINVAL;
> >+
> >+			if (!access_ok(VERIFY_READ, addr, len))
> >+				return -EFAULT;
> >+
> >+			mutex_lock(&mm->arg_lock);
> >+			mm->arg_start = addr;
> 
> Is this safe? You're assigning a user-space pointer to kernel space...
> Don't we need copy_from_user()?

mm->arg_start, arg_end are defined so.
Please see current implementation. 


> >+			mm->arg_end = addr + len;
> 
> Since you already have 'end', no need to caculate this again. :)

Good catch :)
