From: Djalal Harouni <tixxdz@gmail.com>
Subject: Re: [PATCH RFC v3 1/7] proc: add proc_fs_info struct to store proc information
Date: Fri, 10 Nov 2017 11:32:55 +0100
Message-ID: <CAEiveUdj=PbJ6pGAX-wr3Fz+4=y6QbiDSE=mU6yKwxn11OU_gw@mail.gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
 <1510244046-3256-2-git-send-email-tixxdz@gmail.com> <CACVxJT88zLoekiwFxq1rdDEnFxPnpZeDYHOWEVQEwHZvFdOy4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CACVxJT88zLoekiwFxq1rdDEnFxPnpZeDYHOWEVQEwHZvFdOy4A@mail.gmail.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, "Tobin C. Harding" <me@tobin.cc>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmica>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 10, 2017 at 11:26 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On 11/9/17, Djalal Harouni <tixxdz@gmail.com> wrote:
>
>> +struct proc_fs_info {
>> +     struct pid_namespace *pid_ns;
>> +};
>
>> +static inline struct proc_fs_info *proc_sb(struct super_block *sb)
>> +{
>> +     return sb->s_fs_info;
>> +}
>
> Can you rename this to "struct proc_super_block *" then?
> That "info" suffix all over filesystems doesn't add much info itself
> just more typing.
> Ditto for "fs_info" identifiers.

Ok, will do.

>> +extern inline struct proc_fs_info *proc_sb(struct super_block *sb)
>> { return NULL;}
>
> extern inline?

Oups, sorry will fix it and try to compile without proc.

Thank you!

-- 
tixxdz
