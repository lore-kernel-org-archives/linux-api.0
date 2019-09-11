From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH 2/4] rseq: Fix: Unregister rseq for CLONE_TLS
Date: Tue, 10 Sep 2019 20:31:01 -0400 (EDT)
Message-ID: <248314994.16.1568161861658.JavaMail.zimbra@efficios.com>
References: <20190911002744.8690-1-mathieu.desnoyers@efficios.com> <20190911002744.8690-2-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190911002744.8690-2-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, paulmck <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Dmitry Vyukov <dvyukov@google.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Of course, this patch title should read:

  rseq: Fix: Unregister rseq for CLONE_SETTLS

----- On Sep 11, 2019, at 1:27 AM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

 
> /*
>  * If parent process has a registered restartable sequences area, the
> - * child inherits. Only applies when forking a process, not a thread.
> + * child inherits. Unregister rseq for a clone with CLONE_TLS set.

and here CLONE_SETTLS as well.

>  */
> static inline void rseq_fork(struct task_struct *t, unsigned long clone_flags)
> {
> -	if (clone_flags & CLONE_THREAD) {
> +	if (clone_flags & CLONE_TLS) {

.. and here.

Thanks,

Mathieu

> 		t->rseq = NULL;
> 		t->rseq_sig = 0;
> 		t->rseq_event_mask = 0;
> --
> 2.17.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
