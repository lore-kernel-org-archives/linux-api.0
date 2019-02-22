From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 0/3] Allow checking SYN cookies from XDP and tc cls act
Date: Fri, 22 Feb 2019 09:50:54 +0000
Message-ID: <20190222095057.9442-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc: linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

This series adds a helper bpf_sk_check_syncookie, which allows checking
whether a packet is a valid SYN cookie for a given socket. This is
useful for implementing load-balancing approaches like glb-director [1]
or Beamer [2] in pure eBPF.

Specifically, we'd like to replace the functionality of the glb-redirect
kernel module by an XDP program or tc classifier.

1: https://github.com/github/glb-director
2: https://www.usenix.org/conference/nsdi18/presentation/olteanu

Lorenz Bauer (3):
  bpf: add helper to check for a valid SYN cookie
  tools: sync changes to uapi/linux/bpf.h
  selftests/bpf: add tests for bpf_sk_check_syncookie

 include/uapi/linux/bpf.h                      |  18 +-
 net/core/filter.c                             |  68 ++++++
 tools/include/uapi/linux/bpf.h                |  18 +-
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 .../bpf/progs/test_sk_syncookie_kern.c        | 119 ++++++++++
 .../selftests/bpf/test_sk_syncookie.sh        |  81 +++++++
 .../selftests/bpf/test_sk_syncookie_user.c    | 212 ++++++++++++++++++
 9 files changed, 521 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_syncookie_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_sk_syncookie.sh
 create mode 100644 tools/testing/selftests/bpf/test_sk_syncookie_user.c
