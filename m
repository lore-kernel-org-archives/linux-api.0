From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC] capabilities: Ambient capabilities
Date: Fri, 13 Mar 2015 12:54:12 -0700
Message-ID: <CAGXu5jLj5M4FjhxqWy7Kg7qSXmBZ387f2DdwxRvioKaRJ9opXw@mail.gmail.com>
References: <933931146caf5dac58379f50c017bff9f6c47661.1426183417.git.luto@kernel.org>
	<CAGXu5jKfvswdUMcrGbr6+wn1ME_JkySMvdNd0wvvHpbQ1C7HUg@mail.gmail.com>
	<CALQRfL7b8CjYgUnVy3jykNwv48fOc03T385RKo--cfv25YenBg@mail.gmail.com>
	<CAObL_7HgU-ekb7mJS7C=0=idfrzV6=CSqTrG2LvUgdDtvbJx_w@mail.gmail.com>
	<CALQRfL6HUGMfPtsqLcSed8G14Yqg27R8tpDnMZOKtvQE+rqX0A@mail.gmail.com>
	<CALCETrVz39pJmMAEFodBNA8cOZjd0xkH95EzMazY0MWJDtpYgg@mail.gmail.com>
	<CAGXu5jLiLsXN2-RAbPJh7ZursuTroi5DAs=VTz2kyAZ2urNvgA@mail.gmail.com>
	<CALCETrV7vDJVhM_AgtGn8ENStcyxZBwCw3zhSn-whArT_XPg8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrV7vDJVhM_AgtGn8ENStcyxZBwCw3zhSn-whArT_XPg8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 13, 2015 at 12:03 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Fri, Mar 13, 2015 at 11:52 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>
>> All this said, almost half of the capabilities, if passed to flawed
>> children with attacker controlled execution, can be elevated to full
>> root privileges pretty easily[1], so I think any documentation around
>> this feature should include some pretty dire warnings about using
>> this.
>
> That's a good point.  I'll make sure to document that.
>
> It's worth noting that, for many applications, that list is
> overstated.  For example, many of the suggested privilege escalations
> don't work if you're in a sufficiently restrictive mount namespace.
>
> For my own use, I plan on adding only CAP_NET_BIND_SERVICE and
> CAP_NET_RAW to pA, and I'll be layering seccomp on top to the extent
> possible.

Right, keeping software authors aware of the fact that their efforts
for attack surface reducing may need additional confinement beyond
just the capability reduction.

-Kees

>
> --Andy
>
>>
>> -Kees
>>
>> [1] https://forums.grsecurity.net/viewtopic.php?f=7&t=2522
>>
>> --
>> Kees Cook
>> Chrome OS Security
>
>
>
> --
> Andy Lutomirski
> AMA Capital Management, LLC



-- 
Kees Cook
Chrome OS Security
