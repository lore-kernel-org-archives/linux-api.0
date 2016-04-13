From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 14:01:52 -0500
Message-ID: <20160413190152.GA29753@mail.hallyn.com>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160413175736.GC3676@htj.duckdns.org>
 <20160413184639.GA29483@mail.hallyn.com>
 <20160413185033.GH3676@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160413185033.GH3676-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hello, Serge.
> 
> On Wed, Apr 13, 2016 at 01:46:39PM -0500, Serge E. Hallyn wrote:
> > It's not a leak of any information we're trying to hide.  I realize
> > something like 8 years have passed, but I still basically go by the
> > ksummit guidance that containers are ok but the kernel's first priority
> > is to facilitate containers but not trick containers into thinking
> > they're not containerized.  So long as the container is properly set
> > up, I don't think there's anything the workload could do with the
> > nsroot= info other than *know* that it is in a ns cgroup.
> > 
> > If we did change that guidance, there's a slew of proc info that we
> > could better virtualize :)
> 
> I see.  I'm just wondering because the information here seems a bit
> gratuituous.  Isn't the only thing necessary telling whether the root
> is bind mounted or namescoped?  Wouldn't simple "nsroot" work for that
> purpose?

I don't think so - we could be in a cgroup namespace but still have
access only to bind-mounted cgroups.  So we need to compare the
superblock dentry root field to the nsroot= value.
