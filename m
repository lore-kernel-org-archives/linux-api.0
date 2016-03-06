From: Szabolcs Nagy <nsz-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org>
Subject: Re: [PATCH v4 0/2] make sigaltstack() compatible with swapcontext()
Date: Sun, 6 Mar 2016 21:27:38 +0100
Message-ID: <20160306202738.GU29662@port70.net>
References: <1456781345-8243-1-git-send-email-stsp@list.ru>
 <20160306200207.GT29662@port70.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160306200207.GT29662-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

* Szabolcs Nagy <nsz-4P1ElwuDYu6sTnJN9+BGXg@public.gmane.org> [2016-03-06 21:02:08 +0100]:
> * Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> [2016-03-01 00:29:03 +0300]:
> > The following patches make it possible to use swapcontext()
> > in a sighandler that works on sigaltstack.
> 
> i don't think that's possible, the (obsolete) userspace
> *context functions cannot operate on kernel provided
> ucontext_t structs, so they are not usable in signal
> handlers.
> 
> at least not on most target archs.
> 
> so i don't understand how the tests can work portably.
> 

i see the test does not use the kernel ucontext_t
and only synchronous context switch is done

sorry for the noise.
