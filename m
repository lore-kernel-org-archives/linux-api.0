From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 2/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
Date: Fri, 4 Aug 2017 17:24:00 -0500
Message-ID: <f1bcb30e-7600-3363-9c30-f7f2551a72d7@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-3-git-send-email-tyhicks@canonical.com>
 <CAGXu5jJXRGvM8OajE3-QHOhZKUyPi1n4Gi20vHersVEGXvJYiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="UJpLtMoCr6pv6XhSE2Mcm7WkoFAIejxQK"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jJXRGvM8OajE3-QHOhZKUyPi1n4Gi20vHersVEGXvJYiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UJpLtMoCr6pv6XhSE2Mcm7WkoFAIejxQK
Content-Type: multipart/mixed; boundary="2vMQIGXJQbjj9pFPUm57VAwncdcOlC0SP";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <f1bcb30e-7600-3363-9c30-f7f2551a72d7-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 2/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
References: <1501275352-30045-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <1501275352-30045-3-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CAGXu5jJXRGvM8OajE3-QHOhZKUyPi1n4Gi20vHersVEGXvJYiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAGXu5jJXRGvM8OajE3-QHOhZKUyPi1n4Gi20vHersVEGXvJYiQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--2vMQIGXJQbjj9pFPUm57VAwncdcOlC0SP
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/03/2017 11:33 AM, Kees Cook wrote:
> On Fri, Jul 28, 2017 at 1:55 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wr=
ote:
>> Adminstrators can write to this sysctl to set the seccomp actions that=

>> are allowed to be logged. Any actions not found in this sysctl will no=
t
>> be logged.
>>
>> For example, all SECCOMP_RET_KILL, SECCOMP_RET_TRAP, and
>> SECCOMP_RET_ERRNO actions would be loggable if "kill trap errno" were
>> written to the sysctl. SECCOMP_RET_TRACE actions would not be logged
>> since its string representation ("trace") wasn't present in the sysctl=

>> value.
>=20
> Just to make sure I'm clear on this, the key word above is "loggable",
> in that filters requesting logging will be seen.
>=20
> i.e. at the end of the series, the final state of "will it be logged?" =
is:
>=20
> if action=3D=3DRET_ALLOW:
>   do not log
> else if action=3D=3DRET_KILL || audit-enabled:
>   log
> else if filter-requests-logging && action in actions_logged:
>   log
> else:
>   do not log

Not quite. You didn't mention RET_LOG, RET_KILL (and RET_LOG) can be
quieted by the admin, and the audit behavior is different. It is like thi=
s:

if action =3D=3D RET_ALLOW:
  do not log
else if action =3D=3D RET_KILL && RET_KILL in actions_logged:
  log
else if action =3D=3D RET_LOG && RET_LOG in actions_logged:
  log
else if filter-requests-logging && action in actions_logged:
  log
else if audit_enabled && process-is-being-audited:
  log
else:
  do not log

Writing that up made me realize that there is a behavior change that my
patch set introduces when the process is being audited. Before my patch
set, this was the behavior:

=2E..
else if action =3D=3D RET_KILL && audit_enabled && process-is-being-audit=
ed:
  log
=2E..

Now it is:

=2E..
else if audit_enabled && process-is-being-audited:
  log
=2E..

Should I go back to only logging RET_KILL actions in that situation?

>=20
>> The path to the sysctl is:
>>
>>  /proc/sys/kernel/seccomp/actions_logged
>>
>> The actions_avail sysctl can be read to discover the valid action name=
s
>> that can be written to the actions_logged sysctl with the exception of=

