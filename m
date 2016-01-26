From: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: Re: [PATCH v1 1/3] media: v4l: Add VP8 format support in V4L2
 framework
Date: Tue, 26 Jan 2016 18:53:33 -0500
Message-ID: <1453852413.5584.15.camel@collabora.com>
References: <1453799046-307-1-git-send-email-jung.zhao@rock-chips.com>
	 <1453799046-307-2-git-send-email-jung.zhao@rock-chips.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-lffQv4S1oUc8jo+dSthu"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1453799046-307-2-git-send-email-jung.zhao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jung Zhao <jung.zhao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, pawel-FA/gS7QP4orQT0dZR+AlfA@public.gmane.org, m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kyungmin.park-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org
Cc: linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, herman.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org, alpha.lin-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Benoit Parrot <bparrot-l0cyMroinI0@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sakari Ailus <sakari.ailus-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ricardo Ribalda Delgado <ricardo.ribalda-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org


--=-lffQv4S1oUc8jo+dSthu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jung,

this patch adds new public API to videodev2.h. It would be appropriate
to also add the associated documentation for it (see Documentation/DocBook/=
media). I also believe there is multiple way VP8 support could have been ad=
ded. A proper commit message that explains the approach would also be appro=
priate.

cheers,
Nicolas

Le mardi 26 janvier 2016 =C3=A0 17:04 +0800, Jung Zhao a =C3=A9crit=C2=A0:
> From: zhaojun <jung.zhao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
>=20
> Signed-off-by: zhaojun <jung.zhao-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
>=20
> =C2=A0drivers/media/v4l2-core/v4l2-ctrls.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 17 ++++-
> =C2=A0drivers/media/v4l2-core/v4l2-ioctl.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A03 +
> =C2=A0drivers/media/v4l2-core/videobuf2-dma-contig.c | 51 +++++++++-----
> =C2=A0include/media/v4l2-ctrls.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A02 +
> =C2=A0include/media/videobuf2-dma-contig.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 11 ++-
> =C2=A0include/uapi/linux/v4l2-controls.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 98
> ++++++++++++++++++++++++++
> =C2=A0include/uapi/linux/videodev2.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=
=C2=A05 ++
> =C2=A07 files changed, 166 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c
> index 890520d..22821e94 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -761,7 +761,7 @@ const char *v4l2_ctrl_get_name(u32 id)
> =C2=A0	case V4L2_CID_MPEG_VIDEO_VPX_I_FRAME_QP:		retu
> rn "VPX I-Frame QP Value";
> =C2=A0	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		retu
> rn "VPX P-Frame QP Value";
> =C2=A0	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:		=09
> return "VPX Profile";
> -
> +	case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:		=09
> return "VP8 Frame Header";
> =C2=A0	/* CAMERA controls */
> =C2=A0	/* Keep the order of the 'case's the same as in v4l2-
> controls.h! */
> =C2=A0	case V4L2_CID_CAMERA_CLASS:		return "Camera
> Controls";
> @@ -1126,6 +1126,9 @@ void v4l2_ctrl_fill(u32 id, const char **name,
> enum v4l2_ctrl_type *type,
> =C2=A0	case V4L2_CID_RDS_TX_ALT_FREQS:
> =C2=A0		*type =3D V4L2_CTRL_TYPE_U32;
> =C2=A0		break;
> +	case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:
> +		*type =3D V4L2_CTRL_TYPE_VP8_FRAME_HDR;
> +		break;
> =C2=A0	default:
> =C2=A0		*type =3D V4L2_CTRL_TYPE_INTEGER;
> =C2=A0		break;
> @@ -1525,6 +1528,13 @@ static int std_validate(const struct v4l2_ctrl
> *ctrl, u32 idx,
> =C2=A0			return -ERANGE;
> =C2=A0		return 0;
> =C2=A0
> +	/* FIXME:just return 0 for now */
> +	case V4L2_CTRL_TYPE_PRIVATE:
> +		return 0;
> +
> +	case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
> +		return 0;
> +
> =C2=A0	default:
> =C2=A0		return -EINVAL;
> =C2=A0	}
> @@ -2074,6 +2084,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> v4l2_ctrl_handler *hdl,
> =C2=A0	case V4L2_CTRL_TYPE_U32:
> =C2=A0		elem_size =3D sizeof(u32);
> =C2=A0		break;
> +	case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
> +		elem_size =3D sizeof(struct v4l2_ctrl_vp8_frame_hdr);
> +		break;
> =C2=A0	default:
> =C2=A0		if (type < V4L2_CTRL_COMPOUND_TYPES)
> =C2=A0			elem_size =3D sizeof(s32);
> @@ -2098,7 +2111,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> v4l2_ctrl_handler *hdl,
> =C2=A0		handler_set_err(hdl, -ERANGE);
> =C2=A0		return NULL;
> =C2=A0	}
> -	if (is_array &&
> +	if ((is_array || (flags & V4L2_CTRL_FLAG_REQ_KEEP)) &&
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0(type =3D=3D V4L2_CTRL_TYPE_BUTTON ||
> =C2=A0	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0type =3D=3D V4L2_CTRL_TYPE_CTRL_CLAS=
S)) {
> =C2=A0		handler_set_err(hdl, -EINVAL);
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c
> b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 7d028d1..8aa5812 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1259,6 +1259,9 @@ static void v4l_fill_fmtdesc(struct
> v4l2_fmtdesc *fmt)
> =C2=A0		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr =3D "VC-1
> (SMPTE 412M Annex G)"; break;
> =C2=A0		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr =3D "VC-1
> (SMPTE 412M Annex L)"; break;
> =C2=A0		case V4L2_PIX_FMT_VP8:		descr =3D "VP8";
> break;
> +		case V4L2_PIX_FMT_VP8_FRAME:
> +			descr =3D "VP8 FRAME";
> +			break;
> =C2=A0		case V4L2_PIX_FMT_CPIA1:	descr =3D "GSPCA CPiA
> YUV"; break;
> =C2=A0		case V4L2_PIX_FMT_WNVA:		descr =3D
> "WNVA"; break;
> =C2=A0		case V4L2_PIX_FMT_SN9C10X:	descr =3D "GSPCA
> SN9C10X"; break;
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index c331272..aebcc7f 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -23,13 +23,16 @@
> =C2=A0
> =C2=A0struct vb2_dc_conf {
> =C2=A0	struct device		*dev;
> +	struct dma_attrs	attrs;
> =C2=A0};
> =C2=A0
> =C2=A0struct vb2_dc_buf {
> =C2=A0	struct device			*dev;
> =C2=A0	void				*vaddr;
> =C2=A0	unsigned long			size;
> +	void				*cookie;
> =C2=A0	dma_addr_t			dma_addr;
> +	struct dma_attrs		attrs;
> =C2=A0	enum dma_data_direction		dma_dir;
> =C2=A0	struct sg_table			*dma_sgt;
> =C2=A0	struct frame_vector		*vec;
> @@ -131,7 +134,8 @@ static void vb2_dc_put(void *buf_priv)
> =C2=A0		sg_free_table(buf->sgt_base);
> =C2=A0		kfree(buf->sgt_base);
> =C2=A0	}
> -	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf-
> >dma_addr);
> +	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf-
> >dma_addr,
> +			&buf->attrs);
> =C2=A0	put_device(buf->dev);
> =C2=A0	kfree(buf);
> =C2=A0}
> @@ -143,18 +147,22 @@ static void *vb2_dc_alloc(void *alloc_ctx,
> unsigned long size,
> =C2=A0	struct device *dev =3D conf->dev;
> =C2=A0	struct vb2_dc_buf *buf;
> =C2=A0
> -	buf =3D kzalloc(sizeof *buf, GFP_KERNEL);
> +	buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
> =C2=A0	if (!buf)
> =C2=A0		return ERR_PTR(-ENOMEM);
> =C2=A0
> -	buf->vaddr =3D dma_alloc_coherent(dev, size, &buf->dma_addr,
> -						GFP_KERNEL |
> gfp_flags);
> -	if (!buf->vaddr) {
> +	buf->attrs =3D conf->attrs;
> +	buf->cookie =3D dma_alloc_attrs(dev, size, &buf->dma_addr,
> +					GFP_KERNEL | gfp_flags,
> &buf->attrs);
> +	if (!buf->cookie) {
> =C2=A0		dev_err(dev, "dma_alloc_coherent of size %ld
> failed\n", size);
> =C2=A0		kfree(buf);
> =C2=A0		return ERR_PTR(-ENOMEM);
> =C2=A0	}
> =C2=A0
> +	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->attrs))
> +		buf->vaddr =3D buf->cookie;
> +
> =C2=A0	/* Prevent the device from being released while the buffer
> is used */
> =C2=A0	buf->dev =3D get_device(dev);
> =C2=A0	buf->size =3D size;
> @@ -185,8 +193,8 @@ static int vb2_dc_mmap(void *buf_priv, struct
> vm_area_struct *vma)
> =C2=A0	=C2=A0*/
> =C2=A0	vma->vm_pgoff =3D 0;
> =C2=A0
> -	ret =3D dma_mmap_coherent(buf->dev, vma, buf->vaddr,
> -		buf->dma_addr, buf->size);
> +	ret =3D dma_mmap_attrs(buf->dev, vma, buf->cookie,
> +		buf->dma_addr, buf->size, &buf->attrs);
> =C2=A0
> =C2=A0	if (ret) {
> =C2=A0		pr_err("Remapping memory failed, error: %d\n", ret);
> @@ -329,7 +337,7 @@ static void *vb2_dc_dmabuf_ops_kmap(struct
> dma_buf *dbuf, unsigned long pgnum)
> =C2=A0{
> =C2=A0	struct vb2_dc_buf *buf =3D dbuf->priv;
> =C2=A0
> -	return buf->vaddr + pgnum * PAGE_SIZE;
> +	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
> =C2=A0}
> =C2=A0
> =C2=A0static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
> @@ -368,8 +376,8 @@ static struct sg_table
> *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
> =C2=A0		return NULL;
> =C2=A0	}
> =C2=A0
> -	ret =3D dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf-
> >dma_addr,
> -		buf->size);
> +	ret =3D dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf-
> >dma_addr,
> +		buf->size, &buf->attrs);
> =C2=A0	if (ret < 0) {
> =C2=A0		dev_err(buf->dev, "failed to get scatterlist from
> DMA API\n");
> =C2=A0		kfree(sgt);
> @@ -448,22 +456,26 @@ static void vb2_dc_put_userptr(void *buf_priv)
> =C2=A0 */
> =C2=A0
> =C2=A0#ifdef __arch_pfn_to_dma
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> unsigned long pfn)
> +static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> +					=C2=A0=C2=A0=C2=A0unsigned long pfn)
> =C2=A0{
> =C2=A0	return (dma_addr_t)__arch_pfn_to_dma(dev, pfn);
> =C2=A0}
> =C2=A0#elif defined(__pfn_to_bus)
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> unsigned long pfn)
> +static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> +					=C2=A0=C2=A0=C2=A0unsigned long pfn)
> =C2=A0{
> =C2=A0	return (dma_addr_t)__pfn_to_bus(pfn);
> =C2=A0}
> =C2=A0#elif defined(__pfn_to_phys)
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> unsigned long pfn)
> +static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> +					=C2=A0=C2=A0=C2=A0unsigned long pfn)
> =C2=A0{
> =C2=A0	return (dma_addr_t)__pfn_to_phys(pfn);
> =C2=A0}
> =C2=A0#else
> -static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> unsigned long pfn)
> +static inline dma_addr_t vb2_dc_pfn_to_dma(struct device *dev,
> +					=C2=A0=C2=A0=C2=A0unsigned long pfn)
> =C2=A0{
> =C2=A0	/* really, we cannot do anything better at this point */
> =C2=A0	return (dma_addr_t)(pfn) << PAGE_SHIFT;
> @@ -497,7 +509,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr,
> =C2=A0		return ERR_PTR(-EINVAL);
> =C2=A0	}
> =C2=A0
> -	buf =3D kzalloc(sizeof *buf, GFP_KERNEL);
> +	buf =3D kzalloc(sizeof(*buf), GFP_KERNEL);
> =C2=A0	if (!buf)
> =C2=A0		return ERR_PTR(-ENOMEM);
> =C2=A0
> @@ -721,19 +733,22 @@ const struct vb2_mem_ops vb2_dma_contig_memops
> =3D {
> =C2=A0};
> =C2=A0EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
> =C2=A0
> -void *vb2_dma_contig_init_ctx(struct device *dev)
> +void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
> +				=C2=A0=C2=A0=C2=A0=C2=A0struct dma_attrs *attrs)
> =C2=A0{
> =C2=A0	struct vb2_dc_conf *conf;
> =C2=A0
> -	conf =3D kzalloc(sizeof *conf, GFP_KERNEL);
> +	conf =3D kzalloc(sizeof(*conf), GFP_KERNEL);
> =C2=A0	if (!conf)
> =C2=A0		return ERR_PTR(-ENOMEM);
> =C2=A0
> =C2=A0	conf->dev =3D dev;
> +	if (attrs)
> +		conf->attrs =3D *attrs;
> =C2=A0
> =C2=A0	return conf;
> =C2=A0}
> -EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
> +EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx_attrs);
> =C2=A0
> =C2=A0void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
> =C2=A0{
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 5f9526f..0424cdc 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -46,6 +46,7 @@ struct poll_table_struct;
> =C2=A0 * @p_u16:	Pointer to a 16-bit unsigned value.
> =C2=A0 * @p_u32:	Pointer to a 32-bit unsigned value.
> =C2=A0 * @p_char:	Pointer to a string.
> + * @p_vp8_frame_hdr:	Pointer to a struct
> v4l2_ctrl_vp8_frame_hdr.
> =C2=A0 * @p:		Pointer to a compound value.
> =C2=A0 */
> =C2=A0union v4l2_ctrl_ptr {
> @@ -55,6 +56,7 @@ union v4l2_ctrl_ptr {
> =C2=A0	u16 *p_u16;
> =C2=A0	u32 *p_u32;
> =C2=A0	char *p_char;
> +	struct v4l2_ctrl_vp8_frame_hdr *p_vp8_frame_hdr;
> =C2=A0	void *p;
> =C2=A0};
> =C2=A0
> diff --git a/include/media/videobuf2-dma-contig.h
> b/include/media/videobuf2-dma-contig.h
> index c33dfa6..2087c9a 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -16,6 +16,8 @@
> =C2=A0#include <media/videobuf2-v4l2.h>
> =C2=A0#include <linux/dma-mapping.h>
> =C2=A0
> +struct dma_attrs;
> +
> =C2=A0static inline dma_addr_t
> =C2=A0vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int
> plane_no)
> =C2=A0{
> @@ -24,7 +26,14 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer
> *vb, unsigned int plane_no)
> =C2=A0	return *addr;
> =C2=A0}
> =C2=A0
> -void *vb2_dma_contig_init_ctx(struct device *dev);
> +void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
> +				=C2=A0=C2=A0=C2=A0=C2=A0struct dma_attrs *attrs);
> +
> +static inline void *vb2_dma_contig_init_ctx(struct device *dev)
> +{
> +	return vb2_dma_contig_init_ctx_attrs(dev, NULL);
> +}
> +
> =C2=A0void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
> =C2=A0
> =C2=A0extern const struct vb2_mem_ops vb2_dma_contig_memops;
> diff --git a/include/uapi/linux/v4l2-controls.h
> b/include/uapi/linux/v4l2-controls.h
> index 2d225bc..63c65d9 100644
> --- a/include/uapi/linux/v4l2-controls.h
> +++ b/include/uapi/linux/v4l2-controls.h
> @@ -520,6 +520,7 @@ enum
> v4l2_mpeg_video_h264_hierarchical_coding_type {
> =C2=A0};
> =C2=A0#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V
> 4L2_CID_MPEG_BASE+381)
> =C2=A0#define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP=09
> (V4L2_CID_MPEG_BASE+382)
> +
> =C2=A0#define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_B
> ASE+400)
> =C2=A0#define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_B
> ASE+401)
> =C2=A0#define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_B
> ASE+402)
> @@ -578,6 +579,8 @@ enum v4l2_vp8_golden_frame_sel {
> =C2=A0#define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_
> MPEG_BASE+510)
> =C2=A0#define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2
> _CID_MPEG_BASE+511)
> =C2=A0
> +#define V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR		(V4L2_CID_M
> PEG_BASE+512)
> +
> =C2=A0/*=C2=A0=C2=A0MPEG-class control IDs specific to the CX2341x driver=
 as defined
> by V4L2 */
> =C2=A0#define V4L2_CID_MPEG_CX2341X_BASE=C2=A0				(
> V4L2_CTRL_CLASS_MPEG | 0x1000)
> =C2=A0#define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE=C2=A0	(V4L
> 2_CID_MPEG_CX2341X_BASE+0)
> @@ -963,4 +966,99 @@ enum v4l2_detect_md_mode {
> =C2=A0#define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CL
> ASS_BASE + 3)
> =C2=A0#define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETE
> CT_CLASS_BASE + 4)
> =C2=A0
> +
> +/* Complex controls */
> +
> +#define V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x01
> +#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_MAP=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00x02
> +#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_FEATURE_DATA=C2=A0=C2=A00x04
> +struct v4l2_vp8_sgmnt_hdr {
> +	__u8 segment_feature_mode;
> +
> +	__s8 quant_update[4];
> +	__s8 lf_update[4];
> +	__u8 segment_probs[3];
> +
> +	__u8 flags;
> +};
> +
> +#define V4L2_VP8_LF_HDR_ADJ_ENABLE	0x01
> +#define V4L2_VP8_LF_HDR_DELTA_UPDATE	0x02
> +struct v4l2_vp8_loopfilter_hdr {
> +	__u8 type;
> +	__u8 level;
> +	__u8 sharpness_level;
> +	__s8 ref_frm_delta_magnitude[4];
> +	__s8 mb_mode_delta_magnitude[4];
> +
> +	__u8 flags;
> +};
> +
> +struct v4l2_vp8_quantization_hdr {
> +	__u8 y_ac_qi;
> +	__s8 y_dc_delta;
> +	__s8 y2_dc_delta;
> +	__s8 y2_ac_delta;
> +	__s8 uv_dc_delta;
> +	__s8 uv_ac_delta;
> +	__u16 dequant_factors[4][3][2];
> +};
> +
> +struct v4l2_vp8_entropy_hdr {
> +	__u8 coeff_probs[4][8][3][11];
> +	__u8 y_mode_probs[4];
> +	__u8 uv_mode_probs[3];
> +	__u8 mv_probs[2][19];
> +};
> +
> +#define V4L2_VP8_FRAME_HDR_FLAG_EXPERIMENTAL		0x01
> +#define V4L2_VP8_FRAME_HDR_FLAG_SHOW_FRAME		0x02
> +#define V4L2_VP8_FRAME_HDR_FLAG_MB_NO_SKIP_COEFF	0x04
> +struct v4l2_ctrl_vp8_frame_hdr {
> +	/* 0: keyframe, 1: not a keyframe */
> +	__u8 key_frame;
> +	__u8 version;
> +
> +	/* Populated also if not a key frame */
> +	__u16 width;
> +	__u8 horizontal_scale;
> +	__u16 height;
> +	__u8 vertical_scale;
> +
> +	struct v4l2_vp8_sgmnt_hdr sgmnt_hdr;
> +	struct v4l2_vp8_loopfilter_hdr lf_hdr;
> +	struct v4l2_vp8_quantization_hdr quant_hdr;
> +	struct v4l2_vp8_entropy_hdr entropy_hdr;
> +
> +	__u8 sign_bias_golden;
> +	__u8 sign_bias_alternate;
> +
> +	__u8 prob_skip_false;
> +	__u8 prob_intra;
> +	__u8 prob_last;
> +	__u8 prob_gf;
> +
> +	__u32 first_part_size;
> +	__u32 first_part_offset;
> +	/*
> +	=C2=A0* Offset in bits of MB data in first partition,
> +	=C2=A0* i.e. bit offset starting from first_part_offset.
> +	=C2=A0*/
> +	__u32 macroblock_bit_offset;
> +
> +	__u8 num_dct_parts;
> +	__u32 dct_part_sizes[8];
> +
> +	__u8 bool_dec_range;
> +	__u8 bool_dec_value;
> +	__u8 bool_dec_count;
> +
> +	/* v4l2_buffer indices of reference frames */
> +	__u32 last_frame;
> +	__u32 golden_frame;
> +	__u32 alt_frame;
> +
> +	__u8 flags;
> +};
> +
> =C2=A0#endif
> diff --git a/include/uapi/linux/videodev2.h
> b/include/uapi/linux/videodev2.h
> index 29a6b78..191ca19 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -593,6 +593,7 @@ struct v4l2_pix_format {
> =C2=A0#define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /*
> SMPTE 421M Annex G compliant stream */
> =C2=A0#define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /*
> SMPTE 421M Annex L compliant stream */
> =C2=A0#define V4L2_PIX_FMT_VP8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0v4l2_fo=
urcc('V', 'P', '8', '0') /* VP8
> */
> +#define V4L2_PIX_FMT_VP8_FRAME	v4l2_fourcc('V', 'P', '8',
> 'F') /* VP8 parsed frames */
> =C2=A0
> =C2=A0/*=C2=A0=C2=A0Vendor-specific formats=C2=A0=C2=A0=C2=A0*/
> =C2=A0#define V4L2_PIX_FMT_CPIA1=C2=A0=C2=A0=C2=A0=C2=A0v4l2_fourcc('C', =
'P', 'I', 'A') /*
> cpia1 YUV */
> @@ -1473,6 +1474,7 @@ struct v4l2_ext_control {
> =C2=A0		__u8 __user *p_u8;
> =C2=A0		__u16 __user *p_u16;
> =C2=A0		__u32 __user *p_u32;
> +		struct v4l2_ctrl_vp8_frame_hdr __user
> *p_vp8_frame_hdr;
> =C2=A0		void __user *ptr;
> =C2=A0	};
> =C2=A0} __attribute__ ((packed));
> @@ -1517,6 +1519,9 @@ enum v4l2_ctrl_type {
> =C2=A0	V4L2_CTRL_TYPE_U8	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0x0100,
> =C2=A0	V4L2_CTRL_TYPE_U16	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0x0101,
> =C2=A0	V4L2_CTRL_TYPE_U32	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0x0102,
> +	V4L2_CTRL_TYPE_VP8_FRAME_HDR	=3D 0x108,
> +
> +	V4L2_CTRL_TYPE_PRIVATE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=3D 0xf=
fff,
> =C2=A0};
> =C2=A0
> =C2=A0/*=C2=A0=C2=A0Used in the VIDIOC_QUERYCTRL ioctl for querying contr=
ols */
--=-lffQv4S1oUc8jo+dSthu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaoBv0ACgkQcVMCLawGqBzj9wCdH4ghlvs5FYE8GKAdp2cvxHl3
mHcAoIl8IR/iidbwpH8o2mDRLdI40rqG
=Eml1
-----END PGP SIGNATURE-----

--=-lffQv4S1oUc8jo+dSthu--
