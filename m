From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH RFC] mm: add MAP_EXCLUSIVE to create exclusive user
 mappings
Date: Tue, 29 Oct 2019 10:43:32 -0700
Message-ID: <1572371012.4812.19.camel@linux.ibm.com>
References: <1572171452-7958-1-git-send-email-rppt@kernel.org>
         <2236FBA76BA1254E88B949DDB74E612BA4EEC0CE@IRSMSX102.ger.corp.intel.com>
         <CALCETrWN9kc+10tf7YoBp9ixqkO_KZ=b1E_cFBr_Uogxhu68PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrWN9kc+10tf7YoBp9ixqkO_KZ=b1E_cFBr_Uogxhu68PQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "x86@kernel.org" <x86@kernel.org>, Mike Rapoport <rppt@linux.ibm.com>, Tycho Andersen <tycho@tycho.ws>, Alan Cox <alan@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, 2019-10-29 at 10:03 -0700, Andy Lutomirski wrote:
> On Tue, Oct 29, 2019 at 4:25 AM Reshetova, Elena
> <elena.reshetova@intel.com> wrote:
> > 
> > > The patch below aims to allow applications to create mappins that
> > > have
> > > pages visible only to the owning process. Such mappings could be
> > > used to
> > > store secrets so that these secrets are not visible neither to
> > > other
> > > processes nor to the kernel.
> > 
> > Hi Mike,
> > 
> > I have actually been looking into the closely related problem for
> > the past
> > couple of weeks (on and off). What is common here is the need for
> > userspace
> > to indicate to kernel that some pages contain secrets. And then
> > there are
> > actually a number of things that kernel can do to try to protect
> > these secrets
> > better. Unmap from direct map is one of them. Another thing is to
> > map such
> > pages as non-cached, which can help us to prevent or considerably
> > restrict
> > speculation on such pages. The initial proof of concept for marking
> > pages as
> > "UNCACHED" that I got from Dave Hansen was actually based on
> > mlock2()
> > and a new flag for it for this purpose. Since then I have been
> > thinking on what
> > interface suits the use case better and actually selected going
> > with new madvise()
> > flag instead because of all possible implications for fragmentation
> > and performance.
> 
> Doing all of this with MAP_SECRET seems bad to me.  If user code
> wants UC memory, it should ask for UC memory -- having the kernel
> involved in the decision to use UC memory is a bad idea, because the
> performance impact of using UC memory where user code wasn't
> expecting it wil be so bad that the system might as well not work at
> all.  (For kicks, I once added a sysctl to turn off caching in
> CR0.  I enabled it in gnome-shell.  The system slowed down to such an
> extent that I was unable to enter the three or so keystrokes to turn
> it back off.)
> 
> EXCLUSIVE makes sense.  Saying "don't ptrace this" makes sense.  UC
> makes sense.  But having one flag to rule them all does not make
> sense to me.

So this is a usability problem.  We have a memory flag that can be used
for "secrecy" for some userspace value of the word and we have a load
of internal properties depending on how the hardware works, including
potentially some hardware additions like SEV or TME, that can be used
to implement the property.  If we expose our hardware vagaries, the
user is really not going to know what to do ... and we have a limited
number of flags to express this, so it stands to reason that we need to
define "secrecy" for the user and then implement it using whatever
flags we have.  So I think no ptrace and no direct map make sense for
pretty much any value of "secrecy".  The UC bit seems to be an attempt
to prevent exfiltration via L1TF or other cache side channels, so it
looks like it should only be applied if the side channel mitigations
aren't active ... which would tend to indicate it's a kernel decision
as well.

In the use case in my head, I'd like MAP_EXCLUSIVE to mean the data in
the user memory is difficult to exfiltrate for another tenant in a
virtual system, even if they break containment, so effectively I want
it protected against kernel exploitation and root in the host ... and I
suppose I need to acknowledge that "protected" means best effort
available on the platform, not no attacker can ever extract this.

James
