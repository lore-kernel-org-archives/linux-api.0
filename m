Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793396335;
	b=do55NwINjiQdax93+wFwPfjEgnoJiuk8KfF9+ztbyLkyCsZgaO46ySsEzVPj4FGPc+/m
	 VzIy7GtTs0rcmpVpMjsq5uj57SzcTq1qF9Y7g3HD89b98z9wQKU6yrQee2ocUco9TonV/
	 rZomSQJ0bKCROlN+d8tcIsPWe1EZhDfTauamyEiSSybRcb/5uyeUB58B1UQqHUcFyGgiw
	 a1FvZphOuSb4GytY7tppm5lql+3BQYmk2cGir3BKPGcD6za0oXWYbOb927wVkLE/8r6Bo
	 AX/161v+NgwsNRN8pBXzIAs9su+aOVHo7pWH4Z0VsGh0GvXd4TiWkr9QrsS+hP0vUZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793396335;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=spinRV1ytdEm3zTInDOPw5U8SMhCOKVdFz2ROyH2B1M=;
	b=PrFs5vIS9P/gT3GKAH6eEnzq6ZYwneVLJLX7h+Th8pZGWobVEy3/gQ/HQbzcdo3P4ZUb
	 K2fqcGueFoM51+FBhbHAWhNUHTDSFR/w+WoQO4ZOq2LOzK1QjdqCLK9u8qsdDwDt2hU1E
	 OcsN7pjLx98DaEptveJu357RPqBQ2CIFkp8ej84mXX3IlSdHGkYmxryyDJ8Aj3hJuxmcZ
	 DLPRPLcT22JisZggd1D4s78sDFWN0Tk1RfyFpaKPTbrN3vornyIVMR8jizGkF0lpx2HBT
	 KddfbLPh6I/+mZ1iTleM8pocEEtlGW1ZAgdGMdzsPM0dX4DbOcdpE3HrdhuDed47SEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=Bc+BaGit;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFEE606A31A;
	Fri, 30 Oct 2026 21:38:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BFEE606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=Bc+BaGit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:From:Reply-To;
	bh=spinRV1ytdEm3zTInDOPw5U8SMhCOKVdFz2ROyH2B1M=; b=Bc+BaGitZmeelyf+NbZNsPzJ49
	VBYsI17TYPApjQqD5cK8FbVmrmItXa0E6qj3PK9xujLl5uBQ4AN0k4UibvICYmj/Kf6T/1ZBxa2Gw
	HCZ5ovt0zEHQH7mYfWxBSaJwBN5t18xOttjUe7nXdvBDNtMKbrBIcUhVVzbUIN3vR6Jrv6btQSIRT
	Yyd8dp3MM2bGO0F6R45Vu7pei2C6pSaWk9k/FVUg0tqvjPMf/SVIM9ikjRPBqFBm3MSIWoLAhHIwI
	TGxje9h+SwJcPL8s7cU9uWVlS7KcJsR4thQrID7YCjb3GadalQ0UhTjYmd7mWIhHPGq2Q4bJ37qRN
	kUzXtr2g==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1xMuJE-00FNmU-7s; Fri, 30 Oct 2026 22:38:48 +0100
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Fri, 30 Oct 2026 18:38:32 -0300
Subject: [PATCH v8 1/6] treewide: Get rid of get_task_comm()
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-tonyk-long_name-v8-1-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
In-Reply-To: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2

Since commit 4cc0473d7754 ("get rid of __get_task_comm()"),
get_task_comm() does just a redundant check for the buffer size and call
strscpy_pad(). Replace get_task_comm() calls with strscpy_pad(), that will
do the right thing if the buffers sizes doesn't match: zero-pad if it's
bigger, and truncate if it's smaller.

Link: https://lore.kernel.org/lkml/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/
Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
Changes from v1:
 - Fix for security/ipe/audit.c and net/netfilter/nf_tables_api.c
