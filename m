From: Y Song <ys114321@gmail.com>
Subject: Re: [PATCH 1/3] bpf: respect size hint to BPF_PROG_TEST_RUN if present
Date: Sun, 18 Nov 2018 05:47:10 +0000
Message-ID: <CAH3MdRWoYu3xj5g5--xnVztGJny-_KF4ypMUptHfxeN7prFBBA@mail.gmail.com>
References: <20181116125329.3974-1-lmb@cloudflare.com> <20181116125329.3974-2-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116125329.3974-2-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: lmb@cloudflare.com
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, netdev <netdev@vger.kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 16, 2018 at 12:54 PM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> Use data_size_out as a size hint when copying test output to user space.
> A program using BPF_PERF_OUTPUT can compare its own buffer length with
> data_size_out after the syscall to detect whether truncation has taken
> place. Callers which so far did not set data_size_in are not affected.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  net/bpf/test_run.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index c89c22c49015..30c57b7f4ba4 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -74,8 +74,15 @@ static int bpf_test_finish(const union bpf_attr *kattr,
>  {
>         void __user *data_out = u64_to_user_ptr(kattr->test.data_out);
>         int err = -EFAULT;
> +       u32 copy_size = size;
>
> -       if (data_out && copy_to_user(data_out, data, size))
> +       /* Clamp copy if the user has provided a size hint, but copy the full
> +        * buffer if not to retain old behaviour.
> +        */
> +       if (kattr->test.data_size_out && copy_size > kattr->test.data_size_out)
> +               copy_size = kattr->test.data_size_out;
> +
> +       if (data_out && copy_to_user(data_out, data, copy_size))
>                 goto out;
>         if (copy_to_user(&uattr->test.data_size_out, &size, sizeof(size)))
>                 goto out;

if copy_size < size, maybe we should return -ENOSPC so user space is aware
of insufficient size and takes proper action? This behavior will then
be consistent
with BPF_PROG_QUERY subcommand where prog_cnt is the in/out parameter and
-ENOSPC is returned if kernel does not have enough space to copy out
the whole data.

Also, since data_size_out field now has more complex semantics, could you add
some comments in uapi/linux/bpf.h so it will be relatively clear from
uapi header
how this field will be used?

> --
> 2.17.1
>
