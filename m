From: "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/6] virtio-gpu: add 3d/virgl support
Date: Mon, 21 Sep 2015 13:15:00 +0300
Message-ID: <20150921130110-mutt-send-email-mst@redhat.com>
References: <1442828417-6165-1-git-send-email-kraxel@redhat.com>
 <1442828417-6165-5-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442828417-6165-5-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:VIRTIO GPU DRIVER" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:VIRTIO GPU DRIVER" <virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Sep 21, 2015 at 11:40:15AM +0200, Gerd Hoffmann wrote:
> Add the bits needed for opengl rendering support: query
> capabilities, new virtio commands, drm ioctls.
> 
> Signed-off-by: Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Looks good to me overall.
Some minor comments below.

I had to fix dri-devel mailing list address.
Hope I did it correctly.


> ---
>  drivers/gpu/drm/virtio/Makefile        |   3 +-
>  drivers/gpu/drm/virtio/virtgpu_drv.c   |  10 +
>  drivers/gpu/drm/virtio/virtgpu_drv.h   |  60 ++++
>  drivers/gpu/drm/virtio/virtgpu_gem.c   |  41 +++
>  drivers/gpu/drm/virtio/virtgpu_ioctl.c | 572 +++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/virtio/virtgpu_kms.c   | 135 +++++++-
>  drivers/gpu/drm/virtio/virtgpu_ttm.c   |   1 +
>  drivers/gpu/drm/virtio/virtgpu_vq.c    | 265 +++++++++++++++
>  include/uapi/drm/Kbuild                |   1 +
>  include/uapi/drm/virtgpu_drm.h         | 167 ++++++++++
>  include/uapi/linux/virtio_gpu.h        | 112 ++++++-
>  11 files changed, 1364 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/gpu/drm/virtio/virtgpu_ioctl.c
>  create mode 100644 include/uapi/drm/virtgpu_drm.h
> 
> diff --git a/drivers/gpu/drm/virtio/Makefile b/drivers/gpu/drm/virtio/Makefile
> index 2ee1602..da7bf19 100644
> --- a/drivers/gpu/drm/virtio/Makefile
> +++ b/drivers/gpu/drm/virtio/Makefile
> @@ -6,6 +6,7 @@ ccflags-y := -Iinclude/drm
>  
>  virtio-gpu-y := virtgpu_drv.o virtgpu_kms.o virtgpu_drm_bus.o virtgpu_gem.o \
>  	virtgpu_fb.o virtgpu_display.o virtgpu_vq.o virtgpu_ttm.o \
> -	virtgpu_fence.o virtgpu_object.o virtgpu_debugfs.o virtgpu_plane.o
> +	virtgpu_fence.o virtgpu_object.o virtgpu_debugfs.o virtgpu_plane.o \
> +	virtgpu_ioctl.o
>  
>  obj-$(CONFIG_DRM_VIRTIO_GPU) += virtio-gpu.o
> diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.c b/drivers/gpu/drm/virtio/virtgpu_drv.c
> index 7d9610a..957e455 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_drv.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_drv.c
> @@ -73,6 +73,9 @@ static struct virtio_device_id id_table[] = {
>  };
>  
>  static unsigned int features[] = {
> +#ifdef __LITTLE_ENDIAN
> +	VIRTIO_GPU_FEATURE_VIRGL,
> +#endif
>  };

Why is virgl LE specific? Just curious.

