From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 00/11] Landlock LSM: Toward unprivileged
 sandboxing
Date: Tue, 6 Mar 2018 23:25:31 +0100
Message-ID: <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
 <CALCETrV3OZb70o83uOG437PubwBwaUJ6SKQucq_7g1BuBOmxzg@mail.gmail.com>
 <2e06621c-08e9-dc12-9b6e-9c09d5d8f458@digikod.net>
 <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="PvZReyUi33n28IxqiwHX1q5FTHMFGG1i5"
Return-path: <kernel-hardening-return-12172-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PvZReyUi33n28IxqiwHX1q5FTHMFGG1i5
Content-Type: multipart/mixed; boundary="sEcIHHJqCS6B4cMrH9dqyVOUmWwcXc4Pq";
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
Message-ID: <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net>
Subject: Re: [PATCH bpf-next v8 00/11] Landlock LSM: Toward unprivileged
 sandboxing
References: <20180227004121.3633-1-mic@digikod.net>
 <CALCETrV3OZb70o83uOG437PubwBwaUJ6SKQucq_7g1BuBOmxzg@mail.gmail.com>
 <2e06621c-08e9-dc12-9b6e-9c09d5d8f458@digikod.net>
 <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
In-Reply-To: <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>

--sEcIHHJqCS6B4cMrH9dqyVOUmWwcXc4Pq
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 28/02/2018 00:09, Andy Lutomirski wrote:
> On Tue, Feb 27, 2018 at 10:03 PM, Micka=C3=ABl Sala=C3=BCn <mic@digikod=
=2Enet> wrote:
>>
>> On 27/02/2018 05:36, Andy Lutomirski wrote:
>>> On Tue, Feb 27, 2018 at 12:41 AM, Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>>>> Hi,
>>>>
>=20
>>>>
>>>> ## Why use the seccomp(2) syscall?
>>>>
>>>> Landlock use the same semantic as seccomp to apply access rule
>>>> restrictions. It add a new layer of security for the current process=

>>>> which is inherited by its children. It makes sense to use an unique
>>>> access-restricting syscall (that should be allowed by seccomp filter=
s)
>>>> which can only drop privileges. Moreover, a Landlock rule could come=

>>>> from outside a process (e.g.  passed through a UNIX socket). It is t=
hen
>>>> useful to differentiate the creation/load of Landlock eBPF programs =
via
>>>> bpf(2), from rule enforcement via seccomp(2).
>>>
>>> This seems like a weak argument to me.  Sure, this is a bit different=

>>> from seccomp(), and maybe shoving it into the seccomp() multiplexer i=
s
>>> awkward, but surely the bpf() multiplexer is even less applicable.
>>
>> I think using the seccomp syscall is fine, and everyone agreed on it.
>>
>=20
> Ah, sorry, I completely misread what you wrote.  My apologies.  You
> can disregard most of my email.
>=20
>>
>>>
>>> Also, looking forward, I think you're going to want a bunch of the
>>> stuff that's under consideration as new seccomp features.  Tycho is
>>> working on a "user notifier" feature for seccomp where, in addition t=
o
>>> accepting, rejecting, or kicking to ptrace, you can send a message to=

>>> the creator of the filter and wait for a reply.  I think that Landloc=
k
>>> will want exactly the same feature.
>>
>> I don't think why this may be useful at all her. Landlock does not
>> filter at the syscall level but handles kernel object and actions as
>> does an LSM. That is the whole purpose of Landlock.
>=20
> Suppose I'm writing a container manager.  I want to run "mount" in the
> container, but I don't want to allow moun() in general and I want to
> emulate certain mount() actions.  I can write a filter that catches
> mount using seccomp and calls out to the container manager for help.
> This isn't theoretical -- Tycho wants *exactly* this use case to be
> supported.

Well, I think this use case should be handled with something like
LD_PRELOAD and a helper library. FYI, I did something like this:
https://github.com/stemjail/stemshim

Otherwise, we should think about enabling a process to (dynamically)
extend/patch the vDSO (similar to LD_PRELOAD but at the syscall level
and works with static binaries) for a subset of processes (the same way
seccomp filters are inherited). It may be more powerful and flexible
than extending the kernel/seccomp to patch (buggy?) userland.

>=20
> But using seccomp for this is indeed annoying.  It would be nice to
> use Landlock's ability to filter based on the filesystem type, for
> example.  So Tycho could write a Landlock rule like:
>=20
> bool filter_mount(...)
> {
>   if (path needs emulation)
>     call_user_notifier();
> }
>=20
> And it should work.
>=20
> This means that, if both seccomp user notifiers and Landlock make it
> upstream, then there should probably be a way to have a user notifier
> bound to a seccomp filter and a set of landlock filters.
>=20

Using seccomp filters and Landlock programs may be powerful. However,
for this use case, I think a *post-syscall* vDSO-like (which could get
some data returned by a Landlock program) may be much more flexible
(with less kernel code). What is needed here is a way to know the kernel
semantic (Landlock) and a way to patch userland without patching its
code (vDSO-like).


--sEcIHHJqCS6B4cMrH9dqyVOUmWwcXc4Pq--

--PvZReyUi33n28IxqiwHX1q5FTHMFGG1i5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlqfFVsACgkQIt7+33O9
apXBpgf+IexCxH4mYe+h7ZXCYbbX2SNVuELlcdHdOc0/nWAtQp1iE60Q5cerYFzd
2GyIc2aNTXQo8bxcvUIubzGPmvIiDkuAB5FvaDsjgkC/02YisW6N9QegxMx7duD6
QtHTiW8LqIektN1IkNstUXn6M796ToUjMMrJo+Mh/hyUV488wepbsPNvRQwTD9g8
sbvC1CVnQQtjqPNkgqaI1uA4n3hRB75a+9JH8tRu/Z7CP9EiTpqVuJhx02R7jO8P
k2aMZXLNbdO3p14nk67gL/TMhLIIPLEcVWICjmDexGMY+o3ehARIYV+KqEXVbzO4
rgQ9zEHUngRX4523Yf46CtEZUgn+3A==
=i3OW
-----END PGP SIGNATURE-----

--PvZReyUi33n28IxqiwHX1q5FTHMFGG1i5--
