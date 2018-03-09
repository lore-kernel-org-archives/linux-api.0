From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 19:45:11 +0000
Message-ID: <CALCETrUU-456u3R=D08fuJFEiiMLB3n=jdCTxvLqbSGA87r-9A@mail.gmail.com>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net> <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
 <20180309.135724.452219538059491199.davem@davemloft.net> <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
 <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Alexei Starovoitov <ast@fb.com>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 9, 2018 at 7:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Mar 9, 2018 at 11:12 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> How are you going to handle five processes doing the same setup concurrently?
>
> Side note: it's not just serialization. It's also "is it actually up
> and running".
>

I think the right way to solve this would be to take a hint from
systemd's socket activation model.  The current patch had the module
load process kick off an ELF binary that goes an registers itself to
handle something.  We can turn that around.  Make the module init
function create the socket (or pipe or whatever) receives request and
pass it to the user program as stdin.  Then the kernel can start
queueing requests into the socket immediately, and the user program
will get to them whenever it finishes initializing.  Or it can write
some message to the socket saying "hey, I'm ready".

This also completely avoids the issue where some clever user manually
loads the "module" with exec() ("hey, I'm so clever, I can just run
the damn thing instead if using init_module()!" or writes an
out-of-tree program that uses whatever supposedly secret API the
in-kernel binary is supposed to use to register itself (and I know
people who would do exactly that!) and the kernel does
request_module() at roughly the same time.
