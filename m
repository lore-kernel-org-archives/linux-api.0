From: Nikhilesh Reddy <reddyn-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Wed, 20 Jan 2016 15:24:12 -0800
Message-ID: <56A0171C.6050108@codeaurora.org>
References: <565394BE.4040506@codeaurora.org> <5696E366.2080605@codeaurora.org> <20160114045716.GB8006@kroah.com> <5697EF97.9020800@codeaurora.org> <CA+55aFwxaU0Y_UxyKFv6WaYsPWDDzZG-rhVtMuLSPcJ0WLLw2A@mail.gmail.com> <CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g@mail.gmail.com> <CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw@mail.gmail.com> <871t9i91e1.fsf@thinkpad.rath.org> <56994884.9060002@codeaurora.org> <CA+55aFw9N6Qt=5Q7z+rc_KsotiDgwizm-3Ym6Q70azkb2b3YOA@mail.gmail.com> <CALCETrUA2veiBYYbN1hCSkHxBFyDpe3b=PXg=j53_ZuQBt1FUw@mail.gmail.com> <CA+55aFyFLEkAthR=aUV2noQspgpZ8ascNCCftNBdEGaLvi199A@mail.gmail.com> <569DA62B.7070701@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569DA62B.7070701-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Nikolaus Rath <nikolaus-BTH8mxji4b0@public.gmane.org>, fuse-devel <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, sven.utcke-Mmb7MZpHnFY@public.gmane.org, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Antonio SJ Musumeci <trapexit-wGTF+nt6ur047o9RxwvyTQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 01/18/2016 06:57 PM, Nikhilesh Reddy wrote:
> On 01/15/2016 01:53 PM, Linus Torvalds wrote:
>> On Fri, Jan 15, 2016 at 1:46 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>> wrote:
>>
>>> If mmap sets vm_file to the underlying thing, wouldn't CRIU and
>>> anything else that uses map_files get confused?  Or did you have
>>> something else in mind?
>>
>> Why would they care?
>>
>> Also, I don't think you actually need to change vm_file - we have this
>> whole notion of "inode->i_data" vs "inode->i_mapping".
>>
>> So I think you could set the "i_mapping" of the fuse inode to be the
>> i_mapping of the passed-through-to inode, and it should just work.
>>
>> And no, I didn't look into this very deeply, and maybe there is some
>> annoying detail that would make that not work well. But that's part of
>> the whole point of the i_mapping indirection: so that you can share
>> the page cache when you have two separate anchor points. I think coda
>> uses it for the local caching, and block devices use it to not have
>> mapping aliases between different inodex that all are the same block
>> device.
>>
>>                   Linus
>>
>
> Hi
>
> Thanks for your support.
>
> I am looking  into adding the mmap by change the i_mmaping but seems to
> be getting stuck for some stress tests.
>
> Once i get that debugged and working i will definitely send out a new
> patch with that functionality.
>
> ( Sending it as a second patch will help make it easier to go through
> the legal redtape and procedures i am forced to follow).
>
> For now i am going to update the current patch and call it "passthrough"
> as you suggested and also update the commit message giving  a clearer
> explanation of the motivation.
>
> Once i get it tested I can send it out for consideration and review
>
> Please do let me know if you have any questions or concerns on this and
> i will try my best to address them all.
>
>
I have just sent out the latest version of the patch in the email with 
the subject
[PATCH v3] fuse: Add support for passthrough read/write

Please do let me know if you have any questions or concerns on this and
i will try my best to address them all.

-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
