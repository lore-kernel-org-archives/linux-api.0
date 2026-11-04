Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763370;
	b=stOubMqDmharQ/xj/EirxhWjGRMdCer9Rt/YgNJ0kEV9FwiFnEVuoIqAogkFHk2ee5Jr
	 2F0qy3t3rd+0B9htQMzmczwxQQkRavZUJbAz1Ktu8ULfAJz/rJULmD0A3WkeJnTJ/m7CI
	 jmikrK/vTRJjG6IqPJSRagCRZgku5q2LdVaCR4g/6bJFhtZNdrauPTZYzvb93M+ipDdim
	 Yag4WwUC9TSSj0cjuVHZhlsrZ72+raoSddp1hHoIr7yvX5JvgmXFu+aMqZ9C+83Y9bkli
	 uDy3cg4dbAvQIMd7NJoeKXthXSFp+lepFTfnPBwDeXzGj3NhN9ssWebqF6JEbzOAgjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763370;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=RDaP+dNG/QtNuoB0a0b0YVPr/BeKGVTsXfTUPQfFDL0=;
	b=rC4Y/n4COfnp2MO9VFke+mn1pmkm7VwQrwRrpqH28ZmDc5CmOW+WH38HBY3lep2qXgjX
	 HqcB+7F24lZZHNUnCzUWYdBLlGBKkTenpR4FderMNEUFQNBm5U+YtIt0qJAGb92K6A1CF
	 Bdz0CxpYn/rGmHJ/PlTrRBrxcMWob8UozNEEx6tch6D8nB6T4JOcRmKWzgTiDzLSHprxz
	 y5DUdlQWDI664Fz23a3AtxFzeDjjJtBlPJao1rSNNX8fQi/GYF8Fgic3g3H1M8nD4j8wo
	 tTNnIY3ae8GcqJ12EFMQPrSZnTvHNhKWvErUusJClKQYMGAuxKFgctd08/ynvJDz0tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Jwxkrk3d;
	arc=none smtp.remote-ip=162.62.57.49
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D16606A326;
	Wed,  4 Nov 2026 03:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6D16606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=Jwxkrk3d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793763362; bh=RDaP+dNG/QtNuoB0a0b0YVPr/BeKGVTsXfTUPQfFDL0=;
	h=From:To:Cc:Subject:Date;
	b=Jwxkrk3dsBcvrLEtgybEMGb79TAsvzMx8+otDSrl0T6OcM7Ht2oxbYuO7lJzHRTFQ
	 su32Vt8dZA88FtSjaZHdwMUq6EC+lmdgf7heONqkeSPEfePF00nGnRMGkpnPjJJI8q
	 8n2X6f27utGmxcBC45lUov+nOQOI0BhHovwpolkw=
Received: from hub.zhongying.com.zhongying.com ([2409:891f:8f46:1a8b:2dd5:45b2:eebc:59b4])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 8DBB9AD2; Wed, 04 Nov 2026 11:35:27 +0800
X-QQ-mid: xmsmtpt1793763327tsscucnbb
Message-ID: <tencent_BC9FCDC060870B3AAD4716DE9ED970420107@qq.com>
X-QQ-XMAILINFO: NbgegmlEc3Ju/BQxMc7j346TICtme/opNEbfOI3/wbxeYYPlOfk4wf43P9jQpp
	 lp6vPX7e27ylODIGYIz5ITIqgKac5Pszo6rjKEPioxZBUZKXNYmOOSFFMXhXi5JV6c0Vl+P95aTH
	 MgqugR5L8qwZLQbnyIPmUcuhJOTTcSjhfkJ+J5aHIbcEBYcR5MGWdSwWA14dJLyVmwYouyIWYurf
	 AO+ibZXiqesCtWfq4pu9QJL6pL6dYxwhSUiUutPWWPWhsNMDXXUDbi/O+hAr0QTDPCEemqC5lqYk
	 PEVVvjjCfOnWkBL/2ME+ENqmtI2GPot0PtS8Z3EbnaTEAGF7uosGc+ybt1HGhu1EV+qda1B+cqCz
	 kSEYl6M6we9g9HO4CzbvhEDq7rDZF8R0i6xPVvV0fMTUz3LzhUZmaiGDHSxAflQG8qp7z1+gT467
	 88bq58+tmLEYvqMtO3od4Ctrgt6cNkRo773KXTZByIiBZ9ZCf5BHQ3z34febTMTDepCn/kFS6+Td
	 +W4zRT5oM3geYN3y/Km2tOt0YS7HDL0wZQPJUSW7RHwzz4RZyUErcaVEWSQVL4bnMgUXHEGa4KZF
	 ErecbgN5+y+ErIFA463Bz6a8h6eBEBe3SV0EbTlG62yAvezrPgyWzzoPGldCEVjSV6UAZWAOu4/a
	 k/yLRRo6a5+ug2F3mct3ELWF67ZPUfthqtbkVeJOWbwXWTtRmletNTw40GK1pYycfgcg4wrD6Yms
	 ma8buSYT6TV6OyCufKLcM+NT+JXAfBfMR2CQp99Ef3kkoaz1QFrNPUvC5Gad7+sTXLYtKUmih0LF
	 b8hcqnMQHFIbuUkfkkdtRnKEk/O4yAEjwWWCwhEZCsJNITXsURo331FlnckIsZwygUDLKzQYqhOk
	 D2RYTikNJtOZWWpcSTx/EUpHLWU4ldT+k5TaojjmEEjLH2lEFUtiEh67FpiZ5PDR/SesM7FtPUzf
	 nY3dcronqnBN4WGjoJTw0PHjmvEJ6VFUGjvKN5EjyXFzDd0l2T+DiUAL6sClWka6m8NMuGVWK1t5
	 rGVQM0gEn4qeKfvU6bVjHjBDGOX5Ed8dCS8UfyUGwQLeyUjK/GQAAMuibxwO530DQz6eMTopHXo8
	 ff2CGJ
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: patrick <work_patrick@qq.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/2] netlink: optional per-netns ROUTE multicast index
Date: Wed,  4 Nov 2026 11:35:24 +0800
X-OQ-MSGID: <20261104033526.2917590-1-work_patrick@qq.com>
X-Mailer: git-send-email 2.25.1
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

