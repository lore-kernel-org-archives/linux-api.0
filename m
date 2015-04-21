From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/8] vhost: support for cross endian guests
Date: Tue, 21 Apr 2015 18:24:03 +0200
Message-ID: <20150421182403.690a03a7@bahia.local>
References: <20150410101500.31843.61248.stgit@bahia.local>
	<20150421160954-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150421160954-mutt-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, 21 Apr 2015 16:10:18 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Fri, Apr 10, 2015 at 12:15:00PM +0200, Greg Kurz wrote:
> > Hi,
> > 
> > This patchset allows vhost to be used with legacy virtio when guest and host
> > have a different endianness.
> > 
> > Patch 7 got rewritten according to Cornelia's and Michael's comments. I have
> > also introduced patch 8 that brings BE vnet headers support to tun/macvtap.
> > 
> > This series is enough to have vhost_net working flawlessly. I could
> > succesfully reboot guests from ppc64 to ppc64le and vice-versa on ppc64
> > and ppc64le hosts.
> 
> Looks good overall.
> A couple of style comments.
> 
> Thanks!
> 

Thanks for your time Michael.

> > ---
> > 
> > Greg Kurz (8):
> >       virtio: introduce virtio_is_little_endian() helper
> >       tun: add tun_is_little_endian() helper
> >       macvtap: introduce macvtap_is_little_endian() helper
> >       vringh: introduce vringh_is_little_endian() helper
> >       vhost: introduce vhost_is_little_endian() helper
> >       virtio: add explicit big-endian support to memory accessors
> >       vhost: feature to set the vring endianness
> >       macvtap/tun: add VNET_BE flag
> > 
> > 
> >  drivers/net/Kconfig              |   12 ++++++
> >  drivers/net/macvtap.c            |   69 ++++++++++++++++++++++++++++++++++-
> >  drivers/net/tun.c                |   71 +++++++++++++++++++++++++++++++++++-
> >  drivers/vhost/Kconfig            |   10 +++++
> >  drivers/vhost/vhost.c            |   76 ++++++++++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost.h            |   25 ++++++++++---
> >  include/linux/virtio_byteorder.h |   24 +++++++-----
> >  include/linux/virtio_config.h    |   19 +++++++---
> >  include/linux/vringh.h           |   19 +++++++---
> >  include/uapi/linux/if_tun.h      |    2 +
> >  include/uapi/linux/vhost.h       |    9 +++++
> >  11 files changed, 303 insertions(+), 33 deletions(-)
> > 
> > --
> > Greg
> 