>> SECCOMP_RET_ALLOW. It cannot be configured for logging.
>>
>> The default setting for the sysctl is to allow all actions to be logge=
d
>> except SECCOMP_RET_ALLOW.
>>
>> There's one important exception to this sysctl. If a task is
>> specifically being audited, meaning that an audit context has been
>> allocated for the task, seccomp will log all actions other than
>> SECCOMP_RET_ALLOW despite the value of actions_logged. This exception
>> preserves the existing auditing behavior of tasks with an allocated
>> audit context.
>>
>> Signed-off-by: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>
>> * Changes since v4:
>>   - the sysctl is now a list of actions that are allowed by the admin =
to be
>>     logged rather than a list of actions that should be logged
>>     + a follow up patch will let applications have a say in what shoul=
d be
>>       logged but the admin has the final say with this sysctl
>>     + RET_ALLOW cannot be allowed to be logged
>>   - fix comment style
>>   - mark the seccomp_action_names array as const
>>   - adjust for new reStructuredText format
>>
>>  Documentation/userspace-api/seccomp_filter.rst |  18 +++
>>  include/linux/audit.h                          |   6 +-
>>  kernel/seccomp.c                               | 180 ++++++++++++++++=
++++++++-
>>  3 files changed, 196 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Document=
ation/userspace-api/seccomp_filter.rst
>> index 35fc7cb..2d1d8ab 100644
>> --- a/Documentation/userspace-api/seccomp_filter.rst
>> +++ b/Documentation/userspace-api/seccomp_filter.rst
>> @@ -187,6 +187,24 @@ directory. Here's a description of each file in t=
hat directory:
>>         program was built, differs from the set of actions actually
>>         supported in the current running kernel.
>>
>> +``actions_logged``:
>> +       A read-write ordered list of seccomp return values (refer to t=
he
>> +       ``SECCOMP_RET_*`` macros above) that are allowed to be logged.=
 Writes
>> +       to the file do not need to be in ordered form but reads from t=
he file
>> +       will be ordered in the same way as the actions_avail sysctl.
>> +
>> +       It is important to note that the value of ``actions_logged`` d=
oes not
>> +       prevent certain actions from being logged when the audit subsy=
stem is
>> +       configured to audit a task. If the action is not found in
>> +       ``actions_logged`` list, the final decision on whether to audi=
t the
>> +       action for that task is ultimately left up to the audit subsys=
tem to
>> +       decide for all seccomp return values other than ``SECCOMP_RET_=
ALLOW``.
>> +
>> +       The ``allow`` string is not accepted in the ``actions_logged``=
 sysctl
>> +       as it is not possible to log ``SECCOMP_RET_ALLOW`` actions. At=
tempting
>> +       to write ``allow`` to the sysctl will result in an EINVAL bein=
g
>> +       returned.
>> +
>>  Adding architecture support
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>>
>> diff --git a/include/linux/audit.h b/include/linux/audit.h
>> index 2150bdc..8c30f06 100644
>> --- a/include/linux/audit.h
>> +++ b/include/linux/audit.h
>> @@ -314,11 +314,7 @@ void audit_core_dumps(long signr);
>>
>>  static inline void audit_seccomp(unsigned long syscall, long signr, i=
nt code)
>>  {
>> -       if (!audit_enabled)
>> -               return;
>> -
>> -       /* Force a record to be reported if a signal was delivered. */=

>> -       if (signr || unlikely(!audit_dummy_context()))
>> +       if (audit_enabled && unlikely(!audit_dummy_context()))
>>                 __audit_seccomp(syscall, signr, code);
>>  }
>>
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 6bff068..87257f2 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -516,6 +516,52 @@ static void seccomp_send_sigsys(int syscall, int =
reason)
>>  }
>>  #endif /* CONFIG_SECCOMP_FILTER */
>>
>> +/* For use with seccomp_actions_logged */
>> +#define SECCOMP_LOG_KILL               (1 << 0)
>> +#define SECCOMP_LOG_TRAP               (1 << 2)
>> +#define SECCOMP_LOG_ERRNO              (1 << 3)
>> +#define SECCOMP_LOG_TRACE              (1 << 4)
>> +#define SECCOMP_LOG_ALLOW              (1 << 5)
>> +
>> +static u32 seccomp_actions_logged =3D SECCOMP_LOG_KILL  | SECCOMP_LOG=
_TRAP  |
>> +                                   SECCOMP_LOG_ERRNO | SECCOMP_LOG_TR=
ACE;
>> +
>> +static inline void seccomp_log(unsigned long syscall, long signr, u32=
 action)
