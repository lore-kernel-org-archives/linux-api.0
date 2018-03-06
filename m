From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 00/11] Landlock LSM: Toward unprivileged
 sandboxing
Date: Wed, 7 Mar 2018 00:06:55 +0100
Message-ID: <7082be04-d6af-b853-4bb7-f331836662e2@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
 <CALCETrV3OZb70o83uOG437PubwBwaUJ6SKQucq_7g1BuBOmxzg@mail.gmail.com>
 <2e06621c-08e9-dc12-9b6e-9c09d5d8f458@digikod.net>
 <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
 <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net>
 <CALCETrUQYp0ta4tLgUWJ79pZVwp3WRY7cp-XaPcn1WyTc=wZyg@mail.gmail.com>
 <20180306224636.wf5z3kujtc7r5qyh@cisco>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="CA5yknZ0yvPQg8R5gPdoSxYt4QYQkvwQk"
Return-path: <kernel-hardening-return-12177-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20180306224636.wf5z3kujtc7r5qyh@cisco>
To: Tycho Andersen <tycho@tycho.ws>, Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>, Kernel Hardening <kernel-hardening@lists.>
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CA5yknZ0yvPQg8R5gPdoSxYt4QYQkvwQk
Content-Type: multipart/mixed; boundary="lw8U6tC1t0QnNZz2bsHmZ8eUNemphPWuw";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Tycho Andersen <tycho@tycho.ws>, Andy Lutomirski <luto@amacapital.net>
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
 Thomas Graf <tgraf@suug.ch>, Will Drewry <wad@chromium.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Network Development <netdev@vger.kernel.org>
Message-ID: <7082be04-d6af-b853-4bb7-f331836662e2@digikod.net>
Subject: Re: [PATCH bpf-next v8 00/11] Landlock LSM: Toward unprivileged
 sandboxing
References: <20180227004121.3633-1-mic@digikod.net>
 <CALCETrV3OZb70o83uOG437PubwBwaUJ6SKQucq_7g1BuBOmxzg@mail.gmail.com>
 <2e06621c-08e9-dc12-9b6e-9c09d5d8f458@digikod.net>
 <CALCETrWnJ7WkkfiymyahQd7YqO0KXP4mG1pRMq7fp8LG8Bwtcw@mail.gmail.com>
 <a70b41ee-78cb-52cc-152c-ac5e43b7e45c@digikod.net>
 <CALCETrUQYp0ta4tLgUWJ79pZVwp3WRY7cp-XaPcn1WyTc=wZyg@mail.gmail.com>
 <20180306224636.wf5z3kujtc7r5qyh@cisco>
In-Reply-To: <20180306224636.wf5z3kujtc7r5qyh@cisco>

--lw8U6tC1t0QnNZz2bsHmZ8eUNemphPWuw
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 06/03/2018 23:46, Tycho Andersen wrote:
> On Tue, Mar 06, 2018 at 10:33:17PM +0000, Andy Lutomirski wrote:
>>>> Suppose I'm writing a container manager.  I want to run "mount" in t=
he
>>>> container, but I don't want to allow moun() in general and I want to=

>>>> emulate certain mount() actions.  I can write a filter that catches
>>>> mount using seccomp and calls out to the container manager for help.=

>>>> This isn't theoretical -- Tycho wants *exactly* this use case to be
>>>> supported.
>>>
>>> Well, I think this use case should be handled with something like
>>> LD_PRELOAD and a helper library. FYI, I did something like this:
>>> https://github.com/stemjail/stemshim
>>
>> I doubt that will work for containers.  Containers that use user
>> namespaces and, for example, setuid programs aren't going to honor
>> LD_PRELOAD.
>=20
> Or anything that calls syscalls directly, like go programs.

That's why the vDSO-like approach. Enforcing an access control is not
the issue here, patching a buggy userland (without patching its code) is
the issue isn't it?

As far as I remember, the main problem is to handle file descriptors
while "emulating" the kernel behavior. This can be done with a "shim"
code mapped in every processes. Chrome used something like this (in a
previous sandbox mechanism) as a kind of emulation (with the current
seccomp-bpf ). I think it should be doable to replace the (userland)
emulation code with an IPC wrapper receiving file descriptors through
UNIX socket.


--lw8U6tC1t0QnNZz2bsHmZ8eUNemphPWuw--

--CA5yknZ0yvPQg8R5gPdoSxYt4QYQkvwQk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlqfHw8ACgkQIt7+33O9
apXd6QgAkdBZYFx+RgVgfvJaenKD/R5clTVlOGT63Qf0KnK9njn/xCLkbjAV4vPq
fnVKGJqpJ0QF0wY64Gyh8Kh0NJ3RuH50GzNeW9pZ/wvtNkbJ5iZby4/oN8UhKpZb
Chi/0bcM/Qb538hky6YJPbKnJ2DMb4hSU5ufmcWIMIccRkKC/+in/aarZpUGwtHD
kdQ6R2o1vT1+KdXP2OgfuJ/Gf6s8Nq023yHMj7EOyk1M4f7+RUSFFV4wZIe3MNsW
pG6me6GlXD6OF5f6mgDYf4sGZG/8UZx7zwYCVFWzDj1lDs0QRTUrmFzXTlV+63hz
BOPunr5a+PdAFogK+Fr6sfvZctbGYA==
=Oltr
-----END PGP SIGNATURE-----

--CA5yknZ0yvPQg8R5gPdoSxYt4QYQkvwQk--
