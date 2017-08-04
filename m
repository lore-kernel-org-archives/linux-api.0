From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 6/6] seccomp: Selftest for detection of filter flag
 support
Date: Fri, 4 Aug 2017 17:57:59 -0500
Message-ID: <3cdfd28d-0bc8-1e98-5d18-98ab8267cba7@canonical.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com>
 <1501275352-30045-7-git-send-email-tyhicks@canonical.com>
 <CAGXu5j+jFK9QzHhMG532cs-J1DUxdnt7890-psqJh6uYdeppcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="chBWaJ7rKmF1bOUqhttVVxi0mNOvjJe0P"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+jFK9QzHhMG532cs-J1DUxdnt7890-psqJh6uYdeppcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--chBWaJ7rKmF1bOUqhttVVxi0mNOvjJe0P
Content-Type: multipart/mixed; boundary="uWwEpU6E7xMg8XMfNxn2iAHU7btqgsKJD";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
 LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <3cdfd28d-0bc8-1e98-5d18-98ab8267cba7-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v5 6/6] seccomp: Selftest for detection of filter flag
 support
References: <1501275352-30045-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <1501275352-30045-7-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CAGXu5j+jFK9QzHhMG532cs-J1DUxdnt7890-psqJh6uYdeppcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAGXu5j+jFK9QzHhMG532cs-J1DUxdnt7890-psqJh6uYdeppcQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--uWwEpU6E7xMg8XMfNxn2iAHU7btqgsKJD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/03/2017 11:58 AM, Kees Cook wrote:
> On Fri, Jul 28, 2017 at 1:55 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wr=
ote:
>> Userspace needs to be able to reliably detect the support of a filter
>> flag. A good way of doing that is by attempting to enter filter mode,
>> with the flag bit(s) in question set, and a NULL pointer for the args
>> parameter of seccomp(2). EFAULT indicates that the flag is valid and
>> EINVAL indicates that the flag is invalid.
>>
>> This patch adds a selftest that can be used to test this method of
>> detection in userspace.
>>
>> Signed-off-by: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
>> ---
>>
>> * Changes since v4:
>>   - This is a new patch
>>
>>  tools/testing/selftests/seccomp/seccomp_bpf.c | 58 ++++++++++++++++++=
+++++++++
>>  1 file changed, 58 insertions(+)
>>
>> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/tes=
ting/selftests/seccomp/seccomp_bpf.c
>> index 040e875..d221437 100644
>> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
>> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> @@ -1885,6 +1885,64 @@ TEST(seccomp_syscall_mode_lock)
>>         }
>>  }
>>
>> +/* Test detection of known and unknown filter flags. Userspace needs =
to be able
>> + * to check if a filter flag is support by the current kernel and a g=
ood way of
>> + * doing that is by attempting to enter filter mode, with the flag bi=
t in
>> + * question set, and a NULL pointer for the _args_ parameter. EFAULT =
indicates
>> + * that the flag is valid and EINVAL indicates that the flag is inval=
id.
>> + */
>> +TEST(detect_seccomp_filter_flags)
>> +{
>> +       unsigned int flags[] =3D { SECCOMP_FILTER_FLAG_TSYNC,
>> +                                SECCOMP_FILTER_FLAG_LOG };
>> +       unsigned int flag, all_flags;
>> +       int i;
>> +       long ret;
>> +
>> +       /* Test detection of known-good filter flags */
>> +       for (i =3D 0, all_flags =3D 0; i < ARRAY_SIZE(flags); i++) {
>> +               flag =3D flags[i];
>> +               ret =3D seccomp(SECCOMP_SET_MODE_FILTER, flag, NULL);
>> +               ASSERT_NE(ENOSYS, errno) {
>> +                       TH_LOG("Kernel does not support seccomp syscal=
l!");
>> +               }
>> +               EXPECT_EQ(-1, ret);
>> +               EXPECT_EQ(EFAULT, errno) {
>> +                       TH_LOG("Failed to detect that a known-good fil=
ter flag (0x%X) is supported!",
>> +                              flag);
>> +               }
>> +
>> +               all_flags |=3D flag;
>> +       }
>> +
>> +       /* Test detection of all known-good filter flags */
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, all_flags, NULL);
>> +       EXPECT_EQ(-1, ret);
>> +       EXPECT_EQ(EFAULT, errno) {
>> +               TH_LOG("Failed to detect that all known-good filter fl=
ags (0x%X) are supported!",
>> +                      all_flags);
>> +       }
>> +
>> +       /* Test detection of an unknown filter flag */
>> +       flag =3D -1;
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, flag, NULL);
>> +       EXPECT_EQ(-1, ret);
>> +       EXPECT_EQ(EINVAL, errno) {
>> +               TH_LOG("Failed to detect that an unknown filter flag (=
0x%X) is unsupported!",
>> +                      flag);
>> +       }
>> +
>> +       /* Test detection of an unknown filter flag that may simply ne=
ed to be
>> +        * added to this test */
>> +       flag =3D flags[ARRAY_SIZE(flags) - 1] << 1;
>> +       ret =3D seccomp(SECCOMP_SET_MODE_FILTER, flag, NULL);
>> +       EXPECT_EQ(-1, ret);
>> +       EXPECT_EQ(EINVAL, errno) {
>> +               TH_LOG("Failed to detect that an unknown filter flag (=
0x%X) is unsupported! Does a new flag need to be added to this test?",
>> +                      flag);
>> +       }
>> +}
>> +
>>  TEST(TSYNC_first)
>>  {
>>         struct sock_filter filter[] =3D {
>> --
>> 2.7.4
>>
>=20
> This is good, yes. Can you actually move it earlier in the series, so
> it will pass before adding ..._FLAG_LOG, and then the patch adding
> ..._FLAG_LOG will add it to this test too?

Yeah, that's the correct way to order it.

Tyler

>=20
> Thanks!
>=20
> -Kees
>=20



--uWwEpU6E7xMg8XMfNxn2iAHU7btqgsKJD--

--chBWaJ7rKmF1bOUqhttVVxi0mNOvjJe0P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZhPv3AAoJENaSAD2qAscKmqoP/1GcPiebvRw9Oy26ZVUnYJsA
6jylEKoJH0eTHbqAdEaURCf7afavXzYQ53bAuAbXfAqjhTDWc2Ki9kjGsBD/4pyW
AMaW96URyQ9l7Ikb2xNYMerppV/4+bRPy5Mq2c6493+q5cLFeEwHKllTpeok6mgJ
dhRjGL/ar/RWhzi2YbrjtxIuBkLR+rXTfeW8eB7jfYMFUXFvhr/6QQMe1hyn9tj6
O93SzyAw4kphJ7OszK+uT4Ro2T1TwwXJ5Y1rb9NOu4od7T9w26BSLEjV6J8OgQ+y
NwZoPAZ28M0mtbtr1s5qbR/5pp2NE4dIC/SZ4idt3SFozNnUQsayEiaglXesS1lQ
ifiWSmcWw26kXjDl3g+28lr5PI6F7V8cGYVg4rmN2N43ojMSR0JQWaJf8iv8Uvt9
FS1v0iDBgtXG/mgx97ciW05t9nY/WMH/Z+zNw80yohK6uX1sv1+3/vWVhPM4DMce
AJYsdiwz+D8ZDFBixiy/nLqPNJxDKr8ZcP2UAzAwOgAnH0ltHoMxtXT/p3DmjOll
N98ZIGsjpof47NF0C5alAz67yPnP5phAA48SF7U6M9P7PhatdovBRvZqrKLjaMa5
lqMUiuPsxbkJH3ZTGHm9fFbYBD5yzwJl0/BXy7mVkKEEhdQUJpN4eSKniqQVAg/1
HbTcnoOTSUO+x8dLATEr
=biro
-----END PGP SIGNATURE-----

--chBWaJ7rKmF1bOUqhttVVxi0mNOvjJe0P--
