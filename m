From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v3 1/6] virtio_balloon: transitional interface
Date: Wed, 1 Apr 2015 13:52:44 +0200
Message-ID: <20150401135244.5a8d7ad1.cornelia.huck@de.ibm.com>
References: <1427884468-23930-1-git-send-email-mst@redhat.com>
	<1427884468-23930-2-git-send-email-mst@redhat.com>
	<20150401124539-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <virtio-dev-return-727-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <20150401124539-mutt-send-email-mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>, virtio-dev@lists.oasis-open.org, Rusty Russell <rusty@rustcorp.com.au>, virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 1 Apr 2015 12:49:02 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Apr 01, 2015 at 12:35:45PM +0200, Michael S. Tsirkin wrote:
> > Virtio 1.0 doesn't include a modern balloon device.
> > But it's not a big change to support a transitional
> > balloon device: this has the advantage of supporting
> > existing drivers, transparently.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/uapi/linux/virtio_balloon.h | 11 ++++++++--
> >  drivers/virtio/virtio_balloon.c     | 43 +++++++++++++++++++++++++++++--------
> >  2 files changed, 43 insertions(+), 11 deletions(-)
> 
> So all in all 32 LOC added, and 9 out of these
> deal with endian-ness differences.
> 
> Seems like a small cost for guests to pay for a clean spec, no?
> 

I'm not opposed to this per se, but I'm not totally convinced of the
usefulness :)

Seeing the qemu side would be helpful.
