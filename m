From: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 19/24] membarrier: selftest: Test shared
 expedited cmd
Date: Fri, 17 Nov 2017 08:07:19 -0700
Message-ID: <9e0e1b65-337f-4f0e-7e55-6cee8c17a507@osg.samsung.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
 <20171114200414.2188-20-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114200414.2188-20-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Avi Kivity <avi@scylladb.c>
List-Id: linux-api@vger.kernel.org

On 11/14/2017 01:04 PM, Mathieu Desnoyers wrote:
> Test the new MEMBARRIER_CMD_SHARED_EXPEDITED and
> MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED commands.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> CC: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> CC: Paul E. McKenney <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Maged Michael <maged.michael-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Avi Kivity <avi-VrcmuVmyx1hWk0Htik3J/w@public.gmane.org>
> CC: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>
> CC: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> CC: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
> CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
> CC: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> CC: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: Alice Ferrazzi <alice.ferrazzi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Paul Elder <paul.elder-fYq5UfK3d1k@public.gmane.org>
> CC: linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  .../testing/selftests/membarrier/membarrier_test.c | 51 +++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/membarrier/membarrier_test.c b/tools/testing/selftests/membarrier/membarrier_test.c
> index e6ee73d01fa1..bb9c58072c5c 100644
> --- a/tools/testing/selftests/membarrier/membarrier_test.c
> +++ b/tools/testing/selftests/membarrier/membarrier_test.c
> @@ -132,6 +132,40 @@ static int test_membarrier_private_expedited_success(void)
>  	return 0;
>  }
>  
> +static int test_membarrier_register_shared_expedited_success(void)
> +{
> +	int cmd = MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED, flags = 0;
> +	const char *test_name = "sys membarrier MEMBARRIER_CMD_REGISTER_SHARED_EXPEDITED";
> +
> +	if (sys_membarrier(cmd, flags) != 0) {
> +		ksft_exit_fail_msg(
> +			"%s test: flags = %d, errno = %d\n",
> +			test_name, flags, errno);
> +	}
> +
> +	ksft_test_result_pass(
> +		"%s test: flags = %d\n",
> +		test_name, flags);
> +	return 0;
> +}
> +
> +static int test_membarrier_shared_expedited_success(void)
> +{
> +	int cmd = MEMBARRIER_CMD_SHARED_EXPEDITED, flags = 0;
> +	const char *test_name = "sys membarrier MEMBARRIER_CMD_SHARED_EXPEDITED";
> +
> +	if (sys_membarrier(cmd, flags) != 0) {
> +		ksft_exit_fail_msg(
> +			"%s test: flags = %d, errno = %d\n",
> +			test_name, flags, errno);
> +	}
> +
> +	ksft_test_result_pass(
> +		"%s test: flags = %d\n",
> +		test_name, flags);
> +	return 0;
> +}
> +
>  static int test_membarrier(void)
>  {
>  	int status;
> @@ -154,6 +188,19 @@ static int test_membarrier(void)
>  	status = test_membarrier_private_expedited_success();
>  	if (status)
>  		return status;
> +	/*
> +	 * It is valid to send a shared membarrier from a non-registered
> +	 * process.
> +	 */
> +	status = test_membarrier_shared_expedited_success();
> +	if (status)
> +		return status;
> +	status = test_membarrier_register_shared_expedited_success();
> +	if (status)
> +		return status;
> +	status = test_membarrier_shared_expedited_success();
> +	if (status)
> +		return status;
>  	return 0;
>  }
>  
> @@ -173,8 +220,10 @@ static int test_membarrier_query(void)
>  		}
>  		ksft_exit_fail_msg("sys_membarrier() failed\n");
>  	}
> -	if (!(ret & MEMBARRIER_CMD_SHARED))
> +	if (!(ret & MEMBARRIER_CMD_SHARED)) {
> +		ksft_test_result_fail("sys_membarrier() CMD_SHARED query failed\n");
>  		ksft_exit_fail_msg("sys_membarrier is not supported.\n");
> +	}
>  
>  	ksft_test_result_pass("sys_membarrier available\n");
>  	return 0;
> 

Looks good to me. I am assuming this patch goes in with the rest of the
series. For this patch:

Acked-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

thanks,
-- Shuah
