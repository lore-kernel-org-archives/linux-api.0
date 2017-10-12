From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [1/2,v2] fdmap(2)
Date: Thu, 12 Oct 2017 01:06:15 -0700
Message-ID: <20171012080608.GA23077@outlook.office365.com>
References: <20170924200620.GA24368@avx2>
 <20171010220804.GA30735@outlook.office365.com>
 <20171011181234.GB2119@avx2>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171011181234.GB2119@avx2>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gladkov.alexey-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 11, 2017 at 09:12:34PM +0300, Alexey Dobriyan wrote:
> On Tue, Oct 10, 2017 at 03:08:06PM -0700, Andrei Vagin wrote:
> > On Sun, Sep 24, 2017 at 11:06:20PM +0300, Alexey Dobriyan wrote:
> > > From: Aliaksandr Patseyenak <Aliaksandr_Patseyenak1-uRwfk40T5oI@public.gmane.org>
> > > 
> > > Implement system call for bulk retrieveing of opened descriptors
> > > in binary form.
> > > 
> > > Some daemons could use it to reliably close file descriptors
> > > before starting. Currently they close everything upto some number
> > > which formally is not reliable. Other natural users are lsof(1) and CRIU
> > > (although lsof does so much in /proc that the effect is thoroughly buried).
> > 
> > Hello Alexey,
> > 
> > I am not sure about the idea to add syscalls for all sort of process
> > attributes. For example, in CRIU we need file descriptors with their
> > properties, which we currently get from /proc/pid/fdinfo/. How can
> > this interface be extended to achieve our goal?
> > 
> > Have you seen the task-diag interface what I sent about a year ago?
> 
> Of course, let's discuss /proc/task_diag.
> 
> Adding it as /proc file is obviously unnecessary: you do it only
> to hook ->read and ->write netlink style
> (and BTW you don't need .THIS_MODULE anymore ;-)
> 
> Transactional netlink send and recv aren't necessary either.
> As I understand it, it comes from old times when netlink was async,
> so 2 syscalls were neccesary. Netlink is not async anymore.
> 
> Basically you want to do sys_task_diag(2) which accepts set of pids
> (maybe) and a mask (see statx()) and returns synchronously result into
> a buffer.

You are not quite right here. We send a request and then we read a
response, which can be bigger than what we can read for one call.

So we need something like a cursor, in your case it is the "start"
argument. But sometimes this cursor contains a kernel internal data
to have a better performance. We need to have a way to address this
cursor from userspace, and it is a reason why we need a file
descriptor in this scheme.

For example, you can look at the proc_maps_private structure.


> 
> > We had a discussion on the previous kernel summit how to rework
> > task-diag, so that it can be merged into the upstream kernel.
> > Unfortunately, I didn't send a summary for this discussion. But it's
> > better now than never. We decided to do something like this:
> > 
> > 1. Add a new syscall readfile(fname, buf, size), which can be
> > used to read small files without opening a file descriptor. It will be
> > useful for proc files, configs, etc.
> 
> If nothing, it should be done because the number of programmers capable
> of writing readfile() in userspace correctly handling all errors and
> short reads is very small indeed. Out of curiosity I once booted a kernel
> which made all reads short by default. It was fascinating I can tell you.
> 
> > 2. bin/text/bin conversion is very slow
> >  - 65.47% proc_pid_status
> >   - 20.81% render_sigset_t
> >    - 18.27% seq_printf
> >     + 15.77% seq_vprintf
> >   - 10.65% task_mem
> >     + 8.78% seq_print
> >     + 1.02% hugetlb_rep
> >   + 7.40% seq_printf
> > so a new interface has to use a binary format and the format of netlink
> > messages can be used here. It should be possible to extend a file
> > without breaking backward compatibility.
> 
> Binary -- yes.
> netlink attributes -- maybe.
> 
> There is statx() model which is perfect for this usecase:
> do not want pagecache of all block devices? sure, no problem.
> 
> > 3. There are a lot of objection to use a netlink sockets out of the network
> > subsystem. The idea of using a "transaction" file looks weird for many
> > people, so we decided to add a few files in /proc/pid/. I see
> > minimum two files. One file contains information about a task, it is
> > mostly what we have in /proc/pid/status and /proc/pid/stat. Another file
> > describes a task memory, it is what we have now in /proc/pid/smaps.
> > Here is one more major idea. All attributes in a file has to be equal in
> > term of performance, or by other words there should not be attributes,
> > which significantly affect a generation time of a whole file.
> > 
> > If we look at /proc/pid/smaps, we spend a lot of time to get memory
> > statistics. This file contains a lot of data and if you read it to get
> > VmFlags, the kernel will waste your time by generating a useless data
> > for you.
> 
> There is a unsolvable problem with /proc/*/stat style files. Anyone
> who wants to add new stuff has a desicion to make, whether add new /proc
> file or extend existing /proc file.
> 
> Adding new /proc file means 3 syscalls currently, it surely will become
> better with aforementioned readfileat() but even adding tons of symlinks
> like this:
> 
> 	$ readlink /proc/self/affinity
> 	0f
> 
> would have been better -- readlink doesn't open files.
> 
> Adding to existing file means _all_ users have to eat the cost as
> read(2) doesn't accept any sort of mask to filter data. Most /proc files
> are seqfiles now which most of the time internally generates whole buffer
> before shipping data to userspace. cat(1) does 32KB read by default
> which is bigger than most of files in /proc and stat'ing /proc files is
> useless because they're all 0 length. Reliable rewinding to necessary data
> is possible only with memchr() which misses the point.
> 
> Basically, those sacred text files the Universe consists of suck.
> 
> With statx() model the cost of extending result with new data is very
> small -- 1 branch to skip generation of data.
> 
> I suggest that anyone who dares to improve the situation with process
> statistics and anything /proc related uses it as a model.
> 
> Of course, I also suggest to freeze /proc for new stuff to press
> the issue but one can only dream.


I'm agree with your points, but I think you choose a wrong set of data
to make an example of a new approach.

You are talking a lot about statx, but for me it is unclear how fdmap
follows the idea of statx. Let's imagine that I want to extend fdmap to
return mnt_id for each file descriptor?

Or it may be more complex case, when we decided to provide all data
from /proc/pid/fdinfo/X for each descriptor. A set of fields in fdinfo
depends on a type of a file descriptor, it is different for epoll,
signalfd, inotify, sockets, etc.

For inotify file descriptors, there are information about all watches,
so it is not possible to use a fixed size struture to present this data.

I like the interface of statx, but this case is more complex.

Thanks,
Andrei
