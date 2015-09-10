From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH 3/5] update virtio gpu driver: add 3d/virgl support
Date: Thu, 10 Sep 2015 16:45:31 +0200
Message-ID: <1441896331.11233.21.camel@redhat.com>
References: <1441798946-26233-1-git-send-email-kraxel@redhat.com>
	<1441798946-26233-4-git-send-email-kraxel@redhat.com>
	<CACvgo51Y7j0ka46Rfq2eBvXzP4q8Jc6x4j-JrYHDLkH6_xOh7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <CACvgo51Y7j0ka46Rfq2eBvXzP4q8Jc6x4j-JrYHDLkH6_xOh7w@mail.gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "open list:ABI/API" <linux-api@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, ML dri-devel <dri-devel@lists.freedesktop.org>, "open list:VIRTIO GPU DRIVER" <virtualization@lists.linux-foundation.org>, Dave Airlie <airlied@redhat.com>
List-Id: linux-api@vger.kernel.org

  Hi,

> Just a FYI - Daniel Vetter has a series in flight which deprecates
> DRM_UNLOCKED for KMS drivers.

Thanks for the heads up.

> 
> > --- /dev/null
> > +++ b/include/uapi/drm/virtgpu_drm.h
> > @@ -0,0 +1,163 @@
> 
> > +
> > +struct drm_virtgpu_3d_box {
> > +       uint32_t x, y, z;
> > +       uint32_t w, h, d;
> > +};
> > +
> There was a similar case (multiple variables declared on a single
> line) in drm core that caused confusion and we broke the 32bit compat.
> I thought I mention it - not advocating for/against the above declaration.

I highly doubt we'll ever change that.
But we can give each struct field its own row, sure.

> > +struct drm_virtgpu_3d_transfer_to_host {
> > +       uint32_t bo_handle;
> > +       struct drm_virtgpu_3d_box box;
> > +       uint32_t level;
> > +       uint32_t offset;
> > +};
> > +
> > +struct drm_virtgpu_3d_transfer_from_host {
> > +       uint32_t bo_handle;
> > +       struct drm_virtgpu_3d_box box;
> > +       uint32_t level;
> > +       uint32_t offset;
> > +};
> > +
> Afaics these seems to be used by the ioctls. If so the current
> declarations are not 32bit compat safe.

Why?  As long as we have only 32bit fields in the struct the struct
itself gets a 32bit alignment too.  So no layout differences between
32bit and 64bit.

> Things will also go badly if you consider expanding 
> struct drm_virtgpu_3d_box in the distant future.

See above, very unlikely.  And should that really happen we have bigger
problems anyway because it is quite likely that we have to touch the
virtio wire protocol too.

> A u32 pad after bo_handle and a 'pointer' to struct
> drm_virtgpu_3d_box might be the more flexible solution.

IMO this makes things more complicated for no good reason.

cheers,
  Gerd
