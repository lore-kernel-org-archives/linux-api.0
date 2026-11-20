Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180731;
	b=u7Ot7bObC4nEm1BQzNWdrWOKXlEfsG4xZ2YNCnQ+p6wqpWWtwvobt8CCat4ls5BMuEa0
	 AmuIT/tBK9N41vRN5k2LZNBv4Rwhj85XDa/jgGOJTZRPzn+RuN1Yz8WupTCHvAKbvrqET
	 yaJvFx3IHZpBq26nykYqr2R8fzf6aY7Vjj8cTBjZLjIyl9pcbzXn3lznzbOul3unVW6UB
	 D4DMRbmdLCv1wY585F8rpP49uKif08HC3NfKVmz36UhxCRK6iFb2Gw66BYKrC85NJ7k3e
	 8+smesGaI2IKz7zxvOSDh5Azdx7gsAevbROHZzmwxOypxoOUm7oOBOSmE/pQcsQoqxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180731;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Subject:
	 From:To:Cc:Date:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=YAQTVNIYZ/0Tbx2obltQhn42YTPBHmmwY733kBIibzM=;
	b=poWgssikY9M/Ps2VrbgqscRBv0GdSyBX45aTnxzMB6y5ko66T7S0rCPw+xC2xkqZurUh
	 E7pM/7Vg4d3fdt6o6dhcYCtHaTwC/Wha9tabxL7PSOEAT7nXcfH8tQqIDNvFjhd/iIo+b
	 Of0wXiZsKVJGd664UY7gtT0UqeZreSGz6O5qNvno6C9YC3zqMItkqRX9FrtjnMiQBvZE/
	 Z3DJCtYixNTqUafHOShLjITH7iEdglY7w/B0OiMcgvpBFy65ijpCeY17Woba4d3nI5KFN
	 20kl0qQ1jxzBt2MnGy+1LLfVVRGxMXsBlavAzRAUCNZ9e0n6zZfKV3Id3dIBklef8ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="UI/9rv+D";
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277FA606A330
	for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 13:18:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 277FA606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=UI/9rv+D
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c51373ae637so135958266b.3
        for <linux-api@vger.kernel.org>; Fri, 20 Nov 2026 05:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795180728; x=1795785528; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YAQTVNIYZ/0Tbx2obltQhn42YTPBHmmwY733kBIibzM=;
        b=UI/9rv+DZdDezz6z4q5V4bbLRvq2PUwTXKvmGLgkStPFRG3MFzpLEzZUOMicEVzjqv
         h9WskxL6pQRjVp6LW7wNLul6TdE5DMEMvMtKHVto1kDWUtXl4YZysNnP5izuUm6Wyf00
         02kOc+/ogItTG9aLvdGftl8BuwMr3ddEGZP8CscGYWnM7MnxJ1gdPDJRCMKsqAHhAduA
         5fYf+0m8yQ6qc78NG4siN795mYwXAc6BQzyhcrtUI3sLGXErAQdCZNzpNCRSgoDhZ53Q
         BTlXcoGhXILqja8hQmBbLSiQNTaIckFhQCA59sphyqAh5AgpCytcMtf2fggUT1oBCS51
         FT4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795180728; x=1795785528;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YAQTVNIYZ/0Tbx2obltQhn42YTPBHmmwY733kBIibzM=;
        b=fBkfJFRCBjdYkef0rh4RsvVYZP/IvWfKLQ524JUsr8QJcnSo91XNcyq2p/QqDCt+1N
         wIsP3WH2rkSQhTwIetsnTS6ZoyalL01KdjNHTZ+oegisJ5U/829R3Zk1NceHhFhh8Tbr
         JZxeUufAB40LLfWmwipD+E6XasDBb9mEMO4stUS+h1A53QcpFBHscMkx9nuAjEHVZd08
         5klEjvboQEBcCIxUs0L9GHVAPjcKU5vDAAAXLkB3Z1n4zKDwx6y+VTKLhYvU/wEXWxLY
         m3Bi2MXSy2po6tznJj18CSPZlchvshjAHDJyO51XL1EpcgpL9wmH/g23unZWFMwfDH0t
         XO3g==
X-Gm-Message-State: APuU4Z/cof1V1ML97LStlkniNwJTa+ID8+GpE719C2RaqyFNgnrREse9
	0+kI2/rDmrzEYvFwRidDL4nWaLr/fn/FVFPgQ7eiEP515mFsdFURf249N2dJSYbpjBJS