>  static struct virtio_driver virtio_gpu_driver = {
>  	.feature_table = features,
> @@ -114,6 +117,8 @@ static struct drm_driver driver = {
>  	.set_busid = drm_virtio_set_busid,
>  	.load = virtio_gpu_driver_load,
>  	.unload = virtio_gpu_driver_unload,
> +	.open = virtio_gpu_driver_open,
> +	.postclose = virtio_gpu_driver_postclose,
>  
>  	.dumb_create = virtio_gpu_mode_dumb_create,
>  	.dumb_map_offset = virtio_gpu_mode_dumb_mmap,
> @@ -125,8 +130,13 @@ static struct drm_driver driver = {
>  #endif
>  
>  	.gem_free_object = virtio_gpu_gem_free_object,
> +	.gem_open_object = virtio_gpu_gem_object_open,
> +	.gem_close_object = virtio_gpu_gem_object_close,
>  	.fops = &virtio_gpu_driver_fops,
>  
> +	.ioctls = virtio_gpu_ioctls,
> +	.num_ioctls = DRM_VIRTIO_NUM_IOCTLS,
> +
>  	.name = DRIVER_NAME,
>  	.desc = DRIVER_DESC,
>  	.date = DRIVER_DATE,
> diff --git a/drivers/gpu/drm/virtio/virtgpu_drv.h b/drivers/gpu/drm/virtio/virtgpu_drv.h
> index 6d4db2d..2719108 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_drv.h
> +++ b/drivers/gpu/drm/virtio/virtgpu_drv.h
> @@ -146,6 +146,21 @@ struct virtio_gpu_queue {
>  	struct work_struct dequeue_work;
>  };
>  
> +struct virtio_gpu_drv_capset {
> +	uint32_t id;
> +	uint32_t max_version;
> +	uint32_t max_size;
> +};
> +
> +struct virtio_gpu_drv_cap_cache {
> +	struct list_head head;
> +	void *caps_cache;
> +	uint32_t id;
> +	uint32_t version;
> +	uint32_t size;
> +	atomic_t is_valid;
> +};
> +
>  struct virtio_gpu_device {
>  	struct device *dev;
>  	struct drm_device *ddev;
> @@ -179,7 +194,13 @@ struct virtio_gpu_device {
>  	struct idr	ctx_id_idr;
>  	spinlock_t ctx_id_idr_lock;
>  
> +	bool has_virgl_3d;
> +
>  	struct work_struct config_changed_work;
> +
> +	struct virtio_gpu_drv_capset *capsets;
> +	uint32_t num_capsets;
> +	struct list_head cap_cache;
>  };
>  
>  struct virtio_gpu_fpriv {
> @@ -193,6 +214,8 @@ extern struct drm_ioctl_desc virtio_gpu_ioctls[DRM_VIRTIO_NUM_IOCTLS];
>  /* virtio_kms.c */
>  int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags);
>  int virtio_gpu_driver_unload(struct drm_device *dev);
> +int virtio_gpu_driver_open(struct drm_device *dev, struct drm_file *file);
> +void virtio_gpu_driver_postclose(struct drm_device *dev, struct drm_file *file);
>  
>  /* virtio_gem.c */
>  void virtio_gpu_gem_free_object(struct drm_gem_object *gem_obj);
> @@ -203,6 +226,10 @@ int virtio_gpu_gem_create(struct drm_file *file,
>  			  uint64_t size,
>  			  struct drm_gem_object **obj_p,
>  			  uint32_t *handle_p);
> +int virtio_gpu_gem_object_open(struct drm_gem_object *obj,
> +			       struct drm_file *file);
> +void virtio_gpu_gem_object_close(struct drm_gem_object *obj,
> +				 struct drm_file *file);
>  struct virtio_gpu_object *virtio_gpu_alloc_object(struct drm_device *dev,
>  						  size_t size, bool kernel,
>  						  bool pinned);
> @@ -260,10 +287,43 @@ void virtio_gpu_cursor_ping(struct virtio_gpu_device *vgdev,
>  int virtio_gpu_cmd_get_display_info(struct virtio_gpu_device *vgdev);
>  void virtio_gpu_cmd_resource_inval_backing(struct virtio_gpu_device *vgdev,
>  					   uint32_t resource_id);
> +int virtio_gpu_cmd_get_capset_info(struct virtio_gpu_device *vgdev, int idx);
> +int virtio_gpu_cmd_get_capset(struct virtio_gpu_device *vgdev,
> +			      int idx, int version,
> +			      struct virtio_gpu_drv_cap_cache **cache_p);
> +void virtio_gpu_cmd_context_create(struct virtio_gpu_device *vgdev, uint32_t id,
> +				   uint32_t nlen, const char *name);
> +void virtio_gpu_cmd_context_destroy(struct virtio_gpu_device *vgdev,
> +				    uint32_t id);
> +void virtio_gpu_cmd_context_attach_resource(struct virtio_gpu_device *vgdev,
> +					    uint32_t ctx_id,
> +					    uint32_t resource_id);
> +void virtio_gpu_cmd_context_detach_resource(struct virtio_gpu_device *vgdev,
> +					    uint32_t ctx_id,
> +					    uint32_t resource_id);
> +void virtio_gpu_cmd_submit(struct virtio_gpu_device *vgdev,
> +			   void *data, uint32_t data_size,
> +			   uint32_t ctx_id, struct virtio_gpu_fence **fence);
> +void virtio_gpu_cmd_transfer_from_host_3d(struct virtio_gpu_device *vgdev,
> +					  uint32_t resource_id, uint32_t ctx_id,
> +					  uint64_t offset, uint32_t level,
> +					  struct virtio_gpu_box *box,
> +					  struct virtio_gpu_fence **fence);
> +void virtio_gpu_cmd_transfer_to_host_3d(struct virtio_gpu_device *vgdev,
> +					uint32_t resource_id, uint32_t ctx_id,
> +					uint64_t offset, uint32_t level,
> +					struct virtio_gpu_box *box,
> +					struct virtio_gpu_fence **fence);
> +void
> +virtio_gpu_cmd_resource_create_3d(struct virtio_gpu_device *vgdev,
> +				  struct virtio_gpu_resource_create_3d *rc_3d,
> +				  struct virtio_gpu_fence **fence);
>  void virtio_gpu_ctrl_ack(struct virtqueue *vq);
>  void virtio_gpu_cursor_ack(struct virtqueue *vq);
> +void virtio_gpu_fence_ack(struct virtqueue *vq);
>  void virtio_gpu_dequeue_ctrl_func(struct work_struct *work);
>  void virtio_gpu_dequeue_cursor_func(struct work_struct *work);
> +void virtio_gpu_dequeue_fence_func(struct work_struct *work);
>  
>  /* virtio_gpu_display.c */
>  int virtio_gpu_framebuffer_init(struct drm_device *dev,
> diff --git a/drivers/gpu/drm/virtio/virtgpu_gem.c b/drivers/gpu/drm/virtio/virtgpu_gem.c
> index cfa0d27..1feb7ce 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_gem.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_gem.c
> @@ -138,3 +138,44 @@ int virtio_gpu_mode_dumb_mmap(struct drm_file *file_priv,
>  	drm_gem_object_unreference_unlocked(gobj);
>  	return 0;
>  }
> +
> +int virtio_gpu_gem_object_open(struct drm_gem_object *obj,
> +			       struct drm_file *file)
> +{
> +	struct virtio_gpu_device *vgdev = obj->dev->dev_private;
> +	struct virtio_gpu_fpriv *vfpriv = file->driver_priv;
> +	struct virtio_gpu_object *qobj = gem_to_virtio_gpu_obj(obj);
> +	int r;
> +
> +	if (!vgdev->has_virgl_3d)
> +		return 0;
> +
> +	r = virtio_gpu_object_reserve(qobj, false);
> +	if (r)
> +		return r;
> +
> +	virtio_gpu_cmd_context_attach_resource(vgdev, vfpriv->ctx_id,
> +					       qobj->hw_res_handle);
> +	virtio_gpu_object_unreserve(qobj);
> +	return 0;
> +}
> +
> +void virtio_gpu_gem_object_close(struct drm_gem_object *obj,
> +				 struct drm_file *file)
> +{
> +	struct virtio_gpu_device *vgdev = obj->dev->dev_private;
> +	struct virtio_gpu_fpriv *vfpriv = file->driver_priv;
> +	struct virtio_gpu_object *qobj = gem_to_virtio_gpu_obj(obj);
> +	int r;
> +
> +	if (!vgdev->has_virgl_3d)
> +		return;
> +
> +	r = virtio_gpu_object_reserve(qobj, false);
> +	if (r)
> +		return;
> +
> +	virtio_gpu_cmd_context_detach_resource(vgdev, vfpriv->ctx_id,
> +						qobj->hw_res_handle);
> +	virtio_gpu_object_unreserve(qobj);
> +}
> diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
> new file mode 100644
> index 0000000..d5c9e02
> --- /dev/null
> +++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
> @@ -0,0 +1,572 @@
> +/*
> + * Copyright (C) 2015 Red Hat, Inc.
> + * All Rights Reserved.
> + *
> + * Authors:
> + *    Dave Airlie
> + *    Alon Levy
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice shall be included in
> + * all copies or substantial portions of the Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +#include <drm/drmP.h>
> +#include "virtgpu_drv.h"
> +#include <drm/virtgpu_drm.h>
> +#include "ttm/ttm_execbuf_util.h"
> +
> +static void convert_to_hw_box(struct virtio_gpu_box *dst,
> +			      const struct drm_virtgpu_3d_box *src)
> +{
> +	dst->x = cpu_to_le32(src->x);
> +	dst->y = cpu_to_le32(src->y);
> +	dst->z = cpu_to_le32(src->z);
> +	dst->w = cpu_to_le32(src->w);
> +	dst->h = cpu_to_le32(src->h);
> +	dst->d = cpu_to_le32(src->d);
> +}
> +
> +static int virtio_gpu_map_ioctl(struct drm_device *dev, void *data,
> +				struct drm_file *file_priv)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct drm_virtgpu_map *virtio_gpu_map = data;
> +
> +	return virtio_gpu_mode_dumb_mmap(file_priv, vgdev->ddev,
> +					 virtio_gpu_map->handle,
> +					 &virtio_gpu_map->offset);
> +}
> +
> +static int virtio_gpu_object_list_validate(struct ww_acquire_ctx *ticket,
> +					   struct list_head *head)
> +{
> +	struct ttm_validate_buffer *buf;
> +	struct ttm_buffer_object *bo;
> +	struct virtio_gpu_object *qobj;
> +	int ret;
> +
> +	ret = ttm_eu_reserve_buffers(ticket, head, true, NULL);
> +	if (ret != 0)
> +		return ret;
> +
> +	list_for_each_entry(buf, head, head) {
> +		bo = buf->bo;
> +		qobj = container_of(bo, struct virtio_gpu_object, tbo);
> +		ret = ttm_bo_validate(bo, &qobj->placement, false, false);
> +		if (ret) {
> +			ttm_eu_backoff_reservation(ticket, head);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void virtio_gpu_unref_list(struct list_head *head)
> +{
> +	struct ttm_validate_buffer *buf;
> +	struct ttm_buffer_object *bo;
> +	struct virtio_gpu_object *qobj;
> +	list_for_each_entry(buf, head, head) {
> +		bo = buf->bo;
> +		qobj = container_of(bo, struct virtio_gpu_object, tbo);
> +
> +		drm_gem_object_unreference_unlocked(&qobj->gem_base);
> +	}
> +}
> +
> +static int virtio_gpu_execbuffer(struct drm_device *dev,
> +				 struct drm_virtgpu_execbuffer *exbuf,
> +				 struct drm_file *drm_file)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct virtio_gpu_fpriv *vfpriv = drm_file->driver_priv;
> +	struct drm_gem_object *gobj;
> +	struct virtio_gpu_fence *fence;
> +	struct virtio_gpu_object *qobj;
> +	int ret;
> +	uint32_t *bo_handles = NULL;
> +	void __user *user_bo_handles = NULL;
> +	struct list_head validate_list;
> +	struct ttm_validate_buffer *buflist = NULL;
> +	struct ttm_validate_buffer cmdbuffer;
> +	int i;
> +	struct ww_acquire_ctx ticket;
> +	void *buf;
> +
> +	if (vgdev->has_virgl_3d == false)
> +		return -ENOSYS;
> +
> +	memset(&cmdbuffer, 0, sizeof(struct ttm_validate_buffer));
> +	INIT_LIST_HEAD(&validate_list);
> +	if (exbuf->num_bo_handles) {
> +
> +		bo_handles = drm_malloc_ab(exbuf->num_bo_handles,
> +					   sizeof(uint32_t));
> +		buflist = drm_calloc_large(exbuf->num_bo_handles,
> +					   sizeof(struct ttm_validate_buffer));
> +		if (!bo_handles || !buflist) {
> +			drm_free_large(bo_handles);
> +			drm_free_large(buflist);
> +			return -ENOMEM;
> +		}
> +
> +		user_bo_handles = (void __user *)(uintptr_t)exbuf->bo_handles;
> +		if (copy_from_user(bo_handles, user_bo_handles,
> +				   exbuf->num_bo_handles * sizeof(uint32_t))) {
> +			ret = -EFAULT;
> +			drm_free_large(bo_handles);
> +			return ret;
> +		}
> +
> +		for (i = 0; i < exbuf->num_bo_handles; i++) {
> +			gobj = drm_gem_object_lookup(dev,
> +						     drm_file, bo_handles[i]);
> +			if (!gobj) {
> +				drm_free_large(bo_handles);
> +				drm_free_large(buflist);
> +				return -ENOENT;
> +			}
> +
> +			qobj = gem_to_virtio_gpu_obj(gobj);
> +			buflist[i].bo = &qobj->tbo;
> +
> +			list_add(&buflist[i].head, &validate_list);
> +		}
> +		drm_free_large(bo_handles);
> +	}
> +
> +	ret = virtio_gpu_object_list_validate(&ticket, &validate_list);
> +	if (ret)
> +		goto out_free;
> +
> +	buf = kmalloc(exbuf->size, GFP_KERNEL);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto out_unresv;
> +	}
> +	if (copy_from_user(buf, (void __user *)(uintptr_t)exbuf->command,
> +			   exbuf->size)) {
> +		kfree(buf);
> +		ret = -EFAULT;
> +		goto out_unresv;
> +	}
> +	virtio_gpu_cmd_submit(vgdev, buf, exbuf->size,
> +			      vfpriv->ctx_id, &fence);
> +
> +	ttm_eu_fence_buffer_objects(&ticket, &validate_list, &fence->f);
> +
> +	/* fence the command bo */
> +	virtio_gpu_unref_list(&validate_list);
> +	drm_free_large(buflist);
> +	fence_put(&fence->f);
> +	return 0;
> +
> +out_unresv:
> +	ttm_eu_backoff_reservation(&ticket, &validate_list);
> +out_free:
> +	virtio_gpu_unref_list(&validate_list);
> +	drm_free_large(buflist);
> +	return ret;
> +}
> +
> +/*
> + * Usage of execbuffer:
> + * Relocations need to take into account the full VIRTIO_GPUDrawable size.
> + * However, the command as passed from user space must *not* contain the initial
> + * VIRTIO_GPUReleaseInfo struct (first XXX bytes)
> + */
> +static int virtio_gpu_execbuffer_ioctl(struct drm_device *dev, void *data,
> +				       struct drm_file *file_priv)
> +{
> +	struct drm_virtgpu_execbuffer *execbuffer = data;
> +	return virtio_gpu_execbuffer(dev, execbuffer, file_priv);
> +}
> +
> +
> +static int virtio_gpu_getparam_ioctl(struct drm_device *dev, void *data,
> +				     struct drm_file *file_priv)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct drm_virtgpu_getparam *param = data;
> +	int value;
> +
> +	switch (param->param) {
> +	case VIRTGPU_PARAM_3D_FEATURES:
> +		value = vgdev->has_virgl_3d == true ? 1 : 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	if (copy_to_user((void __user *)(unsigned long)param->value,
> +			 &value, sizeof(int))) {
> +		return -EFAULT;
> +	}
> +	return 0;
> +}
> +
> +static int virtio_gpu_resource_create_ioctl(struct drm_device *dev, void *data,
> +					    struct drm_file *file_priv)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct drm_virtgpu_resource_create *rc = data;
> +	int ret;
> +	uint32_t res_id;
> +	struct virtio_gpu_object *qobj;
> +	struct drm_gem_object *obj;
> +	uint32_t handle = 0;
> +	uint32_t size;
> +	struct list_head validate_list;
> +	struct ttm_validate_buffer mainbuf;
> +	struct virtio_gpu_fence *fence = NULL;
> +	struct ww_acquire_ctx ticket;
> +	struct virtio_gpu_resource_create_3d rc_3d;
> +
> +	if (vgdev->has_virgl_3d == false) {
> +		if (rc->depth > 1)
> +			return -EINVAL;
> +		if (rc->nr_samples > 1)
> +			return -EINVAL;
> +		if (rc->last_level > 1)
> +			return -EINVAL;
> +		if (rc->target != 2)
> +			return -EINVAL;
> +		if (rc->array_size > 1)
> +			return -EINVAL;
> +	}
> +
> +	INIT_LIST_HEAD(&validate_list);
> +	memset(&mainbuf, 0, sizeof(struct ttm_validate_buffer));
> +
> +	virtio_gpu_resource_id_get(vgdev, &res_id);
> +
> +	size = rc->size;
> +
> +	/* allocate a single page size object */
> +	if (size == 0)
> +		size = PAGE_SIZE;
> +
> +	qobj = virtio_gpu_alloc_object(dev, size, false, false);
> +	if (IS_ERR(qobj)) {
> +		ret = PTR_ERR(qobj);
> +		goto fail_id;
> +	}
> +	obj = &qobj->gem_base;
> +
> +	if (!vgdev->has_virgl_3d) {
> +		virtio_gpu_cmd_create_resource(vgdev, res_id, rc->format,
> +					       rc->width, rc->height);
> +
> +		ret = virtio_gpu_object_attach(vgdev, qobj, res_id, NULL);
> +	} else {
> +		/* use a gem reference since unref list undoes them */
> +		drm_gem_object_reference(&qobj->gem_base);
> +		mainbuf.bo = &qobj->tbo;
> +		list_add(&mainbuf.head, &validate_list);
> +
> +		ret = virtio_gpu_object_list_validate(&ticket, &validate_list);
> +		if (ret) {
> +			DRM_DEBUG("failed to validate\n");
> +			goto fail_unref;
> +		}
> +
> +		rc_3d.resource_id = cpu_to_le32(res_id);
> +		rc_3d.target = cpu_to_le32(rc->target);
> +		rc_3d.format = cpu_to_le32(rc->format);
> +		rc_3d.bind = cpu_to_le32(rc->bind);
> +		rc_3d.width = cpu_to_le32(rc->width);
> +		rc_3d.height = cpu_to_le32(rc->height);
> +		rc_3d.depth = cpu_to_le32(rc->depth);
> +		rc_3d.array_size = cpu_to_le32(rc->array_size);
> +		rc_3d.last_level = cpu_to_le32(rc->last_level);
> +		rc_3d.nr_samples = cpu_to_le32(rc->nr_samples);
> +		rc_3d.flags = cpu_to_le32(rc->flags);
> +
> +		virtio_gpu_cmd_resource_create_3d(vgdev, &rc_3d, NULL);
> +		ret = virtio_gpu_object_attach(vgdev, qobj, res_id, &fence);
> +		if (ret)
> +			goto fail_unref;
> +		ttm_eu_fence_buffer_objects(&ticket, &validate_list, &fence->f);
> +	}
> +
> +	qobj->hw_res_handle = res_id;
> +
> +	ret = drm_gem_handle_create(file_priv, obj, &handle);
> +	if (ret) {
> +
> +		drm_gem_object_release(obj);
> +		if (vgdev->has_virgl_3d) {
> +			virtio_gpu_unref_list(&validate_list);
> +			fence_put(&fence->f);
> +		}
> +		return ret;
> +	}
> +	drm_gem_object_unreference_unlocked(obj);
> +
> +	rc->res_handle = res_id; /* similiar to a VM address */
> +	rc->bo_handle = handle;
> +
> +	if (vgdev->has_virgl_3d) {
> +		virtio_gpu_unref_list(&validate_list);
> +		fence_put(&fence->f);
> +	}
> +	return 0;
> +fail_unref:
> +	if (vgdev->has_virgl_3d) {
> +		virtio_gpu_unref_list(&validate_list);
> +		fence_put(&fence->f);
> +	}
> +//fail_obj:
> +//	drm_gem_object_handle_unreference_unlocked(obj);
> +fail_id:
> +	virtio_gpu_resource_id_put(vgdev, res_id);
> +	return ret;
> +}
> +
> +static int virtio_gpu_resource_info_ioctl(struct drm_device *dev, void *data,
> +					  struct drm_file *file_priv)
> +{
> +	struct drm_virtgpu_resource_info *ri = data;
> +	struct drm_gem_object *gobj = NULL;
> +	struct virtio_gpu_object *qobj = NULL;
> +
> +	gobj = drm_gem_object_lookup(dev, file_priv, ri->bo_handle);
> +	if (gobj == NULL)
> +		return -ENOENT;
> +
> +	qobj = gem_to_virtio_gpu_obj(gobj);
> +
> +	ri->size = qobj->gem_base.size;
> +	ri->res_handle = qobj->hw_res_handle;
> +	drm_gem_object_unreference_unlocked(gobj);
> +	return 0;
> +}
> +
> +static int virtio_gpu_transfer_from_host_ioctl(struct drm_device *dev,
> +					       void *data,
> +					       struct drm_file *file)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct virtio_gpu_fpriv *vfpriv = file->driver_priv;
> +	struct drm_virtgpu_3d_transfer_from_host *args = data;
> +	struct drm_gem_object *gobj = NULL;
> +	struct virtio_gpu_object *qobj = NULL;
> +	struct virtio_gpu_fence *fence;
> +	int ret;
> +	u32 offset = args->offset;
> +	struct virtio_gpu_box box;
> +
> +	if (vgdev->has_virgl_3d == false)
> +		return -ENOSYS;
> +
> +	gobj = drm_gem_object_lookup(dev, file, args->bo_handle);
> +	if (gobj == NULL)
> +		return -ENOENT;
> +
> +	qobj = gem_to_virtio_gpu_obj(gobj);
> +
> +	ret = virtio_gpu_object_reserve(qobj, false);
> +	if (ret)
> +		goto out;
> +
> +	ret = ttm_bo_validate(&qobj->tbo, &qobj->placement,
> +			      true, false);
> +	if (unlikely(ret))
> +		goto out_unres;
> +
> +	convert_to_hw_box(&box, &args->box);
> +	virtio_gpu_cmd_transfer_from_host_3d
> +		(vgdev, qobj->hw_res_handle,
> +		 vfpriv->ctx_id, offset, args->level,
> +		 &box, &fence);
> +	reservation_object_add_excl_fence(qobj->tbo.resv,
> +					  &fence->f);
> +
> +	fence_put(&fence->f);
> +out_unres:
> +	virtio_gpu_object_unreserve(qobj);
> +out:
> +	drm_gem_object_unreference_unlocked(gobj);
> +	return ret;
> +}
> +
> +static int virtio_gpu_transfer_to_host_ioctl(struct drm_device *dev, void *data,
> +					     struct drm_file *file)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct virtio_gpu_fpriv *vfpriv = file->driver_priv;
> +	struct drm_virtgpu_3d_transfer_to_host *args = data;
> +	struct drm_gem_object *gobj = NULL;
> +	struct virtio_gpu_object *qobj = NULL;
> +	struct virtio_gpu_fence *fence;
> +	struct virtio_gpu_box box;
> +	int ret;
> +	u32 offset = args->offset;
> +
> +	gobj = drm_gem_object_lookup(dev, file, args->bo_handle);
> +	if (gobj == NULL)
> +		return -ENOENT;
> +
> +	qobj = gem_to_virtio_gpu_obj(gobj);
> +
> +	ret = virtio_gpu_object_reserve(qobj, false);
> +	if (ret)
> +		goto out;
> +
> +	ret = ttm_bo_validate(&qobj->tbo, &qobj->placement,
> +			      true, false);
> +	if (unlikely(ret))
> +		goto out_unres;
> +
> +	convert_to_hw_box(&box, &args->box);
> +	if (!vgdev->has_virgl_3d) {
> +		virtio_gpu_cmd_transfer_to_host_2d
> +			(vgdev, qobj->hw_res_handle, offset,
> +			 box.w, box.h, box.x, box.y, NULL);
> +	} else {
> +		virtio_gpu_cmd_transfer_to_host_3d
> +			(vgdev, qobj->hw_res_handle,
> +			 vfpriv ? vfpriv->ctx_id : 0, offset,
> +			 args->level, &box, &fence);
> +		reservation_object_add_excl_fence(qobj->tbo.resv,
> +						  &fence->f);
> +		fence_put(&fence->f);
> +	}
> +
> +out_unres:
> +	virtio_gpu_object_unreserve(qobj);
> +out:
> +	drm_gem_object_unreference_unlocked(gobj);
> +	return ret;
> +}
> +
> +static int virtio_gpu_wait_ioctl(struct drm_device *dev, void *data,
> +			    struct drm_file *file)
> +{
> +	struct drm_virtgpu_3d_wait *args = data;
> +	struct drm_gem_object *gobj = NULL;
> +	struct virtio_gpu_object *qobj = NULL;
> +	int ret;
> +	bool nowait = false;
> +
> +	gobj = drm_gem_object_lookup(dev, file, args->handle);
> +	if (gobj == NULL)
> +		return -ENOENT;
> +
> +	qobj = gem_to_virtio_gpu_obj(gobj);
> +
> +	if (args->flags & VIRTGPU_WAIT_NOWAIT)
> +		nowait = true;
> +	ret = virtio_gpu_object_wait(qobj, nowait);
> +
> +	drm_gem_object_unreference_unlocked(gobj);
> +	return ret;
> +}
> +
> +static int virtio_gpu_get_caps_ioctl(struct drm_device *dev,
> +				void *data, struct drm_file *file)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct drm_virtgpu_get_caps *args = data;
> +	int size;
> +	int i;
> +	int found_valid = -1;
> +	int ret;
> +	struct virtio_gpu_drv_cap_cache *cache_ent;
> +	void *ptr;
> +	if (vgdev->num_capsets == 0)
> +		return -ENOSYS;
> +
> +	spin_lock(&vgdev->display_info_lock);
> +	for (i = 0; i < vgdev->num_capsets; i++) {
> +		if (vgdev->capsets[i].id == args->cap_set_id) {
> +			if (vgdev->capsets[i].max_version >= args->cap_set_ver) {
> +				found_valid = i;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (found_valid == -1) {
> +		spin_unlock(&vgdev->display_info_lock);
> +		return -EINVAL;
> +	}
> +
> +	size = vgdev->capsets[found_valid].max_size;
> +	if (args->size > size) {
> +		spin_unlock(&vgdev->display_info_lock);
> +		return -EINVAL;
> +	}
> +
> +	list_for_each_entry(cache_ent, &vgdev->cap_cache, head) {
> +		if (cache_ent->id == args->cap_set_id &&
> +		    cache_ent->version == args->cap_set_ver) {
> +			ptr = cache_ent->caps_cache;
> +			spin_unlock(&vgdev->display_info_lock);
> +			goto copy_exit;
> +		}
> +	}
> +	spin_unlock(&vgdev->display_info_lock);
> +
> +	/* not in cache - need to talk to hw */
> +	virtio_gpu_cmd_get_capset(vgdev, found_valid, args->cap_set_ver,
> +				  &cache_ent);
> +
> +	ret = wait_event_timeout(vgdev->resp_wq,
> +				 atomic_read(&cache_ent->is_valid), 5 * HZ);
> +
> +	ptr = cache_ent->caps_cache;
> +
> +copy_exit:
> +	if (copy_to_user((void __user *)(unsigned long)args->addr, ptr, size))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +struct drm_ioctl_desc virtio_gpu_ioctls[DRM_VIRTIO_NUM_IOCTLS] = {
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_MAP, virtio_gpu_map_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_EXECBUFFER, virtio_gpu_execbuffer_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_GETPARAM, virtio_gpu_getparam_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_RESOURCE_CREATE,
> +			  virtio_gpu_resource_create_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_RESOURCE_INFO, virtio_gpu_resource_info_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +
> +	/* make transfer async to the main ring? - no sure, can we
> +	   thread these in the underlying GL */
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_TRANSFER_FROM_HOST,
> +			  virtio_gpu_transfer_from_host_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_TRANSFER_TO_HOST,
> +			  virtio_gpu_transfer_to_host_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_WAIT, virtio_gpu_wait_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +
> +	DRM_IOCTL_DEF_DRV(VIRTGPU_GET_CAPS, virtio_gpu_get_caps_ioctl,
> +			  DRM_AUTH|DRM_UNLOCKED),
> +};
> diff --git a/drivers/gpu/drm/virtio/virtgpu_kms.c b/drivers/gpu/drm/virtio/virtgpu_kms.c
> index 782766c..12a1091 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_kms.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_kms.c
> @@ -52,6 +52,41 @@ static void virtio_gpu_config_changed_work_func(struct work_struct *work)
>  		      events_clear, &events_clear);
>  }
>  
> +static void virtio_gpu_ctx_id_get(struct virtio_gpu_device *vgdev,
> +				  uint32_t *resid)
> +{
> +	int handle;
> +
> +	idr_preload(GFP_KERNEL);
> +	spin_lock(&vgdev->ctx_id_idr_lock);
> +	handle = idr_alloc(&vgdev->ctx_id_idr, NULL, 1, 0, 0);
> +	spin_unlock(&vgdev->ctx_id_idr_lock);
> +	idr_preload_end();
> +	*resid = handle;
> +}
> +
> +static void virtio_gpu_ctx_id_put(struct virtio_gpu_device *vgdev, uint32_t id)
> +{
> +	spin_lock(&vgdev->ctx_id_idr_lock);
> +	idr_remove(&vgdev->ctx_id_idr, id);
> +	spin_unlock(&vgdev->ctx_id_idr_lock);
> +}
> +
> +static void virtio_gpu_context_create(struct virtio_gpu_device *vgdev,
> +				      uint32_t nlen, const char *name,
> +				      uint32_t *ctx_id)
> +{
> +	virtio_gpu_ctx_id_get(vgdev, ctx_id);
> +	virtio_gpu_cmd_context_create(vgdev, *ctx_id, nlen, name);
> +}
> +
> +static void virtio_gpu_context_destroy(struct virtio_gpu_device *vgdev,
> +				      uint32_t ctx_id)
> +{
> +	virtio_gpu_cmd_context_destroy(vgdev, ctx_id);
> +	virtio_gpu_ctx_id_put(vgdev, ctx_id);
> +}
> +
>  static void virtio_gpu_init_vq(struct virtio_gpu_queue *vgvq,
>  			       void (*work_func)(struct work_struct *work))
>  {
> @@ -60,6 +95,36 @@ static void virtio_gpu_init_vq(struct virtio_gpu_queue *vgvq,
>  	INIT_WORK(&vgvq->dequeue_work, work_func);
>  }
>  
> +static void virtio_gpu_get_capsets(struct virtio_gpu_device *vgdev,
> +				   int num_capsets)
> +{
> +	int i, ret;
> +
> +	vgdev->capsets = kcalloc(num_capsets,
> +				 sizeof(struct virtio_gpu_drv_capset),
> +				 GFP_KERNEL);
> +	if (!vgdev->capsets) {
> +		DRM_ERROR("failed to allocate cap sets\n");
> +		return;
> +	}
> +	for (i = 0; i < num_capsets; i++) {
> +		virtio_gpu_cmd_get_capset_info(vgdev, i);
> +		ret = wait_event_timeout(vgdev->resp_wq,
> +					 vgdev->capsets[i].id > 0, 5 * HZ);
> +		if (ret == 0) {
> +			DRM_ERROR("timed out waiting for cap set %d\n", i);
> +			kfree(vgdev->capsets);
> +			vgdev->capsets = NULL;
> +			return;
> +		}
> +		DRM_INFO("cap set %d: id %d, max-version %d, max-size %d\n",
> +			 i, vgdev->capsets[i].id,
> +			 vgdev->capsets[i].max_version,
> +			 vgdev->capsets[i].max_size);
> +	}
> +	vgdev->num_capsets = num_capsets;
> +}
> +
>  int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags)
>  {
>  	static vq_callback_t *callbacks[] = {
> @@ -70,7 +135,7 @@ int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags)
>  	struct virtio_gpu_device *vgdev;
>  	/* this will expand later */
>  	struct virtqueue *vqs[2];
> -	u32 num_scanouts;
> +	u32 num_scanouts, num_capsets;
>  	int ret;
>  
>  	if (!virtio_has_feature(dev->virtdev, VIRTIO_F_VERSION_1))
> @@ -96,9 +161,17 @@ int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags)
>  
>  	spin_lock_init(&vgdev->fence_drv.lock);
>  	INIT_LIST_HEAD(&vgdev->fence_drv.fences);
> +	INIT_LIST_HEAD(&vgdev->cap_cache);
>  	INIT_WORK(&vgdev->config_changed_work,
>  		  virtio_gpu_config_changed_work_func);
>  
> +#ifdef __LITTLE_ENDIAN
> +	if (virtio_has_feature(vgdev->vdev, VIRTIO_GPU_FEATURE_VIRGL))
> +		vgdev->has_virgl_3d = true;
> +#endif

You might be able to get by without this ifdef as
VIRTIO_GPU_FEATURE_VIRGL won't be set without it.


> +	DRM_INFO("virgl 3d acceleration %s\n",
> +		 vgdev->has_virgl_3d ? "enabled" : "not available");
> +
>  	ret = vgdev->vdev->config->find_vqs(vgdev->vdev, 2, vqs,
>  					    callbacks, names);
>  	if (ret) {
> @@ -129,6 +202,11 @@ int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags)
>  		ret = -EINVAL;
>  		goto err_scanouts;
>  	}
> +	DRM_INFO("number of scanouts: %d\n", num_scanouts);
> +
> +	virtio_cread(vgdev->vdev, struct virtio_gpu_config,
> +		     num_capsets, &num_capsets);
> +	DRM_INFO("number of cap sets: %d\n", num_capsets);
>  
>  	ret = virtio_gpu_modeset_init(vgdev);
>  	if (ret)
> @@ -137,6 +215,8 @@ int virtio_gpu_driver_load(struct drm_device *dev, unsigned long flags)
>  	virtio_device_ready(vgdev->vdev);
>  	vgdev->vqs_ready = true;
>  
> +	if (num_capsets)
> +		virtio_gpu_get_capsets(vgdev, num_capsets);
>  	virtio_gpu_cmd_get_display_info(vgdev);
>  	wait_event_timeout(vgdev->resp_wq, !vgdev->display_info_pending,
>  			   5 * HZ);
> @@ -157,6 +237,16 @@ err_vqs:
>  	return ret;
>  }
>  
> +static void virtio_gpu_cleanup_cap_cache(struct virtio_gpu_device *vgdev)
> +{
> +	struct virtio_gpu_drv_cap_cache *cache_ent, *tmp;
> +
> +	list_for_each_entry_safe(cache_ent, tmp, &vgdev->cap_cache, head) {
> +		kfree(cache_ent->caps_cache);
> +		kfree(cache_ent);
> +	}
> +}
> +
>  int virtio_gpu_driver_unload(struct drm_device *dev)
>  {
>  	struct virtio_gpu_device *vgdev = dev->dev_private;
> @@ -170,6 +260,49 @@ int virtio_gpu_driver_unload(struct drm_device *dev)
>  	virtio_gpu_modeset_fini(vgdev);
>  	virtio_gpu_ttm_fini(vgdev);
>  	virtio_gpu_free_vbufs(vgdev);
> +	virtio_gpu_cleanup_cap_cache(vgdev);
> +	kfree(vgdev->capsets);
>  	kfree(vgdev);
>  	return 0;
>  }
> +
> +int virtio_gpu_driver_open(struct drm_device *dev, struct drm_file *file)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct virtio_gpu_fpriv *vfpriv;
> +	uint32_t id;
> +	char dbgname[64], tmpname[TASK_COMM_LEN];
> +
> +	/* can't create contexts without 3d renderer */
> +	if (!vgdev->has_virgl_3d)
> +		return 0;
> +
> +	get_task_comm(tmpname, current);
> +	snprintf(dbgname, sizeof(dbgname), "%s", tmpname);
> +	dbgname[63] = 0;
> +	/* allocate a virt GPU context for this opener */
> +	vfpriv = kzalloc(sizeof(*vfpriv), GFP_KERNEL);
> +	if (!vfpriv)
> +		return -ENOMEM;
> +
> +	virtio_gpu_context_create(vgdev, strlen(dbgname), dbgname, &id);
> +
> +	vfpriv->ctx_id = id;
> +	file->driver_priv = vfpriv;
> +	return 0;
> +}
> +
> +void virtio_gpu_driver_postclose(struct drm_device *dev, struct drm_file *file)
> +{
> +	struct virtio_gpu_device *vgdev = dev->dev_private;
> +	struct virtio_gpu_fpriv *vfpriv;
> +
> +	if (!vgdev->has_virgl_3d)
> +		return;
> +
> +	vfpriv = file->driver_priv;
> +
> +	virtio_gpu_context_destroy(vgdev, vfpriv->ctx_id);
> +	kfree(vfpriv);
> +	file->driver_priv = NULL;
> +}
> diff --git a/drivers/gpu/drm/virtio/virtgpu_ttm.c b/drivers/gpu/drm/virtio/virtgpu_ttm.c
> index b092d7b..9fd924c 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_ttm.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_ttm.c
> @@ -32,6 +32,7 @@
>  #include <ttm/ttm_module.h>
>  #include <drm/drmP.h>
>  #include <drm/drm.h>
> +#include <drm/virtgpu_drm.h>
>  #include "virtgpu_drv.h"
>  
>  #include <linux/delay.h>
> diff --git a/drivers/gpu/drm/virtio/virtgpu_vq.c b/drivers/gpu/drm/virtio/virtgpu_vq.c
> index ee25e9a..ac4f642 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_vq.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
> @@ -586,6 +586,47 @@ static void virtio_gpu_cmd_get_display_info_cb(struct virtio_gpu_device *vgdev,
>  		drm_kms_helper_hotplug_event(vgdev->ddev);
>  }
>  
> +static void virtio_gpu_cmd_get_capset_info_cb(struct virtio_gpu_device *vgdev,
> +					      struct virtio_gpu_vbuffer *vbuf)
> +{
> +	struct virtio_gpu_get_capset_info *cmd =
> +		(struct virtio_gpu_get_capset_info *)vbuf->buf;
> +	struct virtio_gpu_resp_capset_info *resp =
> +		(struct virtio_gpu_resp_capset_info *)vbuf->resp_buf;
> +	int i = le32_to_cpu(cmd->capset_index);
> +
> +	spin_lock(&vgdev->display_info_lock);
> +	vgdev->capsets[i].id = le32_to_cpu(resp->capset_id);
> +	vgdev->capsets[i].max_version = le32_to_cpu(resp->capset_max_version);
> +	vgdev->capsets[i].max_size = le32_to_cpu(resp->capset_max_size);
> +	spin_unlock(&vgdev->display_info_lock);
> +	wake_up(&vgdev->resp_wq);
> +}
> +
> +static void virtio_gpu_cmd_capset_cb(struct virtio_gpu_device *vgdev,
> +				     struct virtio_gpu_vbuffer *vbuf)
> +{
> +	struct virtio_gpu_get_capset *cmd =
> +		(struct virtio_gpu_get_capset *)vbuf->buf;
> +	struct virtio_gpu_resp_capset *resp =
> +		(struct virtio_gpu_resp_capset *)vbuf->resp_buf;
> +	struct virtio_gpu_drv_cap_cache *cache_ent;
> +
> +	spin_lock(&vgdev->display_info_lock);
> +	list_for_each_entry(cache_ent, &vgdev->cap_cache, head) {
> +		if (cache_ent->version == le32_to_cpu(cmd->capset_version) &&
> +		    cache_ent->id == le32_to_cpu(cmd->capset_id)) {
> +			memcpy(cache_ent->caps_cache, resp->capset_data,
> +			       cache_ent->size);
> +			atomic_set(&cache_ent->is_valid, 1);
> +			break;
> +		}
> +	}
> +	spin_unlock(&vgdev->display_info_lock);
> +	wake_up(&vgdev->resp_wq);
> +}
> +
> +
>  int virtio_gpu_cmd_get_display_info(struct virtio_gpu_device *vgdev)
>  {
>  	struct virtio_gpu_ctrl_hdr *cmd_p;
> @@ -609,6 +650,230 @@ int virtio_gpu_cmd_get_display_info(struct virtio_gpu_device *vgdev)
>  	return 0;
>  }
>  
> +int virtio_gpu_cmd_get_capset_info(struct virtio_gpu_device *vgdev, int idx)
> +{
> +	struct virtio_gpu_get_capset_info *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +	void *resp_buf;
> +
> +	resp_buf = kzalloc(sizeof(struct virtio_gpu_resp_capset_info),
> +			   GFP_KERNEL);
> +	if (!resp_buf)
> +		return -ENOMEM;
> +
> +	cmd_p = virtio_gpu_alloc_cmd_resp
> +		(vgdev, &virtio_gpu_cmd_get_capset_info_cb, &vbuf,
> +		 sizeof(*cmd_p), sizeof(struct virtio_gpu_resp_capset_info),
> +		 resp_buf);
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_GET_CAPSET_INFO);
> +	cmd_p->capset_index = cpu_to_le32(idx);
> +	virtio_gpu_queue_ctrl_buffer(vgdev, vbuf);
> +	return 0;
> +}
> +

