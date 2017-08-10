From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v5 2/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
Date: Thu, 10 Aug 2017 18:58:00 -0500
Message-ID: <3ee50020-64f5-be8e-c4d7-a9f762a96480@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-3-git-send-email-tyhicks@canonical.com>
 <CAGXu5jJXRGvM8OajE3-QHOhZKUyPi1n4Gi20vHersVEGXvJYiQ@mail.gmail.com>
 <f1bcb30e-7600-3363-9c30-f7f2551a72d7@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="TiHBKQCsfxL33vkjEHI2LPBE0RCHMio3o"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f1bcb30e-7600-3363-9c30-f7f2551a72d7@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TiHBKQCsfxL33vkjEHI2LPBE0RCHMio3o
Content-Type: multipart/mixed; boundary="fHjS0s16wbR3rqBoWdXXPwrtOQ7E5hxxv";
 protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
 Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
 John Crispin <john@phrozen.org>, linux-audit@redhat.com,
 LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
Message-ID: <3ee50020-64f5-be8e-c4d7-a9f762a96480@canonical.com>
Subject: Re: [PATCH v5 2/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-3-git-send-email-tyhicks@canonical.com>
 <CAGXu5jJXRGvM8OajE3-QHOhZKUyPi1n4Gi20vHersVEGXvJYiQ@mail.gmail.com>
 <f1bcb30e-7600-3363-9c30-f7f2551a72d7@canonical.com>
In-Reply-To: <f1bcb30e-7600-3363-9c30-f7f2551a72d7@canonical.com>

--fHjS0s16wbR3rqBoWdXXPwrtOQ7E5hxxv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/04/2017 05:24 PM, Tyler Hicks wrote:
> On 08/03/2017 11:33 AM, Kees Cook wrote:
>> On Fri, Jul 28, 2017 at 1:55 PM, Tyler Hicks <tyhicks@canonical.com> w=
rote:
>>> Adminstrators can write to this sysctl to set the seccomp actions tha=
t
>>> are allowed to be logged. Any actions not found in this sysctl will n=
ot
>>> be logged.
>>>
>>> For example, all SECCOMP_RET_KILL, SECCOMP_RET_TRAP, and
>>> SECCOMP_RET_ERRNO actions would be loggable if "kill trap errno" were=

>>> written to the sysctl. SECCOMP_RET_TRACE actions would not be logged
>>> since its string representation ("trace") wasn't present in the sysct=
l
>>> value.
>>
>> Just to make sure I'm clear on this, the key word above is "loggable",=

>> in that filters requesting logging will be seen.
>>
>> i.e. at the end of the series, the final state of "will it be logged?"=
 is:
>>
>> if action=3D=3DRET_ALLOW:
>>   do not log
>> else if action=3D=3DRET_KILL || audit-enabled:
>>   log
>> else if filter-requests-logging && action in actions_logged:
>>   log
>> else:
>>   do not log
>=20
> Not quite. You didn't mention RET_LOG, RET_KILL (and RET_LOG) can be
> quieted by the admin, and the audit behavior is different. It is like t=
his:
>=20
> if action =3D=3D RET_ALLOW:
>   do not log
> else if action =3D=3D RET_KILL && RET_KILL in actions_logged:
>   log
> else if action =3D=3D RET_LOG && RET_LOG in actions_logged:
>   log
> else if filter-requests-logging && action in actions_logged:
>   log
> else if audit_enabled && process-is-being-audited:
>   log
> else:
>   do not log
>=20
> Writing that up made me realize that there is a behavior change that my=

> patch set introduces when the process is being audited. Before my patch=

> set, this was the behavior:
>=20
> ...
> else if action =3D=3D RET_KILL && audit_enabled && process-is-being-aud=
ited:
>   log
> ...
>=20
> Now it is:
>=20
> ...
> else if audit_enabled && process-is-being-audited:
>   log
> ...
>=20
> Should I go back to only logging RET_KILL actions in that situation?

After going back and manually testing, I was wrong about this. There's
no change in behavior for tasks that are being audited. The original
behavior is preserved and I even say that in this patch's commit
message. Sorry for the noise here.

Tyler

>=20
>>
>>> The path to the sysctl is:
>>>
>>>  /proc/sys/kernel/seccomp/actions_logged
>>>
>>> The actions_avail sysctl can be read to discover the valid action nam=
es
>>> that can be written to the actions_logged sysctl with the exception o=
f
>>> SECCOMP_RET_ALLOW. It cannot be configured for logging.
>>>
>>> The default setting for the sysctl is to allow all actions to be logg=
ed
>>> except SECCOMP_RET_ALLOW.
>>>
>>> There's one important exception to this sysctl. If a task is
>>> specifically being audited, meaning that an audit context has been
>>> allocated for the task, seccomp will log all actions other than
>>> SECCOMP_RET_ALLOW despite the value of actions_logged. This exception=

>>> preserves the existing auditing behavior of tasks with an allocated
>>> audit context.
>>>
>>> Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
>>> ---
>>>
>>> * Changes since v4:
>>>   - the sysctl is now a list of actions that are allowed by the admin=
 to be
>>>     logged rather than a list of actions that should be logged
>>>     + a follow up patch will let applications have a say in what shou=
ld be
>>>       logged but the admin has the final say with this sysctl
>>>     + RET_ALLOW cannot be allowed to be logged
>>>   - fix comment style
>>>   - mark the seccomp_action_names array as const
>>>   - adjust for new reStructuredText format
>>>
>>>  Documentation/userspace-api/seccomp_filter.rst |  18 +++
>>>  include/linux/audit.h                          |   6 +-
>>>  kernel/seccomp.c                               | 180 +++++++++++++++=
+++++++++-
>>>  3 files changed, 196 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documen=
tation/userspace-api/seccomp_filter.rst
>>> index 35fc7cb..2d1d8ab 100644
>>> --- a/Documentation/userspace-api/seccomp_filter.rst
>>> +++ b/Documentation/userspace-api/seccomp_filter.rst
>>> @@ -187,6 +187,24 @@ directory. Here's a description of each file in =
that directory:
>>>         program was built, differs from the set of actions actually
>>>         supported in the current running kernel.
>>>
>>> +``actions_logged``:
>>> +       A read-write ordered list of seccomp return values (refer to =
the
>>> +       ``SECCOMP_RET_*`` macros above) that are allowed to be logged=
=2E Writes
>>> +       to the file do not need to be in ordered form but reads from =
the file
>>> +       will be ordered in the same way as the actions_avail sysctl.
>>> +
>>> +       It is important to note that the value of ``actions_logged`` =
does not
>>> +       prevent certain actions from being logged when the audit subs=
ystem is
>>> +       configured to audit a task. If the action is not found in
>>> +       ``actions_logged`` list, the final decision on whether to aud=
it the
>>> +       action for that task is ultimately left up to the audit subsy=
stem to
>>> +       decide for all seccomp return values other than ``SECCOMP_RET=
_ALLOW``.
>>> +
>>> +       The ``allow`` string is not accepted in the ``actions_logged`=
` sysctl
>>> +       as it is not possible to log ``SECCOMP_RET_ALLOW`` actions. A=
ttempting
>>> +       to write ``allow`` to the sysctl will result in an EINVAL bei=
ng
>>> +       returned.
>>> +
>>>  Adding architecture support
>>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>>
>>> diff --git a/include/linux/audit.h b/include/linux/audit.h
>>> index 2150bdc..8c30f06 100644
>>> --- a/include/linux/audit.h
>>> +++ b/include/linux/audit.h
>>> @@ -314,11 +314,7 @@ void audit_core_dumps(long signr);
>>>
>>>  static inline void audit_seccomp(unsigned long syscall, long signr, =
int code)
>>>  {
>>> -       if (!audit_enabled)
>>> -               return;
>>> -
>>> -       /* Force a record to be reported if a signal was delivered. *=
/
>>> -       if (signr || unlikely(!audit_dummy_context()))
>>> +       if (audit_enabled && unlikely(!audit_dummy_context()))
>>>                 __audit_seccomp(syscall, signr, code);
>>>  }
>>>
>>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>>> index 6bff068..87257f2 100644
>>> --- a/kernel/seccomp.c
>>> +++ b/kernel/seccomp.c
>>> @@ -516,6 +516,52 @@ static void seccomp_send_sigsys(int syscall, int=
 reason)
>>>  }
>>>  #endif /* CONFIG_SECCOMP_FILTER */
>>>
>>> +/* For use with seccomp_actions_logged */
>>> +#define SECCOMP_LOG_KILL               (1 << 0)
>>> +#define SECCOMP_LOG_TRAP               (1 << 2)
>>> +#define SECCOMP_LOG_ERRNO              (1 << 3)
>>> +#define SECCOMP_LOG_TRACE              (1 << 4)
>>> +#define SECCOMP_LOG_ALLOW              (1 << 5)
>>> +
>>> +static u32 seccomp_actions_logged =3D SECCOMP_LOG_KILL  | SECCOMP_LO=
G_TRAP  |
>>> +                                   SECCOMP_LOG_ERRNO | SECCOMP_LOG_T=
RACE;
>>> +
>>> +static inline void seccomp_log(unsigned long syscall, long signr, u3=
2 action)
>>> +{
>>> +       bool log;
>>> +
>>> +       switch (action) {
>>> +       case SECCOMP_RET_TRAP:
>>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_TRAP;
>>> +               break;
>>> +       case SECCOMP_RET_ERRNO:
>>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_ERRNO;
>>> +               break;
>>> +       case SECCOMP_RET_TRACE:
>>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_TRACE;
>>> +               break;
>>> +       case SECCOMP_RET_ALLOW:
>>> +               log =3D false;
>>> +               break;
>>> +       case SECCOMP_RET_KILL:
>>> +       default:
>>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_KILL;
>>> +       }
>>> +
>>> +       /*
>>> +        * Force an audit message to be emitted when the action is al=
lowed to
>>> +        * be logged by the admin.
>>> +        */
>>> +       if (log)
>>> +               return __audit_seccomp(syscall, signr, action);
>>
>> At this point in the patch series, there's no filter-requested-logging=

>> flag, so I think the above logic isn't needed until later in the
>> series (or rather, only RET_KILL should be checked).
>=20
> Hmmm... you're right. This slipped in since the sysctl's purpose morphe=
d
> from configuring what actions should be logged to configuring what
> actions are allowed to be logged.
>=20
>>
>>> +
>>> +       /*
>>> +        * Let the audit subsystem decide if the action should be aud=
ited based
>>> +        * on whether the current task itself is being audited.
>>> +        */
>>> +       return audit_seccomp(syscall, signr, action);
>>
>> With audit_seccomp() being a single if, maybe it should just be
>> collapsed into this function?
>>
>> if (log || (audit_enabled && unlikely(!audit_dummy_context()))
>>     audit_seccomp(...)
>=20
> I think that would be fine. Unless you say otherwise, I'll also rename
> __audit_seccomp() to audit_seccomp() after doing that.
>=20
> Tyler
>=20
>>
>> I do like the change in name, though: this new function is correctly
>> named seccomp_log().
>>
>> -Kees
>>
>=20
>=20



--fHjS0s16wbR3rqBoWdXXPwrtOQ7E5hxxv--

--TiHBKQCsfxL33vkjEHI2LPBE0RCHMio3o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZjPMIAAoJENaSAD2qAscKKTQP/1hPEOwCkaZD5b0W7UOInLv7
/FW7LeG7FSIJpUl+0amEkGablym/Lo4WtkYBmKxpnCx/RrJ75nx+xoA0v2+Nx3nD
yfV6Iyvl4oGl93DdmCi/SZGcLn5tk7RN9OWDQj5ExV6jGS4n5+UlJevgMsqtJLsP
yscoZga4bJ6m5IzI8W04J3r0MMAoo7P6UVw6V9QR4lIdwMEi7W8OLb1/fJpuCn3y
hsOJ6i5ATi+Tq8rdnU1ytNBv8kcL0Mvsk6nOzSkZzd6CGaIjdkB8bPb6EYLeVSTm
zSXNsR6dSbz2RZ3qSviI0qbUUaGiAJU4Ex/2hQPv6/GNEORT5yuqfbRz7f6yeTyw
cyl9hlhWVgygB+c4qJRddCp1ukdW6waDB7IpHryjGgxC0vcB9Eo7rwP5yLbpmJ8p
EqA0s1ZqeHsXY8roKTA9dGOZYJakLnIATXW38SID8GXAv59UpPieCxSGuXPRU5V0
16SvuwDDgwThV6PSOTn78ixq/C5vkuz8sES63D6psOlC9eDKfCtnE8W3T5u7Rsa6
u0p+h7CwLy6xY9+IUesqByN/3fqunWg1Uz7HBxDZnedy7hB3S+CcciPrV4adl3dk
Q2ehDkca9nS5RpMS4bWhV2qdmvfwNv+eqHyyII77GHAivLBopzN5pmkB0qMZRQWa
3crwCvYZ0u6HTV4fIwfc
=a/Jd
-----END PGP SIGNATURE-----

--TiHBKQCsfxL33vkjEHI2LPBE0RCHMio3o--
