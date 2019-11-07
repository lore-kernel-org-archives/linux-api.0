From: Christian Brauner <christian.brauner@ubuntu.com>
Subject: Re: Continuing the UAPI split
Date: Thu, 7 Nov 2019 14:36:54 +0100
Message-ID: <20191107133652.lqp5cqcdtwu22ibd@wittgenstein>
References: <CALN7hCK0EXLXjPRPr+tuuF2-uQvkLMCFDNzGhv9HS-jrAz6Hmg@mail.gmail.com>
 <0B17C6F2-DC2B-4192-B4AD-BD11D6B9F2B6@ubuntu.com>
 <87zhh7j38y.fsf@oldenburg2.str.redhat.com>
 <CALN7hCJ_umFqC1L0T19CuiGiGoVwac5807NDw4LiDqSD-VJL=Q@mail.gmail.com>
 <87zhh7hlbl.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <libc-alpha-return-106750-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <87zhh7hlbl.fsf@oldenburg2.str.redhat.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Elichai Turkel <elichai.turkel@gmail.com>, linux-api@vger.kernel.org, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 07, 2019 at 02:23:26PM +0100, Florian Weimer wrote:
> * Elichai Turkel:
> 
> > Thanks for the response,
> > I'm not sure what are you suggesting exactly.
> > A rename to the structs/types so they won't collide with libc?
> 
> Or use namespaces.  I mean, we have had proper technical solutions for
> this issue for more than 20 years now.  I know that this isn't going to
> happen, though.
> 
> > Prioritizing POSIX conformance in the kernel(I think that ship has long sailed)?
> 
> That doesn't really work anyway if userspace has different versions of
> the type depending on feature macros.  Examples are struct stat or soon
> struct timespec on 32-bit architectures.
> 
> > Or just giving up and telling users they can't just directly include
> > both libc headers and kernel headers?
> 
> That's what I've been telling users if they encounter fringe cases I
> can't fix on the glibc side.
> 
> It might also help if top-level types for end user use would be in
> separate headers.  This is what we started doing internally in glibc, to
> disentangle our own headers and eliminate cyclic dependencies.
> 
> > (I'm actually not sure how it works now. because there are definitely
> > collision and if we are using ifdefs and undefs black magic you still
> > end up with a single declaration in the end that might not be
> > compatible with both libc and kernel)
> 
> Officially, it's supposed to work today.  We have one glibc developer
> who says that it's easy to solve, but I disagree strongly.  The fact
> that the problems are not fixed promptly suggests that it's anything but
> simple.
> 
> What I've been doing instead is to include UAPI headers directly from
> glibc headers if it's technically feasible.  (It's not possible in POSIX

A problem I recently ran into that is related are problems with
sys/wait.h and linux/wait.h.
How P_{PID,PGID,PIDFD} used by the waitid() syscall are defined is
different for the two headers.
linux/wait.h uses #define for P_{PID,PGID,PIDFD} whereas sys/wait.h
uses an enum.
The problem is that if I simply don't rely on sys/wait.h and just do
#ifndef P_PID
#define P_PID <value>
#endif
where value is what the syscall expects then technically I need to call
the waitid() syscall directly since it's not at all guaranteed - afaict
- that the P_PID enum == P_PID define that glibc uses for its waitid()
syscall wrapper.
So I'm now in a scenario where I can't call the glibc wrapper for
waitid() with the linux/wait.h defines and I can't call the syscall
directly (e.g. because I want to make use of the syscall's rusage
argument that glibc doesn't expose) with sys/wait.h's P_PID enum.
I'm not sure what the right solution is here...

Christian
