Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794932445;
	b=K9bKcbjK0A8ahyri89TnWkIDQNPZlWzwTx4GNaR/fow850hK4KXFEayLUl0scWiNRlv4
	 guEh4mC1kPngTKohgLW/hOyCZn702cDnHD3DVP+HA57lKqfvxs5wzdBRUzTqSoOW7IWtv
	 DGL0gPSKpdwIN2rRiOY306eq/GgytKuZiuPnyT/0kr7u1y1QzgL3yBq8cjEDeYH2XHk72
	 EKxKD0ui/L6bQ6gvbxq/MhHBNyBXXoWUTbhZ/SFCh0knlSPH49BepxWl5p9lXpwocMBnx
	 UtRqNFAwHCbF3XxxaXSDJmhMGQK6pR4RGP4OMCtsgFXsoFy87/koNAe3QqNPRvR5pDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794932445;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Date:From:To:CC:Subject:In-Reply-To:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=e7yvOvrcKV6zsO6MVOOOAw2Kf7nioa9EAcHZEBlrXag=;
	b=zbdpQVh0h+XWpsT7QcvNU/2YpHHxXMJT99rIJa9FdTfP/D/VEg2xjkRi7Yu5bwHQMV+i
	 iimBeoay88K/oL9omfQyuu5DeaFvcc3jxo6AYFs2Fo6r2Vy7YyyzV2cBcPwV+6rvbyho+
	 IktTiCOO0kV2/p+2+Vg7RtHOvoi+ck3vc8yOSDjGfI1YpPQMLsTbsWN8ZbXvMFT6oxrCP
	 yePyDqhL6/3i6X8HRu4XODx5LtdXlnkm0eDJQPYbolSl3ju8c46tfdf7yXm87kRj1yC65
	 ICXK7M/IcMlh5nMLvorFXkIWc00BxxkTp1QE87Fyxfy1UlTnDvh6+oNzrHlpqUYNmjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D6AwrMZ2;
	arc=none smtp.remote-ip=95.215.58.64
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122A8606A330
	for <linux-api@vger.kernel.org>; Tue, 17 Nov 2026 16:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 122A8606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=D6AwrMZ2
X-Envelope-To: linux-api@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=j9Wfd2hCEYTWQjklDDg72pDAFBZcfpbYfUPC64t440Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794932443; v=1; x=1795537243;
 b=D6AwrMZ2073bS7jPnjnr66v/FmuhytbidjAlO0Ppn1HwyTNqqR4+ukVg84k3CtR2s8ioWX/D
 W3Q0a8Rc2v1BH9cxc06OHBjv6BftRLKA8JuTyDOgUPLHOL9phindh/+wkxtibzbmPkHnKbo60Vm
 rQ1TsyldbFKbLI07QQgpJ2iI=
X-Envelope-To: linux-api@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c7028649ea460a85;
	Tue, 17 Nov 2026 16:20:42 +0000
X-Mizu-Trace-ID: c7028649ea460a85
X-Migadu-Flow: FLOW_OUT
Date: Tue, 17 Nov 2026 16:20:39 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: arpe1618@gmail.com
CC: arnd@arndb.de, brauner@kernel.org, jannh@google.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, me@black-desk.cn, sargun@sargun.me
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_pidfd=3A_restrict_pidfd=5Fg?=
 =?US-ASCII?Q?etfd=28=29_to_the_caller=27s_pid_namespace?=
In-Reply-To: <20261117152332.1221-1-arpe1618@gmail.com>
Message-ID: <6F63BB54-2F8E-439E-AB7C-AA424842D89A@linux.dev>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 17 November 2026 15:23:32 GMT, Jiwoo Kim <arpe1618@gmail.com> wrote:
>pidfds can cross pid namespace boundaries: a task can obtain one for a
>process outside of its own pid namespace hierarchy through SO_PASSPIDFD
>or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor
>inheritance.
>
>Commit ee8323fdc827 ("pidfd: restrict task access ioctls to the caller's
>pid namespace") made the pidfs namespace ioctls fail with -EREMOTE
>unless the target is visible in the caller's active pid namespace, as
>PIDFD_GET_INFO already does, following the rule that operations which
>grant access to additional resources of the target require this [1].
>
>pidfd_getfd() grants access to the target's open files, but it only
>performs the ptrace access check, which does not take the pid namespace
>relationship between the caller and the target into account. With the
>caller in a child pid namespace and in the same user namespace as the
>target, PIDFD_GET_INFO and PIDFD_GET_UTS_NAMESPACE fail with -EREMOTE
>for such a pidfd, while pidfd_getfd() on the same pidfd returns a
>duplicate of the target's file descriptor.
>
>Apply the same rule to pidfd_getfd() and fail with -EREMOTE unless the
>target is visible in the caller's active pid namespace. Callers in
>ancestor pid namespaces are unaffected.
>
>This was found with an AI coding assistant, which also drafted this
>patch and its changelog. The problem was reproduced in a QEMU guest,
>and the fix was tested there.
>
>Link: https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner/ [1]
>Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
>Cc: stable@vger.kernel.org

Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>

>Signed-off-by: Jiwoo Kim <arpe1618@gmail.com>
>---
>-EREMOTE is a new error for pidfd_getfd(). The check is done before the
>task lookup, so, as with PIDFD_GET_INFO, a reaped target outside of the
>caller's pid namespace hierarchy gives -EREMOTE rather than -ESRCH, and
>the check comes before the ptrace access check.
>
>setns() also accepts such pidfds without this check, but it requires
>CAP_SYS_ADMIN over the namespaces being joined, so it is left alone
>here.
>
>A reproducer is available on request.
>
> kernel/pid.c | 14 +++++++++++---
> 1 file changed, 11 insertions(+), 3 deletions(-)
>
>diff --git a/kernel/pid.c b/kernel/pid.c
>index adf721606768..4f9a29eb29de 100644
>--- a/kernel/pid.c
>+++ b/kernel/pid.c
>@@ -893,6 +893,13 @@ static int pidfd_getfd(struct pid *pid, int fd)
> 	struct file *file;
> 	int ret;
> 
>+	/*
>+	 * Require the target to be visible in the caller's pid namespace,
>+	 * like the pidfs ioctls that grant access to its resources.
>+	 */
>+	if (!pid_vnr(pid))
>+		return -EREMOTE;
>+
> 	task = get_pid_task(pid, PIDTYPE_PID);
> 	if (!task)
> 		return -ESRCH;
>@@ -917,9 +924,10 @@ static int pidfd_getfd(struct pid *pid, int fd)
>  *
>  * This syscall gets a copy of a file descriptor from another process
>  * based on the pidfd, and file descriptor number. It requires that
>- * the calling process has the ability to ptrace the process represented
>- * by the pidfd. The process which is having its file descriptor copied
>- * is otherwise unaffected.
>+ * the process represented by the pidfd is visible in the caller's pid
>+ * namespace and that the calling process has the ability to ptrace it.
>+ * The process which is having its file descriptor copied is otherwise
>+ * unaffected.
>  *
>  * Return: On success, a cloexec file descriptor is returned.
>  *         On error, a negative errno number will be returned.
>
>base-commit: 44cc27050381e92de64cc3d7836376eda4d92a5f
>


--- Thanks!
