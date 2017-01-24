From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH 2/2] pidns: Expose task pid_ns_for_children to userspace
Date: Tue, 24 Jan 2017 11:35:08 +0300
Message-ID: <ddf258b1-56f0-26e5-89ab-cc90cd273ce0@virtuozzo.com>
References: <148440326011.30622.12833059348082223242.stgit@localhost.localdomain>
 <148440329770.30622.16593902895676160550.stgit@localhost.localdomain>
 <CAMXgnP7gs_SXTj3yLFSM9DVfmN09m7q0hYQN-9oa3aV4eYgw5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMXgnP7gs_SXTj3yLFSM9DVfmN09m7q0hYQN-9oa3aV4eYgw5w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alban Crequy <alban.crequy@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 24.01.2017 00:49, Alban Crequy wrote:
> On 14 January 2017 at 15:15, Kirill Tkhai <ktkhai@virtuozzo.com> wrote:
>> For correct checkpointing/restoring of a task from userspace
>> it's need to know the task's pid_ns_for_children. Currently,
>> there is no a sane way to do that (the only possible trick
>> is to force the task create a new child and to analize the
>> child's /proc/[pid]/ns/pid link, that is performance-stupid).
>>
>> The patch exposes pid_ns_for_children to ns directory
>> in standard way with the name "pid_for_children":
>>
>> ~# ls /proc/5531/ns -l | grep pid
>> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid -> pid:[4026531836]
>> lrwxrwxrwx 1 root root 0 Jan 14 16:38 pid_for_children -> pid:[4026532286]
>>
>> Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
> 
> What's happening if a process, after unsharing CLONE_NEWPID, does not
> fork but instead let another process open the new "pid_for_children"
> and then setns()+fork()? Is that other process allowed to create the
> "pid 1" in the new pid namespaces? Is that also allowed if the other
> process lives in a sibling pid namespace? If so, that would break what
> pid_namespaces(7) says:
> 
>     "the parental relationship between processes mirrors the parental
>      relationship between PID namespaces: the parent of a process is
>      either in the same namespace or resides in the immediate parent
>      PID namespace."
> 

You can setns() on a pid_ns only if your active pid_ns is a (grand)parent
for the target pid_ns. So, the situation you described is not possible.
See pidns_install() for the details.
