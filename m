From: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 0/3] restartable sequences v2: fast user-space percpu
 critical sections
Date: Tue, 27 Oct 2015 16:56:35 -0700
Message-ID: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an update to the previously posted series at:
  https://lkml.org/lkml/2015/6/24/665

Dave Watson has posted a similar follow-up which allows additional critical
regions to be registered as well as single-step support at:
  https://lkml.org/lkml/2015/10/22/588

This series is a new approach which introduces an alternate ABI that does not
depend on open-coded assembly nor a central 'repository' of rseq sequences.
Sequences may now be inlined and the preparatory[*] work for the sequence can
be written in a higher level language.

This new ABI has also been written to support debugger interaction in a way
that the previous ABI could not.

[*] A sequence essentially has 3 steps:
  1) Determine which cpu the sequence is being run on
  2) Preparatory work specific to the state read in 1)
  3) A single commit instruction which finalizes any state updates.

We require a single instruction for (3) so that if it is interrupted in any
way, we can proceed from (1) once more [or potentially bail].

This new ABI can be described as:
 Progress is ordered as follows:
  *0. Userspace stores current event+cpu counter values
   1. Userspace loads the rip to move to at failure into cx
   2. Userspace loads the rip of the instruction following
      the critical section into a registered TLS address.
   3. Userspace loads the values read at [0] into a known
      location.
   4. Userspace tests to see whether the current event and
      cpu counter values match those stored at 0.  Manually
      jumping to the address from [1] in the case of a
      mismatch.
 
      Note that if we are preempted or otherwise interrupted
      then the kernel can also now perform this comparison
      and conditionally jump us to [1].
   5. Our final instruction before [2] is then our commit.
      The critical section is self-terminating.  [2] must
      also be cleared at this point.
 
 For x86_64:
   [3] uses rdx to represent cpu and event counter as a
       single 64-bit value.
 
 For i386:
   [3] uses ax for cpu and dx for the event_counter.
 
  Both:
   Instruction after commit: rseq_state->post_commit_instr
   Current event and cpu state: rseq_state->event_and_cpu

Exactly, for x86_64 this looks like:
  movq <failed>, rcx [1]
  movq $1f, <commit_instr> [2]
  cmpq <start value>, <current value> [3] (start is in rcx)
  jnz <failed> (4)
  movq <to_write>, (<target>) (5)
  1: movq $0, <commit_instr>

There has been some related discussion, which I am supportive of, in which
we use fs/gs instead of TLS.  This maps naturally to the above and removes
the current requirement for per-thread initialization (this is a good thing!).

On debugger interactions:

There are some nice properties about this new style of API which allow it to
actually support safe interactions with a debugger:
 a) The event counter is a per-cpu value.  This means that we can not advance
    it if no threads from the same process execute on that cpu.  This
    naturally allows basic single step support with thread-isolation.
 b) Single-step can be augmented to evalute the ABI without incrementing the
    event count.
 c) A debugger can also be augmented to evaluate this ABI and push restarts
    on the kernel's behalf.

This is also compatible with David's approach of not single stepping between
2-4 above.  However, I think these are ultimately a little stronger since true
single-stepping and breakpoint support would be available.  Which would be
nice to allow actual debugging of sequences.

(Note that I haven't bothered implementing these in the current patchset as we
are still winnowing down on the ABI and they just add complexity.  It's
important to note that they are possible however.)

Thanks,

- Paul
