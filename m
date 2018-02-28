From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
Date: Wed, 28 Feb 2018 01:00:10 +0100
Message-ID: <f560a30d-10fd-31fc-adba-911961915937@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
 <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
 <CALCETrUTiUeV71jgYWup0CZwG8eQ3=W7X5FgJqmgPxnYbFsccw@mail.gmail.com>
 <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="2eRD9swR8P6ZLiKYgLnCeG5fVYgVzeZED"
Return-path: <kernel-hardening-return-12026-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2eRD9swR8P6ZLiKYgLnCeG5fVYgVzeZED
Content-Type: multipart/mixed; boundary="RzDzFHzLXzjtV1wK3XaAt7NETvtCmIfrn";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Drysdale
 <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>,
 "Eric W . Biederman" <ebiederm@xmission.com>,
 James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
 Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
 Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
 Will Drewry <wad@chromium.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>
Message-ID: <f560a30d-10fd-31fc-adba-911961915937@digikod.net>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
 <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
 <CALCETrUTiUeV71jgYWup0CZwG8eQ3=W7X5FgJqmgPxnYbFsccw@mail.gmail.com>
 <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com>
In-Reply-To: <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com>

--RzDzFHzLXzjtV1wK3XaAt7NETvtCmIfrn
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 28/02/2018 00:23, Andy Lutomirski wrote:
> On Tue, Feb 27, 2018 at 11:02 PM, Andy Lutomirski <luto@kernel.org> wro=
te:
>> On Tue, Feb 27, 2018 at 10:14 PM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>>>
>>> On 27/02/2018 06:01, Andy Lutomirski wrote:
>>>>
>>>>
>>>>> On Feb 26, 2018, at 8:17 PM, Andy Lutomirski <luto@amacapital.net> =
wrote:
>>>>>
>>>>>> On Tue, Feb 27, 2018 at 12:41 AM, Micka=C3=ABl Sala=C3=BCn <mic@di=
gikod.net> wrote:
>>>>>> A landlocked process has less privileges than a non-landlocked pro=
cess
>>>>>> and must then be subject to additional restrictions when manipulat=
ing
>>>>>> processes. To be allowed to use ptrace(2) and related syscalls on =
a
>>>>>> target process, a landlocked process must have a subset of the tar=
get
>>>>>> process' rules.
>>>>>>
>>>>>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>>>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>>>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>>>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>>>>> Cc: David S. Miller <davem@davemloft.net>
>>>>>> Cc: James Morris <james.l.morris@oracle.com>
>>>>>> Cc: Kees Cook <keescook@chromium.org>
>>>>>> Cc: Serge E. Hallyn <serge@hallyn.com>
>>>>>> ---
>>>>>>
>>>>>> Changes since v6:
>>>>>> * factor out ptrace check
>>>>>> * constify pointers
>>>>>> * cleanup headers
>>>>>> * use the new security_add_hooks()
>>>>>> ---
>>>>>> security/landlock/Makefile       |   2 +-
>>>>>> security/landlock/hooks_ptrace.c | 124 +++++++++++++++++++++++++++=
++++++++++++
>>>>>> security/landlock/hooks_ptrace.h |  11 ++++
>>>>>> security/landlock/init.c         |   2 +
>>>>>> 4 files changed, 138 insertions(+), 1 deletion(-)
>>>>>> create mode 100644 security/landlock/hooks_ptrace.c
>>>>>> create mode 100644 security/landlock/hooks_ptrace.h
>>>>>>
>>>>>> diff --git a/security/landlock/Makefile b/security/landlock/Makefi=
le
>>>>>> index d0f532a93b4e..605504d852d3 100644
>>>>>> --- a/security/landlock/Makefile
>>>>>> +++ b/security/landlock/Makefile
>>>>>> @@ -3,4 +3,4 @@ obj-$(CONFIG_SECURITY_LANDLOCK) :=3D landlock.o
>>>>>> landlock-y :=3D init.o chain.o task.o \
>>>>>>        tag.o tag_fs.o \
>>>>>>        enforce.o enforce_seccomp.o \
>>>>>> -       hooks.o hooks_cred.o hooks_fs.o
>>>>>> +       hooks.o hooks_cred.o hooks_fs.o hooks_ptrace.o
>>>>>> diff --git a/security/landlock/hooks_ptrace.c b/security/landlock/=
hooks_ptrace.c
>>>>>> new file mode 100644
>>>>>> index 000000000000..f1b977b9c808
>>>>>> --- /dev/null
>>>>>> +++ b/security/landlock/hooks_ptrace.c
>>>>>> @@ -0,0 +1,124 @@
>>>>>> +/*
>>>>>> + * Landlock LSM - ptrace hooks
>>>>>> + *
>>>>>> + * Copyright =C2=A9 2017 Micka=C3=ABl Sala=C3=BCn <mic@digikod.ne=
t>
>>>>>> + *
>>>>>> + * This program is free software; you can redistribute it and/or =
modify
>>>>>> + * it under the terms of the GNU General Public License version 2=
, as
>>>>>> + * published by the Free Software Foundation.
>>>>>> + */
>>>>>> +
>>>>>> +#include <asm/current.h>
>>>>>> +#include <linux/errno.h>
>>>>>> +#include <linux/kernel.h> /* ARRAY_SIZE */
>>>>>> +#include <linux/lsm_hooks.h>
>>>>>> +#include <linux/sched.h> /* struct task_struct */
>>>>>> +#include <linux/seccomp.h>
>>>>>> +
>>>>>> +#include "common.h" /* struct landlock_prog_set */
>>>>>> +#include "hooks.h" /* landlocked() */
>>>>>> +#include "hooks_ptrace.h"
>>>>>> +
>>>>>> +static bool progs_are_subset(const struct landlock_prog_set *pare=
nt,
>>>>>> +               const struct landlock_prog_set *child)
>>>>>> +{
>>>>>> +       size_t i;
>>>>>> +
>>>>>> +       if (!parent || !child)
>>>>>> +               return false;
>>>>>> +       if (parent =3D=3D child)
>>>>>> +               return true;
>>>>>> +
>>>>>> +       for (i =3D 0; i < ARRAY_SIZE(child->programs); i++) {
>>>>>
>>>>> ARRAY_SIZE(child->programs) seems misleading.  Is there no define
>>>>> NUM_LANDLOCK_PROG_TYPES or similar?
>>>>>
>>>>>> +               struct landlock_prog_list *walker;
>>>>>> +               bool found_parent =3D false;
>>>>>> +
>>>>>> +               if (!parent->programs[i])
>>>>>> +                       continue;
>>>>>> +               for (walker =3D child->programs[i]; walker;
>>>>>> +                               walker =3D walker->prev) {
>>>>>> +                       if (walker =3D=3D parent->programs[i]) {
>>>>>> +                               found_parent =3D true;
>>>>>> +                               break;
>>>>>> +                       }
>>>>>> +               }
>>>>>> +               if (!found_parent)
>>>>>> +                       return false;
>>>>>> +       }
>>>>>> +       return true;
>>>>>> +}
>>>>>
>>>>> If you used seccomp, you'd get this type of check for free, and it
>>>>> would be a lot easier to comprehend.  AFAICT the only extra lenienc=
y
>>>>> you're granting is that you're agnostic to the order in which the
>>>>> rules associated with different program types were applied, which
>>>>> could easily be added to seccomp.
>>>>
>>>> On second thought, this is all way too complicated.  I think the cor=
rect logic is either "if you are filtered by Landlock, you cannot ptrace =
anything" or to delete this patch entirely.
>>>
>>> This does not fit a lot of use cases like running a container
>>> constrained with some Landlock programs. We should not deny users the=

