From: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH for 5.5 1/1] rseq/selftests: Turn off timeout setting
Date: Thu, 19 Dec 2019 18:44:45 -0700
Message-ID: <f8f04858-ff13-8ec3-0249-8c864fad406a@linuxfoundation.org>
References: <20191211162857.11354-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191211162857.11354-1-mathieu.desnoyers@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, Shuah Khan <skhan@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On 12/11/19 9:28 AM, Mathieu Desnoyers wrote:
> As the rseq selftests can run for a long period of time, disable the
> timeout that the general selftests have.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> ---
>   tools/testing/selftests/rseq/settings | 1 +
>   1 file changed, 1 insertion(+)
>   create mode 100644 tools/testing/selftests/rseq/settings
> 
> diff --git a/tools/testing/selftests/rseq/settings b/tools/testing/selftests/rseq/settings
> new file mode 100644
> index 000000000000..e7b9417537fb
> --- /dev/null
> +++ b/tools/testing/selftests/rseq/settings
> @@ -0,0 +1 @@
> +timeout=0
> 

I am pulling this patch in for Linux 5.5-rc4.

Let me know if you have any objections.

thanks,
-- Shuah
