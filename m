From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2] prctl: add PR_[GS]ET_KILLABLE
Date: Fri, 03 Aug 2018 08:34:59 -0500
Message-ID: <87sh3vd14s.fsf@xmission.com>
References: <20180730075241.24002-1-j@bitron.ch>
        <20180731070337.61004-1-j@bitron.ch>
        <20180731143949.GA1890@redhat.com>
        <f21a22c9730ab455504f58a5fbda72cba0eb1227.camel@bitron.ch>
        <20180801141914.GA21248@redhat.com>
        <7f7c57230e0279f4599bf13ae1d1d449d76ac232.camel@bitron.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7f7c57230e0279f4599bf13ae1d1d449d76ac232.camel@bitron.ch>
 (=?utf-8?Q?=22J=C3=BCrg?=
        Billeter"'s message of "Fri, 03 Aug 2018 12:15:16 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?J=C3=BCrg?= Billeter <j@bitron.ch>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Jürg Billeter <j@bitron.ch> writes:

> On Wed, 2018-08-01 at 16:19 +0200, Oleg Nesterov wrote:
>> On 07/31, Jürg Billeter wrote:
>> > 
>> > > Could you explain your use-case? Why a shell wants to use
>> > > CLONE_NEWPID?
>> > 
>> > To guarantee that there won't be any runaway processes, i.e., ensure
>> > that no descendants (background helper daemons or misbehaving
>> > processes) survive when the child process is terminated.
>> 
>> We already have PR_SET_CHILD_SUBREAPER.
>> 
>> Perhaps we can finally add PR_KILL_MY_DESCENDANTS_ON_EXIT? This was already
>> discussed some time ago, but I can't find the previous discussion... Simple
>> to implement.
>
> This would definitely be an option. You mentioned it last October in
> the PR_SET_PDEATHSIG_PROC discussion¹. However, as PID namespaces
> already exist and appear to be a good fit for the most part, I think it
> makes sense to just add the missing pieces to PID namespaces instead of
> duplicating part of the PID namespace functionality.
>
> Also, based on Eric's comment in that other discussion about
> no_new_privs not being allowed to increase the attack surface,
> PR_KILL_MY_DESCENDANTS_ON_EXIT might require CAP_SYS_ADMIN as well (due
> to setuid children). In which case the only potential benefit would be
> that it still allows the child to kill arbitrary processes, as far as I
> can tell.

We don't require CAP_SYS_ADMIN if it is a session and so I think a
similar allowance can be made for PR_KILL_MY_DESCENDANTS_ON_EXIT.  There
is a long standing tradition of being able to kill your own descendants
in linux.  I don't think this allows anything that the tranditional
session allowance for killing process won't.


>From the other direction I think we can just go ahead and fix handling
of the job control stop signals as well.  As far as I understand it
there is a legitimate complaint that SIGTSTP SIGTTIN SIGTTOU do not work
on a pid namespace leader.

The current implementation actual overshoots.  We only need to ignore
signals from the descendants in the pid namespace.  Ideally signals from
other processes are treated like normal.  We have only been able to
apply that ideal to SIGSTOP and SIGKILL as we can handle them in
prepare_signal.  Other signals can be blocked which means the logic to
handle them needs to live in get_signal where we may have no sender
information.


Signals with signal handlers we treat as normal.
Signals with whose default action is to ignore the signal we treat as
normal.

If a process is not in a context where job control has been set up then
SIGTSTP SIGTTIN and SIGTTOU are ignored.  I believe a typical init
process lives in just such an environment.  So I think we can safely
remove the special handling for the job control stops and not have
anyone care.

The rule is that the process group of the process must have a parent in
the same session, or the job control signals are ignored.

A typical init processes calls setsid, which guarantees it has no
parents in the same session.  So the default action of the job control
stops will be to ignore the signal.

A process once a session leader will always be a session leader, and
will never have any parents in a different pgrp in the same session.

So I think this gives us wiggle room needed to just fix this behavior.

Let's see.

For the signals SIGTSTP SIGTTIN and SIGTTOU if we are the typical init
process and we are a session leader we simply don't care who sends those
signals they will be ignored.


So I say we double check my assumption.  Look at sysv init, busy box,
upstart, systemd, whatever android uses, and the container runtimes
light weight inits.  Document it in a change log and just remove the
special case.

If except when handling job control signals is interesting init always
winds up a signal group leader I can't see the point in forcing init
to ignore the job control stop signals.

> ¹ https://lkml.org/lkml/2017/10/5/546

In the future please use mesage-id based links to email disccussions.
That way people can look up the conversations in other email archives.


Eric
