From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] selftests/futex: Fix futex_cmp_requeue_pi() error handling
Date: Mon, 20 Jul 2015 18:34:01 -0600
Message-ID: <55AD9379.7030206@osg.samsung.com>
References: <e45eef3361e23760f2fa8750d0468d7ec021db6d.1437432376.git.dvhart@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e45eef3361e23760f2fa8750d0468d7ec021db6d.1437432376.git.dvhart@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Binderman <dcb314@hotmail.com>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 07/20/2015 04:48 PM, Darren Hart wrote:
> An earlier (pre-kernel-integration) refactoring of this code mistakenly
> replaced the error condition, <, with a >. Use < to detect an error as
> opposed to a successful requeue or signal race.
> 
> Reported-by: David Binderman <dcb314@hotmail.com>
> Cc: Shuah Khan <shuahkh@osg.samsung.com>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> ---
>  .../selftests/futex/functional/futex_requeue_pi_signal_restart.c        | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c b/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
> index 7f0c756..3d7dc6a 100644
> --- a/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
> +++ b/tools/testing/selftests/futex/functional/futex_requeue_pi_signal_restart.c
> @@ -191,7 +191,7 @@ int main(int argc, char *argv[])
>  		if (res > 0) {
>  			atomic_set(&requeued, 1);
>  			break;
> -		} else if (res > 0) {
> +		} else if (res < 0) {
>  			error("FUTEX_CMP_REQUEUE_PI failed\n", errno);
>  			ret = RET_ERROR;
>  			break;
> 

Daren,

That is quick. Applied to linux-kselftest fixes for 4.2

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