I note that all callers ignore the recurn code from
virtio_gpu_queue_ctrl_buffer.

Is there a reason it can't fail?

Shouldn't it be made void then?


> +int virtio_gpu_cmd_get_capset(struct virtio_gpu_device *vgdev,
> +			      int idx, int version,
> +			      struct virtio_gpu_drv_cap_cache **cache_p)
> +{
> +	struct virtio_gpu_get_capset *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +	int max_size = vgdev->capsets[idx].max_size;
> +	struct virtio_gpu_drv_cap_cache *cache_ent;
> +	void *resp_buf;
> +
> +	if (idx > vgdev->num_capsets)
> +		return -EINVAL;
> +
> +	if (version > vgdev->capsets[idx].max_version)
> +		return -EINVAL;
> +
> +	cache_ent = kzalloc(sizeof(*cache_ent), GFP_KERNEL);
> +	if (!cache_ent)
> +		return -ENOMEM;
> +
> +	cache_ent->caps_cache = kmalloc(max_size, GFP_KERNEL);
> +	if (!cache_ent->caps_cache) {
> +		kfree(cache_ent);
> +		return -ENOMEM;
> +	}
> +
> +	resp_buf = kzalloc(sizeof(struct virtio_gpu_resp_capset) + max_size,
> +			   GFP_KERNEL);
> +	if (!resp_buf) {
> +		kfree(cache_ent->caps_cache);
> +		kfree(cache_ent);
> +		return -ENOMEM;
> +	}
> +
> +	cache_ent->version = version;
> +	cache_ent->id = vgdev->capsets[idx].id;
> +	atomic_set(&cache_ent->is_valid, 0);
> +	cache_ent->size = max_size;
> +	spin_lock(&vgdev->display_info_lock);
> +	list_add_tail(&cache_ent->head, &vgdev->cap_cache);
> +	spin_unlock(&vgdev->display_info_lock);
> +
> +	cmd_p = virtio_gpu_alloc_cmd_resp
> +		(vgdev, &virtio_gpu_cmd_capset_cb, &vbuf, sizeof(*cmd_p),
> +		 sizeof(struct virtio_gpu_resp_capset) + max_size,
> +		 resp_buf);
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_GET_CAPSET);
> +	cmd_p->capset_id = cpu_to_le32(vgdev->capsets[idx].id);
> +	cmd_p->capset_version = cpu_to_le32(version);
> +	*cache_p = cache_ent;
> +	virtio_gpu_queue_ctrl_buffer(vgdev, vbuf);
> +
> +	return 0;
> +}
> +
> +void virtio_gpu_cmd_context_create(struct virtio_gpu_device *vgdev, uint32_t id,
> +				   uint32_t nlen, const char *name)
> +{
> +	struct virtio_gpu_ctx_create *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_CTX_CREATE);
> +	cmd_p->hdr.ctx_id = cpu_to_le32(id);
> +	cmd_p->nlen = cpu_to_le32(nlen);
> +	strncpy(cmd_p->debug_name, name, 63);
> +	cmd_p->debug_name[63] = 0;

