From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 2/2] procfs/tasks: add a simple per-task procfs
 hidepid= field
Date: Wed, 18 Jan 2017 15:35:27 -0800
Message-ID: <CALCETrWn-DpyR5JCGG0H2_yFxU3UHPHZHByXMc5uAxHgQDtnjA@mail.gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
 <1484572984-13388-3-git-send-email-djalal@gmail.com> <CAEiveUfDvSoW9Hy2Y_uxU2YQ+vR8OvXMqRhxAANTGG7QaQbJeg@mail.gmail.com>
 <CALCETrWEGLhEHO_6sTXreVyWFVsEeYmZSrLNNXx-ma5gd+nTQQ@mail.gmail.com> <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-6065-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CAEiveUcrSKS9PHAMpiDRChHHK5QDTPh6G63a0p3iXyYP8Wa27w@mail.gmail.com>
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 18, 2017 at 2:50 PM, Djalal Harouni <tixxdz@gmail.com> wrote:
> On Tue, Jan 17, 2017 at 9:33 PM, Andy Lutomirski <luto@amacapital.net> wr=
ote:
>> On Mon, Jan 16, 2017 at 9:15 AM, Djalal Harouni <tixxdz@gmail.com> wrote=
:
>>> Cc linux-api
>>>
>>> On Mon, Jan 16, 2017 at 2:23 PM, Djalal Harouni <tixxdz@gmail.com> wrot=
e:
>>>>
>>>> From: Djalal Harouni <tixxdz@gmail.com>
>>>>
>>>> This adds a new per-task hidepid=3D flag that is honored by procfs whe=
n
>>>> presenting /proc to the user, in addition to the existing hidepid=3D m=
ount
>>>> option. So far, hidepid=3D was exclusively a per-pidns setting. Lockin=
g
>>>> down a set of processes so that they cannot see other user's processes
>>>> without affecting the rest of the system thus currently requires
>>>> creation of a private PID namespace, with all the complexity it brings=
,
>>>> including maintaining a stub init process as PID 1 and losing the
>>>> ability to see processes of the same user on the rest of the system.
>>>>
>>>> With this patch all acesss and visibility checks in procfs now
>>>> honour two fields:
>>>>
>>>>         a) the existing hide_pid field in the PID namespace
>>>>         b) the new hide_pid in struct task_struct
>>>>
>>>> Access/visibility is only granted if both fields permit it; the more
>>>> restrictive one wins. By default the new task_struct hide_pid value
>>>> defaults to 0, which means behaviour is not changed from the status qu=
o.
>>>>
>>>> Setting the per-process hide_pid value is done via a new PR_SET_HIDEPI=
D
>>>> prctl() option which takes the same three supported values as the
>>>> hidepid=3D mount option. The per-process hide_pid may only be increase=
d,
>>>> never decreased, thus ensuring that once applied, processes can never
>>>> escape such a hide_pid jail.  When a process forks it inherits its
>>>> parent's hide_pid value.
>>>>
>>>> Suggested usecase: let's say nginx runs as user "www-data". After
>>>> dropping privileges it may now call:
>>>>
>>>>         =E2=80=A6
>>>>         prctl(PR_SET_HIDEPID, 2);
>>>>         =E2=80=A6
>>>>
>>>> And from that point on neither nginx itself, nor any of its child
>>>> processes may see processes in /proc anymore that belong to a differen=
t
>>>> user than "www-data". Other services running on the same system remain
>>>> unaffected.
>>
>> What affect, if any, does this have on ptrace() permissions?
>
> This should not affect ptrace() permissions or other system calls that
> work directly on pids, the test in procfs is related to inodes before
> the ptrace check, hmm what do you have in mind ?
>

I'm wondering what problem you're trying to solve, then.  hidepid
helps lock down procfs, but ISTM you might still want to lock down
other PID-based APIs.

>
>> Also, this one-way thing seems wrong to me.  I think it should roughly
>> follow the no_new_privs rules instead.  IOW, if you unshare your
>> pidns, it gets cleared.  Also, maybe you shouldn't be able to set it
>
> Andy I don't follow here, no_new_privs is never cleared right ? I
> can't see the corresponding clear bit code for it.

I believe that unsharing userns clears no_new_privs.

>
> For this one I want it to act like no_new_privs. Also pidns can be
> created with userns which means it can be revoked. For my use case I
> want it to be part of *one* single operation where it is set with the
> other sandbox operations that are all preserved... instead of setting
> it *again* each time where it can already be late.
>

I don't see the problem as long as this gets implemented carefully
enough.  If you unshare your userns and your pidns, then you should be
able to see all tasks in the new pidns, even if you mount a fresh
procfs pointing at that pidns -- after all, you are privileged in that
namespace.

>
>> without either having CAP_SYS_ADMIN over your userns or having
>> no_new_privs set.
>
> For this one I can add it sure. Historically that logic was added to
> make seccomp more usable, for this patch the values can't be relaxed,
> they are always increased never decreased. However one minor advantage
> if you require no_new_privs is that this option hidepid will also
> assert that you can't setuid to access some procfs inodes... though
> you can also just set 'no_new_privs + hidepid' both of them in any
> order. Also it allows unprivileged without userns to setup a minimal
> jail while performing some operations that can be blocked by
> no_new_privs.
>
> Andy, Kees any other comments please on it ? I'm not sure if overusing
> no_new_privs in this case is a good idea. Seems to me that seccomp +
> no_new_privs is different than this hidepid feature that overlaps
> nicely with no_new_privs.
>
> If there are no responses for this question, then I will just add the
> "CAP_SYS_ADMIN || no_new_privs" test in the next iteration.

I feel like this feature (per-task hidepid) is subtle and complex
enough that it should have a very clear purpose and use case before
it's merged and that we should make sure that there isn't a better way
to accomplish what you're trying to do.
