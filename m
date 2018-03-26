From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 12:57:02 -0400 (EDT)
Message-ID: <1218234422.259.1522083422808.JavaMail.zimbra@efficios.com>
References: <20180324023038.938665-1-ast@fb.com> <1787605856.4574.1522077244597.JavaMail.zimbra@efficios.com> <5bcacdb5-e72f-b67a-4884-61fcedf0938a@fb.com> <523311773.184.1522079745421.JavaMail.zimbra@efficios.com> <f39181e0-3d46-2154-044c-dfc985053b3a@fb.com> <1055377367.195.1522081045131.JavaMail.zimbra@efficios.com> <89fbc745-c290-c82c-a837-8998cf2988e7@fb.com> <20180326123530.66ced6ae@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326123530.66ced6ae@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@fb.com>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

----- On Mar 26, 2018, at 12:35 PM, rostedt rostedt@goodmis.org wrote:

> On Mon, 26 Mar 2018 09:25:07 -0700
> Alexei Starovoitov <ast@fb.com> wrote:
> 
>> commit log of patch 6 states:
>> 
>> "for_each_tracepoint_range() api has no users inside the kernel.
>> Make it more useful with ability to stop for_each() loop depending
>> via callback return value.
>> In such form it's used in subsequent patch."
>> 
>> and in patch 7:
>> 
>> +static void *__find_tp(struct tracepoint *tp, void *priv)
>> +{
>> +       char *name = priv;
>> +
>> +       if (!strcmp(tp->name, name))
>> +               return tp;
>> +       return NULL;
>> +}
>> ...
>> +       struct tracepoint *tp;
>> ...
>> +       tp = for_each_kernel_tracepoint(__find_tp, tp_name);
>> +       if (!tp)
>> +               return -ENOENT;
>> 
>> still not obvious?
> 
> Please just create a new function called tracepoint_find_by_name(), and
> use that. I don't see any benefit in using a for_each* function for
> such a simple routine. Not to mention, you then don't need to know the
> internals of a tracepoint in kernel/bpf/syscall.c.

Steven's approach is fine by me, considering there should never be duplicated
tracepoint definitions (it emits a __tracepoint_##name symbol which would cause
multiple symbols definition errors at link time if there are more than
a single definition per tracepoint name in the core kernel). The exported
API should probably be named "kernel_tracepoint_find_by_name()" or something
similar, thus indicating that it only lookup tracepoints in the core kernel.

Which brings the next question: what are Alexei's plan to handle tracepoints
in modules, considering module load/unload scenarios ? The tracepoint API
has module notifiers for this, but it does not appear to be used in this
patch series.

Thanks,

Mathieu

> 
> -- Steve

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
