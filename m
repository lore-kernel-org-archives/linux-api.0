From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 00:10:14 -0500
Message-ID: <20150211051014.GA24897@mtj.duckdns.org>
References: <87bnma6xwv.fsf@x220.int.ebiederm.org>
 <20150107224430.GA28414@htj.dyndns.org>
 <878uhe42km.fsf@x220.int.ebiederm.org>
 <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
 <20150211034616.GA25022@mail.hallyn.com>
 <20150211040957.GC21356@htj.duckdns.org>
 <20150211042942.GA27931@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150211042942.GA27931-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Feb 11, 2015 at 05:29:42AM +0100, Serge E. Hallyn wrote:
> > There shouldn't be a "freezer" cgroup.  The processes are categorized
> > according to their logical structure and controllers are applied to
> > the hierarchy as necessary.
> 
> But there can well be cgroups for which only freezer is enabled.  If
> I'm wrong about that, then I am suffering a fundamental misunderstanding.

Ah, sure, I was mostly arguing semantics.  It's just weird to call it
"freezer" cgroup.

> > The semantics is that the parent enables distribution of its given
> > type of resource by enabling the controller in its subtree_control.
> > This scoping isn't necessary for freezer and I'm debating whether to
> > enable controllers which don't need granularity control to be enabled
> > unconditionally.  Right now, I'm leaning against it mostly for
> > consistency.
> 
> Yeah, IIUC (i.e. freezer would always be enabled?) that would be
> even-more-confusing.

Right, freezer is kinda weird tho.  Its feature can almost be
considered a utility feature of cgroups core rather than a separate
controller.  That said, it's most likely that it'll remain in its
current form although how it blocks tasks should definitely be
reimplemented.

Thanks.

-- 
tejun
