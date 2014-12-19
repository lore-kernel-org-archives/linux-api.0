From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RESEND v4] sched/fair: Add advisory flag for borrowing
 a timeslice
Date: Fri, 19 Dec 2014 01:27:17 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1412190045590.17382@nanos>
References: <1418928259-6311-1-git-send-email-khalid.aziz@oracle.com> <20141218222846.GH30905@twins.programming.kicks-ass.net> <54935842.5020507@oracle.com> <alpine.DEB.2.11.1412182355020.17382@nanos> <54936562.5070502@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <54936562.5070502@oracle.com>
Sender: linux-doc-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, corbet@lwn.net, mingo@redhat.com, hpa@zytor.com, riel@redhat.com, akpm@linux-foundation.org, rientjes@google.com, ak@linux.intel.com, mgorman@suse.de, raistlin@linux.it, kirill.shutemov@linux.intel.com, atomlin@redhat.com, avagin@openvz.org, gorcunov@openvz.org, serge.hallyn@canonical.com, athorlton@sgi.com, oleg@redhat.com, vdavydov@parallels.com, daeseok.youn@gmail.com, keescook@chromium.org, yangds.fnst@cn.fujitsu.com, sbauer@eng.utah.edu, vishnu.ps@samsung.com, axboe@fb.com, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 18 Dec 2014, Khalid Aziz wrote:
> On 12/18/2014 04:02 PM, Thomas Gleixner wrote:
> > If we can solve it with a proper designed and well thought out
> > functionality in the kernel based on a futex like mechanism, why cant
> > java and databases not switch over to that and simply use it?
> > 
> > You need to modify user space anyway, so it does not matter whether
> > you modify it in a sane or in a hacky way.
> 
> Actually userspace does not need to be modified. The code to use this
> functionality is already present in database code since this same
> functionality exists on other OSs (the API is a little different but those
> details can be handled with a simple header file in userspace). Userspace code
> has already been tested and debugged thoroughly on the OSs that support this
> functionality and that has significant impact on testing effort. So for
> userspace it is simply a matter of turning that code on on Linux as well and
> recompiling. This would be a multi-platform solution for database/java as
> opposed to a Linux specific solution.

Bullshit. If you turn that option on, it's a modification from the QA
point of view and you need to run a full validation no matter
what. Anything else is just QA by crystal ball.

Of course you carefully avoided (again) to answer the real question:

> But its simpler to hack crap into the scheduler than coming up with a
> proper solution to the problem, right?

I can answer it for you: Yes, it is simpler.

But as you might have figured out it's not really popular and therefor
not simpler to be accepted by the people who actually care about sane
designs. I can whip you up special purpose hacks for that which will
give you way more guarantees with way less lines of horrible code, but
that does not mean that such hacks are an acceptable solution. You can
carry those hacks in your private tree and ship it to your customers,
but do not expect that any sane maintainer will care about it.

Now the very same maintainers asked you several times to answer the
question why this can't be done with proper futex like spin
mechanisms, which would solve a bunch of related problems as well.

 You never even tried to answer that question simply because you never
 tried to think about it for real. Your only answer is that you want A
 because A is already used on other OSs and therefor solution B is not
 an option.

 But if solution B would gain 4% performance, then according to your
 previous argumentation it would become suddenly very interesting,
 right?

So unless you even show any sign of thinking about different
approaches and technically arguing why they cannot deliver the same
value you wont get anywhere with this and I can tell you why.

You create a new user space ABI

 That forces the kernel to support it forever, which in consequence
 imposes restrictions on the kernel scheduler forever.

 We have enough restrictions by misdesigned ABIs (e.g. sched_yield())
 already, so we really do not need more of that.

You ignore any request to prove why a proper designed spin futex
interface would not be a sensible solution for the problem.

 Of course you are free to ignore that (as you are free to ignore
 important review comments), but you don't have to be suprised when
 the responsible maintainers ignore any further attempt from you to
 get this merged.

Aside of that, you still fail to provide a proper test case which is
publically usable for the people involved in this to reproduce your 3%
gain and analyze the problem at hand properly. The provided:

      enable_hack();
      while (/*some condition */) {
      	    /* bla */
	    /* blub */
	    /* blurb */
	    /* yay! */
      }
      disable_hack();

is beyond useless.

Thanks,

	tglx
