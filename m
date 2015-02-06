From: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Fri, 6 Feb 2015 09:13:55 +0000
Message-ID: <20150206091354.GA1143@localhost.localdomain>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DDB9C85B850785449757F9914A034FCB3BF3EADA-4I1V4pQFGigSZAcGdq5asR6epYMZPwEe5NbjCUgZEJk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>
Cc: "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "James E.J. Bottomley (JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org)" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Laurence Oberman (loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 06, 2015 at 12:20:53AM +0000, Seymour, Shane M wrote:
> There has been some ongoing discussion about the best way to implement
> tape statistics. The original method suggested a long time ago used a
> single file in sysfs similar to block statistics in sysfs. That lead to
> an impass about the code on the linux-scsi mailing list.

I would have a strong preference for a single file containing an array
of integer counters. This is in keeping with other statistics attributes
in sysfs and follows the principle of least surprise: it's essentially
the same general format as /proc/diskstats and sysfs disk and partition
stats (dm statistics also follow this convention via the @print_stats
message).

This simplifies userspace code to read and parse the counters and avoids
additional sample jitter when reading stats for very large numbers of
devices; each device would require at least eleven open()/read()/close()
cycles.

For a small number of devices this shouldn't matter too much but
eventually the additional syscall overhead could become significant (I
think you mentioned users with ~20k devices?).

The sync file mechanism in the v2 patch that addresses this problem is
kinda cute but also significantly more complex than a plain old array
and as you pointed out adds hundreds of lines to the patch..

Sticking to arrays also allows existing tools like sysstat to be easily
adapted to the new data source.

> The sysfs documentation says that files should contain one item per file (with some small exceptions):
> 
> > "Attributes should be ASCII text files, preferably with only one value
> > per file. It is noted that it may not be efficient to contain only one
> > value per file, so it is socially acceptable to express an array of
> > values of the same type."

Right: I think there's good precedent for the array file style when
dealing with counter sets.

Regards,
Bryn.
