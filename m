From: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences benchmarks
Date: Thu, 22 Oct 2015 15:10:54 -0700
Message-ID: <20151022221054.GA2949757@devbig217.prn1.facebook.com>
References: <cover.1445464158.git.davejwatson@fb.com>
 <CALCETrWXR0BMeEygiLoT5gbyYpGxren_Fch=S4RSryfqwdxH8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWXR0BMeEygiLoT5gbyYpGxren_Fch=S4RSryfqwdxH8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: kernel-team-b10kYP2dOMg@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 22, 2015 at 12:11:42PM -0700, Andy Lutomirski wrote:
> On Thu, Oct 22, 2015 at 11:06 AM, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org> wrote:
> >
> >                                    RSS CPUIDLE LATENCYMS
> > jemalloc 4.0.0                     31G   33%     390
> > jemalloc + this patch              25G   33%     390
> > jemalloc + this patch using lsl    25G   30%     420
> > jemalloc + PT's rseq patch         25G   32%     405
> > glibc malloc 2.20                  27G   30%     420
> > tcmalloc gperftools trunk (2.2)    21G   30%     480
> 
> Slightly confused.  This is showing a space efficiency improvement but
> not a performance improvement?  Is the idea that percpu free lists are
> more space efficient than per-thread free lists?
> 
> --Andy

Correct - the service was already tuned such that most requests hit
the (very large) thread free lists to avoided taking expensive locks
talking to the central arena.  There were more threads than cpus, so
the memory win is just needing fewer free lists. 
