From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Sun, 19 Oct 2014 12:11:52 -0700
Message-ID: <CALCETrVR-dCT2Xzs9JrO_WieeM7=jxjmBJH21u=jgt8JO2p-pw@mail.gmail.com>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com> <87zjcszz8y.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <87zjcszz8y.fsf@x220.int.ebiederm.org>
Sender: linux-arch-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, X86 ML <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Drysdale <drysdale@google.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Meredydd Luff <meredydd@senatehouse.org>
List-Id: linux-api@vger.kernel.org

On Oct 18, 2014 5:21 PM, "Eric W. Biederman" <ebiederm@xmission.com> wrote:
>
> Andy Lutomirski <luto@amacapital.net> writes:
>
> > [Added Eric Biederman, since I think your tree might be a reasonable
> > route forward for these patches.]
> >
> > On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale@google.com> wrote:
> >> Resending, adding cc:linux-api.
> >>
> >> Also, it may help to add a little more background -- this patch is
> >> needed as a (small) part of implementing Capsicum in the Linux kernel.
> >>
> >> Capsicum is a security framework that has been present in FreeBSD since
> >> version 9.0 (Jan 2012), and is based on concepts from object-capability
> >> security [1].
> >>
> >> One of the features of Capsicum is capability mode, which locks down
> >> access to global namespaces such as the filesystem hierarchy.  In
> >> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
> >> work -- hence the need for a kernel-space
> >
> > I just found myself wanting this syscall for another reason: injecting
> > programs into sandboxes or otherwise heavily locked-down namespaces.
> >
> > For example, I want to be able to reliably do something like nsenter
> > --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
> > it is more or less fully functional, so this should Just Work (tm),
> > except that the toybox binary might not exist in the namespace being
> > entered.  If execveat were available, I could rig nsenter or a similar
> > tool to open it with O_CLOEXEC, enter the namespace, and then call
> > execveat.
> >
> > Is there any reason that these patches can't be merged more or less as
> > is for 3.19?
>
> Yes.  There is a silliness in how it implements fexecve.  The fexecve
> case should be use the empty string "" not a NULL pointer to indication
> that.  That change will then harmonize execveat with the other ...at
> system calls and simplify the code and remove a special case.  I believe
> using the empty string "" requires implementing the AT_EMPTY_PATH flag.
>

Sounds reasonable.

> For sandboxes execveat seems to make a great deal of sense.  I can
> get the same functionality by passing in a directory file descriptor
> calling fchdir and execve so this should not introduce any new security
> holes.  And using the final file descriptor removes a race.

The problem with that approach is that the execed program now has its
current directory outside the sandbox, which could be problematic if
you don't trust that program.

>
> AT_SYMLINK_NOFOLLOW seems to have some limited utility as well, although
> for exec I don't know what problems it can solve.

It can always be added later

>
> Until I am done moving I won't have time to pick this up, and the code
> clearly needs another revision but I will be happy to work to see that
> we get a sane execveat implemented.

Do you have an ETA?  If it's likely to miss 3.19, but if you'll have
time to review before then, I can try to do it.

>
> Eric
>
> p.s.  I don't believe there are any namespaces issues where doing
> something with execveat flags make sense.
>

OK, I'll bite.  How feasible would it be to have a flag that activated
pid_ns_for_children?  That would reduce a lot of the ugliness in tools
like nsenter that need to fork to enter a pid ns.

I always assume that the reason for the active vs. for_children
distinction was because a lot of userspace libraries, including glibc,
would malfunction if getpid(2) started returning a different value.
But, for exec, this doesn't matter.

--Andy
