From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC v13][PATCH 00/14] Kernel based checkpoint/restart
Date: Fri, 13 Feb 2009 15:28:36 -0800
Message-ID: <20090213152836.0fbbfa7d.akpm@linux-foundation.org>
References: <1233076092-8660-1-git-send-email-orenl@cs.columbia.edu>
	<1234285547.30155.6.camel@nimitz>
	<20090211141434.dfa1d079.akpm@linux-foundation.org>
	<1234462282.30155.171.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1234462282.30155.171.camel@nimitz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: mingo-X9Un+BFzKDI@public.gmane.org, orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 12 Feb 2009 10:11:22 -0800
Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:

> 
> ...
>
> > - In bullet-point form, what features are missing, and should be added?
> 
>  * support for more architectures than i386
>  * file descriptors:
>   * sockets (network, AF_UNIX, etc...)
>   * devices files
>   * shmfs, hugetlbfs
>   * epoll
>   * unlinked files
>  * Filesystem state
>   * contents of files
>   * mount tree for individual processes
>  * flock
>  * threads and sessions
>  * CPU and NUMA affinity
>  * sys_remap_file_pages()
> 
> This is a very minimal list that is surely incomplete and sure to grow.

That's a worry.

> 
> > For extra marks:
> > 
> > - Will any of this involve non-trivial serialisation of kernel
> >   objects?  If so, that's getting into the
> >   unacceptably-expensive-to-maintain space, I suspect.
> 
> We have some structures that are certainly tied to the kernel-internal
> ones.  However, we are certainly *not* simply writing kernel structures
> to userspace.  We could do that with /dev/mem.  We are carefully pulling
> out the minimal bits of information from the kernel structures that we
> *need* to recreate the function of the structure at restart.  There is a
> maintenance burden here but, so far, that burden is almost entirely in
> checkpoint/*.c.  We intend to test this functionality thoroughly to
> ensure that we don't regress once we have integrated it.

I guess my question can be approximately simplified to: "will it end up
looking like openvz"?  (I don't believe that we know of any other way
of implementing this?)

Because if it does then that's a concern, because my assessment when I
looked at that code (a number of years ago) was that having code of
that nature in mainline would be pretty costly to us, and rather
unwelcome.

The broadest form of the question is "will we end up regretting having
done this".

If we can arrange for the implementation to sit quietly over in a
corner with a team of people maintaining it and not screwing up other
people's work then I guess we'd be OK - if it breaks then the breakage
is localised.



And it's not just a matter of "does the diffstat only affect a single
subdirectory".  We also should watch out for the imposition of new
rules which kernel code must follow.  "you can't do that, because we
can't serialise it", or something.

Similar to the way in which perfectly correct and normal kernel
sometimes has to be changed because it unexpectedly upsets the -rt
patch.

Do you expect that any restrictions of this type will be imposed?
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
