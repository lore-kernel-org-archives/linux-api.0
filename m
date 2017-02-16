From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v4 2/4] seccomp: Add sysctl to configure actions that
 should be logged
Date: Thu, 16 Feb 2017 12:40:23 -0600
Message-ID: <db7949f6-b0a7-f078-ead4-fd48978bc082@canonical.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
 <1487044559-6351-3-git-send-email-tyhicks@canonical.com>
 <CAGXu5j+xttArLAuSFHGMB8BqZ7tNrELmSFascGYPgDmwcorStw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Ht0l1WgsaWRelAUkOh5MMqOWn9MdfftmK"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+xttArLAuSFHGMB8BqZ7tNrELmSFascGYPgDmwcorStw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ht0l1WgsaWRelAUkOh5MMqOWn9MdfftmK
Content-Type: multipart/mixed; boundary="3kWOm1QoJ0jScqWW4uuslErhI3XlKf0VA";
 protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
 Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
 linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
 John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
Message-ID: <db7949f6-b0a7-f078-ead4-fd48978bc082@canonical.com>
Subject: Re: [PATCH v4 2/4] seccomp: Add sysctl to configure actions that
 should be logged
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
 <1487044559-6351-3-git-send-email-tyhicks@canonical.com>
 <CAGXu5j+xttArLAuSFHGMB8BqZ7tNrELmSFascGYPgDmwcorStw@mail.gmail.com>
In-Reply-To: <CAGXu5j+xttArLAuSFHGMB8BqZ7tNrELmSFascGYPgDmwcorStw@mail.gmail.com>

--3kWOm1QoJ0jScqWW4uuslErhI3XlKf0VA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/15/2017 07:10 PM, Kees Cook wrote:
> On Mon, Feb 13, 2017 at 7:55 PM, Tyler Hicks <tyhicks@canonical.com> wr=
ote:
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index e36dfe9..270a227 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -509,6 +509,22 @@ static void seccomp_send_sigsys(int syscall, int =
reason)
>>  }
>>  #endif /* CONFIG_SECCOMP_FILTER */
>>
>> +static u32 seccomp_log_max_action =3D SECCOMP_RET_KILL;
>> +
>> +static inline void seccomp_log(unsigned long syscall, long signr, u32=
 action)
