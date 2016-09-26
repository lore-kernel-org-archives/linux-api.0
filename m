From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: Naming O_TMPFILE files
Date: Mon, 26 Sep 2016 17:11:37 +0200
Message-ID: <874m52y9ue.fsf@mid.deneb.enyo.de>
References: <0831c636-4513-7c6c-255d-737a4415c8af@redhat.com>
        <2be4ffbb-abab-42c8-88a3-910230bf0d13@redhat.com>
        <aaa0de0c-fe63-52b9-3092-ee15799323b9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <aaa0de0c-fe63-52b9-3092-ee15799323b9@gmail.com> (Michael
        Kerrisk's message of "Mon, 26 Sep 2016 10:11:04 +0200")
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Florian Weimer <fweimer@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, aneesh.kumar@linux.vnet.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

* Michael Kerrisk:

> On 09/23/2016 10:41 AM, Florian Weimer wrote:
>>> The attached test program prints under a non-privileged user:
>>>
>>> error: linkat (fd, "", AT_FDCWD, out_name, AT_EMPTY_PATH):
>>>   No such file or directory
>>> error: linkat (fd, "", current_fd, out_name, AT_EMPTY_PATH):
>>>   No such file or directory
>>> success: linkat (AT_FDCWD, proc_name, AT_FDCWD, out_name,
>>> AT_SYMLINK_FOLLOW)
>>> error: linkat (AT_FDCWD, proc_name, current_fd, out_name,
>>> AT_SYMLINK_FOLLOW):
>>>   No such file or directory
>>> error: linkat (proc_fd, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>>>   No such file or directory
>>> error: linkat (proc_fd, proc_name, current_fd, out_name,
>>> AT_SYMLINK_FOLLOW):
>>>   No such file or directory
>>> successes: 1, failures: 5
>>>
>>> And under a privileged user:
>>>
>>> success: linkat (fd, "", AT_FDCWD, out_name, AT_EMPTY_PATH)
>>> error: linkat (fd, "", current_fd, out_name, AT_EMPTY_PATH):
>>>   No such file or directory
>>> error: linkat (AT_FDCWD, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>>>   No such file or directory
>>> error: linkat (AT_FDCWD, proc_name, current_fd, out_name,
>>> AT_SYMLINK_FOLLOW):
>>>   No such file or directory
>>> error: linkat (proc_fd, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>>>   No such file or directory
>>> error: linkat (proc_fd, proc_name, current_fd, out_name,
>>> AT_SYMLINK_FOLLOW):
>>>   No such file or directory
>>> successes: 1, failures: 5
>>>
>>> (Seen on tmpfs and XFS, 4.7.x kernels.)
>>>
>>> I double-checked with strace, and the test case does not appear to be
>>> broken.  But the exhibited behavior is truly bizarre, and it means that
>>> it is very difficult to give a name to an O_TMPFILE file.
>> 
>> The test case is broken because it does not account for the fact that an 
>> O_TMPFILE file can only be linked once in this way.  This is still a bit 
>> counter-intuitive, but it means that O_TMPFILE works.
>
> Florian, could you elaborate on the "can only be linked once in 
> this way"? In my experiments, it's possible to link multiple times 
> to the O_TMPFILE file.

It's in the quoted bits above.  After the first success, subsequent
attempts at linking the same file descriptor (with AT_EMPTY_PATH or
the /proc/self/fd kludge) fail.  This is what confused me so much, and
makes the behavior seem extremely erratic.
