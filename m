From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v7 4/9] seccomp: move no_new_privs into seccomp
Date: Tue, 24 Jun 2014 12:20:59 -0700
Message-ID: <CALCETrVgpP=zOtiQafVgcic2T95TdEM5DTvHYXWTbcZ14xBqHQ@mail.gmail.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org>
 <1403560693-21809-5-git-send-email-keescook@chromium.org> <20140624191815.GA3623@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140624191815.GA3623@redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@plumgrid.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, X86 ML <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 24, 2014 at 12:18 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 06/23, Kees Cook wrote:
>>
>> --- a/include/linux/seccomp.h
>> +++ b/include/linux/seccomp.h
>> @@ -3,6 +3,8 @@
>>
>>  #include <uapi/linux/seccomp.h>
>>
>> +#define SECCOMP_FLAG_NO_NEW_PRIVS    0       /* task may not gain privs */
>> +
>>  #ifdef CONFIG_SECCOMP
>>
>>  #include <linux/thread_info.h>
>> @@ -16,6 +18,7 @@ struct seccomp_filter;
>>   *         system calls available to a process.
>>   * @filter: must always point to a valid seccomp-filter or NULL as it is
>>   *          accessed without locking during system call entry.
>> + * @flags: flags under task->sighand->siglock lock
>>   *
>>   *          @filter must only be accessed from the context of current as there
>>   *          is no read locking.
>> @@ -23,6 +26,7 @@ struct seccomp_filter;
>>  struct seccomp {
>>       int mode;
>>       struct seccomp_filter *filter;
>> +     unsigned long flags;
>>  };
>>
>>  extern int __secure_computing(int);
>> @@ -51,7 +55,9 @@ static inline int seccomp_mode(struct seccomp *s)
>>
>>  #include <linux/errno.h>
>>
>> -struct seccomp { };
>> +struct seccomp {
>> +     unsigned long flags;
>> +};
>
> A bit messy ;)
>
> I am wondering if we can simply do
>
>         static inline bool current_no_new_privs(void)
>         {
>                 if (current->no_new_privs)
>                         return true;
>
>         #ifdef CONFIG_SECCOMP
>                 if (test_thread_flag(TIF_SECCOMP))
>                         return true;
>         #endif

Nope -- privileged users can enable seccomp w/o nnp.

--Andy
