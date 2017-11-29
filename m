From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: disable `vm.max_map_count' sysctl limit
Date: Wed, 29 Nov 2017 09:32:24 +0100
Message-ID: <20171129083223.u2s2rkihdi5dzb5o@dhcp22.suse.cz>
References: <23066.59196.909026.689706@gargle.gargle.HOWL>
 <20171127101232.ykriowhatecnvjvg@dhcp22.suse.cz>
 <CAM43=SPVvBTPz31Uu=iz3fpS9tb75uSmL=pYP3AfsfmYr9u4Og@mail.gmail.com>
 <20171127195207.vderbbkbgygawuhx@dhcp22.suse.cz>
 <b6faf739-1a4a-12e1-ad84-0b42166d68c1@nvidia.com>
 <20171128081259.gnkiw5227dtmfm4l@dhcp22.suse.cz>
 <5ca7d54b-5ae4-646d-f3a0-9b85129c9ccf@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5ca7d54b-5ae4-646d-f3a0-9b85129c9ccf-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Mikael Pettersson <mikpelinux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue 28-11-17 21:14:23, John Hubbard wrote:
> On 11/28/2017 12:12 AM, Michal Hocko wrote:
> > On Mon 27-11-17 15:26:27, John Hubbard wrote:
> > [...]
> >> Let me add a belated report, then: we ran into this limit while implementing 
> >> an early version of Unified Memory[1], back in 2013. The implementation
> >> at the time depended on tracking that assumed "one allocation == one vma".
> > 
> > And you tried hard to make those VMAs really separate? E.g. with
> > prot_none gaps?
> 
> We didn't do that, and in fact I'm probably failing to grasp the underlying 
> design idea that you have in mind there...hints welcome...

mmap code tries to merge vmas very aggressively so you have to try to
make too many vmas. One way to separate different vmas is to mprotect
holes to trap potential {over,under}flows.

> What we did was to hook into the mmap callbacks in the kernel driver, after 
> userspace mmap'd a region (via a custom allocator API). And we had an ioctl
> in there, to connect up other allocation attributes that couldn't be passed
> through via mmap. Again, this was for regions of memory that were to be
> migrated between CPU and device (GPU).

Or maybe your driver made the vma merging impossible by requesting
explicit ranges which are not adjacent.

> >> So, with only 64K vmas, we quickly ran out, and changed the design to work
> >> around that. (And later, the design was *completely* changed to use a separate
> >> tracking system altogether). exag
> >>
> >> The existing limit seems rather too low, at least from my perspective. Maybe
> >> it would be better, if expressed as a function of RAM size?
> > 
> > Dunno. Whenever we tried to do RAM scaling it turned out a bad idea
> > after years when memory grown much more than the code author expected.
> > Just look how we scaled hash table sizes... But maybe you can come up
> > with something clever. In any case tuning this from the userspace is a
> > trivial thing to do and I am somehow skeptical that any early boot code
> > would trip over the limit.
> > 
> 
> I agree that this is not a limit that boot code is likely to hit. And maybe 
> tuning from userspace really is the right approach here, considering that
> there is a real cost to going too large. 
> 
> Just philosophically here, hard limits like this seem a little awkward if they 
> are set once in, say, 1999 (gross exaggeration here, for effect) and then not
> updated to stay with the times, right? In other words, one should not routinely 
> need to tune most things. That's why I was wondering if something crude and silly
> would work, such as just a ratio of RAM to vma count. (I'm more just trying to
> understand the "rules" here, than to debate--I don't have a strong opinion 
> on this.)

Well, rlimits are in general not very usable. Yet I do not think we
should simply wipe them out.

> The fact that this apparently failed with hash tables is interesting, I'd
> love to read more if you have any notes or links. I spotted a 2014 LWN article
> ( https://lwn.net/Articles/612100 ) about hash table resizing, and some commits
> that fixed resizing bugs, such as
> 
>     12311959ecf8a ("rhashtable: fix shift by 64 when shrinking")
> 
> ...was it just a storm of bugs that showed up?

No, it was just that large (TB) machines allocated insanely large hash
tables for things which will never have any way to fill them up. See
9017217b6f45 ("mm: adaptive hash table scaling").

-- 
Michal Hocko
SUSE Labs
