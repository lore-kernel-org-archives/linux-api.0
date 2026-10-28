Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197405;
	b=A4ix/sbrc6rxKy0LkmB1sBy6JbNvaQpbQMw9OEioAFsIwNUBc64xgqKHoScDIkcBwDrA
	 q1Th0LQ8S8jSRjCLTgYDd7auYHunoHPjqCZKixYEx+RtaXZF4WdosvOCzbcHJH7P+xy/3
	 3fbjeYmIElS55rIVTRYGLVO2EQFRaNSxGOsnRoDtxvDInMMCIqYasueRshTwF01G/fs7g
	 bdehWTC5x4VNpXGbL9FKGRwxxKDhyHpBof8tNletsDREqnF3LcVS6q0k4/9vs9YysrB5z
	 BS+WO6H3qnrQ/9zxSRcdQaov6HOwfeGmLGJPo+D9L2EATzHz151HAi9stndkOy9hVRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197405;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:From:Content-Language:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=W+W+DUD43y8pQnK02FKiOjRqW2u16luQB/v+aklZIK8=;
	b=NkplveOW44ISWDRVqD2/sDW7sI47CinzYgqlMXoTCmzYfkYp7aIwwwuGWmNWORY4axqD
	 fO99ClahEQZX93VHPjbla2wI9TSB4wa69QLExJX5DM2DsojO9HYS7nVzVHxi+5/1C3jbs
	 RfgcvrkX6idB3er8KYE8XdcWcXLNMTOoeynstJSfURMuESfzQmR4txEjlWjuT1LhM7Jev
	 Jaahsgh3N+HijsmG7GlahnM5zJkNfWk1PXqqfcqmgHYuGBRdbdzkSKlp1H3uqRGc5MURK
	 U24oREh9W2391SFQO1TnLH6YMlvgGBfG+QFbwfj2VEzs23MTuRfjDWCUAwNN/kKgvMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=NI+VBiwT;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356B7606A330;
	Wed, 28 Oct 2026 14:23:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 356B7606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=NI+VBiwT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:From:Cc:To:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=W+W+DUD43y8pQnK02FKiOjRqW2u16luQB/v+aklZIK8=; b=NI+VBiwTxfDml2qGZfbUjLz4ZQ
	Ts/EuseKyJUTdKO5FGNSWaYHlKg6O51TFDoa5QHxBuTkisEpbTm0DKFGrxsADhbTeUhQXJ+Rqwcor
	DbrQzWO3rwZiSBQq6etJWilVHFFcke77S7Tm7Eylqv7qUssykEa0OQtye44uF406lQAp48rNwrftQ
	rVUt9w98vVYHehD6uwJ/ibqJrYirmN54h91D8q97M1nM+k85uV1yQFtgPU+mRuKgH9jj1J4NmW8v3
	LQV2J3n6JFbxecbNX35NXrcZlWsDbcmbwpR1QX2J2H4RaKuMXSH+wbl2HIXPCvxU+qxb5ftMNTu42
	PrBLLblA==;
Received: from [179.105.94.163] (helo=[192.168.0.2])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1xM4Ya-00Cwqz-Cq; Wed, 28 Oct 2026 15:23:12 +0100
Message-ID: <25e3d341-91d9-4080-8975-a5622b84726f@igalia.com>
Date: Wed, 28 Oct 2026 11:23:08 -0300
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] drm/v3d: add write-back BO mappings and cache sync
To: =?UTF-8?B?7J207J6s7ZuI?= <dlwognsdc6100@gmail.com>,
 Melissa Wen <mwen@igalia.com>
Cc: Iago Toral Quiroga <itoral@igalia.com>, dri-devel@lists.freedesktop.org,
 linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAE5fF3jr6A=UiC6vMv1q=JM4Fjm1n+eX4xCsRBQycxybk2oWAg@mail.gmail.com>
