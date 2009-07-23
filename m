From: Oren Laadan <orenl@librato.com>
Subject: Re: [RFC v17][PATCH 22/60] c/r: external checkpoint of a task	other
 than ourself
Date: Thu, 23 Jul 2009 00:32:23 -0400
Message-ID: <4A67E7D7.9060800@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-23-git-send-email-orenl@librato.com> <20090722175223.GA19389@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20090722175223.GA19389@us.ibm.com>
Sender: owner-linux-mm@kvack.org
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Pavel Emelyanov <xemul@openvz.org>, Alexey Dobriyan <adobriyan@gmail.com>, Oren Laadan <orenl@cs.columbia.edu>
List-Id: linux-api@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@librato.com):
>> Now we can do "external" checkpoint, i.e. act on another task.
> 
> ...
> 
>>  long do_checkpoint(struct ckpt_ctx *ctx, pid_t pid)
>>  {
>>  	long ret;
>>
>> +	ret = init_checkpoint_ctx(ctx, pid);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (ctx->root_freezer) {
>> +		ret = cgroup_freezer_begin_checkpoint(ctx->root_freezer);
>> +		if (ret < 0)
>> +			return ret;
>> +	}
> 
> Self-checkpoint of a task in root freezer is now denied, though.
> 
> Was that intentional?

Yes.

"root freezer" is an arbitrary task in the checkpoint subtree or
container. It is used to verify that all checkpointed tasks - except
for current, if doing self-checkpoint - belong to the same freezer
group.

Since current is busy calling checkpoint(2), and since we only permit
checkpoint of (cgroup-) frozen tasks, then - by definition - it cannot
possibly belong to the same group. If it did, it would itself be frozen
like its fellows and unable to call checkpoint(2).

Oren.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
