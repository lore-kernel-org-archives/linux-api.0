From: Tyler Hicks <tyhicks@canonical.com>
Subject: Re: [PATCH v4 2/4] seccomp: Add sysctl to configure actions that
 should be logged
Date: Thu, 16 Feb 2017 16:21:49 -0600
Message-ID: <449df1a2-1491-7f7e-e870-02417ba50f4f@canonical.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
 <1487044559-6351-3-git-send-email-tyhicks@canonical.com>
 <CAGXu5j+xttArLAuSFHGMB8BqZ7tNrELmSFascGYPgDmwcorStw@mail.gmail.com>
 <db7949f6-b0a7-f078-ead4-fd48978bc082@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="NEX5lG4NXXlVEiPC07v3m5cD9TjNk7S9w"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <db7949f6-b0a7-f078-ead4-fd48978bc082@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NEX5lG4NXXlVEiPC07v3m5cD9TjNk7S9w
Content-Type: multipart/mixed; boundary="MqN1bCm15E5mGfMCj2LO9iHUAQhUT1sEn";
 protected-headers="v1"
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>,
 Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
 linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>,
 John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
Message-ID: <449df1a2-1491-7f7e-e870-02417ba50f4f@canonical.com>
Subject: Re: [PATCH v4 2/4] seccomp: Add sysctl to configure actions that
 should be logged
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
 <1487044559-6351-3-git-send-email-tyhicks@canonical.com>
 <CAGXu5j+xttArLAuSFHGMB8BqZ7tNrELmSFascGYPgDmwcorStw@mail.gmail.com>
 <db7949f6-b0a7-f078-ead4-fd48978bc082@canonical.com>
In-Reply-To: <db7949f6-b0a7-f078-ead4-fd48978bc082@canonical.com>

--MqN1bCm15E5mGfMCj2LO9iHUAQhUT1sEn
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/16/2017 12:40 PM, Tyler Hicks wrote:
> On 02/15/2017 07:10 PM, Kees Cook wrote:
>> On Mon, Feb 13, 2017 at 7:55 PM, Tyler Hicks <tyhicks@canonical.com> w=
rote:
>>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>>> index e36dfe9..270a227 100644
>>> --- a/kernel/seccomp.c
>>> +++ b/kernel/seccomp.c
>>> @@ -509,6 +509,22 @@ static void seccomp_send_sigsys(int syscall, int=
 reason)
