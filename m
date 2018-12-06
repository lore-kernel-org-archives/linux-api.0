From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Thu, 06 Dec 2018 19:56:44 +0100
Message-ID: <87y392h4b7.fsf@oldenburg2.str.redhat.com>
References: <20181120105124.14733-1-christian@brauner.io>
        <87in0g5aqo.fsf@oldenburg.str.redhat.com>
        <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io>
        <20181202100304.labt63mzrlr5utdl@brauner.io>
        <8736rebl9s.fsf@oldenburg.str.redhat.com>
        <20181203180224.fkvw4kajtbvru2ku@brauner.io>
        <874lbtjvtd.fsf@oldenburg2.str.redhat.com>
        <CALCETrViXJ0gD34yVd8QpB-CSeKZzzncvkPHReycTiQin4r4WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrViXJ0gD34yVd8QpB-CSeKZzzncvkPHReycTiQin4r4WQ@mail.gmail.com>
        (Andy Lutomirski's message of "Thu, 6 Dec 2018 10:54:02 -0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <christian@brauner.io>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

* Andy Lutomirski:

>> I suppose that's fine.  Or alternatively, when thread group support is
>> added, introduce a flag that applications have to use to enable it, so
>> that they can probe for support by checking support for the flag.
>>
>> I wouldn't be opposed to a new system call like this either:
>>
>>  int procfd_open (pid_t thread_group, pid_t thread_id, unsigned flags);
>>
>> But I think this is frowned upon on the kernel side.
>
> I have no problem with it, except that I think it shouldn’t return an
> fd that can be used for proc filesystem access.

Oh no, my intention was that it would just be used with  *_send_signal
and related functions.

Thanks,
Florian
