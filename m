From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v4 7/8] vhost: feature to set the vring endianness
Date: Tue, 14 Apr 2015 17:22:07 +0200
Message-ID: <20150414172207.4d872643.cornelia.huck@de.ibm.com>
References: <20150410101500.31843.61248.stgit@bahia.local>
	<20150410101627.31843.21710.stgit@bahia.local>
	<20150414162023.2f8694fe.cornelia.huck@de.ibm.com>
	<20150414171352.105909ae@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150414171352.105909ae@bahia.local>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Greg Kurz <gkurz@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, 14 Apr 2015 17:13:52 +0200
Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

> On Tue, 14 Apr 2015 16:20:23 +0200
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > On Fri, 10 Apr 2015 12:19:16 +0200
> > Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

> > 
> > > +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> > > +static void vhost_init_is_le(struct vhost_virtqueue *vq)
> > > +{
> > > +	vq->is_le = vhost_has_feature(vq, VIRTIO_F_VERSION_1) || !vq->user_be;
> > 
> > So if the endianness is not explicitly set to BE, it will be forced to
> > LE (instead of native endian)? Won't that break userspace that does not
> > yet use the new interface when CONFIG_VHOST_SET_ENDIAN_LEGACY is set?
> > 
> 
> If userspace doesn't use the new interface, then vq->user_be will retain its
> default value that was set in vhost_vq_reset(), i.e. :
> 
>  vq->user_be = !virtio_legacy_is_little_endian();
> 
> This means default is native endian.
> 
> What about adding this comment ?
> 
> static void vhost_init_is_le(struct vhost_virtqueue *vq)
> {
> 	/* Note for legacy virtio: user_be is initialized in vhost_vq_reset()
> 	 * according to the host endianness. If userspace does not set an
> 	 * explicit endianness, the default behavior is native endian, as
> 	 * expected by legacy virtio.
> 	 */

Good idea, as this is easy to miss.

> 	vq->is_le = vhost_has_feature(vq, VIRTIO_F_VERSION_1) || !vq->user_be;
> }
> 
> > > +}
> > > +#else
> > > +static void vhost_init_is_le(struct vhost_virtqueue *vq)
> > > +{
> > > +	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> > > +		vq->is_le = true;
> > > +}
> > > +#endif
> > > +
> > >  int vhost_init_used(struct vhost_virtqueue *vq)
> > >  {
> > >  	__virtio16 last_used_idx;
> > >  	int r;
> > > -	if (!vq->private_data)
> > > +	if (!vq->private_data) {
> > > +		vq->is_le = virtio_legacy_is_little_endian();
> > >  		return 0;
> > > +	}
> > > +
> > > +	vhost_init_is_le(vq);
> > > 
> > >  	r = vhost_update_used_flags(vq);
> > >  	if (r)
> 