NETLINK_ROUTE multicast walks the protocol-wide subscriber list before
checking network namespace and group membership. Ordinary subscribers in
unrelated namespaces therefore add work to every notification.

Maintain one ROUTE subscriber list per network namespace and one global
LISTEN_ALL_NSID list. With net.core.netlink_route_mc_index=1, visit the
sender's namespace and the cross-namespace list. Exclude local sockets
from the second walk to avoid duplicate delivery. Preserve do_one_broadcast
and the existing broadcast initialization, locking, completion, error and
skb ownership handling; only select a different candidate iteration.
No additional broadcast helper or forced inlining is needed.

The setting defaults to 0, is visible only in init_net and affects all
network namespaces. Mode 0 retains the original global walk. Other
Netlink protocols retain their original walk. Both auxiliary lists remain
maintained in both modes so switching includes existing subscriptions
immediately. There is no automatic threshold or fallback.

The explicit switch allows administrators to choose the indexed walk
for workloads with many ordinary foreign subscribers. Local and ALL_NSID
subscribers can remove its benefit. Disabling it retains the memory and
subscription-maintenance costs.

U is the unpatched base; P0/P1 use the same newly built patched image with
the switch disabled/enabled. Measurements ran in ARM64 KVM with two vCPUs
and 3072 MiB RAM on a shared Phytium D2000/8 host. Three independent boot
pairs, three rounds and four samples per round yield 36 samples per state
and scene: 63 scenes and 6804 valid samples. The unchanged U image was
hash-verified and reused; every measurement in this comparison is new.
Performance configurations match except LOCALVERSION, with no probes.

Each route batch replaces 2640 routes using existing nexthop IDs, then
drains and validates every actual recipient. Timings include userspace,
syscalls, draining and validation. Thread CPU excludes asynchronous
cleanup workers. The 95% intervals resample paired boots and whole rounds
with 10000 bootstrap replicates. All completed formal samples are retained.
The host CPUs remained at 2300 MHz with performance governors.
Host load and small swap-counter changes were observed;
CPU pinning does not establish exclusive host resources or isolate kernel
layout effects.

Selected median wall times; negative changes mean less time:

Scenario              U ms      P0 ms      P1 ms   P0/U %   P1/U %
T1-n900-d0           105.112    120.571     18.595   +14.71   -82.31
T1-n900-d2           147.796    152.543     16.378    +3.21   -88.92
T2-field-c0          200.423    197.234     13.228    -1.59   -93.40
T2-field-c1          199.410    207.788     13.254    +4.20   -93.35
T3-monitor1          101.576    120.891     23.994   +19.02   -76.38
C1-n0                 17.393     17.784     16.973    +2.24    -2.42
C2-candidate900       86.568     91.119     93.700    +5.26    +8.24
C4-all450            108.084    115.643     77.509    +6.99   -28.29
C4-all900            123.199    137.517    161.098   +11.62   +30.76
E1-n1800-d0          585.290    603.409    769.098    +3.10   +31.40
C7-option-route      201.253    208.166    206.722    +3.43    +2.72
PAR-n900              99.985    102.772     19.941    +2.79   -80.06

