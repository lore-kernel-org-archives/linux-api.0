From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 11:03:47 -0500
Message-ID: <20150211160347.GE21356@htj.duckdns.org>
References: <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
 <20150211034616.GA25022@mail.hallyn.com>
 <20150211040957.GC21356@htj.duckdns.org>
 <20150211042942.GA27931@mail.hallyn.com>
 <87oap1qbv3.fsf@x220.int.ebiederm.org>
 <20150211051704.GB24897@mtj.duckdns.org>
 <20150211160023.GA1579@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150211160023.GA1579-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Feb 11, 2015 at 05:00:23PM +0100, Serge E. Hallyn wrote:
> We absolutely would love to use cgroup namespaces to run older
> userspace in containers.  I don't know that it's actually possible
> to do both that and use unified hierarchy at the same time though,
> which is unfortunate.  So an Ubuntu 12.04 container will never, afaics,
> be able to run inside an ubuntu 16.04 host that is using unified
> hierarchy, without using backported newer versions of lxc (etc) in
> the container.

So, the constraint there are the controllers.  A controller can't be
attached to two hierarchies at the same time for obvious reasons, so
regardless of NS, you can't use the same controller on a unified
hierarchy *and* a traditional hierarchy.  NS doesn't adds or
substracts from the situation.  If you decide to attach a controller
to a traditional hierarchy, that's where it's gonna be available.  If
you attach it to the unified hierarchy, the same story.

Thanks.

-- 
tejun
