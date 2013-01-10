From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
Date: Thu, 10 Jan 2013 23:45:17 +0100
Message-ID: <CAKgNAkj2BK80wx-Hki6Q1+uO+J4jefpJ9b_cs_DwpCJNgc+ioA@mail.gmail.com>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org>
 <1356690181-1796-3-git-send-email-avagin@openvz.org> <20121228161436.GA30459@redhat.com>
 <CANaxB-xupOxkyd3-tdJSeW7y+1DQzMr-3Pxnmx17Y=ocDU1VTA@mail.gmail.com>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CANaxB-xupOxkyd3-tdJSeW7y+1DQzMr-3Pxnmx17Y=ocDU1VTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrey Wagin <avagin@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 10, 2013 at 10:47 AM, Andrey Wagin <avagin@gmail.com> wrote:
> 2012/12/28 Oleg Nesterov <oleg@redhat.com>:
>> On 12/28, Andrey Vagin wrote:
>>>
>>> signalfd should be called with the flag SFD_RAW for that.
>>>
>>> signalfd_siginfo is not full for siginfo with a negative si_code.
>>> copy_siginfo_to_user() is copied a full siginfo to user-space, if
>>> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
>>> expanded, because it has not compatible format with siginfo_t.
>>>
>>> Another problem is that a constant __SI_* is removed from si_code.
>>> It's not a problem for usual applications, because they expect
>>> a defined type of siginfo (internal logic).
>>> When we want to dump pending signals, we can't predict a type of
>>> siginfo, so we should get it from kernel.
>>>
>>> The main idea of the raw format is that it should be enough for
>>> restoring exactly the same siginfo for the current process.
>>>
>>> This functionality is required for checkpointing pending signals.
>>
>> And this should be used along with pread().
>>
>> I won't argue, but perhaps we should simply postulate that pread()
>> always dumps siginfo in raw format and avoid the new flag?
>
> I won't argue too:), but I think the flag is more flexiable. The flag
> allows to get raw siginfo from read(), it may be useful not only for
> checkpoint/restore. pread with offset = 0 is equal to read(), so the
> interface with the flag is more clear.

Special casing pread() behavior for signalfd() so that SFD_RAW is not
required seems only to make the ugliness worse...

While I appreciate the need for this API, multiplexing a queue
selector and a positional value into what is normally a byte offset in
pread() is really bizarre. This is ugly and I wonder if something
better is possible, though so far I have no suggestions beyond adding
a new system call.


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
