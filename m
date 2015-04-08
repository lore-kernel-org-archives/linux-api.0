From: Greg Kurz <gkurz@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 7/7] vhost: feature to set the vring endianness
Date: Wed, 8 Apr 2015 09:36:38 +0200
Message-ID: <20150408093638.7a233137@bahia.local>
References: <20150407120929.4213.8225.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
	<20150407121557.4213.95569.stgit@bahia.lab.toulouse-stg.fr.ibm.com>
	<20150407170131.3899d62c.cornelia.huck@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150407170131.3899d62c.cornelia.huck@de.ibm.com>
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
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-api@vger.kernel.org

On Tue, 7 Apr 2015 17:01:31 +0200
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> On Tue, 07 Apr 2015 14:19:31 +0200
> Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:
> 
> > This patch brings cross-endian support to vhost when used to implement
> > legacy virtio devices. Since it is a relatively rare situation, the
> > feature availability is controlled by a kernel config option (not set
> > by default).
> > 
> > The ioctls introduced by this patch are for legacy only: virtio 1.0
> > devices are returned EPERM.
> > 
> > Signed-off-by: Greg Kurz <gkurz@linux.vnet.ibm.com>
> > ---
> >  drivers/vhost/Kconfig      |   10 ++++++++
> >  drivers/vhost/vhost.c      |   55 ++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/vhost/vhost.h      |   17 +++++++++++++-
> >  include/uapi/linux/vhost.h |    5 ++++
> >  4 files changed, 86 insertions(+), 1 deletion(-)
> 
> > +#ifdef CONFIG_VHOST_SET_ENDIAN_LEGACY
> > +static long vhost_set_vring_endian_legacy(struct vhost_virtqueue *vq,
> > +					  void __user *argp)
> > +{
> > +	struct vhost_vring_state s;
> > +
> > +	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> > +		return -EPERM;
> > +
> > +	if (copy_from_user(&s, argp, sizeof(s)))
> > +		return -EFAULT;
> > +
> > +	vq->legacy_is_little_endian = !!s.num;
> > +	return 0;
> > +}
> > +
> > +static long vhost_get_vring_endian_legacy(struct vhost_virtqueue *vq,
> > +					  u32 idx,
> > +					  void __user *argp)
> > +{
> > +	struct vhost_vring_state s = {
> > +		.index = idx,
> > +		.num = vq->legacy_is_little_endian
> > +	};
> > +
> > +	if (vhost_has_feature(vq, VIRTIO_F_VERSION_1))
> > +		return -EPERM;
> > +
> > +	if (copy_to_user(argp, &s, sizeof(s)))
> > +		return -EFAULT;
> > +
> > +	return 0;
> > +}
> > +#else
> > +static long vhost_set_vring_endian_legacy(struct vhost_virtqueue *vq,
> > +					  void __user *argp)
> > +{
> > +	return 0;
> 
> I'm wondering whether this handler should return an error if the
> feature is not configured for the kernel? How can the userspace caller
> find out whether it has successfully prompted the kernel to handle the
> endianness correctly?
> 

Yes you're right. I think -ENOIOCTLCMD as suggested by Michael is a good
candidate.

Thanks.

> > +}
> > +
> > +static long vhost_get_vring_endian_legacy(struct vhost_virtqueue *vq,
> > +					  u32 idx,
> > +					  void __user *argp)
> > +{
> > +	return 0;
> > +}
> > +#endif /* CONFIG_VHOST_SET_ENDIAN_LEGACY */
