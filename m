From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] mm,fork: introduce MADV_WIPEONFORK
Date: Fri, 18 Aug 2017 11:15:45 -0700
Message-ID: <20170818111545.ab371cfedb71d13d76590030@linux-foundation.org>
References: <20170811212829.29186-1-riel@redhat.com>
        <20170811212829.29186-3-riel@redhat.com>
        <20170815155114.ff9f4164eed28bf02db48fbb@linux-foundation.org>
        <1502849899.6577.66.camel@redhat.com>
        <20170817155033.172cf22ec143713d5cf98b4e@linux-foundation.org>
        <1503073709.6577.68.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503073709.6577.68.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 18 Aug 2017 12:28:29 -0400 Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 2017-08-17 at 15:50 -0700, Andrew Morton wrote:
> > On Tue, 15 Aug 2017 22:18:19 -0400 Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > wrote:
> > 
> > > > > --- a/mm/madvise.c
> > > > > +++ b/mm/madvise.c
> > > > > @@ -80,6 +80,17 @@ static long madvise_behavior(struct
> > > > > vm_area_struct *vma,
> > > > > __		}
> > > > > __		new_flags &= ~VM_DONTCOPY;
> > > > > __		break;
> > > > > +	case MADV_WIPEONFORK:
> > > > > +		/* MADV_WIPEONFORK is only supported on
> > > > > anonymous
> > > > > memory. */
> > > > > +		if (vma->vm_file || vma->vm_flags & VM_SHARED)
> > > > > {
> > > > > +			error = -EINVAL;
> > > > > +			goto out;
> > > > > +		}
> > > > > +		new_flags |= VM_WIPEONFORK;
> > > > > +		break;
> > > > > +	case MADV_KEEPONFORK:
> > > > > +		new_flags &= ~VM_WIPEONFORK;
> > > > > +		break;
> > > > > __	case MADV_DONTDUMP:
> > > > > __		new_flags |= VM_DONTDUMP;
> > > > > __		break;
> > > > 
> > > > It seems odd to permit MADV_KEEPONFORK against other-than-anon
> > > > vmas?
> > > 
> > > Given that the only way to set VM_WIPEONFORK is through
> > > MADV_WIPEONFORK, calling MADV_KEEPONFORK on an
> > > other-than-anon vma would be equivalent to a noop.
> > > 
> > > If new_flags == vma->vm_flags, madvise_behavior() will
> > > immediately exit.
> > 
> > Yes, but calling MADV_WIPEONFORK against an other-than-anon vma is
> > presumably a userspace bug.____A bug which will probably result in
> > userspace having WIPEONFORK memory which it didn't want.____The kernel
> > can trivially tell userspace that it has this bug so why not do so?
> 
> Uh, what?
> 

Braino.  I meant MADV_KEEPONFORK.  Calling MADV_KEEPONFORK against an
other-than-anon vma is a presumptive userspace bug and the kernel
should report that.
