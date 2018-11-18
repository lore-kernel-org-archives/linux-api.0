From: Y Song <ys114321@gmail.com>
Subject: Re: [PATCH 0/3] Fix unsafe BPF_PROG_TEST_RUN interface
Date: Sun, 18 Nov 2018 06:13:04 +0000
Message-ID: <CAH3MdRW1=iUm0qQdNrv9r5Orn3rZ2XBDn-qym5i_cpi7wo6PxA@mail.gmail.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116125329.3974-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev <netdev@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 16, 2018 at 12:54 PM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Right now, there is no safe way to use BPF_PROG_TEST_RUN with data_out.
> This is because bpf_test_finish copies the output buffer to user space
> without checking its size. This can lead to the kernel overwriting
> data in user space after the buffer if xdp_adjust_head and friends are
> in play.
>
> Fix this by using bpf_attr.test.data_size_out as a size hint. The old
> behaviour is retained if size_hint is zero.

There is a slight change of user space behavior for this patch.
Without this patch, the value bpf_attr.test.data_size_out is output only.
For example,
   output buffer : out_buf (user allocated size 10)
   data_size_out is a random value (e.g., 1),

The actual data to copy is 5.

In today's implementation, the kernel will copy 5 and set data_size_out is 5.

With this patch, the kernel will copy 1 and set data_size_out is 5.

I am not 100% sure at this time whether we CAN overload data_size_out
since it MAY break existing applications.

Alternativley, we can append another field to bpf_attr.test
  __u32 data_out_size;
this will provide the data_out buffer size.
Inside kernel, if the user input attr is smaller than kernel and does not
have data_out_size, the current behavior should be used. Otherwise,
data_out_size is data_out buffer size.

Daniel and Alexei, which option do you think is reasonable?

>
> Interestingly, do_test_single() in test_verifier.c already assumes
> that this is the intended use of data_size_out, and sets it to the
> output buffer size.
>
> Lorenz Bauer (3):
>   bpf: respect size hint to BPF_PROG_TEST_RUN if present
>   libbpf: require size hint in bpf_prog_test_run
>   selftests: add a test for bpf_prog_test_run output size
>
>  net/bpf/test_run.c                       |  9 ++++-
>  tools/lib/bpf/bpf.c                      |  4 ++-
>  tools/testing/selftests/bpf/test_progs.c | 44 ++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 2 deletions(-)
>
> --
> 2.17.1
>
