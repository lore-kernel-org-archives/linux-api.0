From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 11:38:25 -0800
Message-ID: <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net> <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
 <20180309.135724.452219538059491199.davem@davemloft.net> <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 9, 2018 at 11:12 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> How are you going to handle five processes doing the same setup concurrently?

Side note: it's not just serialization. It's also "is it actually up
and running".

The rule for "request_module()" (for a real module) has been that it
returns when the module is actually alive and active and have done
their initcalls.

The UMH_WAIT_EXEC behavior (ignore the serialization - you could do
that in the caller) behavior doesn't actually have any semantics AT
ALL. It only means that you get the error returns from execve()
itself, so you know that the executable file actually existed and
parsed right enough to get started.

But you don't actually have any reason to believe that it has *done*
anything, and started processing any requests. There's no reason
what-so-ever to believe that it has registered itself for any
asynchronous requests or anything like that.

So in the real module case, you can do

    request_module("modulename");

and just start using whatever resource you just requested. So the
netfilter code literally does

                request_module("nft-chain-%u-%.*s", family,
                               nla_len(nla), (const char *)nla_data(nla));
                nfnl_lock(NFNL_SUBSYS_NFTABLES);
                type = __nf_tables_chain_type_lookup(nla, family);
                if (type != NULL)
                        return ERR_PTR(-EAGAIN);

and doesn't even care about error handling for request_module()
itself, because it knows that either the module got loaded and is
ready, or something failed. And it needs to look that chain type up
anyway, so the failure is indicated by _that_.

With a UMH_WAIT_EXEC? No. You have *nothing*. You know the thing
started, but it might have SIGSEGV'd immediately, and you have
absolutely no way of knowing, and absolutely no way of even figuring
it out. You can wait - forever - for something to bind to whatever
dynamic resource you're expecting. You'll just fundamentally never
know.

You can try again, of course. Add a timeout, and try again in five
seconds or something. Maybe it will work then. Maybe it won't. You
won't have any way to know the _second_ time around either. Or the
third. Or...

See why I say it has to be synchronous?

If it's synchronous, you can actually do things like

 (a) maybe you only need a one-time thing, and don't have any state
("load fixed tables, be done") and that's it. If the process returns
with no error code, you're all done, and you know it's fine.

 (b) maybe the process wants to start a listener daemon or something
like the traditional inetd model. It can open the socket, it can start
listening on it, and it can fork off a child and check it's status. It
can then do exit(0) if everything is fine, and now request_module()
returns.

see the difference? Even if you ended up with a background process
(like in that (b) case), you did so with *error* handling, and you did
so knowing that the state has actually been set up by the time the
request_module() returns.

And if you use the proper module loading exclusion, it also means that
that (b) can know it's the only process starting up, and it's not
racing with another one.  It might still want to do the usual
lock-files in user space to protect against just the admin starting it
manually, but at least you don't have the situation that a hundred
threads just had a thundering herd where they all ended up using the
same kernel facility, and they all independently started a hundred
usermode helpers.

                  Linus