X-Gm-Gg: AYBFou2qPhL+aMHXcWv5YxAT0df6KpTa1HyRWSMpF3X2JP/vQ5q2U58DhlF+StlTYVF
	awn/ymXv4BRJgZ/s3Czf1xLhYKO0qbmfB0SkpVVlrWNmUyx5iiOQ9oRi3pIZcQgqhVTrBaRFfVY
	c2ZfTqqfz0QXqQcWy9m5DWFGKexO/hbfo7YoE/K2/xJlCJmrGa+HRMlbwEFVjDkERLM0c18hYKq
	2/AC2lDAhTwwccN2Qlcz1crWRuoOksCW9rtEm1r6H8ZUE/mjpLziwBl6MHtquGafpjyCWDHRncv
	ykXGCQWFqNPUqfZC6Pla0NGS0jAaQ+UopKVctndLvg9kSz6eqBz8tcuKqvMTAGIMdJIBF3em77G
	XIDUOEofjrDp2XvI6pTyNVipnKi+qqz/Y9+SvDswfpWZeZ+MMRThR+u+xQJS6w0HELGdaXwTGnL
	khLBP4g8vXcdD3aqy5IHw1H5OHJ8k4+C628aSkASpxFK2io9v4GSHG2gaVIRNyEAYvU/sODgoVH
	CZvBl3ltrkPC5CLSJRLHy0G6b+dfWeXj998uH0uV48To0KBmYpmF5wO/nYZQEqF0mrDz1IEPVvE
	CIHE4M2V6tcYDn0YvrdqXK9RciT1lDgOW+4tIKAn0AsUhAe6I91GC7nzoGm9W8gSkg==
X-Received: by 2002:a17:907:a890:b0:c41:55b4:d88b with SMTP id a640c23a62f3a-c513ab14402mr338807466b.43.1795180728386;
        Fri, 20 Nov 2026 05:18:48 -0800 (PST)
Received: from [10.0.0.233] (tmo-084-188.customers.d1-online.com. [80.187.84.188])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513acfe3b0sm93731066b.8.2026.11.20.05.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:18:47 -0800 (PST)
Message-ID: <e376c8f0ec5c50b417375197a5589a210f151d9b.camel@amutable.com>
Subject: Re: [RFC PATCH v4 03/14] rootns: Track init lifecycle via
 copy_process() and pid_namespace
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>,  Andreas
 Larsson <andreas@gaisler.com>, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski	 <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
 Anna-Maria Behnsen	 <anna-maria@linutronix.de>, Arnd Bergmann
 <arnd@arndb.de>, Ben Segall	 <bsegall@google.com>, Borislav Petkov
 <bp@alien8.de>, Casey Schaufler	 <casey@schaufler-ca.com>, Catalin Marinas
 <catalin.marinas@arm.com>,  Christian Borntraeger
 <borntraeger@linux.ibm.com>, Christian Brauner <brauner@kernel.org>,
 "Christophe Leroy (CS GROUP)"	 <chleroy@kernel.org>, Chris Zankel
 <chris@zankel.net>, Dave Hansen	 <dave.hansen@linux.intel.com>, David
 Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>,
 Davidlohr Bueso <dave@stgolabs.net>, "David S. Miller"	
 <davem@davemloft.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Frederic Weisbecker <frederic@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, "Hallgrimur H. Gunnarsson"	 <halg@google.com>,
 Heiko Carstens <hca@linux.ibm.com>, Helge Deller	 <deller@gmx.de>, "H.
 Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,  "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Jan Kara
 <jack@suse.cz>, John Johansen	 <john.johansen@canonical.com>, John Paul
 Adrian Glaubitz	 <glaubitz@physik.fu-berlin.de>, Jonathan Corbet
 <corbet@lwn.net>, Josef Bacik	 <josef@toxicpanda.com>, Juri Lelli
 <juri.lelli@redhat.com>, Kees Cook	 <kees@kernel.org>, K Prateek Nayak
 <kprateek.nayak@amd.com>, "Liam R. Howlett"	 <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Madhavan Srinivasan	 <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Manfred Spraul	
 <manfred@colorfullife.com>, Mark Rutland <mark.rutland@arm.com>, Matt
 Turner	 <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>, Mel Gorman
	 <mgorman@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko	
 <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>, Mike Rapoport	
 <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, Nicholas Piggin	
 <npiggin@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Moore	
 <paul@paul-moore.com>, Paul Walmsley <pjw@kernel.org>, Pavel Tikhomirov	
 <ptikhomirov@virtuozzo.com>, Peter Zijlstra <peterz@infradead.org>, Randy
 Dunlap <rdunlap@infradead.org>, Richard Henderson
 <richard.henderson@linaro.org>, Rich Felker	 <dalias@libc.org>, "Ritesh
 Harjani (IBM)" <ritesh.list@gmail.com>, Russell King	
 <linux@armlinux.org.uk>, Serge Hallyn <sergeh@kernel.org>, Shrikanth Hegde	
 <sshegde@linux.ibm.com>, Shuah Khan <skhan@linuxfoundation.org>, Steven
 Rostedt	 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Sven Schnelle	 <svens@linux.ibm.com>, Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>,  Thomas Gleixner	 <tglx@kernel.org>, Valentin
 Schneider <vschneid@redhat.com>, Vasily Gorbik	 <gor@linux.ibm.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Vlastimil Babka <vbabka@kernel.org>, Will
 Deacon	 <will@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Date: Fri, 20 Nov 2026 14:18:43 +0100
