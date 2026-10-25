Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792921590;
	b=0owEg/2Lgfoz1396t931Dvt/093But7DgA5IL1yKVE0qtXxss8haeC2TlC8fN8qW5SlB
	 IfJd8EX/MOdspX3P+xV1G6lg1cEGULRyUEBgR5pvzIIe7+FIHDmOBCsQ7HW4wTEVeq678
	 3sZ3h+Ai3wzV8SHusk769lbDw2uq52HeOG3tW0bxxWsnaTFV4JDiYfFHKutmTwuWIpu01
	 Y2i3GK6kf7P+YTa0nwyqyO1ijQAoF8pOODQYYQa1IyIRG08i3Wap7M1kw7feozMAZiUhE
	 tPuqtdp6okPX0cy1P9Jyh8sx0GVzVv/0Ez9qbtpDJ6mTcFcI0Zq//pux9eiJyBK8AmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792921590;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:Received:Received:Received:Received:Received:
	 Received:Received:Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:
	 To:Cc:Content-Type;
	bh=rQKpdTQJbLGtJOgvQhp/XHq9+mhq92mx00sXx2/2hHs=;
	b=ht+IPnFhJVG60LNVabeZd+92Yan+xZ66CWQ/WZ+20O7kPX3GF/VNbTPN7vp0k2kKBXIt
	 TOtPENSbgTdUvDkcMpKVm0eVIW3hTwx++Vfn0E9RJc5TOWPP6Dii1b1L+w6r9axr++vJp
	 StO+l01UOyKvVul6mBygoITnIdBzytM8JlPDLQ046dvoA/NbRObUV86IePoZVst8fB8m2
	 /5YQIjvNF3mQgFHM6OSDGikyBepQxC1fBkL51deUUAZpZ8NJcyHHV6iS32UsxM+Zdy5SF
	 BBuTo862AbLwTf0U0zZv3s1mL1TkuRmBct/pKSzObazy2YWD75JnM7anCWAPuWoIyxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JIRkVo7L;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C595F606A31B
	for <linux-api@vger.kernel.org>; Sun, 25 Oct 2026 09:46:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C595F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JIRkVo7L
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c445c95d553so267216866b.1
        for <linux-api@vger.kernel.org>; Sun, 25 Oct 2026 02:46:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792921588; cv=none;
        d=google.com; s=arc-20260327;
        b=QE5T/W64nPwNTJLzFBbzN/sBW1MJlyEo5qqyQZdq+VIONQyTaN7/77ggDyi1huV+bW
         A21QTnXYx/BPaec0hAaIDDJyC1xyxsShQxAOKNLYR0QMCeYis2Bqfx1tLeSk7ki73pDk
         koKl333HnQ281ZzAE+855i4Pbe2m7TdJ5v87HS+8KzW57TwZLxwJdsxZoD78q/KPhFM0
         3T1NtiFSkEQ4bJOaV48o8jS2yNS2gAzz88NQ94FslS7MJ1eWxTqUuLTiudMAn5hvfZa1
         ra7ynouaiyziZ4RxTwXITZ3wQkkgNlVfc199KKhojHlSE+e7NFfDY37tmFEIKatVa9XM
         DpDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:reply-to:mime-version
         :dkim-signature;
        bh=rQKpdTQJbLGtJOgvQhp/XHq9+mhq92mx00sXx2/2hHs=;
        fh=yPW8xWI/paM4yXU4Losf1A3AYJEDRVcnG+VB3tphPiI=;
        b=RqoG2CaqV7l7lwajzMv7rPrqbI6pQrtH+ZOSnyun+LBzatKuUEconr0KdwiZaVPmTW
         bRaPj5x9s/Js5Brvfg1Vs+/tJuEME2P4rX9y71hN6VWGpgRt6aav2k8tN5nGx/x2Z0zm
         eF2yyZLlh2BF3o5QQvv47FFrUD0Axane8T9v37PAcBzuU2CxMbGp8Y6YolXpEYMmpsAi
         FPD6TI0obcNTyas28EbUY0+NpAUVQXp1/Usd4fCdB2MtlE6adYhQYzSaUXEX/saKT0U3
         EIa4Xy/cBiOZWHSy0+WZdXXPLr19KNOxgcJeRMMLBtUYODH8npILIzzDZYUyjEmhilRz
         +ELw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792921588; x=1793526388; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rQKpdTQJbLGtJOgvQhp/XHq9+mhq92mx00sXx2/2hHs=;
        b=JIRkVo7LOOsEbTvzdMtahKOhRazuoR+NsWju6pw+2O1qjJVt+lG0PxpHTPbOXUOR5S
         NEMu2CpH2bWDnd9LZcLml9XCOWNrzlGXDPNxeLMYellrE8P6d38YtID1zytg8y1Gnfe6
         khx4nZInOtzIXUT1tatQ8vJnaKywIADDZWdv8F7gbPZJIfY/JQKQwk69Yd3FiVPTSAHl
         MkpMJQB/UiqWInPCFjxKWWhKjg61xTmm1UPvSDTelp25iBYJ/CO9wMdm3GGzLiJQTkoP
         9iOqJFmSrjUJiCLHhobO7U7a6Diq59WvJouFO5omxI5lfe063VJE0aaaFmF5zQ76wrP3
         43fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792921588; x=1793526388;
        h=content-type:cc:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rQKpdTQJbLGtJOgvQhp/XHq9+mhq92mx00sXx2/2hHs=;
        b=gPtUlBK0ZDQhaw+1BT40rmWwNM6+Uom3jr4Q2Qf4oyE9FTHKZtIfDwoU1Y01gAr4WN
         0rsz6RL4wEsRrWwtRkOnTh3RTHxQE63iJGXijCWzD9k5lC9IqKFtRtz074JnOkX1QOA+
         ZMb6MQpm++am1KRokRY0kuoDrOiDPd0uz3BKZN44P0NrS89+DxRtm8cuyi/Zrk8GAYN9
         lFR7hq8pvhroD/nrndsZ5QTmMvLFSEIVEhmWsdSIOoCDKZNXfWbWm64NsMb8Q4GiQ13z
         70dvziPeJFKLLzyAg9ffc7FB31iXgZPoVQqs+YR7pYhM8BjuweAK02U9Ba93aRakc3ha
         Lcjg==
