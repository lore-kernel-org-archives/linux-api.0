From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Date: Sat, 24 Apr 2010 22:24:47 -0500
Message-ID: <20100425032447.GA25044@hallyn.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421030406.GB10258@kroah.com>
 <20100421034532.GA9254@us.ibm.com>
 <m1zl0xo1m9.fsf@fess.ebiederm.org>
 <20100424033614.GA4180@us.ibm.com>
 <n2s13426df11004240925id540ed94mc2ebafada0099ec4@mail.gmail.com>
 <m11ve4wwzk.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <m11ve4wwzk.fsf@fess.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: ron minnich <rminnich@gmail.com>, "Serge E. Hallyn" <serue@us.ibm.com>, Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org, jt.beard@gmail.com, Andrew Morton <akpm@linux-foundation.org>, Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com, Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> ron minnich <rminnich@gmail.com> writes:
> 
> > On Fri, Apr 23, 2010 at 8:36 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >> An fs actually seems overkill for two write-only files for
> >> process-related information. ??Would these actually be candidates
> >> for new /proc files?
> >>
> >> ?? ?? ?? ??/proc/grantcred - replaces /dev/caphash, for privileged
> >> ?? ?? ?? ?? ?? ?? ?? ??tasks to tell the kernel about new setuid
> >> ?? ?? ?? ?? ?? ?? ?? ??capabilities
> >> ?? ?? ?? ??/proc/self/usecred - replaces /dev/capuse for unprivileged
> >> ?? ?? ?? ?? ?? ?? ?? ??tasks to make use of a setuid capability
> >
> > An fs is fine.
> >
> > To relate this to Plan 9, where it all began, might be useful. There's
> > no equivalent in Plan 9 to Linux/Unix devices of the major/minor
> > number etc. variety. In-kernel drivers and out-of-kernel servers both
> > end up providing the services (i.e. file name spaces) that we see in a
> > Linux file system. So the Plan 9 driver for the capability device
> > really does match closely in function and interface to a Linux
> > kernel-based file system.
> >
> > Hence, making devcap a file system is entirely appropriate, because it
> > best fits the way it works in Plan 9: a kernel driver that provides
> > two files.
> >
> > It's pretty easy to write a Linux VFS anyway, so it makes sense from
> > that point of view.
> >
> > Eric, that was a great suggestion.
> 
> A fs provides user space policy control of naming.  I.e. where the two files go.
> That can also be a very big deal.  Especially when files are writable.
> 
> You have no idea how much I am frustrated by sysfs right now, because
> it does not provide userspace policy control and instead mandates a
> sometimes inappropriate naming convention.
> 
> Eric

Well I'm not convinced that it's a worthwhile tradeoff for polluting
/proc/filesystems and needing yet another fs mounted in each container,
but a preliminary working version using an fs is at
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/p9auth.apr24.2

I'll do some cleanup before sending it out.

Eric, I'd said that the device-based version was namespace-aware, but
that meant that you could on grant and use capabilities in your own
user namespace.  I suppose now that it's an fs we can do better
semantics, where each user ns can mount its own p9auth, and anyone
with CAP_GRANT_ID targeted at some user ns (i.e. root in a user_ns
or the creator of a user_ns) can grant ids to that user ns.  Though
I'm not sure that's a feature anyone would ever use, and I do like
the simplicity of just having one sb.

-serge