T1-n900-d0 holds 900 ordinary foreign sockets in one namespace; d2 puts
two sockets in each foreign namespace. These are sockets, not 900 processes.
The source has two receivers. T2-field-c0/c1 uses a synthetic layout with
450 two-socket namespaces and seven extra subscribers under
nexthop_compat_mode 0/1, producing one recipient per event. T3-monitor1
adds a mapped cross-namespace monitor. C1-n0 has no foreign subscribers;
C2-candidate900 has 900 local candidates with only two matching receivers.
C4-all450/all900 enables ALL_NSID on 450/900 foreign sockets without NSID
mappings; E1-n1800-d0 extends this to 1800 sockets. C7-option-route measures
ROUTE socket-option changes. PAR-n900 has two senders sharing the foreign
socket pool. Workloads differ between scenes; comparisons are within a scene.

Default-off median changes and 95% relative confidence intervals:

  T1-n900-d0: wall +14.71% [-5.03%, +37.23%];
    thread CPU +15.06% [-6.24%, +37.81%]
  T2-field-c0: wall -1.59% [-6.03%, +5.55%];
    thread CPU -1.36% [-5.85%, +5.99%]
  T3-monitor1: wall +19.02% [+2.68%, +20.75%];
    thread CPU +18.98% [+2.51%, +20.75%]
  C4-all900: wall +11.62% [+1.38%, +16.63%];
    thread CPU +11.98% [+1.30%, +16.93%]
  C7-option-route: wall +3.43% [+0.91%, +5.83%];
    thread CPU +4.37% [+1.68%, +6.52%]

With the switch enabled, T1-n900-d0 wall change is -82.31% [-85.75%, -80.43%],
and T2-field-c0 is -93.40% [-93.64%, -93.12%].
The high-ALL_NSID cases show the boundary cost: C4-all900 wall change is
+30.76% [+21.83%, +36.14%]; E1-n1800-d0 is
+31.40% [+8.40%, +44.03%].
There is no candidate reduction when almost all foreign listeners use
ALL_NSID, while auxiliary-node access and local-namespace checks remain.
Default-off changes vary by scene and include intervals entirely above
zero, as shown above; the disabled state is not claimed to be cost-free.
These are measured costs and uncertainty, without a fixed-percentage
claim for default-off overhead. This is workload-dependent multicast
behavior, not end-to-end routing convergence or x86 runtime evidence.

On this ARM64 configuration, netlink_sock grows from 1072 to 1104 bytes
(+32) for all Netlink protocols. Both sizes use the 2048-byte kmalloc
bucket here. The per-netns payload is an 8-byte list
head, with allocation rounding and generic-pointer overhead in addition.
Selected new global symbols total 72 bytes, excluding alignment,
strings and dynamic sysctl registration. Both modes retain these costs.

The 21-case semantics test passes on U, both production modes, both debug
modes and as an installed standalone selftest. Six switch cases pass on
production and debug kernels and from the installed standalone copy.
Production and KASAN/PROVE_LOCKING/DEBUG_LIST/DEBUG_NET kernels each pass
fixed-0, fixed-1 and live-switching stress. Every group has two pinned
senders, at least 60 seconds and 100 batches per sender, concurrent socket,
membership, option and namespace churn; switching groups verify at least
1000 writes. Stable receiver notifications and ACKs are checked. No new
KASAN, lock or list error was reported.

Full linked builds pass for ARM64 production and debug, all four x86_64
GCC NET_NS/SYSCTL combinations, and x86_64 Clang 19. All builds ran in the
isolated ARM64 guest. Cross builds do not establish x86 runtime correctness.
KCSAN and skb allocation-failure injection were not run. FRR 10.3 dual-stack
learn/install/ping/withdraw/reinstall passes separately on U/P0/P1.

The tested base is 4dd16e31135ea8437a720222df34e8745f385d6d.
Both patches also apply cleanly to the checked net-next main
7b6ab4dbc156e2f96419715130b3d5738a306c93. Its five additional
commits change no implementation or test-code file touched here; the
shared selftest config adds unrelated devmem options. Runtime evidence
is for the stated tested base.

Patch 1 adds the lists, sysctl and documentation. Patch 2 adds two
standalone networking selftests, including behavior without the switch.
Raw samples, all scene comparisons and benchmark tools are retained and
can be supplied separately; they are not additional patches or attachments.

Please review this series for application to net-next.

AI assistance: An LLM assisted with implementation adaptation and
simplification.

patrick (2):
  netlink: add an optional per-netns ROUTE multicast index
  selftests: net: cover ROUTE multicast namespace and switch semantics

 Documentation/admin-guide/sysctl/net.rst      |  27 ++
 net/netlink/af_netlink.c                      | 109 ++++-
 net/netlink/af_netlink.h                      |   4 +
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/config            |   1 +
 .../selftests/net/netlink_mcast_semantics.py  | 420 ++++++++++++++++++
 .../selftests/net/netlink_mcast_switch.py     | 217 +++++++++
 7 files changed, 777 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/net/netlink_mcast_semantics.py
 create mode 100755 tools/testing/selftests/net/netlink_mcast_switch.py


base-commit: 4dd16e31135ea8437a720222df34e8745f385d6d