X-Forwarded-Encrypted: i=1; AKwUvBwJhX3CxYsqbJzCX2Xuu89b7tos1tcBfYBvHNzjDPmUmjKDss3XxkaHwZfKQLr6GBAkcnk2mU6tpBM=@vger.kernel.org
X-Gm-Message-State: AFq9FYK0F+x2oT6GCaiwKZdHw7TjjDFnU1lnxuPDi5COqBWT5QYKUqMQ
	KpyYjr0gd5IkpuOjfYoiOUHJKdOwp/7LLZebjqpbRcSbGmqBwjOAUgnC4HidlHkLEQ6ZQ+eOrBa
	QRHkvSyILNfisjHIY6R2C4C8fcc8y9i8=
X-Gm-Gg: AYBFou0RgxaZxhUegwFyCgCdtx8dWAmaKZcAtsAeXB/E/z0OU9Axj4dCJhJ0z9x9pKL
	hNiDMD5rFL6KMhC/Wn05TTym1Oq/k9WV/bmaBUyklDoq28MvoRsL1OQrMLI11ygpNL6TrFo7z2J
	xbUxiIXgIl7pQT5R6C01w/Dh8OZoFVVZLK6i7WAX9KpKvrUBZSSLN9Sm40f78ZQohncdFXbh2LW
	8TVntWJ1rpY7Lh8DomsQLmqnY2MvLTqXUaneP/hmBC9GcsXuVsFOx6Iho4XX5FW+9aOMclHapku
	29YW/0c7uQI+Cn99pICFIGOtqUs2UMADWemxiDLgXm43N3X4cuNmRburK52v2EGwA9Nha/fK+QR
	urb/5iMU4Si11hkI2VcFFtXCvC9w/KjZbeYBK35TfQdMsvfe8iuvKLDA=
