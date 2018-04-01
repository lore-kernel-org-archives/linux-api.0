From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
Date: Mon, 2 Apr 2018 00:48:55 +0200
Message-ID: <63c56227-7394-92d5-d663-59dbe0efe20f@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
 <20180227004121.3633-9-mic@digikod.net>
 <CALCETrUpDbusLPyZijR6MpZd5-0x0d9KuQHBaavqP1_GZ2tjfg@mail.gmail.com>
 <D6B96EE0-8932-4845-BFA5-4C65E5189AFB@amacapital.net>
 <0e7d0512-12a3-568d-aa55-3def4b91c6d0@digikod.net>
 <CALCETrUTiUeV71jgYWup0CZwG8eQ3=W7X5FgJqmgPxnYbFsccw@mail.gmail.com>
 <CALCETrV_BVc44YYq6g8PCpeUYuqQaooVoQSQ7Y=VpuaBshQgQg@mail.gmail.com>
 <f560a30d-10fd-31fc-adba-911961915937@digikod.net>
 <CALCETrW5v1sa17jPJuTskW5vdvcXqjFtRvAd0auWBmKvnAX-zQ@mail.gmail.com>
 <679089bb-c0ac-ff68-71b1-1813d66c6aa7@digikod.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Hm7bzBjMedEZq5T95smQuMfPMscRewwT9"
Return-path: <kernel-hardening-return-12842-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <679089bb-c0ac-ff68-71b1-1813d66c6aa7@digikod.net>
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Hm7bzBjMedEZq5T95smQuMfPMscRewwT9
Content-Type: multipart/mixed; boundary="FOcscaVWkHHqGJfqTL970AuU7bacqfRtS";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Daniel Borkmann <daniel@iogearbox.net>, David Drysdale
 <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>,
 "Eric W . Biederman" <ebiederm@xmission.com>,
 James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
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
Message-ID: <63c56227-7394-92d5-d663-59dbe0efe20f@digikod.net>
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
 <679089bb-c0ac-ff68-71b1-1813d66c6aa7@digikod.net>
In-Reply-To: <679089bb-c0ac-ff68-71b1-1813d66c6aa7@digikod.net>

--FOcscaVWkHHqGJfqTL970AuU7bacqfRtS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable


On 03/06/2018 11:28 PM, Micka=C3=ABl Sala=C3=BCn wrote:
>=20
> On 28/02/2018 01:09, Andy Lutomirski wrote:
>> On Wed, Feb 28, 2018 at 12:00 AM, Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>>>
>>> On 28/02/2018 00:23, Andy Lutomirski wrote:
>>>> On Tue, Feb 27, 2018 at 11:02 PM, Andy Lutomirski <luto@kernel.org> =
wrote:
>>>>> On Tue, Feb 27, 2018 at 10:14 PM, Micka=C3=ABl Sala=C3=BCn <mic@dig=
ikod.net> wrote:
>>>>>>
>>>>>
>>>>> I think you're wrong here.  Any sane container trying to use Landlo=
ck
>>>>> like this would also create a PID namespace.  Problem solved.  I st=
ill
>>>>> think you should drop this patch.
>>>
>>> Containers is one use case, another is build-in sandboxing (e.g. for =
web
>>> browser=E2=80=A6) and another one is for sandbox managers (e.g. Firej=
ail,
>>> Bubblewrap, Flatpack=E2=80=A6). In some of these use cases, especiall=
y from a
>>> developer point of view, you may want/need to debug your applications=

>>> (without requiring to be root). For nested Landlock access-controls
>>> (e.g. container + user session + web browser), it may not be allowed =
to
>>> create a PID namespace, but you still want to have a meaningful
>>> access-control.
>>>
>>
>> The consideration should be exactly the same as for normal seccomp.
>> If I'm in a container (using PID namespaces + seccomp) and a run a web=

>> browser, I can debug the browser.
>>
>> If there's a real use case for adding this type of automatic ptrace
>> protection, then by all means, let's add it as a general seccomp
>> feature.
>>
>=20
> Right, it makes sense to add this feature to seccomp filters as well.
> What do you think Kees?
>=20

As a second though, it may be useful for seccomp but it should be
another patch series, independent from this one.

The idea to keep in mind is that this ptrace restriction is an automatic
way to define what is called a subject in common access control
vocabulary, like used by SELinux. A subject should not be able to
impersonate another one with less restrictions (to get more rights).
Because of the stackable restrictions of Landlock (same principle used
by seccomp), it is easy to identify which subject (i.e. group of
processes) is more restricted (or with different restrictions) than
another. This follow the same principle as Yama's ptrace_scope.

Another important argument for a different ptrace-protection
mechanism than seccomp is that Landlock programs may be applied (i.e.
define subject) otherwise than with a process hierarchy. Another way to
define a Landlock subject may be by using cgroups (which was previously
discussed). I'm also thinking about being able to create (real)
capabilities (not to be confused with POSIX capabilities), which may be
useful to implement some parts of Capsicum, by attaching Landlock
programs to a file descriptor (and not directly to a group of
processes). All this to highlight that the ptrace protection is specific
to Landlock and may not be directly shared with seccomp.

Even if Landlock follows the footprints of seccomp, they are different
beasts.


--FOcscaVWkHHqGJfqTL970AuU7bacqfRtS--

--Hm7bzBjMedEZq5T95smQuMfPMscRewwT9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlrBYdgACgkQIt7+33O9
apVKrQf+K+rJsgAAjeWuJAd0c5iCLG/3/eyy8Ioxr7BXFBsj4/I3+GZNohC+r7Q/
cIQGPOhEXh1LoB/FLTpUwkbic8LudVKm6qB+2e3OCta1WEZKxWO/QaI9Hf0g6Flk
/v7WBBghhZt/RkIMkHl0QNzx41ZJbBRrwP3yMsxhcgToyEZDBywcJq83hKyczDO7
fJxMVugDgh7rdMwhdGdJj9RQrKOl5DKlWQXvAr1d8D1g4RkwT9nQLYfbc2JXNaC/
miJ0Eo2F8le8UtTmf89fkO0tEMFmA45s4+CRkDz6Qd8zRjpW2vWi8LKdNwMmPIM0
ne5ynEnMA8YlvNwz8pSxXHBO71G0ag==
=p4QM
-----END PGP SIGNATURE-----

--Hm7bzBjMedEZq5T95smQuMfPMscRewwT9--
