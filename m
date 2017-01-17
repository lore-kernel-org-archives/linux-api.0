From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Tue, 17 Jan 2017 12:33:13 -0800
Message-ID: <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 16, 2017 at 9:15 AM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Cc linux-api
>
> On Mon, Jan 16, 2017 at 2:23 PM, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> This adds a new per-task hidepid=3D flag that is honored by procfs when
>> presenting /proc to the user, in addition to the existing hidepid=3D mou=
nt
>> option. So far, hidepid=3D was exclusively a per-pidns setting. Locking
>> down a set of processes so that they cannot see other user's processes
>> without affecting the rest of the system thus currently requires
>> creation of a private PID namespace, with all the complexity it brings,
>> including maintaining a stub init process as PID 1 and losing the
>> ability to see processes of the same user on the rest of the system.
>>
>> With this patch all acesss and visibility checks in procfs now
>> honour two fields:
>>
>>         a) the existing hide_pid field in the PID namespace
>>         b) the new hide_pid in struct task_struct
>>
>> Access/visibility is only granted if both fields permit it; the more
>> restrictive one wins. By default the new task_struct hide_pid value
>> defaults to 0, which means behaviour is not changed from the status quo.
>>
>> Setting the per-process hide_pid value is done via a new PR_SET_HIDEPID
>> prctl() option which takes the same three supported values as the
>> hidepid=3D mount option. The per-process hide_pid may only be increased,
>> never decreased, thus ensuring that once applied, processes can never
>> escape such a hide_pid jail.  When a process forks it inherits its
>> parent's hide_pid value.
>>
>> Suggested usecase: let's say nginx runs as user "www-data". After
>> dropping privileges it may now call:
>>
>>         =E2=80=A6
>>         prctl(PR_SET_HIDEPID, 2);
>>         =E2=80=A6
>>
>> And from that point on neither nginx itself, nor any of its child
>> processes may see processes in /proc anymore that belong to a different
>> user than "www-data". Other services running on the same system remain
>> unaffected.

What affect, if any, does this have on ptrace() permissions?

Also, this one-way thing seems wrong to me.  I think it should roughly
follow the no_new_privs rules instead.  IOW, if you unshare your
pidns, it gets cleared.  Also, maybe you shouldn't be able to set it
without either having CAP_SYS_ADMIN over your userns or having
no_new_privs set.

--Andy
