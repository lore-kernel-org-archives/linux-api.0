From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Fri, 6 Sep 2019 19:24:25 +0200
Message-ID: <062c25e2-1996-c32c-46a1-aa831d69930f@ssi.gouv.fr>
References: <20190906152455.22757-1-mic@digikod.net>
 <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <20190906170739.kk3opr2phidb7ilb@yavin.dot.cyphar.com>
 <20190906172050.v44f43psd6qc6awi@wittgenstein>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190906172050.v44f43psd6qc6awi@wittgenstein>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>, Aleksa Sarai <cyphar@cyphar.com>
Cc: Florian Weimer <fweimer@redhat.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@mi>
List-Id: linux-api@vger.kernel.org


On 06/09/2019 19:20, Christian Brauner wrote:
> On Sat, Sep 07, 2019 at 03:07:39AM +1000, Aleksa Sarai wrote:
>> On 2019-09-06, Micka=C3=ABl Sala=C3=BCn <mickael.salaun@ssi.gouv.fr> wro=
te:
>>>
>>> On 06/09/2019 17:56, Florian Weimer wrote:
>>>> Let's assume I want to add support for this to the glibc dynamic loade=
r,
>>>> while still being able to run on older kernels.
>>>>
>>>> Is it safe to try the open call first, with O_MAYEXEC, and if that fai=
ls
>>>> with EINVAL, try again without O_MAYEXEC?
>>>
>>> The kernel ignore unknown open(2) flags, so yes, it is safe even for
>>> older kernel to use O_MAYEXEC.
>>
>> Depends on your definition of "safe" -- a security feature that you will
>> silently not enable on older kernels doesn't sound super safe to me.
>> Unfortunately this is a limitation of open(2) that we cannot change --
>> which is why the openat2(2) proposal I've been posting gives -EINVAL for
>> unknown O_* flags.
>>
>> There is a way to probe for support (though unpleasant), by creating a
>> test O_MAYEXEC fd and then checking if the flag is present in
>> /proc/self/fdinfo/$n.
>
> Which Florian said they can't do for various reasons.
>
> It is a major painpoint if there's no easy way for userspace to probe
> for support. Especially if it's security related which usually means
> that you want to know whether this feature works or not.

I used "safe" deliberately (not "secure" which didn't make sense in this
sentence). According to the threat model, if the kernel doesn't support
the feature, it should be ignored by userland. In this case, it fit well
with the current behavior of open(2). I agree that the openat2(2)
behavior handling flags is the good way to do it (whitelisting), but the
O_MAYEXEC flag should not change the userland behavior on its own,
because it depend on a global policy. Even being able to probe for
O_MAYEXEC support does not make sense because it would not be enough to
know the system policy (either this flag is enforced or not=E2=80=A6).

Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=A9=
es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=99ex=
=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=A8re=
nt dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessaire =C3=
=A0 cette relation. Si vous souhaitez faire usage de vos droits de consulta=
tion, de rectification et de suppression de vos donn=C3=A9es, veuillez cont=
acter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message par err=
eur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9diteur e=
t de d=C3=A9truire le message. The personal data collected and processed du=
ring this exchange aims solely at completing a business relationship and is=
 limited to the necessary duration of that relationship. If you wish to use=
 your rights of consultation, rectification and deletion of your data, plea=
se contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message i=
n error, we thank you for informing the sender and destroying the message.