---
 drivers/connector/cn_proc.c                        |  2 +-
 drivers/dma-buf/sw_sync.c                          |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c    |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |  2 +-
 drivers/gpu/drm/lima/lima_ctx.c                    |  2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  2 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |  2 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |  2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  2 +-
 drivers/hwtracing/stm/core.c                       |  2 +-
 drivers/tty/tty_audit.c                            |  2 +-
 fs/binfmt_elf.c                                    |  2 +-
 fs/binfmt_elf_fdpic.c                              |  2 +-
 fs/proc/array.c                                    |  2 +-
 include/linux/sched.h                              | 19 -------------------
 kernel/audit.c                                     |  6 ++++--
 kernel/auditsc.c                                   |  6 ++++--
 kernel/printk/printk.c                             |  2 +-
 kernel/sys.c                                       |  2 +-
 net/bluetooth/hci_sock.c                           |  2 +-
 net/netfilter/nf_tables_api.c                      |  4 +++-
 security/integrity/integrity_audit.c               |  3 ++-
 security/ipe/audit.c                               |  3 ++-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 ++++---
 security/smack/smack_access.c                      |  4 ++--
 security/smack/smack_lsm.c                         |  4 +++-
 31 files changed, 47 insertions(+), 55 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 0056ab81fbc3..c78243ed3c2a 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -278,7 +278,7 @@ void proc_comm_connector(struct task_struct *task)
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
-	get_task_comm(ev->event_data.comm.comm, task);
+	strscpy_pad(ev->event_data.comm.comm, task->comm);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 8df20b0218a9..d501657ad801 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -312,7 +312,7 @@ static int sw_sync_debugfs_open(struct inode *inode, struct file *file)
 	struct sync_timeline *obj;
 	char task_comm[TASK_COMM_LEN];
 
-	get_task_comm(task_comm, current);
+	strscpy_pad(task_comm, current->comm);
 
 	obj = sync_timeline_create(task_comm);
 	if (!obj)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
