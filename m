From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v5 1/6] seccomp: Sysctl to display available actions
Date: Thu, 3 Aug 2017 19:46:35 -0500
Message-ID: <de6d25e5-ba32-8bdb-4c26-f0e6545e3b37@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-2-git-send-email-tyhicks@canonical.com>
 <CAGXu5jL=MKR9JZRB=8o=gNW7TrmD2rEoDg4b2OKoMqc6DQq8kQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="x9m8grveGO7vw91qJWRsb4pJFkBeXJomP"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL=MKR9JZRB=8o=gNW7TrmD2rEoDg4b2OKoMqc6DQq8kQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x9m8grveGO7vw91qJWRsb4pJFkBeXJomP
Content-Type: multipart/mixed; boundary="3Gvb13G791Ehfr37ulllo2dr3E4PVudBJ";
 protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
 Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
 John Crispin <john@phrozen.org>, linux-audit@redhat.com,
 LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
Message-ID: <de6d25e5-ba32-8bdb-4c26-f0e6545e3b37@canonical.com>
Subject: Re: [PATCH v5 1/6] seccomp: Sysctl to display available actions
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-2-git-send-email-tyhicks@canonical.com>
 <CAGXu5jL=MKR9JZRB=8o=gNW7TrmD2rEoDg4b2OKoMqc6DQq8kQ@mail.gmail.com>
In-Reply-To: <CAGXu5jL=MKR9JZRB=8o=gNW7TrmD2rEoDg4b2OKoMqc6DQq8kQ@mail.gmail.com>

--3Gvb13G791Ehfr37ulllo2dr3E4PVudBJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/03/2017 11:37 AM, Kees Cook wrote:
> On Fri, Jul 28, 2017 at 1:55 PM, Tyler Hicks <tyhicks@canonical.com> wr=
ote:
>> This patch creates a read-only sysctl containing an ordered list of
>> seccomp actions that the kernel supports. The ordering, from left to
>> right, is the lowest action value (kill) to the highest action value
>> (allow). Currently, a read of the sysctl file would return "kill trap
>> errno trace allow". The contents of this sysctl file can be useful for=

>> userspace code as well as the system administrator.
>>
>> The path to the sysctl is:
>>
>>   /proc/sys/kernel/seccomp/actions_avail
>>
>> libseccomp and other userspace code can easily determine which actions=

>> the current kernel supports. The set of actions supported by the curre=
nt
>> kernel may be different than the set of action macros found in kernel
>> headers that were installed where the userspace code was built.
>>
>> In addition, this sysctl will allow system administrators to know whic=
h
>> actions are supported by the kernel and make it easier to configure
>> exactly what seccomp logs through the audit subsystem. Support for thi=
s
>> level of logging configuration will come in a future patch.
>>
>> Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
>> ---
>>
>> * Changes since v4:
>>   - move device_initcall() into CONFIG_SYSCTL ifdef
>>   - mark the seccomp_actions_avail string as const
>>   - adjust for new reStructuredText format
>>
>>  Documentation/sysctl/kernel.txt                |  1 +
>>  Documentation/userspace-api/seccomp_filter.rst | 16 ++++++++
>>  kernel/seccomp.c                               | 51 +++++++++++++++++=
+++++++++
>>  3 files changed, 68 insertions(+)
>>
>> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/ke=
rnel.txt
>> index bac23c1..995c42c 100644
>> --- a/Documentation/sysctl/kernel.txt
>> +++ b/Documentation/sysctl/kernel.txt
>> @@ -74,6 +74,7 @@ show up in /proc/sys/kernel:
>>  - reboot-cmd                  [ SPARC only ]
>>  - rtsig-max
>>  - rtsig-nr
>> +- seccomp/                    =3D=3D> Documentation/userspace-api/sec=
comp_filter.rst
>>  - sem
>>  - sem_next_id                [ sysv ipc ]
>>  - sg-big-buff                 [ generic SCSI device (sg) ]
>> diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Document=
ation/userspace-api/seccomp_filter.rst
>> index f71eb5e..35fc7cb 100644
>> --- a/Documentation/userspace-api/seccomp_filter.rst
>> +++ b/Documentation/userspace-api/seccomp_filter.rst
>> @@ -169,7 +169,23 @@ The ``samples/seccomp/`` directory contains both =
an x86-specific example
>>  and a more generic example of a higher level macro interface for BPF
>>  program generation.
>>
>> +Sysctls
>> +=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Seccomp's sysctl files can be found in the ``/proc/sys/kernel/seccomp=
/``
>> +directory. Here's a description of each file in that directory:
>> +
>> +``actions_avail``:
>> +       A read-only ordered list of seccomp return values (refer to th=
e
>> +       ``SECCOMP_RET_*`` macros above) in string form. The ordering, =
from
>> +       left-to-right, is the least permissive return value to the mos=
t
>> +       permissive return value.
>>
>> +       The list represents the set of seccomp return values supported=