>> +{
>> +       /* Force an audit message to be emitted when the action is not=
 greater
>> +        * than the configured maximum action.
>> +        */
>> +       if (action <=3D seccomp_log_max_action)
>> +               return __audit_seccomp(syscall, signr, action);
>> +
>> +       /* Let the audit subsystem decide if the action should be audi=
ted based
>> +        * on whether the current task itself is being audited.
>> +        */
>=20
> Nitpick on comment style, please use:
>=20
> /*
>  * line 1
>  * line 2...
>  */

No problem.

>=20
>> +       return audit_seccomp(syscall, signr, action);
>> +}
>> +
>>  /*
>>   * Secure computing mode 1 allows only read/write/exit/sigreturn.
>>   * To be fully secure this must be combined with rlimit
>> @@ -534,7 +550,7 @@ static void __secure_computing_strict(int this_sys=
call)
>>  #ifdef SECCOMP_DEBUG
>>         dump_stack();
>>  #endif
>> -       audit_seccomp(this_syscall, SIGKILL, SECCOMP_RET_KILL);
>> +       seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL);
>>         do_exit(SIGKILL);
>>  }
>>
>> @@ -633,18 +649,30 @@ static int __seccomp_filter(int this_syscall, co=
nst struct seccomp_data *sd,
>>                 return 0;
>>
>>         case SECCOMP_RET_ALLOW:
>> +               /* Open-coded seccomp_log(), optimized for the RET_ALL=
OW hot
>> +                * path.
>> +                *
>> +                * We only want to log RET_ALLOW actions when the admi=
n has
>> +                * configured them to be logged via the log_max_action=
 sysctl.
>> +                * Therefore, call __audit_seccomp() directly so that =
RET_ALLOW
>> +                * actions are not audited simply because the task is =
being
>> +                * audited.
>> +                */
>> +               if (unlikely(seccomp_log_max_action =3D=3D SECCOMP_RET=
_ALLOW))
>> +                       __audit_seccomp(this_syscall, 0, action);
>> +
>>                 return 0;
>>
>>         case SECCOMP_RET_KILL:
>>         default:
>> -               audit_seccomp(this_syscall, SIGSYS, action);
>> +               seccomp_log(this_syscall, SIGSYS, action);
>>                 do_exit(SIGSYS);
>>         }
>>
>>         unreachable();
>>
>>  skip:
>> -       audit_seccomp(this_syscall, 0, action);
>> +       seccomp_log(this_syscall, 0, action);
>>         return -1;
>>  }
>>  #else
>> @@ -917,12 +945,96 @@ long seccomp_get_filter(struct task_struct *task=
, unsigned long filter_off,
>>  #define SECCOMP_RET_TRACE_NAME         "trace"
>>  #define SECCOMP_RET_ALLOW_NAME         "allow"
>>
>> +/* Largest strlen() of all action names */
>> +#define SECCOMP_RET_MAX_NAME_LEN       5
>> +
>>  static char seccomp_actions_avail[] =3D SECCOMP_RET_KILL_NAME    " "
>>                                       SECCOMP_RET_TRAP_NAME     " "
>>                                       SECCOMP_RET_ERRNO_NAME    " "
>>                                       SECCOMP_RET_TRACE_NAME    " "
>>                                       SECCOMP_RET_ALLOW_NAME;
>>
>> +struct seccomp_action_name {
>> +       u32             action;
>> +       const char      *name;
>> +};
>> +
>> +static struct seccomp_action_name seccomp_action_names[] =3D {
>=20
> As long as I'm nit-picking, this can be const too. :)

I'll have to cast to a non-const pointer when assigning ctl_table.data
but I think that's fine in this case.

Tyler

>=20
> -Kees
>=20



--3kWOm1QoJ0jScqWW4uuslErhI3XlKf0VA--

--Ht0l1WgsaWRelAUkOh5MMqOWn9MdfftmK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJYpfIXAAoJENaSAD2qAscKXukP+gIPkYP4SzeLYN6dL3xk0XpA
X4d/7GOlTTd1CWuCLWl6ieBf6qjPf8uOwOUqe0hcgXoI+H8iiLBED1N2zErU5xns
ifTheX1HJXRWr66KG/tp+CevAUNZOIeAuH7/ReJhb7d/CvpXpr8apkagJRo8n5Y8
9B3PGGvYF4NrnYMbewQatPnFkyXP+8nIb81Gav0rp1X6aBm/ZD0QQynUE3Rbqq70
uKVw6Z0PUcCEmw+hDGSZrbFSlbpP46mJUI++tBfXpE1kI09XKH3vZjOM1VoOtsSc
ncUdqV1ME99H/ffTIH5gzYZ8QcLqjD5CJVRYn6QCEc7hsyDqXLys3t9CRDw8CuXG
JsQvkTZReLBjaJCnn+znhRK7FZrsHg0LQd+0zYTNKUzji4C/OhQ62KgbUYT+UVVH
feQXxHmyW/XLRxLm6etrDBVUHvXs9sKLWn0dOlen4RjeuRNlsUheZqX62hbqCdk4
J3PPOZII40Z2UWNo8XN95bQ2vY/Nhj3v4XqJMfifrYeitKBseP3aVgyy8PtsiUUM
pP35G5ca+l30nK3nGs7btdZPhMyd4/vG/fGjEshEko2HfYzVKEqkML3ZETOA8ALO
qHQEP3z9JPnD+Mtl+A2rRVgU8DAdy8iv3a7sojTdQ9XGfnly8mdcx3wgnjaZiZdG
ACTG3t5d+ril2N2aSwAb
=+Ro1
-----END PGP SIGNATURE-----

--Ht0l1WgsaWRelAUkOh5MMqOWn9MdfftmK--