index 9b10d015671c..2c92bb12c269 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
@@ -73,7 +73,7 @@ struct amdgpu_amdkfd_fence *amdgpu_amdkfd_fence_create(u64 context,
 	/* This reference gets released in amdkfd_fence_release */
 	mmgrab(mm);
 	fence->mm = mm;
-	get_task_comm(fence->timeline_name, current);
+	strscpy_pad(fence->timeline_name, current->comm);
 	spin_lock_init(&fence->lock);
 	fence->context_id = context_id;
 	dma_fence_init(&fence->base, &amdkfd_fence_ops, &fence->lock,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
index f8652fd0525d..1700898add72 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
@@ -131,7 +131,7 @@ int amdgpu_evf_mgr_rearm(struct amdgpu_eviction_fence_mgr *evf_mgr,
 		return -ENOMEM;
 
 	ev_fence->evf_mgr = evf_mgr;
-	get_task_comm(ev_fence->timeline_name, current);
+	strscpy_pad(ev_fence->timeline_name, current->comm);
 	spin_lock_init(&ev_fence->lock);
 	dma_fence_init64(&ev_fence->base, &amdgpu_eviction_fence_ops,
 			 &ev_fence->lock, evf_mgr->ev_fence_ctx,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 47e852c15c36..3f5a0fa2dba2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -3721,7 +3721,7 @@ int amdgpu_ras_init(struct amdgpu_device *adev)
 	}
 
 	con->init_task_pid = task_pid_nr(current);
-	get_task_comm(con->init_task_comm, current);
+	strscpy_pad(con->init_task_comm, current->comm);
 
 	mutex_init(&con->critical_region_lock);
 	INIT_LIST_HEAD(&con->critical_region_head);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index c1257f530e9a..58086a7c06ef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -85,7 +85,7 @@ int amdgpu_userq_fence_driver_alloc(struct amdgpu_device *adev,
 
 	fence_drv->adev = adev;
 	fence_drv->context = dma_fence_context_alloc(1);
-	get_task_comm(fence_drv->timeline_name, current);
+	strscpy_pad(fence_drv->timeline_name, current->comm);
 
 	*fence_drv_req = fence_drv;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 2bd07007def4..825b6c721fa0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2585,10 +2585,10 @@ void amdgpu_vm_set_task_info(struct amdgpu_vm *vm)
 	}
 
 	vm->task_info->task.pid = current->pid;
-	get_task_comm(vm->task_info->task.comm, current);
+	strscpy_pad(vm->task_info->task.comm, current->comm);
 
 	vm->task_info->tgid = current->tgid;
-	get_task_comm(vm->task_info->process_name, current->group_leader);
+	strscpy_pad(vm->task_info->process_name, current->group_leader->comm);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 249f07f30951..d6f32bc44aef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -565,7 +565,7 @@ static int amdgpu_vram_mgr_new(struct ttm_resource_manager *man,
 	}
 
 	vres->task.pid = task_pid_nr(current);
-	get_task_comm(vres->task.comm, current);
+	strscpy_pad(vres->task.comm, current->comm);
 	list_add_tail(&vres->vres_node, &mgr->allocated_vres_list);
 
 	if (bo->flags & AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS && adjust_dcc_size) {
diff --git a/drivers/gpu/drm/lima/lima_ctx.c b/drivers/gpu/drm/lima/lima_ctx.c
index 68ede7a725e2..e8c5c3601bf1 100644
--- a/drivers/gpu/drm/lima/lima_ctx.c
+++ b/drivers/gpu/drm/lima/lima_ctx.c
@@ -29,7 +29,7 @@ int lima_ctx_create(struct lima_device *dev, struct lima_ctx_mgr *mgr, u32 *id)
 		goto err_out0;
 
 	ctx->pid = task_pid_nr(current);
-	get_task_comm(ctx->pname, current);
+	strscpy_pad(ctx->pname, current->comm);
 
 	return 0;
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 518f24549b9d..4ddf95407aed 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -48,7 +48,7 @@ static void panfrost_gem_debugfs_bo_add(struct panfrost_device *pfdev,
 					struct panfrost_gem_object *bo)
 {
 	bo->debugfs.creator.tgid = current->tgid;
-	get_task_comm(bo->debugfs.creator.process_name, current->group_leader);
+	strscpy_pad(bo->debugfs.creator.process_name, current->group_leader->comm);
 
 	mutex_lock(&pfdev->debugfs.gems_lock);
 	list_add_tail(&bo->debugfs.node, &pfdev->debugfs.gems_list);
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 22b57ab6f929..a598e077f76a 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -54,7 +54,7 @@ static void panthor_gem_debugfs_bo_add(struct panthor_gem_object *bo)
 						    struct panthor_device, base);
 
 	bo->debugfs.creator.tgid = current->tgid;
-	get_task_comm(bo->debugfs.creator.process_name, current->group_leader);
+	strscpy_pad(bo->debugfs.creator.process_name, current->group_leader->comm);
 
 	mutex_lock(&ptdev->gems.lock);
 	list_add_tail(&bo->debugfs.node, &ptdev->gems.node);
diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index a343c5180e01..4954044decd4 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3595,7 +3595,7 @@ static void group_init_task_info(struct panthor_group *group)
 	struct task_struct *task = current->group_leader;
 
 	group->task_info.pid = task->pid;
-	get_task_comm(group->task_info.comm, task);
+	strscpy_pad(group->task_info.comm, task->comm);
 }
 
 static void add_group_kbo_sizes(struct panthor_device *ptdev,
diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 81e70a12b356..eb486b147461 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -50,7 +50,7 @@ static void virtio_gpu_create_context_locked(struct virtio_gpu_device *vgdev,
 	} else {
 		char dbgname[TASK_COMM_LEN];
 
-		get_task_comm(dbgname, current);
+		strscpy_pad(dbgname, current->comm);
 		virtio_gpu_cmd_context_create(vgdev, vfpriv->ctx_id,
 					      vfpriv->context_init, strlen(dbgname),
 					      dbgname);
diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index f48c6a8a0654..c7715439964e 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -634,7 +634,7 @@ static ssize_t stm_char_write(struct file *file, const char __user *buf,
 		char comm[sizeof(current->comm)];
 		char *ids[] = { comm, "default", NULL };
 
-		get_task_comm(comm, current);
+		strscpy_pad(comm, current->comm);
 
 		err = stm_assign_first_policy(stmf->stm, &stmf->output, ids, 1);
 		/*
diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index d014af6ab060..d514a81d0a5c 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -77,7 +77,7 @@ static void tty_audit_log(const char *description, dev_t dev,
 	audit_log_format(ab, "%s pid=%u uid=%u auid=%u ses=%u major=%d minor=%d comm=",
 			 description, pid, uid, loginuid, sessionid,
 			 MAJOR(dev), MINOR(dev));
-	get_task_comm(name, current);
+	strscpy_pad(name, current->comm);
 	audit_log_untrustedstring(ab, name);
 	audit_log_format(ab, " data=");
 	audit_log_n_hex(ab, data, size);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index bf7f8f47548d..cd59409a7975 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1554,7 +1554,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	get_task_comm(psinfo->pr_fname, p);
+	strscpy_pad(psinfo->pr_fname, p->comm);
 
 	return 0;
 }
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index d3872169f55e..9e3ba25e4c8f 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1376,7 +1376,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	get_task_comm(psinfo->pr_fname, p);
+	strscpy_pad(psinfo->pr_fname, p->comm);
 
 	return 0;
 }
diff --git a/fs/proc/array.c b/fs/proc/array.c
index f6f75d206762..8ebb7cf1a7b0 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		get_task_comm(tcomm, p);
+		strscpy_pad(tcomm, p->comm);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c93da75226e..0564aabb1393 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2042,25 +2042,6 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 	__set_task_comm(tsk, from, false);		\
 })
 
-/*
- * - Why not use task_lock()?
- *   User space can randomly change their names anyway, so locking for readers
- *   doesn't make sense. For writers, locking is probably necessary, as a race
- *   condition could lead to long-term mixed results.
- *   The strscpy_pad() in __set_task_comm() can ensure that the task comm is
- *   always NUL-terminated and zero-padded. Therefore the race condition between
- *   reader and writer is not an issue.
- *
- * - BUILD_BUG_ON() can help prevent the buf from being truncated.
- *   Since the callers don't perform any return value checks, this safeguard is
- *   necessary.
- */
-#define get_task_comm(buf, tsk) ({			\
-	BUILD_BUG_ON(sizeof(buf) < TASK_COMM_LEN);	\
-	strscpy_pad(buf, (tsk)->comm);			\
-	buf;						\
-})
-
 static __always_inline void scheduler_ipi(void)
 {
 	/*
diff --git a/kernel/audit.c b/kernel/audit.c
index 631d6d4a23cf..08e9d97f2a82 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1667,7 +1667,8 @@ static void audit_log_multicast(int group, const char *op, int err)
 	audit_put_tty(tty);
 	audit_log_task_context(ab); /* subj= */
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_d_path_exe(ab, current->mm); /* exe= */
 	audit_log_format(ab, " nl-mcgrp=%d op=%s res=%d", group, op, !err);
 	audit_log_end(ab);
@@ -2483,7 +2484,8 @@ void audit_log_task_info(struct audit_buffer *ab)
 			 audit_get_sessionid(current));
 	audit_put_tty(tty);
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_d_path_exe(ab, current->mm);
 	audit_log_task_context(ab);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 552ba9f4fb0a..545388e5ac29 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2881,7 +2881,8 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 	audit_log_format(ab, " pid=%u", task_tgid_nr(current));
 	audit_log_task_context(ab); /* subj= */
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
@@ -2917,7 +2918,8 @@ static void audit_log_task(struct audit_buffer *ab)
 			 sessionid);
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", task_tgid_nr(current));
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_d_path_exe(ab, current->mm);
 }
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 9a205f94bfac..6d9cd4d96003 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2247,7 +2247,7 @@ static u16 printk_sprint(char *text, u16 size, int facility,
 static void printk_store_execution_ctx(struct printk_info *info)
 {
 	info->caller_id2 = printk_caller_id2();
-	get_task_comm(info->comm, current);
+	strscpy_pad(info->comm, current->comm);
 }
 
 static void pmsg_load_execution_ctx(struct printk_message *pmsg,
diff --git a/kernel/sys.c b/kernel/sys.c
index 755bfa5ccd92..31eef656dbd6 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2612,7 +2612,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
-		get_task_comm(comm, me);
+		strscpy_pad(comm, me->comm);
 		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
 			return -EFAULT;
 		break;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 3da994d1fe65..82b6511c7d01 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -104,7 +104,7 @@ static bool hci_sock_gen_cookie(struct sock *sk)
 			id = 0xffffffff;
 
 		hci_pi(sk)->cookie = id;
-		get_task_comm(hci_pi(sk)->comm, current);
+		strscpy_pad(hci_pi(sk)->comm, current->comm);
 		return true;
 	}
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59ac623e6805..6881d20616eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9779,9 +9779,11 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	if (!nlh)
 		goto nla_put_failure;
 
+	strscpy_pad(buf, current->comm);
+
 	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_base_seq(net))) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
-	    nla_put_string(skb, NFTA_GEN_PROC_NAME, get_task_comm(buf, current)))
+	    nla_put_string(skb, NFTA_GEN_PROC_NAME, buf))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 22106aaeb0df..27b125e09974 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -46,7 +46,8 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 			 audit_get_sessionid(current));
 	audit_log_task_context(ab);
 	audit_log_format(ab, " op=%s cause=%s comm=", op, cause);
