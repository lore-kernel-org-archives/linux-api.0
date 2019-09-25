From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: For review: pidfd_send_signal(2) manual page
Date: Wed, 25 Sep 2019 15:46:09 +0200
Message-ID: <b2519fb3-8bf5-d821-ae48-dad4435330f4@gmail.com>
References: <f21dbd73-5ef4-fb5b-003f-ff4fec34a1de@gmail.com>
 <87pnjr9rth.fsf@mid.deneb.enyo.de>
 <20190923142325.jowzbnwjw7g7si7j@wittgenstein>
 <90dd38d5-34b3-b72f-8e5a-b51f944f22fb@gmail.com>
 <20190924195701.7pw2olbviieqsg5q@wittgenstein>
 <b76adb4c-826b-6493-ba75-a9863066d3b1@gmail.com>
 <CAKOZueuJ=En9=mtFvhpmsnjqMAOjVmffaVwwzpe=ieHemxH3mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKOZueuJ=En9=mtFvhpmsnjqMAOjVmffaVwwzpe=ieHemxH3mw@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: mtk.manpages@gmail.com, Christian Brauner <christian.brauner@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Joel Fernandes <joel@joelfernandes.org>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello Daniel,

On 9/24/19 11:08 PM, Daniel Colascione wrote:
> On Tue, Sep 24, 2019 at 2:00 PM Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>>
>> Hello Christian,
>>
>>>>> If you're the parent of the process you can do this without CLONE_PIDFD:
>>>>> pid = fork();
>>>>> pidfd = pidfd_open();
>>>>> ret = pidfd_send_signal(pidfd, 0, NULL, 0);
>>>>> if (ret < 0 && errno == ESRCH)
>>>>>     /* pidfd refers to another, recycled process */
>>>>
>>>> Although there is still the race between the fork() and the
>>>> pidfd_open(), right?
>>>
>>> Actually no and my code is even too complex.
>>> If you are the parent, and this is really a sequence that obeys the
>>> ordering pidfd_open() before waiting:
>>>
>>> pid = fork();
>>> if (pid == 0)
>>>       exit(EXIT_SUCCESS);
>>> pidfd = pidfd_open(pid, 0);
>>> waitid(pid, ...);
>>>
>>> Then you are guaranteed that pidfd will refer to pid. No recycling can
>>> happen since the process has not been waited upon yet (That is,
>>
>> D'oh! Yes, of course.
> 
> You still have a race if you're the parent and you have SIGCHLD set to
> SIG_IGN though.

Yes, thanks for reminding me of that (as did Christian also).

>>> excluding special cases such as where you have a mainloop where a
>>> callback reacts to a SIGCHLD event and waits on the child behind your
>>> back and your next callback in the mainloop calls pidfd_open() while the
>>> pid has been recycled etc.).
> 
> That's a pretty common case though, especially if you're a library.

I presume that conventionally the only real resolution of this kind of
problem is that the mainloop SIGCHLD call back has a waitpid() loop
that (in a nonblocking fashion) loops checking each of the PIDs created
by the mainloop, right?

>>> A race could only appear in sequences where waiting happens before
>>> pidfd_open():
>>>
>>> pid = fork();
>>> if (pid == 0)
>>>       exit(EXIT_SUCCESS);
>>> waitid(pid, ...);
>>> pidfd = pidfd_open(pid, 0);
>>>
>>> which honestly simply doesn't make any sense. So if you're the parent
>>> and you combine fork() + pidfd_open() correctly things should be fine
>>> without even having to verify via pidfd_send_signal() (I missed that in
>>> my first mail.).
>>
>> Thanks for the additional detail.
>>
>> I added the following to the pidfd_open() page, to
>> prevent people making the same thinko as me:
>>
>>        The following code sequence can be used to obtain a file  descrip‐
>>        tor for the child of fork(2):
>>
>>            pid = fork();
>>            if (pid > 0) {     /* If parent */
>>                pidfd = pidfd_open(pid, 0);
>>                ...
>>            }
>>
>>        Even  if  the  child process has already terminated by the time of
>>        the pidfd_open() call, the returned file descriptor is  guaranteed
>>        to refer to the child because the parent has not yet waited on the
>>        child (and therefore, the child's ID has not been recycled).
> 
> I'd prefer that sample code be robust in all cases.

I'm not clear what you think is missing. Or do you mean that the code
can't be robust in the face of (1) waitpid(-1) in another thread or an
asynchronous SIGCHLD handler and (2) SIGCHLD disposition set to SIG_IGN?

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
