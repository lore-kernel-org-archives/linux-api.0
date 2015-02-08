From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Sun, 08 Feb 2015 09:35:01 -0800
Message-ID: <1423416901.2113.83.camel@HansenPartnership.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
	 <20150206125916.GB26247@kroah.com>
	 <20150206154157.GD1143@localhost.localdomain>
	 <20150207040743.GB29944@kroah.com>
	 <ACE69613-157F-4516-8499-EF8242D26736@gmail.com>
	 <20150208024506.GC15396@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150208024506.GC15396-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Laurence Oberman <oberman.l-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "Laurence Oberman (loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, 2015-02-08 at 10:45 +0800, Greg KH wrote:
> On Sat, Feb 07, 2015 at 09:27:05PM -0500, Laurence Oberman wrote:
> > Hello
> > Its not going to be tens of thousands of devices. That count was an
> > aggregate based on 1000's of servers.
> > In reality its unlikely to ever be more than 100 tapes drives per
> > individual Linux kernel instance.
> > Therefore sysfs will be the valid way to do this and make the data
> > available to user space.
> 
> Even if it is only 2 tape drives, again, what's wrong with using the
> existing i/o statistic interfaces that all block devices have?

Tape is a character device.  It only uses block via SCSI (SCSI uses
block to give an issue queue for every device).  One of the problems
with this model is that the block kobj, where all the statistics hang,
is actually never exposed for these devices because they don't have a
block name.  Even granted that we could alter block to give names to the
nameless queues and expose them in /sys/block, we'd still have the
problem, the queue statistics are the property of the pluggable I/O
scheduler, so there's a disconnect between the SCSI upper layer drivers
and the block scheduler (since the latter is embedded by design).
Pulling that apart would get us into a fairly nasty layering violation
(drivers aren't supposed to care about the scheulders).

>   Don't go
> making special one-off interfaces for one type of device if at all
> possible.

I don't really see any way around this.  The statistics the block
schedulers collect are relevant to I/O load balancing; that's not at all
the same class of statistics as the users of tape are interested in.
This problem is equivalent to the fibrechannel one where we collect the
fc_host_statistics in the scsi_transport_fc.c class as an attribute
group (block doesn't want to see or know any of the information because
it's all relevant to the transport, not the block abstraction).

James
