From: Lafcadio Wluiki <wluikil-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Fri, 20 Jan 2017 16:44:31 +0100
Message-ID: <CAOWbf6c4TEFBcts-RMYbnPsDytVJccdG=ku9evs_VaYELLq2_A@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
 <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com> <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 19, 2017 at 12:35 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wro=
te:

>>>>> And from that point on neither nginx itself, nor any of its child
>>>>> processes may see processes in /proc anymore that belong to a differe=
nt
>>>>> user than "www-data". Other services running on the same system remai=
n
>>>>> unaffected.
>>>
>>> What affect, if any, does this have on ptrace() permissions?
>>
>> This should not affect ptrace() permissions or other system calls that
>> work directly on pids, the test in procfs is related to inodes before
>> the ptrace check, hmm what do you have in mind ?
>
> I'm wondering what problem you're trying to solve, then.  hidepid
> helps lock down procfs, but ISTM you might still want to lock down
> other PID-based APIs.

The (pseudo-) mount option hidepid=3D is about reducing information
leakage, that's all. It's not about enforcing access to PIDs if you
happen to know them.

This patch set simply make this global option usable locally, that's
all. It does not change semantics, it does not alter permission
checks, it doesn't turn the thing into something different than it is
right now. It just permits to turn on its effect in a more local way,
without having to change the whole system.

>>> Also, this one-way thing seems wrong to me.  I think it should roughly
>>> follow the no_new_privs rules instead.  IOW, if you unshare your
>>> pidns, it gets cleared.  Also, maybe you shouldn't be able to set it
>>
>> Andy I don't follow here, no_new_privs is never cleared right ? I
>> can't see the corresponding clear bit code for it.
>
> I believe that unsharing userns clears no_new_privs.

Reverting the a zero hidepid value if you create your own pid/user
namespace sounds OK to me. After all, if you create your own kingdom
anyway,  it should be up to you what you want to be able to see inside
of it...

> I feel like this feature (per-task hidepid) is subtle and complex
> enough that it should have a very clear purpose and use case before
> it's merged and that we should make sure that there isn't a better way
> to accomplish what you're trying to do.

The purpose for me is really reducing information leakage, the same
thing hidepid=3D always has done, and not more. To quote the proc(5) man
page about this:

"=E2=80=A6 This doesn't hide the fact that a process with a specific PID va=
lue
exists (it can be learned by other means, for example, by "kill -0
$PID"), but it hides a process's UID and GID, which could otherwise be
learned by employing stat(2) on a /proc/[pid] directory.  This greatly
complicates an attacker's task of gathering information about running
processes  (e.g.,  discovering whether some daemon is running with
elevated privileges, whether another user is running some sensitive
program, whether other users are running any program at all, and so
on). =E2=80=A6"

And, yeah, I think this is useful for services, but to make it usable
in general-purpose distros an individual per-service and per-process
opt-in would be much better than a global opt-in.

Yes, I think there's value in reducing information leakage. And yes,
what was true when the proc(5) man page was written, is still relevant
today, I think.

L.
