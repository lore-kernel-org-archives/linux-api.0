From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
Date: Tue, 27 Feb 2018 23:14:58 +0100
Message-ID: <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="juzjA3tOq9X7GzHiBhdEjTC1LSPJGxe5L"
Return-path: <kernel-hardening-return-12019-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--juzjA3tOq9X7GzHiBhdEjTC1LSPJGxe5L
Content-Type: multipart/mixed; boundary="mHkglwZfixZ6jp0eTeXn92TrtSd9RNwPP";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Andy Lutomirski <luto@amacapital.net>
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
Message-ID: <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
In-Reply-To: <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>

--mHkglwZfixZ6jp0eTeXn92TrtSd9RNwPP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 27/02/2018 06:01, Andy Lutomirski wrote:
>=20
>=20
>> On Feb 26, 2018, at 8:17 PM, Andy Lutomirski <luto@amacapital.net> wro=
te:
>>
>>> On Tue, Feb 27, 2018 at 12:41 AM, Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>>> A landlocked process has less privileges than a non-landlocked proces=
s
>>> and must then be subject to additional restrictions when manipulating=

>>> processes. To be allowed to use ptrace(2) and related syscalls on a
>>> target process, a landlocked process must have a subset of the target=

>>> process' rules.
>>>
>>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>> Cc: Alexei Starovoitov <ast@kernel.org>
>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>> Cc: David S. Miller <davem@davemloft.net>
>>> Cc: James Morris <james.l.morris@oracle.com>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: Serge E. Hallyn <serge@hallyn.com>
>>> ---
>>>
>>> Changes since v6:
>>> * factor out ptrace check
>>> * constify pointers
>>> * cleanup headers
>>> * use the new security_add_hooks()
>>> ---
>>> security/landlock/Makefile       |   2 +-
>>> security/landlock/hooks_ptrace.c | 124 ++++++++++++++++++++++++++++++=
+++++++++
>>> security/landlock/hooks_ptrace.h |  11 ++++
>>> security/landlock/init.c         |   2 +
>>> 4 files changed, 138 insertions(+), 1 deletion(-)
>>> create mode 100644 security/landlock/hooks_ptrace.c
>>> create mode 100644 security/landlock/hooks_ptrace.h
>>>
>>> diff --git a/security/landlock/Makefile b/security/landlock/Makefile
>>> index d0f532a93b4e..605504d852d3 100644
>>> --- a/security/landlock/Makefile
>>> +++ b/security/landlock/Makefile
>>> @@ -3,4 +3,4 @@ obj-$(CONFIG_SECURITY_LANDLOCK) :=3D landlock.o
>>> landlock-y :=3D init.o chain.o task.o \
>>>        tag.o tag_fs.o \
>>>        enforce.o enforce_seccomp.o \
>>> -       hooks.o hooks_cred.o hooks_fs.o
>>> +       hooks.o hooks_cred.o hooks_fs.o hooks_ptrace.o
>>> diff --git a/security/landlock/hooks_ptrace.c b/security/landlock/hoo=
ks_ptrace.c
>>> new file mode 100644
>>> index 000000000000..f1b977b9c808
>>> --- /dev/null
>>> +++ b/security/landlock/hooks_ptrace.c
>>> @@ -0,0 +1,124 @@
>>> +/*
>>> + * Landlock LSM - ptrace hooks
>>> + *
>>> + * Copyright =C2=A9 2017 Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>> + *
>>> + * This program is free software; you can redistribute it and/or mod=
ify
>>> + * it under the terms of the GNU General Public License version 2, a=
s
>>> + * published by the Free Software Foundation.
>>> + */
>>> +
>>> +#include <asm/current.h>
>>> +#include <linux/errno.h>
>>> +#include <linux/kernel.h> /* ARRAY_SIZE */
>>> +#include <linux/lsm_hooks.h>
>>> +#include <linux/sched.h> /* struct task_struct */
>>> +#include <linux/seccomp.h>
>>> +
>>> +#include "common.h" /* struct landlock_prog_set */
>>> +#include "hooks.h" /* landlocked() */
>>> +#include "hooks_ptrace.h"
>>> +
>>> +static bool progs_are_subset(const struct landlock_prog_set *parent,=

>>> +               const struct landlock_prog_set *child)
>>> +{
>>> +       size_t i;
>>> +
>>> +       if (!parent || !child)
>>> +               return false;
>>> +       if (parent =3D=3D child)
>>> +               return true;
>>> +
>>> +       for (i =3D 0; i < ARRAY_SIZE(child->programs); i++) {
>>
>> ARRAY_SIZE(child->programs) seems misleading.  Is there no define
>> NUM_LANDLOCK_PROG_TYPES or similar?
>>
>>> +               struct landlock_prog_list *walker;
>>> +               bool found_parent =3D false;
>>> +
>>> +               if (!parent->programs[i])
>>> +                       continue;
>>> +               for (walker =3D child->programs[i]; walker;
>>> +                               walker =3D walker->prev) {
>>> +                       if (walker =3D=3D parent->programs[i]) {
>>> +                               found_parent =3D true;
>>> +                               break;
>>> +                       }
>>> +               }
>>> +               if (!found_parent)
>>> +                       return false;
>>> +       }
>>> +       return true;
>>> +}
>>
>> If you used seccomp, you'd get this type of check for free, and it
>> would be a lot easier to comprehend.  AFAICT the only extra leniency
>> you're granting is that you're agnostic to the order in which the
>> rules associated with different program types were applied, which
>> could easily be added to seccomp.
>=20
> On second thought, this is all way too complicated.  I think the correc=
t logic is either "if you are filtered by Landlock, you cannot ptrace any=
thing" or to delete this patch entirely.

