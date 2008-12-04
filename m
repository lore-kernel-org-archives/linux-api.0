From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [RESEND][PATCH] Add /proc/mempool to display mempool usage
Date: Thu, 4 Dec 2008 11:02:31 -0500
Message-ID: <cfd18e0f0812040802m378ea52of906b4d1bb4401ed@mail.gmail.com>
References: <1227980689.6354.24.camel@localhost.localdomain>
	 <20081129214207.GA6747@x200.localdomain>
	 <20081129234907.GA2340@kroah.com>
	 <20081201101245.0a2f3123.randy.dunlap@oracle.com>
	 <1228158811.3196.88.camel@calx>
	 <20081201120210.1ed16bd5.akpm@linux-foundation.org>
	 <84144f020812011207q29fe4b3fq11a9e55f171cf743@mail.gmail.com>
	 <alpine.LFD.2.00.0812011210030.3256@nehalem.linux-foundation.org>
	 <84144f020812011402v3cb3ab24pf5cb6310f2d00c5b@mail.gmail.com>
	 <alpine.LFD.2.00.0812011843340.3256@nehalem.linux-foundation.org>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0812011843340.3256-nfNrOhbfy2R17+2ddN/4kux8cNe9sq/dYPYVAmT7z5s@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, remi.colinet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Dec 1, 2008 at 9:54 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
>
> On Tue, 2 Dec 2008, Pekka Enberg wrote:
>>
>> OK, but why do we have those different ABI "stages" in
>> Documentation/ABI then? The README file there seems to contradict what
>> you say. Or maybe I'm reading it wrong...
>
> I think that whole Documentation/ABI stuff is utter tosh, and should just
> be thrown out, whenever it talks about interfaces that are _not_ ABI's.
>
> IOW, it's fine to document things that are actually supposed to be stable,
> but:
>
>  - assuming that non-documentation means that it's not an ABI is bogus
>   and wrong.

Agreed.  (When so much is much is undocumented anyway, there is no way
that lack of documentation can be used to signal "this is not an ABI.)

>  - explicitly documenting something as "not an ABI" is wrongheaded and
>   stupid, because it's meaningless and only sets people up for being
>   disappointed later.

Agreed.

[...]

> Finally, when it comes to documentation as a bigger issue:
>
>  - wrong documentation is irrelevant. It doesn't matter if the
>   documentation says "X", when the code does "Y".
>
>   If people rely on "Y", then pointing at the docs and saying "but you
>   should never have relied on it, because teh docs say X" is totally and
>   utterly bogus. The _documentation_ was wrong. Don't ever use incorrect
>   documentation as an excuse.

Agreed.

> Too many people seem to think that documentation is the "final" argument.
> It's not. Not even close. It's a hint and a help, but it's _secondary_ to
> code. Anybody who doesn't understand that should never be allowed to write
> code (or documentation, for that matte).

While clearly documentation is not the final answer, I think you
undervalue it somewhat, and I think it's worth mentioning two specific
points.  Documentation may be secondary to code, but it can help a
lot, especially if:

* The documentation is done at the same time as the code (by the
developer, or by someone working with the developer).  This typically
makes the developer think more about the code they are writing.  It
also gives others to more quickly understand the code with the aim of
reviewing the code and/or API design, and perhaps testing it.  There
simply isn't enough review and testing going on, and documentation can
make a real difference there, IMO.

*  While the "but you should never have relied on it, because the docs
say X" argument may not hold, there is one important way that I think
documentation can still help: explicitly saying that "the behavior is
unspecified around point X, and other code should not rely on a
specific behavior".  This legitimately allows developers to change the
behavior around point X in the future.  (I made the point at LPC, if
you force users to read the code behind an API, then you end up
creating a "tight spec", since they will do exactly what the code
permits.  In this sense, documentation can be used to "loosen" the
spec.)

Cheers,

Michael




-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