>>>  }
>>>  #endif /* CONFIG_SECCOMP_FILTER */
>>>
>>> +static u32 seccomp_log_max_action =3D SECCOMP_RET_KILL;
>>> +
>>> +static inline void seccomp_log(unsigned long syscall, long signr, u3=
2 action)
>>> +{
>>> +       /* Force an audit message to be emitted when the action is no=
t greater
>>> +        * than the configured maximum action.
>>> +        */
>>> +       if (action <=3D seccomp_log_max_action)
>>> +               return __audit_seccomp(syscall, signr, action);
>>> +
>>> +       /* Let the audit subsystem decide if the action should be aud=
ited based
>>> +        * on whether the current task itself is being audited.
>>> +        */
>>
>> Nitpick on comment style, please use:
>>
>> /*
>>  * line 1
>>  * line 2...
>>  */
>=20
> No problem.
>=20
>>
>>> +       return audit_seccomp(syscall, signr, action);
>>> +}
>>> +
>>>  /*
>>>   * Secure computing mode 1 allows only read/write/exit/sigreturn.
>>>   * To be fully secure this must be combined with rlimit
>>> @@ -534,7 +550,7 @@ static void __secure_computing_strict(int this_sy=
scall)
>>>  #ifdef SECCOMP_DEBUG
>>>         dump_stack();
>>>  #endif
>>> -       audit_seccomp(this_syscall, SIGKILL, SECCOMP_RET_KILL);
>>> +       seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL);
>>>         do_exit(SIGKILL);
>>>  }
>>>
>>> @@ -633,18 +649,30 @@ static int __seccomp_filter(int this_syscall, c=
onst struct seccomp_data *sd,
>>>                 return 0;
>>>
>>>         case SECCOMP_RET_ALLOW:
>>> +               /* Open-coded seccomp_log(), optimized for the RET_AL=
LOW hot
>>> +                * path.
>>> +                *
>>> +                * We only want to log RET_ALLOW actions when the adm=
in has
>>> +                * configured them to be logged via the log_max_actio=
n sysctl.
>>> +                * Therefore, call __audit_seccomp() directly so that=
 RET_ALLOW
>>> +                * actions are not audited simply because the task is=
 being
>>> +                * audited.
>>> +                */
>>> +               if (unlikely(seccomp_log_max_action =3D=3D SECCOMP_RE=
T_ALLOW))
>>> +                       __audit_seccomp(this_syscall, 0, action);
>>> +
>>>                 return 0;
>>>
>>>         case SECCOMP_RET_KILL:
>>>         default:
>>> -               audit_seccomp(this_syscall, SIGSYS, action);
>>> +               seccomp_log(this_syscall, SIGSYS, action);
>>>                 do_exit(SIGSYS);
>>>         }
>>>
>>>         unreachable();
>>>
>>>  skip:
>>> -       audit_seccomp(this_syscall, 0, action);
>>> +       seccomp_log(this_syscall, 0, action);
>>>         return -1;
>>>  }
>>>  #else
>>> @@ -917,12 +945,96 @@ long seccomp_get_filter(struct task_struct *tas=
k, unsigned long filter_off,
>>>  #define SECCOMP_RET_TRACE_NAME         "trace"
>>>  #define SECCOMP_RET_ALLOW_NAME         "allow"
>>>
>>> +/* Largest strlen() of all action names */
>>> +#define SECCOMP_RET_MAX_NAME_LEN       5
>>> +
>>>  static char seccomp_actions_avail[] =3D SECCOMP_RET_KILL_NAME    " "=

>>>                                       SECCOMP_RET_TRAP_NAME     " "
>>>                                       SECCOMP_RET_ERRNO_NAME    " "
>>>                                       SECCOMP_RET_TRACE_NAME    " "
>>>                                       SECCOMP_RET_ALLOW_NAME;
>>>
>>> +struct seccomp_action_name {
>>> +       u32             action;
>>> +       const char      *name;
>>> +};
>>> +
>>> +static struct seccomp_action_name seccomp_action_names[] =3D {
>>
>> As long as I'm nit-picking, this can be const too. :)
>=20
> I'll have to cast to a non-const pointer when assigning ctl_table.data
> but I think that's fine in this case.

I was confused about which array you were talking about. I thought you
were talking about seccomp_actions_avail[].

No casts are needed when making seccomp_action_names[] const.

Tyler


--MqN1bCm15E5mGfMCj2LO9iHUAQhUT1sEn--

--NEX5lG4NXXlVEiPC07v3m5cD9TjNk7S9w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJYpiX9AAoJENaSAD2qAscKmgsQALuvf5XhqrjhAYzEytkLOPGh
yoGT7h1jkvzi0WmiJSh+nuwnjhLjMeiwj3aHE1CaWZdRMGU9PGIRLAbMEWPT7ThT
Af7WtGN6FI2nhgL7IKwT8fs2vuQmqX5kIcHFBN9cKgbbR/0hlNdAbropTnMlo339
oSYyOZlcIeoIu6ToJkVQgUPRCXTLlaD+ooEmPnRjh1TqqlRGLvCYratJKAphKm/a
58My5OrX4VeWbHrUnf6feRjFfx5eCMVwiFFnN3xPunHgoWszh6NVKfIAFMuE+2DD
xH+WDlbxzFFChOXrt9Bhy2dzBW9H4MeXsvNbrXBIaLILqEX/zB3Lwu21OEwGUs7q
2Ireoy/xZg58FlHv5WKH2BL+YjH49t4L3vsNFglVkfYtRkFImCXkf1mjkfSPtAgt
kd4Ybq97c+oUzoq0WKIv6dGW/z7k5j1ozLAm1i5GQq033W9su5tz/MCPUV/uFG3w
0nCVdBwUiQpdqUxjYy2/Gf7XWADvXst+amaFTHAGaW+M7d0xtx5kHzOaoF/BjsAM
TlbzD9DUfr/N6mHkJl+sXpkGKZKz2ekJkSmzb3Z6827E+Kbi7eZaTg9T3X+So8Yi
EX2DTioTTcAxidC0Zsrc+Wjk7uMwRficF4ZITMyjrIyZ0o5SnxAUfe7rrERTNjqu
iB68/+pxuCR29R0PvJZ3
=048z
-----END PGP SIGNATURE-----

--NEX5lG4NXXlVEiPC07v3m5cD9TjNk7S9w--
