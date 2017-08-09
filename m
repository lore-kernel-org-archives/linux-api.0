From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] mm,fork,security: introduce MADV_WIPEONFORK
Date: Wed, 9 Aug 2017 12:59:57 +0300
Message-ID: <20170809095957.kv47or2w4obaipkn@node.shutemov.name>
References: <20170806140425.20937-1-riel@redhat.com>
 <20170807132257.GH32434@dhcp22.suse.cz>
 <20170807134648.GI32434@dhcp22.suse.cz>
 <1502117991.6577.13.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502117991.6577.13.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, colm-ZXBCfW2eEe/k1uMJSBkQmQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Aug 07, 2017 at 10:59:51AM -0400, Rik van Riel wrote:
> On Mon, 2017-08-07 at 15:46 +0200, Michal Hocko wrote:
> > On Mon 07-08-17 15:22:57, Michal Hocko wrote:
> > > This is an user visible API so make sure you CC linux-api (added)
> > > 
> > > On Sun 06-08-17 10:04:23, Rik van Riel wrote:
> > > > 
> > > > A further complication is the proliferation of clone flags,
> > > > programs bypassing glibc's functions to call clone directly,
> > > > and programs calling unshare, causing the glibc pthread_atfork
> > > > hook to not get called.
> > > > 
> > > > It would be better to have the kernel take care of this
> > > > automatically.
> > > > 
> > > > This is similar to the OpenBSD minherit syscall with
> > > > MAP_INHERIT_ZERO:
> > > > 
> > > >     https://man.openbsd.org/minherit.2
> > 
> > I would argue that a MAP_$FOO flag would be more appropriate. Or do
> > you
> > see any cases where such a special mapping would need to change the
> > semantic and inherit the content over the fork again?
> > 
> > I do not like the madvise because it is an advise and as such it can
> > be
> > ignored/not implemented and that shouldn't have any correctness
> > effects
> > on the child process.
> 
> Too late for that. VM_DONTFORK is already implemented
> through MADV_DONTFORK & MADV_DOFORK, in a way that is
> very similar to the MADV_WIPEONFORK from these patches.

It's not obvious to me what would break if kernel would ignore
MADV_DONTFORK or MADV_DONTDUMP.

-- 
 Kirill A. Shutemov
