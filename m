From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 0/3] Fix unsafe BPF_PROG_TEST_RUN interface
Date: Fri, 16 Nov 2018 12:53:26 +0000
Message-ID: <20181116125329.3974-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Right now, there is no safe way to use BPF_PROG_TEST_RUN with data_out.
This is because bpf_test_finish copies the output buffer to user space
without checking its size. This can lead to the kernel overwriting
data in user space after the buffer if xdp_adjust_head and friends are
in play.

Fix this by using bpf_attr.test.data_size_out as a size hint. The old
behaviour is retained if size_hint is zero.

Interestingly, do_test_single() in test_verifier.c already assumes
that this is the intended use of data_size_out, and sets it to the
output buffer size.

Lorenz Bauer (3):
  bpf: respect size hint to BPF_PROG_TEST_RUN if present
  libbpf: require size hint in bpf_prog_test_run
  selftests: add a test for bpf_prog_test_run output size

 net/bpf/test_run.c                       |  9 ++++-
 tools/lib/bpf/bpf.c                      |  4 ++-
 tools/testing/selftests/bpf/test_progs.c | 44 ++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 2 deletions(-)

-- 
2.17.1
