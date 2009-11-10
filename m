From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v5] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Tue, 10 Nov 2009 20:06:31 +0900
Message-ID: <2f11576a0911100306k7e2a64b9r35e13454be858140@mail.gmail.com>
References: <20091103094703.GB11134@hack.redhat.com>
	 <20091103230548.0B45.A69D9226@jp.fujitsu.com>
	 <20091104002544.0B4A.A69D9226@jp.fujitsu.com>
	 <20091109144717.0cd17421.akpm@linux-foundation.org>
	 <3e8340490911091600v3a0e9b67r279349ac852d604a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753412AbZKJLGa@vger.kernel.org>
In-Reply-To: <3e8340490911091600v3a0e9b67r279349ac852d604a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Americo Wang <xiyou.wangcong@gmail.com>, Timo Sirainen <tss@iki.fi>, Ulrich Drepper <drepper@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

2009/11/10 Bryan Donlan <bdonlan@gmail.com>:
> On Mon, Nov 9, 2009 at 5:47 PM, Andrew Morton <akpm@linux-foundation.=
org> wrote:
>
>> What happens if userspace unmaps the memory after telling the kernel=
 to
>> use it?
>>
>> Will processes which try to read the command line get an error readi=
ng
>> /proc? =A0If so, do all the commandline-reading programs in the worl=
d
>> handle this in an appropriate fashion?
>
> This case can already occur in the current code; the userspace proces=
s
> would have to munmap() the top of its stack, but it certainly can do
> so if it tries. In any case, access_process_vm() then returns 0
> because of the fault, and thus /proc/pid/cmdline is seen to have zero
> length. Since a zero-length /proc/pid/cmdline occurs with kernel
> threads as well, we know this isn't a problem.

Plus, ps can read under exiting process. In this case, task->mm is NULL=
 and
proc_pid_cmdline return 0.

procps tools are already NUL safe since long time ago.
