From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v2 1/2] samples, selftests/seccomp: Zero out seccomp_notif
Date: Sat, 28 Dec 2019 11:18:25 -0700
Message-ID: <20191228181825.GB6746@cisco>
References: <20191228014837.GA31774@ircssh-2.c.rugged-nimbus-611.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191228014837.GA31774@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-kernel-owner@vger.kernel.org
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, jannh@google.com, christian.brauner@ubuntu.com, keescook@chromium.org, cyphar@cyphar.com
List-Id: linux-api@vger.kernel.org

On Sat, Dec 28, 2019 at 01:48:39AM +0000, Sargun Dhillon wrote:
> The seccomp_notif structure should be zeroed out prior to calling the
> SECCOMP_IOCTL_NOTIF_RECV ioctl. Previously, the kernel did not check
> whether these structures were zeroed out or not, so these worked.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>  samples/seccomp/user-trap.c                   | 2 +-
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/seccomp/user-trap.c b/samples/seccomp/user-trap.c
> index 6d0125ca8af7..0ca8fb37cd79 100644
> --- a/samples/seccomp/user-trap.c
> +++ b/samples/seccomp/user-trap.c
> @@ -298,7 +298,6 @@ int main(void)
>  		req = malloc(sizes.seccomp_notif);
>  		if (!req)
>  			goto out_close;
> -		memset(req, 0, sizeof(*req));
>  
>  		resp = malloc(sizes.seccomp_notif_resp);
>  		if (!resp)
> @@ -306,6 +305,7 @@ int main(void)
>  		memset(resp, 0, sizeof(*resp));

I know it's unrelated, but it's probably worth sending a patch to fix
this to be sizes.seccomp_notif_resp instead of sizeof(*resp), since if
the kernel is older this will over-zero things. I can do that, or you
can add the patch to this series, just let me know which.

But in any case, this patch is:

Reviewed-by: Tycho Andersen <tycho@tycho.ws>

Cheers,

Tycho
