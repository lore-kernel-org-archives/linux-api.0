From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Formal description of system call interface
Date: Mon, 21 Nov 2016 16:48:49 +0100
Message-ID: <CACT4Y+Z4a08puQsxDyCQGuWwmqgnW5aCYDDQecqtY7NTMj4mVA@mail.gmail.com>
References: <CACT4Y+YYgs43nJnyg3B9cHWOue62iMW3ZgXQKiKG12A1NVMgtg@mail.gmail.com>
 <20161107103819.GA11374@rei.lan> <20161121103752.70ad1418@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161121103752.70ad1418-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, scientist-b10kYP2dOMg@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Tavis Ormandy <taviso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 21, 2016 at 4:37 PM, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:
> On Mon, 7 Nov 2016 11:38:20 +0100
> Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org> wrote:
>
>
>> I'm not sure if something like this is really doable or in the scope of
>> this project, but it may be worth a try.
>>
>
> Looking ahead into the future, I was also thinking that if this becomes
> robust, we could also start an integration specification, that could
> describe how different system calls interact with each other. Like
> open() to read(), write() and close().
>
> But this is just an idea that popped in my head while reading this
> thread. We want to start small first, but still could keep this in the
> back of our minds for future enhancements.


FWIW syzkaller does something along these lines.
It has notion of 'resources' and of input/output arguments.
Then it can figure out that e.g. open creates fd's, so it should be called
before any reads/writes (provided that we want to pass in valid fd's).
It does not have notion of "destructors" for resources (e.g. close
destroys the passed in resource). But it should be easy to describe.
