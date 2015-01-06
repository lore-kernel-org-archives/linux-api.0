From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH] tools: testing: selftests: mq_perf_tests: Fix infinite
 loop on ARM
Date: Tue, 06 Jan 2015 13:03:12 -0700
Message-ID: <54AC3F80.5060406@osg.samsung.com>
References: <1420512880-392-1-git-send-email-dann.frazier@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420512880-392-1-git-send-email-dann.frazier-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dann frazier <dann.frazier-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuah.kh-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/05/2015 07:54 PM, dann frazier wrote:
> We can't use a char type to check for a negative return value since char
> isn't guaranteed to be signed. Indeed, the char type tends to be unsigned on
> ARM.
> 
> Signed-off-by: dann frazier <dann.frazier-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  tools/testing/selftests/mqueue/mq_perf_tests.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c
> index 94dae65..8519e9e 100644
> --- a/tools/testing/selftests/mqueue/mq_perf_tests.c
> +++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
> @@ -536,10 +536,9 @@ int main(int argc, char *argv[])
>  {
>  	struct mq_attr attr;
>  	char *option, *next_option;
> -	int i, cpu;
> +	int i, cpu, rc;
>  	struct sigaction sa;
>  	poptContext popt_context;
> -	char rc;
>  	void *retval;
>  
>  	main_thread = pthread_self();
> 

Thanks. Applied to kernel/git/shuah/linux-kselftest fixes branch

-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org | (970) 217-8978
