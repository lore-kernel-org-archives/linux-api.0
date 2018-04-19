From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 24/24] debugfs: Restrict debugfs when the kernel is locked down
Date: Thu, 19 Apr 2018 15:35:47 +0100
Message-ID: <27818.1524148547@warthog.procyon.org.uk>
References: <20180413202241.GB4484@amd> <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk> <152346403637.4030.15247096217928429102.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413202241.GB4484@amd>
Content-ID: <27817.1524148547.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, linux-man@vger.kernel.org, linux-api@vger.kernel.org, jmorris@namei.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

> >  (1) chmod and chown are disallowed on debugfs objects (though the root dir
> >      can be modified by mount and remount, but I'm not worried about that).
> 
> This has nothing to do with the lockdown goals, right? I find chown of
> such files quite nice, to allow debugging without doing sudo all the time.

It allows someone to give everyone access to files that should perhaps only be
accessible by root.  Besides, if you disable lockdown then you can do this if
you want.

> >  (2) When the kernel is locked down, only files with the following criteria
> >      are permitted to be opened:
> > 
> > 	- The file must have mode 00444
> > 	- The file must not have ioctl methods
> > 	- The file must not have mmap
> 
> Dunno. Would not it be nicer to go through the debugfs files and split
> them into safe/unsafe varieties?

Whilst that is a laudable idea, there are at least a couple of thousand files
to analyse, some of them doing weird stuff in drivers that aren't easy to
understand, and some of them with lists of files, some of which might be safe
and some of which aren't safe.  Even some reads that look like they ought to
be safe have side effects (such as read-and-reset counters).

Besides, define 'safe'.  Is reading a particular reg on a device and returning
the value through a debugfs read safe, for example?  What about files where
reading is harmless, but writing needs to be disallowed?

I did try initially passing in a flag to say whether something was safe or
not, abusing an inode flag to store it since debugfs uses a plain inode
struct, but then I realised just how many ways there are to create debugfs
files and it started to get out of hand.  My initial idea also included
locking everything down by default and marking things unlocked on an as-needed
basis.

If you have the time to audit all these files, then that would be great.

I lean more towards the lock debugfs down entirely side.

David
