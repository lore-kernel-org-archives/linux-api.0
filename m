From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Fri, 15 Jan 2016 13:46:00 -0800
Message-ID: <CALCETrUA2veiBYYbN1hCSkHxBFyDpe3b=PXg=j53_ZuQBt1FUw@mail.gmail.com>
References: <565394BE.4040506@codeaurora.org> <5696E366.2080605@codeaurora.org>
 <20160114045716.GB8006@kroah.com> <5697EF97.9020800@codeaurora.org>
 <CA+55aFwxaU0Y_UxyKFv6WaYsPWDDzZG-rhVtMuLSPcJ0WLLw2A@mail.gmail.com>
 <CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g@mail.gmail.com>
 <CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw@mail.gmail.com>
 <871t9i91e1.fsf@thinkpad.rath.org> <56994884.9060002@codeaurora.org> <CA+55aFw9N6Qt=5Q7z+rc_KsotiDgwizm-3Ym6Q70azkb2b3YOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFw9N6Qt=5Q7z+rc_KsotiDgwizm-3Ym6Q70azkb2b3YOA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nikhilesh Reddy <reddyn@codeaurora.org>, Nikolaus Rath <nikolaus@rath.org>, fuse-devel <fuse-devel@lists.sourceforge.net>, Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, sven.utcke@gmx.de, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Antonio SJ Musumeci <trapexit@spawn.link>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 15, 2016 at 1:43 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jan 15, 2016 at 11:29 AM, Nikhilesh Reddy <reddyn@codeaurora.org> wrote:
>>
>> FUSE allows users to implement extensions to filesystems ..such as enforcing policy or permissions without having to modify the kernel or maintain the policy in the kernel.
>>
>> One such example is what was quoted by Antonio above ..
>> Another example is a fuse based filesystem that tries to enforce additional permissions on a FAT based mount point.
>>
>> From what i could google there are many FUSE based filesystems out there that do things during the open call but simply pass through the read/and write I/O calls to the local "lower" filesystem where they actually store the data.
>
> So I think these are valid use-cases, and I just think that they should
>
>  (a) be documented in the commit message as explanations of why people
> would do this/
>
>  (b) not be called "stacked", because that tends to have some other
> connotations to fs people.
>
> I don't know what a better term would be, but you yourself used "pass
> through". Maybe that (perhaps together with a clarification that it's
> a per-file thing) might work fine.
>
> Btw, why is mmap not passed through? That sounds fairly simple and
> straightforward, I'm not seeing why it would be missing.
>

If mmap sets vm_file to the underlying thing, wouldn't CRIU and
anything else that uses map_files get confused?  Or did you have
something else in mind?

--Andy
