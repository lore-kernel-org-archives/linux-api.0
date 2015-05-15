From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Fri, 15 May 2015 09:31:27 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1505150921040.20285@gentwo.org>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Andrew Morton <akpm@linuxfoundation.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

It would be best to start a complete new thread about this. You
replied to earlier posts about ambient capabilities and
people may not see it as a new release.

> pA obeys the invariant that no bit can ever be set in pA if it is
> not set in both pP and pI.  Dropping a bit from pP or pI drops that
> bit from pA.  This ensures that existing programs that try to drop
> capabilities still do so, with a complication.  Because capability

Ok that is a good improvement.

> inheritance is so broken, setting KEEPCAPS, using setresuid to
> switch to nonroot uids, or calling execve effectively drops
> capabilities.  Therefore, setresuid from root to nonroot
> conditionally clears pA unless SECBIT_NO_SETUID_FIXUP is set.
> Processes that don't like this can re-add bits to pA afterwards.
>
> The capability evolution rules are changed:
>
>   pA' = (file caps or setuid or setgid ? 0 : pA)
>   pP' = (X & fP) | (pI & fI) | pA'
>   pI' = pI
>   pE' = (fE ? pP' : pA')

Isnt this equal to

    pE' = (fE & pP') | pA'

which does not require conditionals and is symmetric to how pP' is
calculated. Your formula seems to indicate that pA' bits are not set if
fE is set. However they are already set unconditionally in pP' regardless.
This makes it more explicit I think. And I thought we are dealing with
bitmask arithmetic here?


> If you are nonroot but you have a capability, you can add it to pA.
> If you do so, your children get that capability in pA, pP, and pE.
> For example, you can set pA = CAP_NET_BIND_SERVICE, and your
> children can automatically bind low-numbered ports.  Hallelujah!

I love this solution.

> [2] The libcap capability mask parsers and formatters are
> dangerously misleading and the documentation is flat-out wrong.  fE
> is *not* a mask; it's a single bit.  This has probably confused
> every single person who has tried to use file capabilities.

Hmmm... yes lets clean that up as well. Then your formula makes sense.

