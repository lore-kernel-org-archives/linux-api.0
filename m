From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v2 bpf-next 5/8] bpf: introduce BPF_RAW_TRACEPOINT
Date: Mon, 26 Mar 2018 09:53:55 +0200
Message-ID: <64eb079d-caa0-9c5c-5cdf-02bba8a6a555@iogearbox.net>
References: <20180321185448.2806324-1-ast@fb.com>
 <20180321185448.2806324-6-ast@fb.com>
 <580e6dcd-7deb-9fe2-5e37-6ce9ad0593a4@iogearbox.net>
 <79700812-58e2-2534-081e-015db6630155@fb.com>
 <eb46ee44-3010-4c4e-1020-9b4fbdd34101@iogearbox.net>
 <50520d4a-1c07-9cca-068c-9bc737c7785f@fb.com>
 <cea19b0f-0420-0620-2240-954a81e22659@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cea19b0f-0420-0620-2240-954a81e22659@fb.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>, davem@davemloft.net
Cc: torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 03/24/2018 02:43 AM, Alexei Starovoitov wrote:
> On 3/23/18 5:58 PM, Alexei Starovoitov wrote:
>> On 3/23/18 4:13 PM, Daniel Borkmann wrote:
>>> On 03/22/2018 04:41 PM, Alexei Starovoitov wrote:
>>>> On 3/22/18 2:43 AM, Daniel Borkmann wrote:
>>>>> On 03/21/2018 07:54 PM, Alexei Starovoitov wrote:
[...]
>>>> I picked 6 as a good compromise and used it twice in bpf_trace_run1x()
>>>> Similar thing possible for u64 arg1, u64 arg2, ...
>>>> but it will be harder to read.
>>>> Looking forward what you can come up with.
>>>
>>> Just took a quick look, so the below one would work for generating the
>>> signature and function. I did till 9 here:
>>>
>>> #define UNPACK(...)            __VA_ARGS__
>>> #define REPEAT_1(FN, DL, X, ...)    FN(X)
>>> #define REPEAT_2(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_1(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT_3(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_2(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT_4(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_3(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT_5(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_4(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT_6(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_5(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT_7(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_6(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT_8(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_7(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT_9(FN, DL, X, ...)    FN(X) UNPACK DL REPEAT_8(FN, DL,
>>> __VA_ARGS__)
>>> #define REPEAT(X, FN, DL, ...)        REPEAT_##X(FN, DL, __VA_ARGS__)
>>>
>>> #define SARG(X)        u64 arg##X
>>> #define COPY(X)        args[X] = arg##X
>>>
>>> #define __DL_COM    (,)
>>> #define __DL_SEM    (;)
>>>
>>> #define __SEQ        0, 1, 2, 3, 4, 5, 6, 7, 8, 9
>>>
>>> #define BPF_TRACE_DECL_x(x)                        \
>>>     void bpf_trace_run##x(struct bpf_prog *prog,            \
>>>                   REPEAT(x, SARG, __DL_COM, __SEQ))
>>> #define BPF_TRACE_DEFN_x(x)                        \
>>>     void bpf_trace_run##x(struct bpf_prog *prog,            \
>>>                   REPEAT(x, SARG, __DL_COM, __SEQ))        \
>>>     {                                \
>>>         u64 args[x];                        \
>>>         REPEAT(x, COPY, __DL_SEM, __SEQ);            \
>>>         __bpf_trace_run(prog, args);                \
>>>     }                                \
>>>     EXPORT_SYMBOL_GPL(bpf_trace_run##x)
>>>
>>> So doing a ...
>>>
>>> BPF_TRACE_DECL_x(5);
>>> BPF_TRACE_DEFN_x(5);
>>
>> interestingly that in addition to above defining
>> #define __REPEAT(X, FN, DL, ...) REPEAT_##X(FN, DL, __VA_ARGS__)
>> to allow recursive expansion and doing
>> __REPEAT(12, BPF_TRACE_DECL_x, __DL_SEM, __SEQ_1_12);
>> almost works...
>> I'm guessing it's hitting preprocessor internal limit on
>> number of expressions to expand.
>> It expands 1-6 nicely and 7-12 are partially expanded :)
> 
> it's not the limit I'm hitting, but self referential issue.
> Exactly half gets expanded.
> I don't think there is an easy workaround other
> than duplicating the whole chain of REPEAT macro twice
> with slightly different name.

Hmm, that is kind of annoying, probably worth filing a bug on gcc, we still
won't be able to use it near term though.

Given it expands just fine from 1-6 arguments, I think Steven had a good
choice on upper limit of 6 args then (including build error with above). ;-)

Thanks,
Daniel
