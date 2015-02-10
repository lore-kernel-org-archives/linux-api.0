From: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Tue, 10 Feb 2015 14:27:20 +0000
Message-ID: <20150210142719.GA1437@localhost.localdomain>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
 <20150206125916.GB26247@kroah.com>
 <20150206154157.GD1143@localhost.localdomain>
 <20150207040743.GB29944@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150207040743.GB29944-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "James E.J. Bottomley (JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org)" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Laurence Oberman (loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Feb 07, 2015 at 12:07:43PM +0800, Greg KH wrote:
> On Fri, Feb 06, 2015 at 03:41:58PM +0000, Bryn M. Reeves wrote:
> > I can't speak for Shane but wouldn't spend too much time looking at the
> > current v2 patch: it's the result of a pretty ugly compromise suggested
> > on linux-scsi.
> 
> Fair enough, but please feel free to cc: me on the patch that you do
> feel is correct to get a sysfs-related review.

Will do; I'm back from travels this week & will have some time to look at
this.
 
> > Likewise for disk stats: although fluff like maj:min/name etc. has been
> > shuffled a few times the basic fields have remained unchanged for a very
> > long time and sysfs already removes the need to include an identity
> > field.
> 
> We already handle i/o stats just fine, why create a special sysfs
> interface for just a tape device interface?  What makes them so special?

But the iostats use exactly the sort of array file we're talking about:

$ cat /sys/block/sda/stat 
  127644    20869  4320505  2305697   154045    30056  3834036  9065092        0   931842 11371357

And we can't simply extend these to tapes as they are not block devices.
 
> > I understand the fact that you can't change them; I just don't think it's
> > a big problem in this specific case (and much less than some of the
> > more imaginative sysfs content - 2d int arrays with column headers
> > anyone?).
> 
> What sysfs file is a 2d int array?  I'll be glad to fix it.

$ cat /sys/fs/selinux/avc/cache_stats 
lookups hits misses allocations reclaims frees
18938916 18921707 17209 17209 17328 22215
38164283 38146514 17769 17769 16800 19049
18078108 18056991 21117 21117 21344 19305
15168204 15150079 18125 18125 17776 13149
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0
0 0 0 0 0 0

$ cat /sys/fs/selinux/avc/hash_stats
entries: 506
buckets used: 290/512
longest chain: 5

> If you want to measure tens of thousands of tape devices then you
> shouldn't be using sysfs in the first place as it is not designed for
> "speed" at all.  Use the existing i/o rate interfaces instead, don't try
> to cram something into sysfs that doesn't belong there.

So far as I'm aware there is no other way to obtain performance data
for the SCSI tape subsystem (without resorting to ftrace/systemtap).

Regards,
Bryn.
