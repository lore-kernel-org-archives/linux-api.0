From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 0/4] Improved seccomp logging
Date: Tue, 2 May 2017 09:14:41 -0700
Message-ID: <CALCETrUwQtS70VRDMysdMsn0ahVUz6ys0Gd+9+YR=anxVX7OMA@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com>
 <CALCETrXbPQg2V_=3OqZRXbzOf7zGJ8V_RZ5YQ5CHtEEkA0n5HQ@mail.gmail.com>
 <CAGXu5j+muyh2bwtMXDHuUHsDV9ZyEY-hMHrJjVuX2vC20MVSZw@mail.gmail.com>
 <CAGXu5jLtLgYmDJDfGA2EtfB7Fqze-SP768ezq=fgWZ=X-ObW3w@mail.gmail.com>
 <ac79529e-f6b6-690c-e597-5adeb75b0f25@canonical.com> <CAGXu5j+qUOpnDeF4TMH2AXXgHZB_WfHHfxe3TBSShmneisR-Lg@mail.gmail.com>
 <a914076f-efb8-d867-f480-69addca4e628@canonical.com> <CAGXu5j+x-4E8z0TK6je9oLa6yLENzQ30jNH2dXsFkGdzTUaSsQ@mail.gmail.com>
 <0b1a2337-7006-e7cb-f519-dec389ede041@canonical.com> <CAGXu5jJc3LBKWaPCx-PoXa6kzOwp8m6je+Q_kuqN9c9L-D4FOQ@mail.gmail.com>
 <9bd7ef1a-e445-b6c5-cfaa-f7f301c34883@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9bd7ef1a-e445-b6c5-cfaa-f7f301c34883@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 1, 2017 at 7:41 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> On 04/27/2017 07:42 PM, Kees Cook wrote:
>> On Thu, Apr 27, 2017 at 3:17 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
>>> Quick update... I finished the move from the high-water mark
>>> log_max_action sysctl to the bitmask based actions_logged sysctl.
>>
>> Awesome!
>>
>>> Unfortunately, I've just realized that SECCOMP_SET_LOGGING, or any
>>> process-wide logging configuration mechanism, will not work. It is fine
>>> for the situation where two unrelated processes set up seccomp filters
>>> that should be logged differently. However, it fails when two closely
>>> related processes, such as parent and child, need to set up seccomp
>>> filters that should be logged differently. Imagine a launcher that sets
>>> up an application sandbox (including a seccomp filter) and then launches
>>> an electron app which will have its own seccomp filter for sandboxing
>>> untrusted code that it runs. Unless the launcher and app completely
>>> agree on actions that should be logged, the logging won't work as
>>> intended for both processes.
>>
>> Oh, you mean the forked process sets up the logging it wants for the
>> filters it just installed, then after exec a process sets up new
>> logging requirements?
>
> Yes - see below.
>
>>
>>> I think this needs to be configured at the filter level.
>>
>> I'm not sure that's even the right way to compose the logging desires.
>>
>> So, my initial thought was "whatever ran SECCOMP_SET_LOGGING knows
>> what it's doing" and it should be the actual value.
>>
>> If the launcher wants logs of everything the application does with its
>> filters, then a purely-tied-to-filter approach won't work either.
>>
>> Perhaps log bits can only be enabled? I.e. SECCOMP_SET_LOGGING
>> performs an OR instead of an assignment?
>
> The problem that I'm envisioning with this design is this:
>
> 1. Launcher is told to launch Chrome and forks off a process.
>
> 2. Launcher sets up a filter using RET_ERRNO for all unacceptable
> syscalls and enables auditing of RET_ERRNO.
>
> 3. Launcher execs Chrome.
>
> 4. Chrome then sets up its own, more restrictive filter that uses
> RET_ERRNO, among other actions, but does not want auditing of RET_ERRNO.
>
> If we use process-wide auditing controls, the logs will be filled with
> RET_ERRNO messages that were unintended and unrelated to the RET_ERRNO
> actions set up in the launcher's filter.
>
> Unfortunately, the OR'ing idea doesn't solve the problem.

Things like my more complicated solution solve this completely, I
think.  The launcher would, by whatever means, say "RET_ERRNO and log
this".  The more restrictive sandbox would say "RET_ERROR and don't
log this" and we'd just make sure that the composition rules mean the
inner rule wins.

--Andy
