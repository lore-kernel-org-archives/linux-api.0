From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 4/6] seccomp: Operation for checking if an action is
 available
Date: Fri, 4 Aug 2017 17:56:04 -0500
Message-ID: <0d67bbb1-6694-fc7e-59af-8d2273812faa@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-5-git-send-email-tyhicks@canonical.com>
 <CAGXu5j+FyiCM5dZXtPDzvuxTWLtGRxnY6rUPNXK_gC7fUVD5kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="mH5mKn38lQmfxvV3wS181sJCuINqqSQ2m"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+FyiCM5dZXtPDzvuxTWLtGRxnY6rUPNXK_gC7fUVD5kA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mH5mKn38lQmfxvV3wS181sJCuINqqSQ2m
Content-Type: multipart/mixed; boundary="Q4LDmFPp51Ve12WfHgUbsm7cXGOkaacQF";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <0d67bbb1-6694-fc7e-59af-8d2273812faa-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 4/6] seccomp: Operation for checking if an action is
 available
References: <1501275352-30045-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <1501275352-30045-5-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CAGXu5j+FyiCM5dZXtPDzvuxTWLtGRxnY6rUPNXK_gC7fUVD5kA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAGXu5j+FyiCM5dZXtPDzvuxTWLtGRxnY6rUPNXK_gC7fUVD5kA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--Q4LDmFPp51Ve12WfHgUbsm7cXGOkaacQF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/03/2017 11:54 AM, Kees Cook wrote:
> On Fri, Jul 28, 2017 at 1:55 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wr=
ote:
>> Userspace code that needs to check if the kernel supports a given acti=
on
>> may not be able to use the /proc/sys/kernel/seccomp/actions_avail
>> sysctl. The process may be running in a sandbox and, therefore,
>> sufficient filesystem access may not be available. This patch adds an
>> operation to the seccomp(2) syscall that allows userspace code to ask
>> the kernel if a given action is available.
>>
>> If the action is supported by the kernel, 0 is returned. If the action=

>> is not supported by the kernel, -1 is returned with errno set to
>> -EOPNOTSUPP. If this check is attempted on a kernel that doesn't suppo=
rt
>> this new operation, -1 is returned with errno set to -EINVAL meaning
>> that userspace code will have the ability to differentiate between the=

