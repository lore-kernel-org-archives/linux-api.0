From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Mon, 9 Sep 2019 11:33:40 +0200
Message-ID: <382034b9-d9fb-b5d7-5cfe-c78f17abff04@ssi.gouv.fr>
References: <20190906152455.22757-1-mic@digikod.net>
 <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
 <20190906171335.d7mc3no5tdrcn6r5@yavin.dot.cyphar.com>
 <e1ac9428e6b768ac3145aafbe19b24dd6cf410b9.camel@kernel.org>
 <D2A57C7B-B0FD-424E-9F81-B858FFF21FF0@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <D2A57C7B-B0FD-424E-9F81-B858FFF21FF0@amacapital.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Jeff Layton <jlayton@kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Florian Weimer <fweimer@redhat.com>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi>
List-Id: linux-api@vger.kernel.org


On 06/09/2019 22:06, Andy Lutomirski wrote:
>
>
>> On Sep 6, 2019, at 12:43 PM, Jeff Layton <jlayton@kernel.org> wrote:
>>
>>> On Sat, 2019-09-07 at 03:13 +1000, Aleksa Sarai wrote:
>>>> On 2019-09-06, Jeff Layton <jlayton@kernel.org> wrote:
>>>>> On Fri, 2019-09-06 at 18:06 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
>>>>>> On 06/09/2019 17:56, Florian Weimer wrote:
>>>>>> Let's assume I want to add support for this to the glibc dynamic loa=
der,
>>>>>> while still being able to run on older kernels.
>>>>>>
>>>>>> Is it safe to try the open call first, with O_MAYEXEC, and if that f=
ails
>>>>>> with EINVAL, try again without O_MAYEXEC?
>>>>>
>>>>> The kernel ignore unknown open(2) flags, so yes, it is safe even for
>>>>> older kernel to use O_MAYEXEC.
>>>>>
>>>>
>>>> Well...maybe. What about existing programs that are sending down bogus
>>>> open flags? Once you turn this on, they may break...or provide a way t=
o
>>>> circumvent the protections this gives.
>>>
>>> It should be noted that this has been a valid concern for every new O_*
>>> flag introduced (and yet we still introduced new flags, despite the
>>> concern) -- though to be fair, O_TMPFILE actually does have a
>>> work-around with the O_DIRECTORY mask setup.
>>>
>>> The openat2() set adds O_EMPTYPATH -- though in fairness it's also
>>> backwards compatible because empty path strings have always given ENOEN=
T
>>> (or EINVAL?) while O_EMPTYPATH is a no-op non-empty strings.
>>>
>>>> Maybe this should be a new flag that is only usable in the new openat2=
()
>>>> syscall that's still under discussion? That syscall will enforce that
>>>> all flags are recognized. You presumably wouldn't need the sysctl if y=
ou
>>>> went that route too.
>>>
>>> I'm also interested in whether we could add an UPGRADE_NOEXEC flag to
>>> how->upgrade_mask for the openat2(2) patchset (I reserved a flag bit fo=
r
>>> it, since I'd heard about this work through the grape-vine).
>>>
>>
>> I rather like the idea of having openat2 fds be non-executable by
>> default, and having userland request it specifically via O_MAYEXEC (or
>> some similar openat2 flag) if it's needed. Then you could add an
>> UPGRADE_EXEC flag instead?
>>
>> That seems like something reasonable to do with a brand new API, and
>> might be very helpful for preventing certain classes of attacks.
>>
>>
>
> There are at least four concepts of executability here:
>
> - Just check the file mode and any other relevant permissions. Return a n=
ormal fd.  Makes sense for script interpreters, perhaps.

This is the purpose of this patch series. It doesn't make sense to add
memory restrictions nor constrain fexecve and such.


>
> - Make the fd fexecve-able.
>
> - Make the resulting fd mappable PROT_EXEC.
>
> - Make the resulting fd upgradable.
>
> I=E2=80=99m not at all convinced that the kernel needs to distinguish all=
 these, but at least upgradability should be its own thing IMO.
>

--
Micka=C3=ABl Sala=C3=BCn

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
