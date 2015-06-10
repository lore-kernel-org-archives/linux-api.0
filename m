From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v3 1/2] capabilities: Ambient capabilities
Date: Wed, 10 Jun 2015 12:24:58 -0700
Message-ID: <CAGXu5jKLa1JtoSvoUTRPb02=NFh62Ge4oNSv=z=Z9q9SG62D6A@mail.gmail.com>
References: <cover.1432770087.git.luto@kernel.org>
	<eb28c29616751f0b17bfc1be7eae5bb718d58f9f.1432770087.git.luto@kernel.org>
	<CAGXu5j+Y85U9pjZUO0LM8rOO-YJrqvwzsXNjmaxN=D+JiQrpJw@mail.gmail.com>
	<CALCETrXz9e_PiAZaGRLuunyDu3-nRW_jopvvXcQwU3gN=sm_SA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXz9e_PiAZaGRLuunyDu3-nRW_jopvvXcQwU3gN=sm_SA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Andrew G. Morgan" <morgan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aaron Jones <aaronmdjones-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Markku Savela <msa-kXoF896ld44xHbG02/KK1g@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 9, 2015 at 5:00 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Tue, Jun 9, 2015 at 4:09 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>> On Wed, May 27, 2015 at 4:47 PM, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> [1] Files that are missing the "security.capability" xattr or that
>>> have unrecognized values for that xattr end up with has_cap set to
>>> false.  The code that does that appears to be complicated for no
>>> good reason.
>>
>> Would it make more sense to have has_cap true, but have it lack any actual caps?
>
> I assume you're referring to the case where we fail to parse the
> xattr.  If so, I don't really know if or when this happens.  Should
> that be addressed separately from this patch set?

No, no. All of these footnotes seem to be separate from the series. I
just wanted to chime in on them, since none of them really sounded
like they should get dropped.

>>> [2] The libcap capability mask parsers and formatters are
>>> dangerously misleading and the documentation is flat-out wrong.  fE
>>> is *not* a mask; it's a single bit.  This has probably confused
>>> every single person who has tried to use file capabilities.
>>
>> Sounds like it would be a valuable documentation patch.
>
> I'll try.  Let's get the current thing done first.

Yup! No worries. I'm happy to help with the docs, too.

>>> [3] Linux very confusingly processes both the script and the
>>> interpreter if applicable, for reasons that elude me.  The results
>>> from thinking about a script's file capabilities and/or setuid bits
>>> are mostly discarded.
>>
>> I wonder if this is important enough to fix?
>
> Not sure.
>
> However, the fact that AFAICT LSM due to a script (as opposed to an
> interpreter) is preserved sounds rather dangerous to me.  I'm not sure
> whether we can safely fix that at this point.

Agreed.

I missed adding:

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

I would love to use this already. :)

-Kees

-- 
Kees Cook
Chrome OS Security
