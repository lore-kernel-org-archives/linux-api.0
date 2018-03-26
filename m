From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 09:08:35 -0700
Message-ID: <f39181e0-3d46-2154-044c-dfc985053b3a@fb.com>
References: <20180324023038.938665-1-ast@fb.com>
 <20180324023038.938665-7-ast@fb.com>
 <20180326110204.042801dd@gandalf.local.home>
 <1787605856.4574.1522077244597.JavaMail.zimbra@efficios.com>
 <5bcacdb5-e72f-b67a-4884-61fcedf0938a@fb.com>
 <523311773.184.1522079745421.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <523311773.184.1522079745421.JavaMail.zimbra@efficios.com>
Sender: netdev-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: rostedt <rostedt@goodmis.org>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

On 3/26/18 8:55 AM, Mathieu Desnoyers wrote:
> ----- On Mar 26, 2018, at 11:42 AM, Alexei Starovoitov ast@fb.com wrote:
>
>> On 3/26/18 8:14 AM, Mathieu Desnoyers wrote:
>>> ----- On Mar 26, 2018, at 11:02 AM, rostedt rostedt@goodmis.org wrote:
>>>
>>>> On Fri, 23 Mar 2018 19:30:34 -0700
>>>> Alexei Starovoitov <ast@fb.com> wrote:
>>>>
>>>>> From: Alexei Starovoitov <ast@kernel.org>
>>>>>
>>>>> add fancy macro to compute number of arguments passed into tracepoint
>>>>> at compile time and store it as part of 'struct tracepoint'.
>>>>> The number is necessary to check safety of bpf program access that
>>>>> is coming in subsequent patch.
>>>>>
>>>>> for_each_tracepoint_range() api has no users inside the kernel.
>>>>> Make it more useful with ability to stop for_each() loop depending
>>>>> via callback return value.
>>>>> In such form it's used in subsequent patch.
>>>>
>>>> I believe this is used by LTTng.
>>>
>>> Indeed, and by SystemTAP as well.
>>>
>>> What justifies the need to stop mid-iteration ? A less intrusive alternative
>>> would be to use the "priv" data pointer to keep state telling further calls
>>> to return immediately. Does performance of iteration over tracepoints really
>>> matter here so much that stopping iteration immediately is worth it ?
>>
>> I'm sure both you and Steven are not serious when you object
>> to _in-tree_ change to for_each_kernel_tracepoint() that
>> affects _out-of_tree_ modules?
>>
>> Just change your module to 'return NULL' instead of plain 'return'.
>
> I never said I objected to adapt the LTTng out of tree code. If there is a
> solid reason for changing the kernel API, I will adapt my code to those
> changes.
>
> What I'm trying to understand here is whether there is solid ground for
> the added complexity you are proposing. Is it a performance enhancement ?
> If so, explanation of the use cases targeted, and numbers that measure
> performance improvements are needed.
>
> How is your patch making tracepoints "more useful" ?

are you arguing about the whole set overall or about a change
to for_each_kernel_tracepoint() ?

I'm hearing your arguments as that now changes to all exported functions
need to be "solid" (not sure what exactly means 'solid' here) to
justify breakage of out-of-tree modules?

re: 'added complexity'...
-       for (iter = begin; iter < end; iter++)
-               fct(*iter, priv);
+               return NULL;
+       for (iter = begin; iter < end; iter++) {
+               ret = fct(*iter, priv);
+               if (ret)
+                       return ret;
+       }
+       return NULL;

where do you see 'added complexity' ?
Isn't the above diff self-explanatory that for_each_tracepoint_range()
can be used not only to iterate over all tracepoints
(just do 'return NULL') from callback _and_ to find one particular
tracepoint as patch 7 does ?
