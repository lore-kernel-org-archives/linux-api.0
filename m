Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4A72DA768;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788145152; cv=none; b=rNMmVHq6ZDjfgL4B2jygp6zAK093l0I51DpVmAZCJqOHDM+UgH7b9wNWK7vw5gRu11s3D2ZTitGh05aVJ4PBuWtF1UmMuOx4IUr5MxpVgCLBP9fp09UPsw4lANXK4AoL4YdxzC4xhIRwGqRH2ZdchgZwHx5QhTlnnSfeCrLurvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788145152; c=relaxed/simple;
	bh=RMKGmZEdzeP7q4RQyJWLL5ub3gwDxt6jUsCX6DmjrtY=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=l0dmGbTNBK6RCfwJdLcNHBbFO3DpIllFUpkbbk4cu9NuNa7Gucv27FUsTyXIXPZFXSdWNJmCE4kRIjKytD7MZf5gQYbpDBoSGquvOlz3ARpo7UTCCToN5eNTdo61Y6B1DXP8Jdp+OUgBCVfRIjacTGG71I4qVZiitYJkwO70nfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TKt3RH9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TKt3RH9y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BBB4C2BCC7;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788145151;
	bh=RMKGmZEdzeP7q4RQyJWLL5ub3gwDxt6jUsCX6DmjrtY=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=TKt3RH9ywQh+2U+bclod27pUMCxZgwIvkUJdtlPCxfYjm7Uabt3JtfceAakC+o9Qv
	 4UT7x1TQCIIpab/pm17iQBOeJ5gqOBCLfmlj5MsC9Fa3EFubPbJ/BrYqkg8lMAXyOg
	 DswiXsCZ5EbzaFkkeLBMYX/YMZfqOIiMDkiBEhbamv7Ul1oJiOAMiiQZeXm4txn/7a
	 /0gVJTfoxrqo9gBIWQnjZod1wX618QP6E+WuPgN4+UwaVa/1Tp3YvgyNUYB+1CLbyK
	 UW7alQbh0kpPDYeOAYAnu9Nz/swlgQ7w7zHaXLcxTi43DGHRQdSFMvbNLjiISfV1Bb
	 R86G9pYd56NBg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7596AC61DF0;
	Mon, 31 Aug 2026 02:59:11 +0000 (UTC)
From: Chen Linxuan via B4 Relay <devnull+me.black-desk.cn@kernel.org>
Subject: [PATCH v2 0/3] pidfd: add task path ioctls
Date: Mon, 31 Aug 2026 10:59:05 +0800
Message-Id: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPntlGoC/2WNyw6CMBBFf4V07Zi2PAKu/A/DonQGGDFA2ko0h
 H+3oDuXJzn33FV4ckxeXJJVOFrY8zRG0KdE2N6MHQFjZKGlLmSpKpgZW4SOAswm9B7yqsgklhY
 VkYir2VHLr6N4q7/sn82dbNgzu9GzD5N7H5eL2r1fXcu/+qJAgrEpEWVSpphfm4exAyD54WxHU
 W/b9gGsVnX8xAAAAA==
