From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 1/2] capabilities: Ambient capabilities
Date: Wed, 27 May 2015 15:44:44 -0700
Message-ID: <CALCETrUwi-_q2GzYquKG4u5K=Zm+9X57C4vStSPFRAtwBHi9uA@mail.gmail.com>
References: <cover.1431671529.git.luto@kernel.org> <cc4749638a21079cce12f9f30c806170558e56e5.1431671529.git.luto@kernel.org>
 <20150523193705.GA30563@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150523193705.GA30563-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, May 23, 2015 at 12:37 PM, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> Thanks very much, Andy.  Comments and ack below.
>
> Quoting Andy Lutomirski (luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
>> ===== The problem =====
>>
>> Capability inheritance is basically useless.
>>
>> If you aren't root and you execute an ordinary binary, fI is zero,
>> so your capabilities have no effect whatsoever on pP'.  This means
>> that you can't usefully execute a helper process or a shell command
>> with elevated capabilities if you aren't root.
>>
>> On current kernels, you can sort of work around this by setting fI
>> to the full set for most or all non-setuid executable files.  This
>> causes pP' = pI for nonroot, and inheritance works.  No one does
>> this because it's a PITA and it isn't even supported on most
>> filesystems.
>>
>> If you try this, you'll discover that every nonroot program ends up
>> with secure exec rules, breaking many things.
>
> PI would have worked great if most programs wanting privilege were
> self-contained and compiled.  Shell scripts and lots of fork+execing
> make pI [much less useful] [completely useless].  See also golang's
> predisposition to fork+exec.

Agreed.

>
>> This is a problem that has bitten many people who have tried to use
>> capabilities for anything useful.
>>
>> ===== The proposed change =====
>>
>> This patch adds a fifth capability mask called the ambient mask
>> (pA).  pA does what pI should have done.
>
> Or at least what most people want it to do.
>
>> pA obeys the invariant that no bit can ever be set in pA if it is
>> not set in both pP and pI.  Dropping a bit from pP or pI drops that
>> bit from pA.  This ensures that existing programs that try to drop
>> capabilities still do so, with a complication.  Because capability
>> inheritance is so broken, setting KEEPCAPS, using setresuid to
>
> Sorry, did you mean "... setting KEEPCAPS and then either using
> setresuid to a nonroot uid or calling execve ..." ?

So, I actually meant:

Because capability inheritance is so broken, setting KEEPCAPS, using
setresuid to switch to nonroot uids, and then calling execve
effectively drops capabilities.

Fixed.

>
>> switch to nonroot uids, or calling execve effectively drops
>> capabilities.  Therefore, setresuid from root to nonroot
>> conditionally clears pA unless SECBIT_NO_SETUID_FIXUP is set.
>> Processes that don't like this can re-add bits to pA afterwards.
>>
>> The capability evolution rules are changed:
>>
>>   pA' = (file caps or setuid or setgid ? 0 : pA)
>>   pP' = (X & fP) | (pI & fI) | pA'
>>   pI' = pI
>>   pE' = (fE ? pP' : pA')
>>   X is unchanged
>>
>> If you are nonroot but you have a capability, you can add it to pA.
>> If you do so, your children get that capability in pA, pP, and pE.
>> For example, you can set pA = CAP_NET_BIND_SERVICE, and your
>> children can automatically bind low-numbered ports.  Hallelujah!
>>
>> Unprivileged users can create user namespaces, map themselves to a
>> nonzero uid, and create both privileged (relative to their
>> namespace) and unprivileged process trees.  This is currently more
>> or less impossible.  Hallelujah!
>>
>> You cannot use pA to try to subvert a setuid, setgid, or file-capped
>> program: if you execute any such program, pA gets cleared and the
>> resulting evolution rules are unchanged by this patch.
>
> Christoph, just to be sure, is this ^ going to suffice for you?
>
> Seems like it should since any program which is setuid-root, i.e.
> passwd, isn't likely to be designed to exec other programs.
>
>> Users with nonzero pA are unlikely to unintentionally leak that
>> capability.  If they run programs that try to drop privileges,
>> dropping privileges will still work.
>>
>> It's worth noting that the degree of paranoia in this patch could
>> possibly be reduced without causing serious problems.  Specifically,
>> if we allowed pA to persist across executing non-pA-aware setuid
>> binaries and across setresuid, then, naively, the only capabilities
>> that could leak as a result would be the capabilities in pA, and any
>> attacker *already* has those capabilities.  This would make me
>> nervous, though -- setuid binaries that tried to privilege-separate
>> might fail to do so, and putting CAP_DAC_READ_SEARCH or
>> CAP_DAC_OVERRIDE into pA could have unexpected side effects.
>> (Whether these unexpected side effects would be exploitable is an
>> open question.)  I've therefore taken the more paranoid route.
>
> I'm definitely open to revisiting this question after the current
> patch has been in use for awhile.

Noted in the changelog for v3.

>
>> An alternative would be to require PR_SET_NO_NEW_PRIVS before
>> setting ambient capabilities.  I think that this would be annoying
>> and would make granting otherwise unprivileged users minor ambient
>> capabilities (CAP_NET_BIND_SERVICE or CAP_NET_RAW for example) much
>> less useful than it is with this patch.
>>
>> ===== Footnotes =====
>>
>> [1] Files that are missing the "security.capability" xattr or that
>> have unrecognized values for that xattr end up with has_cap set to
>> false.  The code that does that appears to be complicated for no
>> good reason.
>>
>> [2] The libcap capability mask parsers and formatters are
>> dangerously misleading and the documentation is flat-out wrong.  fE
>> is *not* a mask; it's a single bit.  This has probably confused
>> every single person who has tried to use file capabilities.
>>
>> [3] Linux very confusingly processes both the script and the
>> interpreter if applicable, for reasons that elude me.  The results
>> from thinking about a script's file capabilities and/or setuid bits
>> are mostly discarded.
>
> Not quite sure what you mean here - setuid and fX are ignored on
> shell scripts, but I think you're saying something less simple is
> going on?

I think that's the effect.  What I mean is that, when running a
script, prepare_binprm and hence cap_bprm_set_creds is called twice:
once from do_execveat_common and once from load_script.

Thanks,
Andy
