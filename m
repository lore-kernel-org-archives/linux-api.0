From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Thu, 22 Mar 2018 15:21:33 -0700
Message-ID: <fbc7ef7a-83fe-67ab-3637-c064edf63cb8@fb.com>
References: <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <E459E6CC-F51B-4F2A-9D26-FFB7166E0A47@amacapital.net>
 <CA+55aFx7w1s7=5HzeczPkkksaU4oVsWQf+_c=aHS0O7i_9g+Kg@mail.gmail.com>
 <20180309.135724.452219538059491199.davem@davemloft.net>
 <CA+55aFyN8JDh76bm1VinBvrgMH5jNL6RbuFAkrH8vuYU1s9GDQ@mail.gmail.com>
 <CA+55aFx-kDp87_uv9TW5pYD2+nr8c65=ervvwcxhTBJVg7c_pQ@mail.gmail.com>
 <81b7599d-aab7-6cb6-7843-64510c8f6260@fb.com>
 <20180310140843.GP4449@wotan.suse.de> <20180310151652.GV4449@wotan.suse.de>
 <20180322205413.GA30543@wotan.suse.de>
 <CALCETrWFhTurv0gwxRcdLn4CD-1ySE=v4ZgvbsUYJqruZNMptQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWFhTurv0gwxRcdLn4CD-1ySE=v4ZgvbsUYJqruZNMptQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Djalal Harouni <tixxdz@gmail.com>, David Miller <davem@davemloft.net>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Hannes Reinecke <hare@suse.com>, werner@suse.com
List-Id: linux-api@vger.kernel.org

On 3/22/18 3:15 PM, Andy Lutomirski wrote:
> On Thu, Mar 22, 2018 at 8:54 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> If we can ensure that these usermode modules don't take *any time at all* on
>> their init *from the start*, it would be wonderful and we'd end up avoiding
>> some really odd corner case issues later.
>>
>
> I don't see why this issue needs to exist at all for the new stuff.
> After all, the new things aren't usermode modules per se.  They're
> regular kernel code (modular or otherwise) that loads a usermode
> helper.  All we need to do is to make sure that, if this is
> distributed as a module, that it's init routine doesn't wait for a
> long time, right?

I've implemented all of the previous suggestions and
now there are zero changes to kernel/module.c
I still need to finish tracpoint stuff first and polish umh code a bit
before sending new version.
Let's hold on this thread until then.