sizeof (cmd_p->debug_name) - 1 will be a but prettier.

> +	virtio_gpu_queue_ctrl_buffer(vgdev, vbuf);
> +}
> +
> +void virtio_gpu_cmd_context_destroy(struct virtio_gpu_device *vgdev,
> +				    uint32_t id)
> +{
> +	struct virtio_gpu_ctx_destroy *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_CTX_DESTROY);
> +	cmd_p->hdr.ctx_id = cpu_to_le32(id);
> +	virtio_gpu_queue_ctrl_buffer(vgdev, vbuf);
> +}
> +
> +void virtio_gpu_cmd_context_attach_resource(struct virtio_gpu_device *vgdev,
> +					    uint32_t ctx_id,
> +					    uint32_t resource_id)
> +{
> +	struct virtio_gpu_ctx_resource *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_CTX_ATTACH_RESOURCE);
> +	cmd_p->hdr.ctx_id = cpu_to_le32(ctx_id);
> +	cmd_p->resource_id = cpu_to_le32(resource_id);
> +	virtio_gpu_queue_ctrl_buffer(vgdev, vbuf);
> +
> +}
> +
> +void virtio_gpu_cmd_context_detach_resource(struct virtio_gpu_device *vgdev,
> +					    uint32_t ctx_id,
> +					    uint32_t resource_id)
> +{
> +	struct virtio_gpu_ctx_resource *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_CTX_DETACH_RESOURCE);
> +	cmd_p->hdr.ctx_id = cpu_to_le32(ctx_id);
> +	cmd_p->resource_id = cpu_to_le32(resource_id);
> +	virtio_gpu_queue_ctrl_buffer(vgdev, vbuf);
> +}
> +
> +void
> +virtio_gpu_cmd_resource_create_3d(struct virtio_gpu_device *vgdev,
> +				  struct virtio_gpu_resource_create_3d *rc_3d,
> +				  struct virtio_gpu_fence **fence)
> +{
> +	struct virtio_gpu_resource_create_3d *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	*cmd_p = *rc_3d;
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_RESOURCE_CREATE_3D);
> +	cmd_p->hdr.flags = 0;
> +
> +	virtio_gpu_queue_fenced_ctrl_buffer(vgdev, vbuf, &cmd_p->hdr, fence);
> +}
> +
> +void virtio_gpu_cmd_transfer_to_host_3d(struct virtio_gpu_device *vgdev,
> +					uint32_t resource_id, uint32_t ctx_id,
> +					uint64_t offset, uint32_t level,
> +					struct virtio_gpu_box *box,
> +					struct virtio_gpu_fence **fence)
> +{
> +	struct virtio_gpu_transfer_host_3d *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_TRANSFER_TO_HOST_3D);
> +	cmd_p->hdr.ctx_id = cpu_to_le32(ctx_id);
> +	cmd_p->resource_id = cpu_to_le32(resource_id);
> +	cmd_p->box = *box;
> +	cmd_p->offset = cpu_to_le64(offset);
> +	cmd_p->level = cpu_to_le32(level);
> +
> +	virtio_gpu_queue_fenced_ctrl_buffer(vgdev, vbuf, &cmd_p->hdr, fence);
> +}
> +
> +void virtio_gpu_cmd_transfer_from_host_3d(struct virtio_gpu_device *vgdev,
> +					  uint32_t resource_id, uint32_t ctx_id,
> +					  uint64_t offset, uint32_t level,
> +					  struct virtio_gpu_box *box,
> +					  struct virtio_gpu_fence **fence)
> +{
> +	struct virtio_gpu_transfer_host_3d *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_TRANSFER_FROM_HOST_3D);
> +	cmd_p->hdr.ctx_id = cpu_to_le32(ctx_id);
> +	cmd_p->resource_id = cpu_to_le32(resource_id);
> +	cmd_p->box = *box;
> +	cmd_p->offset = cpu_to_le64(offset);
> +	cmd_p->level = cpu_to_le32(level);
> +
> +	virtio_gpu_queue_fenced_ctrl_buffer(vgdev, vbuf, &cmd_p->hdr, fence);
> +}
> +
> +void virtio_gpu_cmd_submit(struct virtio_gpu_device *vgdev,
> +			   void *data, uint32_t data_size,
> +			   uint32_t ctx_id, struct virtio_gpu_fence **fence)
> +{
> +	struct virtio_gpu_cmd_submit *cmd_p;
> +	struct virtio_gpu_vbuffer *vbuf;
> +
> +	cmd_p = virtio_gpu_alloc_cmd(vgdev, &vbuf, sizeof(*cmd_p));
> +	memset(cmd_p, 0, sizeof(*cmd_p));
> +
> +	vbuf->data_buf = data;
> +	vbuf->data_size = data_size;
> +
> +	cmd_p->hdr.type = cpu_to_le32(VIRTIO_GPU_CMD_SUBMIT_3D);
> +	cmd_p->hdr.ctx_id = cpu_to_le32(ctx_id);
> +	cmd_p->size = cpu_to_le32(data_size);
> +
> +	virtio_gpu_queue_fenced_ctrl_buffer(vgdev, vbuf, &cmd_p->hdr, fence);
> +}
> +
>  int virtio_gpu_object_attach(struct virtio_gpu_device *vgdev,
>  			     struct virtio_gpu_object *obj,
>  			     uint32_t resource_id,
> diff --git a/include/uapi/drm/Kbuild b/include/uapi/drm/Kbuild
> index 2d9a25d..38d4370 100644
> --- a/include/uapi/drm/Kbuild
> +++ b/include/uapi/drm/Kbuild
> @@ -17,3 +17,4 @@ header-y += tegra_drm.h
>  header-y += via_drm.h
>  header-y += vmwgfx_drm.h
>  header-y += msm_drm.h
> +header-y += virtgpu_drm.h
> diff --git a/include/uapi/drm/virtgpu_drm.h b/include/uapi/drm/virtgpu_drm.h
> new file mode 100644
> index 0000000..fc9e2d6
> --- /dev/null
> +++ b/include/uapi/drm/virtgpu_drm.h
> @@ -0,0 +1,167 @@
> +/*
> + * Copyright 2013 Red Hat
> + * All Rights Reserved.
> + *
> + * Permission is hereby granted, free of charge, to any person obtaining a
> + * copy of this software and associated documentation files (the "Software"),
> + * to deal in the Software without restriction, including without limitation
> + * the rights to use, copy, modify, merge, publish, distribute, sublicense,
> + * and/or sell copies of the Software, and to permit persons to whom the
> + * Software is furnished to do so, subject to the following conditions:
> + *
> + * The above copyright notice and this permission notice (including the next
> + * paragraph) shall be included in all copies or substantial portions of the
> + * Software.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> + * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> + * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
> + * THE AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
> + * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + * OTHER DEALINGS IN THE SOFTWARE.
> + */
> +#ifndef VIRTGPU_DRM_H
> +#define VIRTGPU_DRM_H
> +
> +#include <stddef.h>
> +#include "drm/drm.h"
> +
> +/* Please note that modifications to all structs defined here are
> + * subject to backwards-compatibility constraints.
> + *
> + * Do not use pointers, use uint64_t instead for 32 bit / 64 bit user/kernel
> + * compatibility Keep fields aligned to their size
> + */
> +
> +#define DRM_VIRTGPU_MAP         0x01
> +#define DRM_VIRTGPU_EXECBUFFER  0x02
> +#define DRM_VIRTGPU_GETPARAM    0x03
> +#define DRM_VIRTGPU_RESOURCE_CREATE 0x04
> +#define DRM_VIRTGPU_RESOURCE_INFO     0x05
> +#define DRM_VIRTGPU_TRANSFER_FROM_HOST 0x06
> +#define DRM_VIRTGPU_TRANSFER_TO_HOST 0x07
> +#define DRM_VIRTGPU_WAIT     0x08
> +#define DRM_VIRTGPU_GET_CAPS  0x09
> +
> +struct drm_virtgpu_map {
> +	uint64_t offset; /* use for mmap system call */
> +	uint32_t handle;
> +	uint32_t pad;
> +};
> +
> +struct drm_virtgpu_execbuffer {
> +	uint32_t		flags;		/* for future use */
> +	uint32_t size;
> +	uint64_t command; /* void* */
> +	uint64_t bo_handles;
> +	uint32_t num_bo_handles;
> +	uint32_t pad;
> +};
> +
> +#define VIRTGPU_PARAM_3D_FEATURES 1 /* do we have 3D features in the hw */
> +
> +struct drm_virtgpu_getparam {
> +	uint64_t param;
> +	uint64_t value;
> +};
> +
> +/* NO_BO flags? NO resource flag? */
> +/* resource flag for y_0_top */
> +struct drm_virtgpu_resource_create {
> +	uint32_t target;
> +	uint32_t format;
> +	uint32_t bind;
> +	uint32_t width;
> +	uint32_t height;
> +	uint32_t depth;
> +	uint32_t array_size;
> +	uint32_t last_level;
> +	uint32_t nr_samples;
> +	uint32_t flags;
> +	uint32_t bo_handle; /* if this is set - recreate a new resource attached to this bo ? */
> +	uint32_t res_handle;  /* returned by kernel */
> +	uint32_t size;        /* validate transfer in the host */
> +	uint32_t stride;      /* validate transfer in the host */
> +};
> +
> +struct drm_virtgpu_resource_info {
> +	uint32_t bo_handle;
> +	uint32_t res_handle;
> +	uint32_t size;
> +	uint32_t stride;
> +};
> +
> +struct drm_virtgpu_3d_box {
> +	uint32_t x;
> +	uint32_t y;
> +	uint32_t z;
> +	uint32_t w;
> +	uint32_t h;
> +	uint32_t d;
> +};
> +
> +struct drm_virtgpu_3d_transfer_to_host {
> +	uint32_t bo_handle;
> +	struct drm_virtgpu_3d_box box;
> +	uint32_t level;
> +	uint32_t offset;
> +};
> +
> +struct drm_virtgpu_3d_transfer_from_host {
> +	uint32_t bo_handle;
> +	struct drm_virtgpu_3d_box box;
> +	uint32_t level;
> +	uint32_t offset;
> +};
> +
> +#define VIRTGPU_WAIT_NOWAIT 1 /* like it */
> +struct drm_virtgpu_3d_wait {
> +	uint32_t handle; /* 0 is an invalid handle */
> +	uint32_t flags;
> +};
> +
> +struct drm_virtgpu_get_caps {
> +	uint32_t cap_set_id;
> +	uint32_t cap_set_ver;
> +	uint64_t addr;
> +	uint32_t size;
> +	uint32_t pad;
> +};
> +
> +#define DRM_IOCTL_VIRTGPU_MAP \
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_MAP, struct drm_virtgpu_map)
> +
> +#define DRM_IOCTL_VIRTGPU_EXECBUFFER \
> +	DRM_IOW(DRM_COMMAND_BASE + DRM_VIRTGPU_EXECBUFFER,\
> +		struct drm_virtgpu_execbuffer)
> +
> +#define DRM_IOCTL_VIRTGPU_GETPARAM \
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_GETPARAM,\
> +		struct drm_virtgpu_getparam)
> +
> +#define DRM_IOCTL_VIRTGPU_RESOURCE_CREATE			\
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_RESOURCE_CREATE,	\
> +		struct drm_virtgpu_resource_create)
> +
> +#define DRM_IOCTL_VIRTGPU_RESOURCE_INFO \
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_RESOURCE_INFO, \
> +		 struct drm_virtgpu_resource_info)
> +
> +#define DRM_IOCTL_VIRTGPU_TRANSFER_FROM_HOST \
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_TRANSFER_FROM_HOST,	\
> +		struct drm_virtgpu_3d_transfer_from_host)
> +
> +#define DRM_IOCTL_VIRTGPU_TRANSFER_TO_HOST \
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_TRANSFER_TO_HOST,	\
> +		struct drm_virtgpu_3d_transfer_to_host)
> +
> +#define DRM_IOCTL_VIRTGPU_WAIT				\
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_WAIT,	\
> +		struct drm_virtgpu_3d_wait)
> +
> +#define DRM_IOCTL_VIRTGPU_GET_CAPS \
> +	DRM_IOWR(DRM_COMMAND_BASE + DRM_VIRTGPU_GET_CAPS, \
> +	struct drm_virtgpu_get_caps)
> +
> +#endif
> diff --git a/include/uapi/linux/virtio_gpu.h b/include/uapi/linux/virtio_gpu.h
> index 478be52..7f4f9ce 100644
> --- a/include/uapi/linux/virtio_gpu.h
> +++ b/include/uapi/linux/virtio_gpu.h
> @@ -40,6 +40,8 @@
>  
>  #include <linux/types.h>
>  
> +#define VIRTIO_GPU_FEATURE_VIRGL 0
> +