-	audit_log_untrustedstring(ab, get_task_comm(name, current));
+	strscpy_pad(name, current->comm);
+	audit_log_untrustedstring(ab, name);
 	if (fname) {
 		audit_log_format(ab, " name=");
 		audit_log_untrustedstring(ab, fname);
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index b6f8fb54085a..0d5c683b3d61 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -145,7 +145,8 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 	audit_log_format(ab, "ipe_op=%s ipe_hook=%s enforcing=%d pid=%d comm=",
 			 op, audit_hook_names[ctx->hook], READ_ONCE(enforce),
 			 task_tgid_nr(current));
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 
 	if (ctx->file) {
 		audit_log_d_path(ab, " path=", &ctx->file->f_path);
diff --git a/security/landlock/domain.c b/security/landlock/domain.c
index 4c0b1f0e1db5..902cf41a3048 100644
--- a/security/landlock/domain.c
+++ b/security/landlock/domain.c
@@ -564,7 +564,7 @@ static struct landlock_details *get_current_details(void)
 	memcpy(details->exe_path, path_str, path_size);
 	details->pid = get_pid(task_tgid(current));
 	details->uid = from_kuid(&init_user_ns, current_uid());
-	get_task_comm(details->comm, current);
+	strscpy_pad(details->comm, current->comm);
 	return details;
 }
 
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 955b2e7b2c8e..8f8c29e8c03d 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -276,8 +276,8 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 			if (pid) {
 				char tskcomm[sizeof(tsk->comm)];
 				audit_log_format(ab, " opid=%d ocomm=", pid);
-				audit_log_untrustedstring(ab,
-				    get_task_comm(tskcomm, tsk));
+				strscpy_pad(tskcomm, tsk->comm);
+				audit_log_untrustedstring(ab, tskcomm);
 			}
 		}
 		break;
