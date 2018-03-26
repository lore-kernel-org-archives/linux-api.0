From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 09:25:07 -0700
Message-ID: <89fbc745-c290-c82c-a837-8998cf2988e7@fb.com>
References: <20180324023038.938665-1-ast@fb.com>
 <20180324023038.938665-7-ast@fb.com>
 <20180326110204.042801dd@gandalf.local.home>
 <1787605856.4574.1522077244597.JavaMail.zimbra@efficios.com>
 <5bcacdb5-e72f-b67a-4884-61fcedf0938a@fb.com>
 <523311773.184.1522079745421.JavaMail.zimbra@efficios.com>
 <f39181e0-3d46-2154-044c-dfc985053b3a@fb.com>
 <1055377367.195.1522081045131.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1055377367.195.1522081045131.JavaMail.zimbra@efficios.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

On 3/26/18 9:17 AM, Mathieu Desnoyers wrote:
>>
>> re: 'added complexity'...
>> -       for (iter = begin; iter < end; iter++)
>> -               fct(*iter, priv);
>> +               return NULL;
>> +       for (iter = begin; iter < end; iter++) {
>> +               ret = fct(*iter, priv);
>> +               if (ret)
>> +                       return ret;
>> +       }
>> +       return NULL;
>>
>> where do you see 'added complexity' ?
>> Isn't the above diff self-explanatory that for_each_tracepoint_range()
>> can be used not only to iterate over all tracepoints
>> (just do 'return NULL') from callback _and_ to find one particular
>> tracepoint as patch 7 does ?
>
> I am not arguing about your proposed implementation. I am arguing about
> the lack of justification behind this change. Why is this change needed ?
> What is it allowing you to do that cannot be done using the private data
> pointer ?

commit log of patch 6 states:

"for_each_tracepoint_range() api has no users inside the kernel.
Make it more useful with ability to stop for_each() loop depending
via callback return value.
In such form it's used in subsequent patch."

and in patch 7:

+static void *__find_tp(struct tracepoint *tp, void *priv)
+{
+       char *name = priv;
+
+       if (!strcmp(tp->name, name))
+               return tp;
+       return NULL;
+}
...
+       struct tracepoint *tp;
...
+       tp = for_each_kernel_tracepoint(__find_tp, tp_name);
+       if (!tp)
+               return -ENOENT;

still not obvious?
