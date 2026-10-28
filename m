Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200681;
	b=0U8qIBdi6Eb6DjpYGa798dfJdwNNvrEsF69glVyWWycnlUaKAS64+8tmr+DQXduFJiTH
	 cJieWuEUAP7lDYPLkaN+YCTUbbdjUQxHf/qpedwdN4wzCra7Sb/VC65C0aDjvdRUfHd37
	 soDQSs5Qh5OWQt368Z6FTypNXPFR2VI/g50q0ou1ysgcuutqBLQA1boaoha7+Ozd8Okgr
	 L5wBerlJHe+hbwZ7qnRyitwaA0WZ26unQOPp+4I67Nm/ERbAOAh1KQywO//z3ic0Pl5gB
	 7PhvHoFUa3Xw/PNNReCwdTOs36yKOvRosynCFHDJqkPyWovbv6QH8C9u2GGlvfjggbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200681;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=eVF1QZUf7yAkTLXbOCxlRmuE+fwmhZLgRT3c0pAYLpo=;
	b=mKQGl7+fzE8Ag9RNXUB5RZ+AkGwWF54ZXk9HEk1vXkOMddiTBYjKCniWhY5+4cbsmZrK
	 MK3VjSM0c1twYbpxeSZJmrR/aQrSIX5xmzZnFFAgmL1W0dcwzenR/XE6gmVrZTQJwGg0c
	 qRFHuFZvz8a76w+aA13fea4TfqEhjuANfsT/POcDI4t+VQgZYzhHEHTDlZAO2c5672Uys
	 TMQYXmAPCiyxkXwi+KYc11bqsOkRFObhsbOkeQSj4xniSuCqK61qqm+F/2jJaQIrW23QY
	 5p8cSBqbuwOVLhv+Fi5SvxtoBISGsy7MVaSOnpU4XxPpKWOkVnCDYtYnatGeYDglL5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I2OPX1PF;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11CF606A31A
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:17:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F11CF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I2OPX1PF
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so9892785e9.2
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 08:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793200678; x=1793805478; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eVF1QZUf7yAkTLXbOCxlRmuE+fwmhZLgRT3c0pAYLpo=;
        b=I2OPX1PF8PLaxhUlmHu9h2D0nhYLPHwI5zlfB7Lci4EblI06BEbpfx5OgZ2rqE1J5E
         7L848K8CGF4P+jK7xu6I5UqBRnCrJhDH3TwdWWPK0hVYUFs0k/av5uWyGm3LaLmoiS0l
         /pZC0drqZoLo6fKtdVVMM+Ksu3iSDBgTuNkq3R7oL4xgFPB2l+6ru0DQtuLNOoEQlQ//
         Y+0EdCVuFzJqxdsGUURYxgYxvmiSXwO+4FAKD+oOtejdGv+0YUKo1EHeJg+UZ+xsegEF
         fV7cBRRqfeZVliNudhQJW2vRQwMtBFAYNELVpxZHQptzCYaHR480MdIUQdkyocnatCH/
         w6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793200678; x=1793805478;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eVF1QZUf7yAkTLXbOCxlRmuE+fwmhZLgRT3c0pAYLpo=;
        b=sCwhk7SvhNSRtIrx8dBdv9bshskOEkCqf58IgoBiBmBSdQJe/a5pkXSL8HF0xgB1Ma
         ICzFNIJ60WoULhHjjgB/f1kUyAeHBUUOgf0xwh3vcDab7D3xGwMTdcAMYsE1sMXI2uBP
         E4e657TcUPi/1DliV7x6bHZ1fW4zjKJTGA43vkApC+Qb7HxJydWkIH/Fjew2qgSruqTM
         Mqb0BisnCgcchvl0SUb8PGhjU2+F4qJN44aK80fgOuGXnQLR5v8R+jKVCo/Fl2EgcW58
         GRPCWALGLP1jPiDOD+ZmJB9tWgKrma8N3dODq4bBW6CzaTdmSDLmUbLTvTLfhovaoE9X
         jOqA==
