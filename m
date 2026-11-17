Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892172;
	b=tzu+ycOve+HE5IxCNAlSAaSPnKSzAhm/DvL7Xc7YvAjaH0cxT27EKaV7fz1H5IOR58vd
	 /Eh/k/hkxzhQRlZbeqlxLq5tIamFBCCjLe/T1OmRkGQwyPukdaL1uigF8SQT98632Jb7q
	 9jzCAw337+RbcTzRsIy9i8rkvnUtCyNy4mG4mM/gfgqp0JuKH5fwCblvV9BNad1O6xkxU
	 vEiPMgWdX3SrqY8Myig+mNXUaARx4j/cyJqB25S9ZZNZlwtn4FhIhF5QK+uqlipU4TNgH
	 rsI2zhhO3LOcdJWbvFsWM5KIIJllZz2VT6zJtvdL5hI2pjCcIjpfAgfzmlmPFGSHrnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=T6eIobs5D9XmHWrYFhdj7cW0/x/RnlZNFsdojclJewE=;
	b=YRnNlHGQjfSs34/mtLvHzKBDvb9cyqa4voshefeMcXX/gdturqGVNsFvoLjl2ORdOO1h
	 CnllolnLiABC2JogATCtUfocVIsuhKOZSXhKUyxlexVoKJRaDhwB63+UFATmD+ExiUkdm
	 pb//kHd1DwzblDFZFHVWzBHHFWwIbvXbEZ8vyEoJkaBzRfnV+DHQF+URM8sWtRtFUxZ0y
	 EgZjnPSb/UG7YJH1pqgg7fYrzM2KXW+B6VeD2TMzG0li+IU5CXXucSs1FYpUdoon/KsG+
	 3V80JNCvKJJMgt2H40i9z9bIkWuOzi53fDtSatAAu76/C+Fk3fbe53ayeMdozRGh0OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eltAhv4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 783B5606A31C;
	Tue, 17 Nov 2026 05:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eltAhv4l
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 71EFC1F000C5;
	Tue, 17 Nov 2026 05:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892172;
	bh=T6eIobs5D9XmHWrYFhdj7cW0/x/RnlZNFsdojclJewE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eltAhv4lO1ELFXOfm97cs3eTtAy14zpxN7frA5zDTXljNuj4XDHZRC+HKOwcHYfZq
	 aPgKgW3mho2K57IVLnM3hZ1ogp5RNP1UdB5PuBBeaMJ70ENJxggJNl8RmRt3Qu/ZKR
	 YxN7DbLGmOwScWCab2mUCGewxHbkAe6k2mKsdo3IblwchimDILQDwD6xmjKpdfv0hl
	 sG2rcAPDonSz/l+efsK+nd4bG4cs1PoUswRJS0A8Ro4I8M1SOnRJGJR8tDlUOqsXr5
	 ioNt1Z77jisG+XdgfWf+tCd0OXKdpVTIIybUTE/rk2XCuTylFWSfBteeEVyCuev3hI
	 QRLJOxxlJRksg==
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
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 11/13] docs: Document root namespace uAPI
Date: Tue, 17 Nov 2026 07:08:39 +0200
Message-ID: <20261117050841.3289652-12-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
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
transitions, mount-tree construction, credential rules, and namespace
isolation guarantees.

Add Documentation/userspace-api/rootns.rst to include the kernel-doc
sections and system call reference from kernel/rootns.c,
include/uapi/linux/rootns.h, fs/fsopen.c, and fs/namespace.c.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 Documentation/userspace-api/index.rst  |  1 +
 Documentation/userspace-api/rootns.rst | 35 ++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)
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
index 000000000000..66c6dbc0e937
--- /dev/null
+++ b/Documentation/userspace-api/rootns.rst
@@ -0,0 +1,35 @@
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
+   :identifiers: sys_rootns_create sys_rootns_enter sys_rootns_wait
+                 sys_rootns_kill
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

