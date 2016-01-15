From: Nikhilesh Reddy <reddyn@codeaurora.org>
Subject: Re: [PATCH] fuse: Add support for fuse stacked I/O
Date: Fri, 15 Jan 2016 11:29:08 -0800
Message-ID: <56994884.9060002@codeaurora.org>
References: <565394BE.4040506@codeaurora.org> <5696E366.2080605@codeaurora.org> <20160114045716.GB8006@kroah.com> <5697EF97.9020800@codeaurora.org> <CA+55aFwxaU0Y_UxyKFv6WaYsPWDDzZG-rhVtMuLSPcJ0WLLw2A@mail.gmail.com> <CALCETrWNQ9ytw1bCOOjFJRstauYc6DocQAmZCF61CErAJ5BF2g@mail.gmail.com> <CAB3-ZyT+xcU-0BnNvq-+GsDe6W8=MCWwxguS-+KQ39gajmM5pw@mail.gmail.com> <871t9i91e1.fsf@thinkpad.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871t9i91e1.fsf@thinkpad.rath.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nikolaus Rath <nikolaus@rath.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Linus Torvalds <torvalds@linux-foundation.org>, fuse-devel <fuse-devel@lists.sourceforge.net>, Al Viro <viro@zeniv.linux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, sven.utcke@gmx.de, Miklos Szeredi <miklos@szeredi.hu>, Richard Weinberger <richard@nod.at>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Antonio SJ Musumeci <trapexit@spawn.link>
List-Id: linux-api@vger.kernel.org

On Fri 15 Jan 2016 09:51:50 AM PST, Nikolaus Rath wrote:
> On Jan 15 2016, Antonio SJ Musumeci <trapexit@spawn.link> wrote:
>> The idea is that you want to be able to reason about open, create, etc. but
>> don't care about the data transfer.
>>
>> I have N filesystems I wish to unionize. When I create a new file I want to
>> pick the drive with the most free space (or some other algo). creat is
>> called, succeeds, and now the application issuing this starts writing. The
>> FUSE fs doesn't care about the writes. It just wanted to pick the drive
>> this file should have been created on. Anything I'd do with the FD after
>> that I'm happy to short circuit. I don't need to be asked what to do when
>> fstat'ing this FD or anything which in FUSE hands over the 'fh'. It's just
>> a file descriptor for me and I'd simply be calling the same function.
>>
>> Ideally I think one would want to be able to select which functions to
>> short circuit and maybe even have it so that a short circuited function
>> could propagate back through FUSE on error. But the read and write short
>> circuiting is probably the biggest win given the overhead.
>
>
> I think you should avoid using the term "stacked" completely (which
> would also make Christoph happy). There have been several discussions in
> the past about adding a "fd delegation" function to FUSE. Generally, the
> idea is that the FUSE userspace code tells the FUSE kernel module to
> internally "delegate" to writes and reads for a given file (or even a
> range in that file) to a different file descriptor provided by
> userspace.
>
> I think that function would be useful, and not just for union file
> systems. There are many FUSE file systems that end up writing the data
> into some other file on the disk without doing any transformations on
> the data itself. Especially with the range feature, they would all
> benefit from the ability to delegate reads and writes.
>
> However, Miklos has said in the past that the performance gain from this
> is very small. You can get almost as good a result by splicing from one
> fd to the other in userspace. In that case this function could actually
> be implemented completely in libfuse.
>
>
> Do you have any benchmark results that compare a splice-in-userspace
> approach with your patch?
>
>
> Best,
> -Nikolaus
>


Hi

@Linus
Thanks for taking the time to reply to my email. It means a lot.

FUSE allows users to implement extensions to filesystems ..such as enforcing policy or permissions without having to modify the kernel or maintain the policy in the kernel.

One such example is what was quoted by Antonio above .. 
Another example is a fuse based filesystem that tries to enforce additional permissions on a FAT based mount point.

>From what i could google there are many FUSE based filesystems out there that do things during the open call but simply pass through the read/and write I/O calls to the local "lower" filesystem where they actually store the data.

>From what i understand ...unionfs or overlayfs and similar filesystems are primarily used to support a merged or unified view of directories and do not offer mechanisms to add policy or other checks /extensions to the I/O operations without modifying the kernel..

The main motivation is to make FUSE performance better in such usecases without loosing out on the ease of implementing and extending in the userspace.



@Nikolaus
Our local benchmarks on embedded devices (where power and cpu usage is critical) show that splice doesnt help as much .. when running multiple cpu's results in increased power usage

The below results are on a specific device model.

Where IOPS is number of 4K based read or writes that could be performed each second.

                                 regular         spliced         Stacked I/O
sequencial write (MiBPS)	56.55633333	100.34445       141.7096667
sequencial read (MiBPS)	        49.644	        60.43434        122.367

random write (IOPS)	        2554.333333	4053.4545       8572
random read (IOPS)	        977.3333333	1223.34         1432.666667

The above tests were performed using a file size of 1GB

Using stacked I/O showed the best performance (almost the same as the native EXT4 filesystem that is storing the real file)

Also we measured that there is a 5% saving of Power and the CPU timeslices used. ( Splice did not improve this at all compared to default fuse)

Random I/O i.e seeking to random parts of a file and reading ( usecases such as elf and *.so loading from fuse based filesystems also improved 


Similarly when using MMAPED I/O ( in an extended patch to this one.. still in progress) showed a significant improvement about a 400% improvement over default fuse.

Also we can called it FUSE_DELEGATED_IO if that helps :).
I chose to call is stacked i/o since we are technically stacking the fuse read/writes on the ext4/fat or other filesystems.

Please let me know if you have any questions.

@everyone
Thanks so much for your comments and the interest.
Also many of you have shown support for the patch in private emails.
I would be grateful if you could voice the same support on the public thread so that everyone knows that there is interest in this patch.


-- 
Thanks
Nikhilesh Reddy

Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
