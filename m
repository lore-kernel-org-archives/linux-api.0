From: Y Song <ys114321@gmail.com>
Subject: Re: [PATCH 3/3] selftests: add a test for bpf_prog_test_run output size
Date: Sun, 18 Nov 2018 05:59:15 +0000
Message-ID: <CAH3MdRVd=ipYg+b9sGRR-FFUuOMjZ4OGZzkmJuFEShrYVXvwWA@mail.gmail.com>
References: <20181116125329.3974-1-lmb@cloudflare.com> <20181116125329.3974-4-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116125329.3974-4-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev <netdev@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 16, 2018 at 12:55 PM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Make sure that bpf_prog_test_run returns the correct length
> in the size_out argument and that the kernel respects the
> output size hint.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  tools/testing/selftests/bpf/test_progs.c | 34 ++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
> index 560d7527b86b..6ab98e10e86f 100644
> --- a/tools/testing/selftests/bpf/test_progs.c
> +++ b/tools/testing/selftests/bpf/test_progs.c
> @@ -124,6 +124,39 @@ static void test_pkt_access(void)
>         bpf_object__close(obj);
>  }
>
> +static void test_output_size_hint(void)
> +{
> +       const char *file = "./test_pkt_access.o";
> +       struct bpf_object *obj;
> +       __u32 retval, size, duration;
> +       int err, prog_fd;
> +       char buf[10];
> +
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
> +       if (err) {
> +               error_cnt++;
> +               return;
> +       }
CHECK can also be used here.
if (CHECK(...)) {
   goto done;
}
where label "done" is right before bpf_object__close.
> +
> +       memset(buf, 0, sizeof(buf));
> +
> +       size = 5;
> +       err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
> +                               buf, &size, &retval, &duration);
> +       CHECK(err || retval, "run",
> +             "err %d errno %d retval %d\n",
> +             err, errno, retval);
> +
> +       CHECK(size != sizeof(pkt_v4), "out_size",
> +             "incorrect output size, want %lu have %u\n",
> +             sizeof(pkt_v4), size);
> +
> +       CHECK(buf[5] != 0, "overflow",
> +             "prog_test_run ignored size hint\n");
> +
> +       bpf_object__close(obj);
> +}
> +
>  static void test_xdp(void)
>  {
>         struct vip key4 = {.protocol = 6, .family = AF_INET};
> @@ -1847,6 +1880,7 @@ int main(void)
>         jit_enabled = is_jit_enabled();
>
>         test_pkt_access();
> +       test_output_size_hint();
>         test_xdp();
>         test_xdp_adjust_tail();
>         test_l4lb_all();
> --
> 2.17.1
>
