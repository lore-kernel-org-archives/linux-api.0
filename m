From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Fri, 07 Dec 2018 08:03:45 +1300
Message-ID: <C5E71146-DE79-4145-B54B-E161E7372D95@brauner.io>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com> <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io> <20181202100304.labt63mzrlr5utdl@brauner.io> <8736rebl9s.fsf@oldenburg.str.redhat.com> <20181203180224.fkvw4kajtbvru2ku@brauner.io> <874lbtjvtd.fsf@oldenburg2.str.redhat.com> <CALCETrViXJ0gD34yVd8QpB-CSeKZzzncvkPHReycTiQin4r4WQ@mail.gmail.com> <87y392h4b7.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87y392h4b7.fsf@oldenburg2.str.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man <linux-man@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On December 7, 2018 7:56:44 AM GMT+13:00, Florian Weimer <fweimer@redhat=2E=
com> wrote:
>* Andy Lutomirski:
>
>>> I suppose that's fine=2E  Or alternatively, when thread group support
>is
>>> added, introduce a flag that applications have to use to enable it,
>so
>>> that they can probe for support by checking support for the flag=2E
>>>
>>> I wouldn't be opposed to a new system call like this either:
>>>
>>>  int procfd_open (pid_t thread_group, pid_t thread_id, unsigned
>flags);
>>>
>>> But I think this is frowned upon on the kernel side=2E
>>
>> I have no problem with it, except that I think it shouldn=E2=80=99t ret=
urn an
>> fd that can be used for proc filesystem access=2E
>
>Oh no, my intention was that it would just be used with  *_send_signal
>and related functions=2E

Let's postpone that discussion a little=2E
I think we don't need a syscall to base this off of pids=2E
As I said I rather send my revived version of CLONE_NEWFD that would serve=
 the same task=2E
The same way we could also just add a new open() flag that blocks fs acces=
s completely=2E
I just pitched that idea to Serge a few days back: O_NOCHDIR or similar=2E
That could even be part of Aleksa's path resolution patchset=2E

>
>Thanks,
>Florian
