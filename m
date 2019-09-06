From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
Date: Fri, 6 Sep 2019 12:26:51 -0700
Message-ID: <C95B704C-F84F-4341-BDE7-CD70C5DDBEEF@amacapital.net>
References: <20190906152455.22757-1-mic@digikod.net> <2989749.1YmIBkDdQn@x2> <87mufhckxv.fsf@oldenburg2.str.redhat.com> <1802966.yheqmZt8Si@x2>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1802966.yheqmZt8Si@x2>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Grubb <sgrubb@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>=?u
List-Id: linux-api@vger.kernel.org



> On Sep 6, 2019, at 12:07 PM, Steve Grubb <sgrubb@redhat.com> wrote:
>=20
>> On Friday, September 6, 2019 2:57:00 PM EDT Florian Weimer wrote:
>> * Steve Grubb:
>>> Now with LD_AUDIT
>>> $ LD_AUDIT=3D/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test
>>> 2>&1 | grep passwd openat(3, "passwd", O_RDONLY)           =3D 4
>>>=20
>>> No O_CLOEXEC flag.
>>=20
>> I think you need to explain in detail why you consider this a problem.
>=20
> Because you can strip the O_MAYEXEC flag from being passed into the kernel=
.=20
> Once you do that, you defeat the security mechanism because it never gets=20=

> invoked. The issue is that the only thing that knows _why_ something is be=
ing=20
> opened is user space. With this mechanism, you can attempt to pass this=20=

> reason to the kernel so that it may see if policy permits this. But you ca=
n=20
> just remove the flag.

I=E2=80=99m with Florian here. Once you are executing code in a process, you=
 could just emulate some other unapproved code. This series is not intended t=
o provide the kind of absolute protection you=E2=80=99re imagining.

What the kernel *could* do is prevent mmapping a non-FMODE_EXEC file with PR=
OT_EXEC, which would indeed have a real effect (in an iOS-like world, for ex=
ample) but would break many, many things.=
