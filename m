From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] selftests/exec: Check if the syscall exists and bail if not
Date: Wed, 21 Jan 2015 10:22:04 +0000
Message-ID: <CAHse=S_AWuY4YG7DJeU+Rma-kPuQLGZH2oqVV27RvF4unu61Aw@mail.gmail.com>
References: <1421826060-2237-1-git-send-email-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421826060-2237-1-git-send-email-mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Jan 21, 2015 at 7:41 AM, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org> wrote:
> On systems which don't implement sys_execveat(), this test produces a
> lot of output.
>
> Add a check at the beginning to see if the syscall is present, and if
> not just note one error and return.

Good point, thanks.

> Signed-off-by: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> ---
>  tools/testing/selftests/exec/execveat.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
> index e238c9559caf..b87e4a843bea 100644
> --- a/tools/testing/selftests/exec/execveat.c
> +++ b/tools/testing/selftests/exec/execveat.c
> @@ -234,6 +234,14 @@ static int run_tests(void)
>         int fd_cloexec = open_or_die("execveat", O_RDONLY|O_CLOEXEC);
>         int fd_script_cloexec = open_or_die("script", O_RDONLY|O_CLOEXEC);
>
> +       /* Check if we have execveat at all, and bail early if not */
> +       errno = 0;
> +       execveat_(-1, NULL, NULL, NULL, 0);
> +       if (errno == -ENOSYS) {

Could we change this to ENOSYS (no minus) and also change
the execveat_() function similarly, so that a binary built where
__NR_execveat is available but running where it isn't also exits
early?  (My bad for having the minus sign in execveat_() in the
first place -- fingers too used to kernel mode.)

Thanks!

> +               printf("[FAIL] ENOSYS calling execveat - no kernel support?\n");
> +               return 1;
> +       }
> +
>         /* Change file position to confirm it doesn't affect anything */
>         lseek(fd, 10, SEEK_SET);
>
> --
> 2.1.0
>