X-Forwarded-Encrypted: i=1; AKwUvBz/Ccjbcdp5uKddFlAXScrN0sOZehUQb+nyngtAoAt7lOZ2cKfa4MBxS9Bj7r+HR17Ki54VhhPEuzQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYLMa31T3ZYww63CazTsl63TXn0pzCHkp7BerXRRlvRM2AeZ1KA7
	iY3KhLAdv0no2/y3vHuomcfccluBpVY/8gk0s7gu4tY18Lm9/msLMamR
X-Gm-Gg: AYBFou0vRCmyribSZdeeQM+j3zlitZQZG5J57bhiPqmdTQU4jucmLhpUj90R7AdHSR1
	kOGYCHEwzYcbjKuCnbRKv9Lg2i5Stx3GVsiEu/p58q8QAWfkTeYErw5W7DfvgZ29UJ/ac3KUCZT
	xP961gTwBjTRtnfQyBpe0VlR/3pT4HnYayOr+zL6zJAOREP0jkz+M8Z5r92q/FGFpg7k1P59why
	NamKxuJuMoVJVwvRODwy7ygcpScIESp5inE/E9BdT4drdXFNaSqDHCA9woc+AFttCmMa/K3/xyX
	oy1l02t0d60GidkRuE+mXfowpbkvIcsPwSobHD8RsetboQ+W3ovhNuQOSnsNFcISKUZa0CIIZe3
	yj5rO+Ct0IKVb2/tViuDN/GwbyaHbsyBxyM/NQXmSSI4PhJsQBbS+CnshjOMz4U5pq2zPPPv3sx
	IMscw2DrYNKt+J+hIIaVwIxssvRPXNmUkZofbk2AqZhZJLkQqaJIdDfd4zoN420zAL6KxMYABde
	ROnIvb4AqqpnEiN82xUIScUXGlQx0OmaZ0nJXZpi4qYzCGEk9UgPAmC2pbmLmy5YRcGiClHaEgm
	YXzbWycAIj8c6oTfOoVE8mD/zaYe/tctLq9xhYuRY0U5EXXenXKi8w==
X-Received: by 2002:a05:600c:4e8b:b0:4a5:ef46:1603 with SMTP id 5b1f17b1804b1-4a967202660mr65444905e9.30.1793200677991;
        Wed, 28 Oct 2026 08:17:57 -0700 (PDT)
