From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v2 bpf-next] bpf, tracing: unbreak lttng
Date: Tue, 27 Mar 2018 11:39:19 +0200
Message-ID: <1260578f-4a29-2c72-d81c-3f6e0588bbee@iogearbox.net>
References: <20180326230220.1069180-1-ast@kernel.org>
 <20180326200704.27cb86fa@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326200704.27cb86fa@gandalf.local.home>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>
Cc: davem@davemloft.net, torvalds@linux-foundation.org, peterz@infradead.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/27/2018 02:07 AM, Steven Rostedt wrote:
> On Mon, 26 Mar 2018 16:02:20 -0700
> Alexei Starovoitov <ast@kernel.org> wrote:
> 
>> for_each_kernel_tracepoint() is used by out-of-tree lttng module
>> and therefore cannot be changed.
> 
> This is false and misleading. NACK.

Steven, while I really don't care about this particular function, you wrote
a few emails ago, quote:

  Look, the tracepoint code was written by Mathieu for LTTng, and perf
  and ftrace were able to benefit because of it, as well as your bpf
  code. For this, we agreed to keep this function around for his use,
  as its the only thing he requires. Everyone has been fine with that.
  [...] Having that function for LTTng does not hurt us. And I will NACK
  removing it.

So later saying that "this is false and misleading" is kind of misleading
by itself. ;-) Anyway, it would probably make sense to add a comment to
for_each_kernel_tracepoint() that this is used by LTTng so that people
don't accidentally remove it due to missing in-tree user. I would think
some sort of clarification/background in a comment or such would have
avoided the whole confusion and resulting discussion around this in the
first place.

Btw, in networking land, as soon as there is no in-tree user for a particular
kernel function, it will get ripped out, no matter what. Given this is also
the typical convention in the kernel, it may have caused some confusion with
above preference.

Anyway, given v6 is out now, I've tossed the old series from bpf-next tree.
So I hope we can all move on with some more constructive discussion. :-)

Thanks everyone,
Daniel
