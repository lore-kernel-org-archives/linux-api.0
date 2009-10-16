From: Daniel Lezcano <daniel.lezcano@free.fr>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Date: Fri, 16 Oct 2009 21:22:12 +0200
Message-ID: <4AD8C7E4.9000903@free.fr>
References: <20091013044925.GA28181@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755195AbZJPTWU@vger.kernel.org>
In-Reply-To: <20091013044925.GA28181@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de, Containers <containers@lists.linux-foundation.org>, Nathan Lynch <nathanl@austin.ibm.com>, Louis.Rilling@kerlabs.com, "Eric W. Biederman" <ebiederm@xmission.com>, kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu, linux-api@vger.kernel.org, torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

Sukadev Bhattiprolu wrote:
> Subject: [RFC][v8][PATCH 0/10] Implement clone3() system call
>
> To support application checkpoint/restart, a task must have the same pid it
> had when it was checkpointed.  When containers are nested, the tasks within
> the containers exist in multiple pid namespaces and hence have multiple pids
> to specify during restart.
>
> This patchset implements a new system call, clone3() that lets a process
> specify the pids of the child process.
>
> Patches 1 through 7 are helper patches, needed for choosing a pid for the
> child process.
>
> PATCH 9 defines a prototype of the new system call. PATCH 10 adds some
> documentation on the new system call, some/all of which will eventually
> go into a man page.
>   

Sorry for jumping so late in the discussion and for having maybe my
remarks pointless...

If this syscall is only for checkpoint / restart, why this shouldn't be
used with a future generic sys_restart syscall ?
Otherwise, shouldn't be more convenient to have something usable for
everyone, let's say:

cloneat(pid_t pid, pid_t desiredpid, ...);

Where 'desiredpid' is a hint of for the kernel for the pid to be
allocated (zero means the kernel will choose one for us) and the newly
allocated task is the son of 'pid'.
That looks more consistent with the "<syscall>at" family, 'openat',
'faccessat', 'readlinkat', etc ... and usable for something else than
the checkpoint / restart.

Thanks
  -- Daniel
