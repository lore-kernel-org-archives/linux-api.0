From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.4 0/3] Restartable Sequences Fixes
Date: Wed, 11 Dec 2019 10:28:22 -0500 (EST)
Message-ID: <211848436.2172.1576078102568.JavaMail.zimbra@efficios.com>
References: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, paulmck <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api <linux-api@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Thomas,

I thought those rseq fixes posted in September were in the -tip tree, but it
seems that they never made it to mainline.

Now Shuah Khan noticed the issue with gettid() compatibility with glibc
2.30+. This series contained that fix.

Should I re-post it, or is this series on track to get into mainline
at some point ?

Thanks,

Mathieu

----- On Sep 17, 2019, at 2:29 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> Hi,
> 
> Here is a small set of rseq fixes aiming Linux 5.4. Those should be
> backported to stable kernels >= 4.18.
> 
> Thanks,
> 
> Mathieu
> 
> Mathieu Desnoyers (3):
>  rseq: Fix: Reject unknown flags on rseq unregister
>  rseq: Fix: Unregister rseq for clone CLONE_VM
>  rseq/selftests: Fix: Namespace gettid() for compatibility with glibc
>    2.30
> 
> include/linux/sched.h                     |  4 ++--
> kernel/rseq.c                             |  2 ++
> tools/testing/selftests/rseq/param_test.c | 18 ++++++++++--------
> 3 files changed, 14 insertions(+), 10 deletions(-)
> 
> --
> 2.17.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
