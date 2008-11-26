From: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Subject: Re: [PATCH] Display active jiffie timers in /proc/timer_list, v2
Date: Wed, 26 Nov 2008 12:34:10 -0500
Message-ID: <20081126173410.GA17879@tsunami.ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <20081126164845.GA17394@tsunami.ccur.com> <20081126170715.GA28422@kroah.com>
Reply-To: Joe Korty <joe.korty-oXJCJecloQs@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081126170715.GA28422-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2008 at 12:07:15PM -0500, Greg KH wrote:
> On Wed, Nov 26, 2008 at 11:48:45AM -0500, Joe Korty wrote:
> > Add an 'active jiffie timers' subdisplay to /proc/timer_list, v2.
> 
> Can you add the documentation for this new field to Documentation/ABI/
> as you are changing/adding a public API.


OK.

Right now there is no ABI documention for anything in
/proc/timer_list.  Do you prefer one file for everything
in /proc/timer_list, or a seperate file for each of the
subsections?

I was also thinking the doc(s) should go into the /testing
subsection, as the displayed revision number is < 1.0.

Joe
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
