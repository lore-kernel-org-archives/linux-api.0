From: Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Thu, 12 Mar 2015 15:27:07 -0700
Message-ID: <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
 <CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com> <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Mar 12, 2015 at 3:10 PM, Andrew G. Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> I'm unclear why you refer to the inheritable set in this test:
>
> +               } else {
> +                       if (arg2 == PR_CAP_AMBIENT_RAISE &&
> +                           (!cap_raised(current_cred()->cap_permitted, arg3) ||
> +                            !cap_raised(current_cred()->cap_inheritable,
> +                                        arg3)))
> +                               return -EPERM;

It's to preserve the invariant that pA is always a subset of pI.

>
> I'm also unclear how you can turn off this new 'feature' for a process
> tree? As it is, the code creates an exploit path for a capable (pP !=
> 0) program with an exploitable flaw to create a privilege escalation
> for an arbitrary child program.

Huh?  If you exploit the parent, you already win.  Yes, if a kiddie
injects shellcode that does system("/bin/bash") into some pP != 0
program, they don't actually elevate their privileges.  On the other
hand, by the time an attacker injected shellcode for:

prctl(PR_CAP_AMBIENT, PR_CAP_AMBIENT_RAISE, CAP_SYS_ADMIN);
system("/bin/bash");

into a target, they can already do whatever they want.

> While I understand that everyone
> 'knows what they are doing' in implementing this change, I'm convinced
> that folk that are up to no good also do... Why not provide a lockable
> secure bit to selectively disable this support?

Show me a legitimate use case and I'll gladly implement a secure bit.
In the mean time, I don't even believe that there's a legitimate use
for any of the other secure bits (except keepcaps, and I don't know
why that's a securebit in the first place).

In the mean time, see CVE-2014-3215 for an example of why securebits
are probably more trouble than they're worth.

--Andy
