From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
Date: Wed, 12 Feb 2020 13:16:38 -0600
Message-ID: <87v9obipk9.fsf@x220.int.ebiederm.org>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
        <20200210150519.538333-8-gladkov.alexey@gmail.com>
        <87v9odlxbr.fsf@x220.int.ebiederm.org>
        <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
        <87tv3vkg1a.fsf@x220.int.ebiederm.org>
        <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
        (Linus Torvalds's message of "Wed, 12 Feb 2020 10:45:06 -0800")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Security Module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Dmitry V . Levin" <ldv-u2l5PoMzF/Vg9hUCZPvPmw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "J . Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>Ke
List-Id: linux-api@vger.kernel.org

Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> writes:

> On Wed, Feb 12, 2020 at 7:01 AM Eric W. Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org> wrote:
>>
>> Fundamentally proc_flush_task is an optimization.  Just getting rid of
>> dentries earlier.  At least at one point it was an important
>> optimization because the old process dentries would just sit around
>> doing nothing for anyone.
>
> I'm pretty sure it's still important. It's very easy to generate a
> _ton_ of dentries with /proc.
>
>> I wonder if instead of invalidating specific dentries we could instead
>> fire wake up a shrinker and point it at one or more instances of proc.
>
> It shouldn't be the dentries themselves that are a freeing problem.
> They're being RCU-free'd anyway because of lookup. It's the
> proc_mounts list that is the problem, isn't it?
>
> So it's just fs_info that needs to be rcu-delayed because it contains
> that list. Or is there something else?

The fundamental dcache thing we are playing with is:

	dentry = d_hash_and_lookup(proc_root, &name);
	if (dentry) {
		d_invalidate(dentry);
		dput(dentry);
	}

As Al pointed out upthread dput and d_invalidate can both sleep.

The dput can potentially go away if we use __d_lookup_rcu instead of
d_lookup.

The challenge is d_invalidate.

It has the fundamentally sleeping detach_mounts loop.  Even
shrink_dcache_parent has a cond_sched() in there to ensure it doesn't
live lock the system.

We could and arguabley should set DCACHE_CANT_MOUNT on the proc pid
dentries.  Which will prevent having to deal with mounts.

But I don't see an easy way of getting shrink_dcache_parent to run
without sleeping.  Ideas?


Eric
