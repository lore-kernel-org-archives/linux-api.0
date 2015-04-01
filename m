From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/6] virtio_balloon: transitional interface
Date: Wed, 1 Apr 2015 15:01:38 +0200
Message-ID: <20150401150110-mutt-send-email-mst@redhat.com>
References: <1427884468-23930-1-git-send-email-mst@redhat.com>
 <1427884468-23930-2-git-send-email-mst@redhat.com>
 <20150401124539-mutt-send-email-mst@redhat.com>
 <20150401135244.5a8d7ad1.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150401135244.5a8d7ad1.cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cornelia Huck <cornelia.huck-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, virtio-dev-sDuHXQ4OtrM4h7I2RyI4rWD2FQJk+8+b@public.gmane.org, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 01, 2015 at 01:52:44PM +0200, Cornelia Huck wrote:
> On Wed, 1 Apr 2015 12:49:02 +0200
> "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, Apr 01, 2015 at 12:35:45PM +0200, Michael S. Tsirkin wrote:
> > > Virtio 1.0 doesn't include a modern balloon device.
> > > But it's not a big change to support a transitional
> > > balloon device: this has the advantage of supporting
> > > existing drivers, transparently.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  include/uapi/linux/virtio_balloon.h | 11 ++++++++--
> > >  drivers/virtio/virtio_balloon.c     | 43 +++++++++++++++++++++++++++++--------
> > >  2 files changed, 43 insertions(+), 11 deletions(-)
> > 
> > So all in all 32 LOC added, and 9 out of these
> > deal with endian-ness differences.
> > 
> > Seems like a small cost for guests to pay for a clean spec, no?
> > 
> 
> I'm not opposed to this per se, but I'm not totally convinced of the
> usefulness :)
> 
> Seeing the qemu side would be helpful.

Cleaning this up for submission, should be ready RSN.

-- 
MST
