Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794945818;
	b=gOWJEERc7FwKnWm6s+Qbkup6BLQQSezyJlSSEQOcz3ivPKpXI0xsCICYkrdAmSX6EcPX
	 JI098OIfleCpY9lzmiC84uMwolsyHuF+WB8pSiEv+AZtTYYukP3XqKzBFaBL9eC/DWczu
	 E3oDF0TaTdGjN9a8dVXDQYIdcGamIuwNhNFSzZY5gfAvWtDZf0DwPFQy/8y7KSaiWKOGO
	 W0EQ6bNLrZAnGGrqDfmuYhK1UauMFzZ/uxMUi4NR+DcwUboMqeS42RoHpNIciQTMQu385
	 GkAK4/YHMt7N2HJBGqDTHVcvYjyzEQL1f5/cvPCkZTbCe5B0zgM/ej8KpY4wfKFJzcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794945818;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=A7F9vGUwuGm89Sq7Z6BKmbqulj1taVMbbgDwWzUX518=;
	b=E52aRgDAxEXCxwlDBwlfahW7WG6fJCs0Q/8p8RT/CtFDrJzw/0wI0ts6kgtsGhCP7cVL
	 Isf1+6h/WR4xvEuW4FRXa55F6Nnjq0JhsHXza59CnEzzrLG/+IwYEVt8w1lcrOYUsWACs
	 tYIpjtdLrblSeDc2p8pjBgB5KYf9jxhz6gj82EqMsgcOBK4oh5McckytWuSCbtIB6R5Y9
	 pg7H73OhR6NsKD7o57ZPhPvzK3XXCUJbc2ALtWN07C8MDpmeA7auML5wC9+OIvTEMQVas
	 m6AYFE7BU+l4r2bwna8arCcFrOLdVWqys5pJYvHj/RLB2Cfcj8XJmO+0cToVvJdAb1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgZV8Wvz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 22C55606A32A;
	Tue, 17 Nov 2026 20:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgZV8Wvz
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 453F21F000C4;
	Tue, 17 Nov 2026 20:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794945818;
	bh=A7F9vGUwuGm89Sq7Z6BKmbqulj1taVMbbgDwWzUX518=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GgZV8WvzcdepSUadf6SySKEgnAJgIRXVt6j0ej7g1R4olLseL6+Kzp1GDlNhnKddU
	 si3ENXKDzBgoKGmWrIX3uc1Sac5ouCqJQSgNT3cFQm4mHP3Op6nnesr9x6wuTbSNwC
	 opviFh71CCcLK/BQ4wakf+n49QvI41MbVWUMeEiOrXYmzsI1zneVe9ACOd+n8fYxZl
	 JRTGLazZCNCNDGqYr1YZJS6Mvt6nuNW5zYSK6SBBhT7qvnpO+92T7nRH12ryNYsJrg
	 VL3JfrdW6rXtfQM5Cptxm/f7P0nTVIk+gGrufpzNmsw1p2eOUUX/0WwilkUXBWliZS
	 VwFOOPHxJc4LQ==
Date: Tue, 17 Nov 2026 22:03:34 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [RFC PATCH 07/13] rootns: Add rootns_enter() system call
Message-ID: <avyzFnKQrNOid25y@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <20261117050841.3289652-8-jarkko@kernel.org>
 <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWtbUFQGDOCHkxAN9O4i29ixfL5KKF1Cqw2-CjxKwC6gQ@mail.gmail.com>

On Tue, Nov 17, 2026 at 09:42:26AM -0800, Andy Lutomirski wrote:
> On Mon, Nov 16, 2026 at 9:09 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > Multithreaded userspace daemons cannot call setns(CLONE_NEWUSER) or
> > safely mutate process-wide filesystem state in place before spawning a
> > child into a target namespace set.
> >
> > Add the rootns_enter() system call to fork a child process directly into
> > a rootns whose root mount has been installed. Transition the rootns from
> > ROOTNS_READY through ROOTNS_FORKING to ROOTNS_RUNNING for the first
> > process so it becomes PID 1, serialize concurrent entrants on waitq
> > until bootstrap resolves, and admit subsequent callers into the running
> > PID namespace until teardown begins.
> >
> > Require CAP_SYS_ADMIN in the target user namespace, forbid credential or
> > PR_SET_NO_NEW_PRIVS privilege escalation
> 
> Why are you disallowing this if no_new_privs?

For no any good reason at all apparently: no_new_privs is inherited by
the child and only restricts privilege gain across execve(), whereas
user_namespace transitions are allowed under it.

So yeah, it's a spurious check, and thus I'll drop it.

> This isn't necessarily a showstopper, but fork() is really quite slow
> in many cases.  It would be nice to have a more spawn-like API
> available.  I assume it's possible to open a file in the target's
> mountns by some sane API even without entering that mountns, as a side
> effect of how the fsopen / move_mount mechanism works.


If the caller retains the O_PATH fd returned by fsmount() for "/", it is
able to open files inside the target mount tree via openat2(...,
RESOLVE_IN_ROOT) w/o entering the mount namespace, and pass the
resulting fd to execveat().

For avoiding full fork(), there are (at least) two options:

1. A rootns flag in clone3() (e.g., CLONE_INTO_ROOTNS) and a rootns fd
   in struct clone_args (disallowing incompatible CLONE_NEW*, CLONE_FS,
   CLONE_THREAD, ...), and callers can pair it with CLONE_VM | CLONE_VFORK.
2. A flags parameter in rootns_enter() (e.g., ROOTNS_ENTER_VFORK), which
   would map directly to CLONE_VM | CLONE_VFORK.

> 
> --Andy

Br, Jarkko