>> two error cases.
>>
>> Signed-off-by: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>
>> * Changes since v4:
>>   - This is new patch to allow applications to check if an action is s=
upported
>>     without having to consult the actions_avail sysctl
>>
>>  include/uapi/linux/seccomp.h                  |  5 ++--
>>  kernel/seccomp.c                              | 26 ++++++++++++++++++=
+
>>  tools/testing/selftests/seccomp/seccomp_bpf.c | 36 ++++++++++++++++++=
+++++++++
>>  3 files changed, 65 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp=
=2Eh
>> index 82c823c..19a611d 100644
>> --- a/include/uapi/linux/seccomp.h
>> +++ b/include/uapi/linux/seccomp.h
>> @@ -11,8 +11,9 @@
>>  #define SECCOMP_MODE_FILTER    2 /* uses user-supplied filter. */
>>
>>  /* Valid operations for seccomp syscall. */
>> -#define SECCOMP_SET_MODE_STRICT        0
>> -#define SECCOMP_SET_MODE_FILTER        1
>> +#define SECCOMP_SET_MODE_STRICT                0
>> +#define SECCOMP_SET_MODE_FILTER                1
>> +#define SECCOMP_GET_ACTION_AVAIL       2
>>
>>  /* Valid flags for SECCOMP_SET_MODE_FILTER */
>>  #define SECCOMP_FILTER_FLAG_TSYNC      1
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 1c4c496..03ad3ba 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -858,6 +858,27 @@ static inline long seccomp_set_mode_filter(unsign=
ed int flags,
>>  }
>>  #endif
>>
>> +static long seccomp_get_action_avail(const char __user *uaction)
>> +{
>> +       u32 action;
>> +
>> +       if (copy_from_user(&action, uaction, sizeof(action)))
>> +               return -EFAULT;
>> +
>> +       switch (action) {
>> +       case SECCOMP_RET_KILL:
>> +       case SECCOMP_RET_TRAP:
>> +       case SECCOMP_RET_ERRNO:
>> +       case SECCOMP_RET_TRACE:
>> +       case SECCOMP_RET_ALLOW:
>> +               break;
>> +       default:
>> +               return -EOPNOTSUPP;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>>  /* Common entry point for both prctl and syscall. */
>>  static long do_seccomp(unsigned int op, unsigned int flags,
>>                        const char __user *uargs)
>> @@ -869,6 +890,11 @@ static long do_seccomp(unsigned int op, unsigned =
int flags,
>>                 return seccomp_set_mode_strict();
>>         case SECCOMP_SET_MODE_FILTER:
>>                 return seccomp_set_mode_filter(flags, uargs);
>> +       case SECCOMP_GET_ACTION_AVAIL:
>> +               if (flags !=3D 0)
>> +                       return -EINVAL;
>> +
>> +               return seccomp_get_action_avail(uargs);
>>         default:
>>                 return -EINVAL;
>>         }
>> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/tes=
ting/selftests/seccomp/seccomp_bpf.c
>> index eeb4f7a..8f0872b 100644
>> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
>> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> @@ -1683,6 +1683,10 @@ TEST_F_SIGNAL(TRACE_syscall, kill_after_ptrace,=
 SIGSYS)
>>  #define SECCOMP_SET_MODE_FILTER 1
>>  #endif
>>
>> +#ifndef SECCOMP_GET_ACTION_AVAIL
>> +#define SECCOMP_GET_ACTION_AVAIL 2
>> +#endif
>> +
>>  #ifndef SECCOMP_FILTER_FLAG_TSYNC
>>  #define SECCOMP_FILTER_FLAG_TSYNC 1
>>  #endif
>> @@ -2486,6 +2490,38 @@ TEST_SIGNAL(filter_flag_log, SIGSYS)
>>         EXPECT_EQ(0, syscall(__NR_getpid));
>>  }
>>
>> +TEST(get_action_avail)
>> +{
>> +       __u32 actions[] =3D { SECCOMP_RET_KILL,  SECCOMP_RET_TRAP,
>> +                           SECCOMP_RET_ERRNO, SECCOMP_RET_TRACE,
>> +                           SECCOMP_RET_ALLOW };
>> +       __u32 unknown_action =3D 0x10000000U;
>> +       int i;
>> +       long ret;
>> +
>> +       ret =3D seccomp(SECCOMP_GET_ACTION_AVAIL, 0, &actions[0]);
>> +       ASSERT_NE(ENOSYS, errno) {
>> +               TH_LOG("Kernel does not support seccomp syscall!");
>> +       }
>> +       ASSERT_NE(EINVAL, errno) {
>> +               TH_LOG("Kernel does not support SECCOMP_GET_ACTION_AVA=
IL operation!");
>> +       }
>> +       EXPECT_EQ(ret, 0);
>> +
>> +       for (i =3D 0; i < ARRAY_SIZE(actions); i++) {
>> +               ret =3D seccomp(SECCOMP_GET_ACTION_AVAIL, 0, &actions[=
i]);
>> +               EXPECT_EQ(ret, 0) {
>> +                       TH_LOG("Expected action (0x%X) not available!"=
,
>> +                              actions[i]);
>> +               }
>> +       }
>> +
>> +       /* Check that an unknown action is handled properly (EOPNOTSUP=
P) */
>> +       ret =3D seccomp(SECCOMP_GET_ACTION_AVAIL, 0, &unknown_action);=

>> +       EXPECT_EQ(ret, -1);
>> +       EXPECT_EQ(errno, EOPNOTSUPP);
>> +}
>> +
>>  /*
>>   * TODO:
>>   * - add microbenchmarks
>> --
>> 2.7.4
>>
>=20
> I like this a lot. I think it should follow the sysctl patch in the
> series, but otherwise looks great.

Good to hear! I like it a lot, as well. I'm pretty sure Andy suggested
it so I'll add a Suggested-by tag in the next revision.

Tyler


--Q4LDmFPp51Ve12WfHgUbsm7cXGOkaacQF--

--mH5mKn38lQmfxvV3wS181sJCuINqqSQ2m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZhPuEAAoJENaSAD2qAscK3UcQAJUv5dKK20WhIrznul5g9E5J
TL4GFm1VuVjk8Fiv+v0Tg7TVPE+eP+Uh9EJoB5PHLGuB3s8YhYtFOiJ7l9mM7TxE
S4uRGQyKzrSoHGC/2esNCpMKzy86eafpVK+d+BHMYZ/7EfwyRsMAAfn52B+OhTpu
nkJd6E6L+aDWZd6g02rAeOSo3Elu0qm5GddmP9C5KTv/+qAixSmiJ/I2DORYzm76
u6bfL7lcMC+gZKbHDH4BZ+hVt4CY0sbPqBdYmXvJ0qg4dvtx0L8+Tj3WK/jHNh5S
cRsa02BIaraC6IHd+XipdgcjAxgTFObzZm13twVS5NeADEyT5V5eGG8kuYkyVvO6
yHXhgs5FgOAJ5HqLmWVCcvgNzoFUe9c+Mdy6YxGDjydOF7chc5quNoAau9IiAWHh
Un5ur3QLZyR1hxbJd6uu/DD0pN3DP5huLU8KCno3yfCcl11J3sUi2z4TEMHZEigi
i4lZi4bGoDfxIZs2gvQPdrb50wBeQzGEGss7PrDIKaRHffOOTasOIIFdCzQGOa0o
BxIEBP8dLqLWosCxY3Ny41tUGDJ7E9CS42yqmbg1z2u7buWUmaqvXM9BkFJNXuZx
XaaxtacqNNFyE5OO2N+my9/0pZrNyind4jmROn46ydLY/a/MTSNStsh8TsJv0JKU
aXSUrdY9zu95v+wxZHC0
=s/mu
-----END PGP SIGNATURE-----

--mH5mKn38lQmfxvV3wS181sJCuINqqSQ2m--
