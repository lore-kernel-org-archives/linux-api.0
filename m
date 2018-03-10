From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 9 Mar 2018 18:34:18 -0800
Message-ID: <81b7599d-aab7-6cb6-7843-64510c8f6260@fb.com>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
 <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
 <20180309.135724.452219538059491199.davem@davemloft.net>
 <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
 <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/9/18 11:38 AM, Linus Torvalds wrote:
> On Fri, Mar 9, 2018 at 11:12 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> How are you going to handle five processes doing the same setup concurrently?
>
> Side note: it's not just serialization. It's also "is it actually up
> and running".
>
> The rule for "request_module()" (for a real module) has been that it
> returns when the module is actually alive and active and have done
> their initcalls.
>
> The UMH_WAIT_EXEC behavior (ignore the serialization - you could do
> that in the caller) behavior doesn't actually have any semantics AT
> ALL. It only means that you get the error returns from execve()
> itself, so you know that the executable file actually existed and
> parsed right enough to get started.
>
> But you don't actually have any reason to believe that it has *done*
> anything, and started processing any requests. There's no reason
> what-so-ever to believe that it has registered itself for any
> asynchronous requests or anything like that.
>
> So in the real module case, you can do
>
>     request_module("modulename");
>
> and just start using whatever resource you just requested. So the
> netfilter code literally does
>
>                 request_module("nft-chain-%u-%.*s", family,
>                                nla_len(nla), (const char *)nla_data(nla));
>                 nfnl_lock(NFNL_SUBSYS_NFTABLES);
>                 type = __nf_tables_chain_type_lookup(nla, family);
>                 if (type != NULL)
>                         return ERR_PTR(-EAGAIN);
>
> and doesn't even care about error handling for request_module()
> itself, because it knows that either the module got loaded and is
> ready, or something failed. And it needs to look that chain type up
> anyway, so the failure is indicated by _that_.
>
> With a UMH_WAIT_EXEC? No. You have *nothing*. You know the thing
> started, but it might have SIGSEGV'd immediately, and you have
> absolutely no way of knowing, and absolutely no way of even figuring
> it out. You can wait - forever - for something to bind to whatever
> dynamic resource you're expecting. You'll just fundamentally never
> know.
>
> You can try again, of course. Add a timeout, and try again in five
> seconds or something. Maybe it will work then. Maybe it won't. You
> won't have any way to know the _second_ time around either. Or the
> third. Or...
>
> See why I say it has to be synchronous?
>
> If it's synchronous, you can actually do things like
>
>  (a) maybe you only need a one-time thing, and don't have any state
> ("load fixed tables, be done") and that's it. If the process returns
> with no error code, you're all done, and you know it's fine.

I agree that sync approach nicely fits this use case, but waiting
for umh brings the whole set of suspend/resume issues that
Luis explained earlier and if I understood his points that stuff
is still not quite working right and he's planning a set of fixes.
I really don't want the unknown timeline of fixes for 'waiting umh'
to become a blocker for the bpfilter project ...

>  (b) maybe the process wants to start a listener daemon or something
> like the traditional inetd model. It can open the socket, it can start
> listening on it, and it can fork off a child and check it's status. It
> can then do exit(0) if everything is fine, and now request_module()
> returns.

... while for bpfilter use case we need a daemon and starting umh
with UMH_WAIT_PROC which does fork() right away and parent does exit(0)
is not any different from kernel pov than UMH_WAIT_EXEC.
The kernel will be in the same situation described above. The forked
process could have sigsegv quickly (right after telling parent that
everything is ok) and kernel is waiting forever.

That situation is what I was alluding to regarding that kernel<->umh
need to have some sort of health check protocol.
Regardless of how umh is invoked.

I think what Andy proposing with kernel creating a pipe and giving
it to umh can be used as this health check and means of
'load exclusion' to make sure that only one requested umh is running.

Also I like Luis suggestion to use some other name than request_module()
Something like:
request_umh_module_sync("foo");
request_umh_module_nowait("foo");

in both cases the kernel would create a pipe, call umh either
with UMH_WAIT_PROC or UMH_WAIT_EXEC and make sure that umh
responds to first hello message.
On success they would return a handle to that pipe and umh's pid.
The further interaction between the kernel and umh will be
via that pipe. If kernel->umh request times out the kernel
side of bpfilter would sigkill the task and do request_umh() again.
If that request_umh() fails there will be no retry, since
at this point it's clear that given umh is broken.

I'll implement only _nowait() version, since that's what we need
for bpfilter and when suspend/resume issues are solved somebody
who cares about usb driver in user mode can implement the _sync()
variant.

All that on top of tmpfs->file->execve_file hack that I still
need feedback on.
