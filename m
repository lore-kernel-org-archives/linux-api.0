From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH RFC v3 4/7] proc: support mounting private procfs
 instances inside same pid namespace
Date: Fri, 10 Nov 2017 11:33:47 +0100
Message-ID: <CAEiveUfOoQVNnq0tRVEDJsqBHX99uMHwK3eRJKneuh+ERo7D6w@mail.gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
 <1510244046-3256-5-git-send-email-tixxdz@gmail.com> <alpine.LFD.2.20.1711101352580.8844@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.20.1711101352580.8844@localhost>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, "Tobin C. Harding" <me@tobin.cc>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-fo>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 3:53 AM, James Morris <james.l.morris@oracle.com> wrote:
> On Thu, 9 Nov 2017, Djalal Harouni wrote:
>
>> This should allow later after real testing to have a smooth transition
>> to a procfs with default private instances.
>>
>> [1] https://lists.linuxfoundation.org/pipermail/ksummit-discuss/2017-January/004215.html
>> [2] http://www.openwall.com/lists/kernel-hardening/2017/10/05/5
>> [3] https://lwn.net/Articles/689539/
>> [4] http://lxr.free-electrons.com/source/Documentation/filesystems/devpts.txt?v=3.14
>> [5] https://lkml.org/lkml/2017/5/2/407
>> [6] https://lkml.org/lkml/2017/5/3/357
>>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Suggested-by: Andy Lutomirski <luto@kernel.org>
>> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
>> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
>
>
> Reviewed-by: James Morris <james.l.morris@oracle.com>

Thank you James!


-- 
tixxdz
