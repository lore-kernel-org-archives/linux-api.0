Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381954C10C9;
	Fri, 25 Sep 2026 15:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349160; cv=none; b=WcKNs/QjxAbwcAsPKa+9RHCU5hU7IvWAUnRs7r9kTBGPEVGRVmX8hGcGF/jofvF3f0Vy73S1WxfQziJO8FUiaMJnwyWNNc3RBcRk7GZlEY54joENNGueZHAyZzZLIOAKjYmE+rWqywHtf0IOQQfQlhK7Pu3P87ykOMBDlFc/Q44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349160; c=relaxed/simple;
	bh=MRSukCWNve3Kzs5BeN87oA6khPyqwIpTypZ7gKzRH3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eH5tQr8/piYWx5kNKgj1YTIOZrpDXrimLKCF+edONg7cajOWrR40rF+EBqWsEShXIDj4FGz8IC4dACJ+RxSFD66LGWh65Z6Zutts2pC0UosiAt+CRpV5yVDJuIcGaKkwiGCPtC1z5zZDFyhiXPIBNf0QkWpxPLozEuAa2oNCEBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BAhy/v8T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BAhy/v8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6DD1F000FF;
	Fri, 25 Sep 2026 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790349141;
	bh=c5yS4K3YB4cbDqechSUZ/Ihi+uzGED0jeEp/TnJEBhA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BAhy/v8TxG6BFYuCpIAX+zhkeekEHZwQXxuuF9RW92bIf3O/Be8NmqqdEryfJWALg
	 U/D9uKVRaM8f3sG74RyDOjAda0blaOWoy7xbb/potO1QU2j1USwNVqlH9++InDJfTi
	 OQooqgeolp/H7pt+snwrdA3psFqDp1p1jH1q/8+fl2CmKEJacXTOHI4UuvnEHcwWaS
	 9atvlZX1qGtA6vt4u7uCDpOt88XcpdJcfljswhb+S7Pqbdgpmg6HXAfTUgkvzuz14F
	 J1F0aD/9ILLkNRnzjRGWsCjD3sAVn06mCxk0/Lm5hVsE0LcCBGMCS0ivJqjT9unVI5
	 mXlhb7B3qE4+g==
Date: Fri, 25 Sep 2026 17:12:11 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Chen Linxuan <me@black-desk.cn>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, John Johansen <john.johansen@canonical.com>, 
	Georgia Garcia <georgia.garcia@canonical.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
Message-ID: <20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner>
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
 <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
 <CAC1kPDMK_D4nhyRmBHg6KC7SmmCkH73Xtc5DhXeJbSvf3LcqcQ@mail.gmail.com>
 <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com>

On Mon, Sep 21, 2026 at 10:22:11PM +0200, Jann Horn wrote:
> On Wed, Sep 2, 2026 at 8:47 AM Chen Linxuan <me@black-desk.cn> wrote:
> > On Mon, Aug 31, 2026 at 4:49 PM Christian Brauner <brauner@kernel.org> wrote:
> > > On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> > > > Obtaining a target task's executable, working directory, or root
> > > > currently requires walking procfs symlinks such as /proc/<pid>/exe,
> > > > /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
> > > > on procfs being mounted and visible to the caller, even when it already
> > > > holds a pidfd for the target.
> > > >
> > > > This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> > > > ioctl takes no argument and returns a close-on-exec O_PATH file
> > > > descriptor referencing the corresponding task path.  The new ioctls use
> > > > the same ptrace permission check and nonzero-argument rejection as the
> > > > existing pidfd namespace ioctls.
> > > >
> > > > The target task is sampled while holding its exec_update_lock. This
> > > > keeps the access decision and the task-state read in the same exec
> > > > critical section, preventing a concurrent execve() from changing the
> > > > credentials or target state between the check and the use.
> > > >
> > > > The first patch factors out helpers for acquiring referenced task paths
> > > > and reuses them in procfs and AppArmor.  The second patch introduces
> > > > scoped cleanup for privileged pidfd task access and separates namespace
> > > > lookup from namespace fd creation.  The final patch uses these pieces to
> > > > implement the three new ioctls.
> > > >
> > > > Signed-off-by: Chen Linxuan <me@black-desk.cn>
> > > > ---
> > >
> > > I really have difficulties forming an opinion on this. So this sounds
> > > very useful but it has implications.
> > >
> > > Right now, pidfd ioctls are available even in situations where the task
> > > in question would not be accessible via procfs, e.g., when procfs is
> > > mounted with "hidepid" options or similar. So this would expand the
> >
> > One point regarding hidepid: for callers that can pass
> > PTRACE_MODE_READ_FSCREDS, hidepid does not provide an additional
> > restriction. With hidepid=1 or hidepid=2, has_pid_permissions() falls
> > back to ptrace_may_access(..., PTRACE_MODE_READ_FSCREDS), and
> > hidepid=ptraceable uses that check directly. In addition, the
> > /proc/<pid>/{exe,cwd,root} links independently perform the same
> > PTRACE_MODE_READ_FSCREDS check in call_proc_get_link(), regardless of
> > the hidepid mode.
> >
> > So for these specific path lookups, hidepid does not block a caller who
> > would already pass the check used by the proposed pidfd ioctls.
> 
> Agreed, I think with regards to hidepid there should be no issue here.
> 
> If I try to come up with scenarios in which this could introduce
> additional danger, the main one I can think of would be: A task T1 is
> running inside a pid namespace and has a unix domain socket connection
> to a task T2 outside the namespace, with both running as the same
> EUID; T1 sets SO_PASSPIDFD on its socket to obtain a pidfd pointing to
> T2 on the next message sent by T2, then T1 uses that to get access to
> the mount namespace of T2.
> 
> Christian, is there some mechanism that already protects against using
> something like SO_PASSPIDFD to get a pidfd to a process in a parent
> namespace?
> Otherwise, should we add something like a "pid_vnr(pid) != 0" check
> either in these new operations or in SO_PASSPIDFD?

Right now we don't place any hierarchical restrictions on SO_PASSPIDFD
or SO_PEERPIDFD at all and this is in use by varlink iirc.

What about requiring pid_vnr(pid != 0 for any operations that grant
access to additional resources. IOW, make the icotl for any ns
descriptor or cwd/root fail if the caller is outside the pidns
hierarchy?
