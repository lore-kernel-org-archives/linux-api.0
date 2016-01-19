From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Mon, 18 Jan 2016 18:57:47 -0800
Message-ID: <569DA62B.7070701@codeaurora.org>
References: <565394BE.4040506@codeaurora.org> <5696E366.2080605@codeaurora.org> <20160114045716.GB8006@kroah.com> <5697EF97.9020800@codeaurora.org> <CA+55aFwxaU0Y_UxyKFv6WaYsPWDDzZG-rhVtMuLSPcJ0WLLw2A@mail.gmail.com> <CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g@mail.gmail.com> <CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw@mail.gmail.com> <871t9i91e1.fsf@thinkpad.rath.org> <56994884.9060002@codeaurora.org> <CA+55aFw9N6Qt=5Q7z+rc_KsotiDgwizm-3Ym6Q70azkb2b3YOA@mail.gmail.com> <CALCETrUA2veiBYYbN1hCSkHxBFyDpe3b=PXg=j53_ZuQBt1FUw@mail.gmail.com> <CA+55aFyFLEkAthR=aUV2noQspgpZ8ascNCCftNBdEGaLvi199A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyFLEkAthR=aUV2noQspgpZ8ascNCCftNBdEGaLvi199A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Nikolaus Rath <nikolaus@rath.org>, fuse-devel <fuse-devel@lists.sourceforge.net>, Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, sven.utcke@gmx.de, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Antonio SJ Musumeci <trapexit@spawn.link>
List-Id: linux-api@vger.kernel.org

On 01/15/2016 01:53 PM, Linus Torvalds wrote:
> On Fri, Jan 15, 2016 at 1:46 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
>> If mmap sets vm_file to the underlying thing, wouldn't CRIU and
>> anything else that uses map_files get confused?  Or did you have
>> something else in mind?
>
> Why would they care?
>
> Also, I don't think you actually need to change vm_file - we have this
> whole notion of "inode->i_data" vs "inode->i_mapping".
>
> So I think you could set the "i_mapping" of the fuse inode to be the
> i_mapping of the passed-through-to inode, and it should just work.
>
> And no, I didn't look into this very deeply, and maybe there is some
> annoying detail that would make that not work well. But that's part of
> the whole point of the i_mapping indirection: so that you can share
> the page cache when you have two separate anchor points. I think coda
> uses it for the local caching, and block devices use it to not have
> mapping aliases between different inodex that all are the same block
> device.
>
>                   Linus
>

Hi

Thanks for your support.

I am looking  into adding the mmap by change the i_mmaping but seems to 
be getting stuck for some stress tests.

Once i get that debugged and working i will definitely send out a new 
patch with that functionality.

( Sending it as a second patch will help make it easier to go through 
the legal redtape and procedures i am forced to follow).

For now i am going to update the current patch and call it "passthrough" 
as you suggested and also update the commit message giving  a clearer 
explanation of the motivation.

Once i get it tested I can send it out for consideration and review

Please do let me know if you have any questions or concerns on this and 
i will try my best to address them all.


-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
