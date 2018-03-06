From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
Date: Tue, 6 Mar 2018 23:28:24 +0100
Message-ID: <679089bb-c0ac-ff68-71b1-1813d66c6aa7@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
 <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
 <CALCETrUTiUeV71jgYWup0CZwG8eQ3=W7X5FgJqmgPxnYbFsccw@mail.gmail.com>
 <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com>
 <f560a30d-10fd-31fc-adba-911961915937@digikod.net>
 <CALCETrW5v1sa17jPJuTskW5vdvcXqjFtRvAd0auWBmKvnAX-zQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="h92TW2B8M4QjpHrJfREMpzqkQ8my7B1ZE"
Return-path: <kernel-hardening-return-12173-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <CALCETrW5v1sa17jPJuTskW5vdvcXqjFtRvAd0auWBmKvnAX-zQ@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--h92TW2B8M4QjpHrJfREMpzqkQ8my7B1ZE
Content-Type: multipart/mixed; boundary="kZcZjw0WKnGSqLFbzG2fiWrSWdoqrYTdI";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Andy Lutomirski <luto@kernel.org>
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
Message-ID: <679089bb-c0ac-ff68-71b1-1813d66c6aa7@digikod.net>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
 <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
 <CALCETrUTiUeV71jgYWup0CZwG8eQ3=W7X5FgJqmgPxnYbFsccw@mail.gmail.com>
 <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com>
 <f560a30d-10fd-31fc-adba-911961915937@digikod.net>
 <CALCETrW5v1sa17jPJuTskW5vdvcXqjFtRvAd0auWBmKvnAX-zQ@mail.gmail.com>
In-Reply-To: <CALCETrW5v1sa17jPJuTskW5vdvcXqjFtRvAd0auWBmKvnAX-zQ@mail.gmail.com>

--kZcZjw0WKnGSqLFbzG2fiWrSWdoqrYTdI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 28/02/2018 01:09, Andy Lutomirski wrote:
> On Wed, Feb 28, 2018 at 12:00 AM, Micka=C3=ABl Sala=C3=BCn <mic@digikod=
=2Enet> wrote:
>>
>> On 28/02/2018 00:23, Andy Lutomirski wrote:
>>> On Tue, Feb 27, 2018 at 11:02 PM, Andy Lutomirski <luto@kernel.org> w=
rote:
>>>> On Tue, Feb 27, 2018 at 10:14 PM, Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:
>>>>>
>>>>
>>>> I think you're wrong here.  Any sane container trying to use Landloc=
k
>>>> like this would also create a PID namespace.  Problem solved.  I sti=
ll
>>>> think you should drop this patch.
>>
>> Containers is one use case, another is build-in sandboxing (e.g. for w=
eb
>> browser=E2=80=A6) and another one is for sandbox managers (e.g. Fireja=
il,
>> Bubblewrap, Flatpack=E2=80=A6). In some of these use cases, especially=
 from a
>> developer point of view, you may want/need to debug your applications
>> (without requiring to be root). For nested Landlock access-controls
>> (e.g. container + user session + web browser), it may not be allowed t=
o
>> create a PID namespace, but you still want to have a meaningful
>> access-control.
>>
>=20
> The consideration should be exactly the same as for normal seccomp.
> If I'm in a container (using PID namespaces + seccomp) and a run a web
> browser, I can debug the browser.
>=20
> If there's a real use case for adding this type of automatic ptrace
> protection, then by all means, let's add it as a general seccomp
> feature.
>=20

Right, it makes sense to add this feature to seccomp filters as well.
What do you think Kees?


--kZcZjw0WKnGSqLFbzG2fiWrSWdoqrYTdI--

--h92TW2B8M4QjpHrJfREMpzqkQ8my7B1ZE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlqfFggACgkQIt7+33O9
apW73AgAnM/G8lr+aVe8sB1ahRhpdMjsohKrFeRcQE1cCiGoBWE+XYz2FA3dHmiT
3cUeRbnQKONbgHsGF33+gzELd9Xrog1UfCi5BDaGQV4HYfCaMjr/ZiNQnaXXkw1L
20nM3CZ2H7Y9Skohqt03fca0D3Em+VpFoIRNjin+QziCTpPKEr6YUqQasUmrBT1H
FwjH9rEHtoUCavixV7k1cZgNaOBCwB8oKvgN/sYOkPn9CQLFQ2XaPLZz9To68UlZ
BJwk/D1KCSGWdNSfyuz9TQmXrChalw1+D+HF1EDLTet30zGQIeg2BzOON212F6wM
10W0n7lKkDWr/PskDeRE2EY8S4pYZw==
=zkVw
-----END PGP SIGNATURE-----

--h92TW2B8M4QjpHrJfREMpzqkQ8my7B1ZE--
