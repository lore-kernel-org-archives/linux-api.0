From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Date: Mon, 1 Dec 2014 15:19:50 +0100
Message-ID: <20141201151950.0df00078.cornelia.huck@de.ibm.com>
References: <1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092658.GC15607@redhat.com>
	<20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
	<20141201114645.GA17505@redhat.com>
	<20141201130258.6f01c1e3.cornelia.huck@de.ibm.com>
	<20141201123455.GA17958@redhat.com>
	<20141201134036.726e7386.cornelia.huck@de.ibm.com>
	<20141201125126.GB18106@redhat.com>
	<20141201140004.57d53155.cornelia.huck@de.ibm.com>
	<20141201134719.GA18305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141201134719.GA18305-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, rusty-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, thuth-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 1 Dec 2014 15:47:19 +0200
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, Dec 01, 2014 at 02:00:04PM +0100, Cornelia Huck wrote:
> > On Mon, 1 Dec 2014 14:51:26 +0200
> > "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > On Mon, Dec 01, 2014 at 01:40:36PM +0100, Cornelia Huck wrote:
> > > > On Mon, 1 Dec 2014 14:34:55 +0200
> > > > "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > 
> > > > > On Mon, Dec 01, 2014 at 01:02:58PM +0100, Cornelia Huck wrote:
> > > > > > On Mon, 1 Dec 2014 13:46:45 +0200
> > > > > > "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > > 
> > > > > > > On Mon, Dec 01, 2014 at 12:33:15PM +0100, Cornelia Huck wrote:
> > > > > > > > On Mon, 1 Dec 2014 11:26:58 +0200
> > > > > > > > "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > > > > > 
> > > > > > > > > For some places on data path, it might be worth it
> > > > > > > > > to cache the correct value e.g. as part of device
> > > > > > > > > structure. This replaces a branch with a memory load,
> > > > > > > > > so the gain would have to be measured, best done
> > > > > > > > > separately?
> > > > > > > > 
> > > > > > > > I think we'll want to do some measuring once the basic structure is
> > > > > > > > in place anyway.
> > > > > > > 
> > > > > > > What's meant by in place here?
> > > > > > 
> > > > > > That this patchset is ready :)
> > > > > 
> > > > > Also it's ready to the level where benchmarking is possible, right?  I
> > > > > don't think you should wait until we finish polishing up commit
> > > > > messages.
> > > > 
> > > > My point is that I haven't even found time yet to test this
> > > > thouroughly :(
> > > 
> > > If my experience shows anything, it's unlikely we'll get appropriate
> > > testing without code being upstream first.
> > > That's why I pushed on with sparse tagging btw.
> > > This way we can be reasonably sure we didn't miss some path.
> > 
> > I know that I'm likely the only one to test ccw (unless I manage to get
> > some other also-busy people to try this out).
> > 
> > What's the status of virtio-pci, btw? Can people actually test this
> > sanely?
> 
> Sure, I'm testing that it's not broken by these patches.
> Others can do so, too.

So basically just regression testing, right?

> 
> Once ccw is done on host and guest (will be complete after I
> send v8), it will be easier to add virtio 1.0 for more transports.
> 
> OTOH if we require that everything is ready and perfect before merging
> anything we'll never get anywhere.

I'm not looking for perfect, I'm just trying to juggle testing this +
doing qemu changes + various other stuff that is eating my time :)
