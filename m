From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Date: Thu, 14 Jan 2010 17:17:36 +0900 (JST)
Message-ID: <20100114170247.6747.A69D9226@jp.fujitsu.com>
References: <20100114162327.673E.A69D9226@jp.fujitsu.com> <20100114080117.GL18808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100114080117.GL18808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

> > Hmm..
> > Your answer didn't match I wanted.
> Then I don't get what you want.

I want to know the benefit of the patch for patch reviewing.


> > few additional questions.
> > 
> > - Why don't you change your application? It seems natural way than kernel change.
> There is no way to change my application and achieve what I've described
> in a multithreaded app.

Then, we don't recommend to use mlockall(). I don't hope to hear your conclusion,
it is not objectivization. I hope to hear why you reached such conclusion.


> > - Why do you want your virtual machine have mlockall? AFAIK, current majority
> >   virtual machine doesn't.
> It is absolutely irrelevant for that patch, but just because you ask I
> want to measure the cost of swapping out of a guest memory.

No. if you stop to use mlockall, the issue is vanished.


> > - If this feature added, average distro user can get any benefit?
> > 
> ?! Is this some kind of new measure? There are plenty of much more
> invasive features that don't bring benefits to an average distro user.
> This feature can bring benefit to embedded/RT developers.

I mean who get benifit?


> > I mean, many application developrs want to add their specific feature
> > into kernel. but if we allow it unlimitedly, major syscall become
> > the trushbox of pretty toy feature soon.
> > 
> And if application developer wants to extend kernel in a way that it
> will be possible to do something that was not possible before why is
> this a bad thing? I would agree with you if for my problem was userspace
> solution, but there is none. The mmap interface is asymmetric in regards
> to mlock currently. There is MAP_LOCKED, but no MAP_UNLOCKED. Why
> MAP_LOCKED is useful then?

Why? Because this is formal LKML reviewing process. I'm reviewing your
patch for YOU.

If there is no objective reason, I don't want to continue reviewing.
