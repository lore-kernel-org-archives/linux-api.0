Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795170272;
	b=fPQm85pMe7Vs3hNdM952n69G1SWGXrDk83zRRk11hOdk/da3mV6Fi+hCspheHtia547l
	 0IvngzJEp9oWQEPduVZEU209HpbxC72EdCJ+xkJU6Q/L9nR9b/uMCZbwaqK2KHIKAo5yk
	 +dV8mBNX8tK9PoZCCYfLU0wJYzXQDetMAKdSPKkAvzQmmDul2Uk1MBcvkM79UcX/1ld6/
	 v1UfDsHlXXTUVY/n+tt8SYhhfzB8fvuwAQOOoAVMcWRSSDn2H/vVdEKJeDKdQhHwne/WJ
	 uDKgIRvTkje3ehF3uhIswdUl+uFmV7eT+WjGwBG9GbgH6G14pompYpfv6Rw2to4ZESA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795170272;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qNbHXGTNMLkg4zeH+TBnXHN+GFSzA5rFIxrp9YgCBoY=;
	b=gDQdnuauIA70KaDGe7KOtP1FvGaKFnqikmgDTx+/Kr3ipEXzJUMeaGDN0tcnxCiKa5WF
	 hIPH0BJIguHmhh8Jtv/YX5jSp5fTQdC8hyRy3Kga5tPV74ZG204BW39RXPEKrYRj2msnL
	 JaZN1c30gu8WKr0v7zoeeGBzisLMXrKrgiQmc1t/uXZkZfcr1GduGylVtnMrzmusEfJAd
	 Em6x0BBCkjRmREOrd05RpiYKN9Jn8FvxNwNupsxZ/nPgzjZcWOkz5MelSqchAG2VfEYB/
	 PeodBf03jIiNbnkhV4gwHvB698PHo1iN0D3kWeYtcqHCfI/XZOGsJI5CSgUK01L9QpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFvAWVF4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4BDF6606A320;
	Fri, 20 Nov 2026 10:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFvAWVF4
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 751731F000C4;
	Fri, 20 Nov 2026 10:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170272;
	bh=qNbHXGTNMLkg4zeH+TBnXHN+GFSzA5rFIxrp9YgCBoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nFvAWVF4Odb1RhPoYQyAGaD1llD8ahxydiIGjR1jelNSPSgIf5xjqkDTBfAjpXIGN
	 HMgOw7YokKejMzcXGcjsrExLH5iKsBGzTzT8kmQC7Q+ELR86L+96iltCT96Dyfj40V
	 JhiOaYe3t5rBBPSAjsQGbvjZShZ9o4hyP2abX4qDIMrY3ao+VFF9Kg1yNliPXKeUaV
	 PWfKIB+dxk5s2RQA6jVpo5hXvdf8uzEHHFO1zbIQJr76jtyCNlwvHbGxfKxSHi67gy
	 grRk1NX6j8MGwYTcMsKqtJk4JQyz2c/nq6Tstr4nUVMpqKwUzsYytvv2KugLAb8agk
	 zByiywEJOG23g==
Date: Fri, 20 Nov 2026 12:24:28 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>, Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v4 00/14] Namespace for namespace roots
Message-ID: <awAf3G6LxDJj_xYe@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <av_hbgzwo-1FcAPZ@kernel.org>
 <awAcpPQtM4hYHP-D@kernel.org>
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
In-Reply-To: <awAcpPQtM4hYHP-D@kernel.org>

On Fri, Nov 20, 2026 at 12:10:48PM +0200, Jarkko Sakkinen wrote:
> On Fri, Nov 20, 2026 at 07:58:10AM +0200, Jarkko Sakkinen wrote:
> > I've now re-sliced these into a bit more sane pieces:
> > 
> > $ git log --oneline master..
> > d8e24a6bc14e (HEAD -> rootns, origin/rootns) MAINTAINERS: Add entry for ROOT NAMESPACE
> > f2569e56a267 selftests/rootns: Add root namespace test suite
> > bea05e758f8e docs: Document root namespace uAPI
> > dd05a49aff77 arch: Wire up rootns() system call
> > 2dee7a5fddec bpf: Register rootns LSM hooks
> > 73c51e02b830 security: Add rootns LSM hooks
> > 3cfd6576a037 mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
> > 9ed7387038ea ipc/mqueue: Implement ->set_rootns() fs_context operation
> > 624f0ed9c1c7 proc: Implement ->set_rootns() fs_context operation
> > 1085e6ae2eb3 fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
> > d2898dbdc39b fork: Support CLONE_INTO_ROOTNS in clone3()
> > 42dbccb5890e rootns: Add ROOTNS_KILL ioctl
> > 14cbda3e5bca rootns: Add ROOTNS_WAIT ioctl
> > b2cc82539b75 rootns: Add rootns() system call
> > d29215aa7f0f rootns: Track init lifecycle via copy_process() and pid_namespace
> > 0f9ce7febb49 rootns: Add core infrastructure for root namespaces
> > 7a0e8f969fc7 mount: Enforce mount_too_revealing() for foreign mntns
> > 8c61aee3afbf mount: Add mnt_ns_get_root()
> > 07d239d0287c userns: Factor out install_user_ns_cred()
> > bf74588e706d nsfs: Add nsproxy_open_namespace()
> > 645d31a1c516 nsproxy: Pass nsproxy to create_new_namespaces()
> 
> A "small" fact correction: rootns itself is not actually a namespace. It
> was at some point during the course of doing something over alonger time
> span :-)
> 
> I'll adjust the language and documentation.
> 
> It's like SGX enclave i.e., an isolated and opaque object with *nothing*
> at Epoch. Similarly as enclaves there's a build phase for building the
> memory environment, and a live phase that follows.
> 
> Those are the glasses that I've looked at the topic all the time; not
> so much with namespace glasses, as it's not my main beef and actually
> doing this has very little to do with namespaces and so much more on how
> you manage and control the threads and memory.
> 
> This is more like cross-cutting feature with no obvious subsystem
> ownership more than anything else.

I'll also move config ROOTNS out of being inside config NAMESPACES. That
is a relic from the past (just noticed).

Br, Jarkko

