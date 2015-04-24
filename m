From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v5 7/8] vhost: cross-endian support for legacy devices
Date: Fri, 24 Apr 2015 10:09:16 +0200
Message-ID: <20150424100916.3d18d12c.cornelia.huck@de.ibm.com>
References: <20150423152608.11795.4373.stgit@bahia.local>
	<20150423152915.11795.13921.stgit@bahia.local>
	<20150424091926.1f5dee0b.cornelia.huck@de.ibm.com>
	<20150424100619.665e8bf8@bahia.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20150424100619.665e8bf8@bahia.local>
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

On Fri, 24 Apr 2015 10:06:19 +0200
Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

> On Fri, 24 Apr 2015 09:19:26 +0200
> Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> 
> > On Thu, 23 Apr 2015 17:29:42 +0200
> > Greg Kurz <gkurz@linux.vnet.ibm.com> wrote:

> > > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > > index bb6a5b4..b980b53 100644
> > > --- a/include/uapi/linux/vhost.h
> > > +++ b/include/uapi/linux/vhost.h
> > > @@ -103,6 +103,18 @@ struct vhost_memory {
> > >  /* Get accessor: reads index, writes value in num */
> > >  #define VHOST_GET_VRING_BASE _IOWR(VHOST_VIRTIO, 0x12, struct vhost_vring_state)
> > > 
> > > +/* Set the vring byte order in num. Valid values are VHOST_VRING_LITTLE_ENDIAN
> > > + * or VHOST_VRING_BIG_ENDIAN (other values return EINVAL).
> > 
> > -EINVAL?
> > 
> 
> Oops, yes. :)
> 
> > Should you also mention when you return -EBUSY?
> > 
> 
> Indeed... what about:
> 
> "The byte order cannot be changed when the device is active: trying to do so
> returns -EBUSY."

s/when/while/ ?

But sounds good.