X-Change-ID: 20260819-pidfd-get-paths-59640d8cd1ee
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3549; i=me@black-desk.cn;
 s=20260831; h=from:subject:message-id;
 bh=RMKGmZEdzeP7q4RQyJWLL5ub3gwDxt6jUsCX6DmjrtY=;
 b=owEBbQKS/ZANAwAKAXYe5hQ5ma6LAcsmYgBqlO37ZFQatvNIJ/XqWG5+bT55C46sV06hh7vsz
 nV6esn8i+SJAjMEAAEKAB0WIQTO1VElAk6xdvy0ZVp2HuYUOZmuiwUCapTt+wAKCRB2HuYUOZmu
 i6b2D/4puD5mcrb6qIcY8fPVCL726xa5XVAfOmZYE6ujw+AMfe7DCzs9at0X6tjITAq79046tno
 R5lu9W07Yl/SyM8SQbe8qFMyICkr+dCQ3aBgLyO02B3xMmq/of+Zl9hwX+mo3B5v6WOesIdTwDQ
 ApCXcjyvz/BhV+Xa6QLduRrop2wnXfW6V6xCtLzL5hbJs1uwmo+E32dxz8vTN7WnkaR1/ZqRIxY
 hqOD3WZzgdr+xYctOVSe59+06DaT1Ziry0N96FozDQvkNZSkutS5jo1TTScGN9tbczg4yoyYKpU
 koJVijkxkaTvuGAKoJSLr3PKRljhvkHdo9/wMlXrNNjYG1Q2WRyqqG/z78ocMahd/9MSaPC6x6y
 7A2kv53KAl0orXsUKgHWUIeG4gzH4oZn4c2cZgecEymfASxrfpGLZCWAGE+vwcjzNjoKe/UNpEd
 zcxjqRzNnH/rqKgf6HaBzhct7Q0tQLRiVXg8zRgqiVchfEVZ0JOGR2G6DtSl6D14PB6uPEDZi94
 3HuakPqCsEKOzCKy192XUvPpBc/NsXTV5OvqJIYMteXtl16ZE28S9msyF4sC1sJscpVZRKuu/c3
 vVuQalPUCIYjCo2Pu9b4T0FwHNyGiCABxIPhgoxnuwB/dB+LhKkt58Y+pMUC1AK1GGj9JwkRf2M
 2feItAuIEwUdetw==
X-Developer-Key: i=me@black-desk.cn; a=openpgp;
 fpr=D818ACDD385CAE92D4BAC01A6269794D24791D21
X-Endpoint-Received: by B4 Relay for me@black-desk.cn/20260831 with
 auth_id=991
X-Original-From: Chen Linxuan <me@black-desk.cn>
Reply-To: me@black-desk.cn

Obtaining a target task's executable, working directory, or root
currently requires walking procfs symlinks such as /proc/<pid>/exe,
/proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
on procfs being mounted and visible to the caller, even when it already
holds a pidfd for the target.

This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
ioctl takes no argument and returns a close-on-exec O_PATH file
descriptor referencing the corresponding task path.  The new ioctls use
the same ptrace permission check and nonzero-argument rejection as the
existing pidfd namespace ioctls.

The target task is sampled while holding its exec_update_lock. This
keeps the access decision and the task-state read in the same exec
critical section, preventing a concurrent execve() from changing the
credentials or target state between the check and the use.

The first patch factors out helpers for acquiring referenced task paths
and reuses them in procfs and AppArmor.  The second patch introduces
scoped cleanup for privileged pidfd task access and separates namespace
lookup from namespace fd creation.  The final patch uses these pieces to
implement the three new ioctls.

Signed-off-by: Chen Linxuan <me@black-desk.cn>
---
Changes in v2:
- Make pidfd_get_task_locked() own the task reference until it is
  transferred to the pidfd_task_locked cleanup class.
- Link to v1: https://patch.msgid.link/20260820-pidfd-get-paths-v1-0-ac3eee4003d5@black-desk.cn

To: Alexander Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Ingo Molnar <mingo@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@redhat.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
To: Ben Segall <bsegall@google.com>
To: Mel Gorman <mgorman@suse.de>
To: Valentin Schneider <vschneid@redhat.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
To: Kees Cook <kees@kernel.org>
To: John Johansen <john.johansen@canonical.com>
To: Georgia Garcia <georgia.garcia@canonical.com>
To: Paul Moore <paul@paul-moore.com>
To: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: apparmor@lists.ubuntu.com
Cc: linux-security-module@vger.kernel.org

---
Chen Linxuan (3):
      fs: Introduce task path helpers
      pidfd: Use scoped cleanup for task access
      pidfd: Add task path ioctls

 fs/fs_struct.c             |  44 +++++++++++++
 fs/pidfs.c                 | 153 ++++++++++++++++++++++++++++++++-------------
 fs/proc/base.c             |  34 +---------
 include/linux/fs_struct.h  |   3 +
 include/linux/mm.h         |   1 +
 include/uapi/linux/pidfd.h |   7 +++
 kernel/fork.c              |  21 +++++++
 security/apparmor/task.c   |  12 +---
 8 files changed, 190 insertions(+), 85 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260819-pidfd-get-paths-59640d8cd1ee

Best regards,
--  
Chen Linxuan <me@black-desk.cn>


