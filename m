From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Fri, 9 Mar 2018 10:43:04 -0800
Message-ID: <CAGXu5jJcuSojm_KN5+JQ3fV6J09V6dmNB6haqu11xkXTq=nxog@mail.gmail.com>
References: <C94A45E9-54A0-446D-86D6-82D06E2A35CD@amacapital.net>
 <87478c51-59a7-f6ac-1fb2-f3ca2dcf658b@fb.com> <CA+55aFwfcXzD+pzjN=vTcvscpK97pSztUZ2JK7pABs+rMtM7BQ@mail.gmail.com>
 <20180309.133509.1275903267249306409.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309.133509.1275903267249306409.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexei Starovoitov <ast@fb.com>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, Daniel Borkmann <daniel@iogearbox.net>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Mar 9, 2018 at 10:35 AM, David Miller <davem@davemloft.net> wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Fri, 9 Mar 2018 10:17:42 -0800
>
>>  - use deny_write_access() to make sure that we don't have active
>> writers and cannot get them during the execve.
>
> I agree that this is necessary for image validation purposes.

Module loading (via kernel_read_file()) already uses
deny_write_access(), and so does do_open_execat(). As long as module
loading doesn't call allow_write_access() before the execve() has
started in the new implementation, I think we'd be covered here.

-Kees

-- 
Kees Cook
Pixel Security
