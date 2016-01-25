From: Jann Horn <jannhorn@googlemail.com>
Subject: RE: [RFC PATCH 1/1] seccomp: provide information
 about the previous syscall
Date: Mon, 25 Jan 2016 12:51:55 +0100
Message-ID: <CAK9i0=pYOy10u=f8AcY9NeATuVB-WRjFhPxZx9=6uncNga0pog@mail.gmail.com>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
	<1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
	<20160122104837.GA14440@pc.thejh.net>
	<001701d15721$fb9888b0$f2c99a10$@toshiba.co.jp>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a113ee6700e3d04052a27324c
Return-path: <kernel-hardening-return-2464-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <001701d15721$fb9888b0$f2c99a10$@toshiba.co.jp>
To: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Cc: linux-kernel@vger.kernel.org, wad@chromium.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Paul Moore <paul@paul-moore.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

--001a113ee6700e3d04052a27324c
Content-Type: text/plain; charset=UTF-8

Am 25.01.2016 4:40 vorm. schrieb "Daniel Sangorrin" <
daniel.sangorrin@toshiba.co.jp>:
> There were a few important points that I didn't mention but are critical
to understand
> what I was trying to do.  The focus of the patch was on protecting
"real-time
> embedded IoT devices" such as a PLC (programmable logic controller)
inside a factory
> assembly line .
>
> They have a few important properties that I took into consideration:
[...]
>     - Mimicry: as I mentioned in the cover letter (and Jann showed with
>        his ROP attack) if the attacker is able to emulate the system
call's order
>        (plus its arguments  and the address from which the call was made)
>        this patch can be bypassed. However, note that this is not easy
for several
>        reasons:
>                + the attacker may need a long stack to mimic all the
system calls and their
>                    arguments.

Note that in a ROP attack, the attacker will often set up his own stack
anyway, so I'm not sure how much of a constraint a short stack really is.

>                + the stealthy attacker must make sure the real-time
application does not
>                    crash, miss any of its deadlines or cause deadline
misses in other apps
>                    [Note] Real-time application binaries are usually
closed source so
>                     this might require quite a bit of effort.
>                + randomized system calls: applications could randomly
activate dummy
>                    system calls each time they are instantiated (and
adjust their BPF filter,
>                    which should later be zeroed).  In this case, the
attacker (or virus)
>                    would need to figure out which dummy system calls have
to
>                    be mimicked and prepare a stack accordingly. This
seems challenging.
>                    [Note] under a brute force attack, the application may
just raise an alarm,
>                     activate a redundant node (not connected to the
network) and
>                     commit digital suicide :).
>
> About the ABI, by all means I don't want to break it. If putting the
field at
> the end does not break it, as Alexei mentioned, I can change it. Also I
would
> be glad to review the SECCOMP_FILTER_FLAG_TSYNC flag mentioned by Jann
> in case there is any interest.
>
> However, I'll understand the NACK if you think that the maintenance is
not worth it
> as Andy mentioned; that it can be bypassed under certain conditions; or
the fact
> that it focuses on a particular type of systems. I will keep reading the
> messages in the kernel-hardening list and see if I find another topic to
> contribute :).

You might want to look into CFI (control flow integrity) - that's probably
a much stronger mitigation than this, and it does not require kernel
support. It also works by verifying transitions, but it checks transitions
of userspace code instead of syscall transitions.

--001a113ee6700e3d04052a27324c
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Am 25.01.2016 4:40 vorm. schrieb &quot;Daniel Sangorrin&quot=
; &lt;<a href=3D"mailto:daniel.sangorrin@toshiba.co.jp">daniel.sangorrin@to=
shiba.co.jp</a>&gt;:<br>
&gt; There were a few important points that I didn&#39;t mention but are cr=
itical to understand<br>
&gt; what I was trying to do.=C2=A0 The focus of the patch was on protectin=
g &quot;real-time<br>
&gt; embedded IoT devices&quot; such as a PLC (programmable logic controlle=
r) inside a factory<br>
&gt; assembly line .<br>
&gt;<br>
&gt; They have a few important properties that I took into consideration:<b=
r>
[...]<br>
&gt; =C2=A0 =C2=A0 - Mimicry: as I mentioned in the cover letter (and Jann =
showed with<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0his ROP attack) if the attacker is able to =
emulate the system call&#39;s order<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0(plus its arguments=C2=A0 and the address f=
rom which the call was made)<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0this patch can be bypassed. However, note t=
hat this is not easy for several<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0reasons:<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+ the attacker =
may need a long stack to mimic all the system calls and their<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0a=
rguments.</p>
<p dir=3D"ltr">Note that in a ROP attack, the attacker will often set up hi=
s own stack anyway, so I&#39;m not sure how much of a constraint a short st=
ack really is.<br></p>
<p dir=3D"ltr">&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
+ the stealthy attacker must make sure the real-time application does not<b=
r>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c=
rash, miss any of its deadlines or cause deadline misses in other apps<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[=
Note] Real-time application binaries are usually closed source so<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
this might require quite a bit of effort.<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+ randomized sy=
stem calls: applications could randomly activate dummy<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0s=
ystem calls each time they are instantiated (and adjust their BPF filter,<b=
r>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
hich should later be zeroed).=C2=A0 In this case, the attacker (or virus)<b=
r>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0w=
ould need to figure out which dummy system calls have to<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0b=
e mimicked and prepare a stack accordingly. This seems challenging.<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[=
Note] under a brute force attack, the application may just raise an alarm,<=
br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
activate a redundant node (not connected to the network) and<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
commit digital suicide :).<br>
&gt;<br>
&gt; About the ABI, by all means I don&#39;t want to break it. If putting t=
he field at<br>
&gt; the end does not break it, as Alexei mentioned, I can change it. Also =
I would<br>
&gt; be glad to review the SECCOMP_FILTER_FLAG_TSYNC flag mentioned by Jann=
<br>
&gt; in case there is any interest.<br>
&gt;<br>
&gt; However, I&#39;ll understand the NACK if you think that the maintenanc=
e is not worth it<br>
&gt; as Andy mentioned; that it can be bypassed under certain conditions; o=
r the fact<br>
&gt; that it focuses on a particular type of systems. I will keep reading t=
he<br>
&gt; messages in the kernel-hardening list and see if I find another topic =
to<br>
&gt; contribute :).</p>
<p dir=3D"ltr">You might want to look into CFI (control flow integrity) - t=
hat&#39;s probably a much stronger mitigation than this, and it does not re=
quire kernel support. It also works by verifying transitions, but it checks=
 transitions of userspace code instead of syscall transitions.</p>

--001a113ee6700e3d04052a27324c--
