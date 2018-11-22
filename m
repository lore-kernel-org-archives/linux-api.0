From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Thu, 22 Nov 2018 10:04:16 -0500 (EST)
Message-ID: <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com> <20181122143603.GD23599@brightrain.aerifal.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181122143603.GD23599@brightrain.aerifal.cx>
Sender: linux-kernel-owner@vger.kernel.org
To: Rich Felker <dalias@libc.org>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2018, at 9:36 AM, Rich Felker dalias@libc.org wrote:

> On Wed, Nov 21, 2018 at 01:39:32PM -0500, Mathieu Desnoyers wrote:
>> Register rseq(2) TLS for each thread (including main), and unregister
>> for each thread (excluding main). "rseq" stands for Restartable
>> Sequences.
> 
> Maybe I'm missing something obvious, but "unregister" does not seem to
> be a meaningful operation. Can you clarify what it's for?

There are really two ways rseq TLS can end up being unregistered: either
through an explicit call to the rseq "unregister", or when the OS frees the
thread's task struct.

You bring an interesting point here: do we need to explicitly unregister
rseq at thread exit, or can we leave that to the OS ?

The key thing to look for here is whether it's valid to access the
TLS area of the thread from preemption or signal delivery happening
at the very end of START_THREAD_DEFN. If it's OK to access it until
the very end of the thread lifetime, then we could do without an
explicit unregistration. However, if at any given point of the late
thread lifetime we end up in a situation where reading or writing to
that TLS area can cause corruption, then we need to carefully
unregister it before that memory is reclaimed/reused.

What we have below the current location for the __rseq_unregister_current_thread ()
call is as follows. I'm not all that convinced that it's valid to access the TLS
area up until __exit_thread () at the very end, especially after setting
setxid_futex back to 0.

Thoughts ?

  /* Unregister rseq TLS from kernel. */
  if (has_rseq && __rseq_unregister_current_thread ())
    abort();

  advise_stack_range (pd->stackblock, pd->stackblock_size, (uintptr_t) pd,
                      pd->guardsize);

  /* If the thread is detached free the TCB.  */
  if (IS_DETACHED (pd))
    /* Free the TCB.  */
    __free_tcb (pd);
  else if (__glibc_unlikely (pd->cancelhandling & SETXID_BITMASK))
    {
      /* Some other thread might call any of the setXid functions and expect
         us to reply.  In this case wait until we did that.  */
      do
        /* XXX This differs from the typical futex_wait_simple pattern in that
           the futex_wait condition (setxid_futex) is different from the
           condition used in the surrounding loop (cancelhandling).  We need
           to check and document why this is correct.  */
        futex_wait_simple (&pd->setxid_futex, 0, FUTEX_PRIVATE);
      while (pd->cancelhandling & SETXID_BITMASK);

      /* Reset the value so that the stack can be reused.  */
      pd->setxid_futex = 0;
    }

  /* We cannot call '_exit' here.  '_exit' will terminate the process.

     The 'exit' implementation in the kernel will signal when the
     process is really dead since 'clone' got passed the CLONE_CHILD_CLEARTID
     flag.  The 'tid' field in the TCB will be set to zero.

     The exit code is zero since in case all threads exit by calling
     'pthread_exit' the exit status must be 0 (zero).  */
  __exit_thread ();

  /* NOTREACHED */

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
