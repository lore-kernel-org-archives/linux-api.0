From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH 0/1] arm64: Fix /proc/cpuinfo
Date: Fri, 24 Oct 2014 15:24:35 +0100
Message-ID: <20141024142435.GK24265@leverpostej>
References: <1414159000-27059-1-git-send-email-mark.rutland@arm.com>
 <20141024141936.GS27405@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141024141936.GS27405-l+eeeJia6m9vn6HldHNs0ANdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org" <cross-distro-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Serban Constantinescu <Serban.Constantinescu-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 24, 2014 at 03:19:36PM +0100, Russell King - ARM Linux wrote:
> On Fri, Oct 24, 2014 at 02:56:39PM +0100, Mark Rutland wrote:
> > Currently, the arm64 /proc/cpuinfo format differs from that of arm, in a
> > manner which prevents some otherwise portable applications from
> > functioning as expected. Specifically, the "Features" line describes the
> > 64-bit hwcaps exclusive of the 32-bit hwcaps, which causes issues for
> > certain applications which attempt to parse /proc/cpuinfo to detect
> > features rather than directly using the hwcaps exposed via auxval.
> 
> Like it or not, but every file in procfs is a userspace API, and can
> be parsed by any program.  If we change a procfs file and a userspace
> program then stops working, that's our fault, and our problem to fix
> (by restoring the information published there in a manner which
> userspace can parse.)
> 
> So, as you've found some programs which rely on this, ARM64 really does
> need to be compatible with ARM32 in this respect.

I agree, hence this RFC.

The key question is how we fix the arm64 /proc/cpuinfo format to make
those programs function, without potentially breaking other
applications.

> It's unfortunate that people have decided that parsing the ELF HWCAPs
> from /proc/cpuinfo is an acceptable way to go, rather than using the
> binary information passed, but procfs is a much more visible source
> of information than some binary interface which you need to read man
> pages to find.
> 
> That's the danger of publishing information in either procfs or sysfs.
> Once published, it becomes part of the userspace API, and it can become
> hard to remove it.  This is why we should /always/ think very carefully
> about what we expose through these filesystems.

Yes. We made a mistake here with the arm64 format. Hopefully there's a
way by which we can keep applications happy.

For future architectures, it's probably worth putting stronger
guidelines in place to prevent precisely the issues we've hit here.

Mark.