>>> ability to debug their stuff.
>>>
>>> This patch add the minimal protection which are needed to have
>>> meaningful Landlock security policy. Without it, they may be easily
>>> bypassable, hence useless.
>>>
>>
>> I think you're wrong here.  Any sane container trying to use Landlock
>> like this would also create a PID namespace.  Problem solved.  I still=

>> think you should drop this patch.

Containers is one use case, another is build-in sandboxing (e.g. for web
browser=E2=80=A6) and another one is for sandbox managers (e.g. Firejail,=

Bubblewrap, Flatpack=E2=80=A6). In some of these use cases, especially fr=
om a
developer point of view, you may want/need to debug your applications
(without requiring to be root). For nested Landlock access-controls
(e.g. container + user session + web browser), it may not be allowed to
create a PID namespace, but you still want to have a meaningful
access-control.

>>
>>>
>>>> If something like Tycho's notifiers goes in, then it's not obvious t=
hat, just because you have the same set of filters, you have the same pri=
vilege.  Similarly, if a feature that lets a filter query its cgroup goes=
 in (and you proposed this once!) then the logic you implemented here is =
wrong.
>>>
>>> I don't get your point. Please take a look at the tests (patch 10).
>>
>> I don't know what you want me to look at.
>>
>> What I'm saying is: suppose I write a filter like this:
>>
>> bool allow_some_action(void)
>> {
>>   int value_from_container_manager =3D call_out_to_user_notifier();
>>   return value_from_container_manager =3D=3D 42;
>> }
>>
>> or
>>
>> bool allow_some_action(void)
>> {
>>   return my_cgroup_is("/foo/bar");
>> }
>>
>> In both of these cases, your code will do the wrong thing.

