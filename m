From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: Naming O_TMPFILE files
Date: Mon, 26 Sep 2016 10:11:04 +0200
Message-ID: <aaa0de0c-fe63-52b9-3092-ee15799323b9@gmail.com>
References: <0831c636-4513-7c6c-255d-737a4415c8af@redhat.com>
 <2be4ffbb-abab-42c8-88a3-910230bf0d13@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <2be4ffbb-abab-42c8-88a3-910230bf0d13@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, aneesh.kumar@linux.vnet.ibm.com, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: mtk.manpages@gmail.com
List-Id: linux-api@vger.kernel.org

On 09/23/2016 10:41 AM, Florian Weimer wrote:
> On 09/21/2016 01:50 PM, Florian Weimer wrote:
>> AT_EMPTY_PATH is supposed to be able to give names to files created with
>> O_TMPFILE unless O_EXCL was specified at creation time.
>>
>> However, since this commit
>>
>> commit 11a7b371b64ef39fc5fb1b6f2218eef7c4d035e3
>> Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Date:   Sat Jan 29 18:43:42 2011 +0530
>>
>> fs: allow AT_EMPTY_PATH in linkat(), limit that to CAP_DAC_READ_SEARCH
>>
>> linkat bails out early with AT_EMPTY_PATH and !CAP_DAC_READ_SEARCH,
>> never looking at O_EXCL.
>>
>> The /proc/self/fd kludge works for unprivileged users, but only if
>> *both* paths use AT_FDCWD.  It fails if the first path uses a real
>> descriptor for /proc/self/fd, or if the second path uses a real
>> descriptor for the current directory, or both.  For privileged users,
>> only AT_EMPTY_PATH case with an AT_FDCWD target works.
>>
>> The attached test program prints under a non-privileged user:
>>
>> error: linkat (fd, "", AT_FDCWD, out_name, AT_EMPTY_PATH):
>>   No such file or directory
>> error: linkat (fd, "", current_fd, out_name, AT_EMPTY_PATH):
>>   No such file or directory
>> success: linkat (AT_FDCWD, proc_name, AT_FDCWD, out_name,
>> AT_SYMLINK_FOLLOW)
>> error: linkat (AT_FDCWD, proc_name, current_fd, out_name,
>> AT_SYMLINK_FOLLOW):
>>   No such file or directory
>> error: linkat (proc_fd, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>>   No such file or directory
>> error: linkat (proc_fd, proc_name, current_fd, out_name,
>> AT_SYMLINK_FOLLOW):
>>   No such file or directory
>> successes: 1, failures: 5
>>
>> And under a privileged user:
>>
>> success: linkat (fd, "", AT_FDCWD, out_name, AT_EMPTY_PATH)
>> error: linkat (fd, "", current_fd, out_name, AT_EMPTY_PATH):
>>   No such file or directory
>> error: linkat (AT_FDCWD, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>>   No such file or directory
>> error: linkat (AT_FDCWD, proc_name, current_fd, out_name,
>> AT_SYMLINK_FOLLOW):
>>   No such file or directory
>> error: linkat (proc_fd, proc_name, AT_FDCWD, out_name, AT_SYMLINK_FOLLOW):
>>   No such file or directory
>> error: linkat (proc_fd, proc_name, current_fd, out_name,
>> AT_SYMLINK_FOLLOW):
>>   No such file or directory
>> successes: 1, failures: 5
>>
>> (Seen on tmpfs and XFS, 4.7.x kernels.)
>>
>> I double-checked with strace, and the test case does not appear to be
>> broken.  But the exhibited behavior is truly bizarre, and it means that
>> it is very difficult to give a name to an O_TMPFILE file.
> 
> The test case is broken because it does not account for the fact that an 
> O_TMPFILE file can only be linked once in this way.  This is still a bit 
> counter-intuitive, but it means that O_TMPFILE works.

Florian, could you elaborate on the "can only be linked once in 
this way"? In my experiments, it's possible to link multiple times 
to the O_TMPFILE file.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
