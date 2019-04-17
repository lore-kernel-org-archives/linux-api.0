From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Subject: Re: [RFC PATCH v1 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Wed, 17 Apr 2019 16:55:31 +0200
Message-ID: <55d06e21-9a38-1297-615c-bc1e6e9f33ef@ssi.gouv.fr>
References: <20181212081712.32347-1-mic@digikod.net>
 <20181212081712.32347-2-mic@digikod.net>
 <20181212144306.GA19945@quack2.suse.cz> <3452959.b6JmBh7Lnt@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <kernel-hardening-return-15668-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <3452959.b6JmBh7Lnt@x2>
Content-Language: en-US
To: Steve Grubb <sgrubb@redhat.com>, Jan Kara <jack@suse.cz>
Cc: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Matthew Bobrowski <mbobrowski@mbobrowski.org>, Florian Weimer <fweimer@redhat.com>
List-Id: linux-api@vger.kernel.org


On 15/04/2019 20:47, Steve Grubb wrote:
> Hello,
>
> On Wednesday, December 12, 2018 9:43:06 AM EDT Jan Kara wrote:
>> On Wed 12-12-18 09:17:08, Micka=C3=ABl Sala=C3=BCn wrote:
>>> When the O_MAYEXEC flag is passed, sys_open() may be subject to
>>> additional restrictions depending on a security policy implemented by a=
n
>>> LSM through the inode_permission hook.
>>>
>>> The underlying idea is to be able to restrict scripts interpretation
>>> according to a policy defined by the system administrator.  For this to
>>> be possible, script interpreters must use the O_MAYEXEC flag
>>> appropriately.  To be fully effective, these interpreters also need to
>>> handle the other ways to execute code (for which the kernel can't help)=
:
>>> command line parameters (e.g., option -e for Perl), module loading
>>> (e.g., option -m for Python), stdin, file sourcing, environment
>>> variables, configuration files...  According to the threat model, it ma=
y
>>> be acceptable to allow some script interpreters (e.g. Bash) to interpre=
t
>>> commands from stdin, may it be a TTY or a pipe, because it may not be
>>> enough to (directly) perform syscalls.
>>>
>>> A simple security policy implementation is available in a following
>>> patch for Yama.
>>>
>>> This is an updated subset of the patch initially written by Vincent
>>> Strubel for CLIP OS:
>>> https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb33=
0d
>>> 6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch This patch has
>>> been used for more than 10 years with customized script interpreters.
>>> Some examples can be found here:
>>> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=3DO_=
MAYE
>>> XEC
>>>
>>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>> Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
>>> Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
>>> Reviewed-by: Philippe Tr=C3=A9buchet <philippe.trebuchet@ssi.gouv.fr>
>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> Cc: Micka=C3=ABl Sala=C3=BCn <mickael.salaun@ssi.gouv.fr>
>>
>> ...
>>
>>> diff --git a/fs/open.c b/fs/open.c
>>> index 0285ce7dbd51..75479b79a58f 100644
>>> --- a/fs/open.c
>>> +++ b/fs/open.c
>>> @@ -974,6 +974,10 @@ static inline int build_open_flags(int flags,
>>> umode_t mode, struct open_flags *o>
>>>     if (flags & O_APPEND)
>>>
>>>             acc_mode |=3D MAY_APPEND;
>>>
>>> +   /* Check execution permissions on open. */
>>> +   if (flags & O_MAYEXEC)
>>> +           acc_mode |=3D MAY_OPENEXEC;
>>> +
>>>
>>>     op->acc_mode =3D acc_mode;
>>>
>>>     op->intent =3D flags & O_PATH ? 0 : LOOKUP_OPEN;
>>
>> I don't feel experienced enough in security to tell whether we want this
>> functionality or not. But if we do this, shouldn't we also set FMODE_EXE=
C
>> on the resulting struct file? That way also security_file_open() can be
>> used to arbitrate such executable opens and in particular
>> fanotify permission event FAN_OPEN_EXEC will get properly generated whic=
h I
>> guess is desirable (support for it is sitting in my tree waiting for the
>> merge window) - adding some audit people involved in FAN_OPEN_EXEC to CC=
.
>> Just an idea...
>
> Late in replying. But I think it's important to have a deep look into the
> issue.
>
> TL;DR - This is a gentle man's handshake. It won't _really_ solve the
> problem.

Thanks for your comments. You should find most answers in this thread:
https://lore.kernel.org/lkml/20181212081712.32347-4-mic@digikod.net/

The threat model targets persistent attacks. This O_MAYEXEC flag is not
a silver bullet but it's a needed block to enforce a security policy on
a trusted system. This means that every component executable on the
system must be controlled, which means they may need some bit of
customization. Today no userspace application use this flag (except in
CLIP OS), but we need to first create a feature before it can be used.

It is very important to have in mind that a system security policy need
to have a (central) security manager, in this case the kernel thanks to
Yama's policy (but it could be SELinux, IMA or any other LSM). The goal
is not to give to the developer the job of defining a security policy
for the *system*; this job is for the system administrator (or the distro).

>
> This flag that is being proposed means that you would have to patch all
> interpreters to use it. If you are sure that upstreams will accept that, =
why
> not just change the policy to interpreters shouldn't execute anything unl=
ess
> the execute bit is set? That is simpler and doesn't need a kernel change.=
 And
> setting the execute bit is an auditable event.

As said above, the definition of a the security policy is the job of the
system administrator. Moreover, the security policy may be defined by
the mount point restrictions (i.e. noexec) but it should be definable
with something else (e.g. a SELinux or IMA policy which may be agnostic
to the mount points).

>
> The bottom line is that any interpreter has to become a security policy
> enforcement point whether by indicating it wants to execute by setting a =
flag
> or by refusing to use a file without execute bit set. But this just moves=
 the
> problem to one that is harder to fix. Why in the world does any programmi=
ng
> language allow programs to be loaded via stdin?
>
> It is possible to wget a program and pipe it into python which subsequent=
ly
> pulls down an ELF shared object and runs it all without touching disk via
> memfd_create (e.g. SnakeEater). This is all direct to memory execution. A=
nd
> direct to memory bypasses anti-virus, selinux, IMA, application whitelist=
ing,
> and other integrity schemes.
>
> So, to fix this problem, you really need to not allow any programs to loa=
d via
> stdin so that everything that executes has to touch disk. This way you ca=
n
> get a fanotify event and see the application and vote yes/no on allowing =
it.
> And this will be particularly harder with the memfd_create fix for the ru=
nc
> container breakout. Prior to that, there were very few uses of that syste=
m
> call. Now it may be very common which means finding malicious use just go=
t
> harder to spot.

As said above, stdin must be restricted in some way. You may want to
take a look at the CLIP OS patches (which doesn't only add the O_MAYEXEC
flag but restrict other way to interpret code). It may be foolish to
block or restrict stdin for interpreters on a developer workstation, but
it may make sense for an embedded custom system.

The same apply for memfd_create. If you want to enforce a security
policy on this kind of *file descriptor*, you should ask to the proper
LSM to do so. The current Yama patch deal with this kind of FD if they
are accessed through /proc/*/fd because the procfs is mounted with
noexec. Anyway, the interpreter must *inform* the LSM that it wants to
execute/interpret something from this FD, which is done thanks to the
O_MAYEXEC flag.

>
> But assuming these problems got fixed, then we have yet another place to =
look.
> Many interpreters allow you to specify a command to run via arguments. So=
me
> have a small buffer and some allow lengthy programs to be entered as an
> argument. One strategy might be that an attacker can bootstrap a lengthie=
r
> program across the network. Python for example allows loading modules acr=
oss
> a network. All you need to put in the commandline is the override for the
> module loader and a couple modules to import. It then loads the modules
> remotely. Getting rid of this hole will likely lead to some unhappy peopl=
e -
> meaning it can't be fixed.

Again, this depend on the threat model and the corresponding product. If
you want to handle everything on your system, then you may need some
adjustments.

>
> And even if we get that fixed, we have one last hole to plug. Shells. One=
 can
> simply start a shell and paste their program into the shell and then exec=
ute
> it. You can easily do this with bash or python or any language that has a
> REPL (read=E2=80=93eval=E2=80=93print loop). To fix this means divorcing =
the notion of a
> language from a REPL. Production systems really do not need a Python shel=
l,
> they need the interpreter. I doubt that this would be popular. But fixing=
 each
> of these issues is what it would take to prevent unknown software from
> running. Not going this far leaves holes.

This is also covered by the threat model defined in the patch 3/5 (i.e.
protect the kernel by restricting arbitrary syscalls).

Regards,

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