>> +{
>> +       bool log;
>> +
>> +       switch (action) {
>> +       case SECCOMP_RET_TRAP:
>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_TRAP;
>> +               break;
>> +       case SECCOMP_RET_ERRNO:
>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_ERRNO;
>> +               break;
>> +       case SECCOMP_RET_TRACE:
>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_TRACE;
>> +               break;
>> +       case SECCOMP_RET_ALLOW:
>> +               log =3D false;
>> +               break;
>> +       case SECCOMP_RET_KILL:
>> +       default:
>> +               log =3D seccomp_actions_logged & SECCOMP_LOG_KILL;
>> +       }
>> +
>> +       /*
>> +        * Force an audit message to be emitted when the action is all=
owed to
>> +        * be logged by the admin.
>> +        */
>> +       if (log)
>> +               return __audit_seccomp(syscall, signr, action);
>=20
> At this point in the patch series, there's no filter-requested-logging
> flag, so I think the above logic isn't needed until later in the
> series (or rather, only RET_KILL should be checked).

Hmmm... you're right. This slipped in since the sysctl's purpose morphed
from configuring what actions should be logged to configuring what
actions are allowed to be logged.

>=20
>> +
>> +       /*
>> +        * Let the audit subsystem decide if the action should be audi=
ted based
>> +        * on whether the current task itself is being audited.
>> +        */
>> +       return audit_seccomp(syscall, signr, action);
>=20
> With audit_seccomp() being a single if, maybe it should just be
> collapsed into this function?
>=20
> if (log || (audit_enabled && unlikely(!audit_dummy_context()))
>     audit_seccomp(...)

I think that would be fine. Unless you say otherwise, I'll also rename
__audit_seccomp() to audit_seccomp() after doing that.

Tyler

>=20
> I do like the change in name, though: this new function is correctly
> named seccomp_log().
>=20
> -Kees
>=20



--2vMQIGXJQbjj9pFPUm57VAwncdcOlC0SP--

--UJpLtMoCr6pv6XhSE2Mcm7WkoFAIejxQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZhPQAAAoJENaSAD2qAscKZ44P/081kEVk9/rSP3zIgOx/rPwc
ayAofOJGQF2nq79jGZMRUDdwhufr978XavNiH1+JO6FeVVD1gQatW09sBgZ9ALEF
ZIwylKzMiqBoVpHgDys5qtHUmkv82C9oysWNUe8SEk3IFWIU0OfzGZc3jdVZIsd7
9X8FL4JY0sVm2R9aPWXlOBI2ARo75n/6zxdsT1G8K2ReP5uuxKxNcaC6zOMCz9JY
9RlNepHgIUWmj9+5ygygEDR2MKWVtxvx9dV2EqqxFMj4ukX5QlRpg2kn0FGIMgPj
27IeegtTHDnkpjYR7qX4zudVcVe5kOxzbSR2vfdTwZmjzot9hmO7UNRTOfNQ+2Te
n0gAG6sHiTG7Wk1+HBXe3IlpC5kKFeiGKiCi7xrLEIQWfDh3EbjUdJp7hO4hcOvM
P22JLUOgVdE0/y++B28SIwBdaraho9UzDc4cOxClfMVAWNmsIwkxYH1RzWfwDW/+
iU8Rd5nUdmrda47mTjFNv4dFulEG7ZPQ5SIwIUMGrdlOoEvYPNJpx16Udz3jcIzS
0Z1QAuhTOnGfw98xnp7feYZYZwyYuXFRaSnIszXXcCjcBZSAfRV6hxVS3XDl6MCQ
Myit9YsFzHHslaYf1J4Z7w02JICsGX7TLfZHQagTh1HrCmrNsyy2GnxPv1+dwNFT
lPHDAugTlIjqaFqajfz5
=ZHE8
-----END PGP SIGNATURE-----

--UJpLtMoCr6pv6XhSE2Mcm7WkoFAIejxQK--
