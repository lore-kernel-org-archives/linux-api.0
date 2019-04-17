From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Wed, 17 Apr 2019 17:04:41 +0200
Message-ID: <7da3a491-232a-5a02-63a2-65aa9df413ea@ssi.gouv.fr>
References: <20181212081712.32347-1-mic@digikod.net> <3452959.b6JmBh7Lnt@x2>
 <87wojuxj8s.fsf@oldenburg2.str.redhat.com> <2361288.r9sZr2NHLB@x2>
 <875zrd7xy8.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <875zrd7xy8.fsf@oldenburg2.str.redhat.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, Steve Grubb <sgrubb@redhat.com>
Cc: Jan Kara <jack@suse.cz>, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.orgMatt
List-Id: linux-api@vger.kernel.org


On 17/04/2019 12:01, Florian Weimer wrote:
> * Steve Grubb:
>
>> On Tuesday, April 16, 2019 7:49:39 AM EDT Florian Weimer wrote:
>>> * Steve Grubb:
>>>> This flag that is being proposed means that you would have to patch al=
l
>>>> interpreters to use it. If you are sure that upstreams will accept tha=
t,
>>>> why not just change the policy to interpreters shouldn't execute
>>>> anything unless the execute bit is set? That is simpler and doesn't ne=
ed
>>>> a kernel change. And setting the execute bit is an auditable event.
>>>
>>> I think we need something like O_MAYEXEC so that security policies can
>>> be enforced and noexec mounts can be detected.
>>
>> Application whitelisting can already today stop unknown software without
>> needing O_MAYEXEC.

Whitelisting may be a lot of thing (path/TPE, signed binaries=E2=80=A6), bu=
t
being able to handle this with a global system configuration (instead of
app-specific hardcoded configuration) is a good idea. ;)

>
> I'm somewhat interested in using this to add a proper check for
> executability to explicit dynamic loader invocations.  In other words,
> this
>
>   /lib64/ld-linux-x86-64.so.2 /path/to/noexec/fs/program
>
> should refuse to run the program if the program is located on a file
> system mounted with the noexec attribute.

What if a sysadmin need to do this on an executable mount point? Being
able to enforce a security policy according to a configuration may fit
to much more use cases.

>
>> The problem is that passing O_MAYEXEC is opt-in. You can use ptrace/secc=
omp/
>> bpf/LD_PRELOAD/LD_AUDIT to remove that bit from an otherwise normal prog=
ram.
>> This does not require privs to do so.
>
> That doesn't really help with the above.

Right, ptrace/LD_PRELOAD and so on must be addressed by something else
than only O_MAYEXEC.

>
>> But let's consider that this comes to pass and every interpreter is
>> updated and IMA can see the O_MAYEXEC flag. Attackers now simply pivot
>> to running programs via stdin. It never touches disk and therefore
>> nothing enforces security policy. This already is among the most
>> common ways that malware runs today to evade detection.

As my previous reply, use cases like stdin may be restricted as well.

>
> Are you referring to Windows malware using Powershell?
>
> I'm not sure this is applicable to Linux.  We do not have much
> behavioral monitoring anyway.
>
> Thanks,
> Florian
>

--
Micka=C3=ABl Sala=C3=BCn
ANSSI/SDE/ST/LAM

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
