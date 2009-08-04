From: Oren Laadan <orenl@librato.com>
Subject: Re: [RFC v17][PATCH 16/60] pids 6/7: Define do_fork_with_pids()
Date: Tue, 04 Aug 2009 04:37:58 -0400
Message-ID: <4A77F366.9020104@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-17-git-send-email-orenl@librato.com> <20090803182640.GB7493@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090803182640.GB7493@us.ibm.com>
Sender: owner-linux-mm@kvack.org
To: "Serge E. Hallyn" <serue@us.ibm.com>, Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@openvz.org>, Alexey Dobriyan <adobriyan@gmail.com>
List-Id: linux-api@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@librato.com):
>> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ...
>> +struct target_pid_set {
>> +	int num_pids;
>> +	pid_t *target_pids;
>> +};
> 
> Oren, I thought you had decided to add an extended flags field
> here, to support additional CLONE_ flags - such as CLONE_TIMENS?

Yes.

> 
> I mention it now because if you're still considering that
> long-term, then IMO the syscall should not be called clone_with_pids(),
> but clone_extended().  Otherwise, to support new clone flags we'll
> either have to use unshare2 (without clone support), or add yet
> another clone variant, OR use clone_with_pids() which is a poor name
> for something which will likely be used in cases without specifying
> pids, but specifying flags not support through any other interface.

True.

Also, Suka - any objections to rename 'struct target_pid_set' to
simply 'struct pid_set' ?
Actually, it could probably be (re)used internally in the patch that
adds to cgroup a 'procs' file similar to 'tasks'
(https://lists.linux-foundation.org/pipermail/containers/2009-July/019679.html)

Oren.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
