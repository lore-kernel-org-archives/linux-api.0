From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
Date: Tue, 27 Feb 2018 23:02:16 +0000
Message-ID: <CALCETrUTiUeV71jgYWup0CZwG8eQ3=W7X5FgJqmgPxnYbFsccw@mail.gmail.com>
References: <20180227004121.3633-1-mic@digikod.net> <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net> <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 27, 2018 at 10:14 PM, Mickaël Salaün <mic@digikod.net> wrote:
>
> On 27/02/2018 06:01, Andy Lutomirski wrote:
>>
>>
>>> On Feb 26, 2018, at 8:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>>> On Tue, Feb 27, 2018 at 12:41 AM, Mickaël Salaün <mic@digikod.net> wrote:
>>>> A landlocked process has less privileges than a non-landlocked process
>>>> and must then be subject to additional restrictions when manipulating
>>>> processes. To be allowed to use ptrace(2) and related syscalls on a
>>>> target process, a landlocked process must have a subset of the target
>>>> process' rules.
>>>>
>>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>>> Cc: David S. Miller <davem@davemloft.net>
>>>> Cc: James Morris <james.l.morris@oracle.com>
>>>> Cc: Kees Cook <keescook@chromium.org>
>>>> Cc: Serge E. Hallyn <serge@hallyn.com>
>>>> ---
>>>>
>>>> Changes since v6:
>>>> * factor out ptrace check
>>>> * constify pointers
>>>> * cleanup headers
>>>> * use the new security_add_hooks()
>>>> ---
>>>> security/landlock/Makefile       |   2 +-
>>>> security/landlock/hooks_ptrace.c | 124 +++++++++++++++++++++++++++++++++++++++
>>>> security/landlock/hooks_ptrace.h |  11 ++++
>>>> security/landlock/init.c         |   2 +
>>>> 4 files changed, 138 insertions(+), 1 deletion(-)
>>>> create mode 100644 security/landlock/hooks_ptrace.c
>>>> create mode 100644 security/landlock/hooks_ptrace.h
>>>>
>>>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>>>> index d0f532a93b4e..605504d852d3 100644
>>>> --- a/security/landlock/Makefile
>>>> +++ b/security/landlock/Makefile
>>>> @@ -3,4 +3,4 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
>>>> landlock-y := init.o chain.o task.o \
>>>>        tag.o tag_fs.o \
>>>>        enforce.o enforce_seccomp.o \
>>>> -       hooks.o hooks_cred.o hooks_fs.o
>>>> +       hooks.o hooks_cred.o hooks_fs.o hooks_ptrace.o
>>>> diff --git a/security/landlock/hooks_ptrace.c b/security/landlock/hooks_ptrace.c
>>>> new file mode 100644
>>>> index 000000000000..f1b977b9c808
>>>> --- /dev/null
>>>> +++ b/security/landlock/hooks_ptrace.c
>>>> @@ -0,0 +1,124 @@
>>>> +/*
>>>> + * Landlock LSM - ptrace hooks
>>>> + *
>>>> + * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2, as
>>>> + * published by the Free Software Foundation.
>>>> + */
>>>> +
>>>> +#include <asm/current.h>
>>>> +#include <linux/errno.h>
>>>> +#include <linux/kernel.h> /* ARRAY_SIZE */
>>>> +#include <linux/lsm_hooks.h>
>>>> +#include <linux/sched.h> /* struct task_struct */
>>>> +#include <linux/seccomp.h>
>>>> +
>>>> +#include "common.h" /* struct landlock_prog_set */
>>>> +#include "hooks.h" /* landlocked() */
>>>> +#include "hooks_ptrace.h"
>>>> +
>>>> +static bool progs_are_subset(const struct landlock_prog_set *parent,
>>>> +               const struct landlock_prog_set *child)
>>>> +{
>>>> +       size_t i;
>>>> +
>>>> +       if (!parent || !child)
>>>> +               return false;
>>>> +       if (parent == child)
>>>> +               return true;
>>>> +
>>>> +       for (i = 0; i < ARRAY_SIZE(child->programs); i++) {
>>>
>>> ARRAY_SIZE(child->programs) seems misleading.  Is there no define
>>> NUM_LANDLOCK_PROG_TYPES or similar?
>>>
>>>> +               struct landlock_prog_list *walker;
>>>> +               bool found_parent = false;
>>>> +
>>>> +               if (!parent->programs[i])
>>>> +                       continue;
>>>> +               for (walker = child->programs[i]; walker;
>>>> +                               walker = walker->prev) {
>>>> +                       if (walker == parent->programs[i]) {
>>>> +                               found_parent = true;
>>>> +                               break;
>>>> +                       }
>>>> +               }
>>>> +               if (!found_parent)
>>>> +                       return false;
>>>> +       }
>>>> +       return true;
>>>> +}
>>>
>>> If you used seccomp, you'd get this type of check for free, and it
>>> would be a lot easier to comprehend.  AFAICT the only extra leniency
>>> you're granting is that you're agnostic to the order in which the
>>> rules associated with different program types were applied, which
>>> could easily be added to seccomp.
>>
>> On second thought, this is all way too complicated.  I think the correct logic is either "if you are filtered by Landlock, you cannot ptrace anything" or to delete this patch entirely.
>
> This does not fit a lot of use cases like running a container
> constrained with some Landlock programs. We should not deny users the
> ability to debug their stuff.
>
> This patch add the minimal protection which are needed to have
> meaningful Landlock security policy. Without it, they may be easily
> bypassable, hence useless.
>

I think you're wrong here.  Any sane container trying to use Landlock
like this would also create a PID namespace.  Problem solved.  I still
think you should drop this patch.

>
>> If something like Tycho's notifiers goes in, then it's not obvious that, just because you have the same set of filters, you have the same privilege.  Similarly, if a feature that lets a filter query its cgroup goes in (and you proposed this once!) then the logic you implemented here is wrong.
>
> I don't get your point. Please take a look at the tests (patch 10).

I don't know what you want me to look at.

What I'm saying is: suppose I write a filter like this:

bool allow_some_action(void)
{
  int value_from_container_manager = call_out_to_user_notifier();
  return value_from_container_manager == 42;
}

or

bool allow_some_action(void)
{
  return my_cgroup_is("/foo/bar");
}

In both of these cases, your code will do the wrong thing.

>
>>
>> Or you could just say that it's the responsibility of a Landlock user to properly filter ptrace() just like it's the responsibility of seccomp users to filter ptrace if needed.
>
> A user should be able to enforce a security policy on ptrace as well,
> but this patch enforce a minimal set of security boundaries. It will be
> easy to add a new Landlock program type to get this kind of access control.

It sounds like you want Landlock to be a complete container system all
by itself.  I disagree with that design goal.
