Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219777;
	b=QBYcITE9IBHcudI5FTnTlA8lTTC3qvu0ApFDdeuK0c379zZAxb7Zt65Iieayw8oy9p2N
	 BLT6/h0lnDgX3k1+7zoVoMll3uFvqY9sCBFkCSa+i35v8mIzTN0P2cNy9JxUNivU1OX7m
	 /6vfUnFTGwKeITjCNSh3Hz6PKNIFTYEXcyOn1Y3rFKL+1SfjRAsRWOBs/Q7gO7+mE/Cbl
	 mMFPIXxtDKL2OCYSAfSArMPG00a6kvyROZlC+UgmaCwjGpJ2cXXyRRPGBIWlSVQFCceGg
	 egPILjvrCY8hnuZVBIKpzcf3AJgfpwoIGKnK4N+yW2EOfSe9Rytq1R0MPGNsU6b4voA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	b=GbdJ5rLBHV1p6B4c+ZezNDMAjofGFxV+tBzzwoIQ9TTj5DQKj0h0GFEbOY/v1Rrx2eFI
	 U1QPRtewcpjig4oJ/Yw8Y95h18xWIQ2xf4pl8LtgCOVhEJ5ooG2fIYXb42PYX4+4VbpSK
	 D//NPpaVdKR88+C5W4OnPkzG0IM5vm4VImiaymhAtbXJBZg8jhzUzpHYyXbw0+GZzZe+m
	 Z6UJliXbvsQ4ilm/Z+Me8ngVkgQkQ1TidvaHCrV+aJRQI0FHsfDwYTEyQIJeCjT6Hwfax
	 kr+Yv6Qx1ltNTsXGeuWKpE1n5IqcHOLpwifpsivExAZu6BZsDzsCm/u+EQVEoSuooCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H81SHs/v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B16C1606A6A0;
	Sat, 21 Nov 2026 00:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H81SHs/v
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0B7C31F00A3D;
	Sat, 21 Nov 2026 00:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219777;
	bh=glmqSz2x+APivEM/vonQfanbbokAEU7WMuncz0VaekQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H81SHs/v2K4tqTjGPNdvUf7ZEVvolz24sWuu6uNJWRpVWkSyA5wpH0a7n8m7+1D/k
	 KH/xkMWc4Szns+4CwHQF2zWABJ3KLgjOC59geDEUJFlWf0A+mmqgHUf2MjHdrOh35u
	 6VfGz02YXrt38UmcZqgL9DMsj1MsA4nN9+R8aaT10dyh5v01zkDu98GW+nDJUl/5HN
	 GxYkxxwkymmPLp/v2AIlQTGj69xAHxA0KcsKa5v1DIMTHdXMBWZHE9+PEXiQBAvnHl
	 5TZpRlRYXFMOIiIpD/Bm1ptOcfu2af1j4uIy9BejYAPGkbpnvmL6DlYjkeIomU+N1j
	 xMtI96rJBKeQQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 10/25] nsproxy: Pass nsproxy to create_new_namespaces()
Date: Sat, 21 Nov 2026 02:08:29 +0200
Message-ID: <20261121000844.1863324-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

create_new_namespaces() takes a struct task_struct pointer even though
it only reads tsk->nsproxy, preventing callers outside kernel/nsproxy.c
from constructing a child nsproxy without mutating a task.

Expose create_new_namespaces() and pass the source struct nsproxy
pointer directly so root namespace creation can allocate a detached
namespace set from current->nsproxy.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/nsproxy.h |  5 +++++
 kernel/nsproxy.c        | 32 ++++++++++++++++----------------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index dc2447f5f092..cacbbbe3f1ce 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -12,6 +12,7 @@ struct ipc_namespace;
 struct pid_namespace;
 struct cgroup_namespace;
 struct fs_struct;
+struct user_namespace;
 
 /*
  * A structure to contain pointers to all per-process
@@ -92,6 +93,10 @@ static inline struct cred *nsset_cred(struct nsset *set)
  *
  */
 
+struct nsproxy *create_new_namespaces(u64 flags,
+				      struct nsproxy *ns,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs);
 int copy_namespaces(u64 flags, struct task_struct *tsk);
 void switch_cred_namespaces(const struct cred *old, const struct cred *new);
 void exit_nsproxy_namespaces(struct task_struct *tsk);
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 2dcf105e8ee2..8a3c6d4e94e2 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -85,9 +85,10 @@ void deactivate_nsproxy(struct nsproxy *ns)
  * Return the newly created nsproxy.  Do not attach this to the task,
  * leave it to the caller to do proper locking and attach it to task.
  */
