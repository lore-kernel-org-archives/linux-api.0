Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793225893;
	b=HH9bZcD2S1/1T4lIMUebJCrJu28cR5QtpFOIRA3xaBP9yNidOuOeIVrd2qB25w5mOQPT
	 uBG+ff+5Cum/vNU34hhnkWhzSHY8wfXYzNFLx/Gugt1ycl3rg7X6uLdDUsrqEXTZDX1XF
	 7/GDL9xDOZ34slyW2jkZPlEHjayzi72nBmdD8OtYcPpTJflPLdPYBwBOOb5EYMO4LZuGp
	 Y825jvGsQ+mJwAh6E4SyDfcwq9p0xoRjqdiqYvvwzoaswe1jbNCTS/maxxZFI0h5q7ONX
	 AQFhllpPU2fvGzczy7CL14QJqa1/1Psllfk5l5XGQDvlb4MyYEYC0YoGxwjpsMSmjuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793225893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=zdrXXSLELVsSwHMVPbcUtO/5ayyZxJyxQiN0TcFmn/A=;
	b=FnJg8gWiKwX16uOc6tbCQS2nUgtyw2+094IqY4euGfsOuk7Tn5wy0d5VEttGZuE+3iBK
	 txywg193g6BDDKIayV5xl74E5aqFnlNFJBfQd2+YIzAGWbGKyafbmyws3zteDq6QWJcnH
	 AvYcODcXccuSCCfAi3wndZy8jb0Ie5shoja3iqpYSkIJ20WrpNas6rnjHcuLBz7lBgW2l
	 ipudT5gbCQpNYvumX+gvCkpQs9f+nQwo17DQj0MVBl0ogxOtgZLTPWOsAkt4GLs75tqc1
	 AGtV9m0klpeuZaptF3h5N3yFiNCvfcJD0TtyRgNlh/CXCAW2d1UxJUTBIY5DH45VeFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--halg.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R0rY2M8Z;
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CC2606A31D
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 22:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59CC2606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--halg.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R0rY2M8Z
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e8c76334fso138082966b.1
        for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 15:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793225891; x=1793830691; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zdrXXSLELVsSwHMVPbcUtO/5ayyZxJyxQiN0TcFmn/A=;
        b=R0rY2M8ZBUpsVK5bvV77N25RxUNl/lUiEIl/l/IxVInBY6WYxjElllaIF5TS+q6dcU
         z0XpP3NNHCu9S89x/gTlWHBVP7dA9wWeYXTc0glEmrZPaKSnw3haEyProTm/RxyhTpeK
         bgJtiEw+QO4eJlE6D3wwySmvlU8Tg8ja0ActR9YXpRuTwOQRSDKukk9jzd1pAT0O/7jf
         GRxAUBTrmV4J3lwkf2Ay5hI5EI/MZtN14zKbwi3wSxtgUnXQSNSy/BenMyQTitov8cer
         jS1iH/9a990RSGgwDGJWTSCO26h5zi3DAFhRsB6P7SX8T1pnUzd5RmcSiJnQAh79zmm+
         naQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793225891; x=1793830691;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zdrXXSLELVsSwHMVPbcUtO/5ayyZxJyxQiN0TcFmn/A=;
        b=lkAUcCW/xY98170887ttex9LRICDcEr36HqjSUfXm8ju4G1B+GekXrlp7Ayylzue0I
         HIam06u3VnM/+y6I9AZC+WerEUrdX+9+5KYLR8sSm+MDc2AJgb0jhkL1Wit2FX/vsaES
         YvEdnbYfgXBg6ziYi+bUJbvcz7QGHhzeoIxubN0zmlYxlga+II2Fwi+YCVK3qPNNHGdC
         ZE4f+aYubY5WRg7MziOCPFM7VXG+6G//GcTJAEeQgBJzAHIDYDqsMgTMCaF4Aq4cwkoU
         PBmUXjXR+/+BSejHxNGK1D2DKcEpM2zQTbvw+fH38heUfTDif9J8SmgTYlws7BzyR7Uf
         /YRw==
X-Forwarded-Encrypted: i=1; AKwUvBz+npCWkZdgqU0dz+WTEt1KIM4pCYIYcRv6EMbMpuPYWh9qr2RBtbAPhTMH4C2strjiF+UBFvVzCzA=@vger.kernel.org
X-Gm-Message-State: AFq9FYJAMb1vTbDWl9jQ+6dbkQzRrDp1ihE3SDPoRR3eNon4tqnGYTRM
	A55/dH2t2Ro+3k5nXiFeOxefcEUBAJqNEAKmIwFZK0biiO7hutUASWAeq+VXO5vvwBXk0XnIpQ=
	=
