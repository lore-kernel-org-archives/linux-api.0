From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Wed, 22 Feb 2017 10:39:44 -0800
Message-ID: <CAGXu5jJiK1CyM9M39F9nqpY1YJ90-St_gv6BYMzeUFejTDapPg@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com> <CALCETrXzFDotNzqYmSoHwGoDUKidHVW+HKwJBRFFr+Z1Z=WbjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXzFDotNzqYmSoHwGoDUKidHVW+HKwJBRFFr+Z1Z=WbjQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tyler Hicks <tyhicks@canonical.com>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, linux-api@ver.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Feb 17, 2017 at 9:00 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Feb 16, 2017 at 3:29 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Feb 15, 2017 at 7:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> If someone was going to do this, they could just as well set up a
>> tracer to use RET_TRAP. (And this is what things like minijail does
>> already, IIRC.) The reality of the situation is that this is way too
>> much overhead for the common case. We need a generalized logging
>> system that uses the existing logging mechanisms.
>
> True.  And we can always add this part later if we want to.
>
> But let me propose a different, much more minor change to the patches:
>
> First, we currently have seccomp_run_filters running the whole stack
> and keeping (more or less) the lowest value.  What if we changed it a
> bit so that return values of 0xff???????? were special.  Specifically,
> a return value of 0xff?????? from a filter means "take some action
> right now but don't change the outcome of the filter stack".  Then we
> define SECCOMP_RET_LOG as 0xff000000 and perhaps reserve a few bits to
> be a number reflected in the log entry.  (e.g. SECCOMP_RET_LOG(x) =
> 0xff000000 | (x & 0xff)).

I'm not a fan of adding more logic to the filter-running loop, but
this idea is tempting.

> Now SECCOMP_RET_LOG or SECCOMP_RET_LOG(0) does approximately what it
> does in the current patch series if used in isolation, but you can
> install two filters, one of which logs and one of which kills, to get
> "log and kill".
>
> If we do this, we might want SECCOMP_RET_KILL to stop running filters
> so that filters farther up the stack don't log the syscall.

I don't want to change the semantics of filter execution for this, so
I'd prefer to avoid adding an early abort.

> What do you think?  This should be a very small delta on top of the
> current patches.

What I don't like about this is that the logging and the action taken
are now totally separate. You could even end up having something
install multiple RET_LOGs, which aren't tied to what seccomp actually
decides to do in the end.

I'm not entirely opposed to the 0xff.... idea, but I don't think it
overlaps with logging very well. I would want seccomp logging to
reflect the actual action taken. Okay, I will now begin
stream-of-consciousness dumping to email...

I'm sure gmail will mangle whitespace, but here's sort of the 0xff
idea, well, actually 0x80....

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index 0f238a43ff1e..f61a0b783f6d 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -32,6 +32,7 @@
 #define SECCOMP_RET_ALLOW      0x7fff0000U /* allow */

 /* Masks for the return value sections. */
+#define SECCOMP_RET_OOB 0x80000000U
 #define SECCOMP_RET_ACTION     0x7fff0000U
 #define SECCOMP_RET_DATA       0x0000ffffU

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index f8f88ebcb3ba..4fac64fdfdc1 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -197,6 +197,9 @@ static u32 seccomp_run_filters(const struct
seccomp_data *sd)
        for (; f; f = f->prev) {
                u32 cur_ret = BPF_PROG_RUN(f->prog, sd);

+               if (unlikely(cur_ret & SECCOMP_RET_OOB))
+                       seccomp_oob_action(cur_ret);
+
                if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
                        ret = cur_ret;
        }

So, if SECCOMP_RET_OOB_LOG existed, it'd need to be installed as a
stand-alone filter, since it's still a BPF return value. That seems
... unfriendly ... as it would have to duplicate all the same logic as
another filter running along side it. e.g.:

filter 1 (actual actions):
- check arch
- check syscalls, jump to resolution
- ok: ret_allow
- unexpected: ret_allow
- weird: ret_errno
- bad: ret_kill

filter 2 ("oob" logging):
- check arch
- check syscalls, jump to resolution
- ok: ret_allow
- unexpected: ret_oob_log <- only difference
- weird: ret_errno
- bad: ret_kill

I mean, filter 2 could also just be:
- check arch
- check syscalls, jump to resolution
- unexpected: ret_oob_log
- everything else: ret_allow

But this kind of split logic seems needlessly complex and error-prone
on the filter developer's end. I don't think OOB logging should be
used here. Adding RET_LOG seems like the right approach to me.

The observations that it's per-process logging vs system-wide log
reporting is, I think, still problematic, but the case where a
developer is using RET_LOG is under non-production development and it
can be argued that the general case is developer==system owner, so
this is, again, sufficient.

So... I remain convinced that Tyler's series is the correct direction
to solve the bulk of the logging needs currently expressed by
developers and system owners.

-Kees

-- 
Kees Cook
Pixel Security
