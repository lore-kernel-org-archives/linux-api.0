From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Sat, 14 Mar 2015 15:53:27 -0700
Message-ID: <CALCETrXC7oZnbXas10gat2MCZGFQfNchSeCaZTMRvq5NoPLZHw@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
 <CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com>
 <CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
 <CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com>
 <CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
 <CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg@mail.gmail.com>
 <CALQRfL5FGGUnK7+Ss=MSDGmxpAERTUjezardGnH3QouBwhbZ4A@mail.gmail.com>
 <CALCETrUGASa3Gp6cC1zdAahcS59DOdyLnTtgNX7t7FucMZLmoQ@mail.gmail.com> <CALQRfL6z2dEtPkWiuGydT0a+y4iWm2qw-cY0Rk9hA-K4gPw_qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALQRfL6z2dEtPkWiuGydT0a+y4iWm2qw-cY0Rk9hA-K4gPw_qA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Mar 14, 2015 at 3:17 PM, Andrew G. Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Sat, Mar 14, 2015 at 2:45 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Sat, Mar 14, 2015 at 2:09 PM, Andrew G. Morgan <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> On Fri, Mar 13, 2015 at 10:57 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>>>> On Mar 13, 2015 6:24 AM, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>>>
>>>>> > It's to preserve the invariant that pA is always a subset of pI.
>>>>>
>>>>> But since a user can always raise a bit in pI if it is present in pP,
>>>>> what does this invariant add to your model other than inconvenience?
>>>>
>>>> The useful part is that dropping a bit from pI also drops it from pA.
>>>> To keep the model consistent, I also require that you add the bit to
>>>> pI before adding it to pA.
>>>
>>> So you are saying that pA is always a strict subset of pI (and pP)?
>>> Then why not explicitly implement it as:
>>>
>>>   pA' = (file caps or setuid or setgid ? 0 : pA)
>>>   pP' = (fP & X) | (pI & [fI | (pA' & pP)] )
>>>
>>> As it is you have so distributed these constraints that it is hard to
>>> be sure it will remain that way.
>>
>> That would be insecure.  If an attacker had pA = CAP_SYS_ADMIN, pI =
>> 0, pP = 0 (i.e. no privs but pA is set somehow) then, unless that's
>> there's some other protection implemented, they could run some setuid
>> program, and that program could switch back to non-root, set pI = 0,
>> and call execve.  Unexpectedly, CAP_SYS_ADMIN would be inherited.
>
> Forgive me, but which bit of
>
>    pI & [fI | (pA' & pP)]
>
> with pI = 0 makes that so?

Oh, I misread that.

I think it's already unnecessarily confusing that you can inherit
nonzero pI without inheriting the corresponding bits in pP, and I
don't want to add yet more degrees of freedom in non-permitted caps.

>>>>
>>>> I don't know what you mean here by naive privilege inheritance.  The
>>>> examples you're taking about aren't inheritance at all; they're
>>>> exploring privilege *grants* during execve.  My patch deliberately
>>>> leaves grants like that alone.
>>>
>>> The pI set is inherited through this exec unmolested.
>>
>> This is flat-out useless.  Having pI = CAP_NET_BIND_SERVICE doesn't
>> let me bind low-numbered ports, full stop.
>
> Even in your proposed model, neither pI nor pA does this. It is what
> is in pE that counts.

Let me state it more precisely.  If your parent puts
CAP_NET_BIND_SERVICE in pI and execs you, you can't bind low-numbered
ports.  If your parent puts CAP_NET_BIND_SERVICE in pA, you can.

>
>>> My Nack remains that you are eliminating the explicit enforcement of
>>> selective inheritance. A lockable secure bit protecting access to your
>>> prctl() function would address this concern.
>>
>> Would a sysctl or securebit that *optionally* allows pA to be disabled
>> satisfy you?
>>
>> I don't understand why lockable is at all useful.  You'd need
>> CAP_SETPCAP to flip it regardless.
>
> Because it means one can create process trees in which this behavior
> is guaranteed to be allowed and/or disallowed.
>

I don't see why guaranteeing that it's allowed is particularly useful.
I also don't see why any of the securebits lock bits are useful.  I
don't specifically object; I just don't see the point.  If you give a
subtree CAP_SETPCAP but you don't trust them enough to leave
securebits unlocked, then I think your threat model is confused.

--Andy
