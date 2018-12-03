From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Mon, 03 Dec 2018 17:57:51 +0100
Message-ID: <8736rebl9s.fsf@oldenburg.str.redhat.com>
References: <20181120105124.14733-1-christian@brauner.io>
        <87in0g5aqo.fsf@oldenburg.str.redhat.com>
        <746B7C49-CC7B-4040-A7EF-82491796D360@brauner.io>
        <20181202100304.labt63mzrlr5utdl@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181202100304.labt63mzrlr5utdl@brauner.io> (Christian Brauner's
        message of "Sun, 2 Dec 2018 11:03:06 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

* Christian Brauner:

> Ok, I finally have access to source code again. Scratch what I said above!
> I looked at the code and tested it. If the process has exited but not
> yet waited upon aka is a zombie procfd_send_signal() will return 0. This
> is identical to kill(2) behavior. It should've been sort-of obvious
> since when a process is in zombie state /proc/<pid> will still be around
> which means that struct pid must still be around.

Should we make this state more accessible, by providing a different
error code?

Will the system call ever return ESRCH, given that you have a handle for
the process?

>> >Looking at the rt_tgsigqueueinfo interface, is there a way to implement
>> >the “tg” part with the current procfd_signal interface?  Would you use
>> >openat to retrieve the Tgid: line from "status"?
> 
> Yes, the tg part can be implemented.

I meant on top of the existing interface.

> As I pointed out in another mail my I is to make this work by using
> file descriptors for /proc/<pid>/task/<tid>.  I don't want this in the
> initial patchset though.  I prefer to slowly add those features once
> we have gotten the basic functionality in.

Do you want to land all this in one kernel release?  I wonder how
applications are supposed to discover kernel support if functionality is
split across several kernel releases.  If you get EINVAL or EBADF, it
may not be obvious what is going on.

What happens if you use the new interface with an O_PATH descriptor?

Thanks,
Florian
