From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 10:55:51 -0700
Message-ID: <17073efa-d833-7348-bef1-79376ad43bc6@fb.com>
References: <20180324023038.938665-1-ast@fb.com>
 <1787605856.4574.1522077244597.JavaMail.zimbra@efficios.com>
 <5bcacdb5-e72f-b67a-4884-61fcedf0938a@fb.com>
 <523311773.184.1522079745421.JavaMail.zimbra@efficios.com>
 <f39181e0-3d46-2154-044c-dfc985053b3a@fb.com>
 <1055377367.195.1522081045131.JavaMail.zimbra@efficios.com>
 <89fbc745-c290-c82c-a837-8998cf2988e7@fb.com>
 <20180326123530.66ced6ae@gandalf.local.home>
 <1218234422.259.1522083422808.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1218234422.259.1522083422808.JavaMail.zimbra@efficios.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, rostedt <rostedt@goodmis.org>
Cc: "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

On 3/26/18 9:57 AM, Mathieu Desnoyers wrote:
> ----- On Mar 26, 2018, at 12:35 PM, rostedt rostedt@goodmis.org wrote:
>
>> On Mon, 26 Mar 2018 09:25:07 -0700
>> Alexei Starovoitov <ast@fb.com> wrote:
>>
>>> commit log of patch 6 states:
>>>
>>> "for_each_tracepoint_range() api has no users inside the kernel.
>>> Make it more useful with ability to stop for_each() loop depending
>>> via callback return value.
>>> In such form it's used in subsequent patch."
>>>
>>> and in patch 7:
>>>
>>> +static void *__find_tp(struct tracepoint *tp, void *priv)
>>> +{
>>> +       char *name = priv;
>>> +
>>> +       if (!strcmp(tp->name, name))
>>> +               return tp;
>>> +       return NULL;
>>> +}
>>> ...
>>> +       struct tracepoint *tp;
>>> ...
>>> +       tp = for_each_kernel_tracepoint(__find_tp, tp_name);
>>> +       if (!tp)
>>> +               return -ENOENT;
>>>
>>> still not obvious?
>>
>> Please just create a new function called tracepoint_find_by_name(), and
>> use that. I don't see any benefit in using a for_each* function for
>> such a simple routine. Not to mention, you then don't need to know the
>> internals of a tracepoint in kernel/bpf/syscall.c.
>
> Steven's approach is fine by me, considering there should never be duplicated
> tracepoint definitions (it emits a __tracepoint_##name symbol which would cause
> multiple symbols definition errors at link time if there are more than
> a single definition per tracepoint name in the core kernel). The exported
> API should probably be named "kernel_tracepoint_find_by_name()" or something
> similar, thus indicating that it only lookup tracepoints in the core kernel.

An email ago you were ok to s/return/return NULL/ in your out-of-tree
module, but now flip flop to add new function approach just to
reduce the work you need to do in lttng?
We're not talking about changing __kmalloc signature here.
My patch extends for_each_kernel_tracepoint() api similar to other
for_each_*() iterators and improves possible uses of it.

It can event help lltng.

lttng-tracepoint.c is doing:

for_each_kernel_tracepoint(lttng_kernel_tracepoint_add, &ret);

to copy kernel tracepoints into its own hash table.

Only to later do:
/*
  * Get tracepoint if the tracepoint is present in the tracepoint hash 
table.
  * Must be called with lttng_tracepoint_mutex held.
  * Returns NULL if not present.
  */
static
struct tracepoint_entry *get_tracepoint(const char *name)
{
	struct hlist_head *head;
	struct tracepoint_entry *e;
	u32 hash = jhash(name, strlen(name), 0);

	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
	lttng_hlist_for_each_entry(e, head, hlist) {
		if (!strcmp(name, e->name))
			return e;
	}
	return NULL;
}

this use case potentially can be reimplemented in lttng with
this extended for_each_kernel_tracepoint() api.
Like I do on bpf side with very similar callback:
+static void *__find_tp(struct tracepoint *tp, void *priv)
+{
+       char *name = priv;
+
+       if (!strcmp(tp->name, name))
+               return tp;
+       return NULL;
+}

> Which brings the next question: what are Alexei's plan to handle tracepoints
> in modules, considering module load/unload scenarios ? The tracepoint API
> has module notifiers for this, but it does not appear to be used in this
> patch series.

correct. this set deals with in-kernel tracepoints only.
No attempt to do anything with tracepoints inside modules.

but your question brings another question:
why kernel/module.c have this code:
  mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs"
                                       sizeof(*mod->tracepoints_ptrs),
                                       &mod->num_tracepoints);
and the whole module tracepoint notifier logic
that is only used by out-of-tree ?

I didn't realize so much of kernel code was taken hostage by lttng.

One thing is to be nice to out-of-tree and do not break them
for no reason, but arguing that kernel shouldn't add a minor extension
to for_each_kernel_tracepoint() api is really taking the whole thing
to next level.

Also I hope you noticed that the patch is doing:
+++ b/include/linux/tracepoint-defs.h
@@ -33,6 +33,7 @@ struct tracepoint {
         int (*regfunc)(void);
         void (*unregfunc)(void);
         struct tracepoint_func __rcu *funcs;
+       u32 num_args;
  };

To make sure that bpf programs are safe I need to do a static check
in the verifier that programs don't access arguments beyond
those specified by the tracepoint.

That was mentioned in the commit log of patch 6 too:
"
compute number of arguments passed into tracepoint
at compile time and store it as part of 'struct tracepoint'.
The number is necessary to check safety of bpf program access that
is coming in subsequent patch.
"

I suspect you will have the same objection?
It breaks out-of-tree modules?!