I'd prefer it named VIRTIO_GPU_F_VIRGL for consistency with other
devices.



>  enum virtio_gpu_ctrl_type {
>  	VIRTIO_GPU_UNDEFINED = 0,
>  
> @@ -52,6 +54,18 @@ enum virtio_gpu_ctrl_type {
>  	VIRTIO_GPU_CMD_TRANSFER_TO_HOST_2D,
>  	VIRTIO_GPU_CMD_RESOURCE_ATTACH_BACKING,
>  	VIRTIO_GPU_CMD_RESOURCE_DETACH_BACKING,
> +	VIRTIO_GPU_CMD_GET_CAPSET_INFO,
> +	VIRTIO_GPU_CMD_GET_CAPSET,
> +
> +	/* 3d commands */
> +	VIRTIO_GPU_CMD_CTX_CREATE = 0x0200,
> +	VIRTIO_GPU_CMD_CTX_DESTROY,
> +	VIRTIO_GPU_CMD_CTX_ATTACH_RESOURCE,
> +	VIRTIO_GPU_CMD_CTX_DETACH_RESOURCE,
> +	VIRTIO_GPU_CMD_RESOURCE_CREATE_3D,
> +	VIRTIO_GPU_CMD_TRANSFER_TO_HOST_3D,
> +	VIRTIO_GPU_CMD_TRANSFER_FROM_HOST_3D,
> +	VIRTIO_GPU_CMD_SUBMIT_3D,
>  
>  	/* cursor commands */
>  	VIRTIO_GPU_CMD_UPDATE_CURSOR = 0x0300,
> @@ -60,6 +74,8 @@ enum virtio_gpu_ctrl_type {
>  	/* success responses */
>  	VIRTIO_GPU_RESP_OK_NODATA = 0x1100,
>  	VIRTIO_GPU_RESP_OK_DISPLAY_INFO,
> +	VIRTIO_GPU_RESP_OK_CAPSET_INFO,
> +	VIRTIO_GPU_RESP_OK_CAPSET,
>  
>  	/* error responses */
>  	VIRTIO_GPU_RESP_ERR_UNSPEC = 0x1200,
> @@ -180,13 +196,107 @@ struct virtio_gpu_resp_display_info {
>  	} pmodes[VIRTIO_GPU_MAX_SCANOUTS];
>  };
>  
> +/* data passed in the control vq, 3d related */
> +
> +struct virtio_gpu_box {
> +	__le32 x, y, z;
> +	__le32 w, h, d;
> +};
> +
> +/* VIRTIO_GPU_CMD_TRANSFER_TO_HOST_3D, VIRTIO_GPU_CMD_TRANSFER_FROM_HOST_3D */
> +struct virtio_gpu_transfer_host_3d {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	struct virtio_gpu_box box;
> +	__le64 offset;
> +	__le32 resource_id;
> +	__le32 level;
> +	__le32 stride;
> +	__le32 layer_stride;
> +};
> +
> +/* VIRTIO_GPU_CMD_RESOURCE_CREATE_3D */
> +#define VIRTIO_GPU_RESOURCE_FLAG_Y_0_TOP (1 << 0)
> +struct virtio_gpu_resource_create_3d {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	__le32 resource_id;
> +	__le32 target;
> +	__le32 format;
> +	__le32 bind;
> +	__le32 width;
> +	__le32 height;
> +	__le32 depth;
> +	__le32 array_size;
> +	__le32 last_level;
> +	__le32 nr_samples;
> +	__le32 flags;
> +	__le32 padding;
> +};
> +
> +/* VIRTIO_GPU_CMD_CTX_CREATE */
> +struct virtio_gpu_ctx_create {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	__le32 nlen;
> +	__le32 padding;
> +	char debug_name[64];
> +};
> +
> +/* VIRTIO_GPU_CMD_CTX_DESTROY */
> +struct virtio_gpu_ctx_destroy {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +};
> +
> +/* VIRTIO_GPU_CMD_CTX_ATTACH_RESOURCE, VIRTIO_GPU_CMD_CTX_DETACH_RESOURCE */
> +struct virtio_gpu_ctx_resource {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	__le32 resource_id;
> +	__le32 padding;
> +};
> +
> +/* VIRTIO_GPU_CMD_SUBMIT_3D */
> +struct virtio_gpu_cmd_submit {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	__le32 size;
> +	__le32 padding;
> +};
> +
> +#define VIRTIO_GPU_CAPSET_VIRGL 1
> +
> +/* VIRTIO_GPU_CMD_GET_CAPSET_INFO */
> +struct virtio_gpu_get_capset_info {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	__le32 capset_index;
> +	__le32 padding;
> +};
> +
> +/* VIRTIO_GPU_RESP_OK_CAPSET_INFO */
> +struct virtio_gpu_resp_capset_info {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	__le32 capset_id;
> +	__le32 capset_max_version;
> +	__le32 capset_max_size;
> +	__le32 padding;
> +};
> +
> +/* VIRTIO_GPU_CMD_GET_CAPSET */
> +struct virtio_gpu_get_capset {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	__le32 capset_id;
> +	__le32 capset_version;
> +};
> +
> +/* VIRTIO_GPU_RESP_OK_CAPSET */
> +struct virtio_gpu_resp_capset {
> +	struct virtio_gpu_ctrl_hdr hdr;
> +	uint8_t capset_data[];
> +};
> +
>  #define VIRTIO_GPU_EVENT_DISPLAY (1 << 0)
>  
>  struct virtio_gpu_config {
>  	__u32 events_read;
>  	__u32 events_clear;
>  	__u32 num_scanouts;
> -	__u32 reserved;
> +	__u32 num_capsets;
>  };
>  
>  /* simple formats for fbcon/X use */
> -- 
> 1.8.3.1
