From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 05/18] Add io_uring IO interface
Date: Tue, 29 Jan 2019 08:20:42 -0700
Message-ID: <4b12d149-99f7-0b2e-0c3f-9b477ce48520@kernel.dk>
References: <20190123153536.7081-1-axboe@kernel.dk>
 <20190123153536.7081-6-axboe@kernel.dk> <20190128145700.GA9795@lst.de>
 <2729ab43-b2bf-44b0-d41d-dbb495ddffbf@kernel.dk>
 <20190129063043.GC2996@lst.de>
 <CAK8P3a1x4BsFfacxOmaDXKOKmmQ2j0ypX2+mCNCbjH3E7nC4DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <CAK8P3a1x4BsFfacxOmaDXKOKmmQ2j0ypX2+mCNCbjH3E7nC4DQ@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-aio@kvack.org
To: Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>
Cc: Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>, linux-block <linux-block@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Avi Kivity <avi@scylladb.com>, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org, Deepa Dinamani <deepa.kernel@gmail.com>
List-Id: linux-api@vger.kernel.org

On 1/29/19 4:58 AM, Arnd Bergmann wrote:
> On Tue, Jan 29, 2019 at 7:30 AM Christoph Hellwig <hch@lst.de> wrote:
>>
>> On Mon, Jan 28, 2019 at 11:25:12AM -0700, Jens Axboe wrote:
>>>> Especially with poll support now in the series, don't we need a ѕigmask
>>>> argument similar to pselect/ppoll/io_pgetevents now to deal with signal
>>>> blocking during waiting for events?
>>>
>>> Is there any way to avoid passing in the sigset_t size? If it's just a
>>> 32-bit/64-bit thing, surely the in_compat_syscall() could cover it? Or
>>> are there other cases that need to be catered to?
>>
>> As far as I can tell we never look at it, never looked at it and don't
>> have any plans to look at it anytime soon.  But when I tried to omit
>> it for io_pgetevents I got stong pushback and thus had to add the
>> crazy double indirection calling convention.
> 
> Deepa has recently reworked the handling for the sigset_t handling
> to be more consistent. As I understand it, we only ever check the
> size argument to ensure that user and kernel space agree on
> the size, as it there had been some historic differences.
> 
> If you pass a signal mask to a syscall, you should now just use the
> set_user_sigmask()/set_compat_user_sigmask()/restore_user_sigmask()
> helpers. The compat version is required for the incompatible bit order
> between 32-bit and 64-bit big-endian architectures (on little-endian, compat
> and native signal masks are compatible), and to deal with the one
> architecture that has an _NSIG defined to something other than 64:
> MIPS uses 128 because of a historic accident.
> 
> I think Deepa originally suggested combining set_user_sigmask()
> and set_compat_user_sigmask(), using an in_compat_syscall()
> check. This would let us simplify a number of compat syscalls
> (ppoll, ppoll_time32, pselect6, pselect6_time32, epoll_pwait()
> io_pgetevents_time64, io_pgetevents_time32). I advised against
> changing it at the time for consistency with other compat syscalls,
> but it's something we can still do now.

That's good info. I am currently using set_user_sigmask() for it.
I'd really like to avoid having to pass in a sigset_t size for the
system call, however. What's the best way of achieving that? Can I get
away with doing something like this:

	if (in_compat_syscall()) {
		const compat_sigset_t __user *compat_sig;

		compat_sig = (const compat_sigset_t __user *) sig;
		ret = set_compat_user_sigmask(compat_sig, &ksigmask,
						&sigsaved, _NSIG_WORDS);
	} else {
		ret = set_user_sigmask(sig, &ksigmask, &sigsaved,
						_NSIG_WORDS);
	}

-- 
Jens Axboe

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
