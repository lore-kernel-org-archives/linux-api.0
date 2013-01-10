From: Andrey Wagin <avagin@gmail.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
Date: Thu, 10 Jan 2013 13:47:40 +0400
Message-ID: <CANaxB-xupOxkyd3-tdJSeW7y+1DQzMr-3Pxnmx17Y=ocDU1VTA@mail.gmail.com>
References: <1356690181-1796-1-git-send-email-avagin@openvz.org>
	<1356690181-1796-3-git-send-email-avagin@openvz.org>
	<20121228161436.GA30459@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121228161436.GA30459@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Pavel Emelyanov <xemul@parallels.com>, Cyrill Gorcunov <gorcunov@openvz.org>
List-Id: linux-api@vger.kernel.org

2012/12/28 Oleg Nesterov <oleg@redhat.com>:
> On 12/28, Andrey Vagin wrote:
>>
>> signalfd should be called with the flag SFD_RAW for that.
>>
>> signalfd_siginfo is not full for siginfo with a negative si_code.
>> copy_siginfo_to_user() is copied a full siginfo to user-space, if
>> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
>> expanded, because it has not compatible format with siginfo_t.
>>
>> Another problem is that a constant __SI_* is removed from si_code.
>> It's not a problem for usual applications, because they expect
>> a defined type of siginfo (internal logic).
>> When we want to dump pending signals, we can't predict a type of
>> siginfo, so we should get it from kernel.
>>
>> The main idea of the raw format is that it should be enough for
>> restoring exactly the same siginfo for the current process.
>>
>> This functionality is required for checkpointing pending signals.
>
> And this should be used along with pread().
>
> I won't argue, but perhaps we should simply postulate that pread()
> always dumps siginfo in raw format and avoid the new flag?

I won't argue too:), but I think the flag is more flexiable. The flag
allows to get raw siginfo from read(), it may be useful not only for
checkpoint/restore. pread with offset = 0 is equal to read(), so the
interface with the flag is more clear.

>
>> @@ -272,20 +311,35 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>>       signotset(&sigmask);
>>
>>       if (ufd == -1) {
>> +             struct file *file;
>>               ctx = kmalloc(sizeof(*ctx), GFP_KERNEL);
>>               if (!ctx)
>>                       return -ENOMEM;
>>
>>               ctx->sigmask = sigmask;
>>
>> +             ufd = get_unused_fd_flags(flags);
>> +             if (ufd < 0) {
>> +                     kfree(ctx);
>> +                     goto out;
>> +             }
>> +
>>               /*
>>                * When we call this, the initialization must be complete, since
>>                * anon_inode_getfd() will install the fd.
>>                */
>> -             ufd = anon_inode_getfd("[signalfd]", &signalfd_fops, ctx,
>> +             file = anon_inode_getfile("[signalfd]", &signalfd_fops, ctx,
>>                                      O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
>> -             if (ufd < 0)
>> +             if (IS_ERR(file)) {
>> +                     put_unused_fd(ufd);
>> +                     ufd = PTR_ERR(file);
>>                       kfree(ctx);
>> +                     goto out;
>> +             }
>> +
>> +             file->f_flags |= flags & SFD_RAW;
>> +
>> +             fd_install(ufd, file);
>
> And this is needed because we want to set more bits in f_flags/f_mode.
>
> I am wondering if we can change anon_inode_getfd/getfile somehow so
> that the user can pass more flags...
>
> Or. Currently fops->open() is never used if this file_operations is used
> by anon_inode_get*. So perhaps we can change anon_inode_getfile() to call
> fops->open() if it is not zero before return?
>
> OK, this is almost off-topic, please ignore.
>
> Oleg.
>
