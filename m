From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH RFC 0/3] simple copy offloading system call
Date: Wed, 6 May 2015 19:52:34 -0700
Message-ID: <CALCETrUj2EqJ7uDPbAuOGBnLycWBqqnt2Z2cAf8Pp+sgCqBhvw@mail.gmail.com>
References: <1428703236-24735-1-git-send-email-zab@redhat.com> <CAHO5Pa0UEhOC3vqP9Nq4+gEH_OJPG6dgoLM9XbRLOfTRsRVSCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CAHO5Pa0UEhOC3vqP9Nq4+gEH_OJPG6dgoLM9XbRLOfTRsRVSCw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-nfs@vger.kernel.org, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Zach Brown <zab@redhat.com>
List-Id: linux-api@vger.kernel.org

On May 6, 2015 11:45 AM, "Michael Kerrisk" <mtk.manpages@gmail.com> wrote:
>
> [CC += linux-api@vger.kernel.org]
>
> Zach,
>
> Since this is a kernel-user-space API change, please CC linux-api@.
> The kernel source file Documentation/SubmitChecklist notes that all
> Linux kernel patches that change userspace interfaces should be CCed
> to linux-api@vger.kernel.org, so that the various parties who are
> interested in API changes are informed. For further information, see
> https://www.kernel.org/doc/man-pages/linux-api-ml.html
>
> Thanks,
>
> Michael
>
>
>
>
> On Sat, Apr 11, 2015 at 12:00 AM, Zach Brown <zab@redhat.com> wrote:
> > Hello everyone!
> >
> > Here's my current attempt at the most basic system call interface for
> > offloading copying between files.  The system call and vfs function
> > are relatively light wrappers around the file_operation method that
> > does the heavy lifting.
> >
> > There was interest at LSF in getting the basic infrastructure merged
> > before worrying about adding behavioural flags and more complicated
> > implementations.  This series only offers a refactoring of the btrfs
> > clone ioctl as an example of an implementation of the file
> > copy_file_range method.
> >
> > I've added support for copy_file_range() to xfs_io in xfsprogs and
> > have the start of an xfstest that tests the system call.  I'll send
> > those to fstests@.
> >
> > So how does this look?
> >
> > Do we want to merge this and let the NFS and block XCOPY patches add
> > their changes when they're ready?

This sounds enough like splice that I'm wondering why the API isn't splice.

--Andy
