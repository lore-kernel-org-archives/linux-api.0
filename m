From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 13 Mar 2015 11:52:31 -0700
Message-ID: <CAGXu5jLiLsXN2-RAbPJh7ZursuTroi5DAs=VTz2kyAZ2urNvgA@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
	<CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com>
	<CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
	<CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com>
	<CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
	<CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 10:57 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Mar 13, 2015 6:24 AM, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> I think it is safe to say that naive privilege inheritance has a fair
>> track record of being exploited orders of magnitude more frequently
>> than this. After all, these are the reasons LD_PRELOAD and shell
>> script setuid bits are suppressed.
>
> I don't know what you mean here by naive privilege inheritance.  The
> examples you're taking about aren't inheritance at all; they're
> exploring privilege *grants* during execve.  My patch deliberately
> leaves grants like that alone.

Just to clarify (at least for myself), I think the issue here is the
perception of privileges leaking into newly execed processes that may
have flaws that allow arbitrary execution control.

Case A: daemon is running (with whatever set of privileges), has a
flaw and an attacker now has those same privileges.

Case B: running as root, runs some child (which stays root) with a
flaw and an attacker now has root privileges.

Case C: running with pE=CAP_NET_ADMIN, runs some child (which loses
the cap) with a flaw and an attacker now has only user privileges.

Case D: running with pE=pI=CAP_NET_ADMIN, runs some child that has
fI=CAP_NET_ADMIN, but other children don't and lose the cap as in case
C. The privileged attack surface is reduced to only the child with fI
set.

Case E: running with CAP_NET_ADMIN in pA, runs some child (which gets
pE=pA=CAP_NET_ADMIN), and has an attack surface larger (all children)
than Case D, but with a scope smaller (only CAP_NET_ADMIN) than Case
B.

We don't need to talk about Case A, since we're not crossing an exec
boundary and the attacker already has execution control. We all lose.

Case B is the poster-child for "don't run daemons as root", since
privileges aren't dropped, and we're basically back to Case A again.

Case C is the classic "just give the daemon what caps it needs" case,
and if the daemon itself isn't flawed (Case A), then the privileges
don't leak out to any children (usually helpers of some kind) since
the cap doesn't cross the exec boundary. This lack of leaking is
really frustrating for daemons that need to give caps to helpers (e.g.
containers).

Case D is the standard solution to the frustrations in Case C, but
requires filesystem capabilities (and/or SELinux) to pass
capabilities, and comes with various limitations as described in
Andy's first email.

Case E would be possible with Andy's patch. It lacks the limitations
and frustrations of C and D, but opens us up to a limited version of
the risks in Case B. So, I don't think it's as "bad" as Case B since a
process must opt into it (by setting pA), and it passes only the
limited set of capabilities.

I think this boils down to accepting the elevated risk while
recognizing that it may be less than Case B but greater than Case C.

All this said, almost half of the capabilities, if passed to flawed
children with attacker controlled execution, can be elevated to full
root privileges pretty easily[1], so I think any documentation around
this feature should include some pretty dire warnings about using
this.

-Kees

[1] https://forums.grsecurity.net/viewtopic.php?f=7&t=2522

-- 
Kees Cook
Chrome OS Security
