From: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH RESEND 2/2] pidns: Expose task pid_ns_for_children to
 userspace
Date: Fri, 31 Mar 2017 12:45:40 +0300
Message-ID: <0825f166-6f20-59a9-45a9-5ffe9009150e@virtuozzo.com>
References: <149086931397.4388.9604947335273204415.stgit@localhost.localdomain>
 <149086967937.4388.471494976517194744.stgit@localhost.localdomain>
 <20170330150520.1bdf20e599ff464bda0776b9@linux-foundation.org>
 <20170331010409.GA22895@outlook.office365.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170331010409.GA22895-1ViLX0X+lBJGNQ1M2rI3KwRV3xvJKrda@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 31.03.2017 04:04, Andrei Vagin wrote:
> On Thu, Mar 30, 2017 at 03:05:20PM -0700, Andrew Morton wrote:
>> On Thu, 30 Mar 2017 13:27:59 +0300 Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>>
>>> pid_ns_for_children set by a task is known only to the task itself,
>>> and it's impossible to identify it from outside.
>>>
>>> It's a big problem for checkpoint/restore software like CRIU,
>>> because it can't correctly handle tasks, that do setns(CLONE_NEWPID)
>>> in proccess of their work.
>>>
>>> This patch solves the problem, and it exposes pid_ns_for_children
>>> to ns directory in standard way with the name "pid_for_children":
>>>
>>> ~# ls /proc/5531/ns -l | grep pid
>>> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
>>> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]
>>>
>>> --- a/fs/proc/namespaces.c
>>> +++ b/fs/proc/namespaces.c
>>> @@ -23,6 +23,7 @@ static const struct proc_ns_operations *ns_entries[] = {
>>>  #endif
>>>  #ifdef CONFIG_PID_NS
>>>  	&pidns_operations,
>>> +	&pidns_for_children_operations,
>>>  #endif
>>
>> This interface should be documented somewhere under Documentation/. 
>> But I can't immediately find where the /proc/pid/ns/ pseudo-files are
>> documented...
> 
> I know that they are documented in man7/namespaces.7
> 
> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/tree/man7/namespaces.7#n187

I suggest the below patch, but it's too early for the man description till
the feature is in mainline, because the man page requires commit id of the feature.

[PATCH] namespaces.7: Document the /proc/[pid]/ns/pid_for_children file

Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 man7/namespaces.7 | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)
diff --git a/man7/namespaces.7 b/man7/namespaces.7
index 6dfceaa2a..06041774f 100644
--- a/man7/namespaces.7
+++ b/man7/namespaces.7
@@ -125,6 +125,7 @@ lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 ipc \-> ipc:[4026531839]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 mnt \-> mnt:[4026531840]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 net \-> net:[4026531969]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 pid \-> pid:[4026531836]
+lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 pid_for_children -> pid:[4026531834]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 user \-> user:[4026531837]
 lrwxrwxrwx. 1 mtk mtk 0 Apr 28 12:46 uts \-> uts:[4026531838]
 .fi
@@ -186,7 +187,14 @@ This file is a handle for the network namespace of the process.
 .TP
 .IR /proc/[pid]/ns/pid " (since Linux 3.8)"
 .\" commit 57e8391d327609cbf12d843259c968b9e5c1838f
-This file is a handle for the PID namespace of the process.
+This file is a handle for the PID namespace of the process. It's
+permanent during the whole process life.
+.TP
+.IR /proc/[pid]/ns/pid_for_children " (since Linux 4.12)"
+.\" commit FIXME
+This file is a handle for the PID namespace of a next born child
+of the process. It's changed after unshare(2) and via setns(2),
+so the file may differ from /proc/[pid]/ns/pid.
 .TP
 .IR /proc/[pid]/ns/user " (since Linux 3.8)"
 .\" commit cde1975bc242f3e1072bde623ef378e547b73f91
