From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v1 2/2] signal: add procfd_signal() syscall
Date: Wed, 28 Nov 2018 23:05:49 +0100
Message-ID: <20181128220545.fplqmbkfhxowx3lf@brauner.io>
References: <20181119103241.5229-1-christian@brauner.io>
 <20181119103241.5229-3-christian@brauner.io>
 <20181128214534.xxqoyy7mi5dw54kj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181128214534.xxqoyy7mi5dw54kj@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joey Pabalinas <joeypabalinas@gmail.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 28, 2018 at 11:45:34AM -1000, Joey Pabalinas wrote:
> On Mon, Nov 19, 2018 at 11:32:39AM +0100, Christian Brauner wrote:
> > +	if (info) {
> > +		ret = __copy_siginfo_from_user(sig, &kinfo, info);
> > +		if (unlikely(ret))
> > +			goto err;
> 

I think you're misreading here. It jumps to:

err:
        fdput(f);
	return ret;

and does propagate the error. This is also an old iteration of the patch.

Christian

> What's the reason you don't propagate up the errors from __copy_siginfo_from_user()?
> Granted, I admit that -E2BIG is kind of weird to return, but -EFAULT seems like a
> fairly sane error.
> 
> Or is there some reason it's more useful to just return -EINVAL for all of the
> failure cases here?
> 
> -- 
> Cheers,
> Joey Pabalinas
