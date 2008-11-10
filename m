From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [1/1] Use pid in inotify events.
Date: Mon, 10 Nov 2008 12:15:36 -0500
Message-ID: <cfd18e0f0811100915o8ea98a0s816921cee3163c1c@mail.gmail.com>
References: <20081108114225.GA22674@ioremap.net>
	 <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
	 <20081108153545.GA3859@ioremap.net>
	 <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com>
	 <20081110152043.GB15796@ioremap.net>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081110152043.GB15796-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John McCutchan <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Evgeniy,

On Mon, Nov 10, 2008 at 10:20 AM, Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:
> Hi Michael.
>
> On Sat, Nov 08, 2008 at 11:58:30AM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
>> It's perhaps unfortunate that the structure wasn't padded out with a
>> few additional fields "for future use".  But -- maybe it is not really
>> true that we can't change things.  Two things to consider:
>>
>> a) We now (since 2.6.27) have an inotify_init1() which has a flags argument.
>> b) There are spare bits in the mask argument of inotify_add_watch()
>>
>> We could use a flag in either of these to say that we want a different
>> structure returned on read() from the inotify descriptor.  In the
>> first case, this would be a global setting for all inotify events on
>> that descriptor.  In the second, we could do it on a per-watch basis
>> (I'm not so sure that that is a nice idea).  Since we are in any case
>> extending the ABI, and new applications would need to be taught about
>> the extension, it seems we could consider either of the alternative
>> extensions I mentioned, which woul also allow the PID to be obtained
>> for rename() events.  What do you think?
>
> This may be a good idea for some serious ABI change. I think we could
> extend it even more to include IO offset/size into events and attribute
> changes.

Are you going to revise your patch to use this idea?

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
