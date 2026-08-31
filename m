Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206FC35C696;
	Mon, 31 Aug 2026 02:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788145152; cv=none; b=B2ArJmQxY4hoEWVTuc0oalGxCLDgiXy5o+wrFv/hdvgs1cvqsEzA9WO9iicCfPQOyALVcspngMiXHIvh25Wr3tkH5ZJK//iKDvoC6tE7clT9IoSiMkQw+PzPOzfSTsFNzmuQkIAFpASvYNK4RBQi3WNVgEQ5QO8SD6obaiSBJxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788145152; c=relaxed/simple;
	bh=Smhz1v0S65AWaypnb/b+QGQdSN9Z/8SuckCUr7LAkas=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RZE7w/dDdF2xNcEYyIEHj9Zde1Qd8b+OFhLliqXadjZJSuQyHjDD5uCkGcVhsYb4Lr1dUBySww3rHg3cZFHPEgEehkVJv2l69lGMi+sf2ltOPivWqoWo1SL+bj3T3j5VtKgEs4EAzpIjkCES9cCEiBhAsivG2al2Tq2R9OCZUG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsQ4E4Yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsQ4E4Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C7A88C4AF0B;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788145151;
	bh=Smhz1v0S65AWaypnb/b+QGQdSN9Z/8SuckCUr7LAkas=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NsQ4E4Ythu3E/qH7sO7wDJZIsChxiYTG8DLM7xrEAVG8XSHdq/c6aBwDILQKj8LUP
	 +M/Poc5USsXWrH7uvMsVy2+OngtVnG8qD42NcH5k5KrQdTToRUHe1WaODy9GT25v+U
	 AVlE9OhIZalJ5ncJFAwK0kyYoDga1cZ9zuEgmYnAV1huDBG8KZmmZW2SQ7GtSOC1mO
	 rH8xQS6UHxmqqRplTxONoUJJ41oaXPH5kLsbT1x6i6BjGPV2zx3O70JeHsxovYBB/a
	 h85e5kh5/W5fcYg8hSA1sBpZlGffZ6m7jNC8Em977qs3N/14ytEVNLq/pgnsP5opqU
	 vKymxepX01UFQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF62FC624A5;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Date: Mon, 31 Aug 2026 10:59:08 +0800
Subject: [PATCH v2 3/3] pidfd: Add task path ioctls
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260831-pidfd-get-paths-v2-3-c59ea6a21b72@black-desk.cn>
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
In-Reply-To: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
 Chen Linxuan <me@black-desk.cn>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3678; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=ZADtZNdlB7oE/hBsTTGGqoCz5/1kKnW1D9F4WuU2Sco=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqlO39Ayt8SEEcYynePriQkVXfWPjAUsBYWbqbX
 dslGZuXhKOJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCapTt/QAKCRB2HuYUOZmu
 iyLMD/42sfTAfcQHAYOWOJ+1xkyRw56ENUpVgpNhdtd3yFPnmHrvcsrRE+b8eeBW8lTK1jTZmwh
 m/b/X7YW+O3DWxXjKeBMihhsiieg2Qjxnuva26Dx82wX5SZBv98ehkyw8pJSdi6Xigi1ChJcTZk
 wLzpDF0H0qF0bIkVdvgbTgdFyq4GEAksg8fdpq/tzbWs+wM9KDAZ06SgoUsrJULms0Ck61Owig/
 ta6YSZh9VJSeqbbSe2efkkQ9lZXouB0uRpUgdfY2iYrb/Orprb/V3WpzlU0l1n8eI5sSRC2I4p4
 qxB1Gga1IWS2P5+r3xvZYQo/5LJV//6ca18irPp9HX9lL+trhCEfNLyIrFxmnkODZqFn7mrXm0V
 u++2ACXeLlIjQ/Bu3dEma/WRfcYF3cUmNCMv8cbKQnZdJS0MtW9XBnLy5mOT8U3UzFZtSfVzsVe
 yQUopFXBBAUEWdWGLfZuTAbd6RLLbBYOFSsPHlOPsQtUwRGEy2Osh1/BMpL6oszntsPrL8dH4rp
 KnftSmefkfh0pWnt17qzNceLjHOlTbMLX0SiU2kzTs1w56pW93DWGqfS50H0fmf9+QCGMeqIEzj
 7C9QTjehkhz9odNBtcBgvfXk+28gp8cDxlj7ZOJURuE5ZEALFjSQRRPvLcHmj9h9WyWaR5kuObN
 BcBuQvS2RLXfJpA==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn

