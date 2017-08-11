From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v6 3/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
Date: Fri, 11 Aug 2017 14:33:35 -0500
Message-ID: <23a0adb0-4db0-52aa-831e-36ceca466636@canonical.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
 <1502426037-3777-4-git-send-email-tyhicks@canonical.com>
 <CAGXu5jJzboJ47tZH_BkeXTYgD_QyTpK4gXd8FTpcj-acO-F+VQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="vf166FoOTicavmQ7pFME8SGwsd3V2ltXo"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5jJzboJ47tZH_BkeXTYgD_QyTpK4gXd8FTpcj-acO-F+VQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vf166FoOTicavmQ7pFME8SGwsd3V2ltXo
Content-Type: multipart/mixed; boundary="wIkJ8vvUXjaSd4TFvqA4hmj8xji8GPOSm";
 protected-headers="v1"
From: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>,
 Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Tycho Andersen <tycho-FCduhRhOUaTQT0dZR+AlfA@public.gmane.org>,
 linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <23a0adb0-4db0-52aa-831e-36ceca466636-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v6 3/6] seccomp: Sysctl to configure actions that are
 allowed to be logged
References: <1502426037-3777-1-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <1502426037-3777-4-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
 <CAGXu5jJzboJ47tZH_BkeXTYgD_QyTpK4gXd8FTpcj-acO-F+VQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAGXu5jJzboJ47tZH_BkeXTYgD_QyTpK4gXd8FTpcj-acO-F+VQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--wIkJ8vvUXjaSd4TFvqA4hmj8xji8GPOSm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/11/2017 02:17 PM, Kees Cook wrote:
> On Thu, Aug 10, 2017 at 9:33 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wr=
ote:
>> +static int seccomp_actions_logged_handler(struct ctl_table *ro_table,=
 int write,
>> +                                         void __user *buffer, size_t =
*lenp,
>> +                                         loff_t *ppos)
>> +{
>> +       char names[sizeof(seccomp_actions_avail)];
>> +       struct ctl_table table;
>> +       int ret;
>> +
>> +       if (write && !capable(CAP_SYS_ADMIN))
>> +               return -EPERM;
>> +
>> +       memset(names, 0, sizeof(names));
>> +
>> +       if (!write) {
>> +               if (!seccomp_names_from_actions_logged(names, sizeof(n=
ames),
>> +                                                      seccomp_actions=
_logged))
>> +                       return -EINVAL;
>> +       }
>> +
>> +       table =3D *ro_table;
>> +       table.data =3D names;
>> +       table.maxlen =3D sizeof(names);
>> +       ret =3D proc_dostring(&table, write, buffer, lenp, ppos);
>> +       if (ret)
>> +               return ret;
>> +
>> +       if (write) {
>> +               u32 actions_logged;
>> +
>> +               if (!seccomp_actions_logged_from_names(&actions_logged=
,
>> +                                                      table.data))
>> +                       return -EINVAL;
>> +
>> +               if (actions_logged & SECCOMP_LOG_ALLOW)
>> +                       return -EINVAL;
>> +
>> +               seccomp_actions_logged =3D actions_logged;
>> +       }
>> +
>> +       return 0;
>> +}
>=20
> One thought here: should "kill" be always forced on during a write?
> This flag effectively cannot be disabled, so listing it (or not) in
> the sysctl may be confusing...

"kill" can be silenced in the current implementation. Lets hammer out
whether or not that's the right thing to do and then we can discuss the
sysctl behavior on write. I don't personally have any concerns about an
admin being able to silence RET_KILL logs but let me know if you are
against it.

Tyler

>=20
> -Kees
>=20



--wIkJ8vvUXjaSd4TFvqA4hmj8xji8GPOSm--

--vf166FoOTicavmQ7pFME8SGwsd3V2ltXo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJZjgaPAAoJENaSAD2qAscKs7gP/jtiAkgPVozx/AVZ705COp6Y
ugRLsXc6g3tIX3TM9ozFNaSq6SinFIIyG8B54QyB17O2NMKdCA26wm1Uk/ZPv4eO
zlay7LZSwFN6aymmNN3NF94TwaFBgZn7qYUZJIwbDItp3YWbOO4oD3JXXct1GU6D
HRwICU1lzrGy+2+J3xfIn/7lVI1IY2uHGDvMHPwy2hqtLPWNgDHqP+t2rTHrHLhW
E6yNiMWY9QDiKrOax0pVLyKLWsdNnSVuhFt3qLu8pW+ChlLnbnY4XGgRKc0iYPWz
Tb3zYXhEcK4bZT1FYe3IcIUlo3BYKv9M6cd4Ih5ooSR7ECsJwAOSOkzfdKKVNA8n
Dc3Azx34agOP9KZ7IWOHoYe9GYrTcRliznevfWmC79nbvsrJibTvpabX+9am8t70
8J2uQvEmJqKDLi1GEdgah4NdKW37J8gPTZNxfwNXM8b+HGd3AKmptwJ7Zsr6E4Dq
gXDM7gp++8SDAEdxzaCX9Kg4CohOmXTwGR5GF9i1bL7uHqZY8DN1a9n6HyttlaGg
ocofcFamL0mUjTPBh5GaAPM54HTtft56hoOiVKeWFi3nQGKsWVdfB1r4pk8w3Ipn
rZc3LffosD3TqwKxc/2378k/yir8uOP5XF5znP1KBZm0aHE/LcQIes5UpEtPkYYC
6pqsL6OvfHAaMYVeIxCx
=1d09
-----END PGP SIGNATURE-----

--vf166FoOTicavmQ7pFME8SGwsd3V2ltXo--
