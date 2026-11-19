Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795069291;
	b=v6H8Eqr0fnYg7hU+LXloUuVLfsJJTLJITJsjVeeaHlDZyMUyKz5GW7+4GjAhwIL2/tuW
	 Z/J5H9olDGIiIpfp4ET8IbmXlCpwFhxUvMm+lR+2vPiQAzM5xzl2IAdCSh09obDRoDZTW
	 SeeDSP7OiUj9Y14u+oQcKdeJjyUNwJ8T/qEt6BOWsqH23A1NFQHWCxxQva87+TWbbutvQ
	 oquDkCSfgv3+smy38YWUTKeELad0tojT47fnzTEQLpVgDdSyUIZ1Jze9Ay174vZUURBih
	 RUK70gSCwOIGARYNdtuxBhvUsubxIsmUwENWp3NE95efwygaTtI8F/lghl7smzzaZag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795069291;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=btZ2TprQHQojMwnDwVX6xxEuU+pesarzzPhbHJEdoGg=;
	b=aJhdrYDTVGM+hZ5EhauuarR1r7QtwsyMYPlZBm22siHWZpzkvfod8UQvMai9lFeMEml0
	 K+LQkFNoBQX9cti8KLJJj8dr/Q9oS4+MCTMoisiwPbwJOr2siT+9Jnyeol/5u/iheBMhQ
	 tXmnsGyKQsGo3cVD68Zt3SsG2QZEwYz7NUxeb+f1xx7kA3iRlpLXDO6UvSk5GkS43We4m
	 k9hcw2QysNvYO9kyRG+EetuV6xJZC0KsLO7hGUu2ebkqq+sdr5H8SewU628korMVxwLEv
	 7WsaU87pfFO7DPYkji3W+JriQ0jhszjK7dB/7IfPsZByVLWOWAISDISNjsrowcCALww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7xa1Dpj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7CC20606A32A;
	Thu, 19 Nov 2026 06:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7xa1Dpj
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 99E921F000C4;
	Thu, 19 Nov 2026 06:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795069291;
	bh=btZ2TprQHQojMwnDwVX6xxEuU+pesarzzPhbHJEdoGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e7xa1Dpj4IV+gGquktCuwkP8uLbLXtGks3wuXwt/tSMkOsmBjJ/0z/lSi6xpEE1if
	 M+ClMf07lAH8kSdnFi7nUiv7E1oRGPNtacMDB0C9ZyZ9nVvpOERjMX8QaAKZ7lKRn4
	 M1z2+y5hTJxFCzzBM0zcOMJWoXKpQIZjVMenn5ZU2BG85Fmxa/pgerSdcdz7kbKLdA
	 QCVfwXzNN8zWPDBlSNSXrmUbYCk3O1GsxodMLXYujCtnvsjSw4DQj4SWvGVet8sWJk
	 gjUyqjq21Sc89moWlZp69HUgI6J3icvNRaTO40aErPOsiyV3xe7t6GSDpp7+hZ+Auj
	 I9xdx3hVfOiUQ==
Date: Thu, 19 Nov 2026 08:21:27 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Message-ID: <av6VZ5NQG4GwYvPl@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <av4CdM-eW73oO4wB@kernel.org>
 <av4NonrcCxzMoDyz@kernel.org>
 <av5-Zc4xhgkPxb7p@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av5-Zc4xhgkPxb7p@kernel.org>

On Thu, Nov 19, 2026 at 06:43:21AM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 10:42:10PM +0200, Jarkko Sakkinen wrote:
> > > I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
> > > than root nsfd can be acquired as follows:
> > > 
> > > 	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> > 
> > 
> > Unprivileged caller becomes the owner of rootns->user_ns. Each mount
> > syscall then just checks CAP_SYS_ADMIN against rootns->user_ns.
> > 
> > The user space wiring goes along the lines of:
> > 
> >         int root_fd = rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
> >         int mntns_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> > 
> >         int tmpfs_fd = fsopen("tmpfs", 0);
> >         fsconfig(tmpfs_fd, FSCONFIG_SET_ROOTNS, NULL, NULL, root_fd);
> >         fsconfig(tmpfs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
> >         int rootfs_fd = fsmount(tmpfs_fd, 0, 0);
> > 
> >         move_mount(rootfs_fd, "", mntns_fd, "/", MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS);
> > 
> >         struct clone_args args = {
> >                 .flags  = CLONE_INTO_ROOTNS,
> >                 .rootns = root_fd,
> >         };
> >         pid_t pid = clone3(&args, sizeof(args));
> 
> 
> [BTW, this patch set is pointed out to David and not fsdevel mailing by a
>  mishap, apologies.]
> 
> I reduced syscalls can be further to only a single syscall: rootns()
> 
> The complete API after this:
> 
> 1. rootns(flags)
> 2. ioctl(rootfs_fd, ROOTNS_GET_NSFD, ns)
> 3. ioctl(rootfs_fd, ROOTNS_WAIT, NULL)
> 4. ioctl(rootfs_fd, ROOTNS_KILL, signum)
> 
> An updated version of the patch set is available over here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=rootns
> 
> In order to find more evidence that the API is trimmed and code has no
> extra fat, I tried how LSM hooks size-fit.
> 
> Attached are the experimental LSM hooks and while possibly not exactly
> right they should not be at least in the ballpar (Paul?).
> 
> Not perfect, but very usable, and there's a steady track of convergence
> where resolving a bottleneck leads into a better symmetry and coherency
> overall.

Orthogonally, solely fd-local security model (as all is tied to fd) is
the best thing ever when defining mandatory access control policies  as
the full flow can be meaningfully described; i.e. roonts(), sendmsg()
and other calls track the fd's data flow with almost the highest
achievable granularity.

Br, Jarkko
