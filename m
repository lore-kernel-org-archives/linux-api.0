From: Y Song <ys114321@gmail.com>
Subject: Re: [PATCH v2 0/4] Fix unsafe BPF_PROG_TEST_RUN interface
Date: Tue, 20 Nov 2018 09:18:30 -0800
Message-ID: <CAH3MdRU7QqSnF9HB8hQwO34zg0Fe4zoF2jtv1LVAZRXv7Kffag@mail.gmail.com>
References: <20181116125329.3974-1-lmb@cloudflare.com> <20181120154306.16657-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120154306.16657-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev <netdev@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 20, 2018 at 7:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Right now, there is no safe way to use BPF_PROG_TEST_RUN with data_out.
> This is because bpf_test_finish copies the output buffer to user space
> without checking its size. This can lead to the kernel overwriting
> data in user space after the buffer if xdp_adjust_head and friends are
> in play.
>
> Changes in v2:
> * Make the syscall return ENOSPC if data_size_out is too small
> * Make bpf_prog_test_run return EINVAL if size_out is missing
> * Document the new behaviour of data_size_out
>
> Lorenz Bauer (4):
>   bpf: respect size hint to BPF_PROG_TEST_RUN if present
>   tools: sync uapi/linux/bpf.h
>   libbpf: require size hint in bpf_prog_test_run
>   selftests: add a test for bpf_prog_test_run output size

For the series, if we decided to take this approach rather than
amending another field
in the uapi as described in https://www.spinics.net/lists/netdev/msg534277.html,
then
  Acked-by: Yonghong Song <yhs@fb.com>
