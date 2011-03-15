From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Tue, 15 Mar 2011 09:56:08 -0600
Message-ID: <C79DDACF-9320-424D-84F5-3DB9C5325B1D@dilger.ca>
References: <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net> <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl> <201103111255.44979.arnd@arndb.de> <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl> <20110311235607.GB15853@elie> <9446ab1a2315c0d2476c30f8315a0503.squirrel@webmail.greenhost.nl> <20110312021001.GA16833@elie> <20110312173217.GA24981@kroah.com> <1e597aedd3d7825dcc0630b1cf2399fa.squirrel@webmail.greenhost.nl> <Pine.LNX.4.64.1103132114380.5145@cobra.newdream.net> <20110315101155.GO15097@dastard>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110315101155.GO15097@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Sage Weil <sage@newdream.net>, Indan Zupancic <indan@nul.nu>, Greg KH <greg@kroah.com>, Jonathan Nieder <jrnieder@gmail.com>, Arnd Bergmann <arnd@arndb.de>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@lst.de" <hch@lst.de>, "l@jasper.es" <l@jasper.es>
List-Id: linux-api@vger.kernel.org

Should there be a "wait" argument or flag that allows an app to start the syncfs(), do something, and then call again to wait for completion?

A more advanced implementation would have the "wait=0" call return an opaque wait handle (e.g. transaction ID) and then calling back with this handle as an argument would only wait if that handle hadn't committed yet. That allows userspace to do efficient batching without having to wait for the full sync to complete. 

Cheers, Andreas

On 2011-03-15, at 4:11, Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Mar 13, 2011 at 09:29:17PM -0700, Sage Weil wrote:
>> On Mon, 14 Mar 2011, Indan Zupancic wrote:
>>> Everyone seems to want to add this new syncfs, but it's not even defined 
>>> what it does. "Same as sync, but only on one fs" is IMHO not good 
>>> enough, because sync's behaviour is pretty badly documented, and that's 
>>> a system call.
>> 
>> How about the man page below?  I tried to avoid the somewhat antiquated 
>> implementation specific terminology in the sync(2) man page.
>> 
>> I think adding this functionality into sync_file_range(2) is forcing 
>> unrelated functionality into an existing interface; sync_file_range 
>> operates on _files_, not an entire file system.  With each API addition it 
>> is more important to make the interface simple and intuitive than to 
>> minimize the size of our patches.  IMO that's why a new syscall is 
>> preferable to, say, an equivalent ioctl.
>> 
>> Thanks-
>> sage
>> 
>> 
>> .TH SYNCFS 2 2011-03-13 "Linux" "Linux Programmer's Manual"
>> .SH NAME
>> syncfs \- commit cached file system state to stable storage
>> .SH SYNOPSIS
>> .B #include <unistd.h>
>> .sp
>> .B void syncfs(int fd);
>> .SH DESCRIPTION
>> .BR syncfs ()
>> flushes any cached data modifications to the file system containing the 
>> file referenced by the file descriptor
>> .I fd
>> to stable storage (usually a disk).  This includes the results of any
>> file modifications or other file system operations that have completed
>> prior to the call to
>> .BR syncfs(2).
>> This is similar to 
>> .BR sync(2),
>> but will commit changes for only a single file system instead of all
>> mounted file systems.
>> .SH ERRORS
>> This function is always successful.
> 
> Perhaps we should consider propagating errors out to the user
> application rather than discarding them in kernel and pretending we
> can't ever have a write error?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
