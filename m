From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 13:04:43 -0400
Message-ID: <20180326130443.77473b6d@gandalf.local.home>
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
        <b07ea9b4-6b73-60aa-9391-002db42c571b@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <b07ea9b4-6b73-60aa-9391-002db42c571b@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 09:47:21 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> I don't mind to _rename_ for_each_kernel_tracepoint() into
> tracepoint_find_by_name(), but keeping exported function
> just to be used by out-of-tree modules would be wrong message for
> the kernel community in general.
> With my patch the for_each_kernel_tracepoint() will be used by bpf side
> and out-of-tree can trivially hack their callbacks to keep working.
> imo that's a better approach then renaming it.

Look, the tracepoint code was written by Mathieu for LTTng, and perf
and ftrace were able to benefit because of it, as well as your bpf code.
For this, we agreed to keep this function around for his use, as its the
only thing he requires. Everyone has been fine with that. Not all out
of tree code is evil. In fact, some out of tree modules help the kernel
community. You ask why I care. Because PREEMPT_RT has been one of those
out of tree modules that has helped the kernel community a lot. Have
you noticed that there are "raw_spin_lock()" and "spin_lock()"? There's
no difference between the two in the kernel. Why have them? Because
they are used by PREEMPT_RT.

Having that function for LTTng does not hurt us. And I will NACK
removing it.

-- Stevwe
