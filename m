From: Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] fadvise: introduce POSIX_FADV_DONTNEED_FS
Date: Wed, 27 Apr 2011 14:49:25 -0400
Message-ID: <BANLkTikEKXV=dDrTTqXAKU-zBEfnow5juQ@mail.gmail.com>
References: <1303928027-5100-1-git-send-email-andrea@betterlinux.com>
 <20110427183308.GA16716@parisc-linux.org> <BANLkTinPTPMWPN+JELtCZDjrVepLetX6FQ@mail.gmail.com>
 <20110427184756.GB16716@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427184756.GB16716-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Cc: Andrea Righi <andrea-oIIqvOZpAevzfdHfmsDf5w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Apr 27, 2011 at 14:47, Matthew Wilcox wrote:
> On Wed, Apr 27, 2011 at 02:39:53PM -0400, Mike Frysinger wrote:
>> > Mmm ... what if I open /dev/sdxyz and call fadvise() on it? ??I th=
ink
>> > you end up flushing /dev's page cache entries, instead of the file=
system
>> > which is on /dev/sdxyz.
>>
>> i was thinking of that, but was trying to come up with situations
>> where there might not have a node to work on. =A0fs's in a file go
>> through loop devs, dm/lvm have ones created, and flash fs's still ha=
ve
>> a mtd block. =A0how about network based fs's ? =A0how you going to s=
ignal
>> dropping of pages for nfs or cifs or fuse ones ?
>
> For a regular file, mapping->host->i_sb points to the superblock this
> file is on. =A0For a device, mapping->host->i_sb points to the superb=
lock
> corresponding to this device. =A0So it's always what we want.

sorry, wrong question.  i misread your original post (suggesting we
should be calling fadvise on the block instead of an arbitrary dir
handle).
-mike
