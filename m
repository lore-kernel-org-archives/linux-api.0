Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A7731A065;
	Mon, 31 Aug 2026 08:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788166189; cv=none; b=c124OFjY/H1BOWGphpjkFfxQSbN4yRsIRA6nQYpk9Ivu6LndO5F/qtp+CiQhLsskqwRBrNJmWAK58bDjHAExXOeA8TJe8vZ2VzfIXdZQX4HxVDfaOkVFoywDON9QynNDLnBEGjCFpulkjm6ZBIOtMTtji4wGk0qWYkBugnARwAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788166189; c=relaxed/simple;
	bh=RZsKRXUZ5MHkySOQ0pr1OGOzLW4PFVPPjI5FsfQV+lQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=kzWprTAXAfw7fxUh/q2FdFldHWXZ8hqhveOFjEvVLGbvdT/9lybsLb+QLsiBuSVVdiGwT0U3gdmC435hZTGFWb4R1YMpzuaLjimGi8+a1ufn0sMI3BfUju1Ks2v8R5R3cmfTZKSEk2WeiBPDqIkA+ZX4iJ1ke5nI/7VAF2QxY0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FaZekYeZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FaZekYeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8873A1F000E9;
	Mon, 31 Aug 2026 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166188;
	bh=U0RHUkeCK2+wI7g+xlveFyXCiygTgGH8M2YKQRICDbA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=FaZekYeZ0wFn0PLi2UeXQLR+DZ7Ga92WjP0iO0y3hPuhr7su7CkEDkn33bWwnytSy
	 bqfIgL6Rvjq0S5SBAEUGLQx7m56Qtzy1v1x0BCgLs8JTn59a05Qv/61kCQttaR5FwC
	 YK8Ew7IZDm5mKZIZOXrACM/O3Hd4VPjUO0iNW/CrvH3+p84aniky+0n76MgfvfEi2x
	 Zbsd+LfZzInCbDD3bgwwXSgCnoyLUGMWS0X87UtMiUPqI/6dGX4yKUDx6YF6soUTOE
	 luXbDuWAdjKCDJnaCAzS4n8PEKm7feSkY70ckwlXke+xvNMjIPhfKeAH6WuZjRBYoK
	 pT1ZRHj5evrxw==
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
From: Christian Brauner <brauner@kernel.org>
To: Chen Linxuan <me@black-desk.cn>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
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
 "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
In-Reply-To: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
Date: Mon, 31 Aug 2026 10:49:39 +0200
Message-Id: <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1813; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RZsKRXUZ5MHkySOQ0pr1OGOzLW4PFVPPjI5FsfQV+lQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNdVCtzLdnsxG4xVH55O6X/3MWT28u6stlL3/36Y9nz
 sMr/3++7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIBTsjw+0H/otM9kquFjxX
 qq2ymFcwSzPDN64tZGXTnGtv3k+b8ZDhf4ZlH8PR9v3Ja9p6IlIU38x3dXzKfuFz2+O+CwxaSzy
 WcwIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> Obtaining a target task's executable, working directory, or root
> currently requires walking procfs symlinks such as /proc/<pid>/exe,
> /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
> on procfs being mounted and visible to the caller, even when it already
> holds a pidfd for the target.
> 
> This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> ioctl takes no argument and returns a close-on-exec O_PATH file
> descriptor referencing the corresponding task path.  The new ioctls use
> the same ptrace permission check and nonzero-argument rejection as the
> existing pidfd namespace ioctls.
> 
> The target task is sampled while holding its exec_update_lock. This
> keeps the access decision and the task-state read in the same exec
> critical section, preventing a concurrent execve() from changing the
> credentials or target state between the check and the use.
> 
> The first patch factors out helpers for acquiring referenced task paths
> and reuses them in procfs and AppArmor.  The second patch introduces
> scoped cleanup for privileged pidfd task access and separates namespace
> lookup from namespace fd creation.  The final patch uses these pieces to
> implement the three new ioctls.
> 
> Signed-off-by: Chen Linxuan <me@black-desk.cn>
> ---

I really have difficulties forming an opinion on this. So this sounds
very useful but it has implications.

Right now, pidfd ioctls are available even in situations where the task
in question would not be accessible via procfs, e.g., when procfs is
mounted with "hidepid" options or similar. So this would expand the
surface of operations you could potentially do.

But again, I do think it is actually useful. Adding Jann.

