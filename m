From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Date: Fri, 20 Dec 2019 21:37:59 +0100
Message-ID: <87imman36g.fsf@mid.deneb.enyo.de>
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191220201207.17389-1-mathieu.desnoyers@efficios.com> (Mathieu
        Desnoyers's message of "Fri, 20 Dec 2019 15:12:06 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, Neel Natu <neelnatu@google.com>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> diff --git a/include/uapi/linux/rseq.h b/include/uapi/linux/rseq.h
> index 9a402fdb60e9..6f26b0b148a6 100644
> --- a/include/uapi/linux/rseq.h
> +++ b/include/uapi/linux/rseq.h
> @@ -100,7 +100,9 @@ struct rseq {
>  	 * instruction sequence block, as well as when the kernel detects that
>  	 * it is preempting or delivering a signal outside of the range
>  	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
> -	 * before reclaiming memory that contains the targeted struct rseq_cs.
> +	 * before reclaiming memory that contains the targeted struct rseq_cs
> +	 * or reclaiming memory that contains the code refered to by the
> +	 * start_ip and post_commit_offset fields of struct rseq_cs.

Maybe mention that it's good practice to clear rseq_cs before
returning from a function that contains a restartable sequence?

That will deal with the dlclose issue because even if the function
calls dlclose itself, unmapping something on call stack for dlclose is
already undefined.
