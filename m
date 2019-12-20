From: Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH for 5.5 3/3] rseq/selftests: Fix: Namespace gettid() for
 compatibility with glibc 2.30
Date: Thu, 19 Dec 2019 18:44:51 -0700
Message-ID: <166a5ea8-65e8-2c8b-12ce-4cc7d8a77a74@linuxfoundation.org>
References: <20191211161713.4490-1-mathieu.desnoyers@efficios.com>
 <20191211161713.4490-4-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20191211161713.4490-4-mathieu.desnoyers@efficios.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>, linux-api@vger.kernel.org, stable@vger.kernel.org, "Tommi T . Rantala" <tommi.t.rantala@nokia.com>, Dmitry Vyukov <dvyukov@google.com>, Shuah Khan <skhan@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On 12/11/19 9:17 AM, Mathieu Desnoyers wrote:
> glibc 2.30 introduces gettid() in public headers, which clashes with
> the internal static definition within rseq selftests.
> 
> Rename gettid() to rseq_gettid() to eliminate this symbol name clash.
> 
> Reported-by: Tommi T. Rantala <tommi.t.rantala@nokia.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Tommi T. Rantala <tommi.t.rantala@nokia.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: <stable@vger.kernel.org>	# v4.18+
> ---
>   tools/testing/selftests/rseq/param_test.c | 18 ++++++++++--------


I am pulling this patch in for Linux 5.5-rc4.

Let me know if you have any objections.

thanks,
-- Shuah
