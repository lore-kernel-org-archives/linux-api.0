From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 00/12] Add kdbus implementation
Date: Wed, 29 Oct 2014 16:34:38 -0700
Message-ID: <20141029233438.GA16520@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
 <20141029231106.GB16548@kroah.com>
 <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz>
 <alpine.LRH.2.00.1410300024530.11562@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1410300024530.11562-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Marcel Holtmann <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>, desrt-0xnayjDhYQY@public.gmane.org, hadess-0MeiytkfxGOsTnJN9+BGXg@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, tixxdz-Umm1ozX2/EEdnm+yROfE0A@public.gmane.org, simon.mcvittie-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org, alban.crequy-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, javier.martinez-ZGY8ohtN/8pPYcu2f3hruQ@public.gmane.org, teg-B22kvLQNl6c@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 30, 2014 at 12:26:33AM +0100, Jiri Kosina wrote:
> On Thu, 30 Oct 2014, Jiri Kosina wrote:
> 
> > > > It seems to me that most of the highlight features from the cover letter 
> > > > can be "easily" (for certain definition of that word, of course) 
> > > > implemented in userspace (vmsplice(), sending fd through unix socket, user 
> > > > namespaces, UUID management, etc).
> > > 
> > > We have dbus in userspace today, but that requires extra copies of data,
> > 
> > But we can do zero-copy between processess for quite some time already, so 
> > what exactly is the issue here?
> > 
> > > and isn't easy, or even possible, to do some of the application-specific
> > > bus logic that kdbus provides.  
> > 
> > I unfortunately have absolutely no idea what should I imagine here.
> 
> Also, I think I have heard that binder is going out of staging now, right?

Yes, but that needs documentation, which I'm working on at the moment :)

> I admittedly have very limited understanding of both binder and kdbus, but 
> I guess that is the case for many folks. My understanding is that they are 
> providing very similar functionality, so explanation why we need *both* in 
> the kernel would be very interesting as well.

They do very different things, see this writeup I did a while ago about
the differences between them:
	http://kroah.com/log/blog/2014/01/15/kdbus-details/

thanks,

greg k-h
