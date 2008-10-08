From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH v2] proc: show personality via /proc/pid/personality
Date: Wed, 8 Oct 2008 04:45:22 +0200
Message-ID: <cfd18e0f0810071945j4ebbe366qdf2e98fe3d0306eb@mail.gmail.com>
References: <20081002211424.GJ10632@outflux.net>
	 <20081004145149.52c34ee7@infradead.org>
	 <20081004220220.GK10632@outflux.net>
	 <20081004164239.0c1483a4@infradead.org>
	 <20081005004233.GL10632@outflux.net>
	 <20081004174843.6fe48a8e@infradead.org>
	 <20081005091120.GA21003@x200.localdomain>
	 <20081005101438.GR10632@outflux.net>
	 <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
	 <20081007161422.GD10357@outflux.net>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20081007161422.GD10357-oSa+0FWJbaXR7s880joybQ@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Kees,

On Tue, Oct 7, 2008 at 6:14 PM, Kees Cook <kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> Hi Michael,
>
> On Tue, Oct 07, 2008 at 03:39:26PM +0200, Michael Kerrisk wrote:
>> On Sun, Oct 5, 2008 at 12:14 PM, Kees Cook <kees.cook-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
>> > Make process personality flags visible in /proc.  Since a process's
>> > personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
>> > file only readable by the process owner.
>>
>> Please CC userland interface changes to linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>
> Sure, I'd be happy to do that for future stuff.  I don't see this email
> address mentioned anywhere in the kernel tree.  It seems like this is
> useful information that should go in either MAINTAINERS or better yet
> Documentation/SubmittingPatches for it to be discoverable by future
> patch-senders -- and somewhere that I can look it up easily later.  :)

It's there, but only as of a few days ago.

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