From: Chen Linxuan <me@black-desk.cn>

Add PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT to return
close-on-exec O_PATH file descriptors referencing the target task's
executable, working directory, and root directory.

The new ioctls use the same PTRACE_MODE_READ_FSCREDS permission check
and nonzero-argument rejection as the existing namespace ioctls.  The
target is sampled while holding exec_update_lock so that the access
check and path read cannot race with execve().

This allows userspace to obtain stable path references from a pidfd
without requiring procfs.

Assisted-by: LLM
Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
 fs/pidfs.c                 | 38 ++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/pidfd.h |  7 +++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 49a1ab0c42f9..b21374f00002 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -4,6 +4,7 @@
 #include <linux/exportfs.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 #include <linux/cgroup.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -510,6 +511,9 @@ static bool pidfs_ioctl_valid(unsigned int cmd)
 	case PIDFD_GET_UTS_NAMESPACE:
 	case PIDFD_GET_USER_NAMESPACE:
 	case PIDFD_GET_PID_NAMESPACE:
+	case PIDFD_GET_EXE:
+	case PIDFD_GET_CWD:
+	case PIDFD_GET_ROOT:
 		return true;
 	}
 
@@ -678,9 +682,31 @@ static struct ns_common *pidfd_get_namespace(struct pid *pid,
 	return ns_common;
 }
 
+static int pidfd_get_task_path(struct pid *pid, unsigned int cmd,
+			       unsigned long arg, struct path *path)
+{
+	CLASS(pidfd_task_locked, task)(pid, arg);
+
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
+	switch (cmd) {
+	case PIDFD_GET_EXE:
+		return get_task_exe_path(task, path);
+	case PIDFD_GET_CWD:
+		return get_task_pwd(task, path);
+	case PIDFD_GET_ROOT:
+		return get_task_root(task, path);
+	}
+
+	return -EINVAL;
+}
+
 static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct ns_common *ns_common = NULL;
+	struct path path __free(path_put) = {};
+	int error;
 
 	if (!pidfs_ioctl_valid(cmd))
 		return -ENOIOCTLCMD;
@@ -698,6 +724,18 @@ static long pidfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (_IOC_NR(cmd) == _IOC_NR(PIDFD_GET_INFO))
 		return pidfd_info(file, cmd, arg);
 
+	switch (cmd) {
+	case PIDFD_GET_EXE:
+	case PIDFD_GET_CWD:
+	case PIDFD_GET_ROOT:
+		error = pidfd_get_task_path(pidfd_pid(file), cmd, arg, &path);
+		if (error)
+			return error;
+
+		return FD_ADD(O_CLOEXEC,
+			      dentry_open(&path, O_PATH, current_cred()));
+	}
+
 	ns_common = pidfd_get_namespace(pidfd_pid(file), cmd, arg);
 	if (IS_ERR(ns_common))
 		return PTR_ERR(ns_common);
diff --git a/include/uapi/linux/pidfd.h b/include/uapi/linux/pidfd.h
index 0919246a1611..95ce1819f423 100644
--- a/include/uapi/linux/pidfd.h
+++ b/include/uapi/linux/pidfd.h
@@ -121,4 +121,11 @@ struct pidfd_info {
 #define PIDFD_GET_UTS_NAMESPACE               _IO(PIDFS_IOCTL_MAGIC, 10)
 #define PIDFD_GET_INFO                        _IOWR(PIDFS_IOCTL_MAGIC, 11, struct pidfd_info)
 
+/* Return an O_PATH file descriptor for the target task's executable. */
+#define PIDFD_GET_EXE                         _IO(PIDFS_IOCTL_MAGIC, 12)
+/* Return an O_PATH file descriptor for the target task's working directory. */
+#define PIDFD_GET_CWD                         _IO(PIDFS_IOCTL_MAGIC, 13)
+/* Return an O_PATH file descriptor for the target task's root directory. */
+#define PIDFD_GET_ROOT                        _IO(PIDFS_IOCTL_MAGIC, 14)
+
 #endif /* _UAPI_LINUX_PIDFD_H */

-- 
2.53.0


