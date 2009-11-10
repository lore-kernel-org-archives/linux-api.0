From: Bryan Donlan <bdonlan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Mon, 9 Nov 2009 19:00:17 -0500
Message-ID: <3e8340490911091600v3a0e9b67r279349ac852d604a@mail.gmail.com>
References: <20091103094703.GB11134@hack.redhat.com> <20091103230548.0B45.A69D9226@jp.fujitsu.com>
	<20091104002544.0B4A.A69D9226@jp.fujitsu.com> <20091109144717.0cd17421.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091109144717.0cd17421.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Americo Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Timo Sirainen <tss-X3B1VOXEql0@public.gmane.org>, Ulrich Drepper <drepper-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 9, 2009 at 5:47 PM, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3Sm6D+HspMUB@public.gmane.org=
g> wrote:

> What happens if userspace unmaps the memory after telling the kernel =
to
> use it?
>
> Will processes which try to read the command line get an error readin=
g
> /proc? =A0If so, do all the commandline-reading programs in the world
> handle this in an appropriate fashion?

This case can already occur in the current code; the userspace process
would have to munmap() the top of its stack, but it certainly can do
so if it tries. In any case, access_process_vm() then returns 0
because of the fault, and thus /proc/pid/cmdline is seen to have zero
length. Since a zero-length /proc/pid/cmdline occurs with kernel
threads as well, we know this isn't a problem.
