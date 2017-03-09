From: Joseph Myers <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>
Subject: Re: binfmts.h MAX_ARG_STRINGS excessive value allows heap spraying
Date: Thu, 9 Mar 2017 23:10:26 +0000
Message-ID: <alpine.DEB.2.20.1703092304110.23273@digraph.polyomino.org.uk>
References: <1488897868.5178.3.camel@quad>         <f7f9f60b-0f39-7dce-1778-3aa40ba198ef@redhat.com>         <1488997111.5155.10.camel@quad>         <f16cd7f8-f996-cf66-d640-50b0ccee06c7@redhat.com> <1489068854.1026.14.camel@quad>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489068854.1026.14.camel@quad>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leonard den Ottolander <leonard-lists-2Avth2y2NeLyQNdsBcn8aGZHpeb/A1Y/@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 9 Mar 2017, Leonard den Ottolander wrote:

> So if we really want to support lets say users having directories of
> 128k files we can now safely set MAX_ARG_STRINGS to 131072 and assuming
> an average file name length of 32 set MAX_ARG_STRSLEN to 4194304.

I think 128k files is too small.  E.g. I have nearly 4 million archived 
emails here, and I'm sure many people have many more than that, and it's 
common to store emails one per file in a large directory (although I'm not 
storing them like that), and I think normal command-line tools ought to be 
able to take all the files in such a directory on the command line at 
once.

I think it's best not to limit the number of arguments beyond the limit 
implied by argc being an int, and no individual object (e.g. the argv 
array) taking up half or more of the address space, along possibly with a 
limit on the proportion of the whole address space taken up by 
(command-line arguments + environment variables + all the pointers to 
those).

-- 
Joseph S. Myers
joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org