In-Reply-To: <20261119224312.1037966-4-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
	 <20261119224312.1037966-4-jarkko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-11-20 at 00:43 +0200, Jarkko Sakkinen wrote:
> A root namespace needs to record its init thread group's PID when
> bootstrapped and capture its exit status once all processes in the
> root
> namespace have terminated, without serializing normal fork() and
> exit()
> paths inside the container.
>=20
> Commit the bootstrap child reaper, bind pid_ns->rootns, and wake
> waiters
> in copy_rootns() after attach_pid(PIDTYPE_PID), and invoke
> exit_rootns()
> from zap_pid_ns_processes() after the root namespace's PID namespace
> has
> killed and reaped all member tasks.
>=20
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> =C2=A0include/linux/pid_namespace.h |=C2=A0 4 ++++
> =C2=A0include/linux/rootns.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
15 ++++++++++++++
> =C2=A0kernel/fork.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3 +++
> =C2=A0kernel/pid_namespace.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
=C2=A0 2 ++
> =C2=A0kernel/rootns.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 38
> +++++++++++++++++++++++++++++++++++
> =C2=A05 files changed, 62 insertions(+)
>=20
> diff --git a/include/linux/pid_namespace.h
> b/include/linux/pid_namespace.h
> index b20baaa7e62b..6fd959f4d0d4 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -15,6 +15,7 @@
> =C2=A0#define MAX_PID_NS_LEVEL 32
> =C2=A0
> =C2=A0struct fs_pin;
> +struct rootns;
> =C2=A0
> =C2=A0#if defined(CONFIG_SYSCTL) && defined(CONFIG_MEMFD_CREATE)
> =C2=A0/* modes for vm.memfd_noexec sysctl */
> @@ -45,6 +46,9 @@ struct pid_namespace {
> =C2=A0	struct user_namespace *user_ns;
> =C2=A0	struct ucounts *ucounts;
> =C2=A0	int reboot;	/* group exit code if this pidns was
> rebooted */
> +#ifdef CONFIG_ROOTNS
> +	struct rootns *rootns;
> +#endif
> =C2=A0	struct ns_common ns;
> =C2=A0	struct work_struct	work;
> =C2=A0} __randomize_layout;
> diff --git a/include/linux/rootns.h b/include/linux/rootns.h
> index 3f59415efadb..0557ce75195d 100644
> --- a/include/linux/rootns.h
> +++ b/include/linux/rootns.h
> @@ -13,6 +13,8 @@
> =C2=A0struct file;
> =C2=A0struct nsproxy;
> =C2=A0struct pid;
> +struct pid_namespace;
> +struct task_struct;
> =C2=A0struct user_namespace;
> =C2=A0
> =C2=A0enum rootns_state {
> @@ -41,6 +43,9 @@ struct rootns {
> =C2=A0struct rootns *get_rootns(struct rootns *c);
> =C2=A0void put_rootns(struct rootns *c);
> =C2=A0bool is_rootns_file(struct file *file);
> +void copy_rootns(struct task_struct *tsk, struct pid *pid,
> +		 struct rootns *rootns);
> +void exit_rootns(struct pid_namespace *pid_ns, struct task_struct
> *tsk);
> =C2=A0#else
> =C2=A0static inline struct rootns *get_rootns(struct rootns *c)
> =C2=A0{
> @@ -55,6 +60,16 @@ static inline bool is_rootns_file(struct file
> *file)
> =C2=A0{
> =C2=A0	return false;
> =C2=A0}
> +
> +static inline void copy_rootns(struct task_struct *tsk, struct pid
> *pid,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct rootns *rootns)
> +{
> +}
> +
> +static inline void exit_rootns(struct pid_namespace *pid_ns,
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct task_struct *tsk)
> +{
> +}
> =C2=A0#endif /* CONFIG_ROOTNS */
> =C2=A0
> =C2=A0#endif /* _LINUX_ROOTNS_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a7..08fc28ad1eed 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -83,6 +83,7 @@
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/perf_event.h>
> +#include <linux/rootns.h>
> =C2=A0#include <linux/posix-timers.h>
> =C2=A0#include <linux/user-return-notifier.h>
> =C2=A0#include <linux/oom.h>
> @@ -2576,6 +2577,8 @@ __latent_entropy struct task_struct
> *copy_process(
> =C2=A0					=C2=A0 &p->signal->thread_head);
> =C2=A0		}
> =C2=A0		attach_pid(p, PIDTYPE_PID);
> +		if (thread_group_leader(p))
> +			copy_rootns(p, pid, NULL);
> =C2=A0		nr_threads++;
> =C2=A0	}
> =C2=A0	total_forks++;
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 127a5fd23e70..081c27aa85bd 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -24,6 +24,7 @@
> =C2=A0#include <linux/sched/signal.h>
> =C2=A0#include <linux/idr.h>
> =C2=A0#include <linux/nstree.h>
> +#include <linux/rootns.h>
> =C2=A0#include <uapi/linux/wait.h>
> =C2=A0#include "pid_sysctl.h"
> =C2=A0
> @@ -280,6 +281,7 @@ void zap_pid_ns_processes(struct pid_namespace
> *pid_ns)
> =C2=A0		current->signal->group_exit_code =3D pid_ns->reboot;
> =C2=A0

Dear Jarkko,

> =C2=A0	acct_exit_ns(pid_ns);
> +	exit_rootns(pid_ns, me);

We have a very similar mechanism around pidfd's to track exit
information for a task. As far as I can see we already have (struct
rootns *)->init_pid reference, so we can get exit information for free
(look for PIDFD_INFO_EXIT).

Kind regards,
Alex

> =C2=A0	return;
> =C2=A0}
> =C2=A0
> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 3bbf7677080e..bde7cf4baebe 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -183,3 +183,41 @@ bool is_rootns_file(struct file *file)
> =C2=A0{
> =C2=A0	return file->f_op =3D=3D &rootns_fops;
> =C2=A0}
> +
> +void copy_rootns(struct task_struct *tsk, struct pid *pid, struct
> rootns *c)
> +{
> +	if (likely(!c || !is_child_reaper(pid)))
> +		return;
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		if (c->state !=3D ROOTNS_FORKING)
> +			return;
> +		ns_of_pid(pid)->rootns =3D get_rootns(c);
> +		WRITE_ONCE(c->init_pid, get_pid(pid));
> +		WRITE_ONCE(c->state, ROOTNS_RUNNING);
> +	}
> +	wake_up_all(&c->waitq);
> +}
> +
> +void exit_rootns(struct pid_namespace *pid_ns, struct task_struct
> *tsk)
> +{
> +	struct rootns *c =3D pid_ns->rootns;
> +	struct task_struct *leader;
> +	int status;
> +
> +	if (!c)
> +		return;
> +
> +	leader =3D tsk->group_leader;
> +	status =3D (tsk->signal->flags & SIGNAL_GROUP_EXIT) ?
> +		 tsk->signal->group_exit_code : leader->exit_code;
> +
> +	scoped_guard(spinlock, &c->lock) {
> +		c->exit_code =3D status;
> +		WRITE_ONCE(c->state, ROOTNS_DEAD);
> +	}
> +
> +	pid_ns->rootns =3D NULL;
> +	wake_up_poll(&c->waitq, EPOLLHUP);
> +	put_rootns(c);
> +}
