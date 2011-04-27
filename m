From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] [PATCH] drop_pagecache syscall
Date: Wed, 27 Apr 2011 11:25:47 -0400
Message-ID: <BANLkTi=+E+WzUgqEQTnRPmL1g5yPsXu8Bw@mail.gmail.com>
References: <1303853727-21444-1-git-send-email-andrea@betterlinux.com>
 <20110427001453.GD12436@dastard> <20110427085910.GA1749@linux.betterlinux.com>
 <BANLkTimrpNOHVfnund7uc=thf-c3_HxyYQ@mail.gmail.com> <20110427094717.GB1749@linux.betterlinux.com>
 <BANLkTi=ZNq4Yp3U5jVspsJixu4ckbdVjtQ@mail.gmail.com> <20110427095709.GA1687@linux.develer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427095709.GA1687-fxUVXftIFDlZdMzt4l2sLQC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Righi <righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 05:57, Andrea Righi wrote:
> On Wed, Apr 27, 2011 at 05:50:04AM -0400, Mike Frysinger wrote:
>> On Wed, Apr 27, 2011 at 05:47, Andrea Righi wrote:
>> > On Wed, Apr 27, 2011 at 05:10:41AM -0400, Mike Frysinger wrote:
>> >> On Wed, Apr 27, 2011 at 05:01, Andrea Righi wrote:
>> >> > On Wed, Apr 27, 2011 at 10:14:53AM +1000, Dave Chinner wrote:
>> >> >> On Tue, Apr 26, 2011 at 11:35:27PM +0200, Andrea Righi wrote:
>> >> >> > This functionality can be used by all the applications that =
want to have a
>> >> >> > better control over the page cache management (for example t=
o immediately drop
>> >> >> > pages that for sure will not be reused in the near future, w=
ithout calling
>> >> >> > posix_fadvise() for all the files they've touched), or to pr=
ovide a more fine
>> >> >> > grained debugging feature usable by the filesystem benchmark=
s.
>> >> >> >
>> >> >> > The system call does not require root privileges and it can =
be called by any
>> >> >> > unprivileged application. For example, we can write a usersp=
ace tool to run
>> >> >> > something like this:
>> >> >> >
>> >> >> > =C2=A0 $ drop-pagecache /path/file_or_dir
>> >> >>
>> >> >> That's a potential DOS vector, I think. Drop the pagecache in =
a hard
>> >> >> loop on the root fs of a busy server and watch it crawl...
>> >> >
>> >> > Yes, probably we could allow only the CAP_SYS_ADMIN tasks to ex=
ecute
>> >> > this syscall.
>> >>
>> >> if /proc/sys/vm/drop_caches has any checks other than file permis=
sion
>> >> checks (i.e. UID=3D=3D0), it'd probably be better to copy those r=
ather
>> >> than picking something different.
>> >
>> > ok, what about checking current_euid() =3D=3D 0?
>>
>> that's not what i meant. =C2=A0if the drop_caches file already has c=
ertain
>> cap checks/whatever in place, let's use those. =C2=A0if it doesnt, t=
hen
>> picking a cap level as you proposed makes sense.
>
> mmh, drop_caches has a file ownership (root:root) and a permission ma=
sk
> (0644), how to apply the same checks to a system call? The most simil=
ar
> thing seems to check the current euid. Am I missing something?

my (limited) understanding is that you should be using cap checks, not =
UID
-mike
