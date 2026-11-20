Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795170805;
	b=RV4k+4pAUhghUuNJs8ZyTe+laB+NwCp7nbQDRHl/fa6ocZ09przGRwH7J/Okw8H5uilR
	 FT3Xp0mgAq7cdH8INoVC9uh83URiN0aohlT/onB0g9Icd9aAxnk6XMuS5miOBAxAT/EgO
	 aqkN5ZK9rlHFlYKT3XwfveQMIsuVUGHuSiiEkKxI5ZcdZk8Mn+L6NOWZSOdYzDE5E2MDx
	 ZPdroAe+dUTDCvkLGjraUEWIavSUWm7BpI4Ym0by0/uQNauhPvTwkBc/1+BbwYahih0/C
	 0O+bFs2UTlT9leOP94zS/+8mQz58LjHe0S8nF8EsEGEiR7a8tSTAfWFZeuVbwSL9MSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795170805;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=t9oeuZg5SOFELh61DhL9TrcyeFMUL5FVI7HyV9D7ONM=;
	b=ENqpYgOgfzGTyAafC/KubIcjG5YSAlkIzdghGAyom+QbyTHDMBsgcmjVMxifaUYmr9bk
	 EOqDGUnSLp7PnzqwFumczY8oBSgnqg6LWBE1XsUYRitysZhFS0CZHlYrNzUvEW13q3pdd
	 0a5UunErkv3yn5uKwqxR4JC2pLf0OsFGSfy6UboRNlgVXJIJvnEjAIaGfpICMB9J1SdVv
	 cQbGgHWtwEdyaTMd/eNjABL3//EWV3avl6e3mvnx7LozpiHM+HQbaxTLqB+D9tNwPKSsl
	 0Fsi7rHvAN5hNFCwKFgslV/RLimJJ1SuViAI/EvGfW/8Iq8XpKi+y5upVWVspkkRmcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MT90aUeJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 88315606A320;
	Fri, 20 Nov 2026 10:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MT90aUeJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 180BE1F000C4;
	Fri, 20 Nov 2026 10:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170804;
	bh=t9oeuZg5SOFELh61DhL9TrcyeFMUL5FVI7HyV9D7ONM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MT90aUeJnbBLoxSnli8tTtBlsoFe45xxYq7FCMaOJfqXCyODpNpspWc3hSd8SkzQT
	 m9HM/m7tfYasOLIuMLno+XIBkfnsJritn1I35Hs+G85PGyOWo2aqbx01Nb546s3l7J
	 BWGnwVJYoBUhcgV1FsrIjpajqeru0eyjz/AssVQJQzDpJuh5zNs0pxZtz1D7YPzYAN
	 ZzYDSSj8TvhhBVhbzNJkR/DPNP3NVKgSci50dNMucuDoqkdGwZpbuLzlHRwDlI3yq2
	 oowRyN8OH4AiBudC5DwdHeH70QNVCNAH2foLQpSDv5FnrOZ2vP8EWoxiV4qmR5D1+m
	 a8ZBginKlEPFg==
Date: Fri, 20 Nov 2026 12:33:21 +0200
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
Subject: Re: [RFC PATCH v4 07/14] fork: Support CLONE_INTO_ROOTNS in clone3()
Message-ID: <awAh8chFM-9WtNKP@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
 <20261119224312.1037966-8-jarkko@kernel.org>
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
In-Reply-To: <20261119224312.1037966-8-jarkko@kernel.org>

On Fri, Nov 20, 2026 at 12:43:05AM +0200, Jarkko Sakkinen wrote:
> Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> safely mutate process-wide filesystem state in place before spawning a
> child into a target namespace set.
> 
> Add CLONE_INTO_ROOTNS and struct clone_args.rootns (CLONE_ARGS_SIZE_VER3)
> to spawn a child process directly into a rootns whose root mount has
> been installed. Transition the rootns from ROOTNS_INIT through
> ROOTNS_FORKING to ROOTNS_RUNNING for the first process so it becomes
> PID 1, serialize concurrent entrants on waitq until bootstrap resolves,
> and admit subsequent callers into the running PID namespace until
> teardown begins.
> 
> Derive child credentials from current, require CAP_SYS_ADMIN and
> CAP_SYS_CHROOT in the target user namespace and an ancestor active PID
> namespace, preserve caller umask, reset dumpability across user namespace
> transitions, commit time namespace vvar mappings after copy_process()
> succeeds, and look up the live mount namespace root. Restrict companion
> flags to CLONE_VFORK, CLONE_PIDFD, CLONE_PIDFD_AUTOKILL, CLONE_AUTOREAP,
> CLONE_CLEAR_SIGHAND, CLONE_INTO_CGROUP, and CLONE_NNP.
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

Being fd-bound object the gist is that the first clone3() binds
cgroups, which could e.g., different process than who build the
container.

CLONE_INTO_CGROUPS is of course available as an optional flag when
using CLONE_INTO_ROOTNS.

Br, Jarkko
