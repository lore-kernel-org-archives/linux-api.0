From: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] pidns: Expose task pid_ns_for_children to userspace
Date: Mon, 23 Jan 2017 22:49:14 +0100
Message-ID: <CAMXgnP7gs_SXTj3yLFSM9DVfmN09m7q0hYQN-9oa3aV4eYgw5w@mail.gmail.com>
References: <148440326011.30622.12833059348082223242.stgit@localhost.localdomain>
 <148440329770.30622.16593902895676160550.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <148440329770.30622.16593902895676160550.stgit-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 14 January 2017 at 15:15, Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
> For correct checkpointing/restoring of a task from userspace
> it's need to know the task's pid_ns_for_children. Currently,
> there is no a sane way to do that (the only possible trick
> is to force the task create a new child and to analize the
> child's /proc/[pid]/ns/pid link, that is performance-stupid).
>
> The patch exposes pid_ns_for_children to ns directory
> in standard way with the name "pid_for_children":
>
> ~# ls /proc/5531/ns -l | grep pid
> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]
>
> Signed-off-by: Kirill Tkhai <ktkhai-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

What's happening if a process, after unsharing CLONE_NEWPID, does not
fork but instead let another process open the new "pid_for_children"
and then setns()+fork()? Is that other process allowed to create the
"pid 1" in the new pid namespaces? Is that also allowed if the other
process lives in a sibling pid namespace? If so, that would break what
pid_namespaces(7) says:

    "the parental relationship between processes mirrors the parental
     relationship between PID namespaces: the parent of a process is
     either in the same namespace or resides in the immediate parent
     PID namespace."
