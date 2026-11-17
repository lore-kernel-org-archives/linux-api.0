Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794957293;
	b=Sa4t44jnrpiJvvolGQggG3HfCKkCG7SizlcEpMxEXvHcBJ0nL1bguxatT3Ubf2jBs02f
	 QIB36TX34kDboUnlAS5YdyRCKrAeCBoQc3Tziu+eFK8NMpUoCSa7C6qeoP/EtjAuIjsJY
	 DV9z35wBvdotK5tlx6OBzFiqFwc7v9Mi5DnXx/wRovXrvS2eFTfQBnVhh5tUjFrW2X17U
	 Fx6LkOnXq2bHFhHTZIz2Spltr1ILE45Q+wmtNV36VBlTw7sWDjba+LYQ1r+jz9tfVy+dE
	 K2xuc/F3f19/dy+lY1Xqx2YD44gBsXN1H21jKplvhtK7uJ/Pk+oAm97D0CR2sQVUIuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794957293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CiMfC8WxBlUbYWytaJ1DOt79UawEGEAXEtAPiyGHVrA=;
	b=wFyq4aSI+hQiQw6oeoE8pYAgtutx+RiQMj98GYfG+C2r9Osq9yKi8fuKnIYbXsNWzQkZ
	 B2gOYVICOsNr3dcMXgaHgvMIENcZ7k/UwUzlCCZmWFAw6k3hMPrp12NzrKZNO5wAaw7Fl
	 1bcsWGQbgdatmcUJ2N4cVRCf4ZK3joELBYSBb0Td9cpDXzZ95K5bgwy+MIr7gxpW3QZRu
	 4pIsrLJyap/8PJiSpw8w7sL59bspzNPqxQdNV6P7lllmAIVhQ2JIYL/la8efeMUhgtQDJ
	 z1fI8N4rOMIFVcURsq9CalJIzxJ10NmPe9Hhh7wEf9oDg05Z3Bna2Ifwy5G3lPU8Htw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=obv9eQjp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8DFF4606A333;
	Tue, 17 Nov 2026 23:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=obv9eQjp
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9F7131F000CA;
	Tue, 17 Nov 2026 23:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957293;
	bh=CiMfC8WxBlUbYWytaJ1DOt79UawEGEAXEtAPiyGHVrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=obv9eQjpBu2XlVQo5Y/t+VKK7Ro9uJlqNt3aW/t9KyS7o2vo5BqDhS2zq1sbQpqMW
	 r5ofIesgTcSu2dr2azXda2SqWaX0YVuyeKlxlz1g0djzEsNLG8KaKnv5E2nktmxTxK
	 kOjurxnHrQroLbRJ//FllbJ/1N598SSRV7KV1IUx9P+MC1HoUUJvyT9S+Wn/7Tv6CX
	 gfNzgQE1wyeI9a0xSPW8/rjsaVtAMpby4zq349GOd09NjPzz8h7LUM1O4K9TOCWk0n
	 9UxevL+PACtYmaKICzIvr2Ftw8XLfVLUEeQLzxUN3bqb7m5WUDA+IYs1c6z8axEVM0
	 jFTa41POnFgZw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 11/13] docs: Document root namespace uAPI
Date: Wed, 18 Nov 2026 01:13:50 +0200
Message-ID: <20261117231352.3816603-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace container managers need a clear specification of rootns state
transitions, mount-tree construction, credential rules, and process
creation semantics.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections and system call reference from kernel/rootns.c,
include/uapi/linux/rootns.h, fs/fsopen.c, and fs/namespace.c.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst  |  1 +
 Documentation/userspace-api/rootns.rst | 40 ++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)
 create mode 100644 Documentation/userspace-api/rootns.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a8..56d0ac4eb087 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -17,6 +17,7 @@ System calls
    :maxdepth: 1
 
    unshare
+   rootns
    futex2
    ebpf/index
    ioctl/index
diff --git a/Documentation/userspace-api/rootns.rst b/Documentation/userspace-api/rootns.rst
new file mode 100644
index 000000000000..46b40f5fb29b
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,40 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================
+Root namespace uAPI
+===================
+
+Overview
+========
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: Overview
+
+Flags
+=====
+
+.. kernel-doc:: include/uapi/linux/rootns.h
+
+System calls
+============
+
+.. kernel-doc:: kernel/rootns.c
+   :identifiers: sys_rootns_create sys_rootns_wait sys_rootns_kill
+
+Process creation
+================
+
+.. kernel-doc:: kernel/rootns.c
+   :doc: CLONE_INTO_ROOTNS
+
+Filesystem configuration
+========================
+
+.. kernel-doc:: fs/fsopen.c
+   :doc: FSCONFIG_SET_ROOTNS
+
+Mount tree installation
+=======================
+
+.. kernel-doc:: fs/namespace.c
+   :doc: MOVE_MOUNT_T_ROOTNS_ROOT
-- 
2.47.3

