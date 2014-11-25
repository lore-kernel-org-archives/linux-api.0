From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4 09/42] virtio: set FEATURES_OK
Date: Tue, 25 Nov 2014 23:38:23 +0200
Message-ID: <20141125213823.GC22343@redhat.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-10-git-send-email-mst@redhat.com>
	<20141125184811.3191f8db.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20141125184811.3191f8db.cornelia.huck@de.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: rusty@au1.ibm.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 25, 2014 at 06:48:11PM +0100, Cornelia Huck wrote:
> On Tue, 25 Nov 2014 18:42:01 +0200
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > set FEATURES_OK as per virtio 1.0 spec
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  include/uapi/linux/virtio_config.h |  2 ++
> >  drivers/virtio/virtio.c            | 29 ++++++++++++++++++++++-------
> >  2 files changed, 24 insertions(+), 7 deletions(-)
> > 
> 
> > +	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
> > +		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
> > +		status = dev->config->get_status(dev);
> > +		if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> > +			printk(KERN_ERR "virtio: device refuses features: %x\n",
> > +			       status);
> 
> Can you use dev_err() to include the information which device failed?

I'm not sure - is dev_err OK to use from probe?

If yes then sure ...

I guess I'll experiment with this.

> > +			err = -ENODEV;
> > +			goto err;
> > +		}
> > +	}