X-Received: from educ16.prod.google.com ([2002:a05:6402:1010:b0:6b4:1882:2675])
 (user=halg job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:608e:b0:c46:8b87:c1f4
 with SMTP id a640c23a62f3a-c49bded259fmr314393966b.20.1793225890525; Wed, 28
 Oct 2026 15:18:10 -0700 (PDT)
Date: Wed, 28 Oct 2026 22:16:57 +0000
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261028221705.3915340-1-halg@google.com>
Subject: [PATCH 0/8] userns: per-namespace capability bounding set and opt-in
 netns loopback
From: "Hallgrimur H. Gunnarsson" <halg@google.com>
To: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Jan Kara <jack@suse.cz>, James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-api@vger.kernel.org, containers@lists.linux.dev, netdev@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Hallgrimur H. Gunnarsson" <halg@google.com>
Content-Type: text/plain; charset="UTF-8"

When an unprivileged process creates a new user namespace, it is granted
a full set of capabilities (CAP_FULL_SET) scoped to that namespace.
While these capabilities are isolated to the namespace, they allow
unprivileged local users to reach deep kernel subsystems (most notably
networking configuration and raw sockets via CAP_NET_ADMIN and
CAP_NET_RAW) that historically assumed a trusted caller and have
accounted for a large share of local privilege escalation
vulnerabilities.

Many workloads and sandboxes use unprivileged user namespaces strictly
for basic UID/GID, mount, PID, or network isolation and never need
high-risk capabilities like CAP_NET_ADMIN or CAP_NET_RAW. Likewise,
system administrators often want a host-wide policy ceiling restricting
which capabilities unprivileged user namespaces may acquire, without
disabling unprivileged user namespaces altogether.

Prior work by Jonathan Calmels [1] proposed addressing this via a sixth
per-thread capability set (cap_userns) alongside a global sysctl mask.
During that discussion [1, 2], feedback (e.g. from Casey Schaufler)
suggested that rather than adding another per-thread capability set and
prctl() interface, capability restrictions could be integrated directly
into struct user_namespace and configured via clone3(). At the same
time, as noted in [1], a clone3() flag alone is not sufficient for
administrators who need to enforce a host-wide ceiling on unprivileged
user namespaces without modifying every userspace callsite.

This series combines both pieces of feedback: it embeds a capability
bounding set (cap_bset) directly into struct user_namespace, reusing
the existing task cap_bset, cap_permitted, and cap_effective sets on
namespace entry, and provides both a system-wide sysctl ceiling for
unprivileged user namespaces and a CLONE_NEWUSER_BSET flag for
voluntary per-namespace restriction via clone3().

In addition, because restricting CAP_NET_ADMIN at user namespace
creation time prevents userspace from bringing up the loopback
interface in new network namespaces, the series first introduces
an opt-in flag to automatically enable loopback on network namespace
creation:

1. Opt-in loopback activation on netns creation (Patch 1)

  New network namespaces start with the loopback interface (lo) DOWN by
  default, requiring CAP_NET_ADMIN over the owning user namespace to
  bring it up. To block external network access while preserving
  localhost networking, sandboxes commonly create an isolated network
  namespace with only the loopback interface enabled.

  However, requiring a sandbox to hold CAP_NET_ADMIN in a new user
  namespace solely to bring loopback up conflicts with reducing the
  CAP_NET_ADMIN attack surface. Today, an unprivileged sandbox must
  start with CAP_NET_ADMIN to bring loopback up, drop it, and then
  block CAP_NET_ADMIN from being regained in nested user namespaces
  (e.g. via seccomp or max_user_namespaces limits). Conversely, when
  CAP_NET_ADMIN is restricted at user namespace creation time (via the
  sysctl ceiling or CLONE_NEWUSER_BSET introduced in Patches 2-3, or
  via LSMs such as Landlock), tasks inside the new namespace never
  acquire CAP_NET_ADMIN and cannot bring loopback up from userspace,
  breaking localhost networking for unprivileged sandboxes.

  Introduce the CLONE_NEWNET_LOOPBACK flag for clone3() and the
  corresponding UNSHARE_NEWNET_LOOPBACK flag for unshare(), which imply
  CLONE_NEWNET and automatically bring the loopback device up in
  copy_net_ns() before returning the new network namespace. Making this
  an explicit opt-in preserves default network namespace semantics
  while allowing unprivileged sandboxes to create an isolated network
  namespace with functional localhost networking without ever holding
  CAP_NET_ADMIN.

2. Per-user-namespace capability bounding set & sysctl ceiling (Patch 2)

  Add cap_bset to struct user_namespace (initialized to CAP_FULL_SET in
  init_user_ns) and introduce a system-wide sysctl ceiling for
  unprivileged users at:
    /proc/sys/kernel/unprivileged_userns_caps_allowed
  (defaulting to CAP_FULL_SET).

  When a new user namespace is created:
  - Privileged creators (holding CAP_SYS_ADMIN in the parent user
    namespace) inherit cap_bset from the parent user namespace.
  - Unprivileged creators (lacking CAP_SYS_ADMIN in the parent user
    namespace) have the child namespace's bounding set constrained by
    the sysctl ceiling combined with any effective capabilities the
    creator already holds in the parent namespace:
        child_bset = parent_bset & (sysctl_ceiling | creator_effective)
    Allowing the creator to retain capabilities it already holds in the
    parent namespace ensures that a process granted a specific
    capability (e.g. CAP_NET_ADMIN) does not lose it when creating a
    nested user namespace.

  When a task enters a user namespace via clone()/unshare() or
  setns(), its cap_bset, cap_permitted, and cap_effective sets are
  clamped to user_ns->cap_bset. In addition, cap_capable_helper() is
  updated so that implicit capabilities granted to the parent-namespace
  owner of a user namespace are likewise bounded by the owned
  namespace's cap_bset.

3. Per-namespace restriction via clone3() (Patch 3)

  Introduce CLONE_NEWUSER_BSET and add cap_bset to struct clone_args.
  When specified alongside CLONE_NEWUSER, the new user namespace's
  bounding set is further intersected with the requested cap_bset mask,
  allowing container runtimes and sandboxes to drop unneeded capabilities
  from a user namespace at creation time even when permitted by the
  global sysctl.

4. Introspection via NS_USER_GET_INFO (Patch 4)

  While tasks inside a user namespace see their initial ceiling in
  /proc/<pid>/status (CapBnd), threads may subsequently drop
  individual capabilities from their per-thread bounding set. Add
  an extensible NS_USER_GET_INFO ioctl on userns file descriptors
  to allow userspace to directly query a user namespace's cap_bset.

5. Selftests (Patches 5-8)

  Add kselftest suites covering CLONE_NEWNET_LOOPBACK, the sysctl
  ceiling, creator capability retention, nested monotonicity,
  parent-owner bounding, CLONE_NEWUSER_BSET and NS_USER_GET_INFO.

[1] https://lore.kernel.org/all/20240609104355.442002-1-jcalmels@3xx0.net/
[2] https://lwn.net/Articles/978846/

Note on tree routing:

While Patch 1 (CLONE_NEWNET_LOOPBACK) touches net/core/net_namespace.c,
most of its changes add clone3()/unshare() flag plumbing in
include/uapi/linux/sched.h, kernel/fork.c, and kernel/nsproxy.c, which
Patch 3 (CLONE_NEWUSER_BSET) builds directly on top of. To avoid
merge conflicts in kernel/fork.c and include/uapi/linux/sched.h, it
may be simplest to route the entire series through a single tree, e.g.
a namespace branch in vfs.git with Acked-by from the netdev and
capabilities/credentials maintainers, or whichever tree the maintainers
prefer.

Hallgrimur H. Gunnarsson (8):
  net: introduce CLONE_NEWNET_LOOPBACK to auto-enable loopback
  userns: introduce capability bounding set for user namespaces
  userns: allow restricting capability bounding set via clone3()
  nsfs: add NS_USER_GET_INFO ioctl to inspect user namespace
    capabilities
  selftests/net: add test suite for CLONE_NEWNET_LOOPBACK
  selftests/capabilities: tests for user namespace capability bounding
    set
  selftests/capabilities: add clone3() tests for CLONE_NEWUSER_BSET
  selftests/nsfs: add tests for NS_USER_GET_INFO ioctl

 Documentation/admin-guide/sysctl/kernel.rst   |  37 ++
 fs/nsfs.c                                     |  29 +
 include/linux/cred.h                          |   3 +-
 include/linux/sched/task.h                    |   1 +
 include/linux/user_namespace.h                |  20 +-
 include/uapi/linux/nsfs.h                     |  17 +
 include/uapi/linux/sched.h                    |   9 +
 kernel/cred.c                                 |  10 +-
 kernel/fork.c                                 |  38 +-
 kernel/nsproxy.c                              |   9 +
 kernel/user.c                                 |   1 +
 kernel/user_namespace.c                       | 100 +++-
 net/core/net_namespace.c                      |  11 +
 security/commoncap.c                          |   8 +-
 .../testing/selftests/capabilities/.gitignore |   1 +
 tools/testing/selftests/capabilities/Makefile |   2 +-
 .../capabilities/userns_bounding_set_test.c   | 566 ++++++++++++++++++
 .../selftests/clone3/clone3_selftests.h       |   1 +
 .../selftests/filesystems/nsfs/.gitignore     |   1 +
 .../selftests/filesystems/nsfs/Makefile       |   4 +-
 .../selftests/filesystems/nsfs/userns.c       | 120 ++++
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/loopback_netns.c  | 103 ++++
 24 files changed, 1069 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/capabilities/userns_bounding_set_test.c
 create mode 100644 tools/testing/selftests/filesystems/nsfs/userns.c
 create mode 100644 tools/testing/selftests/net/loopback_netns.c


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.56.0.313.g2479322e68-goog

