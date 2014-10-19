From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
Date: Sun, 19 Oct 2014 21:20:34 +0100
Message-ID: <20141019202034.GH7996@ZenIV.linux.org.uk>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
 <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Drysdale <drysdale@google.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 17, 2014 at 02:45:03PM -0700, Andy Lutomirski wrote:

> For example, I want to be able to reliably do something like nsenter
> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
> it is more or less fully functional, so this should Just Work (tm),
> except that the toybox binary might not exist in the namespace being
> entered.  If execveat were available, I could rig nsenter or a similar
> tool to open it with O_CLOEXEC, enter the namespace, and then call
> execveat.

The question I hadn't seen really answered through all of that was how to
deal with #!...  "Just use d_path()" isn't particulary appealing - if that
file has a pathname reachable for you, you could bloody well use _that_
from the very beginning.

Frankly, I wonder if it would make sense to provide something like
dupfs.  We can't mount it by default on /dev/fd (more's the pity), but
it might be a good thing to have.

What it is, for those who are not familiar with Plan 9: a filesystem with
one directory and a bunch of files in it.  Directory contents depends on
who's looking; for each opened descriptor in your descriptor table, you'll
see two files there.  One series is 0, 1, ... - opening one of those gives
dup().  IOW, it's *not* giving you a new struct file; it gives you a new
reference to existing one, complete with sharing IO position, etc.  Another
is 0ctl, 1ctl, ... - those are read-only and reading from them gives pretty
much a combination of our /proc/self/fdinfo/n with readlink of /proc/self/fd/n.

It's actually a better match for what one would expect at /dev/fd than what
we do.  Example:

; echo 'read i; cat /dev/fd/0; echo "The first line was $i"' >a.sh
; (echo 'line 1';echo 'line 2') >a
; cat a|sh a.sh
line 2
The first line was line 1
; sh a.sh <a
line 1
line 2
The first line was line 1
;

See what's going on?  Opening /dev/fd/0 (aka /dev/stdin) does a fresh open
of whatever your stdin is; if it's a pipe - fine, you've just added yourself
as additional reader.  But if it's a regular file, you've got yourself
a brand-new opened file, with IO position of its own.  Sitting at the
beginning of the file.

Moreover, try that with stdin being a socket and you'll see cat(1) failing
to open that sucker.

We _can't_ blindly replace /dev/fd with it - it has to be a sysadmin choice;
semantics is different.  However, there's no reason why it can't be mounted
in environments where you want to avoid procfs - it's certainly exposing less
than procfs would.

And these days we can implement relatively cheaply.  It's a window that will
close after a while, but right now we can change ->atomic_open() calling
conventions.  Instead of having it return 0 or error, let's switch to returning
NULL, ERR_PTR(error) *or* an extra reference to preexisting struct file.
Same as we did for ->lookup(), and for similar reason.

Right now we have 8 instances of ->atomic_open() and one place calling that
method.  Changing the API like that would be trivial (and it's a trivial
conversion - replace return ret; with return ERR_PTR(ret); through all
instances, so any out-of-tree filesystems could follow easily).  We certainly
can't do anything of that sort with ->open() - there would be thousands
instances to convert.  ->atomic_open(), OTOH, is still new enough for
that to be feasible.

What we get from that conversion is an ability to do dup-style semantics
easily.
	* give root directory an ->atomic_open() instance that would be
handling opens.
	* make lookups in there fail with ENOENT if you don't have such a
descriptor at the moment.  Otherwise bind all of them to the same inode.
The only method it needs is ->getattr(), and that would look into your
descriptor table for descriptor with number derived from dentry (stashed
in ->d_fsdata at lookup time) and do what fstat() would.
	* have those dentries always fail ->d_revalidate(), to force
everything towards ->atomic_open().
	* for ...ctl names, ->atomic_open() would act in normal fashion;
again, only one inode is needed.  ->read() would pick descriptor number
from ->d_fsdata and report on whatever you have with that number at the
time.

I'll try to put a prototype of that together; I think it's at least
interesting to try.  And that ought to be safe to mount even in very
restricted environments, making arguments along the lines of "but we can't
get the path by opened file without the big bad wol^Wprocfs and we can't
have that in our environment" much weaker...

Comments?
