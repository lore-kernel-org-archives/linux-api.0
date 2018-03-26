From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 bpf-next 06/10] tracepoint: compute num_args at build
 time
Date: Mon, 26 Mar 2018 14:48:21 -0400
Message-ID: <20180326144821.20f6b0de@gandalf.local.home>
References: <20180324023038.938665-1-ast@fb.com>
        <1787605856.4574.1522077244597.JavaMail.zimbra@efficios.com>
        <5bcacdb5-e72f-b67a-4884-61fcedf0938a@fb.com>
        <523311773.184.1522079745421.JavaMail.zimbra@efficios.com>
        <f39181e0-3d46-2154-044c-dfc985053b3a@fb.com>
        <1055377367.195.1522081045131.JavaMail.zimbra@efficios.com>
        <89fbc745-c290-c82c-a837-8998cf2988e7@fb.com>
        <20180326123530.66ced6ae@gandalf.local.home>
        <1218234422.259.1522083422808.JavaMail.zimbra@efficios.com>
        <17073efa-d833-7348-bef1-79376ad43bc6@fb.com>
        <20180326141104.6d63660a@gandalf.local.home>
        <543f953a-8284-68f0-6a22-ec2d5f247199@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <543f953a-8284-68f0-6a22-ec2d5f247199@fb.com>
Sender: netdev-owner@vger.kernel.org
To: Alexei Starovoitov <ast@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, netdev <netdev@vger.kernel.org>, kernel-team <kernel-team@fb.com>, linux-api <linux-api@vger.kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>
List-Id: linux-api@vger.kernel.org

On Mon, 26 Mar 2018 11:39:05 -0700
Alexei Starovoitov <ast@fb.com> wrote:

> On 3/26/18 11:11 AM, Steven Rostedt wrote:
> > On Mon, 26 Mar 2018 10:55:51 -0700
> > Alexei Starovoitov <ast@fb.com> wrote:
> >  
> >> An email ago you were ok to s/return/return NULL/ in your out-of-tree
> >> module, but now flip flop to add new function approach just to
> >> reduce the work you need to do in lttng?
> >> We're not talking about changing __kmalloc signature here.
> >> My patch extends for_each_kernel_tracepoint() api similar to other
> >> for_each_*() iterators and improves possible uses of it.  
> >
> > Alexei, do you have another use case for using
> > for_each_kernel_tracepoint() other than the find_tp? If so, then I'm
> > sure Mathieu can handle the change.
> >
> > But I think it's cleaner to add a tracepoint_find_by_name() function.
> > If you come up with another use case for using the for_each* function
> > then we'll consider changing it then.  
> 
> another use case ?! Frankly such reasoning smells.

WTF is the big deal here?

> 
> I'm fine doing quick followup patch to add tracepoint_find_by_name()

And BTW, it would actually have to be called
tracepoint_core_find_by_name() as it will not deal with modules.
Modules would have to have much more work to deal with.

> and restore 'return void' behavior of for_each_kernel_tracepoint's

What? you can't rebase now? Just don't touch that function.

> callback, but I'm struggling to accept the precedent it will create
> that all exported functions of kernel/tracepoint.c are really
> lttng extensions and we cannot easily change them.

First, my argument about your use case has little to do with LTTng.
I have to maintain this code, and this is my preference. Just like I do
the silly

 /* Comment like this,
  * for multiple lines
  */

When I deal with the networking code. Because that's the preference for
the networking folks.

> I'd like to hear Linus take on this.

I doubt he cares about something this petty.

-- Steve
