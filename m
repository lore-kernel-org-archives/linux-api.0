From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 11 Feb 2015 09:36:38 -0500
Message-ID: <20150211143638.GD21356@htj.duckdns.org>
References: <20150107230615.GA28630@htj.dyndns.org>
 <87fvbm2nni.fsf@x220.int.ebiederm.org>
 <87y4peyxw5.fsf@x220.int.ebiederm.org>
 <20150107233553.GC28630@htj.dyndns.org>
 <20150211034616.GA25022@mail.hallyn.com>
 <20150211040957.GC21356@htj.duckdns.org>
 <20150211042942.GA27931@mail.hallyn.com>
 <87oap1qbv3.fsf@x220.int.ebiederm.org>
 <20150211051704.GB24897@mtj.duckdns.org>
 <87twytklkv.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87twytklkv.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hey,

On Wed, Feb 11, 2015 at 12:29:20AM -0600, Eric W. Biederman wrote:
> In general namespaces are not necessary if your scope of names
> already has hierarchy.  Which means that new interfaces can almost
> always be designed in such a way that you can support containers without
> needing to add any special namespace support.  Which typically results
> in more flexible and useful APIs for everyone, with no real code cost.

Sure, and cgroup ns support isn't doing anything weird there.  Just
bind mounting a subhierarchy is enough for the core features.  The ns
part is dealing with things which can't easily be tied to such
hierarchical scoping like path reported under through proc and even
handling that can be achieved by, for example, marking delegation
points in cgroup proper and forcing tasks beyond that point to
consider that as its origin when determining the path to report.

However, note that something like that is inherently similar to what's
being provided by other namespaces.  It is true that it can be
implemented outside namespace facility proper but that doesn't
automatically make that the right choice and it's more likely to be
worse - we'd be introducing a different way to perform about the same
thing.

So, the argument that adding namespace interface except for backward
compatibility doesn't seem to hold water.  Like it or not, namespace
is serving as a platform for certain type of features and we'd be
foolish to not to consider putting a related feature together there
and I fail to see a valid technical argument as of yet.

> Further in the cgroup namespace patchset I looked at a while ago, the
> only reason for having a cgroup namespace was to provide a measure of
> backwards compatibility with existing userspace.  I expect removing the
> /proc/<pid>/cgroup file and replacing it with something in cgroupfs
> itself would serve just as well if backwards compatibility is not the
> objective.  Or possibly replacincg /proc/<pid>/cgroup into a magic
> symlink onto somewhere in the unified cgroupfs itself.

No matter what we do, we'd still need to mark the delegation point
somehow; otherwise, there's no way to produce a scoped identifier.
This isn't really about backward compatibility but rather the feature
to scope a subhierarcy properly.

> I just don't see any point in doing weird silly namespace things to keep
> existing userspace working when the existing userspace won't work.

If it's too different from existing namespaces, sure, doing something
is definitely an option but is it?

> As such if a namespace doesn't implement compatibility with the existing
> userspace it gets my nack.

Hmmm.... I don't think making the proposed NS support to work across
all hierarchies including the traditional multiple ones would be too
difficult.  That should work then, right?

Thanks.

-- 
tejun
