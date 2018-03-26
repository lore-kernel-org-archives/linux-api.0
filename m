From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 09:47:21 -0700
Message-ID: <b07ea9b4-6b73-60aa-9391-002db42c571b@fb.com>
References: <20180324023038.938665-1-ast@fb.com>
 <20180324023038.938665-7-ast@fb.com>
 <20180326110204.042801dd@gandalf.local.home>
 <1787605856.4574.1522077244597.JavaMail.zimbra@efficios.com>
 <5bcacdb5-e72f-b67a-4884-61fcedf0938a@fb.com>
 <523311773.184.1522079745421.JavaMail.zimbra@efficios.com>
 <f39181e0-3d46-2154-044c-dfc985053b3a@fb.com>
 <1055377367.195.1522081045131.JavaMail.zimbra@efficios.com>
 <89fbc745-c290-c82c-a837-8998cf2988e7@fb.com>
 <20180326123530.66ced6ae@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180326123530.66ced6ae@gandalf.local.home>
Sender: netdev-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

On 3/26/18 9:35 AM, Steven Rostedt wrote:
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

It's a standard pattern in the kernel to stop for_each*() iterator
when callback function returns non-null.
Few examples:
idr_for_each
cfs_hash_for_each
and there are plenty more.

I don't mind to _rename_ for_each_kernel_tracepoint() into
tracepoint_find_by_name(), but keeping exported function
just to be used by out-of-tree modules would be wrong message for
the kernel community in general.
With my patch the for_each_kernel_tracepoint() will be used by bpf side
and out-of-tree can trivially hack their callbacks to keep working.
imo that's a better approach then renaming it.
