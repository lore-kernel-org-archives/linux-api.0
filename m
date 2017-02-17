From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Fri, 17 Feb 2017 09:00:35 -0800
Message-ID: <CALCETrXzFDotNzqYmSoHwGoDUKidHVW+HKwJBRFFr+Z1Z=WbjQ@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com> <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Tyler Hicks <tyhicks@canonical.com>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, linux-api@ver.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 16, 2017 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Feb 15, 2017 at 7:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Mon, Feb 13, 2017 at 7:45 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
>>> This patch set is the third revision of the following two previously
>>> submitted patch sets:
>>>
>>> v1: http://lkml.kernel.org/r/1483375990-14948-1-git-send-email-tyhicks@canonical.com
>>> v1: http://lkml.kernel.org/r/1483377999-15019-2-git-send-email-tyhicks@canonical.com
>>>
>>> v2: http://lkml.kernel.org/r/1486100262-32391-1-git-send-email-tyhicks@canonical.com
>>>
>>> The patch set aims to address some known deficiencies in seccomp's current
>>> logging capabilities:
>>>
>>>   1. Inability to log all filter actions.
>>>   2. Inability to selectively enable filtering; e.g. devs want noisy logging,
>>>      users want relative quiet.
>>>   3. Consistent behavior with audit enabled and disabled.
>>>   4. Inability to easily develop a filter due to the lack of a
>>>      permissive/complain mode.
>>
>> I think I dislike this, but I think my dislikes may be fixable with
>> minor changes.
>>
>> What I dislike is that this mixes app-specific built-in configuration
>> (seccomp) with global privileged stuff (audit).  The result is a
>> potentially difficult to use situation in which you need to modify an
>> app to make it loggable (using RET_LOG) and then fiddle with
>> privileged config (auditctl, etc) to actually see the logs.
>
> You make a good point about RET_LOG vs log_max_action. I think making
> RET_LOG the default value would work for 99% of the cases.
>
>> What if, instead of logging straight to the audit log, SECCOMP_RET_LOG
>> [1] merely meant "tell our parent about this syscall"?  (Ideally we'd
>> also figure out a way to express "log this and allow", "log this and
>> do ERRNO", etc.)  Then we could have another mechanism that installs a
>> layer in the seccomp stack that, instead of catching syscalls, catches
>> log events and sticks them in a ring buffer (or audit).
>
> So, I really don't like this because it's yet another logging system.
> We already have a security event logger: audit. This continues to use
> that subsystem without changing semantics very much.

Audit sucks for this kind of thing, though.  It's mostly useless in a
container, for example.  But let me propose a middle ground.

>
>> Concretely, it might work like this.  If a filter returns
>> SECCOMP_RET_LOG, then we "log" and keep processing.  SECCOMP_RET_LOG
>> is otherwise treated literally like SECCOMP_RET_ALLOW and has no
>> effect on return value.  If you want log-and-kill, you install two
>> filters.
>>
>> There's a new seccomp(2) action that returns an fd.  That fd
>> references a new thing in the seccomp stack that is a BPF program that
>> is called whenever SECCOMP_RET_LOG is returned from lower down.  The
>> output of this filter determines whether the log event is ignored,
>> stuck in the ring buffer, or passed up the stack for further
>> processing.  You read(2) the fd to access the ring buffer.
>>
>> Using this mechanism, you could write a simple seccomptrace tool that
>> needs no privilege and dumps SECCOMP_RET_LOG events from the target
>> program to stderr.
>
> If someone was going to do this, they could just as well set up a
> tracer to use RET_TRAP. (And this is what things like minijail does
> already, IIRC.) The reality of the situation is that this is way too
> much overhead for the common case. We need a generalized logging
> system that uses the existing logging mechanisms.

True.  And we can always add this part later if we want to.

But let me propose a different, much more minor change to the patches:

First, we currently have seccomp_run_filters running the whole stack
and keeping (more or less) the lowest value.  What if we changed it a
bit so that return values of 0xff???????? were special.  Specifically,
a return value of 0xff?????? from a filter means "take some action
right now but don't change the outcome of the filter stack".  Then we
define SECCOMP_RET_LOG as 0xff000000 and perhaps reserve a few bits to
be a number reflected in the log entry.  (e.g. SECCOMP_RET_LOG(x) =
0xff000000 | (x & 0xff)).

Now SECCOMP_RET_LOG or SECCOMP_RET_LOG(0) does approximately what it
does in the current patch series if used in isolation, but you can
install two filters, one of which logs and one of which kills, to get
"log and kill".

If we do this, we might want SECCOMP_RET_KILL to stop running filters
so that filters farther up the stack don't log the syscall.

What do you think?  This should be a very small delta on top of the
current patches.