You are right about the fact that the same filters/programs may not be
equivalent if they use external data (other than from the eBPF context)
to take a decision. This is why using a function
my_cgroup_is("/foo/bar") should not be allowed. If we want to enforce a
security policy according to a cgroup, the Landlock programs should be
pinned on this cgroup. This way, the kernel knows if this programs
should be called or not. It is the same argument I used in the thread
[PATCH bpf-next v8 05/11] about the cache.

The only way a Landlock program may change its behavior is because of an
eBPF map. However, in this case the map is common to all the instances
of this program.

To say it another way, the Landlock's enforce API (currently only
seccomp) is in charge of defining what is a subject. By using seccomp to
enforce a policy, the subject is a hierarchy of processes. By pinning a
Landlock program to a cgroup, the subject is the set of processes under
this cgroup. This is much more efficient than letting a program define
its one subjects. This also allows to audit which processes are
restricted by a set of Landlock programs. Because of that, calls to
functions like bpf_get_current_pid_tgid() should not be allowed (or
limited) for a Landlock program. Let's make this programs as pure as
possible. :)


>>
>>>
>>>>
>>>> Or you could just say that it's the responsibility of a Landlock use=
r to properly filter ptrace() just like it's the responsibility of seccom=
p users to filter ptrace if needed.
>>>
>>> A user should be able to enforce a security policy on ptrace as well,=

>>> but this patch enforce a minimal set of security boundaries. It will =
be
>>> easy to add a new Landlock program type to get this kind of access co=
ntrol.
>>
>> It sounds like you want Landlock to be a complete container system all=

>> by itself.  I disagree with that design goal.
>=20
> Having actually read your series more correctly now (oops!), I still
> think that this patch should be dropped.  I can see an argument for
> having a flag that one can set when adding a seccomp filter that says
> "prevent ptrace of any child that doesn't have this exact stack
> installed", but I think that could be added later and should not be
> part of an initial submission.  For now, Landlock users can block
> ptrace() entirely or use PID namespaces.
>=20

I also though about using a flag, but we should encourage sane/safe
default behavior, which means at least to not have trivially bypassable
access-control rules, to not shoot yourself in the foot. However, a flag
could be added to disable this safe behavior.


--RzDzFHzLXzjtV1wK3XaAt7NETvtCmIfrn--

--2eRD9swR8P6ZLiKYgLnCeG5fVYgVzeZED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlqV8QsACgkQIt7+33O9
apW5ywf+N5ntwm3Th6YCmqP1vqHEBxKpwBrQT0x76w0VtxEDk1CNg3D5fNLLCPDX
6rzLeyzQAH6XBqI/5NJSZjMa788677mBPVbGGyqfbXEBJpblR+EG7qGpG74HQwsh
4Hm26cpvyVWZN7uKdkb2+/Z0k7hu78dLkGCbkmmbt3gqpca1x2mV3nFDrtU4iutR
nIYPwXJZFmPx6H1Gg+fiKfrFNj1+YwKN3jhN/7EMzRD7ikO2DtisX8qgq8jknwx6
e8xBkpBSvYKzw8Ek1C6nlDYL3Pz6kO052cP6/iSSD2c9blT7B9JXw3K4sqW3Qwws
orl8N2b/kYSioG0b8v1S1zYilAYAfQ==
=WcaF
-----END PGP SIGNATURE-----

--2eRD9swR8P6ZLiKYgLnCeG5fVYgVzeZED--
