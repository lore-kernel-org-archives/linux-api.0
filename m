From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v3 1/2] capabilities: Ambient capabilities
Date: Tue, 9 Jun 2015 17:00:56 -0700
Message-ID: <CALCETrXz9e_PiAZaGRLuunyDu3-nRW_jopvvXcQwU3gN=sm_SA@mail.gmail.com>
References: <cover.1432770087.git.luto@kernel.org> <eb28c29616751f0b17bfc1be7eae5bb718d58f9f.1432770087.git.luto@kernel.org>
 <CAGXu5j+Y85U9pjZUO0LM8rOO-YJrqvwzsXNjmaxN=D+JiQrpJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+Y85U9pjZUO0LM8rOO-YJrqvwzsXNjmaxN=D+JiQrpJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 9, 2015 at 4:09 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Wed, May 27, 2015 at 4:47 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Credit where credit is due: this idea comes from Christoph Lameter
>> with a lot of valuable input from Serge Hallyn.  This patch is
>> heavily based on Christoph's patch.
>>
>> ===== The status quo =====
>>
>> On Linux, there are a number of capabilities defined by the kernel.
>> To perform various privileged tasks, processes can wield
>> capabilities that they hold.
>>
>> Each task has four capability masks: effective (pE), permitted (pP),
>> inheritable (pI), and a bounding set (X).  When the kernel checks
>> for a capability, it checks pE.  The other capability masks serve to
>> modify what capabilities can be in pE.
>>
>> Any task can remove capabilities from pE, pP, or pI at any time.  If
>> a task has a capability in pP, it can add that capability to pE
>> and/or pI.  If a task has CAP_SETPCAP, then it can add any
>> capability to pI, and it can remove capabilities from X.
>>
>> Tasks are not the only things that can have capabilities; files can
>> also have capabilities.  A file can have no capabilty information at
>> all [1].  If a file has capability information, then it has a
>> permitted mask (fP) and an inheritable mask (fI) as well as a single
>> effective bit (fE) [2].  File capabilities modify the capabilities
>> of tasks that execve(2) them.
>>
>> A task that successfully calls execve has its capabilities modified
>> for the file ultimately being excecuted (i.e. the binary itself if
>> that binary is ELF or for the interpreter if the binary is a
>> script.) [3] In the capability evolution rules, for each mask Z, pZ
>> represents the old value and pZ' represents the new value.  The
>> rules are:
>>
>>   pP' = (X & fP) | (pI & fI)
>>   pI' = pI
>>   pE' = (fE ? pP' : 0)
>>   X is unchanged
>>
>> For setuid binaries, fP, fI, and fE are modified by a moderately
>> complicated set of rules that emulate POSIX behavior.  Similarly, if
>> euid == 0 or ruid == 0, then fP, fI, and fE are modified differently
>> (primary, fP and fI usually end up being the full set).  For nonroot
>> users executing binaries with neither setuid nor file caps, fI and
>> fP are empty and fE is false.
>>
>> As an extra complication, if you execute a process as nonroot and fE
>> is set, then the "secure exec" rules are in effect: AT_SECURE gets
>> set, LD_PRELOAD doesn't work, etc.
>>
>> This is rather messy.  We've learned that making any changes is
>> dangerous, though: if a new kernel version allows an unprivileged
>> program to change its security state in a way that persists cross
>> execution of a setuid program or a program with file caps, this
>> persistent state is surprisingly likely to allow setuid or
>> file-capped programs to be exploited for privilege escalation.
>>
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
>>
>> This is a problem that has bitten many people who have tried to use
>> capabilities for anything useful.
>>
>> ===== The proposed change =====
>>
>> This patch adds a fifth capability mask called the ambient mask
>> (pA).  pA does what most people expect pI to do.
>>
>> pA obeys the invariant that no bit can ever be set in pA if it is
>> not set in both pP and pI.  Dropping a bit from pP or pI drops that
>> bit from pA.  This ensures that existing programs that try to drop
>> capabilities still do so, with a complication.  Because capability
>> inheritance is so broken, setting KEEPCAPS, using setresuid to
>> switch to nonroot uids, and then calling execve effectively drops
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
>
> Chrome OS could use this right now. :)
>
>> Unprivileged users can create user namespaces, map themselves to a
>> nonzero uid, and create both privileged (relative to their
>> namespace) and unprivileged process trees.  This is currently more
>> or less impossible.  Hallelujah!
>>
>> You cannot use pA to try to subvert a setuid, setgid, or file-capped
>> program: if you execute any such program, pA gets cleared and the
>> resulting evolution rules are unchanged by this patch.
>>
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
>> open question.)  I've therefore taken the more paranoid route.  We
>> can revisit this later.
>
> I think this is correct. Stuff using file caps, or set*id bits are
> fundamentally using a different privilege management model. Keeping pA
> separate makes a lot of sense to me.
>
>> An alternative would be to require PR_SET_NO_NEW_PRIVS before
>> setting ambient capabilities.  I think that this would be annoying
>> and would make granting otherwise unprivileged users minor ambient
>> capabilities (CAP_NET_BIND_SERVICE or CAP_NET_RAW for example) much
>> less useful than it is with this patch.
>
> Agreed: we should keep nnp out of this.
>
>> ===== Footnotes =====
>>
>> [1] Files that are missing the "security.capability" xattr or that
>> have unrecognized values for that xattr end up with has_cap set to
>> false.  The code that does that appears to be complicated for no
>> good reason.
>
> Would it make more sense to have has_cap true, but have it lack any actual caps?

I assume you're referring to the case where we fail to parse the
xattr.  If so, I don't really know if or when this happens.  Should
that be addressed separately from this patch set?

>
>> [2] The libcap capability mask parsers and formatters are
>> dangerously misleading and the documentation is flat-out wrong.  fE
>> is *not* a mask; it's a single bit.  This has probably confused
>> every single person who has tried to use file capabilities.
>
> Sounds like it would be a valuable documentation patch.

I'll try.  Let's get the current thing done first.

>
>> [3] Linux very confusingly processes both the script and the
>> interpreter if applicable, for reasons that elude me.  The results
>> from thinking about a script's file capabilities and/or setuid bits
>> are mostly discarded.
>
> I wonder if this is important enough to fix?

Not sure.

However, the fact that AFAICT LSM due to a script (as opposed to an
interpreter) is preserved sounds rather dangerous to me.  I'm not sure
whether we can safely fix that at this point.

--Andy