-static struct nsproxy *create_new_namespaces(u64 flags,
-	struct task_struct *tsk, struct user_namespace *user_ns,
-	struct fs_struct *new_fs)
+struct nsproxy *create_new_namespaces(u64 flags,
+				      struct nsproxy *ns,
+				      struct user_namespace *user_ns,
+				      struct fs_struct *new_fs)
 {
 	struct nsproxy *new_nsp;
 	int err;
@@ -96,52 +97,51 @@ static struct nsproxy *create_new_namespaces(u64 flags,
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
-	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns,
-				      user_ns, new_fs);
+	new_nsp->mnt_ns = copy_mnt_ns(flags, ns->mnt_ns, user_ns, new_fs);
 	if (IS_ERR(new_nsp->mnt_ns)) {
 		err = PTR_ERR(new_nsp->mnt_ns);
 		goto out_ns;
 	}
 
-	new_nsp->uts_ns = copy_utsname(flags, user_ns, tsk->nsproxy->uts_ns);
+	new_nsp->uts_ns = copy_utsname(flags, user_ns, ns->uts_ns);
 	if (IS_ERR(new_nsp->uts_ns)) {
 		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
 	}
 
-	new_nsp->ipc_ns = copy_ipcs(flags, user_ns, tsk->nsproxy->ipc_ns);
+	new_nsp->ipc_ns = copy_ipcs(flags, user_ns, ns->ipc_ns);
 	if (IS_ERR(new_nsp->ipc_ns)) {
 		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
 	}
 
 	new_nsp->pid_ns_for_children =
-		copy_pid_ns(flags, user_ns, tsk->nsproxy->pid_ns_for_children);
+		copy_pid_ns(flags, user_ns, ns->pid_ns_for_children);
 	if (IS_ERR(new_nsp->pid_ns_for_children)) {
 		err = PTR_ERR(new_nsp->pid_ns_for_children);
 		goto out_pid;
 	}
 
 	new_nsp->cgroup_ns = copy_cgroup_ns(flags, user_ns,
-					    tsk->nsproxy->cgroup_ns);
+					    ns->cgroup_ns);
 	if (IS_ERR(new_nsp->cgroup_ns)) {
 		err = PTR_ERR(new_nsp->cgroup_ns);
 		goto out_cgroup;
 	}
 
-	new_nsp->net_ns = copy_net_ns(flags, user_ns, tsk->nsproxy->net_ns);
+	new_nsp->net_ns = copy_net_ns(flags, user_ns, ns->net_ns);
 	if (IS_ERR(new_nsp->net_ns)) {
 		err = PTR_ERR(new_nsp->net_ns);
 		goto out_net;
 	}
 
 	new_nsp->time_ns_for_children = copy_time_ns(flags, user_ns,
-					tsk->nsproxy->time_ns_for_children);
+					ns->time_ns_for_children);
 	if (IS_ERR(new_nsp->time_ns_for_children)) {
 		err = PTR_ERR(new_nsp->time_ns_for_children);
 		goto out_time;
 	}
-	new_nsp->time_ns = get_time_ns(tsk->nsproxy->time_ns);
+	new_nsp->time_ns = get_time_ns(ns->time_ns);
 
 	return new_nsp;
 
@@ -192,7 +192,7 @@ int copy_namespaces(u64 flags, struct task_struct *tsk)
 		(CLONE_NEWIPC | CLONE_SYSVSEM))
 		return -EINVAL;
 
-	new_ns = create_new_namespaces(flags, tsk, user_ns, tsk->fs);
+	new_ns = create_new_namespaces(flags, tsk->nsproxy, user_ns, tsk->fs);
 	if (IS_ERR(new_ns))
 		return  PTR_ERR(new_ns);
 
@@ -231,7 +231,7 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 		flags |= CLONE_EMPTY_MNTNS;
 	}
 
-	*new_nsp = create_new_namespaces(flags, current, user_ns,
+	*new_nsp = create_new_namespaces(flags, current->nsproxy, user_ns,
 					 new_fs ? new_fs : current->fs);
 	if (IS_ERR(*new_nsp)) {
 		err = PTR_ERR(*new_nsp);
@@ -289,7 +289,7 @@ int exec_task_namespaces(void)
 	if (tsk->nsproxy->time_ns_for_children == tsk->nsproxy->time_ns)
 		return 0;
 
-	new = create_new_namespaces(0, tsk, current_user_ns(), tsk->fs);
+	new = create_new_namespaces(0, tsk->nsproxy, current_user_ns(), tsk->fs);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
@@ -356,7 +356,7 @@ static int prepare_nsset(unsigned flags, struct nsset *nsset)
 	struct task_struct *me = current;
 
 	nsset->flags = flags;
-	nsset->nsproxy = create_new_namespaces(0, me, current_user_ns(), me->fs);
+	nsset->nsproxy = create_new_namespaces(0, me->nsproxy, current_user_ns(), me->fs);
 	if (IS_ERR(nsset->nsproxy))
 		return PTR_ERR(nsset->nsproxy);
 
-- 
2.47.3

