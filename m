From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/3] selftests/capabilities: actually test it
Date: Mon, 16 Nov 2015 16:18:13 +1100
Message-ID: <1447651093.959.7.camel@ellerman.id.au>
References: <1447480914-14834-1-git-send-email-bamvor.zhangjian@linaro.org>
	 <1447480914-14834-3-git-send-email-bamvor.zhangjian@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447480914-14834-3-git-send-email-bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org, khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tyler.baker-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, 2015-11-14 at 14:01 +0800, Bamvor Jian Zhang wrote:

> The capatabilities exist in selftest but no in the TARGET list.
> Add it to the TARGET.
> 
> Signed-off-by: Bamvor Jian Zhang <bamvor.zhangjian-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  tools/testing/selftests/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index 2458288..71b147e 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -1,4 +1,5 @@
>  TARGETS = breakpoints
> +TARGETS += capabilities
>  TARGETS += cpu-hotplug
>  TARGETS += efivarfs
>  TARGETS += exec


This breaks when you use TARGETS on the command line, eg:

 $ make -C tools/testing/selftests TARGETS=capabilities
 make[1]: *** No rule to make target 'capabilities', needed by 'all'.  Stop.

That's because the capabilities/Makefile uses the variable TARGETS internally.
You need to change the name of that variable in capabilities/Makefile, eg. to
BINARIES or something.

cheers