This does not fit a lot of use cases like running a container
constrained with some Landlock programs. We should not deny users the
ability to debug their stuff.

This patch add the minimal protection which are needed to have
meaningful Landlock security policy. Without it, they may be easily
bypassable, hence useless.


> If something like Tycho's notifiers goes in, then it's not obvious that=
, just because you have the same set of filters, you have the same privil=
ege.  Similarly, if a feature that lets a filter query its cgroup goes in=
 (and you proposed this once!) then the logic you implemented here is wro=
ng.

I don't get your point. Please take a look at the tests (patch 10).

>=20
> Or you could just say that it's the responsibility of a Landlock user t=
o properly filter ptrace() just like it's the responsibility of seccomp u=
sers to filter ptrace if needed.

A user should be able to enforce a security policy on ptrace as well,
but this patch enforce a minimal set of security boundaries. It will be
easy to add a new Landlock program type to get this kind of access contro=
l.

>=20
> I take this as further evidence that Landlock makes much more sense as =
part of seccomp than as a totally separate thing.  We've very carefully r=
eviewed these things for seccomp.  Please don't make us do it again from =
scratch.
>=20

Landlock is more complex than seccomp, because of its different goal.
seccomp is less restrictive because it is more simple, but this patch
follow the same logic with the knowledge of the Landlock internals.


--mHkglwZfixZ6jp0eTeXn92TrtSd9RNwPP--

--juzjA3tOq9X7GzHiBhdEjTC1LSPJGxe5L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlqV2GIACgkQIt7+33O9
apXEyQf+KURddBvKxYNuwM6u0k7oFAC+stSeLTkBHdfBXv7UEvAgfPpBAVmyqYv4
mx2gBn85Ey1redPA1W9ezeX6AzuDTcu/mDlpp/h7+CeTG2eSGp4XGVxHCBbuQLKT
CsWq4syeo1cHy11YKv/GPDDo1ZxwJlr7ICu5WYBQMy37fj3kqE5iHcmW7InBYKWa
+POKR3oY+nU9iNxO1qj/LgdXC3dSR6xJZfK0q27uAE293cEzeHZ2+yx8zOGRCVkq
dhKz87tLb3RI0Wwt8dT0ihQNBwWG63bD+rZ4KCjUiZI/QeBps5LpLsRa5tQMKOKN
PoF3ZlCcpZkDhVYdyKuumxBEnrtxFA==
=9JFP
-----END PGP SIGNATURE-----

--juzjA3tOq9X7GzHiBhdEjTC1LSPJGxe5L--
