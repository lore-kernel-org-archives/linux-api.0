From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 16:11:06 -0700
Message-ID: <20141029231106.GB16548@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1410292354480.11562-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 12:00:16AM +0100, Jiri Kosina wrote:
> On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:
> 
> > kdbus is a kernel-level IPC implementation that aims for resemblance to
> > the the protocol layer with the existing userspace D-Bus daemon while
> > enabling some features that couldn't be implemented before in userspace.
> 
> I'd be interested in the features that can't be implemented in userspace 
> (and therefore would justify existence of kdbus in the kernel). Could you 
> please point me to such list / documentation?

Lennart has given whole talks about this in the past, here's a recent
talk going into the details:
	https://www.youtube.com/watch?v=HPbQzm_iz_k

> It seems to me that most of the highlight features from the cover letter 
> can be "easily" (for certain definition of that word, of course) 
> implemented in userspace (vmsplice(), sending fd through unix socket, user 
> namespaces, UUID management, etc).

We have dbus in userspace today, but that requires extra copies of data,
and isn't easy, or even possible, to do some of the application-specific
bus logic that kdbus provides.  See the talk above for details, there
are slides around somewhere with just text that we can add to the cover
letter if that will help out in future spins of this patch series.

thanks,

greg k-h
