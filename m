From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [RFC][PATCH v2] procfs: Always expose /proc/<pid>/map_files/ and
 make it readable
Date: Mon, 26 Jan 2015 16:15:26 -0800
Message-ID: <CAGXu5jLDkg0hJSMm3CdoO-77yiK5GQWHSe3+1h7mq76LERpNBA@mail.gmail.com>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
	<20150114152501.GB9820@node.dhcp.inet.fi>
	<20150114153323.GF2253@moon>
	<20150114204653.GA26698@mail.thefacebook.com>
	<20150114211613.GH2253@moon>
	<20150122024554.GB23762@mail.thefacebook.com>
	<20150124031544.GA1992748@mail.thefacebook.com>
	<20150126124731.GA26916@node.dhcp.inet.fi>
	<20150126210054.GG651@moon>
	<20150126154346.c63c512e5821e9e0ea31f759@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150126154346.c63c512e5821e9e0ea31f759-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Feiner <pfeiner-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Siddhesh Poyarekar <siddhesh.poyarekar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jan 26, 2015 at 3:43 PM, Andrew Morton
<akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Tue, 27 Jan 2015 00:00:54 +0300 Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Mon, Jan 26, 2015 at 02:47:31PM +0200, Kirill A. Shutemov wrote:
>> > On Fri, Jan 23, 2015 at 07:15:44PM -0800, Calvin Owens wrote:
>> > > Currently, /proc/<pid>/map_files/ is restricted to CAP_SYS_ADMIN, and
>> > > is only exposed if CONFIG_CHECKPOINT_RESTORE is set. This interface
>> > > is very useful for enumerating the files mapped into a process when
>> > > the more verbose information in /proc/<pid>/maps is not needed.
>
> This is the main (actually only) justification for the patch, and it it
> far too thin.  What does "not needed" mean.  Why can't people just use
> /proc/pid/maps?
>
>> > > This patch moves the folder out from behind CHECKPOINT_RESTORE, and
>> > > removes the CAP_SYS_ADMIN restrictions. Following the links requires
>> > > the ability to ptrace the process in question, so this doesn't allow
>> > > an attacker to do anything they couldn't already do before.
>> > >
>> > > Signed-off-by: Calvin Owens <calvinowens-b10kYP2dOMg@public.gmane.org>
>> >
>> > Cc +linux-api@
>>
>> Looks good to me, thanks! Though I would really appreciate if someone
>> from security camp take a look as well.
>
> hm, who's that.  Kees comes to mind.
>
> And reviewers' task would be a heck of a lot easier if they knew what
> /proc/pid/map_files actually does.  This:
>
> akpm3:/usr/src/25> grep -r map_files Documentation

If akpm's comments weren't clear: this needs to be fixed. Everything
in /proc should appear in Documentation.

> akpm3:/usr/src/25>
>
> does not help.
>
> The 640708a2cff7f81 changelog says:
>
> :     This one behaves similarly to the /proc/<pid>/fd/ one - it contains
> :     symlinks one for each mapping with file, the name of a symlink is
> :     "vma->vm_start-vma->vm_end", the target is the file.  Opening a symlink
> :     results in a file that point exactly to the same inode as them vma's one.
> :
> :     For example the ls -l of some arbitrary /proc/<pid>/map_files/
> :
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80403000-7f8f80404000 -> /lib64/libc-2.5.so
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f8061e000-7f8f80620000 -> /lib64/libselinux.so.1
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80826000-7f8f80827000 -> /lib64/libacl.so.1.1.0
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a2f000-7f8f80a30000 -> /lib64/librt-2.5.so
> :      | lr-x------ 1 root root 64 Aug 26 06:40 7f8f80a30000-7f8f80a4c000 -> /lib64/ld-2.5.so

How is mmap offset represented in this output?

>
> afacit this info is also available in /proc/pid/maps, so things
> shouldn't get worse if the /proc/pid/map_files permissions are at least
> as restrictive as the /proc/pid/maps permissions.  Is that the case?
> (Please add to changelog).

Both maps and map_files uses ptrace_may_access (via mm_acces) with
PTRACE_MODE_READ, so I'm happy from a info leak perspective.

Are mount namespaces handled in this output?

> There's one other problem here: we're assuming that the map_files
> implementation doesn't have bugs.  If it does have bugs then relaxing
> permissions like this will create new vulnerabilities.  And the
> map_files implementation is surprisingly complex.  Is it bug-free?

-Kees

-- 
Kees Cook
Chrome OS Security