From: =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>
Content-Language: en-US
Autocrypt: addr=mcanal@igalia.com; keydata=
 xsBNBGcCwywBCADgTji02Sv9zjHo26LXKdCaumcSWglfnJ93rwOCNkHfPIBll85LL9G0J7H8
 /PmEL9y0LPo9/B3fhIpbD8VhSy9Sqz8qVl1oeqSe/rh3M+GceZbFUPpMSk5pNY9wr5raZ63d
 gJc1cs8XBhuj1EzeE8qbP6JAmsL+NMEmtkkNPfjhX14yqzHDVSqmAFEsh4Vmw6oaTMXvwQ40
 SkFjtl3sr20y07cJMDe++tFet2fsfKqQNxwiGBZJsjEMO2T+mW7DuV2pKHr9aifWjABY5EPw
 G7qbrh+hXgfT+njAVg5+BcLz7w9Ju/7iwDMiIY1hx64Ogrpwykj9bXav35GKobicCAwHABEB
 AAHNIE1hw61yYSBDYW5hbCA8bWNhbmFsQGlnYWxpYS5jb20+wsCRBBMBCAA7FiEE+ORdfQEW
 dwcppnfRP/MOinaI+qoFAmcCwywCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQ
 P/MOinaI+qoUBQgAqz2gzUP7K3EBI24+a5FwFlruQGtim85GAJZXToBtzsfGLLVUSCL3aF/5
 O335Bh6ViSBgxmowIwVJlS/e+L95CkTGzIIMHgyUZfNefR2L3aZA6cgc9z8cfow62Wu8eXnq
 GM/+WWvrFQb/dBKKuohfBlpThqDWXxhozazCcJYYHradIuOM8zyMtCLDYwPW7Vqmewa+w994
 7Lo4CgOhUXVI2jJSBq3sgHEPxiUBOGxvOt1YBg7H9C37BeZYZxFmU8vh7fbOsvhx7Aqu5xV7
 FG+1ZMfDkv+PixCuGtR5yPPaqU2XdjDC/9mlRWWQTPzg74RLEw5sz/tIHQPPm6ROCACFls7A
 TQRnAsMsAQgAxTU8dnqzK6vgODTCW2A6SAzcvKztxae4YjRwN1SuGhJR2isJgQHoOH6oCItW
 Xc1CGAWnci6doh1DJvbbB7uvkQlbeNxeIz0OzHSiB+pb1ssuT31Hz6QZFbX4q+crregPIhr+
 0xeDi6Mtu+paYprI7USGFFjDUvJUf36kK0yuF2XUOBlF0beCQ7Jhc+UoI9Akmvl4sHUrZJzX
 LMeajARnSBXTcig6h6/NFVkr1mi1uuZfIRNCkxCE8QRYebZLSWxBVr3h7dtOUkq2CzL2kRCK
 T2rKkmYrvBJTqSvfK3Ba7QrDg3szEe+fENpL3gHtH6h/XQF92EOulm5S5o0I+ceREwARAQAB
 wsB2BBgBCAAgFiEE+ORdfQEWdwcppnfRP/MOinaI+qoFAmcCwywCGwwACgkQP/MOinaI+qpI
 zQf+NAcNDBXWHGA3lgvYvOU31+ik9bb30xZ7IqK9MIi6TpZqL7cxNwZ+FAK2GbUWhy+/gPkX
 it2gCAJsjo/QEKJi7Zh8IgHN+jfim942QZOkU+p/YEcvqBvXa0zqW0sYfyAxkrf/OZfTnNNE
 Tr+uBKNaQGO2vkn5AX5l8zMl9LCH3/Ieaboni35qEhoD/aM0Kpf93PhCvJGbD4n1DnRhrxm1
 uEdQ6HUjWghEjC+Jh9xUvJco2tUTepw4OwuPxOvtuPTUa1kgixYyG1Jck/67reJzMigeuYFt
 raV3P8t/6cmtawVjurhnCDuURyhUrjpRhgFp+lW8OGr6pepHol/WFIOQEg==
In-Reply-To: <CAE5fF3jr6A=UiC6vMv1q=JM4Fjm1n+eX4xCsRBQycxybk2oWAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi JaeHoon,

Thanks for your patch. See my comments below:

On 25/10/26 09:09, 이재훈 wrote:
> From: JaeHoon Lee <dlwognsdc610@gmail.com>
> 
> Add V3D_BO_WB_MMAP to request WB CPU mappings. Keep WC as the default.

This needs to cover dma-buf export. v3d doesn't implement .export, so a
WB BO gets exported with the generic drm_gem_prime_dmabuf_ops. Those
have no begin_cpu_access/end_cpu_access, so DMA_BUF_IOCTL_SYNC does
nothing and an importer has no way to keep the CPU view coherent.

