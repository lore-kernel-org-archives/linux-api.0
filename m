From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [1/1] Use pid in inotify events.
Date: Sat, 8 Nov 2008 18:35:45 +0300
Message-ID: <20081108153545.GA3859@ioremap.net>
References: <20081108114225.GA22674@ioremap.net> <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Michael.

On Sat, Nov 08, 2008 at 09:25:16AM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
> I've not looked closely at the patch, but a quick question.  The
> ookied field is unused for _most_ events, but is used for rename
> events.  Are you saying that with this patch, that the cookie will be
> used as before for rename events, but for other events it will be the
> PID of the triggering process?  If so, that seems a bit ugly -- why
> wouldn't we also be intersted in the PID for rename events?

Yes, rename events actually consist of at least two: move from and move
to, and they carry the same cookie, so that userspace could combine them
into single transaction. All others use zero, so I decided to put PID of
the caller there. This does not look perfect of course, but we can not
change the structure layout, so rename events can not be changed to
carry additional PID field.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