X-Received: by 2002:a17:907:6d06:b0:c45:c030:732a with SMTP id
 a640c23a62f3a-c46bde5d73bmr469430366b.35.1792921587732; Sun, 25 Oct 2026
 02:46:27 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 25 Oct 2026 02:46:27 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Sun, 25 Oct 2026 02:46:11 -0700
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sun, 25 Oct 2026 05:45:22 -0400
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 24 Oct 2026 14:42:35 -0700
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 24 Oct 2026 13:19:39 -0700
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 24 Oct 2026 13:14:11 -0700
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 24 Oct 2026 12:46:21 -0700
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 24 Oct 2026 12:33:20 -0700
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Sat, 24 Oct 2026 12:20:05 -0700
Reply-To: JaeHoon Lee <dlwognsdc610@gmail.com>
From: =?UTF-8?B?7J207J6s7ZuI?= <dlwognsdc6100@gmail.com>
Date: Sun, 25 Oct 2026 02:46:27 -0700
X-Gm-Features: AclHuK96i_lAiZ_E2-3njRuhfAO3qcT9D6j2GvJitw1WdwF_-HYTxxFwHPzE1Nc
Message-ID: <CAE5fF3hWujpToOw+0NAAFiMwMgvpx6Sc85VskTcp-nrQyo43sw@mail.gmail.com>
Subject: [RFC PATCH] drm/v3d: add write-back BO mappings and cache sync
To: Melissa Wen <mwen@igalia.com>, =?UTF-8?B?TWHDrXJhIENhbmFs?= <mcanal@igalia.com>
Cc: dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: JaeHoon Lee <dlwognsdc610@gmail.com>

Add V3D_BO_WB_MMAP to request WB CPU mappings. Keep WC as the default.
Set map_wc before getting the BO pages, and use WB for the kernel mapping
only when the BO is native and uses WB.

Add V3D_SYNC_BO, based on Panfrost's BO sync API. It takes a list of BO
ranges and supports cache flush or flush and invalidate. Reject imported
BOs and invalid ranges or sync types.

Indirect CSD uses a CPU job to read three 32-bit workgroup counts. Sync
this 12-byte input range before the CPU reads it from a WB BO.

Assisted-by: LLM
---
This is an RFC for the V3DV host-cached memory work. The Mesa changes are
on this branch:
https://gitlab.freedesktop.org/yserrr/mesa/-/commits/v3dv-host-cached

V3DV uses WB for native HOST_CACHED memory. Internal BOs, including the
uniform BO, still use WC. Shared allocations, images and TRANSFER_DST
buffers also use WC. TRANSFER_DST needs cache sync in the CPU jobs that
copy query results.

Validation:
- ARM64 W=1 build of the V3D driver on drm-misc-next passed.
- checkpatch --no-signoff: 0 errors, 0 warnings.
- The kernel and Mesa UAPI command, flags and struct layouts match.
- The actual sync functions passed 2,000 mock SG range cases with UBSan,
  plus ioctl error and reference cleanup checks.

Hardware tests used a Raspberry Pi 5 and a backport to 6.18.34+rpt-rpi-v8,
with 167 matching kernel symbol CRCs and the rebuilt V3DV driver:
- Native create/map, sync batches and invalid inputs: 15 checks passed.
- WC and WB CPU/GPU round trips: four passes each.
- A partial WB mapping at offset 256: 32 passes over 1 MiB. Data outside
  that range stayed unchanged.
- Indirect dispatch: six cases, 32 passes each, with no wrong results.
  These include a GPU writer and indirect dispatch in one command buffer,
  with no host wait between them, at offsets 0, 60 and 4092.
- No GPU reset or MMU error was logged. The stock module and graphics
  services were restored after the tests.

The hardware results are for the 6.18.34 backport. The drm-misc-next
version was build-tested, not booted.

Base: drm-misc-next cf61bef3801c3c9d0d8c39026b7b2fb242898a3a

 drivers/gpu/drm/v3d/v3d_bo.c    | 127 ++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/v3d/v3d_drv.c   |   1 +
 drivers/gpu/drm/v3d/v3d_drv.h   |   3 +
 drivers/gpu/drm/v3d/v3d_sched.c |  16 +++++
 include/uapi/drm/v3d_drm.h      |  52 +++++++++++++++-
 5 files changed, 192 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
index db95a2fac..1eaa57c64 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -16,6 +16,8 @@
  */

 #include <linux/dma-buf.h>
+#include <linux/dma-mapping.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>

 #include <drm/drm_print.h>
@@ -147,8 +149,8 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
 	return 0;
 }

-struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file
*file_priv,
-			     size_t unaligned_size)
+static struct v3d_bo *v3d_bo_create_flags(struct drm_device *dev,
+					  size_t unaligned_size, u32 flags)
 {
 	struct drm_gem_shmem_object *shmem_obj;
 	struct v3d_bo *bo;
@@ -159,6 +161,12 @@ struct v3d_bo *v3d_bo_create(struct drm_device
*dev, struct drm_file *file_priv,
 		return ERR_CAST(shmem_obj);
 	bo = to_v3d_bo(&shmem_obj->base);
 	bo->vaddr = NULL;
+	/*
+	 * Use map_wc=true for WC by default.
+	 * V3D_BO_WB_MMAP sets map_wc=false for WB.
+	 * WB memory needs explicit cache sync.
+	 */
+	bo->base.map_wc = !(flags & V3D_BO_WB_MMAP);

 	ret = v3d_bo_create_finish(&shmem_obj->base);
 	if (ret)
@@ -171,6 +179,12 @@ struct v3d_bo *v3d_bo_create(struct drm_device
*dev, struct drm_file *file_priv,
 	return ERR_PTR(ret);
 }

+struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file
*file_priv,
+			     size_t unaligned_size)
+{
+	return v3d_bo_create_flags(dev, unaligned_size, 0);
+}
+
 struct drm_gem_object *
 v3d_prime_import_sg_table(struct drm_device *dev,
 			  struct dma_buf_attachment *attach,
@@ -195,9 +209,13 @@ v3d_prime_import_sg_table(struct drm_device *dev,
 void v3d_get_bo_vaddr(struct v3d_bo *bo)
 {
 	struct drm_gem_shmem_object *obj = &bo->base;
+	pgprot_t prot = pgprot_writecombine(PAGE_KERNEL);
+
+	if (!drm_gem_is_imported(&obj->base) && !obj->map_wc)
+		prot = PAGE_KERNEL;

 	bo->vaddr = vmap(obj->pages, obj->base.size >> PAGE_SHIFT, VM_MAP,
-			 pgprot_writecombine(PAGE_KERNEL));
+			 prot);
 }

 void v3d_put_bo_vaddr(struct v3d_bo *bo)
@@ -213,12 +231,12 @@ int v3d_create_bo_ioctl(struct drm_device *dev,
void *data,
 	struct v3d_bo *bo = NULL;
 	int ret;

-	if (args->flags != 0) {
+	if (args->flags & ~V3D_BO_WB_MMAP) {
 		drm_dbg(dev, "unknown create_bo flags: %d\n", args->flags);
 		return -EINVAL;
 	}

-	bo = v3d_bo_create(dev, file_priv, PAGE_ALIGN(args->size));
+	bo = v3d_bo_create_flags(dev, PAGE_ALIGN(args->size), args->flags);
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);

@@ -230,6 +248,105 @@ int v3d_create_bo_ioctl(struct drm_device *dev,
void *data,
 	return ret;
 }

+int v3d_bo_sync(struct drm_gem_object *obj, u32 type, u32 offset, u32 size)
+{
+	struct drm_gem_shmem_object *shmem = &to_v3d_bo(obj)->base;
+	struct sg_table *sgt;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	if (offset + size < offset)
+		return -EINVAL;
+
+	if (offset + size > obj->size)
+		return -EINVAL;
+
+	if (drm_gem_is_imported(obj))
+		return -EINVAL;
+
+	if (type != V3D_BO_SYNC_CPU_CACHE_FLUSH &&
+	    type != V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE)
+		return -EINVAL;
+
+	if (shmem->map_wc)
+		return 0;
+
+	if (!size)
+		return 0;
+
+	sgt = drm_gem_shmem_get_pages_sgt(shmem);
+	if (IS_ERR(sgt))
+		return PTR_ERR(sgt);
+
+	for_each_sgtable_dma_sg(sgt, sg, i) {
+		dma_addr_t addr = sg_dma_address(sg);
+		size_t len = sg_dma_len(sg);
+
+		if (!size)
+			break;
+
+		if (offset >= len) {
+			offset -= len;
+			continue;
+		}
+
+		addr += offset;
+		len -= offset;
+		len = min_t(size_t, len, size);
+		size -= len;
+		offset = 0;
+
+		dma_sync_single_for_device(obj->dev->dev, addr, len, DMA_TO_DEVICE);
+		if (type == V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE)
+			dma_sync_single_for_cpu(obj->dev->dev, addr, len, DMA_FROM_DEVICE);
+	}
+
+	return 0;
+}
+
+int v3d_sync_bo_ioctl(struct drm_device *dev, void *data,
+		      struct drm_file *file_priv)
+{
+	struct drm_v3d_sync_bo *args = data;
+	struct drm_v3d_bo_sync_op *ops;
+	struct drm_gem_object *obj;
+	unsigned int i;
+	int ret = 0;
+
+	if (args->pad)
+		return -EINVAL;
+
+	if (!args->op_count)
+		return 0;
+
+	ops = kvmalloc_objs(*ops, args->op_count);
+	if (!ops)
+		return -ENOMEM;
+
+	if (copy_from_user(ops, u64_to_user_ptr(args->ops),
+			   args->op_count * sizeof(*ops))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	for (i = 0; i < args->op_count; i++) {
+		obj = drm_gem_object_lookup(file_priv, ops[i].handle);
+		if (!obj) {
+			ret = -ENOENT;
+			goto out;
+		}
+
+		ret = v3d_bo_sync(obj, ops[i].type, ops[i].offset, ops[i].size);
+		drm_gem_object_put(obj);
+		if (ret)
+			goto out;
+	}
+
+out:
+	kvfree(ops);
+	return ret;
+}
+
 int v3d_mmap_bo_ioctl(struct drm_device *dev, void *data,
 		      struct drm_file *file_priv)
 {
diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index 8d914dbc3..0fcf6ceed 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -264,6 +264,7 @@ static const struct drm_ioctl_desc v3d_drm_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(V3D_SUBMIT_CPU, v3d_submit_cpu_ioctl,
DRM_RENDER_ALLOW | DRM_AUTH),
 	DRM_IOCTL_DEF_DRV(V3D_PERFMON_GET_COUNTER,
v3d_perfmon_get_counter_ioctl, DRM_RENDER_ALLOW),
 	DRM_IOCTL_DEF_DRV(V3D_PERFMON_SET_GLOBAL,
v3d_perfmon_set_global_ioctl, DRM_RENDER_ALLOW),
+	DRM_IOCTL_DEF_DRV(V3D_SYNC_BO, v3d_sync_bo_ioctl, DRM_RENDER_ALLOW),
 };

 static const struct drm_driver v3d_drm_driver = {
diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index 7c7bdf6e5..d5db64bf5 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -595,10 +595,13 @@ struct v3d_bo *v3d_bo_create(struct drm_device
*dev, struct drm_file *file_priv,
 			     size_t size);
 void v3d_get_bo_vaddr(struct v3d_bo *bo);
 void v3d_put_bo_vaddr(struct v3d_bo *bo);
+int v3d_bo_sync(struct drm_gem_object *obj, u32 type, u32 offset, u32 size);
 int v3d_create_bo_ioctl(struct drm_device *dev, void *data,
 			struct drm_file *file_priv);
 int v3d_mmap_bo_ioctl(struct drm_device *dev, void *data,
 		      struct drm_file *file_priv);
+int v3d_sync_bo_ioctl(struct drm_device *dev, void *data,
+		      struct drm_file *file_priv);
 int v3d_get_bo_offset_ioctl(struct drm_device *dev, void *data,
 			    struct drm_file *file_priv);
 int v3d_wait_bo_ioctl(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 1924e3440..17648a913 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -396,6 +396,22 @@
v3d_rewrite_csd_job_wg_counts_from_indirect(struct v3d_cpu_job *job)
 	struct drm_v3d_submit_csd *args = &indirect_csd->job->args;
 	struct v3d_dev *v3d = job->base.v3d;
 	u32 num_batches, *wg_counts;
+	int ret;
+
+	/*
+	 * WB memory needs cache sync before the CPU reads the three counts.
+	 * The GPU job that wrote them must finish first.
+	 */
+	if (!drm_gem_is_imported(&bo->base.base)) {
+		ret = v3d_bo_sync(&bo->base.base,
+				 V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE,
+				 indirect_csd->offset, 3 * sizeof(*wg_counts));
+		if (ret) {
+			dma_fence_set_error(job->base.done_fence, ret);
+			dma_fence_set_error(indirect_csd->job->base.done_fence, ret);
+			return;
+		}
+	}

 	v3d_get_bo_vaddr(bo);
 	v3d_get_bo_vaddr(indirect);
diff --git a/include/uapi/drm/v3d_drm.h b/include/uapi/drm/v3d_drm.h
index d9b01f4c3..ca7352e96 100644
--- a/include/uapi/drm/v3d_drm.h
+++ b/include/uapi/drm/v3d_drm.h
@@ -44,6 +44,7 @@ extern "C" {
 #define DRM_V3D_SUBMIT_CPU                        0x0b
 #define DRM_V3D_PERFMON_GET_COUNTER               0x0c
 #define DRM_V3D_PERFMON_SET_GLOBAL                0x0d
+#define DRM_V3D_SYNC_BO                           0x0e

 #define DRM_IOCTL_V3D_SUBMIT_CL           DRM_IOWR(DRM_COMMAND_BASE +
DRM_V3D_SUBMIT_CL, struct drm_v3d_submit_cl)
 #define DRM_IOCTL_V3D_WAIT_BO             DRM_IOWR(DRM_COMMAND_BASE +
DRM_V3D_WAIT_BO, struct drm_v3d_wait_bo)
@@ -64,6 +65,8 @@ extern "C" {
 						   struct drm_v3d_perfmon_get_counter)
 #define DRM_IOCTL_V3D_PERFMON_SET_GLOBAL  DRM_IOW(DRM_COMMAND_BASE +
DRM_V3D_PERFMON_SET_GLOBAL, \
 						   struct drm_v3d_perfmon_set_global)
+#define DRM_IOCTL_V3D_SYNC_BO             DRM_IOWR(DRM_COMMAND_BASE +
DRM_V3D_SYNC_BO, \
+						   struct drm_v3d_sync_bo)

 #define DRM_V3D_SUBMIT_CL_FLUSH_CACHE             0x01
 #define DRM_V3D_SUBMIT_EXTENSION		  0x02
@@ -237,11 +240,13 @@ struct drm_v3d_wait_bo {
 	__u64 timeout_ns;
 };

+/* WB BOs require explicit cache sync. */
+#define V3D_BO_WB_MMAP 4
+
 /**
  * struct drm_v3d_create_bo - ioctl argument for creating V3D BOs.
  *
- * There are currently no values for the flags argument, but it may be
- * used in a future extension.
+ * The flags argument may request V3D_BO_WB_MMAP for a write-back CPU mapping.
  */
 struct drm_v3d_create_bo {
 	__u32 size;
@@ -278,6 +283,49 @@ struct drm_v3d_mmap_bo {
 	__u64 offset;
 };

+/* Valid flags to pass to drm_v3d_bo_sync_op */
+#define V3D_BO_SYNC_CPU_CACHE_FLUSH			0
+#define V3D_BO_SYNC_CPU_CACHE_FLUSH_AND_INVALIDATE	1
+
+/**
+ * struct drm_v3d_bo_sync_op - BO map sync op
+ */
+struct drm_v3d_bo_sync_op {
+	/** Handle of the buffer object to sync. */
+	__u32 handle;
+
+	/** Type of sync operation. */
+	__u32 type;
+
+	/**
+	 * Offset into the BO at which the sync range starts.
+	 *
+	 * This will be rounded down to the nearest cache line as needed.
+	 */
+	__u32 offset;
+
+	/**
+	 * Size of the range to sync
+	 *
+	 * size + offset will be rounded up to the nearest cache line as
+	 * needed.
+	 */
+	__u32 size;
+};
+
+/**
+ * struct drm_v3d_sync_bo - ioctl argument for syncing BO maps
+ */
+struct drm_v3d_sync_bo {
+	/** Array of struct drm_v3d_bo_sync_op */
+	__u64 ops;
+
+	/** Number of BO sync ops */
+	__u32 op_count;
+
+	__u32 pad;
+};
+
 enum drm_v3d_param {
 	DRM_V3D_PARAM_V3D_UIFCFG,
 	DRM_V3D_PARAM_V3D_HUB_IDENT1,