For example, Panfrost has a custom dma-buf implementation, implemented
in commit 3ae6637378e6 ("drm/panfrost: Provide a custom dma_buf
implementation").

I'm not sure if you tested this implementation, but at the moment, cache
maintaince won't work.

I believe we should invest in a more generic approach that both V3D and
Panfrost can make use of. I just worked on a draft of this
implementation and I'll share the result here in the next few days. Then
you can base your userspace implementation on it.

Best regards,
- Maíra

> Set map_wc before getting the BO pages, and use WB for the kernel mapping
> only when the BO is native and uses WB.
> 
> Add V3D_SYNC_BO, based on Panfrost's BO sync API. It takes a list of BO
> ranges and supports cache flush or flush and invalidate. Reject imported
> BOs and invalid ranges or sync types.
> 
> Indirect CSD uses a CPU job to read three 32-bit workgroup counts. Sync
> this 12-byte input range before the CPU reads it from a WB BO.
> 
> Signed-off-by: JaeHoon Lee <dlwognsdc610@gmail.com>
> Assisted-by: LLM
> ---
> Sorry, the wrong version of the email was sent without my Signed-off-by
> trailer. I also forgot to Cc Iago Toral.
> Please use this version instead.
> 
> This is an RFC for the V3DV host-cached memory work. The Mesa changes are
> on this branch:
> https://gitlab.freedesktop.org/yserrr/mesa/-/commits/v3dv-host-cached
> 
> V3DV uses WB for native HOST_CACHED memory. Internal BOs, including the
> uniform BO, still use WC. Shared allocations, images and TRANSFER_DST
> buffers also use WC. TRANSFER_DST needs cache sync in the CPU jobs that
> copy query results.
> 
> Hardware tests were run on a Raspberry Pi 5 with a backport to
> 6.18.34 and a rebuilt V3DV driver. Native BO creation and
> mapping, sync batches, and checks for invalid inputs passed.
> 
> If I have missed anything, please let me know so I can fix it.
> 
> Base: drm-misc-next cf61bef3801c3c9d0d8c39026b7b2fb242898a3a
> 
> 
>   drivers/gpu/drm/v3d/v3d_bo.c    | 127 ++++++++++++++++++++++++++++++++++++++--
>   drivers/gpu/drm/v3d/v3d_drv.c   |   1 +
>   drivers/gpu/drm/v3d/v3d_drv.h   |   3 +
>   drivers/gpu/drm/v3d/v3d_sched.c |  16 +++++
>   include/uapi/drm/v3d_drm.h      |  52 +++++++++++++++-
>   5 files changed, 192 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
> index db95a2fac..1eaa57c64 100644
> --- a/drivers/gpu/drm/v3d/v3d_bo.c
> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
> @@ -16,6 +16,8 @@
>    */
> 
>   #include <linux/dma-buf.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/uaccess.h>
>   #include <linux/vmalloc.h>
> 
>   #include <drm/drm_print.h>
> @@ -147,8 +149,8 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
>          return 0;
>   }
> 
> -struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file
> *file_priv,
> -                            size_t unaligned_size)
> +static struct v3d_bo *v3d_bo_create_flags(struct drm_device *dev,
> +                                         size_t unaligned_size, u32 flags)
>   {
>          struct drm_gem_shmem_object *shmem_obj;
>          struct v3d_bo *bo;
> @@ -159,6 +161,12 @@ struct v3d_bo *v3d_bo_create(struct drm_device
> *dev, struct drm_file *file_priv,
>                  return ERR_CAST(shmem_obj);
>          bo = to_v3d_bo(&shmem_obj->base);
>          bo->vaddr = NULL;
> +       /*
> +        * Use map_wc=true for WC by default.
> +        * V3D_BO_WB_MMAP sets map_wc=false for WB.
> +        * WB memory needs explicit cache sync.
> +        */
> +       bo->base.map_wc = !(flags & V3D_BO_WB_MMAP);
> 
>          ret = v3d_bo_create_finish(&shmem_obj->base);
>          if (ret)
> @@ -171,6 +179,12 @@ struct v3d_bo *v3d_bo_create(struct drm_device
> *dev, struct drm_file *file_priv,
>          return ERR_PTR(ret);
>   }
> 
> +struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file
> *file_priv,
> +                            size_t unaligned_size)
> +{
> +       return v3d_bo_create_flags(dev, unaligned_size, 0);
> +}
> +
>   struct drm_gem_object *
>   v3d_prime_import_sg_table(struct drm_device *dev,
>                            struct dma_buf_attachment *attach,
> @@ -195,9 +209,13 @@ v3d_prime_import_sg_table(struct drm_device *dev,
>   void v3d_get_bo_vaddr(struct v3d_bo *bo)
>   {
>          struct drm_gem_shmem_object *obj = &bo->base;
> +       pgprot_t prot = pgprot_writecombine(PAGE_KERNEL);
> +
> +       if (!drm_gem_is_imported(&obj->base) && !obj->map_wc)
> +               prot = PAGE_KERNEL;
> 
>          bo->vaddr = vmap(obj->pages, obj->base.size >> PAGE_SHIFT, VM_MAP,
> -                        pgprot_writecombine(PAGE_KERNEL));
> +                        prot);
>   }
> 
>   void v3d_put_bo_vaddr(struct v3d_bo *bo)
> @@ -213,12 +231,12 @@ int v3d_create_bo_ioctl(struct drm_device *dev,
> void *data,
>          struct v3d_bo *bo = NULL;
>          int ret;
> 
> -       if (args->flags != 0) {
> +       if (args->flags & ~V3D_BO_WB_MMAP) {
>                  drm_dbg(dev, "unknown create_bo flags: %d\n", args->flags);
>                  return -EINVAL;
>          }
> 
> -       bo = v3d_bo_create(dev, file_priv, PAGE_ALIGN(args->size));
> +       bo = v3d_bo_create_flags(dev, PAGE_ALIGN(args->size), args->flags);
>          if (IS_ERR(bo))
>                  return PTR_ERR(bo);
> 
> @@ -230,6 +248,105 @@ int v3d_create_bo_ioctl(struct drm_device *dev,
> void *data,
>          return ret;
>   }
> 
> +int v3d_bo_sync(struct drm_gem_object *obj, u32 type, u32 offset, u32 size)
> +{
> +       struct drm_gem_shmem_object *shmem = &to_v3d_bo(obj)->base;
> +       struct sg_table *sgt;
> +       struct scatterlist *sg;
> +       unsigned int i;
> +
> +       if (offset + size < offset)
> +               return -EINVAL;
> +
> +       if (offset + size > obj->size)
> +               return -EINVAL;
> +
> +       if (drm_gem_is_imported(obj))
> +               return -EINVAL;
> +
> +       if (type != V3D_BO_SYNC_CPU_CACHE_FLUSH &&
> +           type != V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE)
> +               return -EINVAL;
> +
> +       if (shmem->map_wc)
> +               return 0;
> +
> +       if (!size)
> +               return 0;
> +
> +       sgt = drm_gem_shmem_get_pages_sgt(shmem);
> +       if (IS_ERR(sgt))
> +               return PTR_ERR(sgt);
> +
> +       for_each_sgtable_dma_sg(sgt, sg, i) {
> +               dma_addr_t addr = sg_dma_address(sg);
> +               size_t len = sg_dma_len(sg);
> +
> +               if (!size)
> +                       break;
> +
> +               if (offset >= len) {
> +                       offset -= len;
> +                       continue;
> +               }
> +
> +               addr += offset;
> +               len -= offset;
> +               len = min_t(size_t, len, size);
> +               size -= len;
> +               offset = 0;
> +
> +               dma_sync_single_for_device(obj->dev->dev, addr, len,
> DMA_TO_DEVICE);
> +               if (type == V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE)
> +                       dma_sync_single_for_cpu(obj->dev->dev, addr,
> len, DMA_FROM_DEVICE);
> +       }
> +
> +       return 0;
> +}
> +
> +int v3d_sync_bo_ioctl(struct drm_device *dev, void *data,
> +                     struct drm_file *file_priv)
> +{
> +       struct drm_v3d_sync_bo *args = data;
> +       struct drm_v3d_bo_sync_op *ops;
> +       struct drm_gem_object *obj;
> +       unsigned int i;
> +       int ret = 0;
> +
> +       if (args->pad)
> +               return -EINVAL;
> +
> +       if (!args->op_count)
> +               return 0;
> +
> +       ops = kvmalloc_objs(*ops, args->op_count);
> +       if (!ops)
> +               return -ENOMEM;
> +
> +       if (copy_from_user(ops, u64_to_user_ptr(args->ops),
> +                          args->op_count * sizeof(*ops))) {
> +               ret = -EFAULT;
> +               goto out;
> +       }
> +
> +       for (i = 0; i < args->op_count; i++) {
> +               obj = drm_gem_object_lookup(file_priv, ops[i].handle);
> +               if (!obj) {
> +                       ret = -ENOENT;
> +                       goto out;
> +               }
> +
> +               ret = v3d_bo_sync(obj, ops[i].type, ops[i].offset, ops[i].size);
> +               drm_gem_object_put(obj);
> +               if (ret)
> +                       goto out;
> +       }
> +
> +out:
> +       kvfree(ops);
> +       return ret;
> +}
> +
>   int v3d_mmap_bo_ioctl(struct drm_device *dev, void *data,
>                        struct drm_file *file_priv)
>   {
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
> index 8d914dbc3..0fcf6ceed 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.c
> +++ b/drivers/gpu/drm/v3d/v3d_drv.c
> @@ -264,6 +264,7 @@ static const struct drm_ioctl_desc v3d_drm_ioctls[] = {
>          DRM_IOCTL_DEF_DRV(V3D_SUBMIT_CPU, v3d_submit_cpu_ioctl,
> DRM_RENDER_ALLOW | DRM_AUTH),
>          DRM_IOCTL_DEF_DRV(V3D_PERFMON_GET_COUNTER,
> v3d_perfmon_get_counter_ioctl, DRM_RENDER_ALLOW),
>          DRM_IOCTL_DEF_DRV(V3D_PERFMON_SET_GLOBAL,
> v3d_perfmon_set_global_ioctl, DRM_RENDER_ALLOW),
> +       DRM_IOCTL_DEF_DRV(V3D_SYNC_BO, v3d_sync_bo_ioctl, DRM_RENDER_ALLOW),
>   };
> 
>   static const struct drm_driver v3d_drm_driver = {
> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
> index 7c7bdf6e5..d5db64bf5 100644
> --- a/drivers/gpu/drm/v3d/v3d_drv.h
> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
> @@ -595,10 +595,13 @@ struct v3d_bo *v3d_bo_create(struct drm_device
> *dev, struct drm_file *file_priv,
>                               size_t size);
>   void v3d_get_bo_vaddr(struct v3d_bo *bo);
>   void v3d_put_bo_vaddr(struct v3d_bo *bo);
> +int v3d_bo_sync(struct drm_gem_object *obj, u32 type, u32 offset, u32 size);
>   int v3d_create_bo_ioctl(struct drm_device *dev, void *data,
>                          struct drm_file *file_priv);
>   int v3d_mmap_bo_ioctl(struct drm_device *dev, void *data,
>                        struct drm_file *file_priv);
> +int v3d_sync_bo_ioctl(struct drm_device *dev, void *data,
> +                     struct drm_file *file_priv);
>   int v3d_get_bo_offset_ioctl(struct drm_device *dev, void *data,
>                              struct drm_file *file_priv);
>   int v3d_wait_bo_ioctl(struct drm_device *dev, void *data,
> diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
> index 1924e3440..17648a913 100644
> --- a/drivers/gpu/drm/v3d/v3d_sched.c
> +++ b/drivers/gpu/drm/v3d/v3d_sched.c
> @@ -396,6 +396,22 @@
> v3d_rewrite_csd_job_wg_counts_from_indirect(struct v3d_cpu_job *job)
>          struct drm_v3d_submit_csd *args = &indirect_csd->job->args;
>          struct v3d_dev *v3d = job->base.v3d;
>          u32 num_batches, *wg_counts;
> +       int ret;
> +
> +       /*
> +        * WB memory needs cache sync before the CPU reads the three counts.
> +        * The GPU job that wrote them must finish first.
> +        */
> +       if (!drm_gem_is_imported(&bo->base.base)) {
> +               ret = v3d_bo_sync(&bo->base.base,
> +                                V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE,
> +                                indirect_csd->offset, 3 * sizeof(*wg_counts));
> +               if (ret) {
> +                       dma_fence_set_error(job->base.done_fence, ret);
> +
> dma_fence_set_error(indirect_csd->job->base.done_fence, ret);
> +                       return;
> +               }
> +       }
> 
>          v3d_get_bo_vaddr(bo);
>          v3d_get_bo_vaddr(indirect);
> diff --git a/include/uapi/drm/v3d_drm.h b/include/uapi/drm/v3d_drm.h
> index d9b01f4c3..ca7352e96 100644
> --- a/include/uapi/drm/v3d_drm.h
> +++ b/include/uapi/drm/v3d_drm.h
> @@ -44,6 +44,7 @@ extern "C" {
>   #define DRM_V3D_SUBMIT_CPU                        0x0b
>   #define DRM_V3D_PERFMON_GET_COUNTER               0x0c
>   #define DRM_V3D_PERFMON_SET_GLOBAL                0x0d
> +#define DRM_V3D_SYNC_BO                           0x0e
> 
>   #define DRM_IOCTL_V3D_SUBMIT_CL           DRM_IOWR(DRM_COMMAND_BASE +
> DRM_V3D_SUBMIT_CL, struct drm_v3d_submit_cl)
>   #define DRM_IOCTL_V3D_WAIT_BO             DRM_IOWR(DRM_COMMAND_BASE +
> DRM_V3D_WAIT_BO, struct drm_v3d_wait_bo)
> @@ -64,6 +65,8 @@ extern "C" {
>                                                     struct
> drm_v3d_perfmon_get_counter)
>   #define DRM_IOCTL_V3D_PERFMON_SET_GLOBAL  DRM_IOW(DRM_COMMAND_BASE +
> DRM_V3D_PERFMON_SET_GLOBAL, \
>                                                     struct
> drm_v3d_perfmon_set_global)
> +#define DRM_IOCTL_V3D_SYNC_BO             DRM_IOWR(DRM_COMMAND_BASE +
> DRM_V3D_SYNC_BO, \
> +                                                  struct drm_v3d_sync_bo)
> 
>   #define DRM_V3D_SUBMIT_CL_FLUSH_CACHE             0x01
>   #define DRM_V3D_SUBMIT_EXTENSION                 0x02
> @@ -237,11 +240,13 @@ struct drm_v3d_wait_bo {
>          __u64 timeout_ns;
>   };
> 
> +/* WB BOs require explicit cache sync. */
> +#define V3D_BO_WB_MMAP 4
> +
>   /**
>    * struct drm_v3d_create_bo - ioctl argument for creating V3D BOs.
>    *
> - * There are currently no values for the flags argument, but it may be
> - * used in a future extension.
> + * The flags argument may request V3D_BO_WB_MMAP for a write-back CPU mapping.
>    */
>   struct drm_v3d_create_bo {
>          __u32 size;
> @@ -278,6 +283,49 @@ struct drm_v3d_mmap_bo {
>          __u64 offset;
>   };
> 
> +/* Valid flags to pass to drm_v3d_bo_sync_op */
> +#define V3D_BO_SYNC_CPU_CACHE_FLUSH                    0
> +#define V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE     1
> +
> +/**
> + * struct drm_v3d_bo_sync_op - BO map sync op
> + */
> +struct drm_v3d_bo_sync_op {
> +       /** Handle of the buffer object to sync. */
> +       __u32 handle;
> +
> +       /** Type of sync operation. */
> +       __u32 type;
> +
> +       /**
> +        * Offset into the BO at which the sync range starts.
> +        *
> +        * This will be rounded down to the nearest cache line as needed.
> +        */
> +       __u32 offset;
> +
> +       /**
> +        * Size of the range to sync
> +        *
> +        * size + offset will be rounded up to the nearest cache line as
> +        * needed.
> +        */
> +       __u32 size;
> +};
> +
> +/**
> + * struct drm_v3d_sync_bo - ioctl argument for syncing BO maps
> + */
> +struct drm_v3d_sync_bo {
> +       /** Array of struct drm_v3d_bo_sync_op */
> +       __u64 ops;
> +
> +       /** Number of BO sync ops */
> +       __u32 op_count;
> +
> +       __u32 pad;
> +};
> +
>   enum drm_v3d_param {
>          DRM_V3D_PARAM_V3D_UIFCFG,
>          DRM_V3D_PARAM_V3D_HUB_IDENT1,