Received: from localhost (ip87-106-108-193.pbiaas.com. [87.106.108.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a978795f4dsm44632965e9.9.2026.10.28.08.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:17:56 -0700 (PDT)
Date: Wed, 28 Oct 2026 16:17:51 +0100
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Ketan Bhardwaj <ketan@armoriq.io>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	linux-security-module@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
	linux-api@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	linux-kernel@vger.kernel.org,
	"HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
Subject: Re: [RFC PATCH v2 1/6] docs: security: Describe the Kernel Assurance
 Plane design
Message-ID: <20261028.ecf3e62c6cf5@gnoack.org>
References: <20261028133335.75899-1-ketan@armoriq.io>
 <20261028133335.75899-2-ketan@armoriq.io>
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
In-Reply-To: <20261028133335.75899-2-ketan@armoriq.io>

Hello!

On Wed, Oct 28, 2026 at 09:33:30AM -0400, Ketan Bhardwaj wrote:
> Describe the Kernel Assurance Plane (KAP) design.
> 
> Agents and other long-running tasks act on behalf of an objective that a
> user approved. Linux decides whether a task may perform an operation,
> but not whether the operation still belongs to that objective. Seccomp,
> LSM profiles, namespaces and cgroups cannot hold several objectives apart
> inside one environment, or revoke one objective's authority while its
> task runs.
> 
> KAP introduces objective-scoped authority as a kernel subsystem. The
> document covers Intent Lineage Groups, the authority model and the
> control plane under /sys/kernel/security/kap, where igroups are created
> with mkdir as cgroups are. For each design decision it lists the
> alternatives considered, and it ends with the questions on which
> maintainer feedback is wanted.
> 
> Assisted-by: Claude
> Co-developed-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
> Signed-off-by: HARIHARA SUDHAN. R <harisudhan@armoriq.io>
> Assisted-by: Codex
> Signed-off-by: Ketan Bhardwaj <ketan@armoriq.io>
> ---
>  Documentation/ABI/testing/securityfs-kap | 111 +++++++++++
>  Documentation/security/index.rst         |   1 +
>  Documentation/security/kap.rst           | 236 +++++++++++++++++++++++
>  3 files changed, 348 insertions(+)
>  create mode 100644 Documentation/ABI/testing/securityfs-kap
>  create mode 100644 Documentation/security/kap.rst
> 
> diff --git a/Documentation/ABI/testing/securityfs-kap b/Documentation/ABI/testing/securityfs-kap
> new file mode 100644
> index 0000000..066de0b
> --- /dev/null
> +++ b/Documentation/ABI/testing/securityfs-kap
> @@ -0,0 +1,111 @@
> +What:		/sys/kernel/security/kap/
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Kernel Assurance Plane control directory in securityfs.
> +		The ABI is experimental and intended for RFC review.
> +
> +What:		/sys/kernel/security/kap/kap.default
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read or write "open" or "closed". When closed, a task
> +		outside the initial PID namespace that is bound to no igroup
> +		cannot start a program.
> +
> +What:		/sys/kernel/security/kap/igroups/
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Directory of Intent Lineage Groups. Create an igroup with
> +		mkdir, as a cgroup is created.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.install
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Write the lineage root, authority epoch, optional expiry and
> +		transition, and the authority as one key=value document in a
> +		single write. The fields commit together or not at all.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.procs
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Write a pid to bind that process, with all of its threads,
> +		to the igroup. Reads return the pids written.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.lineage_root
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read or write the opaque lineage root for the igroup.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.authority_epoch
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read or write the current authority epoch. A lower value is
> +		refused, and a write clears revoked mode. Bound tasks whose
> +		recorded epoch is stale fail KAP checks closed.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.authority
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read or write the authority document for the igroup, in a
> +		strict subset of JSON, with a "predicates" array, each predicate having a
> +		"kind" and "allow" and "deny" arrays of patterns. The
> +		Kernel Assurance Plane design document lists the kinds and
> +		how patterns match.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.expires_at
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read or write the authority expiry in seconds since the Unix
> +		epoch, or 0 for none. An expiry already in the past is
> +		refused. Once it passes, every check for the igroup fails
> +		closed.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.transition
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Write a transition record whose sequence number is higher
> +		than the last one, to prevent replay. Reads return the last
> +		sequence number.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.mode
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read or write igroup mode. Supported values are "enforce" and
> +		"revoked". A revoked igroup refuses every operation.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.events
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read recent KAP decisions as JSON lines with the fields
> +		ts_ns, igroup, decision, operation, target, reason, epoch,
> +		root and pid.
> +
> +What:		/sys/kernel/security/kap/igroups/<igroup>/kap.igfd
> +Date:		October 2026
> +KernelVersion:	RFC
> +Contact:	Ketan Bhardwaj <ketan@armoriq.io>
> +Description:
> +		Read the igroup's name, epoch and lineage root on one line.
> diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
> index 00650dc..937193b 100644
> --- a/Documentation/security/index.rst
> +++ b/Documentation/security/index.rst
> @@ -18,6 +18,7 @@ Security Documentation
>     siphash
>     tpm/index
>     digsig
> +   kap
>     landlock
>     secrets/index
>     ipe
> diff --git a/Documentation/security/kap.rst b/Documentation/security/kap.rst
> new file mode 100644
> index 0000000..22c2729
> --- /dev/null
> +++ b/Documentation/security/kap.rst
> @@ -0,0 +1,236 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +======================
> +Kernel Assurance Plane
> +======================
> +
> +Kernel Assurance Plane (KAP) introduces objective-scoped authority as a kernel
> +subsystem. Intent Lineage Groups (igroups) are its core kernel object, LSM hooks
> +are its enforcement mechanism, and securityfs is its control-plane interface.
> +
> +This document describes the design for review. It lists the alternatives that
> +were considered for each decision and the questions on which maintainer feedback
> +is wanted.
> +
> +Motivation
> +==========
> +
> +A task increasingly runs on behalf of an objective that a user approved, for
> +example an AI agent asked to fix a failing test. Over hours it starts programs,
> +reads and writes files and opens connections. Linux decides whether the task
> +may perform each operation. It does not decide whether the operation still
> +belongs to the objective the task was started for.
> +
> +Existing mechanisms cover parts of this. Seccomp filters syscalls but cannot see
> +paths or objectives. LSM profiles, such as AppArmor or SELinux, are attached to
> +programs or labels, not to an objective, and cannot be narrowed for one task
> +while it runs.

Can you please also set apart how it is conceptually different to
Landlock?

Landlock can see paths (unlike Seccomp), and Landlock policies
(rulesets) are defined and enforced by unprivileged processes through
its userspace API.  It is already a popular choice for AI agent
sandboxing and orchestration frameworks.

What is missing in Landlock which does not make it usable for your use
case?

(Obviously, there are missing features that people would want in
Landlock, but that's an argument that doesn't count IMHO, since it's
still easier to add these features to Landlock than to create a new
separate LSM.)


> +Namespaces and cgroups partition resources rather than
> +authority. None of them lets several objectives run in one environment, each
> +held to its own authority, or fails a task closed the moment its authority is
> +revoked.
> +
> +Model
> +=====
> +
> +``igroup``
> +  Intent Lineage Group, the unit KAP enforces. An igroup owns an authority
> +  snapshot, a lineage root, the current epoch, an optional expiry, a transition
> +  sequence, its bound tasks and an event log. A process is bound by writing its
> +  pid to the igroup, which binds all of its threads. Children inherit the
> +  binding, and it is kept across exec and setns.
> +
> +``authority snapshot``
> +  The predicate set for one igroup epoch, with typed ``allow`` and ``deny``
> +  arrays for exec, file, network connect, credential, IPC, namespace,
> +  descriptor, procfs, executable memory, BPF, ptrace and io_uring checks. File
> +  predicates also govern rename, link, unlink, mkdir, rmdir, mknod, symlink and
> +  truncate, so a file cannot be moved into a denied path. A deny wins over an
> +  allow, and an operation no predicate allows is refused. The snapshot is
> +  compiled once when it is installed.
> +
> +  In this RFC the snapshot is a document in a strict subset of JSON, with no
> +  whitespace around the ``"predicates"`` and ``"kind"`` keys and no escaped
> +  quotes::
> +
> +    {"predicates":[{"kind":"file","allow":["/srv/work"],"deny":["/srv/work/keys"]},
> +                   {"kind":"exec","allow":["/usr/bin/*"],"deny":[]}]}
> +
> +  The kinds are ``exec``, ``file``, ``net``, ``cred``, ``ipc``, ``namespace``,
> +  ``descriptor``, ``procfs``, ``execmem``, ``bpf``, ``ptrace`` and
> +  ``io_uring``. File, descriptor and procfs patterns match a path and
> +  everything below it. Other patterns match exactly, or by prefix when they
> +  end in ``*``. A program is allowed by the path it resolves to, and refused
> +  by a deny on either that path or the name it was started with.
> +
> +  Each kind is matched against a target string:
> +
> +  * ``exec``, ``file``, ``descriptor``, ``procfs``: a path. A rename, link or
> +    other path operation is checked as its parent directory plus its name.

It's unclear to me why procfs is not covered with "file", since you
are already doing path-based matching.  What operations are restricted
by "descriptor" is also unclear to me.

> +  * ``execmem``: the path of the mapped file, or ``anonymous``.
> +  * ``net``: the destination address and port, as in ``192.0.2.1:443``, or
> +    ``family:N`` for an address family other than IPv4 and IPv6. A connect
> +    with ``AF_UNSPEC`` is not checked; ``AF_UNIX`` is checked as ``ipc``.
> +  * ``cred``: ``uid=U,euid=U,suid=U,fsuid=U``, ``gid=G,egid=G,sgid=G,fsgid=G``,
> +    ``groups`` or ``capset``.
> +  * ``ipc``: ``unix:stream_connect``, ``unix:may_send`` or ``sysv:flag=N``.

FWIW since pathname Unix Domain Socket are also addressed by path, we
found it useful to express the rules about them with paths as well, in
Landlock.

In networking and IPC, I am a bit missing how that would work when
*offering* a service (listen(), bind()).  Do you have thoughts on
that?

What is `sysv:flag=N`?  You might be interested in the discussion we
had at [1] -- I found System V IPC tricky to restrict, because many of
its integer identifiers are not FD-like handles, but just live fully
accessible to the entire IPC namespace.

[1] https://lore.kernel.org/all/20260727230833.138165-1-utilityemal77@gmail.com/

> +  * ``namespace``: ``TYPE:OPERATION`` for clone, unshare and setns, where
> +    TYPE is ``mount``, ``pid``, ``net``, ``user``, ``uts``, ``ipc``,
> +    ``cgroup`` or ``time``; ``user`` for creating a user namespace; and
> +    ``mount:mount:FSTYPE:PATH``, ``mount:umount:PATH``,
> +    ``mount:pivotroot:OLD:NEW`` and ``mount:move:FROM:TO`` for mounts.
> +  * ``ptrace``: ``same-igroup``, ``igroup=NAME`` or ``unconfined``, for the
> +    other task.
> +  * ``bpf``: ``cmd=N``, with ``map_type=N`` or ``prog_type=N`` when creating
> +    a map or loading a program.
> +  * ``io_uring``: ``override_creds``, ``sqpoll`` or ``uring_cmd``.

Can it be turned off as well?


> +``epoch``
> +  Monotonic authority generation. Installing a higher epoch fails every task
> +  still bound to an older one closed from its next check.
> +
> +``lineage root``
> +  Opaque identifier supplied by userspace that ties the installed authority to
> +  a committed execution lineage.
> +
> +The kernel does not parse planning or policy languages. A privileged userspace
> +runtime validates those artifacts and installs kernel-ready state. Tasks that
> +are bound to no igroup are not checked, except for the exec check that
> +``kap.default`` enables.
> +
> +Control plane
> +=============
> +
> +KAP state lives under ``/sys/kernel/security/kap``::
> +
> +  /sys/kernel/security/kap/
> +    kap.default
> +    igroups/            created with mkdir, as cgroups are
> +      <igroup>/
> +        kap.install
> +        kap.procs
> +        kap.lineage_root
> +        kap.authority_epoch
> +        kap.authority
> +        kap.expires_at
> +        kap.transition
> +        kap.mode
> +        kap.events
> +        kap.igfd
> +
> +``kap.default``
> +  ``open`` (the default) or ``closed``. When closed, a task outside the initial
> +  PID namespace that is bound to no igroup cannot start a program, so a bind
> +  that failed cannot leave a workload running without authority.
> +
> +``kap.install``
> +  Write the lineage root, epoch, optional expiry and transition, and the
> +  authority as one ``key=value`` document in a single write. They commit
> +  together or not at all.
> +
> +``kap.procs``
> +  Write a pid to bind that process, with all of its threads, to the igroup.
> +  Reads return the pids written.
> +
> +``kap.lineage_root``, ``kap.authority``
> +  Read or write the lineage root or the authority document. A write to
> +  ``kap.authority`` is compiled before it replaces the current authority; a
> +  document that does not compile leaves it unchanged.
> +
> +``kap.authority_epoch``, ``kap.expires_at``
> +  Read or write the epoch, or the expiry in seconds since the Unix epoch (0 for
> +  none). A lower epoch, or an expiry already in the past, is refused. Writing
> +  an epoch, or installing authority, also clears revoked mode.
> +
> +``kap.transition``
> +  Write a transition record whose sequence number is higher than the last one.
> +  Reads return the last sequence number.
> +
> +``kap.mode``
> +  ``enforce`` or ``revoked``. A revoked igroup refuses every operation.
> +
> +``kap.events``
> +  Read recent decisions as JSON lines with the fields ``ts_ns``, ``igroup``,
> +  ``decision``, ``operation``, ``target``, ``reason``, ``epoch``, ``root``
> +  (the lineage root) and ``pid``.
> +
> +``kap.igfd``
> +  Read the igroup's name, epoch and lineage root on one line. The name is
> +  reserved for future igroup file descriptors.
> +
> +Design decisions
> +================
> +
> +Where the control plane lives
> +-----------------------------
> +
> +Igroups are created and destroyed by userspace, so the control plane needs
> +directories that userspace can create. securityfs does not allow userspace
> +mkdir.
> +
> +Considered:
> +
> +* A dedicated filesystem mounted at ``/sys/fs/kap``, the prototype's first
> +  interface. It works, but puts security state outside securityfs, where the
> +  other LSMs keep theirs.
> +* securityfs with control files, for example writing a name to a ``create`` file
> +  to make an igroup. This keeps everything in securityfs but replaces mkdir and
> +  rmdir with a private protocol that every tool has to learn.
> +
> +Chosen: a small internal filesystem that the kernel mounts itself and links
> +under securityfs, the approach AppArmor uses for policy namespaces
> +(``apparmorfs``, linked as ``/sys/kernel/security/apparmor/policy``). Users only
> +see paths under securityfs, and an igroup is created with mkdir, the way a
> +cgroup is.

You are creating policies through the file system, but you are at the
same time restricting access to the file system with these policies.
How does that work?

> +Igroups rather than a cgroup controller
> +---------------------------------------
> +
> +Considered: making KAP a cgroup controller, since igroups are created like
> +cgroups and follow the process tree.
> +
> +Chosen: a separate hierarchy. A container usually places all of its tasks in
> +one cgroup, while several objectives can run inside it, each needing its own
> +authority. Tying authority to resource partitioning would prevent that, and
> +authority must also follow setns, which cgroup membership does not.
> +
> +A static LSM rather than BPF LSM programs
> +-----------------------------------------
> +
> +Considered: implementing the checks as BPF LSM programs.
> +
> +Chosen: a built-in LSM. Igroup membership, epochs and inheritance across fork,
> +exec and setns are kernel object state with fixed semantics that reviewers can
> +audit in one place. BPF LSM also needs ``CONFIG_BPF_LSM`` and BTF, which many
> +minimal kernels do not enable.

I find both arguments unconvincing.  If it's a BPF program, you can
also audit it in one place - in the BPF program.  And the lobbying to
get CONFIG_BPF_LSM enabled in these kernels is probably not
substantially different than the lobbying to get CONFIG_KAP_LSM
enabled.

> +
> +Policy stays in userspace
> +-------------------------
> +
> +Considered: parsing a policy language in the kernel.
> +
> +Chosen: the kernel accepts only a compiled predicate snapshot. Planning,
> +policy validation and signature checks stay in privileged userspace, and the
> +snapshot is compiled into per-kind pattern sets once at install time.

I'm surprised that it's privileged, since existing AI agent software
tends to run unprivileged.  Who would be operating this and defining
the policies?  From your description I would have expected that the
"objectives" that inform the policies are roughly equivalent to the
goals that you give to the model in an agent prompt?  Does the agent
software communicate with a privileged agent?  Or does the agent
software spawn off namespaces to attain the necessary privileges?

More of a terminology remark, but when you consider the kernel layer
only, it feels like the compiled predicate snapshot *is* the policy
that you are enforcing?


> +Questions for maintainers
> +=========================
> +
> +1. Is an internal filesystem linked under securityfs, as AppArmor does,
> +   acceptable for a control plane that needs userspace mkdir?
> +2. Should igroup removal follow cgroups, with rmdir allowed once no task is
> +   bound?
> +3. Is a separate igroup hierarchy the right call, or should this be a cgroup
> +   controller despite the cases above?
> +4. The predicate format is a JSON document and experimental. Is a binary
> +   format preferred, or reuse of an existing ruleset format such as
> +   Landlock's?

I don't understand why the JSON format is a question for the kernel
review; you can do the interface in a format that is suitable for the
kernel, and translate from JSON into that format in userspace, not
mixing the layering between that userspace component and kernel space.


> +5. unshare and setns have no LSM hook, so the series calls KAP from them
> +   directly. Would a hook for namespace transitions be acceptable, or is there
> +   an existing one that should be used instead?

I believe we added such hooks for the Landlock namespace and
capability support.


> +6. The LSM ID is provisional and should be confirmed.
> +
> +RFC status
> +==========
> +
> +This interface is experimental. The RFC is intended to make the authority and
> +lineage model reviewable, not to freeze the userspace ABI.

I have to admit, I've read the doc, but still don't understand how
that model is supposed to work.  Do you maybe have a concrete
motivational example which defines such a policy and demonstrates why
that is different and can not implemented with one of the other LSMs
or the BPF-LSM instead?

–Günther
