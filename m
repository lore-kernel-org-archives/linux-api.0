From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH bpf-next] bpf, tracing: unbreak lttng
Date: Mon, 26 Mar 2018 19:08:51 -0700
Message-ID: <4cdd5f71-38e7-966d-15f8-36833c36182e@fb.com>
References: <20180326220845.678423-1-ast@kernel.org>
 <1523827268.612.1522103407744.JavaMail.zimbra@efficios.com>
 <761ce9e6-aea4-01d8-8ff0-a17ad8a92526@fb.com>
 <20180326200840.2b9eda2c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326200840.2b9eda2c@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Alexei Starovoitov <ast@kernel.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/26/18 5:08 PM, Steven Rostedt wrote:
> On Mon, 26 Mar 2018 15:35:56 -0700
> Alexei Starovoitov <ast@fb.com> wrote:
>
>
>>> This patch is not reverting to the old code properly. It introduces a
>>> static inline void function that returns NULL. Please compile-test
>>> with CONFIG_TRACEPOINTS=n before submitting a patch involving tracepoints.
>>
>> right. good catch. v2 is coming.
>
> Either fold the patch into the original patch, or I'm pulling in
> Mathieu's patch and pushing it to Linus come the merge window.

Ok. I will fold this patch into previous set and rebase the tree.