>> +       by the kernel. A userspace program may use this list to
>> +       determine if the actions found in the ``seccomp.h``, when the
>> +       program was built, differs from the set of actions actually
>> +       supported in the current running kernel.
>>
>>  Adding architecture support
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 98b59b5..6bff068 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -17,11 +17,13 @@
>>  #include <linux/audit.h>
>>  #include <linux/compat.h>
>>  #include <linux/coredump.h>
>> +#include <linux/kmemleak.h>
>>  #include <linux/sched.h>
>>  #include <linux/sched/task_stack.h>
>>  #include <linux/seccomp.h>
>>  #include <linux/slab.h>
>>  #include <linux/syscalls.h>
>> +#include <linux/sysctl.h>
>>
>>  #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
>>  #include <asm/syscall.h>
>> @@ -922,3 +924,52 @@ long seccomp_get_filter(struct task_struct *task,=
 unsigned long filter_off,
>>         return ret;
>>  }
>>  #endif
>> +
>> +#ifdef CONFIG_SYSCTL
>> +
>> +/* Human readable action names for friendly sysctl interaction */
>> +#define SECCOMP_RET_KILL_NAME          "kill"
>> +#define SECCOMP_RET_TRAP_NAME          "trap"
>> +#define SECCOMP_RET_ERRNO_NAME         "errno"
>> +#define SECCOMP_RET_TRACE_NAME         "trace"
>> +#define SECCOMP_RET_ALLOW_NAME         "allow"
>> +
>> +static const char seccomp_actions_avail[] =3D SECCOMP_RET_KILL_NAME  =
    " "
>> +                                           SECCOMP_RET_TRAP_NAME     =
  " "
>> +                                           SECCOMP_RET_ERRNO_NAME    =
  " "
>> +                                           SECCOMP_RET_TRACE_NAME    =
  " "
>> +                                           SECCOMP_RET_ALLOW_NAME;
>> +
>> +static struct ctl_path seccomp_sysctl_path[] =3D {
>> +       { .procname =3D "kernel", },
>> +       { .procname =3D "seccomp", },
>> +       { }
>> +};
>> +
>> +static struct ctl_table seccomp_sysctl_table[] =3D {
>> +       {
>> +               .procname       =3D "actions_avail",
>> +               .data           =3D (void *) &seccomp_actions_avail,
>> +               .maxlen         =3D sizeof(seccomp_actions_avail),
>> +               .mode           =3D 0444,
>> +               .proc_handler   =3D proc_dostring,
>> +       },
>> +       { }
>> +};
>> +
>> +static int __init seccomp_sysctl_init(void)
>> +{
>> +       struct ctl_table_header *hdr;
>> +
>> +       hdr =3D register_sysctl_paths(seccomp_sysctl_path, seccomp_sys=
ctl_table);
>> +       if (!hdr)
>> +               pr_warn("seccomp: sysctl registration failed\n");
>> +       else
>> +               kmemleak_not_leak(hdr);
>> +
>> +       return 0;
>> +}
>> +
>> +device_initcall(seccomp_sysctl_init)
>> +
>> +#endif /* CONFIG_SYSCTL */
>=20
> Looks good. And for the record, the BPF return values, while not
> checked in seccomp_check_filter(), are part of ABI and the kernel will
> behave differently for unexpected values. For example, an older kernel
> encountering the future SECCOMP_RET_LOG will treat it as
> SECCOMP_RET_KILL since it's missing from the switch statement in
> __seccomp_filter().
>=20
> A question about patch ordering: should the new seccomp action
> introspection patch maybe follow this one, so they're together in the
> series (they provide the same information)?

That would be fine. I'll move it to patch #2.

Tyler

>=20
> -Kees
>=20



--3Gvb13G791Ehfr37ulllo2dr3E4PVudBJ--

--x9m8grveGO7vw91qJWRsb4pJFkBeXJomP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZg8PrAAoJENaSAD2qAscKNDgQAMjJ9+fUl9cP80coxDQ+SDhL
wUtC3EJnqV9BntnXmr6faH9CpRTKvPP5rCMtX31AGI3Ta61KHm7RuPXq9D4OxwGX
BHv02K2Y4p1rWf4GKaiU0fUq76nIH8mF8o7ZEwOMVjSO/cjeX9vvPcK+o9mxbqdE
JIQtJx5iplnitkj6OWIR87pD41jN3NGp2KL0cMCbS/RByFCfQV0ZqqnhLdXz4nQX
vwx32lQXZQn+osfID7c+KxwUdnPOZxDm1hk2YB5BaqdVRQHwdjNPx+2pTLkBfHRK
mSf/k7Sxkn6KTtukHb8I5Y3rsrXQIDCg7sw0TtKOVkjWT2BvDey5cx0JWcECnevl
RYE2FSN5FM12HjYiZIgDJIiWG3T6I2nBQynxNbpNQT66b7FUP2/rgdXzRBvtLqEh
oGMefO19dbO5nQR2Jb9ophEa47RiLFUQ4QlpaJ8RIF6k06cPR/+uLZpRH0xA+nzN
2skLsuMbV9FChyTG2EPQXHJ4XqBEy9JgLVYY+kZSgszOVa0Sro5Dx7CCZy28VMAh
PDJntsN2XL64l54Vqzxg2n74ohJr8HAmbf+AaK45JC701yRhDVTsAlFFB4cHuNRQ
/A7pQ7xAldxjMiqHqsNs0pHbv4NNyyAhqcHevX2RO1zitZRj0NYSegMBZbNbUTbb
MkDGp6ZWpSEHW6ry1H5Z
=DHdE
-----END PGP SIGNATURE-----

--x9m8grveGO7vw91qJWRsb4pJFkBeXJomP--
