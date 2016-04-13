From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 13 Apr 2016 15:12:35 -0400
Message-ID: <20160413191235.GA20142@htj.duckdns.org>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160413175736.GC3676@htj.duckdns.org>
 <20160413184639.GA29483@mail.hallyn.com>
 <20160413185033.GH3676@htj.duckdns.org>
 <20160413190152.GA29753@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160413190152.GA29753-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Apr 13, 2016 at 02:01:52PM -0500, Serge E. Hallyn wrote:
> I don't think so - we could be in a cgroup namespace but still have
> access only to bind-mounted cgroups.  So we need to compare the
> superblock dentry root field to the nsroot= value.

I see.  No objection then.

Thanks.

-- 
tejun
