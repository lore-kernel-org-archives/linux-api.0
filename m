From: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 16/46] virtio_blk: v1.0 support
Date: Mon, 1 Dec 2014 13:40:36 +0100
Message-ID: <20141201134036.726e7386.cornelia.huck@de.ibm.com>
References: <1417359787-10138-1-git-send-email-mst@redhat.com>
	<1417359787-10138-17-git-send-email-mst@redhat.com>
	<20141201091641.3085e682@thinkpad-w530>
	<20141201092658.GC15607@redhat.com>
	<20141201123315.1b95d06f.cornelia.huck@de.ibm.com>
	<20141201114645.GA17505@redhat.com>
	<20141201130258.6f01c1e3.cornelia.huck@de.ibm.com>
	<20141201123455.GA17958@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141201123455.GA17958-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Hildenbrand <dahi-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, rusty-8fk3Idey6ehBDgjK7y7TUQ@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, thuth-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 1 Dec 2014 14:34:55 +0200
"Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Mon, Dec 01, 2014 at 01:02:58PM +0100, Cornelia Huck wrote:
> > On Mon, 1 Dec 2014 13:46:45 +0200
> > "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > On Mon, Dec 01, 2014 at 12:33:15PM +0100, Cornelia Huck wrote:
> > > > On Mon, 1 Dec 2014 11:26:58 +0200
> > > > "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > > 
> > > > > For some places on data path, it might be worth it
> > > > > to cache the correct value e.g. as part of device
> > > > > structure. This replaces a branch with a memory load,
> > > > > so the gain would have to be measured, best done
> > > > > separately?
> > > > 
> > > > I think we'll want to do some measuring once the basic structure is
> > > > in place anyway.
> > > 
> > > What's meant by in place here?
> > 
> > That this patchset is ready :)
> 
> Also it's ready to the level where benchmarking is possible, right?  I
> don't think you should wait until we finish polishing up commit
> messages.

My point is that I haven't even found time yet to test this
thouroughly :(
