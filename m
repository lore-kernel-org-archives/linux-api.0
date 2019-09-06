From: Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Date: Fri, 06 Sep 2019 14:38:11 -0400
Message-ID: <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
References: <20190906152455.22757-1-mic@digikod.net>
         <20190906152455.22757-2-mic@digikod.net>
         <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
         <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
         <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org>
         <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>, Florian Weimer <fweimer@redhat.com>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, Daniel Borkmann <daniel@iogearbox.net>, Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>, Philippe =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, Sean Christopherson <sean.j.christopherson@intel.com>
List-Id: linux-api@vger.kernel.org

On Fri, 2019-09-06 at 19:14 +0200, Mickaël Salaün wrote:
> On 06/09/2019 18:48, Jeff Layton wrote:
> > On Fri, 2019-09-06 at 18:06 +0200, Mickaël Salaün wrote:
> > > On 06/09/2019 17:56, Florian Weimer wrote:
> > > > Let's assume I want to add support for this to the glibc dynamic loader,
> > > > while still being able to run on older kernels.
> > > > 
> > > > Is it safe to try the open call first, with O_MAYEXEC, and if that fails
> > > > with EINVAL, try again without O_MAYEXEC?
> > > 
> > > The kernel ignore unknown open(2) flags, so yes, it is safe even for
> > > older kernel to use O_MAYEXEC.
> > > 
> > 
> > Well...maybe. What about existing programs that are sending down bogus
> > open flags? Once you turn this on, they may break...or provide a way to
> > circumvent the protections this gives.
> 
> Well, I don't think we should nor could care about bogus programs that
> do not conform to the Linux ABI.
> 

But they do conform. The ABI is just undefined here. Unknown flags are
ignored so we never really know if $random_program may be setting them.

> > Maybe this should be a new flag that is only usable in the new openat2()
> > syscall that's still under discussion? That syscall will enforce that
> > all flags are recognized. You presumably wouldn't need the sysctl if you
> > went that route too.
> 
> Here is a thread about a new syscall:
> https://lore.kernel.org/lkml/1544699060.6703.11.camel@linux.ibm.com/
> 
> I don't think it fit well with auditing nor integrity. Moreover using
> the current open(2) behavior of ignoring unknown flags fit well with the
> usage of O_MAYEXEC (because it is only a hint to the kernel about the
> use of the *opened* file).
> 

The fact that open and openat didn't vet unknown flags is really a bug.

Too late to fix it now, of course, and as Aleksa points out, we've
worked around that in the past. Now though, we have a new openat2
syscall on the horizon. There's little need to continue these sorts of
hacks.

New open flags really have no place in the old syscalls, IMO.

> > Anyone that wants to use this will have to recompile anyway. If the
> > kernel doesn't support openat2 or if the flag is rejected then you know
> > that you have no O_MAYEXEC support and can decide what to do.
> 
> If we want to enforce a security policy, we need to either be the system
> administrator or the distro developer. If a distro ship interpreters
> using this flag, we don't need to recompile anything, but we need to be
> able to control the enforcement according to the mount point
> configuration (or an advanced MAC, or an IMA config). I don't see why an
> userspace process should check if this flag is supported or not, it
> should simply use it, and the sysadmin will enable an enforcement if it
> makes sense for the whole system.
> 

A userland program may need to do other risk mitigation if it sets
O_MAYEXEC and the kernel doesn't recognize it.

Personally, here's what I'd suggest:

- Base this on top of the openat2 set
- Change it that so that openat2() files are non-executable by default. Anyone wanting to do that needs to set O_MAYEXEC or upgrade the fd somehow.
- Only have the openat2 syscall pay attention to O_MAYEXEC. Let open and openat continue ignoring the new flag.

That works around a whole pile of potential ABI headaches. Note that
we'd need to make that decision before the openat2 patches are merged.

Even better would be to declare the new flag in some openat2-only flag
space, so there's no confusion about it being supported by legacy open
calls.

If glibc wants to implement an open -> openat2 wrapper in userland
later, it can set that flag in the wrapper implicitly to emulate the old
behavior.

Given that you're going to have to recompile software to take advantage
of this anyway, what's the benefit to changing legacy syscalls?

> > > > Or do I risk disabling this security feature if I do that?
> > > 
> > > It is only a security feature if the kernel support it, otherwise it is
> > > a no-op.
> > > 
> > 
> > With a security feature, I think we really want userland to aware of
> > whether it works.
> 
> If userland would like to enforce something, it can already do it
> without any kernel modification. The goal of the O_MAYEXEC flag is to
> enable the kernel, hence sysadmins or system designers, to enforce a
> global security policy that makes sense.
> 

I don't see how this helps anything if you can't tell whether the kernel
recognizes the damned thing. Also, our track record with global sysctl
switches like this is pretty poor. They're an administrative headache as
well as a potential attack vector.

I think your idea is a good one, but it could stand to have fewer moving
parts.
-- 
Jeff Layton <jlayton@kernel.org>
