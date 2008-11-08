From: "Robert Love" <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [1/1] Use pid in inotify events.
Date: Sat, 8 Nov 2008 12:04:40 -0500
Message-ID: <acdcfe7e0811080904y7eb461d3n70b0765d8b1e9011@mail.gmail.com>
References: <20081108114225.GA22674@ioremap.net>
	 <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
	 <20081108153545.GA3859@ioremap.net>
	 <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John McCutchan <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The reason John & I did not add a pid field -- and we discussed it and
really wanted it -- is security. It is an information leak to know
what an unrelated process is doing.

Trust me that the rest of the kernel developers are even harder on
this subject than I.

I suppose you could fill out the pid field only if the uid's match,
but that is extra work for less utility.

     Robert


On Sat, Nov 8, 2008 at 11:58 AM, Michael Kerrisk
<mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
> [CC += "John McCutchan" <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>, who was one of the
> inotify developers, as I recall]
>
> Hi Evgeniy,
>
> On Sat, Nov 8, 2008 at 10:35 AM, Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:
>> Hi Michael.
>>
>> On Sat, Nov 08, 2008 at 09:25:16AM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
>>> I've not looked closely at the patch, but a quick question.  The
>>> ookied field is unused for _most_ events, but is used for rename
>>> events.  Are you saying that with this patch, that the cookie will be
>>> used as before for rename events, but for other events it will be the
>>> PID of the triggering process?  If so, that seems a bit ugly -- why
>>> wouldn't we also be intersted in the PID for rename events?
>>
>> Yes, rename events actually consist of at least two: move from and move
>> to, and they carry the same cookie, so that userspace could combine them
>> into single transaction. All others use zero, so I decided to put PID of
>> the caller there. This does not look perfect of course, but we can not
>> change the structure layout, so rename events can not be changed to
>> carry additional PID field.
>
> It's perhaps unfortunate that the structure wasn't padded out with a
> few additional fields "for future use".  But -- maybe it is not really
> true that we can't change things.  Two things to consider:
>
> a) We now (since 2.6.27) have an inotify_init1() which has a flags argument.
> b) There are spare bits in the mask argument of inotify_add_watch()
>
> We could use a flag in either of these to say that we want a different
> structure returned on read() from the inotify descriptor.  In the
> first case, this would be a global setting for all inotify events on
> that descriptor.  In the second, we could do it on a per-watch basis
> (I'm not so sure that that is a nice idea).  Since we are in any case
> extending the ABI, and new applications would need to be taught about
> the extension, it seems we could consider either of the alternative
> extensions I mentioned, which woul also allow the PID to be obtained
> for rename() events.  What do you think?
>
> Cheers,
>
> Michael
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
> man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
> Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
