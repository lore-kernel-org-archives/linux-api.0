From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Thu, 19 Jan 2017 14:53:32 +0100
Message-ID: <CAEiveUevjijnmr7oWzQexi52nJm-BjVwAkb3fJinAbet=QvzxQ@mail.gmail.com>
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
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org" <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Lafcadio Wluiki <wluikil-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 19, 2017 at 12:35 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wro=
te:
> On Wed, Jan 18, 2017 at 2:50 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
[...]
>>>>>
>>>>>         =E2=80=A6
>>>>>         prctl(PR_SET_HIDEPID, 2);
>>>>>         =E2=80=A6
>>>>>
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
>>
>
> I'm wondering what problem you're trying to solve, then.  hidepid
> helps lock down procfs, but ISTM you might still want to lock down
> other PID-based APIs.

Yes but they are already locked based on uid checks. procfs was not
and this patch is specifically to align it, and to reduce the ability
to peek data from other processes.

>>
>>> Also, this one-way thing seems wrong to me.  I think it should roughly
>>> follow the no_new_privs rules instead.  IOW, if you unshare your
>>> pidns, it gets cleared.  Also, maybe you shouldn't be able to set it
>>
>> Andy I don't follow here, no_new_privs is never cleared right ? I
>> can't see the corresponding clear bit code for it.
>
> I believe that unsharing userns clears no_new_privs.
No, it is not cleared, and I can't see the clear bit for it. Maybe due
to userns+filesystems limitations it was not noticed.


>>
>> For this one I want it to act like no_new_privs. Also pidns can be
>> created with userns which means it can be revoked. For my use case I
>> want it to be part of *one* single operation where it is set with the
>> other sandbox operations that are all preserved... instead of setting
>> it *again* each time where it can already be late.
>>
>
> I don't see the problem as long as this gets implemented carefully
> enough.  If you unshare your userns and your pidns, then you should be
> able to see all tasks in the new pidns, even if you mount a fresh
> procfs pointing at that pidns -- after all, you are privileged in that
> namespace.

That's already the case, if you are privileged you can see all tasks,
the code is written that the per-task hidepid does not overwrite
capabilities.


>>
>>> without either having CAP_SYS_ADMIN over your userns or having
>>> no_new_privs set.
>>
>> For this one I can add it sure. Historically that logic was added to
>> make seccomp more usable, for this patch the values can't be relaxed,
>> they are always increased never decreased. However one minor advantage
>> if you require no_new_privs is that this option hidepid will also
>> assert that you can't setuid to access some procfs inodes... though
>> you can also just set 'no_new_privs + hidepid' both of them in any
>> order. Also it allows unprivileged without userns to setup a minimal
>> jail while performing some operations that can be blocked by
>> no_new_privs.
>>
>> Andy, Kees any other comments please on it ? I'm not sure if overusing
>> no_new_privs in this case is a good idea. Seems to me that seccomp +
>> no_new_privs is different than this hidepid feature that overlaps
>> nicely with no_new_privs.
>>
>> If there are no responses for this question, then I will just add the
>> "CAP_SYS_ADMIN || no_new_privs" test in the next iteration.
>
> I feel like this feature (per-task hidepid) is subtle and complex
> enough that it should have a very clear purpose and use case before
> it's merged and that we should make sure that there isn't a better way
> to accomplish what you're trying to do.

Sure, the hidepid mount option is old enough, and this per-task
hidepid is clearly defined only for procfs and per task, we can't add
another switch that's relate to both a filesystem and pid namespaces,
it will be a bit complicated and not really useful for cases that are
in *same* pidns where *each* one have to mount its procfs, it will
propagate. Also as noted by Lafcadio, the gid thing is a bit hard to
use now.

Thanks!

--=20
tixxdz
http://opendz.org
