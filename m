From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf
 binaries
Date: Fri, 9 Mar 2018 10:50:49 -0800
Message-ID: <74e26cc0-9e72-f03b-5396-f3480921f234@fb.com>
References: <CALCETrX=Vfk1T-XegwnjtUqeEsyUFXH1744d0yGkufQvDA5xkQ@mail.gmail.com>
 <CA+55aFwJPDub+tdShCgeTz3UejeskVE7_x+eQLq75mCjYPyP8w@mail.gmail.com>
 <CAGXu5j+B4wgT3ovynAxa1zwCeROfN5zK45tL1FUnFh0sg8M5AA@mail.gmail.com>
 <CA+55aFwRGDPvaCUgMtqnQHb2PZ77JSMQMQVf1znSN+PiV7NR-Q@mail.gmail.com>
 <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
 <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com>
 <CALCETrWKLB4e8Cw6ZRiDP535=HzoQJczsEMEpytstveO15mAMg@mail.gmail.com>
 <6d2e31fa-d87b-fea6-c919-b7d066bb0385@fb.com>
 <CALCETrX+oGQthnk5AR0MUJwLLwguWG_yq_r9QQPhUYjvz9jyPw@mail.gmail.com>
 <c9388b10-19ac-0bd5-4986-9c306d23046e@fb.com>
 <20180309181527.GA15803@kroah.com>
 <E622B120-3C3A-4A15-8E1B-6F7649038623@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E622B120-3C3A-4A15-8E1B-6F7649038623@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>, Greg KH <gregkh@linuxfoundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Daniel Borkmann <daniel@iogearbox.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/9/18 10:23 AM, Andy Lutomirski wrote:
>
>
>> On Mar 9, 2018, at 10:15 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>
>>
>> Oh, and for the record, I like Andy's proposal as well as dumping this
>> into a kernel module "blob" with the exception that this now would take
>> up unswapable memory, which isn't the nicest and is one big reason we
>> removed the in-kernel-memory firmware blobs many years ago.
>>
>
> It might not be totally crazy to back it by tmpfs.

interesting. how do you propose to do it?
Something like:
- create /umh_module_tempxxx dir
- mount tmpfs there
- copy elf into it and exec it?
