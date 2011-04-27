From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Date: Wed, 27 Apr 2011 05:50:04 -0400
Message-ID: <BANLkTi=ZNq4Yp3U5jVspsJixu4ckbdVjtQ@mail.gmail.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard> <20110427085910.GA1749@linux.betterlinux.com>
 <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ@mail.gmail.com> <20110427094717.GB1749@linux.betterlinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110427094717.GB1749@linux.betterlinux.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Righi <andrea@betterlinux.com>
Cc: Dave Chinner <david@fromorbit.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 05:47, Andrea Righi wrote:
> On Wed, Apr 27, 2011 at 05:10:41AM -0400, Mike Frysinger wrote:
>> On Wed, Apr 27, 2011 at 05:01, Andrea Righi wrote:
>> > On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
>> >> On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
>> >> > This functionality can be used by all the applications that wan=
t to have a
>> >> > better control over the page cache management (for example to i=
mmediately drop
>> >> > pages that for sure will not be reused in the near future, with=
out calling
>> >> > posix_fadvise() for all the files they've touched), or to provi=
de a more fine
>> >> > grained debugging feature usable by the filesystem benchmarks.
>> >> >
>> >> > The system call does not require root privileges and it can be =
called by any
>> >> > unprivileged application. For example, we can write a userspace=
 tool to run
>> >> > something like this:
>> >> >
>> >> > =A0 $ drop-pagecache /path/file_or_dir
>> >>
>> >> That's a potential DOS vector, I think. Drop the pagecache in a h=
ard
>> >> loop on the root fs of a busy server and watch it crawl...
>> >
>> > Yes, probably we could allow only the CAP_SYS_ADMIN tasks to execu=
te
>> > this syscall.
>>
>> if /proc/sys/vm/drop_caches has any checks other than file permissio=
n
>> checks (i.e. UID=3D=3D0), it'd probably be better to copy those rath=
er
>> than picking something different.
>
> ok, what about checking current_euid() =3D=3D 0?

that's not what i meant.  if the drop_caches file already has certain
cap checks/whatever in place, let's use those.  if it doesnt, then
picking a cap level as you proposed makes sense.
-mike
