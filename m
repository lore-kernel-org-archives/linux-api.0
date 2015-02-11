From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 17:00:23 +0100
Message-ID: <20150211160023.GA1579@mail.hallyn.com>
References: <878uhe42km.fsf@x220.int.ebiederm.org>
 <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
 <20150211034616.GA25022@mail.hallyn.com>
 <20150211040957.GC21356@htj.duckdns.org>
 <20150211042942.GA27931@mail.hallyn.com>
 <87oap1qbv3.fsf@x220.int.ebiederm.org>
 <20150211051704.GB24897@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150211051704.GB24897-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Hey,
> 
> On Tue, Feb 10, 2015 at 11:02:40PM -0600, Eric W. Biederman wrote:
> > A slightly off topic comment, for where this thread has gone but
> > relevant if we are talking about cgroup namespaces.
> > 
> > If don't implement compatibility with existing userspace, they get a
> > nack.  A backwards-incompatible change should figure out how to remove
> > the need for any namespaces.
> >
> > Because that is what namespaces are about backwards compatibility.
> 
> Are you claiming that namespaces are soley about backwards
> compatibility?  ie. to trick userland into scoping without letting it
> notice?  That's a very restricted view and namespaces do provide
> further isolation capabilties in addition to what can be achieved
> otherwise and it is logical to collect simliar funtionalities there.

We absolutely would love to use cgroup namespaces to run older
userspace in containers.  I don't know that it's actually possible
to do both that and use unified hierarchy at the same time though,
which is unfortunate.  So an Ubuntu 12.04 container will never, afaics,
be able to run inside an ubuntu 16.04 host that is using unified
hierarchy, without using backported newer versions of lxc (etc) in
the container.
