From: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 13 Mar 2015 06:24:28 -0700
Message-ID: <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
	<CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com>
	<CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
	<CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

> It's to preserve the invariant that pA is always a subset of pI.

But since a user can always raise a bit in pI if it is present in pP,
what does this invariant add to your model other than inconvenience?

>> I'm also unclear how you can turn off this new 'feature' for a process
>> tree? As it is, the code creates an exploit path for a capable (pP !=
>> 0) program with an exploitable flaw to create a privilege escalation
>> for an arbitrary child program.
>
> Huh?  If you exploit the parent, you already win.  Yes, if a kiddie
> injects shellcode that does system("/bin/bash") into some pP != 0
> program, they don't actually elevate their privileges.  On the other
> hand, by the time an attacker injected shellcode for:
>
> prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_SYS_ADMIN);
> system("/bin/bash");

Let's call the above two lines [a] and [b]. With this patch, you are
encouraging folk to write programs that contain a line like [a]
already. So, yes, I am saying that you are creating an exploitable
path in these programs that says if someone can inject
system("/bin/bash") into these programs they can get a new (because of
this patch) privilege escalation.

In the prevailing model, this kind of privilege escalation (resulting
from naive inheritance) is designed out. I recognize that you want to
add it back in, but I am concerned that you are not allowing for the
possibility that some folk might still want to still be able to
prevent it.

> into a target, they can already do whatever they want.
>
>> While I understand that everyone
>> 'knows what they are doing' in implementing this change, I'm convinced
>> that folk that are up to no good also do... Why not provide a lockable
>> secure bit to selectively disable this support?
>
> Show me a legitimate use case and I'll gladly implement a secure bit.

Thanks. I was kind of hoping that you would add a lockable secure bit
that defaults this support to off, but can be used to turn it on with
or without a lock. That way, you can avoid disturbing the legacy
defaults (no surprises).

> In the mean time, I don't even believe that there's a legitimate use
> for any of the other secure bits (except keepcaps, and I don't know
> why that's a securebit in the first place).

Those bits currently make it possible to run a subsystem with no
[set]uid-0 support in its process tree.

> In the mean time, see CVE-2014-3215 for an example of why securebits
> are probably more trouble than they're worth.

I think it is safe to say that naive privilege inheritance has a fair
track record of being exploited orders of magnitude more frequently
than this. After all, these are the reasons LD_PRELOAD and shell
script setuid bits are suppressed.

Cheers

Andrew
