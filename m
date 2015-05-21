From: Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: [PATCH net-next 1/4] bpf: allow bpf programs to tail-call other
 bpf programs
Date: Thu, 21 May 2015 09:40:51 -0700
Message-ID: <555E0A93.2020803@plumgrid.com>
References: <1432079946-9878-1-git-send-email-ast@plumgrid.com> <1432079946-9878-2-git-send-email-ast@plumgrid.com> <CALCETrVP=7sCM12cCZVZCCMozGcHyqTsOFvjv7cEpc7Frxj4Xg@mail.gmail.com> <555BD2E4.5050608@plumgrid.com> <CALCETrVNwOVRJ4KH6mEo4hPq_QjTCb8mcwRf1sy5kd1nmnSZ+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CALCETrVNwOVRJ4KH6mEo4hPq_QjTCb8mcwRf1sy5kd1nmnSZ+A@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Michael Holzheu <holzheu@linux.vnet.ibm.com>, Zi Shen Lim <zlim.lnx@gmail.com>, Linux API <linux-api@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 5/21/15 9:20 AM, Andy Lutomirski wrote:
>
> What I mean is: why do we need the interface to be "look up this index
> in an array and just to what it references" as a single atomic
> instruction?  Can't we break it down into first "look up this index in
> an array" and then "do this tail call"?

I've actually considered to do this split and do first part as map 
lookup and 2nd as 'tail call to this ptr' insn, but it turned out to be
painful: verifier gets more complicated, ctx pointer needs to kept
somewhere, JITs need to special case two things instead of one.
Also I couldn't see a use case for exposing program pointer to the
program itself. I've explored this path only because it felt more
traditional 'goto *ptr' like, but adding new PTR_TO_PROG type to
verifier looked wasteful.

> I don't see why everything needs to be a map.

I mentioned the reasons to use map abstraction in the commit log:
"- jump table is implemented as BPF_MAP_TYPE_PROG_ARRAY to reuse 'map'
   abstraction, its user space API and all of verifier logic.
   It's in the existing arraymap.c file, since several functions are
   shared with regular array map."

The other alternative would be to add new thing just for jump table,
but it means extending syscall commands and propagating the callchain
through several files plus adding all new interfaces to user space.
I think 'map' abstraction fits very well. We have 'array' map
which is one-to-one to normal C array. This is just different type
of array that stores prog_fds.
When in C you're creating 'void *jmptable[] = { &&label1, &&label2};'
it is still an array. So here you have special type PROG_ARRAY for it
to make verifier recognize it.