@@ -421,7 +421,8 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	char comm[sizeof(current->comm)];
 
 	audit_log_format(ab, " pid=%d comm=", task_tgid_nr(current));
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_lsm_data(ab, a);
 }
 
diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
index fb85356266e5..0e7b2edcc3d6 100644
--- a/security/smack/smack_access.c
+++ b/security/smack/smack_access.c
@@ -335,10 +335,10 @@ static void smack_log_callback(struct audit_buffer *ab, void *a)
 	if (sad->subj_tsk) {
 		char comm[TASK_COMM_LEN];
 
+		strscpy_pad(comm, sad->subj_tsk->comm);
 		audit_log_format(ab, " subj_pid=%d subj_comm=",
 			task_tgid_nr(sad->subj_tsk));
-		audit_log_untrustedstring(ab,
-			get_task_comm(comm, sad->subj_tsk));
+		audit_log_untrustedstring(ab, comm);
 	}
 }
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 28a8e12603ce..e8c678a36c15 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -138,6 +138,8 @@ smk_bu_tsk_to_obj(struct task_struct *tsk, const struct task_smack *tsp,
 	char acc[SMK_NUM_ACCESS_TYPE + 1];
 	char comm[TASK_COMM_LEN];
 
+	strscpy_pad(comm, tsk->comm);
+
 	if (rc <= 0)
 		return rc;
 	if (rc > SMACK_UNCONFINED_OBJECT)
@@ -147,7 +149,7 @@ smk_bu_tsk_to_obj(struct task_struct *tsk, const struct task_smack *tsp,
 
 	pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
 		smk_of_task(tsp)->smk_known, oskp->smk_known,
-		acc, get_task_comm(comm, tsk), note);
+		acc, comm, note);
 	return 0;
 #else
 	return rc;

-- 
2.56.0

