From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 13 Mar 2015 10:57:32 -0700
Message-ID: <CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
 <CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com>
 <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
 <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com> <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Linux API <linux-api@vger.kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Mar 13, 2015 6:24 AM, "Andrew G. Morgan" <morgan@kernel.org> wrote:
>
> > It's to preserve the invariant that pA is always a subset of pI.
>
> But since a user can always raise a bit in pI if it is present in pP,
> what does this invariant add to your model other than inconvenience?

The useful part is that dropping a bit from pI also drops it from pA.
To keep the model consistent, I also require that you add the bit to
pI before adding it to pA.

>
> >> I'm also unclear how you can turn off this new 'feature' for a process
> >> tree? As it is, the code creates an exploit path for a capable (pP !=
> >> 0) program with an exploitable flaw to create a privilege escalation
> >> for an arbitrary child program.
> >
> > Huh?  If you exploit the parent, you already win.  Yes, if a kiddie
> > injects shellcode that does system("/bin/bash") into some pP != 0
> > program, they don't actually elevate their privileges.  On the other
> > hand, by the time an attacker injected shellcode for:
> >
> > prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_SYS_ADMIN);
> > system("/bin/bash");
>
> Let's call the above two lines [a] and [b]. With this patch, you are
> encouraging folk to write programs that contain a line like [a]
> already. So, yes, I am saying that you are creating an exploitable
> path in these programs that says if someone can inject
> system("/bin/bash") into these programs they can get a new (because of
> this patch) privilege escalation.
>
> In the prevailing model, this kind of privilege escalation (resulting
> from naive inheritance) is designed out. I recognize that you want to
> add it back in, but I am concerned that you are not allowing for the
> possibility that some folk might still want to still be able to
> prevent it.

If you have a program that deliberately uses PR_CAP_AMBIENT, then
setting such a securebit will break the program, so it still doesn't
buy you anything.

>
> > into a target, they can already do whatever they want.
> >
> >> While I understand that everyone
> >> 'knows what they are doing' in implementing this change, I'm convinced
> >> that folk that are up to no good also do... Why not provide a lockable
> >> secure bit to selectively disable this support?
> >
> > Show me a legitimate use case and I'll gladly implement a secure bit.
>
> Thanks. I was kind of hoping that you would add a lockable secure bit
> that defaults this support to off, but can be used to turn it on with
> or without a lock. That way, you can avoid disturbing the legacy
> defaults (no surprises).

I think this thing needs to default on to be useful.

>
> > In the mean time, I don't even believe that there's a legitimate use
> > for any of the other secure bits (except keepcaps, and I don't know
> > why that's a securebit in the first place).
>
> Those bits currently make it possible to run a subsystem with no
> [set]uid-0 support in its process tree.

Not usefully, because even with all the securebits set to their
non-legacy modes, caps don't inherit, so it doesn't work.  I've tried.

>
> > In the mean time, see CVE-2014-3215 for an example of why securebits
> > are probably more trouble than they're worth.
>
> I think it is safe to say that naive privilege inheritance has a fair
> track record of being exploited orders of magnitude more frequently
> than this. After all, these are the reasons LD_PRELOAD and shell
> script setuid bits are suppressed.

I don't know what you mean here by naive privilege inheritance.  The
examples you're taking about aren't inheritance at all; they're
exploring privilege *grants* during execve.  My patch deliberately
leaves grants like that alone.

--Andy

>
> Cheers
>
> Andrew
