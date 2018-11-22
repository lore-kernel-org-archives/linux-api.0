From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 0/4] Fix unsafe BPF_PROG_TEST_RUN interface
Date: Thu, 22 Nov 2018 14:09:06 +0000
Message-ID: <20181122140910.1079-1-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116125329.3974-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, ys114321@gmail.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Right now, there is no safe way to use BPF_PROG_TEST_RUN with data_out.
This is because bpf_test_finish copies the output buffer to user space
without checking its size. This can lead to the kernel overwriting
data in user space after the buffer if xdp_adjust_head and friends are
in play.

Changes in v3:
* Introduce bpf_prog_test_run_xattr instead of modifying the existing
  function

Changes in v2:
* Make the syscall return ENOSPC if data_size_out is too small
* Make bpf_prog_test_run return EINVAL if size_out is missing
* Document the new behaviour of data_size_out

Lorenz Bauer (4):
  bpf: respect size hint to BPF_PROG_TEST_RUN if present
  tools: sync uapi/linux/bpf.h
  libbpf: add bpf_prog_test_run_xattr
  selftests: add a test for bpf_prog_test_run_xattr

 include/uapi/linux/bpf.h                 |  7 +++-
 net/bpf/test_run.c                       | 15 +++++++-
 tools/include/uapi/linux/bpf.h           |  7 +++-
 tools/lib/bpf/bpf.c                      | 27 +++++++++++++
 tools/lib/bpf/bpf.h                      | 13 +++++++
 tools/testing/selftests/bpf/test_progs.c | 49 ++++++++++++++++++++++++
 6 files changed, 112 insertions(+), 6 deletions(-)

-- 
2.17.1
